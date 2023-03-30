<script lang="ts">
  import CastleCompact from "../Castle/CastleCompact.svelte";
  import { castleExtended, popUpEntities } from "../UI";
  import { quadOut } from "svelte/easing";
  import { fly } from "svelte/transition";
  import { dragging } from "./index";

  export let baseEntityId: string;

  let draggingOver = false;

  const close = () => popUpEntities.set($popUpEntities.filter((id) => id !== baseEntityId));

  const onDragEnter = (e: DragEvent) => {
    console.log("enter");
    draggingOver = true;
  };

  const onDragLeave = (e) => {
    draggingOver = false;
  };

  const onDragEnd = (e: DragEvent | PointerEvent) => {
    draggingOver = false;
    if (e.dataTransfer) {
      e.dataTransfer.clearData();
      dragging.set("");
    }
  };
</script>

<div
  class:extended={$castleExtended}
  in:fly={{ duration: 200, y: 200, easing: quadOut }}
  on:dragover={onDragEnter}
  on:dragenter={onDragEnter}
  on:dragleave={onDragLeave}
  on:dragend={onDragEnd}
  on:pointerleave={onDragEnd}
  on:pointerup={onDragEnd}
  class="castle"
>
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <div on:click={close}>CLOSE</div>
  <CastleCompact {baseEntityId} {draggingOver} />
</div>

<style lang="scss">
  .castle {
    flex-grow: 0;
    width: 460px;
    background: rgba(40, 40, 40, 1);
    height: calc(100vh - 250px);
    overflow: scroll;
  }

  .actions {
    height: 200px;
    width: 100%;
    border-top: 1px solid white;
    overflow: scroll;
  }

  .extended .castle {
    height: calc(100vh - 50px);
  }
</style>
