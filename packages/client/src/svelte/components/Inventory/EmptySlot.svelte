<script lang="ts">
  export let dropAllowed = true;

  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();

  let hovering = false;

  const onDragEnter = (e: DragEvent) => {
    e.stopPropagation();
    hovering = true;
  };
  const onDragLeave = (e: DragEvent) => {
    e.stopPropagation();
    hovering = false;
  };
  const onDrop = (e: DragEvent) => {
    hovering = false;
    if (dropAllowed) {
      dispatch("drop", e);
    }
  };
</script>

<div
  on:drop={onDrop}
  on:dragenter={onDragEnter}
  on:dragleave={onDragLeave}
  class:hovering
  class:dropAllowed
  class:disabled={!dropAllowed}
  class="empty-slot"
  ondragover="return false"
/>

<style lang="scss">
  .empty-slot {
    height: 140px;
    width: 140px;
    overflow: hidden;
    margin-right: 5px;
    margin-bottom: 5px;
    font-size: 42px;
    display: flex;
    justify-content: center;
    align-items: center;
    color: black;
    cursor: pointer;
    background: lightgray;

    &.hovering.dropAllowed {
      border: 3px solid rgb(0, 255, 0);
    }

    &.hovering.disabled {
      background: rgb(255, 0, 0);
    }
  }
</style>
