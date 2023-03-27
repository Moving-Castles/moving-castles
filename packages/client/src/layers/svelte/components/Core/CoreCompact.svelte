<script lang="ts">
  import { playerCore, playerAddress } from "../../modules/player";
  import { idToName, idToAvatar } from "../../utils/name";
</script>

<div class="core-compact">
  {#if $playerCore}
    <!-- <div class="core-item">
      CORE: {shortenAddress($playerAddress)}
    </div> -->
    <div class="core-item"><strong>{idToName($playerAddress)}</strong></div>
    <div class="core-item">Energy: {$playerCore.energy}</div>
    <div class="core-item">Point: {parseInt(String($playerCore.point))}</div>
    <div class="core-item">
      <img draggable="false" class="core-avatar" src={idToAvatar($playerAddress)} alt="core" />
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

    .core-item {
      margin-right: 20px;
      .core-avatar {
        height: 40px;
        width: 40px;
      }
    }
  }
</style>
