import { AzureFunction, Context } from "@azure/functions";

import * as MongoDb from "../lib/infra/mongoDb";
import { TiltMeasurementRepository } from "../lib/repositories/tiltMeasurementRepository";
import { TiltMeasurement } from "../lib/models/tiltMeasurement";
import { IotHubTiltData } from "../lib/models/iotHub";

const tiltMeasurementRepository = new TiltMeasurementRepository();

const eventHubTrigger: AzureFunction = async function (
  context: Context,
  message: IotHubTiltData
): Promise<void> {
  try {
    await MongoDb.connect();
  } catch (error) {
    context.log.error(error);
    return;
  }

  const adapterId =
    context.bindingData.systemProperties["iothub-connection-device-id"];
  const { $metadata, $version, ...tilts } = message.properties.reported;

  const measurements: [string, TiltMeasurement][] = Object.entries(tilts).map(
    ([color, reported]) => [
      color,
      {
        specificGravity: reported.specificGravity,
        temperature: reported.temperature.fahrenheit,
      },
    ]
  );

  await Promise.all(
    measurements.map(([color, measurement]) =>
      tiltMeasurementRepository.create(adapterId, color, measurement)
    )
  );

  context.log(
    `Saved new values for adapter ${adapterId} and tilts ${Object.keys(
      measurements
    ).join(", ")}`
  );
};

export default eventHubTrigger;
