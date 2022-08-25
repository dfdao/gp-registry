// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.10;

import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();
error InvalidURI();

contract NFT is ERC721, Ownable {
    using Strings for uint256;
    string public baseURI;
    uint256 public currentTokenId;
    mapping(uint256 => string) tokenURIs;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _baseURI
    ) ERC721(_name, _symbol) {
        baseURI = _baseURI;
    }

    function mintTo(address recipient, string memory _tokenURI)
        public
        payable
        onlyOwner
        returns (uint256)
    {
        if (bytes(baseURI).length == 0) revert InvalidURI();

        uint256 newTokenId = ++currentTokenId;
        tokenURIs[newTokenId] = _tokenURI;
        _safeMint(recipient, newTokenId);
        return newTokenId;
    }

    function bulkMintTo(address[] memory recipients, string memory _tokenURI)
        public
        payable
        onlyOwner
        returns (uint256[] memory)
    {
        uint256[] memory tokenIds = new uint[](recipients.length);

        if (bytes(baseURI).length == 0) revert InvalidURI();
        for(uint256 i; i < recipients.length; i++) {
            uint256 newTokenId = ++currentTokenId;
            tokenURIs[newTokenId] = _tokenURI;
            _safeMint(recipients[i], newTokenId);
            tokenIds[i] = newTokenId;
        }

        return tokenIds;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        if (ownerOf(tokenId) == address(0)) {
            revert NonExistentTokenURI();
        }
        return bytes(baseURI).length > 0 ? tokenURIs[tokenId] : "";
    }

    function withdrawPayments(address payable payee) external onlyOwner {
        uint256 balance = address(this).balance;
        (bool transferTx, ) = payee.call{value: balance}("");
        if (!transferTx) {
            revert WithdrawTransfer();
        }
    }
}
