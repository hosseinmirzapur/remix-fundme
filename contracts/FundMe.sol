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
}
