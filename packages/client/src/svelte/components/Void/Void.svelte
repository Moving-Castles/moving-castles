<script lang="ts">
  import { cores } from "../../modules/entities"
  import { playerAddress } from "../../modules/player"
  import OffChain from "../OffChain/OffChain.svelte"
</script>

<div class="void">
  <div>
    <div>ON CHAIN CORES:</div>
    {#each Object.entries($cores) as [key, value]}
      <div class="core">
        <div class="core__name">
          {key}
          {#if key === $playerAddress}(YOU){/if}
        </div>
      </div>
    {/each}
    <hr />
    <OffChain />
    <hr />
  </div>
</div>

<style lang="scss">
  .void {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: #0000ff;
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>
