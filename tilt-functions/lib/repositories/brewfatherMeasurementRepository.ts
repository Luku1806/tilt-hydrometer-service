import axios from "axios";
import { BrewfatherMeasurement } from "../models/brewfatherMeasurement";

export class BrewfatherMeasurementRepository {
  constructor(
    private readonly id: string,
    private readonly url = "http://log.brewfather.net"
  ) {}

  async create(measurement: BrewfatherMeasurement) {
    await axios.post(`${this.url}/stream?id=${this.id}`, measurement);
  }
}
