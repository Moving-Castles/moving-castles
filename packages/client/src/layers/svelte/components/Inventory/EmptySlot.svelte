<script lang="ts">
  import { onMount, onDestroy } from "svelte";
</script>

<div class="empty-slot" />

<style lang="scss">
  .empty-slot {
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
    background: lightgray;
  }
</style>
