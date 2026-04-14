/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

const TAG = 'TransferRelationManager';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);
const CONFIG = 'etc/launcher_icon_map_table.json';

class TransferRelationManager {
  private transInfos: Map<string, Array<TransferRelationModel>> = new Map<string, Array<TransferRelationModel>>();
  private transInfoList: Array<TransferRelationModel> = [];
  private isLoaded: boolean = false;

  private static sInstance: TransferRelationManager;

  /**
   * Get instance of UpdateManager
   *
   * @returns instance of UpdateManager
   */
  public static getInstance(): TransferRelationManager {
    if (!TransferRelationManager.sInstance) {
      TransferRelationManager.sInstance = new TransferRelationManager();
    }
    return TransferRelationManager.sInstance;
  }

  /**
   * load transfer relation config
   * @returns Promise<void>
   */
  public async loadTransferInfos(): Promise<void> {
    log.showInfo(TAG, 'loadTransferInfos start');
    this.transInfos.clear();
    this.transInfoList = [];
    try {
      const filePath = await ConfigParseUtil.getConfig(CONFIG);
      const config: string = fs.readTextSync(filePath);
      if (!CheckEmptyUtils.checkStrIsEmpty(config)) {
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
          if (this.transInfos.has(relationModel.getSourcePackageName())) {
            let transferRelationModelArr: TransferRelationModel[] | undefined =
              this.transInfos.get(relationModel.getSourcePackageName());
            transferRelationModelArr?.push(relationModel);
          } else {
            let transferRelationModelArr = new Array<TransferRelationModel>();
            transferRelationModelArr.push(relationModel);
            this.transInfos.set(relationModel.getSourcePackageName(), transferRelationModelArr);
          }
          this.transInfoList.push(relationModel);
        }
      } else {
        log.showInfo(TAG, 'loadTransferInfos config empty');
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
   * get all relation TransferRelationModel
   * @returns Map<string, Array<TransferRelationModel>>
   */
  public getTransInfos(): Map<string, Array<TransferRelationModel>> {
    return this.transInfos;
  }

  /**
   * get  relation by sourcePackageName
   * @returns Map<string, Array<TransferRelationModel>>
   */
  public getTransInfosForPackage(sourcePackageName: string): TransferRelationModel[] {
    if (this.transInfos.has(sourcePackageName)) {
      return this.transInfos.get(sourcePackageName) ?? [];
    }
    return [];
  }

  /**
   * get  relation by sourcePackageName and sourceClassName
   * @returns TransferRelationModel
   */
  public getTransInfoForClass(sourcePackageName: string, sourceClassName: string): TransferRelationModel | undefined {
    if (!this.transInfos.has(sourcePackageName)) {
      return undefined;
    }
    let relationModelArr = this.transInfos.get(sourcePackageName);
    if (!relationModelArr) {
      return undefined;
    }
    for (const relationModel of relationModelArr) {
      if (relationModel.getSourceClassName() === sourceClassName) {
        return relationModel;
      }
    }
    return undefined;
  }

  /**
   * 判断是否是映射表里面的里面
   *
   * @param bundleName 应用包名
   * @returns boolean 是否在映射表
   */
  public isRelationApp(bundleName: string): boolean {
    return this.transInfoList.findIndex(item => item.getTargetBundleName() === bundleName) > -1;
  }
}

export const transferRelationManager = TransferRelationManager.getInstance();