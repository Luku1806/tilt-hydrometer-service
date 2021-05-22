import { IBeacon, isIBeacon, parseIBeaconData } from "./iBeacon";
import * as noble from "@abandonware/noble";

export const TiltUUIDs = {
  Black: "A495BB30C5B14B44B5121370F02D74DE",
  Blue: "A495BB60C5B14B44B5121370F02D74DE",
  Green: "A495BB20C5B14B44B5121370F02D74DE",
  Orange: "A495BB50C5B14B44B5121370F02D74DE",
  Pink: "A495BB80C5B14B44B5121370F02D74DE",
  Purple: "A495BB40C5B14B44B5121370F02D74DE",
  Red: "A495BB10C5B14B44B5121370F02D74DE",
  Yellow: "A495BB70C5B14B44B5121370F02D74DE",
};

export type Color =
  | "Black"
  | "Blue"
  | "Green"
  | "Orange"
  | "Pink"
  | "Purple"
  | "Red"
  | "Yellow";

export interface Temperature {
  celsius: number;
  fahrenheit: number;
}

export interface TiltData {
  color: Color;
  temperature: Temperature;
  specificGravity: number;
}

export function isTilt(peripheral: noble.Peripheral): boolean {
  if (!isIBeacon(peripheral)) {
    return false;
  }

  const iBeacon = parseIBeaconData(peripheral);
  return Object.values(TiltUUIDs).some(
    (uuid) => uuid.toLowerCase() === iBeacon.uuid.toLowerCase()
  );
}

export function parseTiltData(peripheral: noble.Peripheral): TiltData {
  const iBeacon = parseIBeaconData(peripheral);
  return {
    color: color(iBeacon.uuid),
    temperature: parseTemperature(iBeacon),
    specificGravity: parseSpecificGravity(iBeacon),
  };
}

function parseTemperature(iBeacon: IBeacon): Temperature {
  return {
    fahrenheit: iBeacon.major,
    celsius: (iBeacon.major - 32) / 1.8,
  };
}

function parseSpecificGravity(iBeacon: IBeacon): number {
  return iBeacon.minor / 1000;
}

function isColor(candidate: string): candidate is Color {
  return Object.keys(TiltUUIDs).includes(candidate);
}

export function color(uuid: string): Color {
  const tilt = Object.entries(TiltUUIDs).find(
    ([color, colorUuid]) => colorUuid.toLowerCase() === uuid.toLowerCase()
  );

  if (!tilt || !isColor(tilt[0])) {
    throw new Error("The supplied uuid is not a tilt device");
  }

  return tilt[0];
}
