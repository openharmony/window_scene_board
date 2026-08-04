/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, ScreenStateMonitor, ScreenStateModel } from '@ohos/frameworkwrapper';

const TAG = 'StartAndExitUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export enum StartAndExitResponse {
  // 正常启动场景：桌面、负一屏
  NORMAL_START,
  // 其他启动场景：中心启动、分屏启动
  OTHER_START,
  // 退出场景：桌面、负一屏、全搜、HDC命令、异常退出
  EXIT
}

const NORMAL_START_RESPONSE_MAP = new Map<string, number>([
  ['F_landscape', 0.26],
  ['F_portrait', 0.26],
  ['M_landscape', 0.285],
  ['M_portrait', 0.285],
  ['G_landscape', 0.295],
  ['G_portrait', 0.314],
]);

const OTHER_START_RESPONSE_MAP = new Map<string, number>([
  ['F_landscape', 0.3],
  ['F_portrait', 0.3],
  ['M_landscape', 0.33],
  ['M_portrait', 0.33],
  ['G_landscape', 0.34],
  ['G_portrait', 0.36],
]);

const EXIT_RESPONSE_MAP = new Map<string, number>([
  ['F_landscape', 0.5],
  ['F_portrait', 0.5],
  ['M_landscape', 0.55],
  ['M_portrait', 0.55],
  ['G_landscape', 0.58],
  ['G_portrait', 0.61],
]);

export class StartAndExitUtil {
  public static getResponse(responseType: number): number {
    let response: number;
    let screenStateKey: string = 'F_portrait';
    // 三折叠设备根据断点信息区分不同屏幕形态
    if (DeviceHelper.isThreeFoldProduct()) {
      let screenModel: ScreenStateModel = ScreenStateMonitor.getInstance().getCurrentScreenStateModel();
      screenStateKey = screenModel.screenState + '_' + screenModel.orientation;
    }
    switch (responseType) {
      case StartAndExitResponse.NORMAL_START:
        response = NORMAL_START_RESPONSE_MAP.get(screenStateKey) || 0.26;
        break;
      case StartAndExitResponse.OTHER_START:
        response = OTHER_START_RESPONSE_MAP.get(screenStateKey) || 0.3;
        break;
      case StartAndExitResponse.EXIT:
        response = EXIT_RESPONSE_MAP.get(screenStateKey) || 0.5;
        break;
      default:
        response = NORMAL_START_RESPONSE_MAP.get(screenStateKey) || 0.26;
        break;
    }
    log.showWarn(`get screenStateKey: ${screenStateKey}, responseType: ${responseType}, response: ${response}`);
    return response;
  }
}