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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import bundleManager from '@ohos.bundle.bundleManager';
import { OverflowConstants } from '@ohos/commonconstants';
import { GameCardInfo, GridLayoutItemInfo } from '@ohos/launchercommon';

const TAG = 'OverflowFormUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEFAULT_USER_ID: number = 100;
const SPLIT_CHAR: string = '|';
const GESTURE_SET: Set<string> =
  new Set([DisableGesture.SWIPE_DESKTOP, DisableGesture.PULL_DOWN_SEARCH, DisableGesture.LONG_CLICK,
    DisableGesture.DRAG]);
const EPSILON: number = 1e-2;

// 被禁止的手势
export const enum DisableGesture {
  SWIPE_DESKTOP = 'SWIPE_DESKTOP',
  PULL_DOWN_SEARCH = 'PULL_DOWN_SEARCH',
  LONG_CLICK = 'LONG_CLICK',
  DRAG = 'DRAG',
  NONE = 'NONE'
}

export default class OverflowFormUtils {
  private static isTouch: boolean = false;

  /**
   * 设置是否正在操作激活态的游戏卡片
   *
   * @param isTouch 在激活态的游戏卡片上滑动长按等
   */
  public static setActiveFormTouch(isTouch: boolean): void {
    log.showInfo(`setActiveFormTouch is ${isTouch}`);
    OverflowFormUtils.isTouch = isTouch;
  }

  /**
   * 获取在激活态游戏卡片上操作
   *
   * @returns 是否在操作激活态的游戏卡片
   */
  public static getActiveFormTouch(): boolean {
    log.showInfo(`getActiveFormTouch, isActiveFormTouch = ${OverflowFormUtils.isTouch}`);
    return OverflowFormUtils.isTouch;
  }

  /**
   * 系统应用认证
   *
   * @param bundleName
   * @returns boolean
   */
  public static isSystemApp(bundleName: string): boolean {
    let applicationFlags = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
    try {
      let applicationInfo = bundleManager.getApplicationInfoSync(bundleName, applicationFlags,
        OverflowFormUtils.getCurrentUserId());
      if (applicationInfo && applicationInfo.systemApp) {
        return true;
      }
    } catch (error) {
      log.error('call isSystemApp error', error);
    }
    return false;
  }

  /**
   * 判断该手势是否要禁止
   * @param gesture 手势
   * @returns 是否禁止
   */
  public static isBehaviorDisabled(gesture: string, formItem: GridLayoutItemInfo | undefined): boolean {
    // funInteraction默认禁掉；SceneAnimation查看手势
    if (!formItem) {
      log.showInfo('isBehaviorDisabled no active form');
      return false;
    }
    let gameCardInfo: GameCardInfo | undefined = formItem.gameCardInfo;
    if (!gameCardInfo) {
      log.showError('isBehaviorDisabled no info');
      return false;
    }
    let isFunInteraction: boolean = gameCardInfo.extensionType === OverflowConstants.INTERACTION_TYPE ||
      gameCardInfo.gameType === OverflowConstants.QUICK_TYPE_GAMECARD;
    let isAnimationType = gameCardInfo.extensionType === OverflowConstants.ANIMATION_TYPE;
    let isSystemApp: boolean = OverflowFormUtils.isSystemApp(formItem.bundleName);

    // 游戏卡片默认屏蔽系统事件，非游戏卡片分情况讨论
    // 1. 系统应用：根据配置进行判断是否屏蔽
    // 2. 非系统应用：不支持屏蔽系统事件
    if (isFunInteraction || (isAnimationType && isSystemApp &&
      OverflowFormUtils.hasBehaviorDisabled(gameCardInfo, gesture))) {
      return true;
    }
    return false;
  }

  public static isBiggerOrEqual(left: number, right: number): boolean {
    return OverflowFormUtils.isBigger(left, right) || OverflowFormUtils.isEqual(left, right);
  }

  public static isSmallerOrEqual(left: number, right: number): boolean {
    return OverflowFormUtils.isSmaller(left, right) || OverflowFormUtils.isEqual(left, right);
  }

  private static isBigger(left: number, right: number): boolean {
    return left - right > EPSILON;
  }

  private static isSmaller(left: number, right: number): boolean {
    return right - left > EPSILON;
  }

  private static isEqual(left: number, right: number): boolean {
    return Math.abs(left - right) < EPSILON;
  }

  /**
   * 获取禁止手势
   * @param gameCardInfo 3D live 卡片信息
   * @param gesture 手势
   * @returns 禁止手势
   */
  private static hasBehaviorDisabled(gameCardInfo: GameCardInfo, gesture: string): boolean {
    if (!gameCardInfo || !gameCardInfo.disabledDesktopBehaviors) {
      log.showError('hasBehaviorDisabled undefined gamecardInfo');
      return false;
    }
    let disabledDesktopBehaviors: string[] = gameCardInfo.disabledDesktopBehaviors.trim().split(SPLIT_CHAR);
    if (disabledDesktopBehaviors.length <= 0) {
      log.showError('hasBehaviorDisabled invalid behaviors length');
      return false;
    }
    log.showDebug(`hasBehaviorDisabled init behaviors length ${disabledDesktopBehaviors.length}`);
    if (!GESTURE_SET.has(gesture)) {
      log.showError('hasBehaviorDisabled invalid behaviors value');
      return false;
    }
    let result: boolean = disabledDesktopBehaviors.some(behavior => behavior.trim() === gesture);
    log.showInfo(`hasBehaviorDisabled, gesture: ${gesture} is ${result ? 'disabled' : 'not disabled'}`);
    return result;
  }

  private static getCurrentUserId(): number {
    let currentUserId: number | undefined = AppStorage.get<number>('mCurrentUserId');
    if (!currentUserId) {
      currentUserId = DEFAULT_USER_ID;
    }
    return currentUserId;
  }
}