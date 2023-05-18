import { mudConfig } from "@latticexyz/world/register";
import { resolveTableId } from "@latticexyz/config";

export default mudConfig({
    deploysDirectory: "./deploys",
    namespace: "moving_castles",
    tables: {
        Core: "bool",
        Energy: "uint32",
        Points: "uint32",
        ReadyBlock: "uint256",
        Counter: {
            keySchema: {},
            schema: "uint32",
        }
    }
});
