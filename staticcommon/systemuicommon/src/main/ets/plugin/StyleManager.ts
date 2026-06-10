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

import display from '@ohos.display';
import {
  SingletonHelper,
  CommonUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
const TAG = 'Plugin-StyleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const DENSITY_200: number = 200;
const DENSITY_304: number = 304;

class StyleManager {
  private densityDPI: number;

  constructor() {
    let displayClass: display.Display;
    try {
      displayClass = display.getDefaultDisplaySync();
    } catch (exception) {
      log.error('constructor getDefaultDisplaySync err', exception);
    }
    this.densityDPI = displayClass?.densityDPI ?? DENSITY_304;
  }

  isPCDPI200(): boolean {
    return DeviceHelper.isPC() && this.densityDPI === DENSITY_200;
  }

  translateDPI(val: Length): Length {
    if (!this.isPCDPI200()) {
      return val;
    }
    return CommonUtils.splicePx(ResUtils.getNumberFromLengthExceptPx(val));
  }

  /**
   * Adapter startusBar Height  WGR1.5 PC1.25
   * @returns
   */
  vp2pxStatusBarPCHeight(): number {
    return !styleMgr.isPCDPI200() ? vp2px(ResUtils.getNumber($r('app.float.had_status_bar_pc_height'))) : ResUtils.getNumber($r('app.float.status_bar_pc_height'));
  }

  /**
   * Adapter startusBar Height  WGR1.5 PC1.25
   * @returns
   */
  px2vpStatusBarPCHeight(): number {
    return styleMgr.isPCDPI200() ? px2vp(ResUtils.getNumber($r('app.float.status_bar_pc_height'))) : ResUtils.getNumber($r('app.float.had_status_bar_pc_height'));
  }
}

// 单例
export let styleMgr = SingletonHelper.getInstance(StyleManager, TAG);