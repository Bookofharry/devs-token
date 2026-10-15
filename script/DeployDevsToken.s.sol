// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console2} from "forge-std/Script.sol";
import {DevsToken} from "../src/DevsToken.sol";

contract DeployDevsToken is Script {
    function run() external returns (DevsToken token) {
        require(block.chainid == 11155111 || block.chainid == 31337, "Use Sepolia or a local chain");
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        token = new DevsToken("DEVS TOKEN", "DEVS", 1_000_000);
        vm.stopBroadcast();
        console2.log("DEVS TOKEN deployed at:", address(token));
        console2.log("Owner:", token.owner());
        console2.log("Total supply (base units):", token.totalSupply());
    }
}
