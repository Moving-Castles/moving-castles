import { mudConfig } from "@latticexyz/config";

export default mudConfig({
    deploysDirectory: "./deploys",
    namespace: "moving_castles",
    tables: {
        Avatar: "uint256",
        CarriedBy: "bytes32",
        Core: "bool",
        CreationBlock: "uint256",
        Energy: "uint32",
        Name: "string",
        Portable: "bool",
        ReadyBlock: "uint256",
        RealmId: "uint256",
    }
});
