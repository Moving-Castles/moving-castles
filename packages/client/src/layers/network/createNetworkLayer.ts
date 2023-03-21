import type { SystemTypes } from "contracts/types/SystemTypes";
import type { GameConfig } from "./config";
import { createWorld } from "@latticexyz/recs";
import { setupDevSystems } from "./setup";
import { createActionSystem, setupMUDNetwork } from "@latticexyz/std-client";
import { createFaucetService } from "@latticexyz/network";
import {
  defineLoadingStateComponent,
  defineGameConfigComponent,
  defineCreationBlockComponent,
  defineEnergyComponent,
  defineMatterComponent,
  definePortableComponent,
  definePositionComponent,
  defineReadyBlockComponent,
  defineCarryingCapacityComponent,
  defineCarriedByComponent,
  defineCoreComponent,
  defineAbilityMoveComponent,
  defineAbilityConsumeComponent,
  // defineAbilityExtractComponent,
  defineAbilityPlayComponent,
  // defineAbilityBurnComponent,
  defineUntraversableComponent,
  defineCommitComponent,
  // defineBurnBlockComponent,
  defineLootComponent,
  defineGoalComponent,
  definePointComponent
} from "./components";
import { SystemAbis } from "contracts/types/SystemAbis.mjs";
import { getNetworkConfig } from "./config";
import { utils } from "ethers";

/**
 * The Network layer is the lowest layer in the client architecture.
 * Its purpose is to synchronize the client components with the contract components.
 */
export async function createNetworkLayer(config: GameConfig) {
  // --- WORLD ----------------------------------------------------------------------
  const world = createWorld();

  // --- COMPONENTS -----------------------------------------------------------------
  const components = {
    LoadingState: defineLoadingStateComponent(world),
    GameConfig: defineGameConfigComponent(world),
    Position: definePositionComponent(world),
    Energy: defineEnergyComponent(world),
    Matter: defineMatterComponent(world),
    CreationBlock: defineCreationBlockComponent(world),
    ReadyBlock: defineReadyBlockComponent(world),
    Portable: definePortableComponent(world),
    CarryingCapacity: defineCarryingCapacityComponent(world),
    CarriedBy: defineCarriedByComponent(world),
    Core: defineCoreComponent(world),
    AbilityMove: defineAbilityMoveComponent(world),
    AbilityConsume: defineAbilityConsumeComponent(world),
    AbilityPlay: defineAbilityPlayComponent(world),
    Untraversable: defineUntraversableComponent(world),
    Commit: defineCommitComponent(world),
    Loot: defineLootComponent(world),
    Goal: defineGoalComponent(world),
    Point: definePointComponent(world)
  };

  // --- SETUP ----------------------------------------------------------------------
  const { txQueue, systems, txReduced$, network, startSync, encoders, systemCallStreams } = await setupMUDNetwork<
    typeof components,
    SystemTypes
  >(getNetworkConfig(config), world, components, SystemAbis, { fetchSystemCalls: true });

  // Faucet setup
  const faucet = config.faucetServiceUrl ? createFaucetService(config.faucetServiceUrl) : undefined;
  const address = network.connectedAddress.get();
  console.log("player address:", address);

  async function requestDrip() {
    const playerIsBroke = (await network.signer.get()?.getBalance())?.lte(utils.parseEther("0.05"));
    if (playerIsBroke) {
      console.info("[Dev Faucet] Dripping funds to player");
      // Double drip
      address && (await faucet?.dripDev({ address })) && (await faucet?.dripDev({ address }));
    }
  }

  requestDrip();
  // Request a drip every 20 seconds
  setInterval(requestDrip, 20000);

  // --- ACTION SYSTEM --------------------------------------------------------------
  const actions = createActionSystem(world, txReduced$);

  // --- API ------------------------------------------------------------------------

  function spawn() {
    try {
      systems["system.Spawn"].executeTyped();
    } catch (e) {
      window.alert(e);
    }
  }

  // --- CONTEXT --------------------------------------------------------------------
  const context = {
    world,
    components,
    txQueue,
    systems,
    txReduced$,
    startSync,
    network,
    actions,
    systemCallStreams,
    api: { spawn },
    dev: setupDevSystems(world, encoders, systems),
  };

  return context;
}
