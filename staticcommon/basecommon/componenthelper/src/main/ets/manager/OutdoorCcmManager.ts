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
import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { List } from '@kit.ArkTS';
import configPolicy from '@ohos.configPolicy';

const TAG = 'OutdoorCcmManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const OUTDOOR_CONFIG_FILE_PATH = 'etc/cloud/outdoor_config.json';

export interface OutdoorInfo {
  maxAddAppCount: number;
  iconBadgeInvisibleList: string[];
  addAppBlacklist: string[];
}

export class OutdoorCcmManager {
  private static instance: OutdoorCcmManager;
  private iconBadgeInvisibleList: List<string> = new List<string>();
  private addAppBlackList: List<string> = new List<string>();

  public static getInstance(): OutdoorCcmManager {
    if (OutdoorCcmManager.instance === undefined) {
      OutdoorCcmManager.instance = new OutdoorCcmManager();
    }
    return OutdoorCcmManager.instance;
  }

  /**
   * 读取云端ccm参数
   */
  public async init(): Promise<void> {
    this.loadOutdoorConfigFromFile();
  }

  private async loadOutdoorConfigFromFile(): Promise<void> {
    log.showInfo(TAG, 'loadOutdoorConfigFromFile');
    try {
      let configFile: string | undefined = await configPolicy.getOneCfgFile(OUTDOOR_CONFIG_FILE_PATH);
      if (CheckEmptyUtils.checkStrIsEmpty(configFile)) {
        log.showWarn(TAG, 'Can not find outdoor json path');
        return;
      }
      if (!fs.accessSync(configFile)) {
        log.showWarn(TAG, 'Can not access effect json file');
        return;
      }
      const outdoorJsonText: string = fs.readTextSync(configFile);
      if (CheckEmptyUtils.checkStrIsEmpty(outdoorJsonText)) {
        log.showWarn(TAG, 'outdoorJsonText is Empty');
        return;
      }
      let configInfo: OutdoorInfo = JSON.parse(outdoorJsonText) as OutdoorInfo;
      for (const bundleName of configInfo.iconBadgeInvisibleList) {
        log.showInfo(TAG, `invisible bundlename: ${bundleName}`);
        this.iconBadgeInvisibleList.add(bundleName)
      }
    } catch (err) {
      log.showError(TAG, `Error on load outdoor file,error ${err.message}`);
    }
  }

  /**
   * 返回云端模式下配置ccm中是否包含包名
   *
   * @param bundleName
   * @returns true 包含, false 不包含
   */
  public isIconBadgeInvisible(bundleName: string): boolean {
    if (CheckEmptyUtils.isEmpty(this.iconBadgeInvisibleList)) {
      return false;
    }
    return this.iconBadgeInvisibleList.has(bundleName);
  }
}