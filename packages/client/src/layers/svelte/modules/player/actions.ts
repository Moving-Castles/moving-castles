import { get } from "svelte/store"
import { addToSequencer } from "../../modules/actionSequencer";
import { atCapacity } from "../../components/Inventory";
import { toastMessage } from "../../modules/toast";

export function pickUp (itemId: string) {
  if (!get(atCapacity)) {
    addToSequencer("system.PickUp", [itemId]);
  } else {
    toastMessage({ type: "warning", message: "Your inventory is full", timestamp: performance.now() });
  }
}

export function consume (itemId: string) {
  addToSequencer("system.Consume", [itemId]);
}

export function play() {
  addToSequencer("system.Play");  
}