<script lang="ts">
  import { playerCore, playerAddress } from "../../modules/player";
  import { idToName, idToAvatar } from "../../utils/name";
</script>

<div class="core-compact">
  {#if $playerCore}
    <!-- NAME -->
    <div class="core-item"><strong>{idToName($playerAddress)}</strong></div>
    <!-- ENERGY INDICATOR -->
    <div class="core-item"><progress value={$playerCore.energy} max="200" /></div>
    <!-- ENERGY NUMBER -->
    <div class="core-item">Energy: {$playerCore.energy}</div>
    <!-- POINTS -->
    {#if $playerCore.point > 0}
      <div class="core-item">Point: {parseInt(String($playerCore.point))}</div>
    {/if}
    <!-- AVATAR -->
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
    font-size: 12px;
    padding-top: 3px;

    .core-item {
      margin-right: 10px;
      .core-avatar {
        height: 40px;
        width: 40px;
      }
    }
  }
</style>
