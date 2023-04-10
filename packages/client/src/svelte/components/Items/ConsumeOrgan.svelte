<script lang="ts">
  import { t } from "../Dialog";
  import { isSpawned } from "../UI";
  import { playerAbilities } from "../../modules/player";
  import { pickUp, consume } from "../../modules/player/actions";
  import { staticContent } from "../../modules/staticContent";
  import { playSound } from "../../../howler";
  import Dialog from "../Dialog/Dialog.svelte";

  export let itemId: string;
  export let showDialog: boolean;
  export let isOnMap = false;

  let dialogVisible = false;

  let info = {
    symbol: "",
    description: "",
  };

  const setInfo = (symbol: string, description: string) => {
    info.symbol = symbol;
    info.description = description;
  };

  setInfo("C", "Ability: Consume");

  const mouseenter = () => {
    playSound("cursor", "ui");
  };

  const click = () => {
    dialogVisible = true;
    // if (isOnMap) {
    //   pickUp(itemId);
    // }
  };

  const icon = $staticContent.organs.find((o) => o.label === "consume")?.images[0];
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="organ consume" on:click={click} on:mouseenter={mouseenter}>
  <img src={icon} alt="consume" />
</div>

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

    &.consume {
      background-color: #00ff00;
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
