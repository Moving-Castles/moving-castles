<script lang="ts">
  import type { Entity } from "../../modules/entities";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { playerCore } from "../../modules/player";
  import { baseEntities } from "../../modules/entities";
  import { isAdjacent } from "../../utils/space";
  import { playSound } from "../../../howler";
  import Spinner from "./Spinner.svelte";
  import { staticContent } from "../../modules/staticContent";
  import { pickUp } from "../../modules/player/actions";
  import { toastMessage } from "../../modules/toast";

  export let itemId: string;
  export let item: Entity;
  export let isOnMap = false;

  enum BoxState {
    UNOPENED,
    OPENING,
  }

  let boxState: BoxState = BoxState.UNOPENED;

  function open() {
    // Is this my box?
    playSound("eventGood", "ui");
    boxState = BoxState.OPENING;
    addToSequencer("system.Open", [itemId]);
  }

  const click = () => {
    if (boxState === BoxState.OPENING) return;
    if (isOnMap) {
      if (!isAdjacent($baseEntities[$playerCore.carriedBy].position, item.position)) {
        toastMessage({ type: "warning", message: "Loot is out of reach", timestamp: performance.now() });
        return;
      }
      pickUp(itemId);
    } else {
      open();
    }
  };

  function mouseenter() {
    if (boxState === BoxState.OPENING) return;
    playSound("cursor", "ui");
  }

  const icon = $staticContent.organs.find((o) => o.type === "loot")?.w400;
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div
  draggable="true"
  class="loot-box"
  class:carried={item.carriedBy}
  class:map={isOnMap}
  on:click|stopPropagation={click}
  on:mouseenter={mouseenter}
>
  {#if boxState === BoxState.OPENING}
    <div class="opening-overlay">
      <div>
        <Spinner />
      </div>
    </div>
  {:else}
    <img src={icon} alt="lootbox" />
  {/if}
</div>

<style lang="scss">
  .loot-box {
    aspect-ratio: 1;
    height: 100%;
    width: 100%;
    overflow: hidden;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;

    &.carried {
      animation: color-change 0.5s infinite alternate linear;
    }

    img {
      height: 100%;
      width: 100%;
    }

    &:hover {
      opacity: 0.9;
    }
  }

  .opening-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(255, 255, 255, 0.9);
    font-size: 50vw;
    color: black;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  @keyframes color-change {
    0% {
      background-color: rgba(0, 0, 0, 0);
    }
    100% {
      background-color: #ff008c;
    }
  }
</style>
