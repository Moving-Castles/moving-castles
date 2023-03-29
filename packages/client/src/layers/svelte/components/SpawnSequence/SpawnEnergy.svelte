<script lang="ts">
  import SpawnSlide from "./SpawnSlide.svelte";
</script>

<SpawnSlide nextSpawnStage={5} buttonText={"OK..."}>
  <span slot="before">
    <img draggable="false" src="/img/game-master/demi.jpg" alt="demiurge" />
  </span>
  <span slot="text">
    <p>I will give you 100 energy</p>
  </span>
</SpawnSlide>
