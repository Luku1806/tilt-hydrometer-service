import { TiltColor } from "./tilt";

export interface IotHubTiltData {
  version: number;
  properties: {
    reported: {
      $metadata: Object;
      $version: number;
    } & TiltTwinData;
  };
}

type TiltTwinData = Partial<
  {
    [color in TiltColor]?: {
      startingGravity: number;
      specificGravity: number;
      temperature: {
        fahrenheit: number;
        celsius: number;
      };
    };
  }
>;
