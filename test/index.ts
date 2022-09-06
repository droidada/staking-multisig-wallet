import { expect } from "chai";
import { ethers } from "hardhat";

describe("Setup token", function () {
  it("Should setup token, guard and safe contracts successfully", async function () {
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy();
    await token.deployed();

    const Guard = await ethers.getContractFactory("Guard");
    const guard = await Guard.deploy();
    await guard.deployed();

    const Safe = await ethers.getContractFactory("StakeSafe");
    const safe = await Safe.deploy();
    await safe.deployed();

    // set guard
    await safe.setGuard(guard);

    // test guard
    expect(await safe.getGuard()).to.equal(guard);
  });
});
