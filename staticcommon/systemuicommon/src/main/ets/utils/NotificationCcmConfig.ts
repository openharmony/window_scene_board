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

import configPolicy from '@ohos.configPolicy';
import fs from '@ohos.file.fs';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, ThreadUtil } from '@ohos/basicutils';
import { messageChannel } from '../messageChannel/MessageChannel';
import { ThreadSync } from '../messageChannel/ThreadSync';

const TAG = 'NotificationConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface AffectedBy {
  deviceType: string;
  status: string;
}

interface SwingEnableFilter {
  affectedBy?: AffectedBy
}

export interface INotificationService {
  swingEnableFilter?: SwingEnableFilter;
  permissionWhiteListNotification?: string[];
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
@ThreadSync.VmDecorator
class NotificationCcmConfig {
  public initFinished: CustomPromise<void> = new CustomPromise();

  private appPrivileges?: Record<string, string>;

  private notificationService?: INotificationService;

  private hiddenEntranceBundle: string[] = [];

  public appLockNormalNtfConfigSet: Set<string> = new Set();

  public appLockLiveNtfConfigSet: Set<string> = new Set();

  /**
   * 初始化
   */
  async init(): Promise<void> {
    await this.loadNotificationConfig();
  }

  /**
   * 获取隐藏通知入口的包名列表
   * @returns
   */
  public getHiddenList(): string[] {
    return this.hiddenEntranceBundle;
  }

  /**
   * 获取系统应用包名列表
   * @returns
   */
  public getDeliverSystemBundleList(): string[] {
    return this.notificationService?.permissionWhiteListNotification ?? [];
  }

  private collectHiddenBundle(): void {
    let keys = Object.keys(this.appPrivileges);

    const tmpArr = [];
    for (let key of keys) {
      if (this.appPrivileges[key][3] === '1') {
        tmpArr.push(key);
      }
    }

    // 使用临时变量给数组赋值，触发vm间同步。直接push元素不会触发同步。
    this.hiddenEntranceBundle = tmpArr;
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
        Object.assign(mergeResult.appPrivileges, configs[i]?.appPrivileges);
      } else {
        mergeResult.appPrivileges = configs[i]?.appPrivileges;
      }
      // 合并 notificationService
      this.mergeNotificationService(mergeResult, configs[i]);
    }
    return mergeResult;
  }

  private mergeNotificationService(mergeResult: INotificationConfig, config: INotificationConfig): void {
    if (!config?.notificationService) {
      return;
    }
    if (!mergeResult.notificationService) {
      mergeResult.notificationService = config.notificationService;
      return;
    }
    const notificationService = mergeResult.notificationService;
    if (config.notificationService.swingEnableFilter) {
      notificationService.swingEnableFilter = config.notificationService.swingEnableFilter;
    }
    if (config.notificationService.permissionWhiteListNotification) {
      notificationService.permissionWhiteListNotification = config.notificationService.permissionWhiteListNotification;
    }
  }
}

export const notificationCcmConfig = new NotificationCcmConfig();