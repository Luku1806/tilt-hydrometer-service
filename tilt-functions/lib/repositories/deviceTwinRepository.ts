import { Device, Twin } from "azure-iothub";
import * as IoTHub from "../infra/iotHub";

export class DeviceTwinRepository {
  async findById(deviceId: string): Promise<Twin> {
    const response = await IoTHub.deviceRegistry.getTwin(deviceId);
    return response.responseBody;
  }

  async update(twin: Twin, patch: any): Promise<void> {
    await twin.update(patch);
  }
}
