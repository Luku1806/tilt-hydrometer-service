import * as noble from "@abandonware/noble";
import * as mdns from "mdns";
import * as azureIotDevice from "azure-iot-device";

import * as Tilt from "./tilt";
import * as IotHub from "./iotHub";

function registerDataHandler(twin: azureIotDevice.Twin) {
  noble.on("discover", async (peripheral) => {
    if (Tilt.isTilt(peripheral)) {
      const tiltData = Tilt.parseTiltData(peripheral);
      await IotHub.updateTwin(tiltData, twin);

      console.log("Received data from Tilt device", tiltData);
    }
  });
}

function startBluetoothScanning(duplicates: boolean) {
  console.log("Scanning for Tilt devices");

  if (noble.state === "poweredOn") {
    noble.startScanning([], duplicates);
  }

  noble.on("stateChange", function (newState) {
    if (newState === "poweredOn") {
      noble.startScanning([], duplicates);
    }
  });
}

function startMdnsAdvertising() {
  mdns.createAdvertisement(mdns.tcp("tilt"), 8080).start();
}

async function start() {
  startMdnsAdvertising();
  startBluetoothScanning(true);

  const twin = await IotHub.connectTwin();
  registerDataHandler(twin);
}

start();
