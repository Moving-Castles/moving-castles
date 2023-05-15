<script lang="ts">
  import { onMount } from "svelte"
  import { network } from "../../modules/network"
  import { playerAddress } from "../../modules/player"

  let uuid = ""

  type Client = {
    id: string
    address: string
  }

  let verifiedClients: Client[] = []

  // Create WebSocket connection.
  let socket: any

  // function sendMessage() {
  //   const message = JSON.stringify({
  //     topic: "broadcast",
  //     data: { text: textInput },
  //   })
  //   socket.send(message)
  //   textInput = ""
  // }

  async function sendVerification() {
    const signature = await $network.network.signer.value_.signMessage("mc")
    const message = JSON.stringify({
      topic: "verify",
      data: { signature: signature },
    })
    socket.send(message)
  }

  onMount(() => {
    uuid = window.crypto.randomUUID()
    socket = new WebSocket("ws://localhost:9001")

    // Connection opened
    socket.addEventListener("open", event => {
      console.log("Connected")
      sendVerification()
    })

    // Listen for messages
    socket.addEventListener("message", event => {
      console.log("Message from server ", event)
      let msgObj = JSON.parse(event.data)
      console.log(msgObj)
      if (msgObj.topic === "verifiedClients") {
        verifiedClients = msgObj.verifiedClients
      }
    })
  })
</script>

<div>
  <div>OFF CHAIN CORES:</div>
  <div>
    {#each verifiedClients as client}
      <div>
        {client.address}
        {#if client.address === $playerAddress}(YOU){/if}
      </div>
    {/each}
  </div>
</div>
