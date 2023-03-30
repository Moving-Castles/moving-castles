<script lang="ts">
  import { fade } from "svelte/transition";
  import { ready } from "../../modules/network";
  import Typewriter from "svelte-typewriter";
  import { spawnStage } from "../UI";
  import { playerCore } from "../../modules/player";
  import { entities } from "../../modules/entities";
  import { playSound } from "../../../howler";
  import { idToBody } from "../../utils/name";

  import Item from "../Items/ItemSelector.svelte";

  export let nextSpawnStage = 6;
  export let buttonText = "THANK YOU";

  let typewriterDone = false;
  let skip = false;
  let organsDone = false;
  let inventory;
  $: inventory = Object.entries($entities).filter(
    ([itemId, item]) => item.carriedBy === $playerCore.carriedBy && !item.core
  );

  $: if (!Object.values($entities).find((e) => e.carriedBy === $playerCore.carriedBy && e.loot)) {
    organsDone = true;
  }

  const next = () => {
    playSound("selectThree", "ui");
    spawnStage.set(nextSpawnStage);
  };
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="spawn-slide"
  in:fade
  on:click={() => {
    skip = true;
  }}
>
  <!-- BEFORE -->
  <img draggable="false" src={idToBody($playerCore.carriedBy)} alt="body" />

  {#if skip}
    <!-- SKIP TEXT -->
    <p>..and you will need a body</p>
    <p>I will grant you three gifts.</p>
    <p>I hope they are useful</p>
  {:else}
    <!-- TYPEWRITER TEXT -->
    <Typewriter
      mode="cascade"
      interval={70}
      on:done={() => {
        typewriterDone = true;
      }}
    >
      <p>..and you will need a body</p>
      <p>I will grant you three gifts.</p>
      <p>I hope they are useful</p>
    </Typewriter>
  {/if}

  {#if $ready && (typewriterDone || skip)}
    <div class="inventory">
      {#each inventory as [itemId, item] (itemId)}
        <Item {itemId} {item} showDialog={false} />
      {/each}
    </div>
  {/if}

  {#if $ready && (typewriterDone || skip) && organsDone}
    <!-- BUTTON -->
    <button on:click={next}>
      {buttonText}
    </button>
  {/if}
</div>

<style lang="scss">
  .spawn-slide {
    width: 100%;
    height: 100%;
    text-align: center;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 32px;
    flex-direction: column;
    color: white;

    button {
      margin-top: 10px;
      border: 0;
      font-size: 32px;
      background: transparent;
      border: 2px solid white;
      color: white;
      padding: 10px 30px;
      cursor: pointer;
      font-family: var(--font-family);

      &:hover {
        background: white;
        color: black;
      }
    }
  }

  :global(.spawn-slide img) {
    height: 300px;
    margin-top: 10px;
    margin-bottom: 10px;
  }

  :global(.spawn-slide p) {
    margin: 0;
  }

  .inventory {
    margin-top: 20px;
    margin-bottom: 20px;
    display: flex;
  }
</style>
