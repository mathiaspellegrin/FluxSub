// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../FluxSub.sol";

/**
 * Minimal unit tests for FluxSub core flows: subscribe, charge, cancel/refund.
 * Run from smart-contracts: forge install forge-std && forge install OpenZeppelin/openzeppelin-contracts && forge test
 */
contract FluxSubTest is Test {
    FluxSub public fluxSub;

    address public owner;
    address public merchant;
    address public user;

    uint256 public constant PERIOD = 7 days;
    uint256 public constant AMOUNT = 1 ether;
    uint256 public constant INITIAL_FUNDING = 3 ether;

    function setUp() public {
        owner = address(this);
        merchant = makeAddr("merchant");
        user = makeAddr("user");
        fluxSub = new FluxSub();
        vm.deal(user, 10 ether);
    }

    function test_subscribe_createsUserSubscriptionAndTransfersToMerchant() public {
        vm.startPrank(merchant);
        uint256 subId = fluxSub.createSubscriptionService(
            "Pro",
            "Pro plan",
            AMOUNT,
            PERIOD
        );
        vm.stopPrank();

        vm.prank(user);
        fluxSub.subscribe{value: INITIAL_FUNDING}(subId, INITIAL_FUNDING);

        (uint256 subscriptionId, address subUser, , uint256 amount, uint256 period, uint256 nextCharge, uint256 balance, bool active,,,) =
            fluxSub.userSubscriptions(1); // (subscriptionId, user, merchant, amount, period, nextCharge, balance, active, paused, subscribedAt, lastCharged)

        assertEq(subscriptionId, subId);
        assertEq(subUser, user);
        assertEq(amount, AMOUNT);
        assertEq(period, PERIOD);
        assertEq(balance, INITIAL_FUNDING);
        assertTrue(active);
        assertEq(nextCharge, block.timestamp + PERIOD);
        assertEq(merchant.balance, INITIAL_FUNDING);
    }

    function test_chargeSubscription_debitsBalanceAndPaysMerchant() public {
        vm.startPrank(merchant);
        uint256 subId = fluxSub.createSubscriptionService("Pro", "Pro", AMOUNT, PERIOD);
        vm.stopPrank();

        vm.prank(user);
        fluxSub.subscribe{value: INITIAL_FUNDING}(subId, INITIAL_FUNDING);

        vm.warp(block.timestamp + PERIOD);

        uint256 merchantBefore = merchant.balance;
        vm.prank(merchant);
        fluxSub.chargeSubscription(1);

        (, , , , , , uint256 balanceAfter,,,) = fluxSub.userSubscriptions(1); // 7th = balance
        assertEq(balanceAfter, INITIAL_FUNDING - AMOUNT);
        assertEq(merchant.balance, merchantBefore + AMOUNT);
    }

    function test_cancelSubscription_refundsRemainingBalance() public {
        vm.startPrank(merchant);
        uint256 subId = fluxSub.createSubscriptionService("Pro", "Pro", AMOUNT, PERIOD);
        vm.stopPrank();

        vm.prank(user);
        fluxSub.subscribe{value: INITIAL_FUNDING}(subId, INITIAL_FUNDING);

        uint256 userBefore = user.balance;
        vm.prank(user);
        fluxSub.cancelSubscription(1);

        (, , , , , , uint256 balanceAfter, bool active,,,) = fluxSub.userSubscriptions(1); // balance, active
        assertFalse(active);
        assertEq(balanceAfter, 0);
        assertEq(user.balance, userBefore + INITIAL_FUNDING);
    }
}
