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

import { AppItemInfo } from '@ohos/launchercommon';
import { IGestureDockDataStrategy } from './IGestureDockDataStrategy';
import bundleManager from '@ohos.bundle.bundleManager';
import { LogDomain, LogHelper, DomainName, CheckEmptyUtils } from '@ohos/basicutils';
import { BusinessError } from '@ohos.base';
import { IconResourceManager } from '@ohos/frameworkwrapper';

const GESTURE_DOCK_ACTION_V1 = 'action.gesture.dock.v1';
const TAG = 'GestureDockActionAbilityStrategy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class GestureDockActionAbilityStrategy implements IGestureDockDataStrategy {
  /**
   * 通过Action策略扩展应用数据
   *
   * @param appItemInfos
   */
  public expandDataByStrategy(appItemInfos: AppItemInfo[]): void {
    if (CheckEmptyUtils.isEmpty(appItemInfos)) {
      log.showWarn('expandDataByStrategy warning:the appItemInfos invalid return.');
      return;
    }
    let abilityFlags = bundleManager.AbilityFlag.GET_ABILITY_INFO_DEFAULT;
    let want: Want = {
      action: GESTURE_DOCK_ACTION_V1,
      parameters: { 'fastNoteLaunchSource': 2 }
    };
    try {
      let abilityList: bundleManager.AbilityInfo[] = bundleManager.queryAbilityInfoSync(want, abilityFlags);
      abilityList.forEach((item: bundleManager.AbilityInfo) => {
        let appItem = this.convertToAppItemInfo(item);
        if (appItem && this.isNeedExpandItemData(appItemInfos, appItem)) {
          appItem.isActionItem = true;
          log.showInfo(`expandDataByStrategy ${appItem.keyName}`);
          appItemInfos.push(appItem);
          IconResourceManager.getInstance()
            .addRequiresIconAbility(appItem.bundleName, appItem.moduleName, appItem.abilityName, 'GestureDock');
        }
      });
    } catch (err) {
      let errInfo: BusinessError = err as BusinessError;
      log.showError(`expandDataByStrategy error, code: ${errInfo?.code}, msg: ${errInfo?.message}`);
    }
    log.showInfo('expandDataByStrategy end');
  }

  /**
   * 通过指定的策略查询abilityInfo封装成AppItemInfo
   *
   * @param bundleName
   * @param appIndex
   * @param abilityName
   * @returns AppItemInfo
   */
  public getAppItemByStrategy(bundleName?: string, appIndex?: number,
    abilityName?: string): AppItemInfo | undefined {
    let abilityFlags = bundleManager.AbilityFlag.GET_ABILITY_INFO_DEFAULT;
    let want: Want = {
      action: GESTURE_DOCK_ACTION_V1,
      parameters: { 'fastNoteLaunchSource': 2 }
    };
    try {
      let abilityList: bundleManager.AbilityInfo[] = bundleManager.queryAbilityInfoSync(want, abilityFlags);
      if (abilityList) {
        let abilityInfo = abilityList.find((item) =>
        item.bundleName === bundleName && item.appIndex === appIndex &&
          item.name === abilityName);
        if (abilityInfo) {
          let appItem = this.convertToAppItemInfo(abilityInfo);
          appItem.isActionItem = true;
          return appItem;
        }
      }
    } catch (err) {
      let errInfo: BusinessError = err as BusinessError;
      log.showError(`getAppItemByStrategy error, code: ${errInfo?.code}, msg: ${errInfo?.message}`);
    }
    return undefined;
  }

  public get type(): string {
    return TAG;
  }

  private convertToAppItemInfo(info: bundleManager.AbilityInfo): AppItemInfo {
    const appItemInfo = new AppItemInfo();
    appItemInfo.appName = info.labelId === 0 ? info.applicationInfo?.label : '';
    appItemInfo.isSystemApp = info.applicationInfo?.systemApp;
    appItemInfo.isUninstallAble = info.applicationInfo?.removable;
    appItemInfo.appIconId = info.iconId;
    appItemInfo.applicationIconId = info.applicationInfo?.iconId;
    appItemInfo.appLabelId = info.labelId;
    appItemInfo.applicationLabelId = info.applicationInfo?.labelId;
    appItemInfo.codePath = info.applicationInfo?.codePath;
    appItemInfo.bundleName = info.bundleName;
    appItemInfo.abilityName = info.name;
    appItemInfo.moduleName = info.moduleName;
    appItemInfo.appIndex = info.appIndex;
    appItemInfo.shortcutId = '';
    appItemInfo.installSource = info.applicationInfo?.installSource;
    appItemInfo.bundleType = bundleManager.BundleType.APP;
    appItemInfo.keyName = AppItemInfo.getKeyName(appItemInfo);
    return appItemInfo;
  }

  private isNeedExpandItemData(appItemInfos: AppItemInfo[], appItemInfo: AppItemInfo) {
    if (CheckEmptyUtils.isEmpty(appItemInfos) || CheckEmptyUtils.isEmpty(appItemInfo)) {
      return false;
    }
    return !(appItemInfos.some(item => item?.bundleName === appItemInfo?.bundleName &&
      item.abilityName === appItemInfo.abilityName));
  }
}