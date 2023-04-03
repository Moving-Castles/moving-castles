<script lang="ts">
  import { cores } from "../../modules/entities";
  import { idToName, idToAvatarIndex } from "../../utils/name";
  import { staticContent } from "../../modules/staticContent";
</script>

{#each Object.entries($cores) as [key, value]}
  <div class="row">
    <div class="core-item">
      <img draggable="false" class="core-avatar" src={$staticContent.cores[idToAvatarIndex(key)].w100} alt="core" />
    </div>
    <div class="core-item"><strong>{idToName(key)}</strong></div>
    <div class="core-item">{parseInt(String(value.point))}</div>
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
