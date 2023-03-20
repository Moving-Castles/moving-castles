<script lang="ts">
  import UIBlockCounter from "./UIBlockCounter.svelte";
  import ActionSequencer from "../ActionSequencer/ActionSequencer.svelte";
  import CoreCompact from "../Core/CoreCompact.svelte";
  import CastleCompact from "../Castle/CastleCompact.svelte";
  import CastleExtended from "../Castle/CastleExtended.svelte";
  import { castleExtended } from "../UI";
</script>

<div class="pane" class:extended={$castleExtended}>
  <div class="core">
    <CoreCompact />
  </div>

  <div class="castle">
    {#if $castleExtended}
      <CastleExtended />
    {:else}
      <CastleCompact />
    {/if}
  </div>

  {#if !$castleExtended}
    <div class="actions">
      <UIBlockCounter />
      <ActionSequencer />
    </div>
  {/if}
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
