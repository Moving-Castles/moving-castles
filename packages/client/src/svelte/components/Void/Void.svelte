<script lang="ts">
  import { network } from "../../modules/network"
  import { entities } from "../../modules/entities"
  import { WorldFunctions } from "../../modules/actionSequencer"
  import { cores } from "../../modules/entities"
  import { playerAddress } from "../../modules/player"
  import OffChain from "../OffChain/OffChain.svelte"

  function count(val) {
    $network.worldSend(WorldFunctions.Count, [val])
  }

  let myArray: number[] = []
  for (let i = 1; i <= 20; i++) {
    myArray.push(i)
  }
</script>

<div class="void">
  {#each myArray as button}
    <button
      on:click={() => {
        count(button)
      }}
      class:counted={$entities["0x060d"]?.counter >= button}
    >
      {button}
    </button>
  {/each}
</div>

<div class="info">
  <hr />
  <div>ON CHAIN CORES:</div>
  {#each Object.entries($cores) as [key, value]}
    <div class="core">
      <div class="core__name">
        {key}
        {#if key === $playerAddress}(YOU){/if}
      </div>
    </div>
  {/each}
  <hr />
  <!-- <OffChain /> -->
  <hr />
</div>

<style lang="scss">
  .void {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: #0000ff;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 18px;

    &.active {
      background: orangered;
    }
  }

  button {
    font-size: 32px;
    display: block;
    margin: 10px;
    cursor: pointer;

    &.counted {
      background: red;
    }
  }

  .pane {
    width: 50%;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    top: 0;

    &.left {
      left: 0;
    }
    &.right {
      right: 0;
    }
  }

  .mid {
    position: fixed;
    left: 50%;
    bottom: 10%;
    background: red;
    transform: translateX(-50%);
  }

  .info {
    position: fixed;
    top: 5px;
    right: 5px;
    font-size: 9px;
    padding: 5px;
    background: lightgrey;
    color: black;
  }
</style>
