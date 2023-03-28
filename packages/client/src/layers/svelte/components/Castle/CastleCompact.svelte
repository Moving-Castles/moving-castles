<script lang="ts">
  import { Activity } from "../../modules/actionUpdater";
  import { playerCore, playerBaseEntity, playerAddress } from "../../modules/player";
  import { shortenAddress, addressToColor } from "../../utils/misc";
  import Inventory from "../Inventory/Inventory.svelte";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { seedToCastleName } from "../../utils/name";
  import { castleExtended } from "../UI";

  export let baseEntityId: string;

  function play() {
    addToSequencer("system.Play");
  }

  function extendCastle() {
    castleExtended.set(true);
  }
</script>

<div class="castle-compact">
  {#if baseEntityId}
    <div class="header">
      <div class="pfp" style={"background:" + addressToColor(baseEntityId) + ";"} />
      CASTLE:<strong> {seedToCastleName(baseEntityId)}</strong>
    </div>

    <Inventory {baseEntityId} showCapacity={true} showEmptySlots={true} />
  {/if}
</div>

<style lang="scss">
  .castle-compact {
    padding: 10px;

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
