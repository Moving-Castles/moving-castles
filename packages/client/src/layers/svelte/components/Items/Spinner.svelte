<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  const ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".split("");
  let letter = "X";
  let interval: number;
  onMount(async () => {
    interval = window.setInterval(() => {
      letter = ALPHABET[Math.floor(Math.random() * ALPHABET.length)];
    }, 50);
  });

  onDestroy(() => {
    clearInterval(interval);
  });
</script>

<span class="spinner">{letter}</span>
