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
    { [data.color]: toTwinData(data) },
    (error) => {
      console.log(`Updating ${data.color} device twin`);
      if (error) {
        console.log("Error updating device twin");
      }
    }
  );
}

function toTwinData(data: TiltData) {
  const { color, ...withoutColor } = data;
  return withoutColor;
}
