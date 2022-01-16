pragma solidity >=0.5.10;

import "./IERC721.sol";

abstract contract kittyContract is IERC721 {

    mapping(address => uint256) ownershipTokenCount;
    uint256 public totalTokenSupply;
    
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
        return totalTokenSupply;
    }

    /*
     * @dev Returns the name of the token.
     */
    function name() external override view returns (string memory tokenName){
        
    }
}