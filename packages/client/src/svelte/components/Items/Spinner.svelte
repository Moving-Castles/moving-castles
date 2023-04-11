<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { staticContent } from "../../modules/staticContent";

  let interval: number;
  let count = 0;
  onMount(async () => {
    interval = window.setInterval(() => {
      count++;
    }, 50);
  });

  onDestroy(() => {
    clearInterval(interval);
  });
</script>

<span class="spinner">
  <img src={$staticContent.organs[count % $staticContent.organs.length].w400} alt="organ" />
</span>

<style lang="scss">
  .spinner {
    user-select: none;

    img {
      height: 600px;
      width: 600px;
    }
  }
</style>
