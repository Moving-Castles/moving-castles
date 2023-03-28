import { get } from "svelte/store";
import { queuedActions, activeActions, completedActions, failedActions } from "../actionSequencer";
import { entities } from "../entities";
import { playerCore, playerAddress } from "../player";
import type { Action } from "../actionSequencer";

export enum Activity {
    Idle,
    Move,
    PickUp,
    Drop,
    Transfer,
    Play,
    Open,
    Harvest,
    Consume
}

function systemIdToActivity(action: Action) {
    switch (action.systemId) {
        case 'system.Move':
            return Activity.Move;
        case 'system.PickUp':
            return Activity.PickUp;
        case 'system.Drop':
            return Activity.Drop;
        case 'system.Transfer':
            return Activity.Transfer;
        case 'system.Play':
            return Activity.Play;
        case 'system.Open':
            return Activity.Open;
        case 'system.Harvest':
            return Activity.Harvest;
        case 'system.Consume':
            return Activity.Consume;
        default:
            return Activity.Idle;
    }
}

const affectsBaseEntity = [Activity.Move];
const hasTargetItem = [Activity.PickUp, Activity.Drop, Activity.Transfer, Activity.Play, Activity.Open, Activity.Harvest, Activity.Consume];

function updateEntityActivity(action: Action, isDone: boolean = false) {

    const activity = systemIdToActivity(action);

    entities.update(entities => {
        // Set core to current activity
        entities[get(playerAddress)].activity = isDone ? Activity.Idle : activity;

        // Possibly set base entity to current activity
        if (affectsBaseEntity.includes(activity)) {
            entities[get(playerCore).carriedBy].activity = isDone ? Activity.Idle : activity;
        }

        // Possibly set target item to current activity
        if (hasTargetItem.includes(activity)) {
            if (action && action.params && action.params[0]) {
                let targetItem = action.params[0];
                entities[targetItem].activity = isDone ? Activity.Idle : activity;
            }
        }

        return entities;
    })

}

export function initActionUpdater() {

    queuedActions.subscribe((actions) => {
        if (actions.length === 0) return;
        updateEntityActivity(actions[0])
    })

    // activeActions.subscribe((actions) => {
    //     if (actions.length === 0) return;
    //     updateEntityActivity(actions[0])
    // })

    completedActions.subscribe((actions) => {
        if (actions.length === 0) return;
        updateEntityActivity(actions[0], true);
    })

    failedActions.subscribe((actions) => {
        if (actions.length === 0) return;
        updateEntityActivity(actions[0], true);
    })
}