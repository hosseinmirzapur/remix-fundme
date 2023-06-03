// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minUSD = 1;

    address[] public funders;

    mapping(address => uint256) public addressToMoney;

    function fund() public payable {
        require(msg.value.getConversionRate() >= minUSD, "Not enough funds!");
        funders.push(msg.sender);
        addressToMoney[msg.sender] = msg.value;
    }

    function withdraw() public {
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToMoney[funder] = 0;
        }

        // reset the arrasy of funders
        funders = new address[](0);

        // withdraw the funds
        /**
         * 1. Transfer
         * 2. Send
         * 3. Call
         */

        // transfer - if anything goes wrong, thr transaction is reverted
        payable(msg.sender).transfer(address(this).balance);

        // send - if anything goes wrong the contract returns boolean
        bool result = payable(msg.sender).send(address(this).balance);
        require(result, "Send failed!");

        // call - it's way more advanced level of creating a transaction
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success, "Call failed!");
    }
    // Also check: https://solidity-by-example.org/sending-ether
}
