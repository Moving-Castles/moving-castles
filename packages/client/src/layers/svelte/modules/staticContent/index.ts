import { writable, derived } from "svelte/store";

type Asset = {
    label: string;
    images: string[];
}

export type StaticContent = {
    cores: string[];
    organs: Asset[];
    bodies: Asset[];
    tiles: Asset[];
}

export const staticContent = writable({} as StaticContent);

const localStaticContent = {
    cores: ["/img/cores/0.jpeg", "/img/cores/1.jpeg", "/img/cores/2.jpeg", "/img/cores/3.jpeg", "/img/cores/4.jpeg"],
    organs: [
        {
            label: "move",
            images: ["/img/organs/move/1.png"]
        },
        {
            label: "consume",
            images: ["/img/organs/consume/1.png"]
        },
        {
            label: "blank",
            images: ["/img/organs/blank/1.png"]
        },
        {
            label: "play",
            images: ["/img/organs/play/1.png"]
        },
        {
            label: "chat",
            images: ["/img/organs/chat/1.png"]
        },
        {
            label: "parasite",
            images: ["/img/organs/parasite/1.png"]
        },
        {
            label: "regen",
            images: ["/img/organs/regen/1.png"]
        },
        {
            label: "goal",
            images: ["/img/organs/goal/1.png"]
        },
        {
            label: "lootbox",
            images: ["/img/organs/lootbox/1.png"]
        },
        {
            label: "trash",
            images: ["/img/organs/trash/1.png",
                "/img/organs/trash/2.png",
                "/img/organs/trash/3.png",
                "/img/organs/trash/4.png",
                "/img/organs/trash/5.png",
                "/img/organs/trash/6.png",
                "/img/organs/trash/7.png",
                "/img/organs/trash/8.png",
                "/img/organs/trash/9.png",
                "/img/organs/trash/10.png",
                "/img/organs/trash/11.png",
                "/img/organs/trash/12.png",
            ]
        },

    ],
    bodies: [
        {
            label: "small",
            images: ["/img/bodies/small/1.png",
                "/img/bodies/small/2.png",
                "/img/bodies/small/3.png",
                "/img/bodies/small/4.png"
            ]
        },
        {
            label: "medium",
            images: ["/img/bodies/medium/1.png",
                "/img/bodies/medium/2.png",
                "/img/bodies/medium/3.png"
            ]
        },
        {
            label: "large",
            images: ["/img/bodies/large/1.png"]
        }
    ],
    tiles: [
        {
            label: "normal",
            images: ["/img/tiles/normal/1.png"]
        },
        {
            label: "occupied",
            images: ["/img/tiles/occupied/1.png"]
        },
        {
            label: "untraversable",
            images: ["/img/tiles/untraversable/1.png"]
        },
    ]
}

export function initStaticContent() {
    staticContent.set(localStaticContent);
}

export const allOrganIcons = derived(staticContent, $staticContent => {
    if (!$staticContent.organs || $staticContent.organs.length === 0) return [];
    return $staticContent.organs.flatMap(o => o.images);
});