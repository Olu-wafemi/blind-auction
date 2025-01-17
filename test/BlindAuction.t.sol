// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {BlindAuction} from "../src/auction.sol";

import {DeployBlindAuction} from "../script/Blindauction.s.sol";

contract AuctionTest is Test {
    BlindAuction blindauction;

    function setUp() external {
        blindauction = new BlindAuction(20, 50, payable(address(this)));
        //blindauction = deployblindauction.run();
    }

    function testbeneficiary() public view {
        assertEq(blindauction.beneficiary(), msg.sender);
    }
}
