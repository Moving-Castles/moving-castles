<script lang="ts">
  import { fade } from "svelte/transition";
  import { uiState, speed, activeComponent } from "./index";

  export let id: string;
  export let active: boolean = true;
  export let title: string = "";

  const handleShortcuts = ({ code }) => {
    if ($activeComponent === id) {
      if (code === "Escape" && !options.persistent) {
        uiState.alter(id, "active", false);
      }
    }
  };

  const handleMouseEnter = () => {
    $activeComponent = id;
  };
  const handleMouseLeave = () => {
    $activeComponent = "";
  };
</script>

<svelte:window on:keydown={handleShortcuts} />

{#if active}
  <div
    class="ui-component"
    on:mouseenter={handleMouseEnter}
    on:mouseleave={handleMouseLeave}
    on:introend={() => uiState.alter(id, "delay", 0)}
    out:fade={{ duration: $speed }}
  >
    <!-- Body -->
    <div class="ui-component-inner">
      <slot />
    </div>
  </div>
{/if}

<style lang="scss">
  .ui-component {
    grid-column: auto / span 1;
    grid-row: auto / span 3;
    user-select: none;
    overflow-y: hidden;
    -ms-overflow-style: none; /* IE and Edge */
    scrollbar-width: none; /* Firefox */
    position: relative;
    /* background-color: var(--background); */
  }

  .ui-component:not(.span) {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: max-content 1fr;
  }

  .ui-component-inner {
    height: 100vh;
    overflow: auto;
  }

  /* Hide scrollbar for Chrome, Safari and Opera */
  .ui-component-inner::-webkit-scrollbar {
    display: none;
  }
</style>
