<script lang="ts">
  import { Activity } from "../../modules/entities";
  import { playerCore, playerBaseEntity, playerAddress } from "../../modules/player";
  import { shortenAddress, addressToColor } from "../../utils/ui";
  import Inventory from "../Inventory/Inventory.svelte";
  import { addToSequencer } from "../../modules/actionSequencer";
  import { seedToCastleName } from "../../utils/name";
  import { castleExtended } from "../UI";

  function play() {
    addToSequencer("system.Play");
  }

  function harvest() {
    addToSequencer("system.Harvest");
  }

  function extendCastle() {
    castleExtended.set(true);
  }
</script>

<div class="castle-compact">
  {#if $playerCore && $playerBaseEntity && $playerBaseEntity.position}
    <div class="header">
      <div class="pfp" style={"background:" + addressToColor($playerCore.carriedBy) + ";"} />
      CASTLE:<strong> {seedToCastleName($playerCore.carriedBy)}</strong>
    </div>
    <div class="play">
      <div><button on:click={harvest}>HARVEST</button></div>
      {#if $playerCore.commit === Activity.Play}
        <div>...P.l.A.y.I.n.G...</div>
        <div><button on:click={play}>STOP</button></div>
      {/if}
    </div>
    {#if $playerCore.carriedBy}
      <Inventory baseEntityId={$playerCore.carriedBy} showCapacity={true} showEmptySlots={true} />
    {/if}

    <div class="extend">
      <button on:click={extendCastle}>Extend castle view</button>
    </div>
  {/if}
</div>

<style lang="scss">
  .play {
    font-size: 18px;
    margin-top: 10px;
    margin-bottom: 10px;
  }

  .header {
    font-size: 18px;
    font-weight: 1000;
    font-stretch: 151%;
    font-variation-settings: "size" 60;
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

  .castle-compact {
    padding: 10px;
  }
</style>
