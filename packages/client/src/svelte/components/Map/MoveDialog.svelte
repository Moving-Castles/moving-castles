<script lang="ts">
  import type { GridTile } from "./index"
  import { quadOut } from "svelte/easing"
  import { scale } from "svelte/transition"
  import { addToSequencer, WorldFunctions } from "../../modules/actionSequencer"
  import { playerAbilities } from "../../modules/player"
  import { gameConfig } from "../../modules/entities"
  import { createEventDispatcher } from "svelte"

  export let tile: GridTile

  const dispatch = createEventDispatcher()

  function move() {
    addToSequencer(WorldFunctions.Move, [
      tile.coordinates.x,
      tile.coordinates.y,
    ])
    close()
  }

  function close() {
    dispatch("close", {})
  }
</script>

<div class="move-dialog" transition:scale={{ duration: 100, easing: quadOut }}>
  {#if $playerAbilities.includes("abilityMove")}
    <div>
      Destination x:{tile.coordinates.x}, y:{tile.coordinates.y}<br />
      Costs: {$gameConfig.moveCost} energy
      <br />
      <button class="success" on:click={move}>move</button>
      <button class="cancel" on:click={close}>abort</button>
    </div>
  {:else}
    <div>
      Sir, You lack Bipedal Creepods.
      <button class="cancel" on:click={close}
        >How can i aquire Bipedal Creepods?</button
      >
      <button class="cancel" on:click={close}>OK</button>
    </div>
  {/if}
</div>

<style lang="scss">
  .move-dialog {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translateX(-50%) translateY(-50%);
    background: red;
    height: 400px;
    width: 600px;
    padding: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 10000;
    font-size: 42px;
    box-shadow: 10px 10px 10px 0 rgba(0, 0, 0, 0.5);

    button {
      font-size: 42px;
      padding: 20px;
    }
  }
</style>
