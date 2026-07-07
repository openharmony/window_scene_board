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

import { LogDomain, LogHelper, FileUtils } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { AppToHapMappingManager } from './AppToHapMappingManager';

const TAG = 'DeliverAppStrategyPushConfigManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const CFG_DIR = 'etc/com.ohos.sceneboard/deliverapps/';
const CLOUD_UPDATE_DOWNLOAD_PATH = '/data/service/el1/public/update/param_service/install/system/';
const LOCAL_PATH_PREFIX = '/deliverapps/';
const VERSION_FILE_NAME = 'version.txt';
const DELIVERY_FILE_NAME = 'delivery_app_strategy.json';
const CLOUD_VERSION_PATH = CLOUD_UPDATE_DOWNLOAD_PATH + CFG_DIR + VERSION_FILE_NAME;
const CLOUD_CONFIG_PATH = CLOUD_UPDATE_DOWNLOAD_PATH + CFG_DIR + DELIVERY_FILE_NAME;
const PREINSTALLED_VERSION_PATH = '/system/' + CFG_DIR + VERSION_FILE_NAME;
const PREINSTALLED_CONFIG_PATH = '/system/' + CFG_DIR + DELIVERY_FILE_NAME;

export class DeliverAppStrategyPushConfigManager {
  private static instance: DeliverAppStrategyPushConfigManager;

  static getInstance(): DeliverAppStrategyPushConfigManager {
    if (!DeliverAppStrategyPushConfigManager.instance) {
      DeliverAppStrategyPushConfigManager.instance = new DeliverAppStrategyPushConfigManager();
    }
    return DeliverAppStrategyPushConfigManager.instance;
  }

  /**
   * 初始化配置
   */
  public initConfigFiles(): void {
    if (!(GlobalContext.getContext()?.filesDir)) {
      log.showError(`initConfigFiles, app files dir is empty`);
      return;
    }
    // 预置配置版本号
    let preinstallVersion: number = 0;
    if (FileUtils.isExist(PREINSTALLED_VERSION_PATH) && FileUtils.isExist(PREINSTALLED_CONFIG_PATH)) {
      preinstallVersion = this.getVersion(this.getVersionFromTxt(PREINSTALLED_VERSION_PATH));
    }
    // 本地配置版本号
    let localVersion: number = 0;
    const localVersionPath = GlobalContext.getContext().filesDir + LOCAL_PATH_PREFIX + VERSION_FILE_NAME;
    if (FileUtils.isExist(localVersionPath)) {
      localVersion = this.getVersion(this.getVersionFromTxt(localVersionPath));
    }
    // 云推路径版本号
    let cloudVersion: number = 0;
    if (FileUtils.isExist(CLOUD_VERSION_PATH) && FileUtils.isExist(CLOUD_CONFIG_PATH)) {
      cloudVersion = this.getVersion(this.getVersionFromTxt(CLOUD_VERSION_PATH));
    }
    if (localVersion >= preinstallVersion && localVersion >= cloudVersion) {
      log.showInfo(`initConfigFiles, local config version is ${localVersion}, already new`);
      return;
    }
    this.createLocalDeliverAppsFolder();
    if (cloudVersion > preinstallVersion) {
      let versionRet: boolean = FileUtils.copyFile(CLOUD_VERSION_PATH, localVersionPath);
      let configRet: boolean = FileUtils.copyFile(CLOUD_CONFIG_PATH,
        GlobalContext.getContext().filesDir + LOCAL_PATH_PREFIX + DELIVERY_FILE_NAME);
      log.showInfo(`initConfigFiles, copy cloud config to appFilesDir, versionRet: ${versionRet}, configRet: ${configRet}`);
    } else {
      let versionRet: boolean = FileUtils.copyFile(PREINSTALLED_VERSION_PATH, localVersionPath);
      let configRet: boolean = FileUtils.copyFile(PREINSTALLED_CONFIG_PATH,
        GlobalContext.getContext().filesDir + LOCAL_PATH_PREFIX + DELIVERY_FILE_NAME);
      log.showInfo(`initConfigFiles, copy preInstall config to appFilesDir, versionRet: ${versionRet}, configRet: ${configRet}`);
    }
    let appToHapMappingManager: AppToHapMappingManager = AppToHapMappingManager.getInstance();
    appToHapMappingManager.initAppToHapPolicyMap();
    appToHapMappingManager.resetDialogDetail();
  }

