<script lang="ts">
  import { shortenAddress } from "../../utils/misc";
  import type { Action } from "../../modules/actionSequencer";
  export let action: Action;
</script>

<div class="action">
  <span class="description">{action.systemId}</span>
  {shortenAddress(action.actionId)}
  {#if action.tx}
    {shortenAddress(action.tx)}
  {/if}
</div>

<style lang="scss">
  .action {
    margin-bottom: 5px;

    .description {
      background: white;
      color: black;
      padding: 2px;
    }
  }
</style>
