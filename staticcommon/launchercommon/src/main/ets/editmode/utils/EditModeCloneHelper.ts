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

import CommonEventManager from '@ohos.commonEventManager';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { editModeManager } from '../model/EditModeManager';
import { AiBarCloneCallbackManager } from '../../manager/AiBarCloneCallbackManager';
import { DesktopManager } from '../../manager/DesktopManager';

const TAG = 'EditModeCloneHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 *  settingData克隆完成公共事件
 */
const EVENT_SETTINGS_DATA_FINISH: string = 'custom.event.SETTINGS_DATA_RESTORE_FINISH';

/**
 *  编辑模式settingData克隆数据工具类
 */
export class EditModeCloneHelper {
  private static _instance: EditModeCloneHelper | null = null;

  public static getInstance(): EditModeCloneHelper {
    if (!EditModeCloneHelper._instance) {
      EditModeCloneHelper._instance = new EditModeCloneHelper();
    }
    return EditModeCloneHelper._instance;
  }
  private cloneSubscriber: CommonEventManager.CommonEventSubscriber | undefined;

  /**
   *  注册settingData克隆完成回调
   */
  public createBackupSubscriber(): void {
    let subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
      events: [EVENT_SETTINGS_DATA_FINISH],
      publisherPermission: 'ohos.permission.MANAGE_SECURE_SETTINGS'
    };
    CommonEventManager.createSubscriber(subscribeInfo).then((commonEventSubscriber) => {
      this.cloneSubscriber = commonEventSubscriber;
      this.subscribeBackEvent();
      log.showInfo('Succeeded in creating subscriber.');
    }).catch((err: Error) => {
      log.showInfo(`Failed to create subscriber. message is ${err.message}`);
    });
  }

  /**
   *  反注册settingData克隆完成回调
   */
  public unSubscribeBackEvent(): void {
    try {
      CommonEventManager.unsubscribe(this.cloneSubscriber);
    } catch (error) {
      log.error(`Failed to unSubscribeBackEvent. Code is ${error?.code}, message is ${error?.message}`);
    }
  }

  private subscribeBackEvent(): void {
    try {
      CommonEventManager.subscribe(this.cloneSubscriber, (err, data) => {
        if (err) {
          log.showInfo(`Failed to subscribe common event. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        log.showInfo(`event subscribe --- ${data.event}`);
        if (data.event === EVENT_SETTINGS_DATA_FINISH) {
          editModeManager.initIsShowAppName();
          DesktopManager.getInstance().saveDesktopParam();
          AiBarCloneCallbackManager.getInstance().executeCallback(data);
        }
      });
    } catch (error) {
      log.error(`subscribe failed, code is ${error?.code}, message is ${error?.message}`);
    }
  }
}