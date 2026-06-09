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

import { ResourceManager } from '@ohos/frameworkwrapper';
import { HashMap } from '@kit.ArkTS';
import { AppStatus } from '../constants/CommonConstants';

/**
 * AppStatus对应名称的类
 */
export class AppStatusNameMapping {
  private nameMappingSet: HashMap<number, string> = new HashMap<number, string>();

  private static mInstance: AppStatusNameMapping;

  private constructor() {
  }

  public static getInstance(): AppStatusNameMapping {
    if (!AppStatusNameMapping.mInstance) {
      AppStatusNameMapping.mInstance = new AppStatusNameMapping();
    }
    return AppStatusNameMapping.mInstance;
  }

  /**
   * 根据AppStatus获取显示名称
   * @param appStatus
   * @returns
   */
  public getDownloadEventNameByAppStatus(appStatus: AppStatus | undefined): string {
    if (appStatus === undefined) {
      return '';
    }
    if (!this.nameMappingSet.hasKey(appStatus)) {
      this.init();
    }
    return this.nameMappingSet.get(appStatus);
  }

  /**
   * 重新初始化名称
   * 比如切换语言场景
   */
  public init(): void {
    ResourceManager.getInstance().getStringByIdSync($r('app.string.download_start').id).then((value: string) => {
      this.nameMappingSet.set(AppStatus.DOWNLOADING, value);
      this.nameMappingSet.set(AppStatus.UPDATING, value);
    });
    ResourceManager.getInstance().getStringByIdSync($r('app.string.download_pause').id).then((value: string) => {
      this.nameMappingSet.set(AppStatus.PAUSING, value);
      this.nameMappingSet.set(AppStatus.WIFI_WAITING, value);
    });
    ResourceManager.getInstance().getStringByIdSync($r('app.string.download_wait').id).then((value: string) => {
      this.nameMappingSet.set(AppStatus.WAITING, value);
    });
    ResourceManager.getInstance().getStringByIdSync($r('app.string.download_installwait').id).then((value: string) => {
      this.nameMappingSet.set(AppStatus.INSTALL_WAITING, value);
    });
    ResourceManager.getInstance().getStringByIdSync($r('app.string.download_installing').id).then((value: string) => {
      this.nameMappingSet.set(AppStatus.INSTALLING, value);
    });
    this.nameMappingSet.set(AppStatus.INSTALLED, '');
  }
}