<script lang="ts">
  import {
    queuedActions,
    activeActions,
    processedActions,
    sequencerState,
    SequencerState,
  } from "../../modules/actionSequencer";
  import type { Action } from "../../modules/actionSequencer";
  import { shortenAddress } from "../../utils/ui";

  function toggleSequencer() {
    sequencerState.set($sequencerState);
    if ($sequencerState === SequencerState.Running) {
      sequencerState.set(SequencerState.Paused);
    } else {
      sequencerState.set(SequencerState.Running);
    }
  }
</script>

<div class="ui-transactions">
  <button on:click={toggleSequencer}>
    {$sequencerState === SequencerState.Running ? "stop" : "start"}
  </button>
  <!-- QUEUED -->
  <h2>Queued</h2>
  {#each $queuedActions as action (action.actionId)}
    <div><span class="description">{action.systemId}</span> {action.actionId}</div>
  {/each}
  <!-- ACTIVE -->
  <h2>Active</h2>
  {#each $activeActions as action (action.actionId)}
    <div><span class="description">{action.systemId}</span> {action.actionId} {action.tx}</div>
  {/each}

  <!-- PROCESSED -->
  <h2>Processed</h2>
  {#each $processedActions as action (action.actionId)}
    <div><span class="description">{action.systemId}</span> {action.actionId} {action.tx}</div>
  {/each}
</div>

<style lang="scss">
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
