import { writable } from "svelte/store";
import type { NetworkLayer } from "../../../network";

// --- STORES -----------------------------------------------------------------

export const network = writable({} as NetworkLayer);
export const blockNumber = writable(0);
export const ready = writable(false);
export const loadingMessage = writable("Loading");
