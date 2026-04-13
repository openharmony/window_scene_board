/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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