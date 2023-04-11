<script lang="ts">
  import { quadOut } from "svelte/easing";
  import { scale } from "svelte/transition";
  import { Activity } from "../../modules/actionUpdater";
  import { cores } from "../../modules/entities";
  import { chebyshev, isAdjacent } from "../../utils/space";
  import { items, baseEntities, entities } from "../../modules/entities";
  import { playerCore } from "../../modules/player";
  import { idToBodyIndex } from "../../utils/name";
  import { staticContent } from "../../modules/staticContent";

  import CoreAvatar from "../../components/Core/CoreAvatar.svelte";
  import { popUpEntities } from "../UI";

  export let baseEntityId: string;
  export let baseEntity: any;

  // let transferActive = true;
  let isPlayer = false;
  let isSame = false;
  let untraversable = false;

  const handleEntityClick = () => {
    if (adjacent) {
      popUpEntities.set([$playerCore.carriedBy, baseEntityId]);
    } else {
      popUpEntities.set([baseEntityId]);
    }
  };

  $: carryingCores = Object.entries($entities).filter(([itemId, item]) => item.carriedBy === baseEntityId && item.core);

  $: isPlayer = baseEntityId === $playerCore.carriedBy;

  $: isSame =
    $playerCore.carriedBy && $baseEntities[$playerCore.carriedBy]
      ? chebyshev($baseEntities[$playerCore.carriedBy].position, baseEntity.position) === 0
      : false;

  // Is this baseentities position adj to players?
  $: adjacent = isAdjacent(baseEntity.position, $baseEntities[$playerCore.carriedBy].position);

  $: untraversable = Object.values($items).some((i) => i.carriedBy === baseEntityId && i.untraversable);
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
    <img draggable="false" class="body" src={$staticContent.bodies[idToBodyIndex(baseEntityId)].w800} alt="body" />
  </div>

  <div class="cores-display">
    <!-- CORES -->
    {#each carryingCores as [address, item]}
      <CoreAvatar {address} />
    {/each}
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
      transform: translateY(-15%);
    }

    .shadow {
      display: block;
      width: 200px;
      height: 80px;
      background-color: rgba(0, 0, 0, 0.5);
      filter: blur(10px);
      border-radius: 100%;
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, 90%);
    }
  }

  .cores-display {
    position: absolute;
    bottom: 0;
    display: flex;
    padding: 40px;
    justify-content: space-between;
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
