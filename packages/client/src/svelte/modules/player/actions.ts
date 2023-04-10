import { get } from "svelte/store"
import { addToSequencer, WorldFunctions } from "../../modules/actionSequencer"
import { atCapacity } from "../../components/Inventory";
import { toastMessage } from "../../modules/toast";

export function pickUp(itemId: string) {
  if (!get(atCapacity)) {
    addToSequencer(WorldFunctions.PickUp, [itemId]);
  } else {
    toastMessage({ type: "warning", message: "Your inventory is full", timestamp: performance.now() });
  }
}

export function consume(itemId: string) {
  addToSequencer(WorldFunctions.Consume, [itemId]);
}

export function play() {
  addToSequencer(WorldFunctions.Play);
}