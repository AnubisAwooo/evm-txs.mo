import Error "mo:base/Error";
import Result "mo:base/Result";
import Ecmult "mo:libsecp256k1/core/ecmult";
import Transaction "Transaction";
import Types "Types";
import AU "utils/ArrayUtils";
import EcdsaApi "interfaces/EcdsaApi";

module {
    public func signDeployment(
        bytecode : Types.Bytes,
        maxPriorityFeePerGas : Types.U256,
        gasLimit : Types.U256,
        maxFeePerGas : Types.U256,
        chainId : Nat64,
        keyName : Text,
        derivationPath : [Blob],
        publicKey : [Nat8],
        nonce : Types.U256,
        context : Ecmult.ECMultContext,
        api: EcdsaApi.API
    ) : async* Result.Result<(Types.TransactionType, [Nat8]), Text> {
        let tx : Types.Transaction1559 = {
            nonce;
            chainId;
            maxPriorityFeePerGas;
            maxFeePerGas;
            gasLimit;
            to = [];
            value = Types.nat_to_u256(0);
            data = bytecode;
            accessList = [];
            v = "0x00";
            r = "0x00";
            s = "0x00";
        };
        switch (Transaction.serialize(#EIP1559(?tx))) {
            case (#err(msg)) {
                return #err(msg);
            };
            case (#ok(rawTx)) {
                return await* Transaction.signRawTx(
                    rawTx, chainId, keyName, derivationPath, publicKey, context, api);
        };
    };
};
}