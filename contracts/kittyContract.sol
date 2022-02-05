pragma solidity >=0.5.10;

import "./IERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./IERC721Receiver.sol";

// START AT 11:00 mark
// https://academy.moralis.io/lessons/assignment-safetransfer-implementation

contract kittyContract is IERC721, Ownable {

    using SafeMath for uint256;

    // this value comes from the bytes4 value of each function
    // header and then an XOR is applied accross all of them
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;

    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    event Birth(
                address owner, 
                uint256 kittenId,
                uint256 mumId, 
                uint256 dadId, 
                uint256 genes
            );
    string public constant token = "KevinKitties";
    string public constant symbolOfToken = "KK";
    uint256 public constant CREATION_LIMIT_GEN0 = 10;
    bytes4 internal constant MAGIC_ERC721_RECEIVED = bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));

    mapping(address => uint256) ownershipTokenCount;
    mapping(uint256 => address) public kittyIndexToOwner;

    mapping(uint256 => address) public kittyIndexToApproved;

    //MyAddress => OperatorAddress => TRUE/FALSE
    // EX: _operatorApprovals[MyAddress][OperatorAddress] = false;
    mapping(address => mapping(address => bool)) private _operatorApprovals;


    struct Kitty {
        uint256 genes;
        uint64 birthTime;
        uint32 mumId;
        uint32 dadId;
        uint16 generation;
    }

    Kitty[] kitties;
    
    uint256 public gen0Counter;

    function supportsInterface(bytes4 _interfaceId) external view returns (bool) {
        return (_interfaceId == _INTERFACE_ID_ERC721 || _interfaceId == _INTERFACE_ID_ERC165);
    }

    function getKitty(uint256 _kittenId) public returns(
        uint256 genes, 
        uint256 birthTime,
        uint256 mumId,
        uint256 dadId,
        uint256 generation,
        address owner) {
            require(_kittenId < kitties.length, "Kitty not found");
            owner = ownerOf(_kittenId);
            return (kitties[_kittenId].genes, 
            uint256(kitties[_kittenId].birthTime),
            uint256(kitties[_kittenId].mumId),
            uint256(kitties[_kittenId].dadId),
            uint256(kitties[_kittenId].generation),
            owner
            );
        }

    function createKittyGen0(uint256 _genes) public onlyOwner returns (uint256){
        require(gen0Counter < CREATION_LIMIT_GEN0);

        gen0Counter = gen0Counter.add(1);

        return _createKitty(0, 0, 0, _genes, msg.sender);
    }

    function _createKitty(
        uint256 _mumId, 
        uint256 _dadId, 
        uint256 _generation,
        uint256 _genes, 
        address _owner) private returns (uint256) {
            Kitty memory _kitty = Kitty({
                genes: _genes,
                birthTime: uint64(block.timestamp),
                mumId: uint32(_mumId),
                dadId: uint32(_dadId),
                generation: uint16(_generation)
            });
            kitties.push(_kitty);
            uint newKittenId = kitties.length - 1;
            _transfer(address(0), _owner, newKittenId);

            emit Birth(_owner, newKittenId, _mumId, _dadId, _genes);

            return newKittenId;
        }


    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external override view returns (uint256 balance){
        return ownershipTokenCount[owner];
    }

    /*
     * @dev Returns the total number of tokens in circulation.
     */
    function totalSupply() public override view returns (uint256 total){
        return kitties.length;
    }

    /*
     * @dev Returns the name of the token.
     */
    function name() external override view returns (string memory tokenName){
        return token;
    }

    /*
     * @dev Returns the symbol of the token.
     */
    function symbol() external override view returns (string memory tokenSymbol){
        return symbolOfToken;
    }

     /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) public override view returns (address owner){
        require(kittyIndexToOwner[tokenId] != address(0), "Token Does Not Exist");
        return kittyIndexToOwner[tokenId];
    }

         /* @dev Transfers `tokenId` token from `msg.sender` to `to`.
     *
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `to` can not be the contract address.
     * - `tokenId` token must be owned by `msg.sender`.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 tokenId) external override {
        require(to != address(0), "Receiver can't be Zero Address");
        require(to != address(this), "Receiver can't be the Contract Address");
        require(_owns(msg.sender,tokenId), "You are not the owner of this token");
        
        _transfer(msg.sender, to, tokenId);
    }
    
    // We separate out because when we mint a cat, it must come from address(0)
    function _transfer(address _from, address _to, uint256 _tokenId) internal {
        kittyIndexToOwner[_tokenId] = _to;
        ownershipTokenCount[_to] = ownershipTokenCount[_to].add(1);
        if(_from != address(0)) {
            ownershipTokenCount[_from] = ownershipTokenCount[_from].sub(1);
            delete kittyIndexToApproved[_tokenId];
        }
        emit Transfer(_from, _to, _tokenId);
    }

    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool result) {
        return kittyIndexToOwner[_tokenId] == _claimant;
    }
    
    function isApprovedForAll(address _owner, address _operator) override public view returns (bool) {
        return _operatorApprovals[_owner][_operator];
    }

    function approve(address _approved, uint256 _tokenId) override external{
        require(_owns(msg.sender, _tokenId) || _operatorApprovals[msg.sender][_approved]);
        kittyIndexToApproved[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) override external {
        require(_operator != msg.sender);
        
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) override public view returns (address) {
        require(_tokenId < totalSupply());
        return kittyIndexToApproved[_tokenId];
    }


    function transferFrom(address _from, address _to, uint256 _tokenId) override external {
        require(msg.sender == _from || isApprovedForAll(_from, msg.sender) ||  approvedFor(msg.sender,_tokenId));
        require(_owns(_from, _tokenId));
        require(_to != address(0));
        require(_tokenId < totalSupply());
        _transfer(_from, _to, _tokenId);
    }

    function _safeTransfer(address _from, address _to, uint256 _tokenId, bytes memory _data) internal{
        _transfer(_from, _to, _tokenId);
        require(_checkERC721Support(_from, _to, _tokenId, _data));
    }


    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) override external {
        require(_owns(msg.sender, _tokenId)|| approvedFor(msg.sender,_tokenId)|| isApprovedForAll(_from,msg.sender));
        require(_from == kittyIndexToOwner[_tokenId]);
        require(_to != address(0));
        require(_tokenId < kitties.length);

        _safeTransfer(_from, _to, _tokenId, data);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) override external {
        require(_owns(msg.sender, _tokenId)|| approvedFor(msg.sender,_tokenId)|| isApprovedForAll(_from,msg.sender));
        require(_from == kittyIndexToOwner[_tokenId]);
        require(_to != address(0));
        require(_tokenId < kitties.length);

        _safeTransfer(_from, _to, _tokenId, "");
    }

    function approvedFor(address _claimant, uint256 _tokenId) internal view returns (bool) {
        return kittyIndexToApproved[_tokenId] == _claimant;
    }

    function _checkERC721Support(address _from, address _to, uint256 _tokenId, bytes memory _data) internal returns (bool) {
        if( !_isContract(_to) ){ //if it isn't a contract, we're sending to a wallet, and no further checks required
            return true;
        }
        
        //have to call the _to contract, call onERC721Received
        bytes4 returnData = IERC721Receiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);

        //check return value is equal to bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
        return returnData == MAGIC_ERC721_RECEIVED;
    }

    function _isContract(address _to) view internal returns (bool) {
        // checking if code size is greater than 0
        // wallets have a code size of 0

        uint32 size;
        assembly{
            size := extcodesize(_to)
        }
        return size > 0;

    }

}