<script lang="ts">
  import { network } from "../../modules/network"
  import { WorldFunctions } from "../../modules/actionSequencer"
  function spawn() {
    $network.worldSend(WorldFunctions.Spawn, [])
  }
</script>

<div class="spawn">
  <button on:click={spawn}>SPAWN</button>
</div>

<style lang="scss">
  .spawn {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: #ff0000;
    display: flex;
    justify-content: center;
    align-items: center;
  }
</style>
