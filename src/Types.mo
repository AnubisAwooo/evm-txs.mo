module {
    public type TransactionType = {
        #Legacy : ?TransactionLegacy;
        #EIP1559 : ?Transaction1559;
        #EIP2930 : ?Transaction2930;
    };

    public type TransactionBase = {
        chainId : Nat64;
        nonce : Nat;
        gasLimit : Nat;
        to : Text;
        value : Nat;
        data : Text;
        v : Text;
        r : Text;
        s : Text;
    };

    public type TransactionLegacy = TransactionBase and {
        gasPrice : Nat;
    };

    public type Transaction2930 = TransactionBase and {
        gasPrice : Nat;
        accessList : [(Text, [Text])];
    };

    public type Transaction1559 = TransactionBase and {
        maxPriorityFeePerGas : Nat;
        maxFeePerGas : Nat;
        accessList : [(Text, [Text])];
    };
}