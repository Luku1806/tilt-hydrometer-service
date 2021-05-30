import { TiltMeasurement } from "../models/tiltMeasurement";
import { TiltTimeSeriesModel } from "../models/tiltTimeSeries";

export class TiltMeasurementRepository {
  async create(adapterId: string, color: string, measurement: TiltMeasurement) {
    await TiltTimeSeriesModel.findOneAndUpdate(
      { adapterId, color },
      { adapterId, color, $push: { measurements: { value: measurement } } },
      { new: true, upsert: true }
    );
  }

  async findByIdAndColor(adapterId: string, color: string) {
    return await TiltTimeSeriesModel.findOne({ adapterId, color });
  }
}
