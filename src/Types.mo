import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";

module {
    public type U256 = [Nat8]; // length is 32
    public type H160 = [Nat8]; // length is 20
    public type Bytes = [Nat8];

    public func nat_to_u256(v : Nat) : U256 {
        var n : [var Nat8] = Array.init<Nat8>(32, 0);
        var vv = v;
        var i = 0;
        while (i < 32) {
            let r = vv % 256;
            n[31 - i] := Nat8.fromNat(r);
            vv := vv / 256;
            if (vv == 0) {
                i := 32;
            };
            i := i + 1;
        };
        Array.freeze(n);
    };

    public type TransactionType = {
        #Legacy : ?TransactionLegacy;
        #EIP1559 : ?Transaction1559;
        #EIP2930 : ?Transaction2930;
    };

    public type TransactionBase = {
        chainId : Nat64;
        nonce : U256;
        gasLimit : U256;
        to : H160;
        value : U256;
        data : Bytes;
        v : Text;
        r : Text;
        s : Text;
    };

    public type TransactionLegacy = TransactionBase and {
        gasPrice : U256;
    };

    public type Transaction2930 = TransactionBase and {
        gasPrice : U256;
        accessList : [(Text, [Text])];
    };

    public type Transaction1559 = TransactionBase and {
        maxPriorityFeePerGas : U256;
        maxFeePerGas : U256;
        accessList : [(Text, [Text])];
    };
}