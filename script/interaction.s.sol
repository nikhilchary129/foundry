// SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/fundme.sol";

contract fundingfundme is Script {
     function fundfundme(address mostrecent) public {
        vm.startBroadcast();
        FundMe(payable(mostrecent)).fund{value: 0.01 ether}();

        vm.stopBroadcast();
        console.log("funded rcent");
    }

    function run() external {
        address mostrecentdeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        fundfundme(mostrecentdeployed);
    }
}

contract withdrawfundme is Script {
    function withdrawdme(address mostrecent) public {
        vm.startBroadcast();
       
        FundMe(payable(mostrecent)).withdraw();

        vm.stopBroadcast();
        console.log("withdraw rcent");
    }

    function run() external {
        address mostrecentdeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawfundme(mostrecentdeployed);
    }
   
}

