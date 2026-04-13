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

import { TsCommonEventSubscribe } from '../../api/TsCommonEventSubscribe';
import { AsyncCallback } from '@ohos.base';
import base from '@ohos.base';
import { commonEventManager } from '@kit.BasicServicesKit';
import { EventEmitter, FileUtil, TsLog } from '@ohos/themeservicebase/Index';
import { ThemeActivationTarget, ThemeOwnershipType, ThemePathConstant } from '../../event/TsConstant';
import { TsEvent } from '../../event/TsEvent';
import { TsEventId } from '../../event/TsEventId';
import { TsEventProvider } from '../../TsEventProvider';

/**
 * 主题使能公共事件
 */
const COMMON_EVENT_ACTIVATE_THEME: string = 'com.ohos.ActivateTheme';
/**
 * 使能主题权限
 */
const PERMISSION_ACTIVATE_THEME: string = 'ohos.permission.ACTIVATE_THEME_PACKAGE';

const TAG: string = 'SubscribeActivateThemeImpl';

/**
 * 监听主题使能公共事件
 */
export class SubscribeActivateThemeImpl implements TsCommonEventSubscribe {
  getSubscribeInfo(userId?: number): commonEventManager.CommonEventSubscribeInfo {
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [COMMON_EVENT_ACTIVATE_THEME],
      userId: userId,
      publisherPermission: PERMISSION_ACTIVATE_THEME
    };
    return subscribeInfo;
  }

  getCallback(): AsyncCallback<commonEventManager.CommonEventData> {
    const callback: AsyncCallback<commonEventManager.CommonEventData> =
      (err: base.BusinessError, eventData: commonEventManager.CommonEventData) => {
        if (err || eventData === undefined) {
          TsLog.error(TAG, `Failed to receive commonEvent ${eventData?.event}`, err);
          return;
        }
        if (eventData.event !== COMMON_EVENT_ACTIVATE_THEME) {
          TsLog.info(TAG, `Unknown event = ${eventData.event}`);
          return;
        }
        TsLog.info(TAG, `Receive event = ${eventData.event}`);
        this.onThemeActivation(eventData);
      }
    return callback;
  }

  /**
   * 接收SA主题使能公共事件回调
   * @param eventData
   */
  private onThemeActivation(eventData: commonEventManager.CommonEventData): void {
    this.notifyThemeActivation(this.parseActivationOption(eventData));
  }

  /**
   * 解析SA发送的主题使能公共事件数据
   * @param eventData 公共事件数据
   * @returns 当前主题使能类型
   */
  private parseActivationOption(eventData: commonEventManager.CommonEventData): ThemeActivationTarget {
    if (!eventData || !eventData.parameters) {
      TsLog.warning(TAG, `parseActivationOption nil ,eventData is null`);
      return ThemeActivationTarget.NIL;
    }
    TsLog.info(TAG, `parseActivationOption`);
    let activationOptions: object = eventData.parameters as object;
    let activationTarget: number = 0;
    Object.keys(activationOptions).forEach(key => {
      if (activationOptions[key] as number !== 1) {
        return;
      }
      switch (key) {
        case 'aod': {
          activationTarget |= ThemeActivationTarget.AOD;
          break;
        }
        case 'home': {
          activationTarget |= ThemeActivationTarget.HOME;
          break;
        }
        case 'lock': {
          activationTarget |= ThemeActivationTarget.UNLOCK;
          break;
        }
        case 'unlock': {
          activationTarget |= ThemeActivationTarget.UNLOCK;
          break;
        }
        case 'sub_screen': {
          activationTarget |= ThemeActivationTarget.OUTER_LOCK;
          break;
        }
        default: {
          TsLog.warning(TAG, `Param ${key} will not be counted as activation option.`);
          break;
        }
      }
    });
    // 过滤只有锁屏时钟使能场景
    if (activationTarget === ThemeActivationTarget.UNLOCK) {
      if (TsEventProvider.getInstance().getIsOnlyClockActive()) {
        activationTarget = ThemeActivationTarget.ONLY_LOCK_CLOCK;
        TsEventProvider.getInstance().setOnlyClockActive(false);
      }
    }
    TsLog.info(TAG, `On activating theme, activation target is ${activationTarget}`);
    return activationTarget as ThemeActivationTarget;
  }

  /**
   * 发送主题使能事件
   * @param target
   */
  private notifyThemeActivation(target: ThemeActivationTarget): void {
    let themePath: string = this.getActiveThemePath();
    const tsEvent: TsEvent = {
      target: target,
      themeOwnership: ThemeOwnershipType.PURCHASED,
      activeThemePath: themePath,
    };
    TsLog.info(TAG, `Posting TsEvent , target = ${target}`);
    EventEmitter.emit(TsEventId.EVENT_THEME_ACTIVATE, tsEvent);
  }

  /**
   * 获取当前激活的主题路径
   * @return {string} 返回当前激活的主题路径
   */
  private getActiveThemePath(): string {
    if (FileUtil.isFileExists(ThemePathConstant.THEME_A_FLAG)) {
      TsLog.info(TAG, `Theme resource was found in A directory.`);
      return ThemePathConstant.THEME_A_PATH;
    } else if (FileUtil.isFileExists(ThemePathConstant.THEME_B_FLAG)) {
      TsLog.info(TAG, `Theme resource was found in B directory.`);
      return ThemePathConstant.THEME_B_PATH;
    } else {
      TsLog.warning(TAG, `Theme resource was not found in neither A nor B directory.`);
      return ThemePathConstant.THEME_A_PATH;
    }
  }
}