// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155URIStorage.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/metatx/ERC2771Context.sol";

// $$$$$$$\  $$\       $$$$$$\   $$$$$$\  $$\   $$\       $$$$$$$\   $$$$$$\   $$$$$$\  $$$$$$$$\ $$$$$$$\   $$$$$$\  
// $$  __$$\ $$ |     $$  __$$\ $$  __$$\ $$ | $$  |      $$  __$$\ $$  __$$\ $$  __$$\ $$  _____|$$  __$$\ $$  __$$\ 
// $$ |  $$ |$$ |     $$ /  $$ |$$ /  \__|$$ |$$  /       $$ |  $$ |$$ /  $$ |$$ /  \__|$$ |      $$ |  $$ |$$ /  \__|
// $$$$$$$\ |$$ |     $$ |  $$ |$$ |      $$$$$  /        $$$$$$$  |$$$$$$$$ |$$ |      $$$$$\    $$$$$$$  |\$$$$$$\  
// $$  __$$\ $$ |     $$ |  $$ |$$ |      $$  $$<         $$  __$$< $$  __$$ |$$ |      $$  __|   $$  __$$<  \____$$\ 
// $$ |  $$ |$$ |     $$ |  $$ |$$ |  $$\ $$ |\$$\        $$ |  $$ |$$ |  $$ |$$ |  $$\ $$ |      $$ |  $$ |$$\   $$ |
// $$$$$$$  |$$$$$$$$\ $$$$$$  |\$$$$$$  |$$ | \$$\       $$ |  $$ |$$ |  $$ |\$$$$$$  |$$$$$$$$\ $$ |  $$ |\$$$$$$  |
// \_______/ \________|\______/  \______/ \__|  \__|      \__|  \__|\__|  \__| \______/ \________|\__|  \__| \______/ 

/// @title Block Racers ERC1155 contract
/// @author RyRy79261
/// @notice This contract facilitates NFT asset management in Block Racers at https://github.com/Chainsafe/BlockRacers
contract BlockRacersAssets is ERC2771Context, ERC1155, ERC1155URIStorage, AccessControl, ReentrancyGuard {
    bytes32 public constant BLOCK_RACERS = keccak256("BLOCK_RACERS");
    
    error NotAuthorizedGameContract();

    modifier onlyBlockracers {
        if(!hasRole(BLOCK_RACERS, _msgSender()))
            revert NotAuthorizedGameContract();
        
        _;
    }

    /// @dev Constructor sets token to be used and nft info, input the RACE token address here on deployment
    /// @param trustedForwarder ERC2771 relayer address
    /// @param baseUri_ URI base string
    /// @param _admin Admin address for managing approved minters
    constructor(
        address trustedForwarder,
        string memory baseUri_, 
        address _admin
    ) ERC2771Context(trustedForwarder) ERC1155(baseUri_) {
        _grantRole(DEFAULT_ADMIN_ROLE, _admin);
        // Default is 0x00 so the default init value of Admin role would be 0x00 so this might be redundant
        _setRoleAdmin(BLOCK_RACERS, DEFAULT_ADMIN_ROLE); 
    }

    /// @dev Minting functions
    /// @notice Mints an Nft to a users wallet
    /// @param to The receiving account
    /// @param id The ID of the token
    /// @param value The amount of token being sent
    /// @return true if successful
    function mint(address to, uint256 id, uint256 value) external onlyBlockracers() returns(bool) {
       _mint(to, id, value, new bytes(0));
       return true;
    }

    /// @dev Minting functions
    /// @notice Mints an Nft to a users wallet
    /// @param to The receiving account
    /// @param id The ID of the token
    /// @param value The amount of token being sent
    /// @return true if successful
    function mint(address to, uint256 id, uint256 value, string memory newUri) external onlyBlockracers() returns(bool) {
       _mint(to, id, value, new bytes(0));
       ERC1155URIStorage._setURI(id, newUri);
       return true;
    }

    /// Batch minting function
    /// @param to receiver account
    /// @param ids ID list
    /// @param values Quantity list
    /// @param data abitrary data 
    function mintBatch(address to, uint256[] memory ids, uint256[] memory values, bytes memory data) external onlyBlockracers() returns(bool) {
        _mintBatch(to, ids, values, data);
        return true;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC1155, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function uri(uint256 tokenId) public view override(ERC1155URIStorage, ERC1155) returns (string memory) {
        return ERC1155URIStorage.uri(tokenId);
    }

    /**
     * @dev Override required as inheritance was indeterminant for which function to use
     */
    function _msgSender() internal view override(ERC2771Context, Context) returns (address sender) {
        return ERC2771Context._msgSender();
    }

    /**
     * @dev Override required as inheritance was indeterminant for which function to use
     */
    function _msgData() internal view override(ERC2771Context, Context) returns (bytes calldata) {
        return ERC2771Context._msgData();
    }
}