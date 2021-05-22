import * as noble from "@abandonware/noble";
import * as mdns from "mdns";

import { isTilt, parseTiltData } from "./tilt";

function registerBleHandler() {
  noble.on("discover", async (peripheral) => {
    if (isTilt(peripheral)) {
      const tiltData = parseTiltData(peripheral);
      console.log("Received data from Tilt device", tiltData);
    }
  });
}

function startScanning(duplicates: boolean) {
  console.log("Scanning for Tilt devices");

  if (noble.state === "poweredOn") {
    noble.startScanning([], duplicates);
    registerBleHandler();
  }

  noble.on("stateChange", function (newState) {
    if (newState === "poweredOn") {
      noble.startScanning([], duplicates);
      registerBleHandler();
    }
  });
}

function startMdnsAdvertising() {
  mdns.createAdvertisement(mdns.tcp("tilt"), 8080).start();
}

startMdnsAdvertising();
startScanning(true);
