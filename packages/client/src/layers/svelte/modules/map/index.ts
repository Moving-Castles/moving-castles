import type { Writable } from "svelte/store"
import { writable, get } from "svelte/store"

const dummy = document.createElement('div')

export const position: Writable<{ x: number | undefined, y: number | undefined, top: number | undefined, left: number | undefined }> = writable({ top: 0, left: 0, x: 0, y: 0 })
export const mapElement: Writable<HTMLElement> = writable(dummy)

const pointerMove = (e: PointerEvent) => {
  console.log('move')
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
  console.log('up')
  document.removeEventListener('pointermove', pointerMove);
  document.removeEventListener('pointerup', pointerUp);
}

const pointerDown = (e: PointerEvent) => {
  const el = get(mapElement)
  console.log('down', el)

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
  console.log('init')
  mapElement.set(element)
  element.addEventListener('pointerdown', pointerDown)

  return {
    destroy: () => {
      element.removeEventListener('pointerdown', pointerDown)
    }
  }
}