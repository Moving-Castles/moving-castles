<script lang="ts">
  import {
    queuedActions,
    activeActions,
    processedActions,
    sequencerState,
    SequencerState,
  } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";
  import { shortenAddress } from "../../utils/misc";

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
    <div class="action">
      <span class="description">{action.systemId}</span>
      {action.actionId}
    </div>
  {/each}
  <!-- ACTIVE -->
  <h2>Active</h2>
  {#each $activeActions as action (action.actionId)}
    <div class="action">
      <span class="description">{action.systemId}</span>
      {action.actionId}
      {action.tx}
    </div>
  {/each}
  <!-- PROCESSED -->
  <h2>Processed</h2>
  {#each $processedActions as action (action.actionId)}
    <div class="action">
      <span class="description">{action.systemId}</span>
      {shortenAddress(action.actionId)}
      {shortenAddress(action.tx)}
    </div>
  {/each}
</div>

<style lang="scss">
  .ui-action-sequencer {
    word-break: break-all;

    .action {
      margin-bottom: 5px;
    }
  }

  .description {
    background: white;
    color: black;
    padding: 2px;
  }

  h2 {
    font-size: 14px;
    text-decoration: underline;
  }
</style>
