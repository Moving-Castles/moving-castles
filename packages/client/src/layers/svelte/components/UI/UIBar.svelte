<script lang="ts">
  import { entities } from "../../modules/entities";
  import { activeActions, queuedActions, processedActions } from "../../modules/actionSequencer";
  import { leaderBoardActive, actionSequencerActive } from "./index";
  import CoreCompact from "../Core/CoreCompact.svelte";

  const toggleLeaderBoard = () => {
    leaderBoardActive.set(!$leaderBoardActive);
  };

  const toggleActionSequencer = () => {
    actionSequencerActive.set(!$actionSequencerActive);
  };
</script>

<div class="bar">
  <!-- Transaction tracker -->
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div class="action" on:click={toggleActionSequencer}>
    <span>ACTIONS:</span>
    {#if $queuedActions.length > 0}
      QUEUED ({$queuedActions.length})
    {:else if $activeActions.length > 0}
      ACTIVE
    {:else}
      DONE ({$processedActions.length})
    {/if}
  </div>
  <!-- Leaderboard -->
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  {#if Object.values($entities).find((e) => e.goal)}
    <div class="leaderboard" on:click={toggleLeaderBoard}>LEADERBOARD</div>
  {/if}
  <!-- Center button -->
  <!-- <div class="center-map">CENTER MAP</div> -->
  <!-- Castle -->
  <div class="castle">CASTLE</div>
  <!-- Core -->
  <CoreCompact />
</div>

<style lang="scss">
  .bar {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 40px;
    background: red;
    display: flex;
    justify-content: space-between;
    z-index: 1000;
    align-items: center;
    padding: 0 10px;

    div {
      user-select: none;
      cursor: pointer;
    }
  }
</style>
