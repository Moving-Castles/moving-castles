<script lang="ts">
  import { addToSequencer } from "../../modules/actionSequencer";
  import { playSound } from "../../../howler";
  import Spinner from "./Spinner.svelte";

  export let itemId: string;

  enum BoxState {
    UNOPENED,
    OPENING,
  }

  let boxState: BoxState = BoxState.UNOPENED;

  function open() {
    playSound("eventGood", "ui");

    boxState = BoxState.OPENING;
    addToSequencer("system.Open", [itemId]);
  }

  function mouseenter() {
    playSound("cursor", "ui");
  }
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div class="loot-box" on:click={open} on:mouseenter={mouseenter}>
  {#if boxState === BoxState.OPENING}
    <Spinner />
  {:else}
    ?
  {/if}
</div>

<style lang="scss">
  .loot-box {
    height: 100px;
    width: 100px;
    overflow: hidden;
    margin-right: 5px;
    margin-bottom: 5px;
    font-size: 42px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;
    background: red;

    &:hover {
      opacity: 0.9;
    }
  }
</style>
