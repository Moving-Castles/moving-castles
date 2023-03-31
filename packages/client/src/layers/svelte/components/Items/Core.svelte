<script lang="ts">
  import { addressToColor } from "../../utils/misc";
  import type { Core } from "../../modules/entities";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";
  import { playerAddress } from "../../modules/player";
  import { idToName, idToAvatar } from "../../utils/name";
  import { t } from "../Dialogue";

  export let itemId: string;
  export let item: Core;

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
  on:mouseenter={mouseenter}
  use:t
>
  <img draggable="false" class="core-avatar" src={idToAvatar(itemId)} alt="core" />

  <div class="dialog">
    <div class="description">{info.description}</div>
  </div>
</div>

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
