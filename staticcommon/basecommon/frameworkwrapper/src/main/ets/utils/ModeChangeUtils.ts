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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import systemParameterEnhance from '@ohos.systemParameterEnhance';

const TAG = 'ModeChangeUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
export const DELAY_TIME: number = 150;

/**
 * qxs模式切换工具类
 *
 * @since 2025-05-07
 */
export class ModeChangeUtils {
  private static isPcModeCache: boolean | undefined = undefined;
  private static sIsSupportWindowPcModeSwitch: boolean | undefined = undefined;
  private static shutDownViewCallback: Function | undefined = undefined;

  public static registerShutDownViewCallback(cb: Function, tag: string): void {
    if (cb) {
      log.showInfo('registerShutDownViewCallback, tag:' + tag);
      ModeChangeUtils.shutDownViewCallback = cb;
    }
  }

  public static unRegisterShutDownViewCallback(tag: string): void {
    log.showInfo('unRegisterShutDownViewCallback, tag:' + tag);
    ModeChangeUtils.shutDownViewCallback = undefined;
  }

  public static execShutDownViewCallback(): void {
    if (ModeChangeUtils.shutDownViewCallback !== undefined) {
      ModeChangeUtils.shutDownViewCallback();
    }
  }

  static isPcMode(): boolean {
    if (ModeChangeUtils.isPcModeCache !== undefined) {
      return ModeChangeUtils.isPcModeCache;
    }
    if (!ModeChangeUtils.isSupportWindowPcModeSwitch()) {
      ModeChangeUtils.isPcModeCache = false;
      return false;
    }
    try {
      let res = systemParameterEnhance.getSync('persist.sceneboard.ispcmode', 'false');
      log.showInfo('ispcmode, res:' + res);
      ModeChangeUtils.isPcModeCache = res === 'true';
      return ModeChangeUtils.isPcModeCache;
    } catch (e) {
      log.showError(`Get pc mode switch failed`);
      return false;
    }
  }

  /**
   * 是否支持PAD/PC模式切换
   */
  static isSupportWindowPcModeSwitch(): boolean {
    if (ModeChangeUtils.sIsSupportWindowPcModeSwitch !== undefined) {
      return ModeChangeUtils.sIsSupportWindowPcModeSwitch;
    }
    try {
      ModeChangeUtils.sIsSupportWindowPcModeSwitch =
        systemParameterEnhance.getSync('const.window.support_window_pcmode_switch', 'false') === 'true';
      log.showDebug(`suppport windwo pcmode switch: ${ModeChangeUtils.sIsSupportWindowPcModeSwitch}`);
      return ModeChangeUtils.sIsSupportWindowPcModeSwitch;
    } catch (e) {
      log.showError('Get switch supportWindowPcModeSwitch failed');
      return false;
    }
  }
}