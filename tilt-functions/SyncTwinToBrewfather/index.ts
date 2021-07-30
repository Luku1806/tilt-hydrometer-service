import { AzureFunction, Context } from "@azure/functions";
import { IotHubTiltData } from "../lib/models/iotHub";

import { BrewfatherMeasurementRepository } from "../lib/repositories/brewfatherMeasurementRepository";
import { BrewfatherMeasurement } from "../lib/models/brewfatherMeasurement";

const brewfatherMeasurementRepo = new BrewfatherMeasurementRepository(
  process.env["BREWFATHER_STREAM_ID"]
);

const eventHubTrigger: AzureFunction = async function (
  context: Context,
  message: IotHubTiltData
): Promise<void> {
  const adapterId =
    context.bindingData.systemProperties["iothub-connection-device-id"];

  const { $metadata, $version, ...tilts } = message.properties.reported;

  const measurements: [string, BrewfatherMeasurement][] = Object.entries(
    tilts
  ).map(([color, reported]) => [
    adapterId,
    {
      name: `${adapterId}-${color}`,
      gravity: reported.specificGravity,
      temperature: reported.temperature.celsius,
    },
  ]);

  await Promise.all(
    measurements.map(([_, measurement]) =>
      brewfatherMeasurementRepo.create(measurement)
    )
  );

  context.log(
    `Saved new values at brewfather for adapter ${adapterId} and tilts ${Object.keys(
      measurements
    ).join(", ")}`
  );
};

export default eventHubTrigger;
