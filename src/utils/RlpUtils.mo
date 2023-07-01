import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import RlpTypes "mo:rlp-anubis/types";
import AU "ArrayUtils";
import Types "../Types";

module {
    public func getAsValue(
        dec : RlpTypes.Decoded
    ) : [Nat8] {
        switch (dec) {
            case (#Uint8Array(val)) {
                return Buffer.toArray(val);
            };
            case (#Nested(_)) {
                return [];
            };
        };
    };

    public func getAsU256(
        dec : RlpTypes.Decoded
    ) : Types.U256 {
        return AU.toU256(getAsValue(dec));
    };
    public func getAsH160(
        dec : RlpTypes.Decoded
    ) : Types.H160 {
        return AU.toH160(getAsValue(dec));
    };
    public func getAsBytes(
        dec : RlpTypes.Decoded
    ) : Types.Bytes {
        return AU.toBytes(getAsValue(dec));
    };

    public func getAsNat(
        dec : RlpTypes.Decoded
    ) : Nat {
        return AU.toNat(getAsValue(dec));
    };

    public func getAsNat64(
        dec : RlpTypes.Decoded
    ) : Nat64 {
        return AU.toNat64(getAsValue(dec));
    };

    public func getAsText(
        dec : RlpTypes.Decoded
    ) : Text {
        return AU.toText(getAsValue(dec));
    };

    public func getAsList(
        dec : RlpTypes.Decoded
    ) : [[Nat8]] {
        switch (dec) {
            case (#Uint8Array(_)) {
                return [];
            };
            case (#Nested(list)) {
                let res = Buffer.Buffer<[Nat8]>(list.size());
                for (item in list.vals()) {
                    switch (item) {
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