import { mudConfig } from "@latticexyz/world/register";
import { resolveTableId } from "@latticexyz/config";

export default mudConfig({
    deploysDirectory: "./deploys",
    namespace: "moving_castles",
    tables: {
        Core: "bool",
        CarriedBy: "bytes32",
        Energy: "uint32",
        Points: "uint32",
        ReadyBlock: "uint256",
        Health: "uint32",
        Active: "bool"
    },
    modules: [
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("CarriedBy")],
        },
    ],
});
