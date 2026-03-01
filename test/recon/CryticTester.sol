// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {TargetFunctions} from "./TargetFunctions.sol";
import {CryticAsserts} from "@chimera/CryticAsserts.sol";

// echidna . --contract CryticTester --config echidna.yaml
// medusa fuzz
contract CryticTester is TargetFunctions, CryticAsserts {
    constructor() payable {
        setup();
    }

    function echidna_assert_canary_ASSERTION_CANARY() public returns (bool) {
        assert_canary_ASSERTION_CANARY(0);
        return false;
    }

    function echidna_invariant_canary() public returns (bool) {
        invariant_canary();
        return false;
    }
}
