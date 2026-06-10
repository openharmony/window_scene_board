/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { display } from '@kit.ArkUI';

const TAG = 'DisplayAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export interface IDisplayAdapterInfo {
  rotation: number;
  width: number;
  height: number;
  densityDPI: number;
  orientation: display.Orientation;
}

export class DisplayAdapter {
  public static getFoldStatus(): display.FoldStatus {
    try {
      return display.getFoldStatus();
    } catch (error) {
      log.showError(`getFoldStatus code: ${error?.code}, msg: ${error?.message}`);
    }
    return display.FoldStatus.FOLD_STATUS_UNKNOWN;
  }

  public static getDefaultDisplaySync(): IDisplayAdapterInfo {
    try {
      const defaultDisplaySync = display.getDefaultDisplaySync();
      return {
        rotation: defaultDisplaySync.rotation,
        width: defaultDisplaySync.width,
        height: defaultDisplaySync.height,
        densityDPI: defaultDisplaySync.densityDPI,
        orientation: defaultDisplaySync.orientation
      };
    } catch (e) {
      log.showError(`getDefaultDisplaySync code: ${e?.code}, msg: ${e?.message}`);
    }
    return {
      rotation: 0,
      width: 0,
      height: 0,
      densityDPI: 0,
      orientation: display.Orientation.PORTRAIT
    };
  }
}