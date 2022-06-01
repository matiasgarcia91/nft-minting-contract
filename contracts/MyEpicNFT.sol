// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    // Tool from OpenZeppelin to help us keep track of tokenIds.
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Terrible", "Hideous", "Witty", "Grand", "Astute", "Sneaky", "Graceful", "Scheming", "Warmongering", "Regal", "Sharp", "Tall", "Alcoholic", "Intimidating", "Brave"]; // 15
    string[] secondWords = ["King", "Baron", "Hobo", "Prince", "Lady", "Apprentice", "Ward", "Peasant", "Merchant", "Sailor", "Stablehand", "Goblin", "Eagle", "Knight", "Blacksmith", "Cleric", "Priest"]; // 17
    string[] thirdWords = ["Murderer", "Companion", "Pleaser", "Worshipper", "Adulterer", "Follower", "Stalker", "Friend", "Poisoner", "Enemy", "Ally", "Betrayer", "BackStabber", "Commander", "Leader"]; // 15

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("Hello from the NFT contract. Wooo!");
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
      // seed the random generator
      uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
      // Squash the # between 0 and the length of the array to avoid going out of bounds.
      rand = rand % firstWords.length;
      return firstWords[rand];
    }

     function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
      uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
      rand = rand % secondWords.length;
      return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
      uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
      rand = rand % thirdWords.length;
      return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
      // Get the current tokenId, starts at 0;
      uint256 newItemId = _tokenIds.current();

      string memory first = pickRandomFirstWord(newItemId);
      string memory second = pickRandomSecondWord(newItemId);
      string memory third = pickRandomThirdWord(newItemId);
      string memory combinedWord = string(abi.encodePacked(first, second, third));

      string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));


      string memory json = Base64.encode(
        bytes(
          string(abi.encodePacked(
            '{"name": "', combinedWord, '", "description": "A piece of the highly acclaimed square collection.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(finalSvg)), '"}'
          ))
        )
      );

      string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
      );

      console.log('finalTokenUri: ', finalTokenUri);

      // Actually mint the NFT to the sender msg.sender. Comes from OpenZeppelin
      _safeMint(msg.sender, newItemId);

      // Set the NFTs data
      _setTokenURI(newItemId, finalTokenUri);

      console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

      // Increment the counter for when the next NFT is minted.
      _tokenIds.increment();
    }



}