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

import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { IconResourceManager, ResourceManager } from '@ohos/frameworkwrapper';
import { AppItemInfo, AppModel, CommonConstants, GridLayoutUtil } from '@ohos/launchercommon';

const TAG = 'AddDialogBubbleViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class AddDialogBubbleViewModel {
  private static sInstance: AddDialogBubbleViewModel;
  /**
   * 获取AddDialogBubbleViewModel单例
   * @returns sInstance
   */
  static getInstance(): AddDialogBubbleViewModel {
    if (AddDialogBubbleViewModel.sInstance === undefined) {
      AddDialogBubbleViewModel.sInstance = new AddDialogBubbleViewModel();
    }
    return AddDialogBubbleViewModel.sInstance;
  }

  /**
   * 初始化获取应用名称
   * @param appItem 传入的应用信息，根据应用信息拿到应用名
   */
  public initAppName(appItem: AppItemInfo): void {
    if (GridLayoutUtil.isShortcutToDesktopInApp(appItem)) {
      return;
    }
    if (appItem.typeId === CommonConstants.TYPE_APP && GridLayoutUtil.isAppInstalled(appItem)) {
        appItem.appName = IconResourceManager.getInstance().getCachedIconNameSync(appItem.bundleName,
        appItem.moduleName, appItem.abilityName) ?? appItem.appName;
    } else if (appItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      appItem.appName = ResourceManager.getInstance()
          .getCachedAppName(appItem.appLabelId, appItem.bundleName, appItem.moduleName);
    }
    log.showInfo(TAG, `bundleName is ${appItem.bundleName}, appName is ${appItem.appName}`);
  }
}