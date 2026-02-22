// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BeforeAfter} from "./BeforeAfter.sol";
import {GovernanceProperties} from "./properties/GovernanceProperties.sol";
import {BribeInitiativeProperties} from "./properties/BribeInitiativeProperties.sol";

abstract contract Properties is GovernanceProperties {
    string internal constant ASSERTION_CANARY_ASSERTION_FAILURE =
        "!!! CANARY_ASSERTION_FAILURE";
    string internal constant INVARIANT_CANARY_GLOBAL_INVARIANT_FAILURE =
        "CANARY_GLOBAL_INVARIANT_FAILURE";

    /// @dev Canary assertion failure expected to fail immediately.
    function invariant_canary_assertion_failure() public returns (bool) {
        t(false, ASSERTION_CANARY_ASSERTION_FAILURE);
        return false;
    }

    /// @dev Canary global invariant expected to fail immediately.
    function invariant_canary_global_invariant_failure()
        public
        virtual
        returns (bool)
    {
        t(false, INVARIANT_CANARY_GLOBAL_INVARIANT_FAILURE);
        return false;
    }
}
