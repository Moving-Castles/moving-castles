<script lang="ts">
  import { createEventDispatcher } from "svelte";
  const dispatch = createEventDispatcher();
  let hovering = false;

  const onDrop = (e: DragEvent) => {
    hovering = false;
    dispatch("drop", e);
  };
</script>

<div
  on:drop={onDrop}
  on:dragenter={() => (hovering = true)}
  on:dragleave={() => (hovering = false)}
  class:hovering
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

    &.hovering {
      border: 3px solid red;
    }
  }
</style>
