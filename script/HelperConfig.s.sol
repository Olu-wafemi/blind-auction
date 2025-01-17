// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "../lib/forge-std/src/Script.sol";

// /To delpoy mocks of the contract while on the local anvil network,
//A contract was created to avoid hardcdoing things in the run script, in this case we're trying to get teh address of the spolia/anvil local netwrok
contract HelperConfig {
    NetworkConfig public activeNetworkconfig;

    struct NetworkConfig {
        address priceFeed;
    }

    struct Bid {
        bytes32 blindedBid;
        uint deposit;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkconfig = getSepoliaEthConfig();
        }
        activeNetworkconfig = getAnvilEthConfig();
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0xfEefF7c3fB57d18C5C6Cdd71e45D2D0b4F9377bF
        });

        return sepoliaConfig;
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {}
}
