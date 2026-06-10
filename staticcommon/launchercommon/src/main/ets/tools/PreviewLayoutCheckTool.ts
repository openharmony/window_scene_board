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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysEventUtil, localEventManager, RdbStoreConfig } from '@ohos/frameworkwrapper';
import Account from '@ohos.account.osAccount';
import { SCBOobeManager } from '@ohos/windowscene';
import rdb from '@ohos.data.rdb';
import GridLayoutInfoColumns from '../db/column/GridLayoutInfoColumns';
import { AppItemInfo } from '../bean/AppItemInfo';
import { CommonConstants, DesktopLayoutState } from '../constants/CommonConstants';
import EventConstants from '../constants/EventConstants';
import DefaultDesktopLayoutInfo from '../configs/DefaultDesktopLayoutInfo';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import RdbTaskPool from '../db/RdbTaskPool';
import { DesktopDataLoader } from '../viewmodel/DesktopDataLoader';
import { GetLayoutInfoFromConfig } from '../layoutconfig/GetLayoutInfoFromConfig';
import { launcherAbilityManager } from '../abilitymanager/LauncherAbilityManager';

const TAG = 'SCBPreviewCheckTool';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const MAIN_USERID = 100;

/**
 * 在首次OOBE未结束前，对桌面首页布局和预制布局首页图标布局进行比对，如果存在不一致情况，进行兜底处理，重新恢复预制布局配置
 */
export class PreviewLayoutCheckTool {
  private static mInstance: PreviewLayoutCheckTool;

  private msgArr: string[] = [];

  /**
   * 开始检查之前需要校验的事件参数
   */
  private eventSet: Set<string> = new Set<string>();

  public constructor() {
    this.msgArr = [];
  }

  public static getInstance(): PreviewLayoutCheckTool {
    if (!PreviewLayoutCheckTool.mInstance) {
      PreviewLayoutCheckTool.mInstance = new PreviewLayoutCheckTool();
    }
    return PreviewLayoutCheckTool.mInstance;
  }

  /**
   * 添加校验的事件参数
   * @param event
   */
  public addPromiseEvent(event: string): void {
    this.eventSet.add(event);
  }

  /**
   * 开始检查布局
   * @param loadFromConfiguration
   * @returns
   */
  public async startCheck(loadFromConfiguration: string): Promise<boolean> {
    log.showWarn('checkLayoutInOOBE loadFromConfiguration: %{public}s', loadFromConfiguration);
    this.eventSet.delete(loadFromConfiguration);
    if (this.eventSet.size !== 0) {
      this.eventSet.forEach((key) => log.showWarn('checkLayoutInOOBE return. left events:%{public}s', key));
      return false;
    }
    await this.checkLayoutInOOBE();
    this.msgArr = [];
    return true;
  }

  private async checkLayoutInOOBE(): Promise<void> {
    try {
      let userId = await Account.getAccountManager().getOsAccountLocalId();
      // 主用户才需要预加载
      if (userId !== MAIN_USERID) {
        log.showWarn('checkLayoutInOOBE: not main user now');
        return;
      }
      // 判断当前是否在OOBE阶段(不含OTA升级拉起的OOBE)
      let isEnable: boolean = SCBOobeManager.isEnable();
      if (!isEnable) {
        return;
      }
      let isSame: boolean = await this.checkSame();
      log.showWarn('checkLayoutInOOBE: isSame: %{public}s, msg: %{public}s', isSame, this.msgArr.join(';'));
      if (!isSame) {
        HiSysEventUtil.writePreloadLayout(this.msgArr.join(';'));
        localEventManager.sendLocalEvent(EventConstants.EVENT_RESTORE_DESKTOP_LAYOUT, undefined);
      }
    } catch (e) {
      log.showError('checkLayoutInOOBE error, code %{public}d, msg %{public}s', e?.code, e?.message);
    }
  }

