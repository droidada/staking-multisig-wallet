// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "hardhat/console.sol";

contract AkaraNFT is ERC20 {
    using Counters for Counters.Counter;
    Counters.Counter private tokenIds;
    address private owner;

    constructor(address _marketplace) ERC20("Usher", "UsherToken") {
        owner = _marketplace;
    }

}
