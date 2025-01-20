// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
//Foundry devops tool to get most rcent deployment
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {BlindAuction} from "../src/auction.sol";

contract Auction is Script {
    bytes32 abid =
        keccak256(abi.encodePacked(uint256(10 * 10 ** 10), false, "why"));

    function bidBlindAuction(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        BlindAuction(mostRecentlyDeployed).bid(abid);
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "BlindAuction",
            block.chainid
        );

        bidBlindAuction(mostRecentlyDeployed);
    }
}
