<script lang="ts">
  import { addToSequencer } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";
  import Spinner from "./Spinner.svelte";

  export let itemId: string;
  export let isOnMap = false;

  enum BoxState {
    UNOPENED,
    OPENING,
  }

  let boxState: BoxState = BoxState.UNOPENED;

  function open() {
    playSound("eventGood", "ui");
    boxState = BoxState.OPENING;
    addToSequencer("system.Open", [itemId]);
  }

  function pickup() {
    addToSequencer("system.PickUp", [itemId]);
  }
  const click = () => {
    if (boxState === BoxState.OPENING) return;
    if (isOnMap) {
      pickup();
    } else {
      open();
    }
  };

  function mouseenter() {
    if (boxState === BoxState.OPENING) return;
    playSound("cursor", "ui");
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="loot-box" class:map={isOnMap} on:click|stopPropagation={click} on:mouseenter={mouseenter}>
  {#if boxState === BoxState.OPENING}
    <div class="opening-overlay">
      <div>
        <Spinner />
      </div>
    </div>
  {:else}
    ?
  {/if}
</div>

<style lang="scss">
  .loot-box {
    aspect-ratio: 1;
    height: 100vw;
    // width: 100%;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;
    background: red;

    &:hover {
      opacity: 0.9;
    }
  }

  .opening-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(255, 255, 255, 0.9);
    font-size: 50vw;
    color: black;
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>
