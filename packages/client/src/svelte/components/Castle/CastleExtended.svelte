<script lang="ts">
  import { Activity } from "../../modules/entities";
  import { playerCore, playerBaseEntity } from "../../modules/player";
  import { shortenAddress, addressToColor } from "../../utils/misc";
  import Inventory from "../Inventory/Inventory.svelte";
  import { seedToCastleName } from "../../utils/name";
  import { play } from "../../modules/player/actions";
  import { castleExtended } from "../UI";

  function extendCastle() {
    castleExtended.set(false);
  }
</script>

<div class="castle-extended">
  {#if $playerCore && $playerBaseEntity && $playerBaseEntity.position}
    <div class="left">
      <div class="header">
        <div class="pfp" style={"background:" + addressToColor($playerCore.carriedBy) + ";"} />
        CASTLE:<strong> {seedToCastleName($playerCore.carriedBy)}</strong>
      </div>
      <div class="play">
        {#if $playerCore.commit === Activity.Play}
          <div>...P.l.A.y.I.n.G...</div>
          <div><button on:click={play}>STOP</button></div>
        {/if}
      </div>
      {#if $playerCore.carriedBy}
        <Inventory baseEntityId={$playerCore.carriedBy} showCapacity={true} showEmptySlots={true} />
      {/if}
      <div class="extend">
        <button on:click={extendCastle}>compact castle view</button>
      </div>
    </div>

    <div class="right">
      <img draggable="false" src="img/test1.png" alt="castle" />
    </div>
  {/if}
</div>

<style lang="scss">
  .castle-extended {
    padding: 10px;

    .left {
      width: 50%;
      height: 100%;
      float: left;
    }

    .right {
      width: 50%;
      background-color: orangered;
      height: 100%;
      float: left;
      background-image: url("img/dust.png");
      display: flex;
      justify-content: center;
      align-items: center;

      img {
        max-width: 100%;
        max-height: 90vh;
      }
    }

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
  }
</style>
