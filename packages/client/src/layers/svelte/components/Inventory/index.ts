import type { Writable, Derived } from "svelte/store"
import { writable, derived } from "svelte/store"

export const carryingCapacity: Writable<number> = writable(0)
export const itemCount: Writable<number> = writable(0)
export const atCapacity: Derived<boolean> = derived([carryingCapacity, itemCount], ([cc, ic]) => cc === ic)