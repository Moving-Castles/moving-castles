<script lang="ts">
  import { Activity } from "../../modules/entities";
  import { playerCore, playerBaseEntity, playerAddress } from "../../modules/player";
  import { shortenAddress, addressToColor } from "../../utils/ui";
  import { idToName, idToAvatar } from "../../utils/name";
</script>

<div class="core-compact">
  {#if $playerCore}
    <!-- <div class="core-item">
      CORE: {shortenAddress($playerAddress)}
    </div> -->
    <div class="core-item"><strong>{idToName($playerAddress)}</strong></div>
    <div class="core-item">Energy: {$playerCore.energy}</div>
    <div class="core-item">Point: {parseInt($playerCore.point)}</div>
    <div class="core-item">
      <img class="core-avatar" src={idToAvatar($playerAddress)} alt="core" />
    </div>
  {/if}
</div>

<style lang="scss">
  .core-compact {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    font-size: 16px;
    padding-top: 3px;
  }

  .core-avatar {
    height: 40px;
    width: 40px;
  }

  .core-item {
    margin-right: 20px;
  }
</style>
