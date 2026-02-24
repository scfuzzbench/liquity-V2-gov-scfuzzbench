// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {TargetFunctions} from "./TargetFunctions.sol";
import {FoundryAsserts} from "@chimera/FoundryAsserts.sol";
import {Asserts} from "@chimera/Asserts.sol";

// forge test --match-contract CryticToFoundry --match-test 'invariant_' -vv
contract CryticToFoundry is Test, TargetFunctions, FoundryAsserts {
    mapping(string => bool) private assertionFailures;

    function setUp() public {
        setup();

        targetContract(address(this));
        targetSender(address(0x10000));
        targetSender(address(0x20000));
        targetSender(address(0x30000));
    }

    function _isAssertion(string memory reason) internal pure returns (bool) {
        return _hasAssertionPrefix(reason);
    }

    function _hasAssertionPrefix(string memory reason) internal pure returns (bool) {
        bytes memory reasonBytes = bytes(reason);
        return reasonBytes.length >= 3 && reasonBytes[0] == "!" && reasonBytes[1] == "!" && reasonBytes[2] == "!";
    }

    function _recordAssertion(bool ok, string memory reason) internal {
        if (ok) {
            return;
        }

        assertionFailures[reason] = true;
    }

    function gt(uint256 a, uint256 b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(a > b, reason);
        } else {
            super.gt(a, b, reason);
        }
    }

    function gte(uint256 a, uint256 b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(a >= b, reason);
        } else {
            super.gte(a, b, reason);
        }
    }

    function lt(uint256 a, uint256 b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(a < b, reason);
        } else {
            super.lt(a, b, reason);
        }
    }

    function lte(uint256 a, uint256 b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(a <= b, reason);
        } else {
            super.lte(a, b, reason);
        }
    }

    function eq(uint256 a, uint256 b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(a == b, reason);
        } else {
            super.eq(a, b, reason);
        }
    }

    function t(bool b, string memory reason) internal virtual override(FoundryAsserts, Asserts) {
        if (_isAssertion(reason)) {
            _recordAssertion(b, reason);
        } else {
            super.t(b, reason);
        }
    }

    function invariant_assertion_failure_CANARY() public view {
        assertTrue(!assertionFailures[ASSERTION_CANARY], ASSERTION_CANARY);
    }

    function invariant_assertion_failure_GV01() public view {
        assertTrue(!assertionFailures[ASSERTION_GV01], ASSERTION_GV01);
    }

    function invariant_assertion_failure_BI01_LQTY() public view {
        assertTrue(!assertionFailures[ASSERTION_BI01_LQTY], ASSERTION_BI01_LQTY);
    }

    function invariant_assertion_failure_BI01_BOLD() public view {
        assertTrue(!assertionFailures[ASSERTION_BI01_BOLD], ASSERTION_BI01_BOLD);
    }

    function invariant_assertion_failure_BI02() public view {
        assertTrue(!assertionFailures[ASSERTION_BI02], ASSERTION_BI02);
    }

    function invariant_assertion_failure_BI03() public view {
        assertTrue(!assertionFailures[ASSERTION_BI03], ASSERTION_BI03);
    }

    function invariant_assertion_failure_BI04() public view {
        assertTrue(!assertionFailures[ASSERTION_BI04], ASSERTION_BI04);
    }

    function invariant_assertion_failure_BI05_BRIBE_DUST() public view {
        assertTrue(!assertionFailures[ASSERTION_BI05_BRIBE_DUST], ASSERTION_BI05_BRIBE_DUST);
    }

    function invariant_assertion_failure_BI05_BOLD_DUST() public view {
        assertTrue(!assertionFailures[ASSERTION_BI05_BOLD_DUST], ASSERTION_BI05_BOLD_DUST);
    }

    function invariant_noop() public view {}
}
