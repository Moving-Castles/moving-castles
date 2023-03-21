import { derived } from "svelte/store";
import { network } from "../network";
import type { Core, BaseEntity } from "../entities";
import { entities, cores } from "../entities";

// --- STORES -----------------------------------------------------------------

export const playerAddress = derived(network, ($network) => $network.network?.connectedAddress.get() || "0x0");

export const playerCore = derived(
  [entities, playerAddress],
  ([$entities, $playerAddress]) => $entities[$playerAddress] as Core
);

export const playerBaseEntity = derived([entities, playerCore], ([$entities, $playerCore]) => {
  if (!$entities || !$playerCore) return {} as BaseEntity;
  return $entities[$playerCore.carriedBy] as BaseEntity;
});

// Is the players core sharing base entity with another core?
export const multiCore = derived([cores, playerCore], ([$cores, $playerCore]) =>
  Object.values($cores).filter((e) => e.carriedBy == $playerCore.carriedBy).length > 1 ? true : false
);


const ABILITY_LIST = ["abilityMove", "abilityConsume", "abilityPlay"];

export const playerAbilities = derived([entities, playerCore], ([$entities, $playerCore]) => {
  const abilities: string[] = [];
  const inventory = Object.values($entities).filter((e) => e.carriedBy === $playerCore.carriedBy);

  ABILITY_LIST.forEach((a) => {
    if (inventory.find((item) => item[a])) {
      abilities.push(a);
    }
  });

  return abilities;
});
