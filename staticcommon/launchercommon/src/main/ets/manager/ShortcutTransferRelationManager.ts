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
import { LogDomain, Logger, CheckEmptyUtils } from '@ohos/basicutils';
import ConfigParseUtil from '../utils/ConfigParseUtil';
import { TransferRelationModel } from '../model/TransferRelationModel';

const TAG = 'ShortcutTransferRelationManager';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);
const CONFIG = 'etc/clone/launcher_oh_shortcut_map_table.json';

class ShortcutTransferRelationManager {
  private transInfos: Map<string, TransferRelationModel> = new Map<string, TransferRelationModel>();
  private isLoaded: boolean = false;

  private static sInstance: ShortcutTransferRelationManager;

  /**
   * Get instance of ShortcutTransferRelationManager
   *
   * @returns instance of ShortcutTransferRelationManager
   */
  public static getInstance(): ShortcutTransferRelationManager {
    if (!ShortcutTransferRelationManager.sInstance) {
      ShortcutTransferRelationManager.sInstance = new ShortcutTransferRelationManager();
    }
    return ShortcutTransferRelationManager.sInstance;
  }

  /**
   * load transfer relation config
   * @returns Promise<void>
   */
  public async loadTransferInfos(): Promise<void> {
    log.showInfo(TAG, 'loadTransferInfos start');
    this.transInfos.clear();
    try {
      const filePath = await ConfigParseUtil.getConfig(CONFIG);
      const config: string = fs.readTextSync(filePath);
      if (CheckEmptyUtils.checkStrIsEmpty(config)) {
        log.showWarn(TAG, 'shortcut loadTransferInfos config empty');
        return;
      }
      let jsonArray: Object[] = JSON.parse(config);
      if (!Array.isArray(jsonArray)) {
        this.isLoaded = true;
        return;
      }
      for (const jsonEle of jsonArray) {
        let relationModel: TransferRelationModel = new TransferRelationModel(jsonEle);
        if (!relationModel.isValid()) {
          continue;
        }
        let shortcutKey: string = relationModel.getSourcePackageName() + relationModel.getSourceClassName() +
        relationModel.getSourceShortcutId();
        if (!this.transInfos.has(shortcutKey)) {
          this.transInfos.set(shortcutKey, relationModel);
        }
      }
    } catch (e) {
      log.showError(TAG, `readJsonFile error: ${e.toString()}`);
      return;
    }
    this.isLoaded = true;
    log.showInfo(TAG, `loadTransferInfos end , size=${this.transInfos.size}`);
  }

  /**
   *  return config is load
   * @returns true load finish false not load
   */
  public getIsLoaded(): boolean {
    return this.isLoaded;
  }

  /**
   * get all relation ShortcutTransferRelationManager
   * @returns Map<string, TransferRelationModel>
   */
  public getTransInfos(): Map<string, TransferRelationModel> {
    return this.transInfos;
  }

  /**
   * get  relation by sourceClassName and sourceShortcutId
   * @returns TransferRelationModel
   */
  public getTransInfoForShortCut(shortcutKeyName: string): TransferRelationModel | undefined {
    if (!this.transInfos.has(shortcutKeyName)) {
      return undefined;
    }
    return this.transInfos.get(shortcutKeyName);
  }
}

export const shortcutTransferRelationManager = ShortcutTransferRelationManager.getInstance();