import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import { Registry } from "azure-iothub";

const httpTrigger: AzureFunction = async function (
  context: Context,
  req: HttpRequest
): Promise<void> {
  const deviceId = context.bindingData.deviceId;
  const color = context.bindingData.color;

  if (!deviceId) {
    context.res = {
      status: 400,
      body: "Please send the device id either via query or body",
    };
    return;
  }

  const registry = Registry.fromConnectionString(
    process.env["IOT_HUB_CONNECTION_STRING"]
  );

  try {
    const response = await registry?.getTwin(deviceId);
    const { $metadata, $version, ...tilts } =
      response.responseBody.properties.reported;

    const bodyContent = color ? tiltWithColor(tilts, color) : { tilts };

    context.res = {
      body: { lastUpdated: $metadata.$lastUpdated, ...bodyContent },
    };
  } catch (error) {
    context.log(error);

    if (error.message === "Not found") {
      context.res = {
        status: 400,
        body: {
          message: "Device with the given deviceId/color does not exist",
        },
      };
      return;
    }

    context.res = {
      status: 500,
      body: { message: "Internal server error", error: error.message },
    };
  }
};

function tiltWithColor(tilts, color) {
  const tilt = Object.entries(tilts).find(
    ([currentColor, _]) => currentColor.toLowerCase() === color
  );

  if (!tilt || typeof tilt[1] !== "object") {
    throw new Error("Not found");
  }

  return tilt[1];
}

export default httpTrigger;
