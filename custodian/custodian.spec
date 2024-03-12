// one desired property is that the internal ledger match the 
// ERC20 ledger. How to find that out?

methods {
    function balanceOf(address) external returns (uint256) envfree;
    function custodyFor(address) external returns (uint256) envfree;
}

/*
    This invariant is a problem because we can't tell that
    the state of another contract has changed/we don't have
    access to the other contract's specification/verified 
    properties
*/
invariant ledgerConfluence(address a)
    custodyFor(a) <= balanceOf(address(this));
