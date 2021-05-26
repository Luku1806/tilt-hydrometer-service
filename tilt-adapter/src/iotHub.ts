import * as iotHub from "azure-iot-device";
import * as iotHubProtocol from "azure-iot-device-mqtt";
import { throttle } from "lodash";

import { TiltData } from "./tilt";

export const IOT_HUB_CONNECTION_STRING = process.env.IOT_HUB_CONNECTION_STRING;
export const IOT_HUB_UPDATE_DELAY =
  parseInt(process.env.IOT_HUB_UPDATE_DELAY, 10) ?? 500;

export const iotHubClient = iotHub.Client.fromConnectionString(
  IOT_HUB_CONNECTION_STRING,
  iotHubProtocol.Mqtt
);

export async function connectTwin(
  connectionString = IOT_HUB_CONNECTION_STRING
): Promise<iotHub.Twin> {
  await iotHubClient.open();
  return await iotHubClient.getTwin();
}

export function registerTwinDesiredStateChangeHandler(twin: iotHub.Twin) {
  twin.on("properties.desired", (delta: Object) => {
    const patch = Object.entries(delta).reduce((current, [color, value]) => {
      if (value?.startingGravity) {
        return {
          ...current,
          [color]: { startingGravity: value.startingGravity },
        };
      }
      return current;
    }, {});

    twin.properties.reported.update(patch, onDeviceTwinUpdateDone);
  });
}

function delayFromEnvironment(defaultSeconds = 500) {
  return (
    (Number.isNaN(IOT_HUB_UPDATE_DELAY)
      ? defaultSeconds
      : IOT_HUB_UPDATE_DELAY) * 1000
  );
}

export const updateTwin = throttle(updateTwinValues, delayFromEnvironment(), {
  trailing: true,
});

async function updateTwinValues(data: TiltData, twin: iotHub.Twin) {
  twin.properties.reported.update(
    {
      [data.color]: {
        ...toTwinData(twin.properties.reported[data.color], data),
      },
    },
    onDeviceTwinUpdateDone
  );
}

function onDeviceTwinUpdateDone(error) {
  console.log(`Updating device twin`);
  if (error) {
    console.log("Error updating device twin");
  }
}

interface TiltState extends TiltData {
  startingGravity: number;
}

function toTwinData(previousState: TiltState, data: Partial<TiltData>) {
  const { color, ...withoutColor } = data;
  return {
    ...previousState,
    ...withoutColor,
    startingGravity: previousState.startingGravity ?? data.specificGravity,
  };
}
