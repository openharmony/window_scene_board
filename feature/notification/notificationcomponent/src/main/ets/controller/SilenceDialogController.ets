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

import { CommonUtils, SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { NotificationType } from '../common/NotificationType';
import { NtfSettingsDialogVM } from '../vm/NtfSettingsDialogVM';

const TAG = 'SilenceDialogController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 静默弹窗控制器
 *
 */
class SilenceDialogController {
  /**
   * 弹框控制，一个面板一个控制器
   * NotificationType => 控制器
   */
  private settingsControllers: Map<number, CustomDialogController> = new Map();

  /**
   * 弹框当前是否正在显示
   * NotificationType => 弹框是否显示
   */
  private isDialogShowings: Map<number, boolean> = new Map();

  /**
   * 弹出弹框
   *
   * @param ntfType 通知面板类型
   * @param ntfEntry 通知数据
   */
  showDialog(ntfType: number, controller: CustomDialogController): void {
    if (DeviceHelper.isPC()) {
      if (CommonUtils.isInvalid(controller)) {
        return;
      }
    } else {

      if (CommonUtils.isInvalid(controller)) {
        return;
      }

      if (controller === this.settingsControllers.get(ntfType) && Object.keys(controller).length !== 0) {
        return;
      }
    }
    controller.open();
    this.settingsControllers.set(ntfType, controller);
    this.isDialogShowings.set(ntfType, true);
    log.showInfo(`showDialog, ntfType:${ntfType}`);
  }

  /**
   * 隐藏弹框
   *
   * @param ntfType 面板类型
   */
  hideDialog(ntfType: number): void {
    let controller = this.settingsControllers?.get(ntfType);
    controller?.close();
    this.settingsControllers?.delete(ntfType);
    this.isDialogShowings.set(ntfType, false);
    log.showInfo(`hideDialog, ntfType:${ntfType}`);
  }
}

// 单例
export let silenceDialogDC: SilenceDialogController = SingletonHelper.getInstance(SilenceDialogController, TAG);