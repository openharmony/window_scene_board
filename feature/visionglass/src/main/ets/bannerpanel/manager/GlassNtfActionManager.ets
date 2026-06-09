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

import Ntf from '@ohos.notificationSubscribe';
import wantAgent, { WantAgent } from '@ohos.app.ability.wantAgent';
import { Callback } from '@kit.BasicServicesKit';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'GlassNtfActionManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class GlassNtfActionManager {
  private static instance: GlassNtfActionManager | null = null;

  /**
   * 拉起远程WantAgent
   *
   * @param agent 远程agent
   * @param inputKey 输入action键值
   * @param inputContent 输入action内容
   */
  public startWantAgent(agent: WantAgent, callback?: Callback<number>, inputKey?: string, inputContent?: string): void {
    log.info(`enter startWantAgent`);
    try {
      wantAgent.trigger(agent, {
        code: 0,
        startOptions: { displayId: 1 },
        extraInfo: { key: inputKey, data: inputContent },
      }, () => {
        if (callback) {
          callback(0);
        }
        log.info('startWantAgent has start want complete');
      });
    } catch (error) {
      log.error('trigger error', error);
    }
  }

  /**
   * 点击移除通知
   *
   * @param entry 通知
   */
  public removeNotificationByClick(entry: NotificationEntry): void {
    let hashCode = entry.hashCode;
    log.info(`removeNotificationByClick: ${hashCode}`);
    try {
      Ntf.remove(hashCode, Ntf.RemoveReason.CLICK_REASON_REMOVE).then(() => {
        log.info(`removeNotificationByClick has remove: ${hashCode}`);
      }).catch((err: object) => {
        log.error(`removeNotificationByClick:${hashCode} fail:`, err);
      });
    } catch (error) {
      log.error('removeNotificationByClick error', error);
    }
  }

  /*
   * 获取单例
   * */
  public static getInstance(): GlassNtfActionManager {
    if (!GlassNtfActionManager.instance) {
      log.showInfo(`getInstance new instance`);
      GlassNtfActionManager.instance = new GlassNtfActionManager();
    }
    return GlassNtfActionManager.instance;
  }

  public static detroyInstance(): void {
    log.showInfo(`detroyInstance`);
    GlassNtfActionManager.instance = null;
  }
}