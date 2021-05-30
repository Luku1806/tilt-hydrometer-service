import * as mongoose from "mongoose";

export interface TiltTimeSeriesDocument extends mongoose.Document {
  readonly adapterId: string;
  readonly color: string;
  readonly measurements: {
    readonly date: Date;
    readonly value: { temperature: Number; specificGravity: Number };
  }[];
}

const TiltTimeSeriesSchema = new mongoose.Schema({
  _id: false,
  adapterId: {
    type: String,
    unique: true,
    index: true,
    required: true,
  },
  color: {
    type: String,
    required: true,
  },
  measurements: {
    type: [
      {
        _id: false,
        date: { type: Date, default: Date.now },
        value: {
          type: {
            temperature: { type: Number, required: true },
            specificGravity: { type: Number, required: true },
          },
        },
      },
    ],
    default: [],
  },
});

export const TiltTimeSeriesModel = mongoose.model<TiltTimeSeriesDocument>(
  "TiltTimeSeries",
  TiltTimeSeriesSchema
);
