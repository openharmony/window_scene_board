/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { RdbStoreManager } from './RdbStoreManager';
import { CommonConstants } from '../constants/CommonConstants';
import { FileUtils } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import type ctx from '@ohos.app.ability.common';
import { LauncherStartup, StartupStep } from '../tools/LauncherStartup';

const TAG = 'RdbStoreStarter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 初始化数据库的工具类，避免数据库管理类和config类出现循环依赖
 */
export class RdbStoreStarter {
  // 数据库升级时待删除config列表
  private static configList: string[] = [
    CommonConstants.SMART_DOCK_LAYOUT_INFO,
    CommonConstants.DESKTOP_APPLICATION_INFO,
    CommonConstants.GRID_LAYOUT_INFO
  ];

  private static getConfigFilePath(configName: string): string {
    let filesDir = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.filesDir + '/';
    return filesDir + configName + AppStorage.get('device') + '.json';
  }

  /**
   * 初始化数据库
   *
   * @returns
   */
  public static async initRdbConfig(): Promise<void> {
    TraceUtil.startTrace(DomainName.SCB, 'RdbStoreStarter');
    LauncherStartup.getInstance().passStep(StartupStep.INIT_RDB_BEGIN);
    await RdbStoreManager.getInstance().initRdbConfig(() => {
      log.showInfo('clear config cache');
      RdbStoreStarter.configList.forEach((value: string) => {
        const configPath: string = RdbStoreStarter.getConfigFilePath(value);
        FileUtils.deleteConfigFile(configPath);
      });
    });
    LauncherStartup.getInstance().passStep(StartupStep.INIT_RDB_END);
    TraceUtil.endTrace(DomainName.SCB, 'RdbStoreStarter');
  }
}