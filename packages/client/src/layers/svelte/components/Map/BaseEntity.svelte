<script lang="ts">
  import { quadOut } from "svelte/easing";
  import { scale } from "svelte/transition";
  import { Activity } from "../../modules/actionUpdater";
  import { cores } from "../../modules/entities";
  import { chebyshev, isAdjacent } from "../../utils/space";
  import { items, baseEntities } from "../../modules/entities";
  import { playerCore } from "../../modules/player";
  import { addressToColor } from "../../utils/misc";

  import Item from "../Items/ItemSelector.svelte";
  import Transfer from "./TransferDialog.svelte";
  import { popUpEntities } from "../UI";

  export let baseEntityId: string;
  export let baseEntity: any;

  // let transferActive = true;
  let isPlayer = false;
  let isSame = false;
  let untraversable = false;
  let playing = false;

  const handleEntityClick = () => {
    if (adjacent) {
      popUpEntities.set([baseEntityId, $playerCore.carriedBy]);
    } else {
      popUpEntities.set([baseEntityId]);
    }
  };

  $: playing = Object.values($cores)
    .filter((c) => c.carriedBy === baseEntityId)
    .some((c) => c.commit === Activity.Play);

  $: isPlayer = baseEntityId === $playerCore.carriedBy;

  $: isSame =
    $playerCore.carriedBy && $baseEntities[$playerCore.carriedBy]
      ? chebyshev($baseEntities[$playerCore.carriedBy].position, baseEntity.position) === 0
      : false;

  // Is this baseentities position adj to players?
  $: adjacent = isAdjacent(baseEntity.position, $baseEntities[$playerCore.carriedBy].position);

  $: untraversable = Object.values($items).some((i) => i.carriedBy === baseEntityId && i.untraversable);

  $: if (isPlayer) {
    console.log("baseEntity.activity", baseEntity.activity);
  }
</script>

<!-- {#if transferActive}
  <Transfer
    {baseEntityId}
    on:close={() => {
      transferActive = false;
    }}
  />
{/if} -->

{#if untraversable}
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div
    class="base-entity grid-item untraversable"
    on:click|stopPropagation={() => {
      // popUpEntities.set(baseEntityId);
    }}
  />
{:else}
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div
    class="base-entity grid-item"
    class:debug={import.meta.env.DEV}
    class:player={isPlayer}
    class:active={baseEntity.activity && baseEntity.activity !== Activity.Idle}
    on:click|stopPropagation={handleEntityClick}
    transition:scale={{ duration: 100, easing: quadOut }}
  >
    <div class="shadow" />
    <img class="body" draggable="false" src="/img/bodies/small/3.png" alt="body" />
  </div>
{/if}

<style lang="scss">
  .base-entity {
    aspect-ratio: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    line-height: 0;
    cursor: pointer;
    object-fit: contain;
    padding: 10px;
    height: 400px;
    position: relative;

    &.player.debug {
      border: 1px solid red;
    }

    &.active {
      animation: color-change 0.2s infinite;
    }

    &.untraversable {
      width: 100%;
      height: 100%;
      background-image: url("/img/tiles/untraversable/1.png");
      pointer-events: none;
    }

    .body {
      width: 100%;
      height: 100%;
      object-fit: contain;
      transform: translateY(-30%);
    }

    .shadow {
      display: block;
      width: 200px;
      height: 80px;
      background-color: rgba(0, 0, 0, 0.5);
      filter: blur(20px);
      border-radius: 100%;
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, 0);
    }
  }

  @keyframes color-change {
    0% {
      filter: invert(0);
    }

    100% {
      filter: invert(1);
    }
  }
</style>
