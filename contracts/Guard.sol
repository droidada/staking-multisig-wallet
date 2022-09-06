//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "@gnosis.pm/safe-contracts/contracts/base/GuardManager.sol";
import "@gnosis.pm/safe-contracts/contracts/common/SignatureDecoder.sol";
import "./StakeSafe.sol";
import "./Token.sol";
import "hardhat/console.sol";


contract NewGuard is Guard, SignatureDecoder {

    constructor() {}

    function checkTransaction(
        address,
        uint256,
        bytes memory,
        Enum.Operation,
        uint256,
        uint256,
        uint256,
        address,
        address payable,
        bytes memory signatures,
        address
    ) external view override {

        StakeSafe safe = StakeSafe(payable(msg.sender));
        uint256 threshold = safe.getThreshold();
        require(threshold <= 0,"invalid stakesafe");

        uint256 summedRatio = 0;
        uint8 v;
        bytes32 r;
        bytes32 s;
        uint256 i;

        for ( i = 0; i < threshold; i++) {
            (v, r, s) = signatureSplit(signatures, i);
            address staker = address(uint160(uint256(r)));
            require(staker != address(0), "invalid signature");
            summedRatio += safe.getStakerTokens(staker) / safe.getTotalTokens();
        }
        uint256 thresholdRatio = threshold / safe.getOwnerCount();
        require(summedRatio >= thresholdRatio, "invalid authorization for tx");
    }

    function checkAfterExecution(bytes32 txHash, bool success) external override {}

}
