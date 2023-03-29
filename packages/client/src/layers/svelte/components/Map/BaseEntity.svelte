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
  import { popUpEntity } from "../UI";

  export let baseEntityId: string;
  export let baseEntity: any;

  let transferActive = false;
  let isPlayer = false;
  let isSame = false;
  let untraversable = false;
  let playing = false;

  $: playing = Object.values($cores)
    .filter((c) => c.carriedBy === baseEntityId)
    .some((c) => c.commit === Activity.Play);

  $: isPlayer = baseEntityId === $playerCore.carriedBy;

  $: isSame =
    $playerCore.carriedBy && $baseEntities[$playerCore.carriedBy]
      ? chebyshev($baseEntities[$playerCore.carriedBy].position, baseEntity.position) === 0
      : false;

  $: adjacent = isAdjacent($baseEntities[$playerCore.carriedBy].position, baseEntity.position);

  $: untraversable = Object.values($items).some((i) => i.carriedBy === baseEntityId && i.untraversable);

  $: if (isPlayer) {
    console.log("baseEntity.activity", baseEntity.activity);
  }
</script>

{#if transferActive}
  <Transfer
    {baseEntityId}
    on:close={() => {
      transferActive = false;
    }}
  />
{/if}

{#if untraversable}
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div
    class="base-entity-2 grid-item untraversable"
    on:click|stopPropagation={() => {
      // popUpEntity.set(baseEntityId);
    }}
  />
{:else}
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div
    class="base-entity-2 grid-item"
    class:player={isPlayer}
    class:active={baseEntity.activity && baseEntity.activity !== Activity.Idle}
    on:click|stopPropagation={() => {
      popUpEntity.set(baseEntityId);
    }}
    transition:scale={{ duration: 100, easing: quadOut }}
  >
    <img draggable="false" src="/img/bodies/small/3.png" alt="body" />
  </div>
{/if}

<style lang="scss">
  .base-entity-2 {
    aspect-ratio: 1;
    display: flex;
    justify-content: center;
    align-items: center;
    line-height: 0;
    cursor: pointer;
    object-fit: contain;
    padding: 10px;
    height: 400px;

    &.active {
      animation: color-change 0.2s infinite;
    }

    &.untraversable {
      width: 100%;
      height: 100%;
      background-image: url("/img/tiles/untraversable/1.png");
      pointer-events: none;
    }

    img {
      width: 100%;
      height: 100%;
      object-fit: contain;
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
