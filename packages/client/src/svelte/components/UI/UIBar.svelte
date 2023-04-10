<script lang="ts">
  import { entities } from "../../modules/entities";
  import { leaderBoardActive, actionSequencerActive } from "./index";
  import CoreCompact from "../Core/CoreCompact.svelte";
  import Executor from "./Executor.svelte";

  const toggleLeaderBoard = () => {
    leaderBoardActive.set(!$leaderBoardActive);
  };

  const toggleActionSequencer = () => {
    actionSequencerActive.set(!$actionSequencerActive);
  };
</script>

<div class="bar">
  <Executor />

  <!-- Transaction tracker -->
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <!-- <div class="action" on:click={toggleActionSequencer}>
  </div> -->
  <!-- Leaderboard -->
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <!-- {#if Object.values($entities).find((e) => e.goal)}
    <div class="leaderboard" on:click={toggleLeaderBoard}>LEADERBOARD</div>
  {/if} -->
  <!-- Center button -->
  <!-- <div class="center-map">CENTER MAP</div> -->
  <!-- Castle -->
  <!-- <div class="castle">CASTLE</div> -->
  <!-- Core -->
  <!-- <CoreCompact /> -->
</div>

<style lang="scss">
  .bar {
    position: fixed;
    top: 10px;
    left: 10px;
    width: auto;
    height: 100px;
    display: flex;
    justify-content: space-between;
    z-index: 1000;
    align-items: center;
    // padding: 0 10px;
    box-shadow: 10px 10px 40px 0 rgba(0, 0, 0, 0.8);

    div {
      user-select: none;
      cursor: pointer;
    }
  }
</style>
