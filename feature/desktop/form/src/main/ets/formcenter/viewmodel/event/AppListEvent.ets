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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResourceManager, IconResourceManager } from '@ohos/frameworkwrapper';
import { NoIconAppInfo, NoIconAppModel } from '@ohos/launchercommon/src/main/ets/model/NoIconAppModel';
import { AppItemInfo, CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AppListItemInterface } from '../../interfaces/AppListInterface';
import FormStyleConstants from '../../../default/common/constants/FormStyleConstants';
import { image } from '@kit.ImageKit';

export class FormAppItemInfo {
  @Track public icon: string | PixelMap | Resource = '';
  @Track public appName: string | Resource = '';
  @Track public searchResult: string[] = [];
}

const TAG = 'AppListItemEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class AppListItemEvent implements AppListItemInterface {
  private static instance: AppListItemEvent;
  private constructor() {}

  static getInstance(): AppListItemEvent {
    if (!AppListItemEvent.instance) {
      AppListItemEvent.instance = new AppListItemEvent();
    }
    return AppListItemEvent.instance;
  }

  public updateServiceFormAppInfo(appItem: AppItemInfo, appInfo: FormAppItemInfo): void {
    if (appItem.bundleName === FormStyleConstants.FORM_CENTER_DEFAULT_ITEM) {
      appInfo.icon = $r('app.media.ic_suggestion_icon');
      appInfo.appName = $r('app.string.suggestion');
      return;
    }
    let iconResourceManager: IconResourceManager = IconResourceManager.getInstance();
    appInfo.appName = appItem.applicationName as string;
    if (CheckEmptyUtils.checkStrIsEmpty(appInfo.appName)) {
      appInfo.appName = iconResourceManager.getCachedIconNameSync(appItem.bundleName,
        appItem.moduleName, appItem.abilityName);
      log.showInfo(`update appName: ${appInfo.appName}`);
    }
    iconResourceManager.getCombIcon(appItem.bundleName, appItem.moduleName, appItem.abilityName)
      .then((icon: image.PixelMap) => {
        appInfo.icon = icon;
      });
  }

  public getDisplayNameWithFormatter(disPlayNames: string[]): string {
    if (!disPlayNames || disPlayNames.length <= 0) {
      log.showWarn(`invalid disPlayNames: ${disPlayNames}`);
      return '';
    }
    if (disPlayNames.length === 1) {
      return disPlayNames[0];
    }
    return ResourceManager.getInstance().getStringByName('splitter_format',
      disPlayNames[0], this.getDisplayNameWithFormatter(disPlayNames.slice(1)));
  }
}