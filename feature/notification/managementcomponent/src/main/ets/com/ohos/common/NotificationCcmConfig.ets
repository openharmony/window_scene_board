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

import configPolicy from '@ohos.configPolicy';
import fs from '@ohos.file.fs';
import { CustomPromise } from './CustomPromise';
import { LogDomain, LogHelper } from './BasicCommon';

const TAG = 'NotificationConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

interface AffectedBy {
  deviceType: string;
  status: string;
}

interface SwingEnableFilter {
  affectedBy?: AffectedBy
}

export interface INotificationService {
  swingEnableFilter?: SwingEnableFilter;
}

interface INotificationConfig {
  /**
   * 应用特权配置格式{ 'com.xxx': '1' }，一个包名对应一个按位组合的字符串，从左往右每一个含义如下：
   * 第一位：是否隐藏实况窗开关配置
   */
  appPrivileges?: Record<string, string>;

  notificationService?: INotificationService;
}

/**
 * 通知CCM配置
 */
class NotificationCcmConfig {
  public initFinished: CustomPromise<void> = new CustomPromise();

  private appPrivileges?: Record<string, string>;

  private notificationService?: INotificationService;

  private hiddenEntranceBundle: string[] = [];

  /**
   * 初始化
   */
  async init(): Promise<void> {
    await this.loadNotificationConfig();
  }

  private collectHiddenBundle(): void {
    let keys = Object.keys(this.appPrivileges ?? []);
    for (let key of keys) {
      if (this.appPrivileges?.[key][3] === '1') {
        this.hiddenEntranceBundle.push(key);
      }
    }
  }

  /**
   * 是否隐藏实况窗开关配置
   * @returns
   */
  isHiddenSwitch(bundleName: string): boolean {
    if (!this.appPrivileges) {
      return false;
    }
    if (!this.appPrivileges?.[bundleName]) {
      return false;
    }
    return this.appPrivileges[bundleName][0] === '1';
  }

  isHiddenNtfEntrance(bundleName: string): boolean {
    if (!this.appPrivileges?.[bundleName]) {
      return false;
    }
    return this.appPrivileges[bundleName][3] === '1';
  }

  /**
   * 隐藏实况窗开关配置包列表
   * @returns
   */
  getLiveViewHiddenSwitchList(): string[] {
    if (!this.appPrivileges) {
      return [];
    }
    return Object.keys(this.appPrivileges).filter((bundle) => this.isHiddenSwitch(bundle));
  }

  isSupportRemindWeakly(): boolean {
    if (this.notificationService?.swingEnableFilter?.affectedBy) {
      // notificationService + swingEnableFilter + affectedBy 都存在
      return true;
    }
    return false;
  }

  /**
   * 加载所有的'/etc/notification/notification_config.json'
   * @returns
   */
  private async loadNotificationConfig(): Promise<void> {
    try {
      const notificationConfigPaths = await configPolicy.getCfgFiles('etc/notification/notification_config.json');
      if (notificationConfigPaths.length === 0) {
        log.showWarn('not get any config files');
        this.initFinished.resolve();
        return;
      }
      let configs: INotificationConfig[] = [];
      for (let path of notificationConfigPaths) {
        const notificationConfig = JSON.parse(await fs.readText(path)) as INotificationConfig;
        configs.push(notificationConfig);
      }
      let mergeResult = this.mergeNotificationConfigs(configs);
      this.appPrivileges = mergeResult.appPrivileges;
      this.notificationService = mergeResult.notificationService;

      this.collectHiddenBundle();
      this.initFinished.resolve();
      log.showInfo('load notificationConfig end');
    } catch (e) {
      log.error('Read notification_config.json failed:', e);
      this.initFinished.resolve();
    }
  }

  /**
   * 按优先级从低到高合并配置文件，高优先级覆盖低优先级
   * @param configs
   * @returns
   */
  private mergeNotificationConfigs(configs: INotificationConfig[]): INotificationConfig {
    let mergeResult = configs[0];
    for (let i = 1; i <= configs.length; i++) {
      // 合并 appPrivileges
      if (mergeResult?.appPrivileges) {
        for (let key of Object.keys(configs[i]?.appPrivileges ?? [])) {
          mergeResult.appPrivileges[key] = configs[i]?.appPrivileges?.[key] ?? '';
        }
      } else {
        mergeResult.appPrivileges = configs[i]?.appPrivileges;
      }
      // 合并 notificationService
      if (configs[i]?.notificationService) {
        mergeResult.notificationService = configs[i].notificationService;
      }
    }
    return mergeResult;
  }
}

export const notificationCcmConfig = new NotificationCcmConfig();