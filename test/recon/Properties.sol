// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BeforeAfter} from "./BeforeAfter.sol";
import {GovernanceProperties} from "./properties/GovernanceProperties.sol";
import {BribeInitiativeProperties} from "./properties/BribeInitiativeProperties.sol";

abstract contract Properties is GovernanceProperties {
    string internal constant ASSERTION_CANARY =
        "!!! canary assertion";
    string internal constant INVARIANT_CANARY_GLOBAL_INVARIANT_FAILURE =
        "Canary invariant";

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
