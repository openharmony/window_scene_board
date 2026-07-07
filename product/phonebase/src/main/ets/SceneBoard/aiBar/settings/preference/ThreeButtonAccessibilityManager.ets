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

import { CheckEmptyUtils, LogDomain, Logger, SingletonHelper } from '@ohos/basicutils';
import { SCBGestureNavSetMgr } from '@ohos/componenthelper';
import { FloatingNavigationManager } from '../../proxy/FloatingNavigationManager';
import { AiBarSettingsDataMgr } from './AiBarSettingsDataMgr';
import { SwitchType } from './PreferenceType';
import settings from '@ohos.settings';
import { Constants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { GlobalContext, } from '@ohos/frameworkwrapper';
import type abilityCommon from '@ohos.app.ability.common';

const TAG: string = 'ThreeButtonAccessibilityManager';
const log: Logger = Logger.getLogHelper(LogDomain.GESTURE);

export enum FloatAccessibilityBeforeOpen {
  THREE_OPEN = '0',
  FLOAT_BALL_OPEN = '1',
  ALL_OPEN = '2',
  ALL_CLOSE = '3'
}

export class ThreeButtonAccessibilityManager {
  /**
   * 用于保持无障碍开启前，三键和悬浮球开关状态的key
   */
  private floatAccessibilityBeforeOpen: string = 'float_accessibility_before_open';

  /**
   * 无障碍期间三键状态
   */
  private floatNavAccessibilityModeState: string = 'float_nav_accessibility_mode_state';

  /**
   * 获取单例
   * @returns 返回实例
   */
  static getInstance(): ThreeButtonAccessibilityManager {
    return SingletonHelper.getInstance(ThreeButtonAccessibilityManager, TAG);
  }

  public async closeFloatBallAndSaveBeforeOpen(context: abilityCommon.ServiceExtensionContext): Promise<void> {
    let threeButtonValue: string = Constants.SYSTEM_NAVIGATION_GESTURE;
    try {
      //三键开关状态
      threeButtonValue =
        await settings.getValue(context, SwitchType.FLOATING_NAV_STATUS, settings.domainName.USER_PROPERTY);
    } catch (e) {
      log.showError(TAG, `getThreeButtonValue ${e?.code}, msg: ${e?.message}`);
    }
    let floatBallValue: string = AiBarSettingsDataMgr.getInstance().ballOff;
    try {
      //悬浮球开关状态
      floatBallValue =
        await settings.getValue(context, SwitchType.FLOATING_BALL, settings.domainName.USER_PROPERTY);
    } catch (e) {
      log.showError(TAG, `getFloatBallValue ${e?.code}, msg: ${e?.message}`);
    }
    let floatBeforeOpen: FloatAccessibilityBeforeOpen = this.getFloatBeforeOpenState(threeButtonValue, floatBallValue);
    try {
      settings.setValue(context, this.floatAccessibilityBeforeOpen, floatBeforeOpen,
        settings.domainName.USER_PROPERTY);
      // 开启无障碍,关闭悬浮球开关
      AiBarSettingsDataMgr.getInstance().closeFloatingBall();
    } catch (e) {
      log.showError(TAG, `closeFloatBallAndSaveBeforeOpen ${e?.code}, msg: ${e?.message}`);
    }
  }

  private getFloatBeforeOpenState(threeButtonValue: string, floatBallValue: string): FloatAccessibilityBeforeOpen {
    if (threeButtonValue === Constants.SYSTEM_NAVIGATION_FLOATING &&
      floatBallValue === AiBarSettingsDataMgr.getInstance().ballOn) {
      // 悬浮球和三键都打开
      return FloatAccessibilityBeforeOpen.ALL_OPEN
    }
    let floatBeforeOpen: FloatAccessibilityBeforeOpen = FloatAccessibilityBeforeOpen.ALL_CLOSE
    //保存，开启前悬浮球和三键的开关状态
    if (threeButtonValue === Constants.SYSTEM_NAVIGATION_FLOATING) {
      // 三键开
      floatBeforeOpen = FloatAccessibilityBeforeOpen.THREE_OPEN
    }
    if (floatBallValue === AiBarSettingsDataMgr.getInstance().ballOn) {
      // 悬浮球开
      floatBeforeOpen = FloatAccessibilityBeforeOpen.FLOAT_BALL_OPEN
    }
    return floatBeforeOpen;
  }

  /**
   * 恢复之前开关状态
   *
   * @param context 上下文
   * @param beforeOpenValue 之前状态
   */
  private restoreFloatBeforeOpenState(beforeOpenValue: string): void {
    switch (beforeOpenValue) {
      case FloatAccessibilityBeforeOpen.THREE_OPEN:
        AiBarSettingsDataMgr.getInstance().openThreeButton();
        AiBarSettingsDataMgr.getInstance().closeFloatingBall();
        break;
      case FloatAccessibilityBeforeOpen.FLOAT_BALL_OPEN:
        AiBarSettingsDataMgr.getInstance().openFloatingBall();
        AiBarSettingsDataMgr.getInstance().closeThreeButton();
        break;
      case FloatAccessibilityBeforeOpen.ALL_OPEN:
        AiBarSettingsDataMgr.getInstance().openFloatingBall();
        AiBarSettingsDataMgr.getInstance().openThreeButton();
        break;
      case FloatAccessibilityBeforeOpen.ALL_CLOSE:
        AiBarSettingsDataMgr.getInstance().closeFloatingBall();
        AiBarSettingsDataMgr.getInstance().closeThreeButton();
        break;
      default:
        log.showError(TAG, `not has beforeOpenValue`);
        break;
    }
  }

  /**
   * 保存无障碍期间三键状态
   *
   * @param floatNav 三键状态
   */
  public async saveFloatNavAccessibilityModeState(floatNav: string): Promise<void> {
    let context = GlobalContext.getContext();
    if (!context) {
      log.showError(TAG, 'saveFloatNavAccessibilityModeState context is undefined or null');
      return;
    }
    try {
      settings.setValue(context, this.floatNavAccessibilityModeState, floatNav,
        settings.domainName.USER_PROPERTY);
    } catch (e) {
      log.showError(TAG, `saveFloatNavAccessibilityModeState ${e?.code}, msg: ${e?.message}`);
    }
  }


  /**
   * 获取无障碍期间三键状态
   * @returns 无障碍期间三键状态
   */
  public async getFloatNavAccessibilityModeState(): Promise<string> {
    let context = GlobalContext.getContext();
    if (!context) {
      log.showError(TAG, 'saveFloatNavAccessibilityModeState context is undefined or null');
      return '';
    }
    let floatNavAccessibilityModeState: string = '';
    try {
      floatNavAccessibilityModeState =
        await settings.getValue(context, this.floatNavAccessibilityModeState, settings.domainName.USER_PROPERTY);
    } catch (e) {
      log.showError(TAG, `getFloatNavAccessibilityModeState ${e?.code}, msg: ${e?.message}`);
    }
    return floatNavAccessibilityModeState;
  }

  /**
   * 无障碍状态改变
   */
  public async onChangeAccessibilityModeStateChange(isAccessibilityMode: boolean): Promise<void> {
    log.showInfo(TAG, `onChangeAccessibilityModeState ${isAccessibilityMode}`);
    try {
      let context = GlobalContext.getContext();
      if (!context) {
        log.showError(TAG, 'onChangeAccessibilityModeStateChange context is undefined or null');
        return;
      }

      if (isAccessibilityMode) {
        await this.closeFloatBallAndSaveBeforeOpen(context);
      }

      // 进入无障碍模式，设置三键为开启，并重置三键位置
      if (isAccessibilityMode && SCBGestureNavSetMgr.isSupportFloatNavigation()) {
        log.showInfo(TAG, 'isSupportFloatNavigation is true');
        await this.handleAccessibilityModeOpen();
      } else {
        // 关闭无障碍，恢复开启无障碍之前的开关状态
        let beforeOpenValue: string =
          await settings.getValue(context, this.floatAccessibilityBeforeOpen, settings.domainName.USER_PROPERTY);
        log.showInfo(TAG, `beforeOpenValue is ${beforeOpenValue}`);
        // 根据之前状态回复开关值
        this.restoreFloatBeforeOpenState(beforeOpenValue);
      }
    } catch (e) {
      log.showError(TAG, `onChangeAccessibilityModeStateChange ${e?.code}, msg: ${e?.message}`);
    }
  }

  private async handleAccessibilityModeOpen() {
    try {
      let floatNav = await this.getFloatNavAccessibilityModeState();
      log.showInfo(TAG, `handelAccessibilityModeOpen ${floatNav}`);
      if (CheckEmptyUtils.isEmpty(floatNav) || floatNav === Constants.SYSTEM_NAVIGATION_FLOATING) {
        AiBarSettingsDataMgr.getInstance()
          .putValue(SwitchType.FLOATING_NAV_STATUS, Constants.SYSTEM_NAVIGATION_FLOATING,
            settings.domainName.USER_PROPERTY);
        FloatingNavigationManager.getInstance().setShowVerifyImmersiveState(true);
      } else {
        AiBarSettingsDataMgr.getInstance().closeThreeButton();
      }
    } catch (e) {
      log.showError(TAG, `handelAccessibilityModeOpen ${e?.code}, msg: ${e?.message}`);
    }
  }
}

export const threeButtonAccessibilityMgr = ThreeButtonAccessibilityManager.getInstance();