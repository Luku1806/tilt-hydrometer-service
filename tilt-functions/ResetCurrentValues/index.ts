import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import { TiltMeasurementRepository } from "../lib/repositories/tiltMeasurementRepository";
import * as MongoDb from "../lib/infra/mongoDb";

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
    await tiltMeasurementRepo.deleteByIdAndColor(deviceId, color);

    return {
      status: 204,
    };
  } catch (error) {
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

export default httpTrigger;
