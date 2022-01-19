pragma solidity >=0.5.10;

import "./IERC721.sol";
import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";


contract kittyContract is IERC721 {

    using SafeMath for uint256;

    string public constant token = "KevinKitties";
    string public constant symbolOfToken = "KK";
    mapping(address => uint256) ownershipTokenCount;
    mapping(uint256 => address) public kittyIndexToOwner;

    struct Kitty {
        uint256 genes;
        uint64 birthTime;
        uint32 mumId;
        uint32 dadId;
        uint16 generation;
    }

    Kitty[] kitties;
    
    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external override view returns (uint256 balance){
        return ownershipTokenCount[owner];
    }

    /*
     * @dev Returns the total number of tokens in circulation.
     */
    function totalSupply() external override view returns (uint256 total){
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
    function ownerOf(uint256 tokenId) external override view returns (address owner){
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
        }
        emit Transfer(_from, _to, _tokenId);
    }

    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool result) {
        return kittyIndexToOwner[_tokenId] == _claimant;
    }
}