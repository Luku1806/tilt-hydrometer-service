import { AzureFunction, Context, HttpRequest } from "@azure/functions";
import { Registry } from "azure-iothub";

const httpTrigger: AzureFunction = async function (
  context: Context,
  req: HttpRequest
): Promise<void> {
  const deviceId = req.query.deviceId || req.body?.deviceId;

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

    context.res = {
      body: tilts,
    };
  } catch (error) {
    context.log(error);

    if (error.message === "Not found") {
      context.res = {
        status: 400,
        body: { message: "Device with the given deviceId does not exist" },
      };
      return;
    }

    context.res = {
      status: 500,
      body: { message: "Internal server error" },
    };
  }
};

export default httpTrigger;
