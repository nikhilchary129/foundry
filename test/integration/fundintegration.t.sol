// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {fundingfundme, withdrawfundme} from "../../script/interaction.s.sol";

contract fundmeintgration is Test {
    FundMe fundMe;
    address USER = makeAddr("user");

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, 10 ether);
    }

    function testfundintgreation() public {
        fundingfundme funding = new fundingfundme();
        // uint256 startingfunderbalnce = address(funding).balance;
        // uint256 startingfundmebalnce = address(fundMe).balance;

        funding.fundfundme(address(fundMe));



        withdrawfundme withdrawing = new withdrawfundme();
        //  hoax(address(this),10 ether);
        withdrawing.withdrawdme(address(fundMe));
        uint256 fundmebalnce = address(fundMe).balance;
        assertEq(fundmebalnce,0);
    }
}
