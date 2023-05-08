<script lang="ts">
  import { loadingMessage } from "../../modules/network"
</script>

<div class="loading">
  <div class="loading-message">{$loadingMessage}</div>
</div>

<style lang="scss">
  .loading {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: #ffffff;
    display: flex;
    justify-content: center;
    align-items: center;

    .loading-message {
      color: black;
      font-size: 12px;
    }
  }
</style>
