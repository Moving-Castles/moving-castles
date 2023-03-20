<script lang="ts">
  import { fade } from "svelte/transition";
  import { ready } from "../../modules/network";
  import Typewriter from "svelte-typewriter";
  import { spawnStage } from "../UI";
  import { playSound } from "../../../howler";

  export let nextSpawnStage: number;
  export let buttonText = "OK";

  let typewriterDone = false;
  let skip = false;

  const next = () => {
    playSound("selectTwo", "ui");
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
  <slot name="before" />

  {#if skip}
    <!-- SKIP TEXT -->
    <slot name="text" />
  {:else}
    <!-- TYPEWRITER TEXT -->
    <Typewriter
      mode="cascade"
      interval={70}
      on:done={() => {
        typewriterDone = true;
      }}
    >
      <slot name="text" />
    </Typewriter>
  {/if}

  {#if $ready && (typewriterDone || skip)}
    <!-- AFTER -->
    <slot name="after" />
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
    color: black;

    button {
      margin-top: 10px;
      border: 0;
      font-size: 32px;
      background: transparent;
      border: 2px solid black;
      color: black;
      padding: 10px 30px;
      cursor: pointer;
      font-family: var(--font-family);

      &:hover {
        background: black;
        color: white;
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
</style>
