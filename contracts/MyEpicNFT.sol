// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.17;

// We first import some OpenZeppelin Contracts.
// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' width='720' height='720' viewBox='0 0 540 540'><path d='M0 270v270h540V0H0v270zm271.1-121c.5 0 .9.5.9 1.1 0 .5-.4.7-1 .4-.5-.3-1-.1-1 .5 0 .7.7 1 1.5.6 2-.7 7.8 5.4 12.2 12.9 5.1 8.9 14.6 24.5 30.5 49.8 2.6 4.3 4.5 8.3 4.2 8.9-.4.6-.2.8.4.5.6-.4 3.1 2.7 5.9 7.4 2.6 4.5 5.3 8.9 5.8 9.8 2.4 3.7 3.9 6.7 4.1 8.1.2.8.6 2.7 1 4.2.6 2.5 0 3.1-7.7 8.1-4.6 2.9-9.9 6.2-11.7 7.3-8.1 4.8-42.9 25.7-44.2 26.6-1.2.8-5.3-1.2-18.5-9.2-9.4-5.6-18.5-11.1-20.2-12.1-5.1-2.9-16.5-10.1-19.8-12.4-1.6-1.2-3.8-2.5-4.8-2.8-1-.4-1.5-1.1-1.2-1.7s-.1-.7-.9-.4c-2 .8-2 0 0-2.1.9-.9 1.4-1.9 1-2.2-.3-.3-1.4.5-2.5 1.8s-2 2-2.1 1.6c0-.7 2.9-5.7 4-6.7.3-.3.6-1 .7-1.5.1-1 13.5-23.7 18.2-31 2.7-4.2 21.5-35.4 27-44.8 2.5-4.3 5.3-8.9 6.1-10.2.8-1.2 2.6-4.1 3.9-6.4 1.4-2.3 3.1-4 3.9-3.9.8.2 1.7-.3 2-1.1s0-1.1-.7-.7c-.6.4-1.1.2-1.1-.4 0-.7.7-.9 1.6-.6s2 .6 2.5.6zm4.4 2.9c-.6.5-2.5-1-2.5-2 0-.5.6-.4 1.4.3s1.2 1.5 1.1 1.7zm-60 125.9c1.9 1.3 1.9 1.4-.5.7-1.4-.4-3.2-1.4-4-2.2-1.3-1.2-1.3-1.3.5-.7 1.1.4 2.9 1.4 4 2.2zm113.6-.5c-.6.8-.8 1.6-.5 1.9s-.2.5-1.2.4c-1.1 0-1.8.7-1.9 2.1s.4 2.3 1.2 2.3 1.2.4.9.9-1.4.7-2.4.5c-1.2-.3-2.2.6-3.5 3.2-.9 1.9-1.5 4-1.1 4.5.8 1.3-1.4 3.9-2.9 3.5-.7-.1-.9-.1-.4.1.4.3.7.8.7 1.2 0 .6-8.9 13.6-15.3 22.3-2.6 3.6-12.4 17.3-16.9 23.6-2.6 3.7-5.1 7.1-5.6 7.7-.4.5-2.2 3.1-4 5.7-1.8 2.7-3.6 4.8-3.9 4.8-.4 0-.2-.5.5-1.2s1.2-1.9 1.1-2.8c0-1-.2-1.1-.6-.2-.2.6-.9 1-1.4.6-.5-.3-.9 0-.9.7 0 .8-.7.6-1.9-.5-1.9-1.7-1.9-1.7-1.4.6.6 2.3.6 2.3-1.4.3-1-1.1-3.9-4.9-6.3-8.4-2.5-3.5-6.6-9.4-9.1-13-23.6-33.9-27.9-40.4-27.4-41.1.3-.5 0-1.2-.6-1.6-.8-.5-1-.2-.5.7.4.8-.2.3-1.3-1.1s-1.8-3.2-1.5-4.2c.3-.9 0-1.9-.6-2.3-.6-.3-.8-1.1-.5-1.6.4-.5-.4-.8-1.6-.6-1.2.1-2.4-.4-2.6-1.3-.4-1.2-.3-1.3.5-.1.8 1.1 1.1.9 1.7-.8.3-1.1 1.1-2.1 1.7-2.1.5 0 .7-.7.4-1.6-.4-1.1 1.3-.5 5.6 1.9 3.5 1.9 10.1 5.4 14.8 7.8 4.7 2.3 10.1 5.3 12 6.4 6.5 4 20.9 11.5 22.1 11.5.6 0 4.5-2 8.6-4.5 4-2.5 7.5-4.5 7.7-4.5s3.5-1.9 7.2-4.2c3.8-2.3 11.3-6.5 16.7-9.4 9.1-4.9 9.7-5.1 8.1-2.6l-1.8 2.7 2.5-1.7c1.3-.9 2.3-2.2 2.2-3-.2-.7 1-2.1 2.5-3 3.3-2.1 3.8-2.2 2.3-.5zm-114.3 3c.6.5 1.2 1.5 1.2 2.1s-.5.3-1.1-.7c-.5-.9-1.5-1.7-2.1-1.7-.7 0-.6.5.2 1.5.7.8.8 1.5.3 1.5s-1.5-1.1-2.1-2.5c-1-2.1-.9-2.3.6-1.8.9.3 2.3 1 3 1.6zm109.2 9.6c-1.1 2.1-3 3.7-3 2.5 0-.8 3-4.4 3.7-4.4.2 0-.1.9-.7 1.9zm-105 .1c0 .5-.2 1-.4 1-.3 0-.8-.5-1.1-1-.3-.6-.1-1 .4-1 .6 0 1.1.4 1.1 1z'/><path d='M271.6 355.7c-.6 1.4-.5 1.5.5.6.7-.7 1-1.5.7-1.8s-.9.2-1.2 1.2z'/><text x='50%' y='10%' dominant-baseline='middle' text-anchor='middle' style='fill:#fff;font-family:serif;font-size:30px'>Identity NFT</text><text x='15%' y='92%' dominant-baseline='middle' text-anchor='middle' style='fill:#fff;font-family:serif;font-size:15px'>Polygon Mumbai Testnet</text><text x='5%' y='86%' dominant-baseline='middle' text-anchor='middle' style='fill:#fff;font-family:serif;font-size:40px'>";

 
  string[] firstWords = ["#1", "#2", "#3", "#4", "#5", "#6", "#7", "#8", "#9", "#10"];
  event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("IdentityNFT", "SQUARE") {
    console.log("This is my NFT contract. Woah!");
  }

  // I create a function to randomly pick a word from each array.
  function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
    // I seed the random generator. More on this in the lesson. 
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    // Squash the # between 0 and the length of the array to avoid going out of bounds.
    rand = rand % firstWords.length;
    return firstWords[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomFirstWord(newItemId);
    string memory combinedWord = string(abi.encodePacked(first));

    // I concatenate it all together, and then close the <text> and <svg> tags.
    string memory finalSvg = string(abi.encodePacked(baseSvg, first, "</text></svg>"));
     // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    combinedWord,
                    '", "description": "A highly acclaimed collection of your Identities secured and Safe IdentityNFTs", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    string memory finalTokenUri = string (
      abi.encodePacked("data:application/json;base64,",json)
    );
    console.log("\n--------------------");
    console.log(finalSvg);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);
  
    // We'll be setting the tokenURI later!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}