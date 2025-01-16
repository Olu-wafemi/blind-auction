//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";
import {BlindAuction} from "../src/auction.sol";

contract DeployBlindAuction is Script {
    function run() external {
        vm.startBroadcast();
        BlindAuction blindauction = new BlindAuction(
            20,
            50,
            payable(address(this))
        );
        vm.stopBroadcast();
        return blindauction;
    }
}
