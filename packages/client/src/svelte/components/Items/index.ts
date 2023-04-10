import type { Writable } from "svelte/store"
import { writable } from "svelte/store"

export const dragging: Writable<string> = writable('');