  /**
   * 当前布局跟预制布局比较
   * @returns boolean 如果布局一致，true；如果不一致，false
   */
  private async checkSame(): Promise<boolean> {
    GetLayoutInfoFromConfig.getInstance().clearFinalLayout();
    let desktopDataLoader = DesktopDataLoader.getInstance(DesktopLayoutState.HOME_LAUNCHER_MODE);
    let defaultLayoutInfoFromFile: DefaultDesktopLayoutInfo = await desktopDataLoader.loadFromJsonConfig();
    if (!defaultLayoutInfoFromFile || !defaultLayoutInfoFromFile.layoutInfo) {
      return true;
    }
    let appBundles: string[] = [];
    // 查询BMS中所有图标
    let bmsAppList: AppItemInfo[] = await launcherAbilityManager.getLauncherAbilityList(MAIN_USERID);
    bmsAppList?.forEach((item: AppItemInfo) => {
      appBundles.push(`${item.bundleName}_${item.abilityName}_${item.moduleName}`);
    });
    let defaultApps: Set<string> = new Set();
    let keys: string[] = [];
    defaultLayoutInfoFromFile.layoutInfo.forEach((item: GridLayoutItemInfo) => {
      // 只比对首页的图标，如果该图标在BMS中没有，不比对该图标
      if (item && item.page === 0 && item.typeId === CommonConstants.TYPE_APP &&
        item.container === CommonConstants.CONTAINER_DESKTOP &&
        appBundles.indexOf(`${item.bundleName}_${item.abilityName}_${item.moduleName}`) !== -1) {
        let key = this.getGridLayoutItemInfoKey(item);
        defaultApps.add(key);
        keys.push(key);
      }
    });
    let defaultMag = `default:${keys.join(',')}`;
    log.showWarn(defaultMag);
    this.msgArr.push(defaultMag);
    return this.compare(defaultApps);
  }

  private async getFirstPageApp(): Promise<GridLayoutItemInfo[]> {
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.PAGE_INDEX, 0);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_APP);
    conditions.set(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_DESKTOP);
    return await RdbTaskPool.getInstance().queryGridLayoutInfo(RdbStoreConfig.gridLayoutInfo.tableName, conditions);
  }

  /**
   * 比较预制布局跟数据库
   * @param defaultApps 预制布局
   * @returns boolean 如果布局一致，true；如果不一致，false
   */
  private async compare(defaultApps: Set<string>): Promise<boolean> {
    let currentList: GridLayoutItemInfo[] = await this.getFirstPageApp();
    // 这里不用判断数组长度是否为0， 有些产品首页就是没有图标
    if (!currentList) {
      log.showWarn('currentList is empty');
      return false;
    }

    let currentKeys: string[] = [];
    // 只比对首页图标
    currentList.filter(item => item && item.page === 0 && item.typeId === CommonConstants.TYPE_APP)
      .forEach((item: GridLayoutItemInfo) => {
        let key = this.getGridLayoutItemInfoKey(item);
        currentKeys.push(key);
      });
    let currentMsg = `current:${currentKeys.join(',')}`;
    log.showWarn(currentMsg);
    this.msgArr.push(currentMsg);
    if (currentList.length !== defaultApps.size) {
      this.msgArr.push(`size is different. default layout:${defaultApps.size}, current layout:${currentList.length}`);
      return false;
    }

    for (let i = 0; i < currentKeys.length; i++) {
      let key = currentKeys[i];
      if (!defaultApps.has(key)) {
        this.msgArr.push(`default layout do not have:${key}`);
        return false;
      }
      defaultApps.delete(key);
    }
    if (defaultApps.size > 0) {
      let keys: string[] = [];
      defaultApps.forEach((key: string) => keys.push(key));
      this.msgArr.push(`current layout do not have:${keys.join(';')}`);
      return false;
    }
    log.showWarn('compare first page app layout is same.');
    return true;
  }

  private getGridLayoutItemInfoKey(item: GridLayoutItemInfo): string {
    return `${item.bundleName}_${item.abilityName}_${item.moduleName}_${item.container}_${item.page}_${item.row}_${item.column}`;
  }
}