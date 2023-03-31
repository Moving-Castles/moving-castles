<script lang="ts">
  import { onMount } from "svelte";
  import type { Toast } from "../../modules/toast";
  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher<{ end: Toast }>();

  export let toast: Toast;

  const close = () => dispatch("end", toast);

  onMount(() => {
    if (!import.meta.env.DEV) {
      setTimeout(() => {
        close();
      }, 4000);
    }
  });
</script>

<div class="toast {toast.type}" on:click={close}>
  {#if toast.type === "warning"}
    <p class="exclamation">!</p>
  {/if}
  <p>
    {toast.message}
  </p>
</div>

<style lang="scss">
  .toast {
    text-align: center;
    max-width: 40ch;
    display: flex;
    flex-flow: column nowrap;
    text-shadow: 0px 2px #000;
    font-size: 1.2rem;

    &.warning {
      // color: var(--warning);
    }

    .exclamation {
      font-size: 2.5rem;
      margin: 0;
      animation: wobble 800ms ease 0s 1 normal forwards;
    }
  }

  @keyframes wobble {
    0%,
    100% {
      transform: translateY(0) rotate(0);
      transform-origin: 50% 50%;
    }

    15% {
      transform: translateY(-30px) rotate(6deg);
    }

    30% {
      transform: translateY(15px) rotate(-6deg);
    }

    45% {
      transform: translateY(-15px) rotate(3.6deg);
    }

    60% {
      transform: translateY(9px) rotate(-2.4deg);
    }

    75% {
      transform: translateY(-6px) rotate(1.2deg);
    }
  }
</style>
