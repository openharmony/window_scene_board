import { Log } from "../aigcServiceAbility/IdlService/Log";
import { display } from "@kit.ArkUI";

const TAG = 'DeviceHelper';

export class DeviceHelper {
  static async getAllResolutions(): Promise<Map<number, number[]>> {
    let resolutionArray: DisplayPhysicalResolution[];
    try {
      resolutionArray = await display.getAllDisplayPhysicalResolution();
    } catch (err) {
      Log.error(TAG, `getAllResolutions error ${err}`);
      return Promise.reject();
    }
    Log.info(TAG, `getAllResolutions resolutionArray = ${JSON.stringify(resolutionArray)}`);
    let resolutionMap: Map<number, number[]> = new Map();
    resolutionArray.forEach((value) => {
      if (!resolutionMap.has(value.foldDisplayMode)) {
        resolutionMap.set(value.foldDisplayMode, [value.physicalWidth, value.physicalHeight]);
      }
    });
    return resolutionMap;
  }

  static getDefaultDisplay(): display.Display | undefined {
    let defaultDisplay: display.Display | undefined = undefined;
    try {
      defaultDisplay = display.getDefaultDisplaySync();
    } catch (err) {
      Log.error(TAG, `getDafaultDisplay err: ${err}`);
    }
    return defaultDisplay;
  }
}

export interface DisplayPhysicalResolution {
  foldDisplayMode: number;
  physicalWidth: number;
  physicalHeight: number;
}