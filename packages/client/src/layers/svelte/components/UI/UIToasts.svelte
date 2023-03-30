<script lang="ts">
  import { toasts } from "./index";
  import { flip } from "svelte/animate";
  import Toast from "./Toast.svelte";
  import { quadOut } from "svelte/easing";
  import { fly, fade } from "svelte/transition";

  const onEnd = (e: CustomEvent<{ end: Toast }>) => {
    toasts.set($toasts.filter((t: Toast) => t.timestamp !== e.detail.timestamp));
  };
</script>

<div class="toast-pane">
  {#each $toasts as toast (toast.timestamp)}
    <div animate:flip in:fly={{ duration: 200, y: 200, easing: quadOut }} out:fade>
      <Toast {toast} on:end={onEnd} />
    </div>
  {/each}
</div>

<style>
  .toast-pane {
    position: fixed;
    bottom: 20px;
    right: 20px;
    display: flex;
    flex-direction: column-reverse;
  }
</style>
