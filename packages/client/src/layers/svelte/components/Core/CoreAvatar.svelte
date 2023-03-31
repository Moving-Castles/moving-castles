<script lang="ts">
  export let address: string;
  import { playerCore, playerAddress } from "../../modules/player";
  import { idToName, idToAvatar } from "../../utils/name";
</script>

<div class="core-avatar">
  <img draggable="false" class="core-avatar" src={idToAvatar(address)} alt="core" />
  <div class="shadow" />
</div>

<style lang="scss">
  .core-avatar {
    height: 60px;
    width: 60px;
    overflow: hidden;
    border-radius: 40px;

    img {
      width: 100%;
      height: 100%;
    }
  }

  .shadow {
    position: absolute;
    width: 60px;
    height: 60px;
    background: rgb(0, 0, 0, 0.3);
    filter: blur(10px);
    display: block;
    border-radius: 40px;
    bottom: 0;
    z-index: 1;
  }
</style>
