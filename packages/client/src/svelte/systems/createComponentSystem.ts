import { get } from "svelte/store";
import { entities, indexToID } from "../modules/entities";
import { network } from "../modules/network";
import { toCamelCase } from "../utils/misc";

export function createComponentSystem(componentKey: string) {

  console.log(':::: Setting up', componentKey)

  get(network).components[componentKey].update$.subscribe(update => {
    console.log("==>", componentKey, update);
    const [nextValue, prevValue] = update.value

    // Single-value components have a "value" property, structs do not
    const newValue =
      nextValue && Object.prototype.hasOwnProperty.call(nextValue, "value")
        ? nextValue.value
        : nextValue;

    console.log(update.entity)

    // const entityID = indexToID(update.entity);
    const entityID = update.entity;
    const propertyName = toCamelCase(componentKey);

    entities.update((value) => {
      // Create an empty entity if it does not exist
      if (value[entityID] === undefined) value[entityID] = {};

      // @todo: fix types
      if (newValue === undefined) {
        delete value[entityID][propertyName];
      } else {
        value[entityID][propertyName] = newValue;
      }

      return value;
    });

  })
}
