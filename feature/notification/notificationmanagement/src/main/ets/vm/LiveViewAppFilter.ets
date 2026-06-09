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

import fs from '@ohos.file.fs';
import { notificationManager } from '@kit.NotificationKit';
import { configPolicy } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper,
  NotificationConfigEntity } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import { AppItem, StateValue } from '@ohos/managementcomponent/src/main/ets/com/ohos/vm/appLstComponentViewModel';


const TAG = 'ManagementComponent-LiveViewAppFilter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export interface INotificationConfig {
  /**
   * 应用特权配置格式{ 'com.xxx': '1' }，一个包名对应一个按位组合的字符串，从左往右每一个含义如下：
   * 第一位：是否隐藏实况窗开关配置
   */
  appPrivileges?: Record<string, string>;
}

export class LiveViewAppFilter {
  private appPrivileges?: Record<string, string>;

  /**
   * 获取列表中支持实况窗的应用、元服务
   *
   * @param appList
   * @returns
   */
  public async getLiveViewApp(appList: (AppItem | undefined)[]) : Promise<AppItem[]> {
    let filteredList: AppItem[] = [];
    for (const appItem of appList) {
      if (appItem && await this.isLiveViewEnable(appItem)) {
        filteredList.push(appItem);
      }
    }
    return filteredList;
  }

  private async isLiveViewEnable(appItem: AppItem): Promise<boolean> {
    let bundle: notificationManager.BundleOption = {
      bundle: appItem.appBundleName,
      uid: appItem.appUid
    };
    try {
      await this.initAppPrivileges();
      if (this.appPrivileges?.[appItem.appBundleName] && this.appPrivileges?.[appItem.appBundleName][0] === '1') {
        log.info(`Get ${appItem.appBundleName} is in list`);
        return false;
      }
      let enable = await notificationManager.isNotificationSlotEnabled(bundle, notificationManager.SlotType.LIVE_VIEW);
      appItem.appLiveViewSwitch = new StateValue(enable);
      log.info(`Get ${appItem.appBundleName} support live view`);
      return true;
    } catch (err) {
      log.error(`Get ${appItem.appBundleName} live view switch fail: ${err?.message}`);
      return false;
    }
  }

  private async initAppPrivileges(): Promise<void> {
    if (!this.appPrivileges) {
      try {
        const notificationConfigPaths = await configPolicy.getCfgFiles('etc/notification/notification_config.json');
        if (notificationConfigPaths.length === 0) {
          log.warn('not get any valid config path');
          return;
        }
        let configs: INotificationConfig[] = [];
        for (let path of notificationConfigPaths) {
          const notificationConfig = JSON.parse(await fs.readText(path)) as INotificationConfig;
          configs.push(notificationConfig);
        }
        let mergeRes = this.mergeConfigs(configs);
        this.appPrivileges = mergeRes.appPrivileges;
        log.info('appPrivileges init end');
      } catch (e) {
        log.error(`Read notification_config.json failed: ${e?.message}`);
      }
    }
  }

  private mergeConfigs(configs: INotificationConfig[]): INotificationConfig {
    let mergeRes = configs[0]?.appPrivileges ?? {};
    for (let i = 1; i < configs.length; i++) {
      const privilege = configs[i]?.appPrivileges ?? {};
      Object.keys(privilege).forEach((key) => {
        mergeRes[key] = privilege[key];
      });
    }
    return { appPrivileges: mergeRes };
  }
}

export const liveViewAppFilter = new LiveViewAppFilter();
