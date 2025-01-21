// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";

import {BlindAuction} from "../../src/auction.sol";

import {DeployBlindAuction} from "../../script/Blindauction.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {Auction} from "../../script/Interactions.s.sol";


contract BlindAuctionIntegarationTest is Test, HelperConfig {

    BlindAuction blindauction;
    bytes32 abid;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployBlindAuction deployblindauction = new DeployBlindAuction();
        blindauction = deployblindauction.run();
        vm.deal(USER, STARTING_BALANCE);

    }

    function testusercanbid() public{
       Auction auction = new Auction();
        auction.BidBlindAuction(address(blindauction));
         abid = keccak256(
            abi.encodePacked(uint256(10 * 10 ** 18), false, "there")
        );

        blindauction.bid(abid);
        Bid[] memory bid = blindauction.getBids(address(this));
        assertEq(abid, bid[0].blindedBid);

    }
}
