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

import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';
import BundleResourceModel from '@ohos/managementcomponent/src/main/ets/com/ohos/model/bundleResourceModel';
import display from '@ohos.display';
import Constants from '../common/constants';
import { WantAgent } from '@ohos.wantAgent';
import { Want } from '@kit.AbilityKit';

const TAG = 'NotificationManagement-NotificationManagenmentViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export default class NotificationManagenmentViewModel {
  private isPhone = false;

  ViewModelInit(): void {
    log.showDebug('ViewModelInit');
    this.MigrateTo();
    this.judgeDeviceType();
  }

  MigrateTo(): void {
    log.showDebug('MigrateTo');
    //get the want
    let want: Want = Reflect.get(globalThis, Constants.ABILITY_NAME_NOTIFICATION_MANAGEMENT + '_want');
    let isHmMigrate: boolean =
      want != undefined && want.parameters?.migrateUri !== undefined && want.parameters.migrateBundle !== undefined;
    if (!isHmMigrate) {
      log.showInfo('Skip MigrateTo');
      return;
    }
    let migrateUri: string | undefined = want.parameters?.migrateUri as string ?? '';
    let bundleName: string | undefined = want.parameters?.migrateBundle as string ?? '';
    log.showDebug(`aboutToAppear migrateUri:${migrateUri} migrateBundle:${bundleName}`);

    let dataModel: BundleResourceModel = new BundleResourceModel();
    dataModel.getBundleInfo(bundleName,
      async (bundleInfo: Record<string, Object> | PromiseLike<Record<string, Object>>) => {
        log.showInfo('MigrateTo bundleInfo');
        let info = await bundleInfo;
        let params = {
          appTitle: info?.appTitle,
          appVersion: info?.appVersion,
          appBundleName: info?.appBundleName,
          appUid: info?.appUid,
          systemApp: info?.systemApp,
          appIcon: info?.appIcon,
          appIndex: info?.appIndex,
          appSwitch: info?.appSwitch,
          appSlot: info?.appSlot,
          shouldClearRouter: true
        } as Router;
        const router = await import('@ohos.router');
        //to next page
        router.default.replaceUrl({
          url: migrateUri,
          params: params
        });
      });
    //clear want
    Reflect.set(globalThis, Constants.ABILITY_NAME_NOTIFICATION_MANAGEMENT + '_want', null);
  }

  async judgeDeviceType(): Promise<void> {
    log.showDebug('judgeDeviceType');
    let configInfo = await display.getDefaultDisplay();
    log.showDebug(`judgeDeviceType, configInfo: ${configInfo} `);
    if (configInfo && configInfo.width < configInfo.height) {
      this.isPhone = true;
    }
  }

  checkMigrate(): boolean {
    let res = Reflect.get(globalThis, Constants.ABILITY_NAME_NOTIFICATION_MANAGEMENT + '_new_want') === 1;
    if (res) {
      this.MigrateTo();
      Reflect.set(globalThis, Constants.ABILITY_NAME_NOTIFICATION_MANAGEMENT + '_new_want', 0);
    }
    return res;
  }
}

/**
 * 通知来源Bundle信息
 *
 */
export interface NtfBundleInfo {
  appTitle: string;
  appVersion: string;
  appBundleName: string;
  appUid: number;
  systemApp: boolean;
  appIcon: string;
  appIndex: number;
  appSwitch?: boolean;
  appSlot?: number;
}

export interface Router {
  appTitle: string;
  appVersion: string;
  appBundleName: string;
  appUid: number;
  systemApp: boolean;
  appIcon: string;
  appIndex: number;
  appSwitch?: boolean;
  appSlot?: number;
  shouldClearRouter: boolean;
}