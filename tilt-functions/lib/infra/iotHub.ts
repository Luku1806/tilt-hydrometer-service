import { Registry } from "azure-iothub";

export const deviceRegistry = Registry.fromConnectionString(
  process.env["IOT_HUB_CONNECTION_STRING"]
);

export function tiltWithColor(tilts: { [color: string]: any }, color: string) {
  const tilt = Object.entries(tilts).find(
    ([currentColor, _]) => currentColor.toLowerCase() === color
  );

  if (!tilt || typeof tilt[1] !== "object") {
    throw new Error("Not found");
  }

  return tilt[1];
}
