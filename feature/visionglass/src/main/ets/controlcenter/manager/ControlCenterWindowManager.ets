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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';

const TAG = 'ControlCenterWindowManager';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export enum ControlCenterWindowName {
  VISION_ADJUST_STEPS_WINDOW = 'VisionAdjustmentStepsComponent',
}

/*
 * 管理控制中心界面二级窗口显隐
 * */
export class ControlCenterWindowManager {
  public static instance: ControlCenterWindowManager | undefined = undefined;
  private updateWindowNameCallback?: ((name: ControlCenterWindowName) => void);

  public registerUpdateWindowNameCallback(callback: ((name: ControlCenterWindowName) => void)): void {
    this.updateWindowNameCallback = callback;
  }

  public unRegisterUpdateWindowNameCallback(): void {
    this.updateWindowNameCallback = undefined;
  }

  public openSubWindow(name: ControlCenterWindowName): void {
    if (this.updateWindowNameCallback) {
      this.updateWindowNameCallback(name);
    }
    GlassSystemSceneManager.getInstance().showSystemView(GlassSystemSceneType.GLASS_CONTROL_CENTER_SUBPAGE);
    GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_CONTROL);
  }

  public closeCurSubWindow(): void {
    GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_CONTROL_CENTER_SUBPAGE);
    GlassSystemSceneManager.getInstance().showSystemView(GlassSystemSceneType.GLASS_CONTROL);
  }

  public static getInstance(): ControlCenterWindowManager {
    if (!ControlCenterWindowManager.instance) {
      log.showInfo(`getInstance new instance`);
      ControlCenterWindowManager.instance = new ControlCenterWindowManager();
    }
    return ControlCenterWindowManager.instance;
  }

  public static destroyInstance(): void {
    log.showInfo(`destroyInstance`);
    ControlCenterWindowManager.instance = undefined;
  }
}