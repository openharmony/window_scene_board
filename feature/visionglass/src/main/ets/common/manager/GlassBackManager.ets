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
import { GlassSceneManager } from '../../scene/common/GlassSceneManager';
import { GlassSystemSceneManager } from '../../scene/common/GlassSystemSceneManager';

const TAG: string = 'GlassBackManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export class GlassBackManager {
  private static instance?: GlassBackManager;

  private constructor() {
  }

  public static getInstance(): GlassBackManager {
    if (!GlassBackManager.instance) {
      log.showInfo(`getInstance new instance`);
      GlassBackManager.instance = new GlassBackManager();
    }
    return GlassBackManager.instance;
  }

  public static destroyInstance(): void {
    GlassBackManager.instance = undefined;
  }

  /**
   * 后退
   *
   * @param exit 是否退出应用
   */
  public back(): void {
    if (GlassSystemSceneManager.getInstance().hasWindowMutexWithDesktop(true)) {
      log.showWarn(`back cancel,hasWindowMutexWithDesktop`);
      return;
    }
    GlassSceneManager.getInstance().processBackEvent();
    log.showInfo(`back success`);
  }

  /*
   * Home键任务处理
   *
   * @return
   * */
  public handleHomeKey(): HandleHomeKeyResult {
    let hasWindowMutexWithDesktop: boolean = GlassSystemSceneManager.getInstance().hasWindowMutexWithDesktop(false);
    let activeWant: Want | undefined = GlassSceneManager.getInstance().getActiveWant();
    if (!hasWindowMutexWithDesktop && (activeWant === undefined)) {
      log.showWarn(`handleHomeKey HOME_CANCEL,hasWindowMutexWithDesktop ${hasWindowMutexWithDesktop},activeWant is exist ${activeWant ===
        undefined}`);
      return HandleHomeKeyResult.HOME_CANCEL;
    }
    GlassSceneManager.getInstance().minimizeAllScene();
    GlassSystemSceneManager.getInstance().closeAllSystemWindow();
    log.showInfo(`handleHomeKey HOME_SUCCESS`);
    return HandleHomeKeyResult.HOME_SUCCESS;
  }
}

export enum HandleHomeKeyResult {
  HOME_SUCCESS = 'handle_success',
  HOME_CANCEL = 'handle_cancel',
}