/**
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

import {
  AppModel,
  CalculateDesktopRst,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  EventConstants,
  LayoutViewModel,
  RdbStoreManager,
  DesktopDataLoader,
  DesktopLayoutState,
  SettingsModel,
  GetHideAppsFromConfig,
  GridLayoutItemInfo,
  GridLayoutUtil,
  FormLayoutCacheManager,
  LaunchLayoutCacheManager
} from '@ohos/launchercommon';
import { PageDesktopLayoutConfig } from '@ohos/launchercommon';
import { PcDesktopLayoutInfo } from './configs/PcDesktopLayoutInfo';
import {
  LogDomain,
  Logger,
  FileUtils,
  CheckEmptyUtils,
  SingleContext,
} from '@ohos/basicutils';
import {localEventManager } from '@ohos/frameworkwrapper';
import { IconResourceManager, DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import sSettingsUtil from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsUtil';
import { DesktopLayoutCacheData } from '@ohos/launchercommon/src/main/ets/cache/layout/DesktopLayoutCacheData';

const TAG = 'PcPageDesktopLayoutConfig';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export default class PcPageDesktopLayoutConfig extends PageDesktopLayoutConfig {
  public static singleName: string = 'PcPageDesktopLayoutConfig';

  public mGridLayoutInfo: DefaultDesktopLayoutInfo = PcDesktopLayoutInfo.PC_LAYOUT_INFO;

  private notSupportItemTypeList: number[] = [CommonConstants.TYPE_FOLDER, CommonConstants.TYPE_FORM_STACK];

  public static self: PcPageDesktopLayoutConfig;

  protected constructor(ctx?: SingleContext) {
    super(ctx);
  }

  /**
   * PcLauncherLayoutStyleConfig of instance
   */
  static getInstance(): PcPageDesktopLayoutConfig {
    if (!PcPageDesktopLayoutConfig.self) {
      PcPageDesktopLayoutConfig.self = new PcPageDesktopLayoutConfig();
    }
    return PcPageDesktopLayoutConfig.self;
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT;
  }

  private updateGridConfig(layoutConfig: DefaultDesktopLayoutInfo): void {
    if (!layoutConfig) {
      log.showWarn(TAG, 'layoutConfig empty');
      return;
    }
    try {
      let rest: CalculateDesktopRst = LayoutViewModel.getInstance().calculateDesktop();
      log.showInfo(TAG, 'updateGridConfig: rows = %{public}d, columns = %{public}d', rest.mRows, rest.mColumns);
      if (rest.mRows !== undefined && rest.mColumns !== undefined) {
        layoutConfig.layoutDescription.row = rest.mRows;
        layoutConfig.layoutDescription.column = rest.mColumns;
      }
    } catch (err) {
      log.showError(TAG, `updateGridConfig err: ${err?.code} ${err?.message}`);
    }
  }

  private filterNotSupportData(layoutConfig: DefaultDesktopLayoutInfo): void {
    log.showInfo(TAG, 'filterNotSupportData start');
    if (!layoutConfig || !layoutConfig.layoutInfo) {
      log.showWarn(TAG, 'filterNotSupportData layoutConfig empty');
      return;
    }
    const gridItemInfoList: GridLayoutItemInfo[] = layoutConfig.layoutInfo;
    const invalidTypeList: GridLayoutItemInfo[] = [];
    for (let idx = 0; idx < gridItemInfoList.length; idx++) {
      if (!gridItemInfoList[idx]) {
        log.showWarn(TAG, 'invalid item, skip it');
        continue;
      }
      const type: number = gridItemInfoList[idx].typeId as number;
      if (this.notSupportItemTypeList.indexOf(type) !== -1) {
        invalidTypeList.push(gridItemInfoList[idx]);
        log.showWarn(TAG, 'invalid item key = %{public}s, type = %{public}s',
          GridLayoutUtil.generateUniqueKey(gridItemInfoList[idx]),
          gridItemInfoList[idx].typeId);
      }
    }
    if (!CheckEmptyUtils.isEmpty(invalidTypeList)) {
      layoutConfig.layoutInfo.filter((item: GridLayoutItemInfo) => {
        return this.notSupportItemTypeList.indexOf(item.typeId as number) < 0;
      })
      RdbStoreManager.getInstance().deleteItemsByInfoIdAndContainer(invalidTypeList);
    }
    log.showInfo(TAG, 'filterNotSupportData end');
  }

  async loadPersistConfig(): Promise<void> {
    log.showInfo(TAG, 'loadPersistConfig start');
    // 初始化隐藏app配置文件 1.开机时加载系统预装的隐藏配置;2.oobe修改完隐藏配置刷新桌面重新加载
    await GetHideAppsFromConfig.getInstance().loadHideConfig();
    let defaultConfig = this.mGridLayoutInfo;
    const configFromFile = FileUtils.readStringFromFile(this.getConfigFileAbsPath());
    try {
      if (!CheckEmptyUtils.isEmpty(configFromFile)) {
        defaultConfig = JSON.parse(configFromFile);
      } else {
        log.showWarn(TAG, 'loadPersistConfig configFromFile empty');
      }
    } catch (err) {
      log.showError(TAG, `loadPersistConfig JSON.parse err: ${err?.code} ${err?.message}`);
    }

    let isOrNotOneScreen: boolean = SCBScreenSessionManager.getInstance().getScreenSessionList().length === 1;
    let configFromRdb =
      await RdbStoreManager.getInstance().queryGridLayoutInfo(undefined, this.singleContext, isOrNotOneScreen);
    configFromRdb = await GetHideAppsFromConfig.getInstance().autoAlignGridLayoutItem(configFromRdb, false);
    if (configFromRdb) {
      log.showInfo(TAG, 'configFromRdb, total item num = %{public}d', configFromRdb.length);
      defaultConfig.layoutInfo = configFromRdb;
    }
    let rdbStartVersion: number = RdbStoreManager.getInstance().getRdbStartVersion();
    log.showInfo(TAG, 'loadPersistConfig rdbStore version = %{public}d', rdbStartVersion);
    if ((configFromRdb && configFromRdb.length > 0) || (configFromRdb && this.isConfigExist() && rdbStartVersion > 0)) {
      log.showInfo(TAG, 'loadPersistConfig load data from db');
    } else {
      if (CheckEmptyUtils.isEmpty(this.mDesktopDataLoader)) {
        this.initDesktopDataLoader();
      }
      try {
        await this.loadLayoutInfoFromConfig(1);
      } catch (err) {
        log.showError(TAG, `loadLayoutInfoFromConfig  err: ${err?.code} ${err?.message}`);
      }
      defaultConfig.layoutInfo = this.mGridLayoutInfo.layoutInfo;
      // 刷机去除隐藏应用
      defaultConfig.layoutInfo =
        await GetHideAppsFromConfig.getInstance().autoAlignGridLayoutItem(defaultConfig.layoutInfo, false);
      if (!CheckEmptyUtils.isEmptyArr(defaultConfig?.layoutInfo)) {
        SettingsModel.getInstance().setAppListInfo(defaultConfig?.layoutInfo);
      }
      log.showInfo(TAG, 'loadPersistConfig from ccm, total num = %{public}d', defaultConfig.layoutInfo?.length);
    }
    this.mGridLayoutInfo = defaultConfig;
    this.updateGridConfig(this.mGridLayoutInfo);
    this.filterNotSupportData(this.mGridLayoutInfo);
    IconResourceManager.getInstance().checkSystemStateAndVersion();
    this.initLayoutCache();
    localEventManager.sendLocalEvent(EventConstants.EVENT_LAYOUT_INIT_FINISHED, null);
    log.showInfo(TAG, 'loadPersistConfig end');
  }

  public async refreshLayoutAfterRecover(): Promise<void> {
    GlobalContext.getInstance().setObject('backupStatus', true);
    const pageCount: number = await globalThis.RdbStoreManagerInstance.querySettingsPageCount();
    const configFromRdb: GridLayoutItemInfo[] = await globalThis.RdbStoreManagerInstance.queryGridLayoutInfo();
    log.showWarn(TAG, 'refreshLayoutAfterRecover configFromRdb length = %{public}d,pageCount = %{public}d',
      configFromRdb.length, pageCount);
    if (pageCount) {
      this.mGridLayoutInfo.layoutDescription.pageCount = pageCount;
    }
    try {
      this.mGridLayoutInfo.layoutInfo = [...configFromRdb];
      this.mGridLayoutInfo.layoutInfo.forEach(item => {
        if (!CheckEmptyUtils.isEmpty(item.layoutInfo)) {
          let date: string = String(new Date());
          item.formRefreshDate = date;
        }
      });
      this.initLayoutCache();
      SettingsModel.getInstance().setAppListInfo(this.mGridLayoutInfo.layoutInfo);
    } catch (error) {
      log.showError(TAG, `init layout cache error ${error?.message}, ${error?.code}`);
    }
  }

  initDesktopDataLoader(): void {
    const model: number = DeviceHelper.is2In1DevicePcType() ?
      DesktopLayoutState.PC_MODE_MODEL : Number(sSettingsUtil.getValue(CommonConstants.SIMPLE_MODE_KEY, '0'));
    this.mDesktopDataLoader = DesktopDataLoader.getInstance(model, this.singleContext);
  }

  protected initLayoutCache(): void {
    let layoutData: DesktopLayoutCacheData = new DesktopLayoutCacheData(this.mGridLayoutInfo);
    LaunchLayoutCacheManager.getInstance().reInit(layoutData);
    FormLayoutCacheManager.getInstance().reInit(layoutData);
    super.persistConfig();
    log.showInfo(TAG, 'initLayoutCache end');
  }
}
