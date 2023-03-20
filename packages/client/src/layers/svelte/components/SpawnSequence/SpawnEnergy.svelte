<script lang="ts">
  import SpawnSlide from "./SpawnSlide.svelte";
</script>

<SpawnSlide nextSpawnStage={5} buttonText={"OK..."}>
  <span slot="before">
    <img src="/img/demi2.png" alt="demiurge" />
  </span>
  <span slot="text">
    <p>I will give you 100 energy</p>
  </span>
</SpawnSlide>
