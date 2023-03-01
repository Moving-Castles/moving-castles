<script lang="ts">
  import { uiState } from "./index";
  import { ready } from "../../modules/network";
  import { playerCore } from "../../modules/player";
  // component2 <= !!!
  import UIComponent from "./UIComponent2.svelte";
  import UISpawn from "./UISpawn.svelte";
  import UILoading from "./UILoading.svelte";
  import Map from "../Map/Map.svelte";
  import UIPane from "./UIPane.svelte";
  import { castleExtended } from "./index";
</script>

<!-- The UI layer -->
<div class="ui-container" class:extended={$castleExtended}>
  {#if !$ready}
    <div class="ui-container-inner">
      <UIComponent id="ui-loading">
        <UILoading />
      </UIComponent>
    </div>
  {:else if !$playerCore}
    <div class="ui-container-inner">
      <UIComponent id="ui-spawn">
        <UISpawn />
      </UIComponent>
    </div>
  {:else}
    <div class="ui-container-inner-map">
      <UIComponent id="map" active={true} title="Map">
        <Map />
      </UIComponent>
    </div>
    <div class="ui-container-inner-pane">
      <UIComponent id="pane" active={true} title="Pane">
        <UIPane />
      </UIComponent>
    </div>
  {/if}
</div>

<style lang="scss">
  .ui-container {
    position: fixed;
    left: 0;
    top: 0;
    width: 100vw;
    height: 100vh;
    color: var(--foreground);
    box-sizing: border-box;
    display: flex;
  }

  .ui-container-inner {
    width: 100vw;
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: orangered;
  }

  .ui-container-inner-pane {
    width: 40vw;
    height: 100vh;
    background: blue;
  }

  .ui-container-inner-map {
    width: 60vw;
    height: 100vh;
    background: red;
  }

  .extended .ui-container-inner-pane {
    width: 100vw;
  }

  .extended .ui-container-inner-map {
    display: none;
  }
</style>
