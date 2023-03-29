<script lang="ts">
  import SpawnSlide from "./SpawnSlide.svelte";
</script>

<SpawnSlide nextSpawnStage={3} buttonText={"ROLL THE DICE"}>
  <span slot="before">
    <img draggable="false" src="/img/game-master/demi.jpg" alt="demiurge" />
  </span>
  <span slot="text">
    <p>aaah so you are here to play a game?</p>
    <p>Ok, I will grant you one core...</p>
  </span>
</SpawnSlide>
