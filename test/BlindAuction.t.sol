// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "../lib/forge-std/src/Test.sol";
import {BlindAuction} from "../src/auction.sol";

contract AuctionTest is Test {
    BlindAuction blindauction;

    function setUp() external {
        blindauction = new BlindAuction(20, 20, payable(msg.sender));
    }

    function testbeneficiary() public view {
        assertEq(blindauction.beneficiary(), msg.sender);
    }
}
