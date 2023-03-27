<script lang="ts">
  import { cores } from "../../modules/entities";
  import { idToName, idToAvatar } from "../../utils/name";

  // let orderedCores;
  // $: orderedCores = Object.entries($cores).sort((a, b) => b[1].point - a[1].point);
</script>

{#each Object.entries($cores) as [key, value]}
  <div class="row">
    <div class="core-item">
      <img draggable="false" class="core-avatar" src={idToAvatar(key)} alt="core" />
    </div>
    <div class="core-item"><strong>{idToName(key)}</strong></div>
    <div class="core-item">{parseInt(value.point)}</div>
  </div>
{/each}

<style lang="scss">
  .row {
    display: flex;
    align-items: center;

    .core-item {
      margin-right: 10px;
      .core-avatar {
        height: 40px;
        width: 40px;
      }
    }
  }
</style>
