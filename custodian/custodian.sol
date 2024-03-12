/*
    A toy example of a contract that interacts with a token
    contract, made for the sake of investigating formal
    specification.
*/

pragma solidity ^0.8.13;

import {IERC20} from "./IERC20.sol" ;

/// @title Toy custodian contract
contract Custodian {
    // the token contract we're willing to be a custodian for 
    IERC20 public token ;

    // a mapping to keep track of funds in custody
    mapping (address => uint256) custody;
    
    // constructor 
    constructor (
        address caddr_token
    ) {
        token = IERC20(caddr_token);
    }

    // the contract takes custody of funds
    function giveCustody(uint amt) public {
        // take custody
        require (token.transferFrom(msg.sender, address(this), amt),
            "token transfer failed, could not take custody");

        // update custody mapping 
        custody[msg.sender] += amt ;
    }

    // the user recovers funds
    function recoverCustody() public {
        // return funds 
        uint256 amt = custody[msg.sender] ;
        require (token.transferFrom(address(this),msg.sender,amt),
            "token transfer failed, could not take custody");

        // clear custody balance
        custody[msg.sender] = 0;
    }

    // look at the balance of the token contract 
    function custodyFor(address a) public view returns (uint256) {
        return custody[a];
    }
}
