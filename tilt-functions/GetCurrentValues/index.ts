import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import * as IoTHub from "../lib/infra/iotHub";
import { DeviceTwinRepository } from "../lib/repositories/deviceTwinRepository";
import { TiltMeasurementRepository } from "../lib/repositories/tiltMeasurementRepository";
import { TiltColor } from "../lib/models/tilt";
import * as MongoDb from "../lib/infra/mongoDb";

const deviceTwinRepo = new DeviceTwinRepository();
const tiltMeasurementRepo = new TiltMeasurementRepository();

const httpTrigger: AzureFunction = async function (
  context: Context,
  req: HttpRequest
): Promise<AzureFunctionsHttpResponse> {
  try {
    await MongoDb.connect();
  } catch (error) {
    context.log.error(error);
    return;
  }

  const deviceId = context.bindingData.deviceId;
  const color = context.bindingData.color;

  if (!deviceId) {
    return {
      status: 400,
      body: "Please send the device id either via query or body",
    };
  }

  try {
    const twin = await deviceTwinRepo.findById(deviceId);
    const { $metadata, $version, ...tilts } = twin.properties.reported;

    const tiltsWithHistory = await Object.entries(tilts).reduce<any>(
      async (result, [color, tilt]) => {
        const enrichedTilts = await result;
        return {
          ...enrichedTilts,
          [color]: await tiltWithHistory(deviceId, color as TiltColor, tilt),
        };
      },
      Promise.resolve({})
    );

    const responseTilts = color
      ? IoTHub.tiltWithColor(tiltsWithHistory, color)
      : { tilts: tiltsWithHistory };

    return {
      body: { lastUpdated: $metadata.$lastUpdated, ...responseTilts },
    };
  } catch (error) {
    context.log(error);

    if (error.message === "Not found") {
      return {
        status: 400,
        body: {
          message: "Device with the given deviceId/color does not exist",
        },
      };
    }

    return {
      status: 500,
      body: { message: "Internal server error", error: error.message },
    };
  }
};

async function tiltWithHistory(adapterId: string, color: TiltColor, tilt: any) {
  const history = await tiltMeasurementRepo.findByIdAndColor(adapterId, color);
  return {
    ...tilt,
    history: history?.measurements ?? [],
  };
}

export default httpTrigger;
