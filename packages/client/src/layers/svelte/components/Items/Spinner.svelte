<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import { allOrganIcons } from "../../modules/staticContent";

  $: console.log($allOrganIcons);

  const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
  let letter = "X";
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
  <img src={$allOrganIcons[count % $allOrganIcons.length]} alt="organ" />
</span>

<style lang="scss">
  .spinner {
    position: fixed;
    user-select: none;

    img {
      height: 600px;
      width: 600px;
    }
  }
</style>
