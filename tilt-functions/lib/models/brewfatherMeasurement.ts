export interface BrewfatherMeasurement {
  readonly name: string;
  readonly temp?: number;
  readonly aux_temp?: number; // Fridge Temp
  readonly ext_temp?: number; // Room Temp
  readonly temp_unit?: "C";
  readonly gravity?: number;
  readonly gravity_unit?: "G";
  readonly battery?: number;
}
