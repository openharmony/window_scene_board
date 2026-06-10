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

import rpc from '@ohos.rpc';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { bundleManager } from '@kit.AbilityKit';
import { NotificationIpc, RequestType } from '@ohos/systemuicommon/src/main/ets/remote/Constant';
import { SettingMaintenanceRemote } from '../maintenance/SettingMaintenanceRemote';

const TAG = 'NotificationRemoteObject';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class NotificationRemoteObject extends rpc.RemoteObject {
  constructor() {
    super(NotificationIpc.INTERFACE_TOKEN);
  }

  async onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption): Promise<boolean> {
    try {
      const descriptor = data.readInterfaceToken();
      if (this.getDescriptor() !== descriptor) {
        log.error(`invalidate descriptor is:${descriptor}`);
        return false;
      }
      if (!await this.checkPermissions()) {
        return false;
      }
      const type = data.readInt();
      const info = data.readString();
      switch (type) {
        case RequestType.SETTING_MAINTENANCE:
          new SettingMaintenanceRemote().report(info);
          break;
        default:
          log.showWarn(`unkown request type, ${type}`);
          return false;
      }
      return true;
    } catch (e) {
      log.error('process remote request failed, ' + e);
    }
    return false;
  }

  async checkPermissions(): Promise<boolean> {
    try {
      const callerUid = rpc.IPCSkeleton.getCallingUid();
      const bundleName = await bundleManager.getBundleNameByUid(callerUid);
      const appFlags = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
      const applicationInfo = await bundleManager.getApplicationInfo(bundleName, appFlags);

      if (bundleName === NotificationIpc.BUNDLE_NAME && applicationInfo.systemApp) {
        log.showInfo(`bundleName ${bundleName} is vaild and ${bundleName} is systemApp, the caller is in trustlist`);
        return true;
      } else {
        log.showError(`bundleName ${bundleName} is not in trustlist, bundleName ${bundleName} appSystem permission is ${applicationInfo.systemApp}, reject`);
        return false;
      }
    } catch (err) {
      log.showError(`check caller fail because ${err.message}`);
      return false;
    }
  }
}
