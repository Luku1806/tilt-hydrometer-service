import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import { DeviceTwinRepository } from "../lib/repositories/deviceTwinRepository";

const deviceTwinRepo = new DeviceTwinRepository();

const httpTrigger: AzureFunction = async function (
  context: Context,
  req: HttpRequest
): Promise<AzureFunctionsHttpResponse> {
  const deviceId = context.bindingData.deviceId;
  const color = context.bindingData.color;
  const { startingGravity } = req.body;

  if (!deviceId) {
    return {
      status: 400,
      body: "Please send the device id either via query or body",
    };
  }

  if (!startingGravity) {
    return {
      status: 400,
      body: "Please send the startingGravity as body field",
    };
  }

  try {
    const twin = await deviceTwinRepo.findById(deviceId);
    await deviceTwinRepo.update(twin, {
      [color]: {
        startingGravity,
      },
    });

    return {
      status: 200,
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
