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
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import ConfigParseUtil from '../utils/ConfigParseUtil';
import { OhosSuperAdditionRelationModel } from '../model/OhosSuperAdditionRelationModel';

const TAG = 'OhosSuperAdditionRelationManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.BACKUP, TAG);
const CONFIG = 'etc/ohos_superaddition_apps.json';

export class OhosSuperAdditionRelationManager {
  private transInfos: Map<string, string> = new Map<string, string>();
  private isLoaded: boolean = false;

  private static sInstance: OhosSuperAdditionRelationManager;

  /**
   * Get instance of OhosSuperAdditionRelationManager
   *
   * @returns instance of OhosSuperAdditionRelationManager
   */
  public static getInstance(): OhosSuperAdditionRelationManager {
    if (!OhosSuperAdditionRelationManager.sInstance) {
      OhosSuperAdditionRelationManager.sInstance = new OhosSuperAdditionRelationManager();
    }
    return OhosSuperAdditionRelationManager.sInstance;
  }

  /**
   * load transfer relation config
   *
   * @returns Promise<void>
   */
  public async loadTransferInfos(): Promise<void> {
    log.showInfo('loadTransferInfos start');
    this.transInfos.clear();
    try {
      const filePath = await ConfigParseUtil.getConfig(CONFIG);
      const config: string = fs.readTextSync(filePath);
      if (CheckEmptyUtils.checkStrIsEmpty(config)) {
        log.showWarn('loadTransferInfos config empty');
        return;
      }
      let jsonArray: Object[] = JSON.parse(config);
      if (!Array.isArray(jsonArray)) {
        this.isLoaded = true;
        return;
      }
      for (const jsonEle of jsonArray) {
        let relationModel: OhosSuperAdditionRelationModel = new OhosSuperAdditionRelationModel(jsonEle);
        if (!relationModel.isValid()) {
          continue;
        }
        this.parseSourcePkgArr(relationModel);
      }
    } catch (e) {
      log.showError(`readJsonFile error: ${e.toString()}`);
      return;
    }
    this.isLoaded = true;
    log.showInfo(`loadTransferInfos end, size = ${this.transInfos.size}`);
  }

  private parseSourcePkgArr(relationModel: OhosSuperAdditionRelationModel): void {
    relationModel.getSourcePackageArr().forEach(pkgName => {
      if (!this.transInfos.has(pkgName)) {
        this.transInfos.set(pkgName, relationModel.getTargetBundleName());
      }
    });
  }

  /**
   * return config is load
   *
   * @returns true load finish false not load
   */
  public getIsLoaded(): boolean {
    return this.isLoaded;
  }

  /**
   * get all relation OhosSuperAdditionRelationManager
   *
   * @returns Map<string, TransferRelationModel>
   */
  public getTransInfos(): Map<string, string> {
    return this.transInfos;
  }

  /**
   * get relation by sourcePackageName
   *
   * @returns TransferRelationModel
   */
  public getTransInfoForPackageName(sourcePackageName: string): string | undefined {
    if (!this.transInfos.has(sourcePackageName)) {
      return undefined;
    }
    return this.transInfos.get(sourcePackageName);
  }
}