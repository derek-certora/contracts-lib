/*
    A toy example of a contract that interacts with a token
    contract, made for the sake of investigating formal
    specification.
*/

pragma solidity ^0.8.13;

import {IERC20} from "../erc20/IERC20.sol" ;

/// @title Toy trading contract
contract Composed {
    // two token contracts
    IERC20 public token_1 ;
    IERC20 public token_2 ;
    
    // constructor 
    constructor (
        address caddr_token_1,
        address caddr_token_2
    ) {
        token_1 = IERC20(caddr_token_1);
        token_2 = IERC20(caddr_token_2);
    }

    // trade from token_1 to token_2
    function oneTwo(uint amt) public {
        require (token_1.transferFrom(msg.sender, address(this), amt),
            "token_1 transfer failed");
        require (token_2.transferFrom(address(this), msg.sender, amt),
            "token_2 transfer failed");
    }

    // trade from token_2 to token_1
    function twoOne(uint amt) public {
        require (token_2.transferFrom(msg.sender, address(this), amt),
            "token_2 transfer failed");
        require (token_1.transferFrom(address(this), msg.sender, amt),
            "token_1 transfer failed");
    }
}
