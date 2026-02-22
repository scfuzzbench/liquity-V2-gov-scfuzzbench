// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";
import {Asserts} from "@chimera/Asserts.sol";

// forge test --match-contract CryticToFoundry --match-test 'invariant_' -vv
contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    mapping(string => bool) private assertionFailures;
    uint256 private assertionFailureCount;

    string internal constant ASSERTION_GENERIC = "!!!assertion_failed";

    function setUp() public {
        setup();

        targetContract(address(this));
        targetSender(address(0x10000));
        targetSender(address(0x20000));
        targetSender(address(0x30000));

        // Canary: force one assertion-failure invariant to fail immediately.
        _recordAssertion(false, ASSERTION_CANARY_ASSERTION_FAILURE);
    }

    function _isAssertion(string memory) internal pure returns (bool) {
        return true;
    }

    function _hasAssertionPrefix(string memory reason) internal pure returns (bool) {
        bytes memory reasonBytes = bytes(reason);
        return reasonBytes.length >= 3 && reasonBytes[0] == "!" && reasonBytes[1] == "!" && reasonBytes[2] == "!";
    }

    function _normalizeAssertionReason(string memory reason) internal pure returns (string memory) {
        if (bytes(reason).length == 0) {
            return ASSERTION_GENERIC;
        }

        if (_hasAssertionPrefix(reason)) {
            return reason;
        }

        return string.concat("!!!", reason);
    }

    function _recordAssertion(bool ok, string memory reason) internal {
        if (ok) {
            return;
        }

        if (!assertionFailures[reason]) {
            assertionFailures[reason] = true;
            assertionFailureCount++;
        }
    }

    function gt(uint256 a, uint256 b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(a > b, _normalizeAssertionReason(reason));
        } else {
            super.gt(a, b, reason);
        }
    }

    function gte(uint256 a, uint256 b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(a >= b, _normalizeAssertionReason(reason));
        } else {
            super.gte(a, b, reason);
        }
    }

    function lt(uint256 a, uint256 b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(a < b, _normalizeAssertionReason(reason));
        } else {
            super.lt(a, b, reason);
        }
    }

    function lte(uint256 a, uint256 b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(a <= b, _normalizeAssertionReason(reason));
        } else {
            super.lte(a, b, reason);
        }
    }

    function eq(uint256 a, uint256 b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(a == b, _normalizeAssertionReason(reason));
        } else {
            super.eq(a, b, reason);
        }
    }

    function t(bool b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(b, _normalizeAssertionReason(reason));
        } else {
            super.t(b, reason);
        }
    }

    function invariant_assertion_failure_count_zero() public view {
        assertEq(assertionFailureCount, 0, "!!!assertion failure count must remain zero");
    }

    function invariant_assertion_failure_generic() public view {
        assertTrue(!assertionFailures[ASSERTION_GENERIC], ASSERTION_GENERIC);
    }

    function invariant_assertion_failure_CANARY_ASSERTION_FAILURE() public view {
        assertTrue(!assertionFailures[ASSERTION_CANARY_ASSERTION_FAILURE], ASSERTION_CANARY_ASSERTION_FAILURE);
    }

    function invariant_canary_global_invariant_failure()
        public
        pure
        override
        returns (bool)
    {
        assertTrue(false, INVARIANT_CANARY_GLOBAL_INVARIANT_FAILURE);
        return false;
    }

    function invariant_noop() public view {}
}
