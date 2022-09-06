import { expect } from "chai";
import { ethers } from "hardhat";

describe("Setup token", function () {
  it("Should return the new greeting once it's changed", async function () {
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy();
    await token.deployed();

    const Guard = await ethers.getContractFactory("Guard");
    const guard = await Guard.deploy();
    await guard.deployed();

    const Safe = await ethers.getContractFactory("GnosisSafe");
    const safe = await Safe.deploy();
    await safe.deployed();

    expect(await safe.greet()).to.equal("Hello, world!");

    const setGreetingTx = await safe.setGreeting("Hola, mundo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await safe.greet()).to.equal("Hola, mundo!");
  });
});
