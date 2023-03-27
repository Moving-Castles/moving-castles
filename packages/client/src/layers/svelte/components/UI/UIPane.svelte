<script lang="ts">
  import CastleCompact from "../Castle/CastleCompact.svelte";
  import { castleExtended, popUpEntity } from "../UI";
  import { quadOut } from "svelte/easing";
  import { fly } from "svelte/transition";
</script>

<div class="pane" class:extended={$castleExtended} in:fly={{ duration: 200, y: 200, easing: quadOut }}>
  <div class="castle">
    <!-- svelte-ignore a11y-click-events-have-key-events -->
    <div
      on:click={() => {
        popUpEntity.set("");
      }}
    >
      CLOSE
    </div>
    <CastleCompact baseEntityId={$popUpEntity} />
  </div>
</div>

<style lang="scss">
  .pane {
    background: rgba(40, 40, 40, 1);
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
