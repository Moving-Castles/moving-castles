<script lang="ts">
  import { shortenAddress, addressToColor } from "../../utils/misc";
  import Inventory from "../Inventory/Inventory.svelte";
  import { seedToCastleName } from "../../utils/name";
  import { castleExtended } from "../UI";

  export let baseEntityId: string;
  export let draggingOver: boolean;

  function extendCastle() {
    castleExtended.set(true);
  }
</script>

<div class="castle-compact" class:draggingOver>
  {#if baseEntityId}
    <div class="header">
      <div class="pfp" style={"background:" + addressToColor(baseEntityId) + ";"} />
      CASTLE:<strong> {seedToCastleName(baseEntityId)}</strong>
    </div>

    <Inventory {baseEntityId} {draggingOver} showCapacity={true} showEmptySlots={true} />
  {/if}
</div>

<style lang="scss">
  .castle-compact {
    padding: 10px;
    position: relative;

    .play {
      font-size: 18px;
      margin-top: 10px;
      margin-bottom: 10px;
    }

    .header {
      font-size: 18px;
      font-weight: 1000;
      margin-bottom: 30px;

      .pfp {
        display: inline-block;
        height: 40px;
        width: 40px;
        position: relative;
        top: 15px;
        border-radius: 50%;
      }
    }
  }
</style>
