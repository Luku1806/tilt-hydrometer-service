import * as noble from "@abandonware/noble";

const EXPECTED_MANUFACTURER_DATA_LENGTH = 25;
const APPLE_COMPANY_IDENTIFIER = 0x004c;
const IBEACON_TYPE = 0x02;
const EXPECTED_IBEACON_DATA_LENGTH = 0x15;

export type Proximity = "unknown" | "immediate" | "near" | "far";

export interface IBeacon {
  uuid: string;
  major: number;
  minor: number;
  measuredPower: number;
  rssi: number;
  accuracy: number;
  proximity: Proximity;
}

export function isIBeacon(peripheral: noble.Peripheral): boolean {
  const manufacturer = peripheral.advertisement.manufacturerData;

  return (
    EXPECTED_MANUFACTURER_DATA_LENGTH <= manufacturer?.length &&
    APPLE_COMPANY_IDENTIFIER === manufacturer.readUInt16LE(0) &&
    IBEACON_TYPE === manufacturer.readUInt8(2) &&
    EXPECTED_IBEACON_DATA_LENGTH === manufacturer.readUInt8(3)
  );
}

export function parseIBeaconData(peripheral: noble.Peripheral): IBeacon {
  if (!isIBeacon(peripheral)) {
    throw new Error("The supplied peripheral is no iBeacon");
  }

  const manufacturer = peripheral.advertisement.manufacturerData;

  const rssi = peripheral.rssi;
  const uuid = manufacturer.slice(4, 20).toString("hex");
  const major = manufacturer.readUInt16BE(20);
  const minor = manufacturer.readUInt16BE(22);
  const measuredPower = manufacturer.readInt8(24);

  const accuracy = Math.pow(12.0, 1.5 * (rssi / measuredPower - 1));
  const proximity =
    accuracy < 0
      ? "unknown"
      : accuracy < 0.5
      ? "immediate"
      : accuracy < 4.0
      ? "near"
      : "far";

  return {
    uuid,
    major,
    minor,
    measuredPower,
    rssi,
    accuracy,
    proximity,
  };
}
