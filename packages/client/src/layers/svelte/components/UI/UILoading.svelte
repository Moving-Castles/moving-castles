<script lang="ts">
  import { loadingMessage } from "../../modules/network";
</script>

<div class="ui-loading">
  <div class="introduction-text">
    you exist in this darkness,<br />in the cracks of abandoned buildings,<br />in the ruins of decrepit myths...
  </div>
  <div class="loading-message">{$loadingMessage}</div>
</div>

<style lang="scss">
  .ui-loading {
    width: 100%;
    height: 100%;
    text-align: center;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size: 32px;
    flex-direction: column;
    color: black;
  }

  .loading-message {
    margin-top: 1em;
    opacity: 0.5;
  }
</style>
