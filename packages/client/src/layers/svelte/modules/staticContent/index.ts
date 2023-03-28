import { writable } from "svelte/store";

export type StaticContent = {
    cores: string[];
    castles: string[];
}

export const staticContent = writable({} as StaticContent);

const localStaticContent = {
    cores: ["0.jpeg", "1.jpeg", "2.jpeg", "3.jpeg", "4.jpeg"],
    castles: []
}

export function initStaticContent() {
    staticContent.set(localStaticContent);
}