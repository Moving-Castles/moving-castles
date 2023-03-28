import type { Writable } from "svelte/store"
import tippy, {followCursor} from 'tippy.js';
import { writable } from "svelte/store"
import type { SingleTarget, Tippy } from "tippy.js"

export const dialogue: Writable<Tippy | undefined> = writable('')

export const t = function (element: SingleTarget, enable: boolean = true) {
  const d = element.querySelector('.dialog')

  if (!enable) {
    d.style.display = 'none'
    return
  }

  const tt = tippy(element, {
    content: d,
    inertia: true,
    interactive: true,
    trigger: 'click',
    followCursor: 'initial',
    plugins: [followCursor],
    onShow(instance) {
      setTimeout(instance.hide, 5000)
    },
  
  })


  return {
    destroy () {
      // element.removeEventListener('pointerdown', toggle)
      tt.destroy()
    }
  }
}