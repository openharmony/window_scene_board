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

import { LogDomain, LogHelper,
  CheckEmptyUtils} from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { bundleManager } from '@kit.AbilityKit';
import type { BusinessError } from '@ohos.base';
import { image } from '@kit.ImageKit';

const TAG = 'UninstallDialogUtil';
const NEED_TIPS_BUNDLENAME_LIST = [
  'com.ohos.thememanager',
  'com.ohos.meetime',
  'com.ohos.soundrecorder'
];
const NEED_RE_CONFIRMATION_LIST = [
  'com.tencent.wechat'
];
const UNINSTALL_APP_TITLE = 'unInstallAppTitle';
const UNINSTALL_APP_CONTENT = 'unInstallAppContent';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class UninstallDialogUtil {

  public static checkIsNeedTipsApp(bundleName: string): boolean {
    return NEED_TIPS_BUNDLENAME_LIST.includes(bundleName);
  }

  public static async getResUninstallAppInfo(bundleName: string): Promise<UninstallDialogTips> {
    let flag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
    let uninstallDialogTips: UninstallDialogTips = new UninstallDialogTips();
    try {
      let bundleInfo: bundleManager.BundleInfo = bundleManager.getBundleInfoSync(bundleName, flag);
      if (CheckEmptyUtils.isEmpty(bundleInfo)) {
        log.showWarn(`get ${bundleName} bundleInfo empty from bundleManager`);
        return uninstallDialogTips;
      }
      let metadataArr = bundleInfo.appInfo.metadataArray[0].metadata;
      if (CheckEmptyUtils.isEmpty(metadataArr)) {
        log.showWarn(`get ${bundleName} metadataArr empty from bundleInfo`);
        return uninstallDialogTips;
      }
      for (let i = 0; i < metadataArr.length; i++) {
        if (metadataArr[i].name === UNINSTALL_APP_TITLE) {
          let resNameTitle = metadataArr[i].value.substring(metadataArr[i].value.lastIndexOf(':') + 1);
          uninstallDialogTips.title = await ResUtils.getOutStringByName(resNameTitle, bundleName);
        } else if (metadataArr[i].name === UNINSTALL_APP_CONTENT) {
          let resNameContent = metadataArr[i].value.substring(metadataArr[i].value.lastIndexOf(':') + 1);
          uninstallDialogTips.content = await ResUtils.getOutStringByName(resNameContent, bundleName);
        }
      }
    } catch (err) {
      let code = (err as BusinessError)?.code;
      let message = (err as BusinessError)?.message;
      log.showError(`error code: ${code}, error message: ${message}`);
    }
    return uninstallDialogTips;
  }

  public static getIsNeedReConfirmationApp(bundleName: string): boolean {
    return NEED_RE_CONFIRMATION_LIST.includes(bundleName);
  }
}

export class UninstallDialogTips {
  private _title: string | Resource = '';
  private _content: string | Resource = '';

  public set title(value: string | Resource) {
    this._title = value;
  }

  public get title(): string | Resource {
    return this._title;
  }

  public set content(value: string | Resource) {
    this._content = value;
  }

  public get content(): string | Resource {
    return this._content;
  }
}