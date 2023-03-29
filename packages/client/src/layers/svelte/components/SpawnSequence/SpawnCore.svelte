<script lang="ts">
  import { onMount } from "svelte";
  import { fade } from "svelte/transition";
  import Typewriter from "svelte-typewriter";
  import { network } from "../../modules/network";
  import { spawnStage } from "../UI";
  import { playerCore, playerAddress } from "../../modules/player";
  import { idToName, idToAvatar } from "../../utils/name";
  import { playSound } from "../../../howler";
  import { staticContent } from "../../modules/staticContent";

  let typewriterDone = false;

  let coreIndex = 0;
  let counter = 0;

  onMount(async () => {
    $network.api?.spawn();
    setInterval(() => {
      coreIndex = coreIndex == $staticContent.cores.length - 1 ? 0 : coreIndex + 1;
      counter++;
    }, 100);
  });
</script>

{#if $playerCore && counter > 20}
  <div class="demi3" in:fade>
    <img draggable="false" src="/img/game-master/demi.jpg" alt="core" />
    <Typewriter
      mode="cascade"
      interval={70}
      on:done={() => {
        typewriterDone = true;
      }}
    >
      <p>very unfortunate ...</p>
      <p>oh well....</p>
    </Typewriter>
  </div>
{/if}

<div class="spawn-sequence" in:fade>
  {#if $playerCore && counter > 20}
    <img draggable="false" src={idToAvatar($playerAddress)} alt="core" />
    <div class="core-item"><strong>{idToName($playerAddress)}</strong></div>
    <button
      on:click={() => {
        playSound("selectTwo", "ui");
        spawnStage.set(4);
      }}>Accept your fate</button
    >
  {:else}
    <img draggable="false" src={$staticContent.cores[coreIndex]} alt="core" />
  {/if}
</div>

<style lang="scss">
  .spawn-sequence {
    width: 100%;
    height: 100%;
    text-align: center;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 32px;
    flex-direction: column;
    color: black;
    color: white;

    img {
      height: 500px;
    }

    button {
      margin-top: 20px;
      border: 0;
      font-size: 32px;
      background: transparent;
      border: 2px solid white;
      color: black;
      color: white;
      padding: 10px 30px;
      cursor: pointer;
      font-family: var(--font-family);

      &:hover {
        background: black;
        color: white;
      }
    }
  }

  p {
    margin: 0;
  }

  .demi3 {
    position: fixed;
    top: 10px;
    left: 10px;

    img {
      height: 300px;
    }
  }
</style>
