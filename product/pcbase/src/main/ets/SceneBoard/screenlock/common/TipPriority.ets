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

import { CheckEmptyUtils, SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ScreenLock-TipPriority';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class TipPriorityConstants {
  /**
   * always hide tip priority
   */
  public static readonly TIP_PRIORITY_ALWAYS_HIDE = 0;
  /**
   * base tip show priority
   */
  public static readonly TIP_PRIORITY_BASE_DEFAULT = 10;
  /**
   * auto tip priority
   */
  public static readonly TIP_PRIORITY_AUTO = 50;
  /**
   * tip priority for fingerprint locker timeout reshow
   */
  public static readonly TIP_PRIORITY_FINGER_PRINT_LOCKED_TIMEOUT_RESHOW = 70;
  /**
   * tip priority for fingerprint locker timeout
   */
  public static readonly TIP_PRIORITY_FINGER_PRINT_LOCKED_TIMEOUT = 50;
  /**
   * tip priority for password locker timeout reshow
   */
  public static readonly TIP_PRIORITY_PASSWORD_LOCKED_TIMEOUT_RESHOW = 70;
  /**
   * tip priority for password locker timeout
   */
  public static readonly TIP_PRIORITY_PASSWORD_LOCKED_TIMEOUT = 50;
  /**
   * tip priority for face locker timeout reshow
   */
  public static readonly TIP_PRIORITY_FACE_LOCKED_TIMEOUT_RESHOW = 70;
  /**
   * tip priority for face locker timeout
   */
  public static readonly TIP_PRIORITY_FACE_LOCKED_TIMEOUT = 50;
  /**
   * always show tip priority
   */
  public static readonly TIP_PRIORITY_ALWAYS_SHOW = 100;
  /**
   * bubbling tip priority
   */
  public static readonly TIP_PRIORITY_DEFAULT = undefined;
}

export interface TipPriorityConfig {
  name: string;
  visible: boolean;
  priority: number | undefined;
}

export enum TipConfigsIndex {
  FINGER_PRINT_TIP_INDEX = 0,
  PASSWORD_TIP_INDEX = 1,
  FACE_TIP_INDEX = 2,
  BASE_TIP_INDEX = 3,
}

export class TipPriorityScheduler {
  private tipConfigs: Array<TipPriorityConfig> = [
    { name: 'fingerprintTip', visible: false, priority: undefined },
    { name: 'passwordTip', visible: false, priority: undefined },
    { name: 'faceVerifyTip', visible: false, priority: undefined },
    { name: 'baseScreenUnlockTip', visible: true, priority: TipPriorityConstants.TIP_PRIORITY_BASE_DEFAULT }
  ]

  public getTipConfig(index: TipConfigsIndex): TipPriorityConfig {
    return this.tipConfigs[index];
  }

  private showTheTip(showPriority: number | undefined, arrayIndex: number) {
    for (let i = 0; i < this.tipConfigs.length; i++) {
      if (i == arrayIndex) {
        this.tipConfigs[i].visible = true;
        this.tipConfigs[i].priority = showPriority;
      } else {
        this.tipConfigs[i].visible = false;
      }
    }
  }

  private hideTheTip(showPriority: number | undefined, arrayIndex: number) {
    this.tipConfigs[arrayIndex].visible = false;
    this.tipConfigs[arrayIndex].priority = showPriority;
    let allHide = true;
    for (let i = 0; i < this.tipConfigs.length; i++) {
      allHide = allHide && (!this.tipConfigs[i].visible);
    }
    if (allHide) {
      this.tipConfigs[TipConfigsIndex.BASE_TIP_INDEX].visible = true;
      return;
    }
  }

  // 第一原则 动态切换
  // 第二原则 被动倒计时不触发动态切换，主动触发的倒计时通过使用不同showPriority触发动态切换
  public onShowPriorityChange(tip: string, showPriority: number | undefined, arrayIndex: number): void {
    let visible = CheckEmptyUtils.isEmpty(tip) ? false : true;
    if (showPriority == undefined) {
      if (visible) {
        this.showTheTip(showPriority, arrayIndex);
        return;
      } else {
        this.hideTheTip(showPriority, arrayIndex);
        return;
      }
      return;
    }
    if (visible) {
      if (this.tipConfigs[arrayIndex].visible) {
        this.tipConfigs[arrayIndex].priority = showPriority;
        return;
      } else {
        if (this.tipConfigs[arrayIndex].priority === showPriority) {
          return;
        } else {
          // 主动触发的倒计时通过使用不同showPriority触发动态切换
          this.showTheTip(showPriority, arrayIndex);
          return;
        }
      }
    } else {
      if (this.tipConfigs[arrayIndex].visible) {
        this.hideTheTip(showPriority, arrayIndex);
        return;
      } else if (this.tipConfigs[arrayIndex].priority === showPriority) {
        return;
      } else {
        log.showWarn(`unkonwn onShowPriorityChange case`);
        return;
      }
    }
  }

  public init(): void {
    for (let i = 0; i < this.tipConfigs.length; i++) {
      if (i === TipConfigsIndex.BASE_TIP_INDEX) {
        this.tipConfigs[i].visible = true;
        this.tipConfigs[i].priority = TipPriorityConstants.TIP_PRIORITY_BASE_DEFAULT;
      } else {
        this.tipConfigs[i].visible = false;
        this.tipConfigs[i].priority = undefined;
      }
    }
  }
}

export let tipPriorityScheduler = SingletonHelper.getInstance(TipPriorityScheduler, TAG);