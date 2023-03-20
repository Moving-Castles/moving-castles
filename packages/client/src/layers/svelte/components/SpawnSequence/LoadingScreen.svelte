<script lang="ts">
  import { loadingMessage } from "../../modules/network";
  import SpawnSlide from "./SpawnSlide.svelte";
</script>

<div class="loading-message">{$loadingMessage}</div>

<SpawnSlide nextSpawnStage={2} buttonText={"START"}>
  <span slot="text">
    <p>you exist in this darkness</p>
    <p>in the cracks of abandoned buildings,</p>
    <p>in the ruins of decrepit myths...</p>
  </span>
</SpawnSlide>

<style lang="scss">
  .loading-message {
    position: fixed;
    top: 10px;
    transform: translateX(-50%);
    left: 50%;
    margin-top: 1em;
    opacity: 0.5;
    font-size: 12px;
  }
</style>
