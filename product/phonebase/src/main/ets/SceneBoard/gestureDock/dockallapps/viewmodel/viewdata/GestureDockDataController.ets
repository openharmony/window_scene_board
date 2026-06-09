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

import { CheckEmptyUtils, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { DomainName } from '@ohos/basicutils';
import { AppItemInfo, AppModel, CommonConstants, DockItemInfo } from '@ohos/launchercommon';
import { SceneInfoAdapterUtil } from '@ohos/windowscene';
import { GestureDockActionAbilityStrategy } from './GestureDockActionAbilityStrategy';
import { IGestureDockDataStrategy } from './IGestureDockDataStrategy';

const TAG = 'GestureDockDataController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export class GestureDockDataController {
  private actionStrategy: GestureDockActionAbilityStrategy = new GestureDockActionAbilityStrategy();

  /**
   * 复用launcher common数据基础上拓展其他需要显示的ability
   *
   * @returns AppItemInfos
   */
  public getAllAppsList(callBack?: Function): AppItemInfo[] {
    let appItemInfos: AppItemInfo[] = AppModel.getInstance().getAppList(callBack);
    TraceUtil.startTrace(DomainName.SCB, 'GestureDock#putDataByStrategy');
    let dockAppItemInfos: AppItemInfo[] = appItemInfos.concat();
    this.actionStrategy.expandDataByStrategy(dockAppItemInfos);
    TraceUtil.endTrace(DomainName.SCB, 'GestureDock#putDataByStrategy');
    return dockAppItemInfos;
  }

  /**
   * 通过bundleName abilityName等信息从缓存或bms查询AppItemInfo
   *
   * @param bundleName
   * @param appIndex
   * @param abilityName
   * @returns AppItemInfo
   */
  public getAppItemInfo(bundleName?: string, appIndex?: number, abilityName?: string): AppItemInfo | undefined {
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn('getAppItemInfo, bundleName is null');
      return;
    }
    let appItemInfos: AppItemInfo[] = AppModel.getInstance().getAppList();
    let appItem: AppItemInfo | undefined = undefined;
    if (appItemInfos) {
      appItem = appItemInfos.find((item) =>
      item.appIndex === appIndex && item.abilityName === abilityName);
    }
    if (CheckEmptyUtils.isEmpty(appItem)) {
    }
    return appItem;
  }

  /**
   * 创建dock区app元素
   *
   * @param appItemInfo 数据库或缓存中取出的元素
   * @param index 位置信息
   */
  public async createDockAppInfo(appItemInfo: AppItemInfo, index: number): Promise<DockItemInfo> {
    return this.buildDockItemByAppInfo(index, appItemInfo);
  }

  /**
   * 通过appItemInfo构建dockItemInfo
   * @param appItemInfo
   * @param appDataFromSystem
   * @returns
   */
  private buildDockItemByAppInfo(index: number, appItemInfo: AppItemInfo): DockItemInfo {
    let dockItemInfo = new DockItemInfo();
    dockItemInfo.row = 0;
    dockItemInfo.column = index;
    dockItemInfo.area = [1, 1];
    this.fillDockItemByAppInfo(dockItemInfo, appItemInfo);
    return dockItemInfo;
  }

  /**
   * 填充基础数据
   * @param itemInfo
   * @param appDataFromSystem
   */
  public fillDockItemByAppInfo(itemInfo: DockItemInfo, appDataFromSystem: AppItemInfo): void {
    if (CheckEmptyUtils.isEmpty(itemInfo) || CheckEmptyUtils.isEmpty(appDataFromSystem)) {
      log.showWarn('fillDockItemByAppInfo itemInfo or appDataFromSystem is empty');
      return;
    }
    itemInfo.appName = appDataFromSystem.appName;
    itemInfo.bundleName = appDataFromSystem.bundleName;
    itemInfo.moduleName = appDataFromSystem.moduleName;
    itemInfo.abilityName = appDataFromSystem.abilityName;
    itemInfo.appIndex = appDataFromSystem.appIndex;
    itemInfo.appIconId = appDataFromSystem.appIconId;
    itemInfo.appLabelId = appDataFromSystem.appLabelId;
    itemInfo.applicationLabelId = appDataFromSystem.applicationLabelId;
    itemInfo.applicationName = appDataFromSystem.applicationName;
    itemInfo.installTime = appDataFromSystem.installTime;
    itemInfo.appStatus = appDataFromSystem.appStatus;
    itemInfo.isUninstallAble = appDataFromSystem.isUninstallAble;
    itemInfo.badgeNumber = appDataFromSystem.badgeNumber;
    itemInfo.enableNewAppInstance = appDataFromSystem.enableNewAppInstance;
    itemInfo.isSystemApp = appDataFromSystem.isSystemApp;
    itemInfo.isActionItem = appDataFromSystem.isActionItem;
    itemInfo.keyName = DockItemInfo.getKeyName(itemInfo);
    log.showWarn(`dockItem info: keyName: ${itemInfo.keyName}, appStatus: ${itemInfo.appStatus}`);
  }

  public static getInstance(): GestureDockDataController {
    if (globalThis.GestureDockDataController == null) {
      globalThis.GestureDockDataController = new GestureDockDataController();
    }
    return globalThis.GestureDockDataController;
  }
}