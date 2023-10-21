
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

import {FundMe} from "../src/fundme.sol";

import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script{
  function run() external returns (FundMe){
    //anything before startbroadcast doesnot takes gas

    HelperConfig helperConfig= new HelperConfig();
    address  configadd=helperConfig.activeNetworkConfig();
    vm.startBroadcast();
    
    FundMe fundMe=  new FundMe( configadd  );
    
    vm.stopBroadcast();
    return fundMe;
  }
}
