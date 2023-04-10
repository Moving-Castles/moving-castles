import { mudConfig, resolveTableId } from "@latticexyz/config";

export default mudConfig({
    deploysDirectory: "./deploys",
    namespace: "moving_castles",
    tables: {
        Ability: {
            schema: {
                value: "bool"
            },
            tableIdArgument: true,
        },
        AbilityChat: "bool",
        AbilityConsume: "bool",
        AbilityMove: "bool",
        AbilityPlay: "bool",
        // ...
        CarriedBy: "bytes32",
        CarryingCapacity: "uint32",
        Commit: "uint256",
        Core: "bool",
        CreationBlock: "uint256",
        Energy: "uint32",
        GameConfig: {
            fileSelector: "game_config",
            schema: {
                worldHeight: "int32",
                worldWidth: "int32",
                initialEnergy: "uint32",
                defaultCarryingCapacity: "uint32",
                moveCost: "uint32",
                pickUpCost: "uint32",
                dropCost: "uint32",
                transferCost: "uint32",
                playCost: "uint32",
                moveCooldown: "uint32",
                openCost: "uint32",
                harvestCost: "uint32",
                organMatter: "uint32"
            },
            primaryKeys: {},
            dataStruct: true,
        },
        Goal: "uint256",
        Loot: "uint32",
        Matter: "uint32",
        Point: "uint256",
        Portable: "bool",
        Position: {
            schema: {
                x: "int32",
                y: "int32",
            },
        },
        ReadyBlock: "uint256",
        Untraversable: "bool"
    },
    modules: [
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("Position")],
        },
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("CarriedBy")],
        },
        {
            name: "KeysWithValueModule",
            root: true,
            args: [resolveTableId("Goal")],
        },
    ],
});
