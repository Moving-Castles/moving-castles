<script lang="ts">
  import { TimelineMax } from "gsap";
  import {
    activeActions,
    queuedActions,
    completedActions,
    failedActions,
    sequencerState,
    SequencerState,
  } from "../../modules/actionSequencer";
  import { idToAvatar } from "../../utils/name";
  import { playerCore, playerAddress } from "../../modules/player";
  import { playSound } from "../../../howler";

  function toggleSequencer() {
    sequencerState.set($sequencerState);
    if ($sequencerState === SequencerState.Running) {
      playSound("eventBad", "ui");
      sequencerState.set(SequencerState.Paused);
    } else {
      playSound("eventGood", "ui");
      sequencerState.set(SequencerState.Running);
    }
  }

  // select the element you want to animate
  let queueElement: HTMLElement;
  let activeElement: HTMLElement;
  let doneElement: HTMLElement;
  let coreConnector: HTMLElement;
  let queueConnector: HTMLElement;
  let activeConnector: HTMLElement;

  const CONNECTOR_TIME = 0.1;
  const NODE_TIME = 0.4;

  function testTween() {
    // TweenMax.to(element, 1, { backgroundColor: "green" }).to(element, 1, { backgroundColor: "blue" });
    // const tl = new TimelineMax();

    const tl2 = new TimelineMax();
    tl2.to(coreConnector, 0, { height: 0 });
    tl2.to(coreConnector, CONNECTOR_TIME, { height: 100, opacity: 1 });
    tl2.to(queueElement, 0, { backgroundColor: "orange" });
    tl2.to(queueElement, NODE_TIME, { backgroundColor: "#808080" });
    tl2.to(queueConnector, 0, { height: 0 });
    tl2.to(queueConnector, CONNECTOR_TIME, { height: 100, opacity: 1 });
    tl2.to(activeElement, 0, { backgroundColor: "orangered" });
    tl2.to(activeElement, NODE_TIME, { backgroundColor: "#808080" });
    tl2.to(activeConnector, 0, { height: 0 });
    tl2.to(activeConnector, CONNECTOR_TIME, { height: 100, opacity: 1 });
    tl2.to(doneElement, 0, { backgroundColor: "green" });
    tl2.to(doneElement, NODE_TIME, { backgroundColor: "#808080" });
    tl2.to(coreConnector, 0.3, { opacity: 0 }, "end");
    tl2.to(queueConnector, 0.3, { opacity: 0 }, "end");
    tl2.to(activeConnector, 0.3, { opacity: 0 }, "end");
  }
</script>

<div class="executor">
  <!-- AVATAR -->
  <!-- ENERGY INDICATOR -->
  <div class="core-item">Energy: {$playerCore.energy}</div>
  <div class="core-item"><progress value={$playerCore.energy} max="200" /></div>
  <!-- ENERGY NUMBER -->
  <div class="core-item">
    <img draggable="false" class="core-avatar" src={idToAvatar($playerAddress)} alt="core" />
  </div>
  <div class="connector"><div class="line" bind:this={coreConnector} /></div>
  <div class="node queue" bind:this={queueElement} class:focus={$queuedActions.length > 0}>
    <div>Q:{$queuedActions.length}</div>
  </div>
  <div class="connector"><div class="line" bind:this={queueConnector} /></div>
  <div class="node active" bind:this={activeElement} class:focus={$activeActions.length > 0}>
    <div>A:{$activeActions.length}</div>
  </div>
  <div class="connector"><div class="line" bind:this={activeConnector} /></div>
  <div class="node done" bind:this={doneElement}><div>C:{$completedActions.length} F:{$failedActions.length}</div></div>
  <div>
    <button on:click={toggleSequencer}>
      {$sequencerState === SequencerState.Running ? "stop" : "start"}
    </button>
    <button on:click={testTween}>TEST</button>
  </div>
</div>

<style lang="scss">
  progress {
    height: 25px;
  }

  .executor {
    overflow: hidden;
    height: auto;
    width: 100px;
    display: flex;
    flex-direction: column;
    background: black;

    .core-item {
      line-height: 0;
      .core-avatar {
        height: 100px;
        width: 100px;
      }
    }

    .connector {
      width: 100%;
      height: 100px;
      display: flex;
      //   align-items: center;
      justify-content: center;
      background: white;

      .line {
        width: 10px;
        height: 0%;
        background: black;
      }
    }

    .node {
      width: 100%;
      height: 100px;
      background: #808080;
      font-size: 22px;
      display: flex;
      justify-content: center;
      align-items: center;

      &.queue {
        &.focus {
          background: yellow;
          color: black;
        }
      }

      &.active {
        &.focus {
          background: orangered;
          color: black;
        }
      }

      &.active {
        &.focus {
          background: green;
        }
      }
    }
  }
</style>
