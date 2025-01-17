// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "../lib/forge-std/src/Test.sol";
import {console} from "../lib/forge-std/src/console.sol";

import "forge-std/Test.sol";
import {BlindAuction} from "../src/auction.sol";

import {DeployBlindAuction} from "../script/Blindauction.s.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract AuctionTest is Test, HelperConfig {
    BlindAuction blindauction;
    bytes32 abid;

    function setUp() external {
        blindauction = new BlindAuction(20, 50, payable(msg.sender));
        //blindauction = deployblindauction.run();
    }

    function testbeneficiary() public view {
        assertEq(blindauction.beneficiary(), msg.sender);
    }

    function testbidwenthrough() public {
        abid = keccak256(
            abi.encodePacked(uint256(10 * 10 ** 18), false, "there")
        );

        //  console.log(abid);]
        //emit log_bytes32(abid);
        blindauction.bid(abid);
        Bid[] memory bid = blindauction.getBids(address(this));
        assertEq(abid, bid[0].blindedBid);
    }

    function testreveal() public {
        blindauction.reveal(
            [uint256(10 * 10 ** 18)],
            [false],
            [bytes32("there")]
        );
        address thehighestbidder = blindauction.gethighestbidder();
        assertEq(thehighestbidder, msg.sender);
    }
}
