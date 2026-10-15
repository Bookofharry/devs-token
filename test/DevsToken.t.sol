// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {DevsToken} from "../src/DevsToken.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

contract DevsTokenTest is Test {
    DevsToken token;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    uint256 constant SUPPLY = 1_000_000 ether;

    function setUp() public {
        token = new DevsToken("DEVS TOKEN", "DEVS", 1_000_000);
    }

    function testInitialSupplyAndMetadata() public view {
        assertEq(token.name(), "DEVS TOKEN");
        assertEq(token.symbol(), "DEVS");
        assertEq(token.decimals(), 18);
        assertEq(token.owner(), address(this));
        assertEq(token.totalSupply(), SUPPLY);
        assertEq(token.balanceOf(address(this)), SUPPLY);
        assertFalse(token.paused());
    }

    function testTransferBetweenAccounts() public {
        assertTrue(token.transfer(alice, 100 ether));
        assertEq(token.balanceOf(alice), 100 ether);
        assertEq(token.balanceOf(address(this)), SUPPLY - 100 ether);
        assertEq(token.totalSupply(), SUPPLY);
    }

    function testOwnerCanMint() public {
        token.mint(alice, 500 ether);
        assertEq(token.balanceOf(alice), 500 ether);
        assertEq(token.totalSupply(), SUPPLY + 500 ether);
    }

    function testNonOwnerCannotMint() public {
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, alice));
        token.mint(alice, 500 ether);
    }

    function testPauseBlocksTransfer() public {
        token.pause();
        vm.expectRevert(Pausable.EnforcedPause.selector);
        token.transfer(alice, 100 ether);
        assertEq(token.balanceOf(alice), 0);
    }

    function testUnpauseAllowsTransfer() public {
        token.pause();
        token.unpause();
        token.transfer(alice, 100 ether);
        assertEq(token.balanceOf(alice), 100 ether);
    }

    function testNonOwnerCannotPause() public {
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, alice));
        token.pause();
    }

    function testNonOwnerCannotUnpause() public {
        token.pause();
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, alice));
        token.unpause();
    }

    function testBurnReducesBalanceAndSupply() public {
        token.transfer(alice, 100 ether);
        vm.prank(alice);
        token.burn(40 ether);
        assertEq(token.balanceOf(alice), 60 ether);
        assertEq(token.totalSupply(), SUPPLY - 40 ether);
    }

    function testApproveAndTransferFrom() public {
        token.approve(alice, 100 ether);
        vm.prank(alice);
        token.transferFrom(address(this), bob, 40 ether);
        assertEq(token.balanceOf(bob), 40 ether);
        assertEq(token.balanceOf(address(this)), SUPPLY - 40 ether);
        assertEq(token.allowance(address(this), alice), 60 ether);
    }

    function testTransferFromRejectsInsufficientAllowance() public {
        token.approve(alice, 10 ether);
        vm.prank(alice);
        vm.expectRevert(
            abi.encodeWithSelector(IERC20Errors.ERC20InsufficientAllowance.selector, alice, 10 ether, 20 ether)
        );
        token.transferFrom(address(this), bob, 20 ether);
    }

    function testTransferRejectsInsufficientBalance() public {
        vm.prank(alice);
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InsufficientBalance.selector, alice, 0, 1 ether));
        token.transfer(bob, 1 ether);
    }

    function testTransferRejectsZeroAddress() public {
        vm.expectRevert(abi.encodeWithSelector(IERC20Errors.ERC20InvalidReceiver.selector, address(0)));
        token.transfer(address(0), 1 ether);
    }

    function testBurnFromUsesAllowance() public {
        token.approve(alice, 100 ether);
        vm.prank(alice);
        token.burnFrom(address(this), 40 ether);
        assertEq(token.totalSupply(), SUPPLY - 40 ether);
        assertEq(token.balanceOf(address(this)), SUPPLY - 40 ether);
        assertEq(token.allowance(address(this), alice), 60 ether);
    }

    function testPauseBlocksMintAndBurn() public {
        token.pause();
        vm.expectRevert(Pausable.EnforcedPause.selector);
        token.mint(alice, 1 ether);
        vm.expectRevert(Pausable.EnforcedPause.selector);
        token.burn(1 ether);
    }

    function testOwnershipTransferChangesMintPermission() public {
        token.transferOwnership(alice);
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, address(this)));
        token.mint(bob, 1 ether);
        vm.prank(alice);
        token.mint(bob, 1 ether);
        assertEq(token.balanceOf(bob), 1 ether);
    }

    function testFuzzTransferPreservesSupply(uint256 amount) public {
        amount = bound(amount, 0, SUPPLY);
        token.transfer(alice, amount);
        assertEq(token.balanceOf(alice), amount);
        assertEq(token.balanceOf(address(this)), SUPPLY - amount);
        assertEq(token.totalSupply(), SUPPLY);
    }
}
