// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol";
import "hardhat/console.sol";

contract StakeSafe is GnosisSafe {

    IERC20 internal immutable stakingToken;
    uint256 internal totalAmountStaked;
    mapping(address => uint256) internal stakerToAmount;

    modifier ownersOnly() {
        require(msg.sender != SENTINEL_OWNERS && owners[msg.sender] != address(0),"unauthorized owner");
        _;
    }

    constructor(address _stakingToken) GnosisSafe() {
        require(_stakingToken != address(0), "invalid token");
        stakingToken = IERC20(_stakingToken);
    }


    function getOwnerCount() public view returns(uint256) {
        return ownerCount;
    }

    function getStakerTokens(address staker) public view returns(uint256) {
        require(staker != address(0),"invalid address");
        return stakerToAmount[staker];
    }

    function getTotalTokens() public view returns(uint256) {
        return totalAmountStaked;
    }

    function stake(uint _amount) external ownersOnly {
        require(_amount > 0, "amount = 0");
        stakerToAmount[msg.sender] += _amount;
        totalAmountStaked += _amount;
        stakingToken.transferFrom(msg.sender, address(this), _amount);
    }

    function withdraw(uint _amount) external ownersOnly {
        require(_amount > 0, "amount = 0");
        require(stakerToAmount[msg.sender] >= _amount, "overdraft");
        stakerToAmount[msg.sender] -= _amount;
        totalAmountStaked -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

}