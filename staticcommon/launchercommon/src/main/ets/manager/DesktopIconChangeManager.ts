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

import dataShare from '@ohos.data.dataShare';
import type ctx from '@ohos.app.ability.common';
import {
  GlobalContext,
  localEventManager,
  sSettingsUtil,
  AccountMgr,
} from '@ohos/frameworkwrapper';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { IconCommonUtil } from '../utils/IconCommonUtil';

const TAG = 'DesktopIconChangeSize';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
// 无效用户id
const INVALID_USER_ID: number = -1;
// 常规用户id
const NORMAL_USER_ID: number = 100;
// dataShare最大重试次数
const MAX_RETRY_TIMES = 3;
// 重试间隔
const RETRY_INTERVAL_MS = 1000;

export class IconChangeSizeManager {
  private static instance: IconChangeSizeManager;
  private datashareHelper?: dataShare.DataShareHelper;
  private uri: string = '';
  private context: ctx.ServiceExtensionContext = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);

  public static getInstance(): IconChangeSizeManager {
    if (!IconChangeSizeManager.instance) {
      IconChangeSizeManager.instance = new IconChangeSizeManager();
    }
    return IconChangeSizeManager.instance;
  }

  /**
   * 初始化事件监听订阅
   */
  public async init(): Promise<void> {
    this.initDataShareListener(MAX_RETRY_TIMES);
  }

  private async initDataShareListener(retryTimes: number): Promise<void> {
    if (retryTimes <= 0) {
      log.error('no retry times');
      return;
    }

    let userId: number = await AccountMgr.getCurrentAccountId();
    log.showInfo(`getUri userId: ${userId}, key: ${SettingsKeyConstants.DESKTOP_ICON_CHANGESIZE}`);
    if (!CommonUtils.isNumber(userId) || userId === INVALID_USER_ID) {
      log.showWarn('userId is invaild, use NORMAL_USER_ID instead');
      userId = NORMAL_USER_ID;
    }
    this.uri = CommonConstants.getSettingsSecureUriSync(SettingsKeyConstants.DESKTOP_ICON_CHANGESIZE, userId);
    try {
      this.datashareHelper = await dataShare.createDataShareHelper(this.context, this.uri);
      if (!this.datashareHelper) {
        log.showError('datashareHelper: is null');
        setTimeout(() => {
          this.initDataShareListener(retryTimes - 1);
        }, RETRY_INTERVAL_MS);
        return;
      }
    } catch (err) {
      log.showError(`get datashare err ${err}`);
      setTimeout(() => {
        this.initDataShareListener(retryTimes - 1);
      }, RETRY_INTERVAL_MS);
      return;
    }

    try {
      this.datashareHelper.on('dataChange', this.uri, () => this.desktopIconChangeCallback());
    } catch (err) {
      log.showError(`datashare on change err ${err}`);
      setTimeout(() => {
        this.initDataShareListener(retryTimes - 1);
      }, RETRY_INTERVAL_MS);
      return;
    }

    log.showInfo('init ok desktopIconChangeCallback');
  }

  private desktopIconChangeCallback(): void {
    log.info('desktopIconChangeCallback');
    let iconSizeScale: number = Number(sSettingsUtil.getSecureValue(SettingsKeyConstants.DESKTOP_ICON_CHANGESIZE, '0', this.context));
    // 判断是否是非法值 最小值-6 最大值8
    if (IconCommonUtil.isValidIconSizeChange(iconSizeScale)) {
      localEventManager.sendLocalEventSticky('desktopIconChangeSize', iconSizeScale);
    } else {
      log.info(`desktopIconChangeSize is not legal, iconSizeScale: ${iconSizeScale}`);
    }
  }
}