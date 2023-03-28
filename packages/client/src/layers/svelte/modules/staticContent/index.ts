import { writable } from "svelte/store";

type Organ = {
    name: string;
    image: string;
}

export type StaticContent = {
    cores: string[];
    castles: string[];
    organs: Organ[];
}

export const staticContent = writable({} as StaticContent);

const localStaticContent = {
    cores: ["0.jpeg", "1.jpeg", "2.jpeg", "3.jpeg", "4.jpeg"],
    organs: [
        {
            name: "move",
            image: "/img/organs/2.png",
        },
        {
            name: "consume",
            image: "/img/organs/1.png",
        },
        {
            name: "blank",
            image: "/img/organs/3.png",
        }
    ],
    castles: []
}

export function initStaticContent() {
    staticContent.set(localStaticContent);
}