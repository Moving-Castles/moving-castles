<script lang="ts">
  import SpawnSlide from "./SpawnSlide.svelte";
</script>

<SpawnSlide nextSpawnStage={100} buttonText={"DO I HAVE TO?"}>
  <span slot="text">
    <p>now, you are off to The Wasteland my friend</p>
  </span>
  <span slot="after">
    <img draggable="false" src="/img/waste.png" alt="wasteland" />
  </span>
</SpawnSlide>
