import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import RlpTypes "mo:rlp/types";
import AU "ArrayUtils";

module {
       public func getAsValue(
        dec: RlpTypes.Decoded
    ): [Nat8] {
        switch(dec) {
            case (#Uint8Array(val)) {
                return Buffer.toArray(val);
            };
            case (#Nested(_)) {
                return [];
            };
        };
    };

    public func getAsNat(
        dec : RlpTypes.Decoded
    ) : Nat {
        return AU.toNat(getAsValue(dec));
    };

    public func getAsNat64(
        dec: RlpTypes.Decoded
    ): Nat64 {
        return AU.toNat64(getAsValue(dec));
    };

    public func getAsText(
        dec: RlpTypes.Decoded
    ): Text {
        return AU.toText(getAsValue(dec));
    };

    public func getAsList(
        dec: RlpTypes.Decoded
    ): [[Nat8]] {
        switch(dec) {
            case (#Uint8Array(_)) {
                return [];
            };
            case (#Nested(list)) {
                let res = Buffer.Buffer<[Nat8]>(list.size());
                for(item in list.vals()) {
                    switch(item) {
                        case (#Uint8Array(val)) {
                            res.add(Buffer.toArray(val));
                        };
                        case (#Nested(_)) {
                        };
                    };
                };
                return Buffer.toArray(res);
            };
        };
    };
}