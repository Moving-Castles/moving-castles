<script lang="ts">
  import { t } from "../Dialog";
  import { playerAbilities, playerCore } from "../../modules/player";
  import { pickUp, consume, play } from "../../modules/player/actions";
  import { playSound } from "../../../howler";
  import { Activity } from "../../modules/actionUpdater";
  import { staticContent } from "../../modules/staticContent";
  import Dialog from "../Dialog/Dialog.svelte";

  export let isOnMap = false;
  export let itemId: string;

  let dialogVisible = false;

  let markerEl: HTMLElement;
  let dialogEl: HTMLElement;

  let info = {
    symbol: "",
    description: "",
  };

  const setInfo = (symbol: string, description: string) => {
    info.symbol = symbol;
    info.description = description;
  };

  setInfo("P", "Ability: Play");

  const click = () => {
    dialogVisible = true;
  };

  const mouseenter = () => {
    playSound("cursor", "ui");
  };

  const icon = $staticContent.organs.find((o) => o.label === "play")?.images[0];
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="organ play" bind:this={markerEl} on:click={click} on:mouseenter={mouseenter}>
  <img src={icon} alt="play" />
</div>

<Dialog bind:visible={dialogVisible}>
  <div class="description">{info.description}</div>
  <button on:click={play}>{$playerCore.commit === Activity.Play ? "STOP" : "play"}</button>
  {#if $playerAbilities.includes("abilityConsume")}
    <button on:click={() => consume(itemId)}>consume</button>
  {/if}
</Dialog>

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

    &.play {
      background-color: #8ee096;
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
