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
import { GestureEnableCaller, scbGestureManager } from '@ohos/windowscene';
import { KeyguardStatusService, OccludedStateManager, ScreenLockStateManager } from '@ohos/screenlockcommon';

const TAG = 'GestureNaviUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 系统导航使能工具类
 */
export class GestureNaviUtil {
  /**
   * 设置导航使能情况，内置优先级逻辑
   *
   * @param isGestureBackEnable back手势使能
   * @param isGestureNavbarEnable home手势使能
   */
  public static setGestureNavigationEnableState(isGestureBackEnable: boolean,
    isGestureNavbarEnable: boolean, forceSet: boolean = true): void {
    let isOcclude: boolean = OccludedStateManager.getInstance().isOccluded;
    let isPageShow: boolean = ScreenLockStateManager.getInstance().isPageShow;
    if (isOcclude || !isPageShow) {
      log.showInfo(`under using state: isOcclude ${isOcclude} isLocked ${isPageShow}, enable anyway.`);
      if (forceSet) {
        scbGestureManager.setGestureNavigationEnablePriority(GestureEnableCaller.SCREEN_LOCK, true, true);
      } else {
        scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.SCREEN_LOCK, true, true);
      }
      return;
    }
    if (forceSet) {
      scbGestureManager.setGestureNavigationEnablePriority(GestureEnableCaller.SCREEN_LOCK,
        isGestureBackEnable, isGestureNavbarEnable);
    } else {
      scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.SCREEN_LOCK,
        isGestureBackEnable, isGestureNavbarEnable);
    }
  }
}