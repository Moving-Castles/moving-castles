<script lang="ts">
  import { Activity } from "../../modules/entities";
  import { playerCore, playerBaseEntity, playerAddress } from "../../modules/player";
  import { shortenAddress, addressToColor } from "../../utils/ui";
  import Inventory from "../Inventory/Inventory.svelte";
  import { addToSequencer } from "../../modules/actionSequencer";

  function play() {
    addToSequencer("system.Play");
  }
</script>

<div class="ui-debug-log">
  {#if $playerCore}
    <div class="control">
      <span style={"color:" + addressToColor($playerAddress) + ";"}>
        CORE: {shortenAddress($playerAddress)}
      </span>
    </div>
    <div class="control">Energy: {$playerCore.energy}</div>
    <div class="control">Creation block: {parseInt(String($playerCore.creationBlock), 16)}</div>
    <div class="control">Ready block: {parseInt(String($playerCore.readyBlock), 16)}</div>
  {/if}
</div>

<style lang="scss">
  .play {
    font-size: 24px;
    margin-top: 10px;
    margin-bottom: 10px;
  }
</style>
