import {
  time,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { ethers } from "hardhat";

describe("BlockRacersToken", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployFixture() {
    const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    const ONE_GWEI = 1_000_000_000;

    const lockedAmount = ONE_GWEI;
    const unlockTime = (await time.latest()) + ONE_YEAR_IN_SECS;

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();

    const BlockRacersToken = await ethers.getContractFactory("BlockRacersToken");
    const blockRacersToken = await BlockRacersToken.deploy([], { });

    return { blockRacersToken, unlockTime, lockedAmount, owner, otherAccount };
  }

  describe("read", function () {
  });

  describe("write", function () {
    it("mint")
  });
});
