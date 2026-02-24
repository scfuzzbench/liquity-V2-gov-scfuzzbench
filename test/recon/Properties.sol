// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {GovernanceProperties} from "./properties/GovernanceProperties.sol";
import {BribeInitiativeProperties} from "./properties/BribeInitiativeProperties.sol";

abstract contract Properties is GovernanceProperties, BribeInitiativeProperties {
    string internal constant ASSERTION_CANARY = "!!! canary assertion";
    string internal constant ASSERTION_GV01 =
        "!!! GV-01: Initiative state should only return one state per epoch";
    string internal constant ASSERTION_BI01_LQTY =
        "!!! BI-01: User should receive percentage of bribes corresponding to their allocation";
    string internal constant ASSERTION_BI01_BOLD =
        "!!! BI-01: User should receive percentage of BOLD bribes corresponding to their allocation";
    string internal constant ASSERTION_BI02 =
        "!!! BI-02: User can only claim bribes once in an epoch";
    string internal constant ASSERTION_BI03 =
        "!!! BI-03: Accounting for user allocation amount is always correct";
    string internal constant ASSERTION_BI04 =
        "!!! BI-04: Accounting for total allocation amount is always correct";
    string internal constant ASSERTION_BI05_BRIBE_DUST =
        "!!! BI-05: Bribe token dust amount remaining after claiming should be less than 100 million wei";
    string internal constant ASSERTION_BI05_BOLD_DUST =
        "!!! BI-05: Bold token dust amount remaining after claiming should be less than 100 million wei";
    string internal constant INVARIANT_CANARY_GLOBAL_INVARIANT_FAILURE =
        "Canary invariant";

    function _assertionGV01() internal pure virtual override returns (string memory) {
        return ASSERTION_GV01;
    }

    function _assertionBI01Lqty() internal pure virtual override returns (string memory) {
        return ASSERTION_BI01_LQTY;
    }

    function _assertionBI01Bold() internal pure virtual override returns (string memory) {
        return ASSERTION_BI01_BOLD;
    }

    function _assertionBI02() internal pure virtual override returns (string memory) {
        return ASSERTION_BI02;
    }

    function _assertionBI03() internal pure virtual override returns (string memory) {
        return ASSERTION_BI03;
    }

    function _assertionBI04() internal pure virtual override returns (string memory) {
        return ASSERTION_BI04;
    }

    function _assertionBI05BribeDust() internal pure virtual override returns (string memory) {
        return ASSERTION_BI05_BRIBE_DUST;
    }

    function _assertionBI05BoldDust() internal pure virtual override returns (string memory) {
        return ASSERTION_BI05_BOLD_DUST;
    }

    /// @dev Canary assertion helper. A failing input is expected to be discovered during fuzzing.
    function assert_canary(uint256 entropy) public {
        t(entropy > 0, ASSERTION_CANARY);
    }

    /// @dev Canary global invariant expected to fail immediately.
    function invariant_canary()
        public
        virtual
        returns (bool)
    {
        t(false, INVARIANT_CANARY_GLOBAL_INVARIANT_FAILURE);
        return false;
    }
}
