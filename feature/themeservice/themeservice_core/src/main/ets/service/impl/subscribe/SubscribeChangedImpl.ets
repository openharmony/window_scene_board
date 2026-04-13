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

import { commonEventManager } from '@kit.BasicServicesKit';
import base, { AsyncCallback } from '@ohos.base';
import { ObjectUtils, TsLog } from '@ohos/themeservicebase/Index';
import { NOTIFY_UPDATE_SCENE_HWID, NOTIFY_UPDATE_SCENE_TIME, NotifyUpdateScene } from '../../api/ThemeVipService';
import { TsCommonEventSubscribe } from '../../api/TsCommonEventSubscribe';
import { themeVipService } from '../ThemeVipServiceImpl';

/**
 * 账号登录公共事件
 */
const COMMON_EVENT_HWID_LOGIN: string = 'common.event.HWID_LOGIN';
/**
 * 账号登出公共事件
 */
const COMMON_EVENT_HWID_LOGOUT: string = 'common.event.HWID_LOGOUT';

const TAG: string = 'SubscribeChangedThemeImpl';

/**
 * 监听账号变更、事件变更公共事件
 */
export class SubscribeChangedThemeImpl implements TsCommonEventSubscribe {
  getSubscribeInfo(userId?: number): commonEventManager.CommonEventSubscribeInfo {
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [
        COMMON_EVENT_HWID_LOGIN, // 账号登录公共事件
        COMMON_EVENT_HWID_LOGOUT, // 账号登出公共事件
        commonEventManager.Support.COMMON_EVENT_TIME_CHANGED, // 设置中更改时间
        commonEventManager.Support.COMMON_EVENT_TIMEZONE_CHANGED// 设置中更改时区
      ],
      userId: userId,
    };
    return subscribeInfo;
  }

  getCallback(): AsyncCallback<commonEventManager.CommonEventData> {
    const callback: AsyncCallback<commonEventManager.CommonEventData> =
      (err: base.BusinessError, eventData: commonEventManager.CommonEventData) => {
        if (err || eventData === undefined || ObjectUtils.isNull(eventData)) {
          TsLog.error(TAG, `Failed to receive commonEvent ${eventData?.event}`, err);
          return;
        }
        TsLog.info(TAG, `Receive event = ${eventData.event}`);
        switch (eventData.event) {
          case COMMON_EVENT_HWID_LOGIN: // HwId登录
          case COMMON_EVENT_HWID_LOGOUT: // HwId登出
            this.notifyUpdateOnlineTheme(NOTIFY_UPDATE_SCENE_HWID);
            break;
          case commonEventManager.Support.COMMON_EVENT_TIME_CHANGED: // 设置中更改时间
          case commonEventManager.Support.COMMON_EVENT_TIMEZONE_CHANGED: // 设置中更改时区
            this.notifyUpdateOnlineTheme(NOTIFY_UPDATE_SCENE_TIME);
            break;
          default:
            TsLog.info(TAG, `Unknown event = ${eventData.event}`);
            break;
        }
      }
    return callback;
  }

  /**
   * 通知主题App更新在线资源缓存数据，需要清理在线资源会员信息
   * @param scene 通知主题App刷新缓存场景 0: 账号变化 1：手机系统时间修改 2：应用主题
   * @returns 无返回
   */
  private async notifyUpdateOnlineTheme(scene: NotifyUpdateScene): Promise<void> {
    await themeVipService().notifyUpdateOnlineTheme(true, scene);
  }
}