import type { Writable } from "svelte/store"
import { writable, get } from "svelte/store"

const dummy = document.createElement('div')

export const position: Writable<{ x: number | undefined, y: number | undefined, top: number | undefined, left: number | undefined }> = writable({ top: 0, left: 0, x: 0, y: 0 })
export const mapElement: Writable<HTMLElement> = writable(dummy)

let rotation = 0;
let gestureStartRotation = 0;
let gestureStartScale = 0;
let posX = 0;
let posY = 0;
let scale = 1
let startX: number;
let startY: number;


const setZoom = () => {
  // Make sure scale does not dip
  if (scale < 0) scale = 0.25

  const parent = get(mapElement)
  const element = parent.querySelector('.map-container')
  const player = parent.querySelector('.player')

  const t = player?.parentElement?.offsetTop + player?.parentElement?.clientHeight / 2
  const l = player?.parentElement?.offsetLeft + player?.parentElement?.clientWidth / 2

  const origin = `${(l / element.clientWidth) * 100}% ${(t / element.clientHeight) * 100}%`
  const transform = `scale(${scale})`


  element.style.transformOrigin = origin
  element.style.transform = transform
}

const onWheel = (e) => {
  e.preventDefault();

  if (e.ctrlKey) {
    scale -= e.deltaY * 0.01
  } else {
    posX -= e.deltaX * 2;
    posY -= e.deltaY * 2;
  }

  setZoom()
}

const onGestureStart = (e) => {
  e.preventDefault();
  startX = e.pageX - posX;
  startY = e.pageY - posY;
  gestureStartRotation = rotation;
  gestureStartScale = scale;
}

const onGestureChange = (e) => {
  e.preventDefault();
  
  rotation = gestureStartRotation + e.rotation;
  scale = gestureStartScale * e.scale;

  posX = e.pageX - startX;
  posY = e.pageY - startY;

  setZoom();
}

const onGestureEnd = (e) => {
  e.preventDefault();
}

const pointerMove = (e: PointerEvent) => {
  const pos = get(position)
  const el = get(mapElement)

  // How far the mouse has been moved
  const dx = e.clientX - (pos?.x || 0);
  const dy = e.clientY - (pos?.y || 0);

  // Scroll the element
  el.scrollTop = (pos.top || 0) - dy;
  el.scrollLeft = (pos.left || 0) - dx;
}

const pointerUp = (e: PointerEvent) => {
  document.removeEventListener('pointermove', pointerMove);
  document.removeEventListener('pointerup', pointerUp);
}

function pointerDown (e: PointerEvent) {
  const el = get(mapElement)

  position.set({
      // The current scroll
      left: el?.scrollLeft,
      top: el?.scrollTop,
      // Get the current mouse position
      x: e.clientX,
      y: e.clientY,
  });

  document.addEventListener('pointermove', pointerMove);
  document.addEventListener('pointerup', pointerUp);
}

export const panzoom = (element: HTMLElement) => {
  mapElement.set(element)
  element.addEventListener('pointerdown', pointerDown)

  return {
    destroy: () => {
      element.removeEventListener('pointerdown', pointerDown)
    }
  }
}