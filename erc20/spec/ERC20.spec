// Declared methods from the contract.
// This is to simplify syntax in the Rules below.
methods {
    // envfree functions 
    function totalSupply() external returns uint256 envfree;
    function balanceOf(address) external returns uint256 envfree;
    function allowance(address,address) external returns uint256 envfree;
    function _owner() external returns address envfree;
}



// Rules 


// Example in CVL: A rule called decreasingEntrypoints.
rule decreasingEntrypoints(method f, address caddr) {
    // Consider an environment e where caddr has balance prevBalance, ...
    env e;
    uint256 prevBalance = balanceOf(caddr);

    // and suppose that an entrypoint f is successfully called ...
    calldataarg args;
    f(e,args);

    // ... such that the address caddr has balance newBalance.
    uint256 newBalance = balanceOf(caddr);
    
    // Then, if the balance of caddr decreased, f was either 
    // transfer() or transferFrom().
    assert(newBalance < prevBalance =>
        f.selector == sig:transfer(address, uint256).selector ||
        f.selector == sig:transferFrom(address, address, uint256).selector,
    "user's balance changed as a result function other than transfer() or 
    transferFrom()");
}


// Example in CVL: A rule called transferCorrect.
rule transferCorrect(address recip, uint256 amt, address otherCaddr) {
    // Consider an environment e where otherCaddr has balance prevBalance.
    env e;
    uint256 prevBalance = balanceOf(otherCaddr);

    // Then suppose the transfer() entrypoint is called, ...
    transfer(recip,amt);

    // resulting in a balance newBalance for otherCaddr.
    uint256 newBalance = balanceOf(otherCaddr);
    
    // Then if otherCaddr is neither the sender nor the recipient,
    // the balance of otherCaddr stays constant.
    assert(otherCaddr != msg.sender /\ otherCaddr != recip =>
        newBalance == prevBalance,
    "transfer() has affected the wrong accounts.");
}
