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

import dataShare from '@ohos.data.dataShare';
import {
  GlobalContext,
  AccountMgr,
} from '@ohos/frameworkwrapper';
import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { CommonConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { editModeManager } from '../editmode/model/EditModeManager';

const TAG = 'DesktopIconShowNameManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
// 无效用户id
const INVALID_USER_ID: number = -1;
// 常规用户id
const NORMAL_USER_ID: number = 100;
// dataShare最大重试次数
const MAX_RETRY_TIMES = 3;
// 重试间隔
const RETRY_INTERVAL_MS = 1000;

export class DesktopIconShowNameManager {
  private static instance: DesktopIconShowNameManager;
  private datashareHelper?: dataShare.DataShareHelper;
  private uri: string = '';

  public static getInstance(): DesktopIconShowNameManager {
    if (!DesktopIconShowNameManager.instance) {
      DesktopIconShowNameManager.instance = new DesktopIconShowNameManager();
    }
    return DesktopIconShowNameManager.instance;
  }

  /**
   * 初始化dataShare监听订阅
   */
  public async init(): Promise<void> {
    this.initDataShareListener(MAX_RETRY_TIMES);
  }

  private async initDataShareListener(retryTimes: number): Promise<void> {
    if (retryTimes <= 0) {
      log.showError(TAG, 'no retry times');
      return;
    }

    let userId: number = await AccountMgr.getCurrentAccountId();
    log.showInfo(TAG, `getUri userId: ${userId}, key: ${SettingsKeyConstants.IS_DESKTOP_ICON_SHOWNAME}`);
    if (!CommonUtils.isNumber(userId) || userId === INVALID_USER_ID) {
      log.showWarn(TAG, 'userId is invaild, use NORMAL_USER_ID instead');
      userId = NORMAL_USER_ID;
    }
    this.uri = CommonConstants.getSettingsSecureUriSync(SettingsKeyConstants.IS_DESKTOP_ICON_SHOWNAME, userId);
    try {
      this.datashareHelper = await dataShare.createDataShareHelper(GlobalContext.getContext(), this.uri);
      if (!this.datashareHelper) {
        log.showError(TAG, 'datashareHelper: is null');
        setTimeout(() => {
          this.initDataShareListener(retryTimes - 1);
        }, RETRY_INTERVAL_MS);
        return;
      }
    } catch (err) {
      log.showError(TAG, `get datashare err ${err}`);
      setTimeout(() => {
        this.initDataShareListener(retryTimes - 1);
      }, RETRY_INTERVAL_MS);
      return;
    }

    try {
      this.datashareHelper.on('dataChange', this.uri, () => this.showNameChangeCallback());
    } catch (err) {
      log.showError(TAG, `datashare on change err ${err}`);
      setTimeout(() => {
        this.initDataShareListener(retryTimes - 1);
      }, RETRY_INTERVAL_MS);
      return;
    }

    log.showInfo(TAG, 'init ok showNameChangeCallback');
  }

  private showNameChangeCallback(): void {
    log.showInfo(TAG, 'showNameChangeCallback');
    editModeManager.initIsShowAppName();
  }
}