/*
 *  Central store for all entities in the game.
 * 
 */

import type { Coord } from "@latticexyz/utils";
import { writable, get, derived } from "svelte/store";
import { network } from "../network";

// --- TYPES -----------------------------------------------------------------

export enum Activity {
  Play,
}

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
};

// Default type with all potential properties.
export type Entity = {
  gameConfig?: GameConfig;
  creationBlock?: number;
  readyBlock?: number;
  matter?: number;
  energy?: number;
  position?: Coord;
  portable?: boolean;
  carryingCapacity?: number;
  core?: boolean;
  commit?: Activity;
  carriedBy?: string;
  inventory?: string[];
  abilityMove?: boolean;
  abilityConsume?: boolean;
  abilityPlay?: boolean;
  abilityChat?: boolean;
  untraversable?: boolean;
  loot?: boolean;
  goal?: number;
  point?: number;
};

export type Core = {
  core: true;
  portable: true;
  creationBlock: number;
  readyBlock: number;
  energy: number;
  carriedBy: string;
  point: number;
  commit?: Activity;
};

export type BaseEntity = {
  position: Coord;
  carryingCapacity: number;
  inventory: string[];
};

export type Item = {
  portable: true;
  matter?: number;
  position?: Coord;
  carriedBy?: string;
  abilityMove?: boolean;
  abilityConsume?: boolean;
  abilityPlay?: boolean;
  abilityChat?: boolean;
  untraversable?: boolean;
  loot?: boolean;
  goal?: number;
};

export type FreeItem = Omit<Item, 'carriedBy'> & {
  position: Coord;
};

export type Untraversable = {
  untraversable: true;
  position: Coord;
};

// - - - -

export type Entities = {
  [index: string]: Entity;
};

export type Cores = {
  [index: string]: Core;
};

export type BaseEntities = {
  [index: string]: BaseEntity;
};

export type Items = {
  [index: string]: Item;
};

export type Untraversables = {
  [index: string]: Untraversable;
};

export type FreeItems = {
  [index: string]: FreeItem;
};

// --- STORES -----------------------------------------------------------------

export const entities = writable({} as Entities);

export const gameConfig = derived(entities, ($entities) => {
  // "0x6a1a" => singleton GAIA entity
  return $entities["0x6a1a"].gameConfig || {} as GameConfig
});

export const cores = derived(entities, ($entities) => {
  return Object.fromEntries(Object.entries($entities).filter(([key, entity]) => entity.core)) as Cores;
});

export const baseEntities = derived(entities, ($entities) => {
  return Object.fromEntries(
    Object.entries($entities).filter(([key, entity]) => entity.carryingCapacity)
  ) as BaseEntities;
  // @todo add inventory array to entities
});

export const items = derived(entities, ($entities) => {
  return Object.fromEntries(Object.entries($entities).filter(([key, entity]) => entity.portable)) as Items;
});

export const freeItems = derived(entities, ($entities) => {
  return Object.fromEntries(
    Object.entries($entities).filter(([key, entity]) => entity.portable && entity.position)
  ) as FreeItems;
});

export const untraversables = derived(entities, ($entities) => {
  return Object.fromEntries(
    Object.entries($entities).filter(([key, entity]) => entity.untraversable)
  ) as Untraversables;
});

// --- FUNCTIONS -----------------------------------------------------------------

export const indexToID = (index: number) => get(network).world?.entities[index];

export const getCores = (address: string) =>
  Object.entries(get(entities)).filter(([id, ent]) => ent.core && ent.carriedBy === address);

export const getInventory = (address: string) =>
  Object.entries(get(entities)).filter(([id, ent]) => ent.carriedBy === address);