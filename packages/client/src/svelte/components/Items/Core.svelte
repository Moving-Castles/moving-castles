<script lang="ts">
  import { addressToColor } from "../../utils/misc";
  import type { Core } from "../../modules/entities";
  import { playSound } from "../../../howler";
  import { playerAddress } from "../../modules/player";
  import { idToName, idToAvatar } from "../../utils/name";
  import Dialog from "../Dialog/Dialog.svelte";

  export let itemId: string;
  export let item: Core;

  let dialogVisible = false;
  let info = {
    symbol: "",
    description: "",
  };

  const setInfo = (symbol: string, description: string) => {
    info.symbol = symbol;
    info.description = description;
  };

  setInfo(
    "*",
    itemId === $playerAddress ? idToName(itemId) + " (you)" : idToName(itemId) + ": " + item.energy + " energy"
  );

  const mouseenter = () => {
    playSound("friendly", "misc");
  };
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  class="core"
  class:self={itemId === $playerAddress}
  style={"background:" + addressToColor(itemId) + ";"}
  on:click={() => (dialogVisible = true)}
  on:mouseenter={mouseenter}
>
  <img draggable="false" class="core-avatar" src={idToAvatar(itemId)} alt="core" />
</div>

<Dialog bind:visible={dialogVisible}>
  <div class="description">{info.description}</div>
</Dialog>

<style lang="scss">
  .core {
    height: 100%;
    width: 100%;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;
    position: relative;

    &:hover {
      opacity: 0.9;
    }
  }

  .self {
    border: 1px solid white;
  }

  .core-avatar {
    height: 100%;
    width: 100%;
    object-fit: cover;
  }
</style>
