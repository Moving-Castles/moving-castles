/*
 *  Central store for all entities in the game.
 * 
 */
import { writable, get, derived } from "svelte/store";
import { network } from "../network";

// --- TYPES -----------------------------------------------------------------

export type GameConfig = {
  worldHeight: number;
  worldWidth: number;
  initialEnergy: number;
  defaultCarryingCapacity: number;
  moveCost: number;
  pickUpCost: number;
  dropCost: number;
  transferCost: number;
  playCost: number;
  moveCooldown: number;
  openCost: number;
  harvestCost: number;
  organMatter: number;
};

// Default type with all potential properties.
export type Entity = {
  gameConfig?: GameConfig;
  core?: boolean;
  avatar?: number;
  name?: string;
  creationBlock?: number;
  readyBlock?: number;
  energy?: number;
  portable?: boolean;
  carriedBy?: string;
  realmId?: number;
};

export type Core = {
  core: boolean;
  avatar: number;
  name: string;
  creationBlock: number;
  readyBlock: number;
  energy: number;
  portable: boolean;
  carriedBy: string;
  realmId: number;
};

// - - - -

export type Entities = {
  [index: string]: Entity;
};

export type Cores = {
  [index: string]: Core;
};


// --- STORES -----------------------------------------------------------------

export const entities = writable({} as Entities);

export const gameConfig = derived(entities, ($entities) => {
  // "0x6a1a" => singleton GAIA entity
  // ... temp. "0x060d" => singleton G0D entity
  return $entities["0x060d"].gameConfig || {} as GameConfig
});

export const cores = derived(entities, ($entities) => {
  return Object.fromEntries(Object.entries($entities).filter(([key, entity]) => entity.core)) as Cores;
});


// --- FUNCTIONS -----------------------------------------------------------------

export const indexToID = (index: number) => get(network).world?.entities[index];

export const getCores = (address: string) =>
  Object.entries(get(entities)).filter(([id, ent]) => ent.core && ent.carriedBy === address);

export const getInventory = (address: string) =>
  Object.entries(get(entities)).filter(([id, ent]) => ent.carriedBy === address);