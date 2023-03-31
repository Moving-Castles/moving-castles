/*
 *  The action sequencer is responsible for sending transactions 
 *  to the blockchain, one at a time.
 *
 */

import type { SystemTypes } from "contracts/types/SystemTypes";
import { writable, get } from "svelte/store";
import { network, blockNumber } from "../network";
import { playerCore } from "../player";
import { gameConfig } from "../entities";
import { playSound } from "../../../howler";
import { toastMessage } from "../../modules/toast"

// --- TYPES -----------------------------------------------------------------

export enum SequencerState {
  Running,
  Paused,
}

export type Action = {
  actionId: string;
  systemId: keyof SystemTypes;
  requirements: {
    energy: number;
  };
  tx?: string;
  timestamp?: number;
  params?: any[];
};

// --- STORES -----------------------------------------------------------------

export const sequencerState = writable(SequencerState.Running);
export const queuedActions = writable([] as Action[]);
export const activeActions = writable([] as Action[]);
export const completedActions = writable([] as Action[]);
export const failedActions = writable([] as Action[]);

// --- API -----------------------------------------------------------------

export function getEnergyCost(systemId: keyof SystemTypes) {
  const config = get(gameConfig);
  switch (systemId) {
    case "system.Move":
      return config.moveCost;
    case "system.PickUp":
      return config.pickUpCost;
    case "system.Drop":
      return config.dropCost;
    case "system.Transfer":
      return config.transferCost;
    case "system.Play":
      return config.playCost;
    case "system.Open":
      return config.openCost;
    case "system.Harvest":
      return config.harvestCost;
    default:
      return 0;
  }
}

export function addToSequencer(systemId: keyof SystemTypes, params: any[] = []) {
  // playSound("selectTwo", "ui")
  queuedActions.update((queuedActions) => {
    const newAction = {
      actionId: self.crypto.randomUUID(),
      systemId: systemId,
      params: params,
      requirements: {
        energy: getEnergyCost(systemId)
      }
    };
    return [...queuedActions, newAction];
  });
}

export function removeFromSequencer(id: string) {
  queuedActions.update((queuedActions) => queuedActions.filter((a) => a.actionId !== id));
}

export function clearSequencer() {
  queuedActions.update(() => []);
}

// --- SEQUENCER -----------------------------------------------------------------

export function initActionSequencer() {
  /*
   *   The sequencer triggers on each block
   *   If the conditions are met it executes the next action
   *   To be notified of the action being executed we listen to calls to all systems
   *
   */

  blockNumber.subscribe(async (newBlock) => {
    /*
      * Execute next if:
      * - sequencer is running
      * - there are no active action
      * - queue is not empty
      */
    if (
      get(sequencerState) === SequencerState.Running &&
      get(activeActions).length === 0 &&
      get(queuedActions).length > 0
    ) {
      execute();
    }
  });

  const EXCLUDED_SYSTEMS = ["system.ComponentDev", "system.Init", "system.Spawn"];

  // Set up listeners for all systems (except EXCLUDED_SYSTEMS)
  for (const [key, value] of Object.entries(get(network).systemCallStreams)) {
    if (!EXCLUDED_SYSTEMS.includes(key)) {
      value.subscribe((systemCall) => {
        const action = get(activeActions).find((a) => a.tx === systemCall.tx.hash);
        if (!action) return;
        // Remove action from active list
        activeActions.update((activeActions) => activeActions.filter((a) => a.tx !== action?.tx));
        // Add action to completed list
        completedActions.update((completedActions) => [action, ...completedActions]);
        // playSound("selectFour", "ui")
      });
    }
  }
}

async function execute() {
  const action = get(queuedActions)[0];
  try {
    // Remove action from queue list
    queuedActions.update((queuedActions) => queuedActions.slice(1));
    // Check if player has enough energy
    if (get(playerCore).energy < action.requirements.energy) {
      // Add action to failed list
      failedActions.update((failedActions) => [action, ...failedActions]);
      toastMessage({ message: 'Not enough energy to execute action: ' + String(action.systemId) + '. Requires ' + action.requirements.energy + ' energy.', type: 'warning', timestamp: performance.now() })
      playSound("error", "ui")
      return;
    }
    // Add action to active list
    activeActions.update((activeActions) => [action, ...activeActions]);
    // @todo: fix types
    const tx = await get(network).systems[action.systemId].executeTyped(...action.params);
    // Transaction sent. Add tx hash and timestamp to action.
    activeActions.update((activeActions) => {
      activeActions[0].tx = tx.hash;
      activeActions[0].timestamp = Date.now();
      // playSound("selectOne", "ui")
      return activeActions;
    });
  } catch (e) {
    // playSound("error", "ui")
    // @todo: handle error better
    toastMessage({ message: e, type: 'warning', timestamp: performance.now() })
    // Clear active list
    activeActions.update(() => []);
    // Add action to failed list
    failedActions.update((failedActions) => [action, ...failedActions]);
  }
}
