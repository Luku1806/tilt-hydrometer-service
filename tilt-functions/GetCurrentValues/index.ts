import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import * as IoTHub from "../lib/infra/iotHub";
import { DeviceTwinRepository } from "../lib/repositories/deviceTwinRepository";

const deviceTwinRepo = new DeviceTwinRepository();

const httpTrigger: AzureFunction = async function (
  context: Context,
  req: HttpRequest
): Promise<AzureFunctionsHttpResponse> {
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
    const bodyContent = color ? IoTHub.tiltWithColor(tilts, color) : { tilts };

    return {
      body: { lastUpdated: $metadata.$lastUpdated, ...bodyContent },
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

export default httpTrigger;
