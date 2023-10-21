// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/fundme.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract fundmetest is Test {
    uint256 constant val = 10e18;
    FundMe fundMe;
    //seting a fake user fortesting
    address USER = makeAddr("user");

    function setUp() external {
        //     number=2;
        //  fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        vm.deal(USER, 10 ether);
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getowner(), msg.sender);
    }

    function testprice() public {
        uint256 version = fundMe.getVersion();
        // console.log(version);
        assertEq(version, 4);
    }

    function testFundWithoutETH() public {
        vm.expectRevert();

        fundMe.fund(); //no trnaction is send 0
    }

    function testFundUpadtesFundedDS() public funded {
        uint256 amountFunded = fundMe.getAdressToAmountFunded(USER);
        assertEq(amountFunded, val);
        // address addressOfFunder= fundMe.getFunder()
    }

    function testAddsFunderToarrayofFunder() public funded {
        address testeradd = fundMe.getFunder(0); //this user isalways frst as every test restarts the setup
        assertEq(testeradd, USER);
    }

    function OnlyOwnercanWithdraw() public funded {
        vm.prank(fundMe.getowner());
        vm.expectRevert();
        // console.log(USER,address(this),fundMe.getowner());
        fundMe.withdraw();
    }

    modifier funded() {
        vm.prank(USER); //the tx will be done by the USER
        fundMe.fund{value: val}();
        _;
    }

    function testwithdrawforsinglefunder() public funded {
        //arange
        uint256 startingownerbalance = fundMe.getowner().balance;
        uint256 startingfunderbalance = address(fundMe).balance;

        // console.log(USER,fundMe.getowner());
        //act
        vm.prank(fundMe.getowner());
        fundMe.withdraw();

        // assert
        uint256 endingownerbalance = fundMe.getowner().balance;
        uint256 endingfunderbalance = address(fundMe).balance;
        assertEq(endingfunderbalance, 0);
        assertEq(
            endingownerbalance,
            startingownerbalance + startingfunderbalance
        );
    }

    function testwithdrawfrommultiplefunders() public funded {
        //hoax does the prank and deal

        uint160 numberoffunders = 10;
        uint160 staringfunderindex = 1;
        for (uint160 i = staringfunderindex; i < numberoffunders; i++) {
            hoax(address(i), val);
            fundMe.fund{value: val}();
        }
        uint256 startingownerbalance = fundMe.getowner().balance;
        uint256 startingfunderbalance = address(fundMe).balance;

        vm.startPrank(fundMe.getowner());
        fundMe.withdraw();
        vm.stopPrank();
        assertEq(address(fundMe).balance, 0);
        assertEq(
            startingownerbalance + startingfunderbalance,
            fundMe.getowner().balance
        );
    }
}