  private createLocalDeliverAppsFolder(): void {
    if (!FileUtils.isExist(GlobalContext.getContext().filesDir + LOCAL_PATH_PREFIX)) {
      FileUtils.createFolder(GlobalContext.getContext().filesDir + LOCAL_PATH_PREFIX);
    }
  }

  /**
   * 复制云推文件到沙箱files下
   */
  public backupCloudFilesToAppFilesDir(): void {
    if (!(GlobalContext.getContext()?.filesDir)) {
      log.showError('backupCloudFilesToAppFilesDir, app files dir is empty');
      return;
    }
    // 云推下载目录为空，不需要复制
    if (!FileUtils.isExist(CLOUD_VERSION_PATH) || !FileUtils.isExist(CLOUD_CONFIG_PATH)) {
      log.showInfo('backupCloudFilesToAppFilesDir, cloud config or version txt is not exits, not need backup');
      return;
    }
    // 如果存在备份文件，则需要对比版本
    const localVersionPath = GlobalContext.getContext().filesDir + LOCAL_PATH_PREFIX + VERSION_FILE_NAME;
    if (FileUtils.isExist(localVersionPath)) {
      const localVersion = this.getVersion(this.getVersionFromTxt(localVersionPath));
      const cloudVersion = this.getVersion(this.getVersionFromTxt(CLOUD_VERSION_PATH));
      log.showInfo(`backupCloudFilesToAppFilesDir, compare version, backup: ${localVersion} - cloud: ${cloudVersion}`);
      if (cloudVersion === 0) {
        log.showError(`backupCloudFilesToAppFilesDir, cloud version error.`);
        return;
      }
      if (localVersion >= cloudVersion) {
        log.showInfo('backupCloudFilesToAppFilesDir, it has been copied and does not need to be copied again.');
        return;
      }
    }
    this.createLocalDeliverAppsFolder();
    const versionRet = FileUtils.copyFile(CLOUD_VERSION_PATH, localVersionPath);
    const configRet =
      FileUtils.copyFile(CLOUD_CONFIG_PATH, GlobalContext.getContext().filesDir + LOCAL_PATH_PREFIX + DELIVERY_FILE_NAME);
    log.showInfo(`backupCloudFilesToAppFilesDir, copy cloud file versionRet: ${versionRet}, configRet: ${configRet}`);
    let appToHapMappingManager: AppToHapMappingManager = AppToHapMappingManager.getInstance();
    appToHapMappingManager.initAppToHapPolicyMap();
    appToHapMappingManager.resetDialogDetail();
  }

  /**
   * 版本字符串转为数字，左边补0
   * "11.11.24.101" -> "011011024101" -> 11011024101
   * "11.12.24.100" -> "011012024100" -> 11012024100
   * "11.12.24.100" > "11.11.24.101"
   * @param version
   * @returns
   */
  public getVersion(version: string | undefined): number {
    if (!version) {
      return 0;
    }
    const result = Number(version.split('.').reduce((p, c) => p + c.padStart(3, '0'), ''));
    if (Number.isNaN(result)) {
      return 0;
    }
    return result;
  }

  private getVersionFromTxt(verPath: string): string | undefined {
    let version: string | undefined;
    const content = FileUtils.readTextSync(verPath);
    content.split('\n').forEach((line) => {
      const arr = line.trim().split('=');
      if (arr.length >= 2 && arr[0] === 'version') {
        version = arr[1];
      }
    });
    return version;
  }
}

