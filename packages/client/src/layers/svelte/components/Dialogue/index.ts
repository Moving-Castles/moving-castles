import type { Writable } from "svelte/store"
import tippy, {followCursor} from 'tippy.js';
import { writable } from "svelte/store"
import type { SingleTarget } from "tippy.js"

export const dialogue: Writable<string> = writable('')

export const t = function (element: SingleTarget, enable: boolean) {
  const d = element.querySelector('.dialog')

  if (!enable) {
    d.style.display = 'none'
    return
  }

  const tooltip = tippy(element, {
    content: d,
    inertia: true,
    interactive: true,
    trigger: 'click',
    followCursor: 'initial',
    plugins: [followCursor],
  })


  return {
    destroy () {
      // element.removeEventListener('pointerdown', toggle)
      tooltip.destroy()
    }
  }
}