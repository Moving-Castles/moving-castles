<script lang="ts">
  import { t } from "../Dialog";
  import { playerAbilities } from "../../modules/player";
  import { staticContent } from "../../modules/staticContent";
  import { playSound } from "../../../howler";
  import { pickUp, consume } from "../../modules/player/actions";
  import Dialog from "../Dialog/Dialog.svelte";

  export let itemId: string;
  export let isOnMap = false;

  let dialogVisible = false;

  let info = {
    symbol: "",
    description: "",
  };

  const showDialog = () => (dialogVisible = !dialogVisible);

  const setInfo = (symbol: string, description: string) => {
    info.symbol = symbol;
    info.description = description;
  };

  setInfo("B", "Blank");

  const mouseenter = () => {
    playSound("cursor", "ui");
  };

  const click = () => {
    if (isOnMap) {
      pickUp(itemId);
    }
  };
  const icon = $staticContent.organs.find((o) => o.label === "blank")?.images[0];
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div on:click={showDialog} class="organ blank" on:click={click} on:mouseenter={mouseenter}>
  <img src={icon} alt="move" />
</div>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<Dialog bind:visible={dialogVisible}>
  <div class="description">{info.description}</div>
  {#if $playerAbilities.includes("abilityConsume")}
    <button on:click={() => consume(itemId)}>consume</button>
  {/if}
</Dialog>

<style lang="scss">
  .organ {
    height: 100%;
    width: 100%;
    overflow: hidden;
    font-size: 42px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;

    &.blank {
      background-color: rgb(126, 78, 114);
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
