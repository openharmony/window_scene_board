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

import { LogDomain, LogHelper, FileUtils } from '@ohos/basicutils';
import { fileIo } from '@kit.CoreFileKit';

const TAG = 'OneHandCloudPushConfigManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const CFG_DIR = 'etc/com.ohos.sceneboard/APPTRUNCATE/';
const CLOUD_UPDATE_DOWNLOAD_PATH = '/data/service/el1/public/update/param_service/install/system/';
const VERSION_FILE_NAME = 'version.txt';
const CLOUD_PUSH_TRUNCATE_FILE_NAME = 'appdisplay_truncate_config.xml';
const DEFAULT_VERSION = 10010025100;

export class OneHandCloudPushConfigManager {
  private static instance: OneHandCloudPushConfigManager;

  static getInstance(): OneHandCloudPushConfigManager {
    if (!OneHandCloudPushConfigManager.instance) {
      OneHandCloudPushConfigManager.instance = new OneHandCloudPushConfigManager();
    }
    return OneHandCloudPushConfigManager.instance;
  }

  /**
   * 解析云推白名单配置文件
   * @returns
   */
  public loadAppTruncateConfig(): string | undefined {
    let result: string | undefined = undefined;
    try {
      log.showInfo('load cloud push AppTruncateConfig start');
      // 加载预置version.txt和云推version.txt，对比版本号
      const cloudVersionPath = CLOUD_UPDATE_DOWNLOAD_PATH + CFG_DIR + VERSION_FILE_NAME;
      const cloudVersion = this.getVersion(this.getVersionFromTxt(cloudVersionPath));
      // 云推的版本号大于默认版本号，则读取云推的白名单
      log.showInfo(`Get cloud push App Truncate cloudVersion ${cloudVersion}`);
      if (cloudVersion >= DEFAULT_VERSION) {
        let cloudPath = CLOUD_UPDATE_DOWNLOAD_PATH + CFG_DIR + CLOUD_PUSH_TRUNCATE_FILE_NAME;
        result = fileIo.readTextSync(cloudPath);
        log.showInfo('Get cloud push AppTruncateConfig');
      }
    } catch (error) {
      log.showError(`load cloud push AppTruncateConfig error: ${error}`);
      return undefined;
    }
    return result;
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
        version = arr[1]
      }
    });
    return version;
  }
}

