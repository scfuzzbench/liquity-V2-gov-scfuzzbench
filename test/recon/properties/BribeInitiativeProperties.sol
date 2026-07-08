// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BeforeAfter} from "../BeforeAfter.sol";
import {IBribeInitiative} from "../../../src/interfaces/IBribeInitiative.sol";

abstract contract BribeInitiativeProperties is BeforeAfter {
    function _assertionBI01Lqty() internal pure virtual returns (string memory);
    function _assertionBI01Bold() internal pure virtual returns (string memory);
    function _assertionBI02() internal pure virtual returns (string memory);
    function _assertionBI03() internal pure virtual returns (string memory);
    function _assertionBI04() internal pure virtual returns (string memory);
    function _assertionBI05BribeDust() internal pure virtual returns (string memory);
    function _assertionBI05BoldDust() internal pure virtual returns (string memory);

    function invariant_BI01() public returns (bool) {
        uint16 currentEpoch = governance.epoch();
        for (uint8 i; i < deployedInitiatives.length; i++) {
            address initiative = deployedInitiatives[i];
            // if the bool switches, the user has claimed their bribe for the epoch
            if (
                _before.claimedBribeForInitiativeAtEpoch[initiative][user][currentEpoch]
                    != _after.claimedBribeForInitiativeAtEpoch[initiative][user][currentEpoch]
            ) {
                // calculate user balance delta of the bribe tokens
                uint128 lqtyBalanceDelta = _after.lqtyBalance - _before.lqtyBalance;
                uint128 lusdBalanceDelta = _after.lusdBalance - _before.lusdBalance;

                // calculate balance delta as a percentage of the total bribe for this epoch
                (uint128 bribeBoldAmount, uint128 bribeBribeTokenAmount) =
                    IBribeInitiative(initiative).bribeByEpoch(currentEpoch);
                uint128 lqtyPercentageOfBribe = (lqtyBalanceDelta / bribeBribeTokenAmount) * 10_000;
                uint128 lusdPercentageOfBribe = (lusdBalanceDelta / bribeBoldAmount) * 10_000;

                // Shift right by 40 bits (128 - 88) to get the 88 most significant bits
                uint88 lqtyPercentageOfBribe88 = uint88(lqtyPercentageOfBribe >> 40);
                uint88 lusdPercentageOfBribe88 = uint88(lusdPercentageOfBribe >> 40);

                // calculate user allocation percentage of total for this epoch
                uint88 lqtyAllocatedByUserAtEpoch =
                    IBribeInitiative(initiative).lqtyAllocatedByUserAtEpoch(user, currentEpoch);
                uint88 totalLQTYAllocatedAtEpoch = IBribeInitiative(initiative).totalLQTYAllocatedByEpoch(currentEpoch);
                uint88 allocationPercentageOfTotal = (lqtyAllocatedByUserAtEpoch / totalLQTYAllocatedAtEpoch) * 10_000;

                // check that allocation percentage and received bribe percentage match
                eq(
                    lqtyPercentageOfBribe88,
                    allocationPercentageOfTotal,
                    _assertionBI01Lqty()
                );
                eq(
                    lusdPercentageOfBribe88,
                    allocationPercentageOfTotal,
                    _assertionBI01Bold()
                );
            }
        }
        return true;
    }

    function invariant_BI02() public returns (bool) {
        t(!claimedTwice, _assertionBI02());
        return true;
    }

    function invariant_BI03() public returns (bool) {
        uint16 currentEpoch = governance.epoch();
        for (uint8 i; i < deployedInitiatives.length; i++) {
            IBribeInitiative initiative = IBribeInitiative(deployedInitiatives[i]);
            uint88 lqtyAllocatedByUserAtEpoch = initiative.lqtyAllocatedByUserAtEpoch(user, currentEpoch);
            eq(
                ghostLqtyAllocationByUserAtEpoch[user],
                lqtyAllocatedByUserAtEpoch,
                _assertionBI03()
            );
        }
        return true;
    }

    function invariant_BI04() public returns (bool) {
        uint16 currentEpoch = governance.epoch();
        for (uint8 i; i < deployedInitiatives.length; i++) {
            IBribeInitiative initiative = IBribeInitiative(deployedInitiatives[i]);
            uint88 totalLQTYAllocatedAtEpoch = initiative.totalLQTYAllocatedByEpoch(currentEpoch);
            eq(
                ghostTotalAllocationAtEpoch[currentEpoch],
                totalLQTYAllocatedAtEpoch,
                _assertionBI04()
            );
        }
        return true;
    }

    // TODO: double check that this implementation is correct
    function invariant_BI05() public returns (bool) {
        uint16 currentEpoch = governance.epoch();
        for (uint8 i; i < deployedInitiatives.length; i++) {
            address initiative = deployedInitiatives[i];
            // if the bool switches, the user has claimed their bribe for the epoch
            if (
                _before.claimedBribeForInitiativeAtEpoch[initiative][user][currentEpoch]
                    != _after.claimedBribeForInitiativeAtEpoch[initiative][user][currentEpoch]
            ) {
                // check that the remaining bribe amount left over is less than 100 million wei
                uint256 bribeTokenBalanceInitiative = lqty.balanceOf(initiative);
                uint256 boldTokenBalanceInitiative = lusd.balanceOf(initiative);

                lte(
                    bribeTokenBalanceInitiative,
                    1e8,
                    _assertionBI05BribeDust()
                );
                lte(
                    boldTokenBalanceInitiative,
                    1e8,
                    _assertionBI05BoldDust()
                );
            }
        }
        return true;
    }
}
