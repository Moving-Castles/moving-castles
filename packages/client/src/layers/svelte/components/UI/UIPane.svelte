<script lang="ts">
  import CastleCompact from "../Castle/CastleCompact.svelte";
  import { castleExtended, popUpEntities } from "../UI";
  import { quadOut } from "svelte/easing";
  import { fly } from "svelte/transition";

  export let baseEntityId: string;
</script>

<div class:extended={$castleExtended} in:fly={{ duration: 200, y: 200, easing: quadOut }} class="castle">
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div
    on:click={() => {
      popUpEntities.set([]);
    }}
  >
    CLOSE
  </div>
  <CastleCompact {baseEntityId} />
</div>

<style lang="scss">
  .castle {
    flex-grow: 0;
    width: 460px;
    background: rgba(40, 40, 40, 1);
    height: calc(100vh - 250px);
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
