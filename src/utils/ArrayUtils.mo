import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import List "mo:base/List";
import Nat64 "mo:base/Nat64";
import Nat32 "mo:base/Nat32";
import Nat8 "mo:base/Nat8";
import Char "mo:base/Char";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Int8 "mo:base/Int8";
import CU "CharUtils";

module {
    public func fill<T>(
        arr: [T],
        size: Nat,
        default: T
    ): [T] {
        if(size <= arr.size()) {
            return arr;
        };

        let res = Array.tabulateVar<T>(size, func i = default);

        var i = 0;
        while(i < arr.size()) {
            res[i] := arr[i];
            i += 1;
        };

        return Array.freeze(res);
    };

    public func left<T>(
        arr: [T],
        offset: Nat
    ): [T] {
        let elms = offset + 1;
        let res = Buffer.Buffer<T>(elms);

        var i = 0;
        while(i < elms) {
            res.add(arr[i]);
            i += 1;
        };

        return Buffer.toArray(res);
    };

    public func right<T>(
        arr: [T],
        offset: Nat
    ): [T] {
        let elms = Nat.sub(arr.size(), offset);
        let res = Buffer.Buffer<T>(elms);

        var i = 0;
        while(i < elms) {
            res.add(arr[offset + i]);
            i += 1;
        };

        return Buffer.toArray(res);
    };

    public func stripLeft<T>(
        arr: [T],
        strip: (a: T) -> Bool
    ): [T] {
        var offset = 0;
        label L while(offset < arr.size()) {
            if(not strip(arr[offset])) {
                break L;
            };
        };
        
        let elms = Nat.sub(arr.size(), offset);
        let res = Buffer.Buffer<T>(elms);

        var i = 0;
        while(i < elms) {
            res.add(arr[offset + i]);
            i += 1;
        };

        return Buffer.toArray(res);
    };

    public func toNat(array : [Nat8]) : Nat {
        var value : Nat = 0;

        for (byte in array.vals()) {
            value := (value * 256) + Nat8.toNat(byte);
        };

        return value;
    };

    func _fromNat(list : List.List<Nat8>, value : Nat, byte : Nat) : List.List<Nat8> {
        var list2 = List.push(Nat8.fromNat(byte), list);
        if (value != 0) {
            list2 := _fromNat(list2, value / 256, value % 256);
        };
        list2;
    };

    public func fromNat(value : Nat) : [Nat8] {
        let list = _fromNat(List.nil<Nat8>(), value / 256, value % 256);
        List.toArray(list);
    };

    public func toNat64(
        arr: [Nat8]
    ): Nat64 {
        var res: Nat64 = 0;

        for(byte in arr.vals()) {
            res := (res << 8) | Nat64.fromNat(Nat8.toNat(byte));
        };

        return res;
    };

    public func fromNat64(
        value: Nat64
    ): [Nat8] {
        let res = Buffer.Buffer<Nat8>(8);
        
        // WebAssembly is little-endian and the evm is big-endian, so a conversion is needed
        // var val = value;
        // var hasLeading = false;
        // while(val > 0) {
        //     let byte = (val >> 56) & 0xff;
        //     val <<= 8;
        //     if(hasLeading or byte != 0) {
        //         res.add(Nat8.fromNat(Nat64.toNat(byte)));
        //         hasLeading := true;
        //     };
        // };

        var array : [var Nat8] = Array.init<Nat8>(8, 0);
        var first : Nat = 7;
        var i : Int8 = 7;
        while (0 <= i) {
            let v = value >> Nat64.fromNat(Nat8.toNat(Int8.toNat8(((7 - i) * 8))));
            let byte : Nat64 = v & 0xff;
            let ii = Nat8.toNat(Int8.toNat8(i));
            array[ii] := Nat8.fromNat(Nat64.toNat(byte));
            if (byte != 0) first := ii;
            i := i - 1;
        };

        var ii = first;
        while (ii < 8) {
            res.add(array[ii]);
            ii := ii + 1;
        };

        return Buffer.toArray(res);
    };

    public func toText(
        arr: [Nat8]
    ): Text {
        var res = "";

        for(byte in arr.vals()) {
            let b = Nat32.fromNat(Nat8.toNat(byte));
            let ms = (b & 0xf0) >> 4;
            let ls = b & 0x0f;
            res #= Char.toText(CU.fromNat32(ms));
            res #= Char.toText(CU.fromNat32(ls));
        };

        return res;
    };

    public func fromText(
        value: Text
    ): [Nat8] {
        let res = Buffer.Buffer<Nat8>(32);

        let str = Iter.toArray(Text.toIter(value));
        let toSkip = if(str.size() >= 2 and str[0] == '0' and str[1] == 'x')
            2
        else
            0;

        var i = toSkip;
        while(i < str.size()) {
            let ms = CU.toNat32(str[i]);
            let ls = CU.toNat32(str[i+1]);
            res.add(Nat8.fromNat(Nat32.toNat((ms << 4) | ls)));
            i += 2;
        };

        return Buffer.toArray(res);
    };


};