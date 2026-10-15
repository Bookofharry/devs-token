// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Script, console2} from "forge-std/Script.sol";
import {HarryToken} from "../src/HarryToken.sol";

contract DeployHarryToken is Script {
    function run() external returns (HarryToken token) {
        require(block.chainid == 11155111 || block.chainid == 31337, "Use Sepolia or a local chain");
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        token = new HarryToken("Harry Token", "HARRY", 1_000_000);
        vm.stopBroadcast();
        console2.log("Harry Token deployed at:", address(token));
        console2.log("Owner:", token.owner());
        console2.log("Total supply (base units):", token.totalSupply());
    }
}
