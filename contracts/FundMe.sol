// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

// Get Funds from users
// Withdraw funds
// Set a minimum funding value in USD

contract FundMe {
    uint256 etherToWei = 1e18;
    uint256 etherToGWei = 1e9;

    function fund() public payable {
        require(msg.value > etherToWei, "Not enough funds!");
    }

    function withdraw() internal {}
}
