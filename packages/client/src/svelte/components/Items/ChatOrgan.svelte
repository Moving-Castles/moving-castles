<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import tippy from "tippy.js";
  import "tippy.js/dist/tippy.css";
  import { playerAbilities } from "../../modules/player";
  import { pickUp, consume } from "../../modules/player/actions";
  import { playSound } from "../../../howler";
  import { staticContent } from "../../modules/staticContent";

  export let itemId: string;
  export let showDialog: boolean;
  export let isOnMap = false;

  let markerEl: HTMLElement;
  let dialogEl: HTMLElement;
  let toolTip: any;

  let info = {
    symbol: "",
    description: "",
  };

  const setInfo = (symbol: string, description: string) => {
    info.symbol = symbol;
    info.description = description;
  };

  setInfo("T", "Ability: Talk");

  const click = () => {
    if (isOnMap) {
      pickUp(itemId);
    }
  };

  const mouseenter = () => {
    playSound("cursor", "ui");
  };

  onMount(async () => {
    if (showDialog) {
      toolTip = tippy(markerEl, {
        content: dialogEl,
        interactive: true,
      });
    }
  });

  onDestroy(() => {
    if (toolTip) {
      toolTip.destroy();
    }
  });

  const icon = $staticContent.organs.find((o) => o.label === "chat")?.images[0];
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="organ chat" bind:this={markerEl} on:click={click} on:mouseenter={mouseenter}>
  <img src={icon} alt="chat" />
</div>

{#if showDialog && !isOnMap}
  <div class="dialog" bind:this={dialogEl}>
    <div class="description">{info.description}</div>
    {#if $playerAbilities.includes("abilityConsume")}
      <button on:click={() => consume(itemId)}>consume</button>
    {/if}
  </div>
{/if}

<style lang="scss">
  .organ {
    height: 100%;
    width: 100%;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;

    &.chat {
      background-color: #e08eda;
    }

    img {
      width: 100%;
      height: 100%;
    }

    &:hover {
      opacity: 0.9;
    }
  }
</style>
