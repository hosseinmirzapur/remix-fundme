// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minUSD = 1;

    AggregatorV3Interface internal priceFeed;

    address[] public funders;

    mapping(address => uint256) public addressToMoney;

    constructor(address _priceFeed) {
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function fund() public payable {
        require(getConversionRate(msg.value) >= minUSD, "Not enough funds!");
        funders.push(msg.sender);
        addressToMoney[msg.sender] = msg.value;
    }

    function getPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(
        uint256 ethAmount
    ) public view returns (uint256) {
        return ((getPrice() * ethAmount) / 1e18);
    }
}
