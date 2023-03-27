<script lang="ts">
  import UIBlockCounter from "./UIBlockCounter.svelte";
  import ActionSequencer from "../ActionSequencer/ActionSequencer.svelte";
  import CoreCompact from "../Core/CoreCompact.svelte";
  import CastleCompact from "../Castle/CastleCompact.svelte";
  import CastleExtended from "../Castle/CastleExtended.svelte";
  import { castleExtended, popUpEntity } from "../UI";
  import { quadOut } from "svelte/easing";
  import { fade, scale, slide, fly } from "svelte/transition";
</script>

<div class="pane" class:extended={$castleExtended} in:fly={{ duration: 200, y: 200, easing: quadOut }}>
  <!-- <div class="core">
    <CoreCompact />
  </div> -->

  <div class="castle">
    <!-- svelte-ignore a11y-click-events-have-key-events -->
    <div
      on:click={() => {
        popUpEntity.set("");
      }}
    >
      CLOSE
    </div>
    <!-- {#if $castleExtended}
      <CastleExtended />
    {:else} -->
    <CastleCompact baseEntityId={$popUpEntity} />
    <!-- {/if} -->
  </div>

  <!-- {#if !$castleExtended}
    <div class="actions">
      <UIBlockCounter />
      <ActionSequencer />
    </div>
  {/if} -->
</div>

<style lang="scss">
  .pane {
    background: rgba(40, 40, 40, 1);
  }

  .core {
    height: 50px;
    width: 100%;
    border-bottom: 1px solid white;
    overflow: hidden;
  }

  .castle {
    height: calc(100vh - 250px);
    width: 100%;
    overflow: scroll;
  }

  .actions {
    height: 200px;
    width: 100%;
    border-top: 1px solid white;
    overflow: scroll;
  }

  .extended .castle {
    height: calc(100vh - 50px);
  }
</style>
