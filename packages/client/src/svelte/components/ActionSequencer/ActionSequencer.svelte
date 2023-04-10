<script lang="ts">
  import {
    queuedActions,
    activeActions,
    completedActions,
    failedActions,
    sequencerState,
    SequencerState,
  } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";
  import ActionItem from "./ActionItem.svelte";

  function toggleSequencer() {
    sequencerState.set($sequencerState);
    if ($sequencerState === SequencerState.Running) {
      playSound("eventBad", "ui");
      sequencerState.set(SequencerState.Paused);
    } else {
      playSound("eventGood", "ui");
      sequencerState.set(SequencerState.Running);
    }
  }
</script>

<div class="ui-action-sequencer">
  <button on:click={toggleSequencer}>
    {$sequencerState === SequencerState.Running ? "stop" : "start"}
  </button>
  <!-- QUEUED -->
  <h2>Queued</h2>
  {#each $queuedActions as action (action.actionId)}
    <ActionItem {action} />
  {/each}
  <!-- ACTIVE -->
  <h2>Active</h2>
  {#each $activeActions as action (action.actionId)}
    <ActionItem {action} />
  {/each}
  <!-- FAILED -->
  <h2>Failed</h2>
  {#each $failedActions as action (action.actionId)}
    <ActionItem {action} />
  {/each}
  <!-- PROCESSED -->
  <h2>Processed</h2>
  {#each $completedActions as action (action.actionId)}
    <ActionItem {action} />
  {/each}
</div>

<style lang="scss">
  .ui-action-sequencer {
    word-break: break-all;

    h2 {
      font-size: 14px;
      text-decoration: underline;
    }
  }
</style>
