// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

error BalanceError();
error NotOwner();
error FailedTransaction();

contract FundMe {
    address public immutable i_owner;
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 1;
    address[] public funders;
    mapping(address => uint256) public addressToMoney;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        if (msg.value.getConversionRate() < MINIMUM_USD) {
            revert BalanceError();
        }
        funders.push(msg.sender);
        addressToMoney[msg.sender] = msg.value;
    }

    function withdraw() public onlyOwner {
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
        // payable(msg.sender).transfer(address(this).balance);

        // send - if anything goes wrong the contract returns boolean
        // bool result = payable(msg.sender).send(address(this).balance);
        // require(result, "Send failed!");

        // call - it's way more advanced level of creating a transaction
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        if (!success) {
            revert FailedTransaction();
        }
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _; // This is like the next() function after the middleware
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    // Also check: https://solidity-by-example.org/sending-ether
}
