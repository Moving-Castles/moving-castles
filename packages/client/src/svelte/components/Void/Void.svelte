<script lang="ts">
  import { network } from "../../modules/network"
  import { entities } from "../../modules/entities"
  import { WorldFunctions } from "../../modules/actionSequencer"
  import { cores } from "../../modules/entities"
  import { playerAddress } from "../../modules/player"
  import OffChain from "../OffChain/OffChain.svelte"

  const BODY_ONE =
    "0x0000000000000000000000000000000000000000000000000000000000000001"
  const BODY_TWO =
    "0x0000000000000000000000000000000000000000000000000000000000000002"

  let ready = false
  $: {
    ready =
      Object.values($entities).find(entity => entity.carriedBy === BODY_ONE) &&
      Object.values($entities).find(entity => entity.carriedBy === BODY_TWO)
  }

  let active = false
  $: {
    active = $entities["0x0666"]?.active
  }

  let done = false
  $: {
    done = $entities["0x01"].health == 0 || $entities["0x02"].health == 0
  }

  function joinBodyOne() {
    $network.worldSend(WorldFunctions.Join, [1])
  }

  function joinBodyTwo() {
    $network.worldSend(WorldFunctions.Join, [2])
  }

  function startMatch() {
    $network.worldSend(WorldFunctions.Start, [])
  }

  function endMatch() {
    $network.worldSend(WorldFunctions.End, [])
  }

  function attack() {
    $network.worldSend(WorldFunctions.Attack, [])
  }
</script>

<div class="void" class:active={$entities["0x0666"]?.active}>
  <div>
    <div class="pane left">
      <div>
        <button on:click={joinBodyOne}>BODY 1</button>
        {#if active}
          <div>
            {$entities["0x01"]?.health}
          </div>
        {/if}
        {#each Object.entries($cores) as [key, value]}
          {#if value.carriedBy === BODY_ONE}
            <div class="core">
              <div class="core__name">
                {key}
                {#if key === $playerAddress}(YOU){/if}
              </div>
            </div>
          {/if}
        {/each}
      </div>
    </div>

    <div class="pane right">
      <div>
        <button on:click={joinBodyTwo}>BODY 2</button>
        {#if active}
          <div>
            {$entities["0x02"]?.health}
          </div>
        {/if}
        {#each Object.entries($cores) as [key, value]}
          {#if value.carriedBy === BODY_TWO}
            <div class="core">
              <div class="core__name">
                {key}
                {#if key === $playerAddress}(YOU){/if}
              </div>
            </div>
          {/if}
        {/each}
      </div>
    </div>

    <div class="mid">
      {#if active}
        MATCH
      {:else}
        LOBBY
      {/if}
      {#if ready}
        {#if !active}
          <button on:click={startMatch}>START</button>
        {:else if done}
          <button on:click={endMatch}>END</button>
        {/if}
      {/if}
      {#if active}
        <button on:click={attack}>ATTACK</button>
      {/if}
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
      <OffChain />
      <hr />
    </div>
  </div>
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
