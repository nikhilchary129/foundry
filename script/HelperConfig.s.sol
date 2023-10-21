
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";

import{MockV3Aggregator}from "../test/mocks/MockV3Agrregator.sol";

contract HelperConfig is Script{
   //to get the address of the local test net we are using
   NetworkConfig public  activeNetworkConfig;

    struct NetworkConfig{
        address priceFeed;
    }
    constructor(){
        if(block.chainid ==11155111) activeNetworkConfig= getSepoliaConfig();
        else activeNetworkConfig= getAnvilConfig();
    }
   function getSepoliaConfig()  public pure returns( NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig=  NetworkConfig({
            priceFeed:0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
      
   }
    function getAnvilConfig()  public returns( NetworkConfig memory){
    //1.deploy the mock
    //2.return the mock address
    if(activeNetworkConfig.priceFeed != address(0)){
        return activeNetworkConfig;
    }

    vm.startBroadcast();
    MockV3Aggregator mockPriceFeed= new MockV3Aggregator(8,2000e8);
    vm.stopBroadcast();
    

    NetworkConfig  memory anvilConfig= NetworkConfig({
        priceFeed:address(mockPriceFeed)
    });

    return anvilConfig;


   }
}