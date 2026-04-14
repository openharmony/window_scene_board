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

/**
 * 通知设置调用异常打点
 */
import {
  ICommonExceptionReporter,
  LogDomain,
  LogHelper,
  RequestType,
  SettingMaintenance,
  NotificationIpc,
  NotificationIpcManager,
} from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { rpc } from '@kit.IPCKit';
import { common, Want } from '@kit.AbilityKit';
import { ContextManager } from '@ohos/managementcomponent/src/main/ets/com/ohos/manager/ContextManager';

const TAG = 'SettingExceptionReporter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class SettingExceptionReporter implements ICommonExceptionReporter {
  // 上报异常日志默认错误码
  private static readonly DEFAULT_EXCEPTION_CODE = -1;
  private notificationIpcManager?: NotificationIpcManager;

  public async reportInfo(desc: string, errorCode: number, stack?: string, tag?: string): Promise<void> {
    try {
      const info = new SettingMaintenance();
      info.errorCode = errorCode === undefined ? SettingExceptionReporter.DEFAULT_EXCEPTION_CODE : errorCode;
      info.desc = desc;
      info.stack = stack;
      info.tag = tag;
      this.settingRemoteSend(RequestType.SETTING_MAINTENANCE, JSON.stringify(info));
    } catch (e) {
      log.showError(`send request fail, code ${e?.code}, message ${e?.message}`);
    }
  }

  private async settingRemoteSend(type: number, info: string): Promise<void> {
    let data: rpc.MessageSequence | null = null;
    try {
      if (!this.notificationIpcManager) {
        const context: common.UIExtensionContext = ContextManager.getContext() as common.UIExtensionContext;
        const requestWant: Want = {
          bundleName: NotificationIpc.BUNDLE_NAME,
          abilityName: NotificationIpc.ABILITY_NAME,
        };
        requestWant.parameters = {};
        requestWant.parameters[NotificationIpc.KEY] = NotificationIpc.VALUE;
        this.notificationIpcManager = new NotificationIpcManager(context, requestWant);
      }
      data = rpc.MessageSequence.create();
      data.writeInterfaceToken(NotificationIpc.INTERFACE_TOKEN);
      data.writeInt(type);
      data.writeString(info);
      await this.notificationIpcManager.send(NotificationIpc.SEND_MESSAGE_REQUEST_CODE, data);
    } catch (err) {
      log.error('setting remote send error', err);
    } finally {
      try {
        data?.reclaim();
      } catch (err) {
        log.error('MessageSequence reclaim failed', err);
      }
    }
  }
}