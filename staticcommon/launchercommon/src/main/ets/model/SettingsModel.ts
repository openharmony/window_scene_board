/**
 * Copyright (c) 2021-2025 Huawei Device Co., Ltd.
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

import GridLayoutUtil from '../utils/GridLayoutUtil';
import { CommonConstants } from '../constants/CommonConstants';
import { layoutConfigManager } from '../layoutconfig/LayoutConfigManager';
import { settingsDataManager } from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsDataManager';
import { PageDesktopModeConfig } from '../layoutconfig/PageDesktopModeConfig';
import { PageDesktopLayoutConfig } from '../layoutconfig/PageDesktopLayoutConfig';
import { PageDesktopAppModeConfig } from '../layoutconfig/PageDesktopAppModeConfig';
import { SettingsModelObserver } from './SettingsModelObserver';
import GridLayoutConfigs from '../configs/GridLayoutConfigs';
import type { GridLayoutConfig } from '../configs/GridLayoutConfigs';
import type { DockItemInfo } from '../bean/DockItemInfo';
import type ctx from '@ohos.app.ability.common';
import { CardItemInfo } from '../bean/CardItemInfo';
import { CheckEmptyUtils, FileUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { desktopUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { dataShare } from '@kit.ArkData';
import { AppItemInfo, GridLayoutItemInfo } from '../TsIndex';
import { AsyncCallback } from '@kit.BasicServicesKit';

const TAG = 'SettingsModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Data model for launcher settings ability.
 */
export class SettingsModel {
  private static mInstance: SettingsModel;
  public static readonly EVENT_FORCE_RELOAD: number = 1;
  private static readonly DEFAULT_VALUE: string = '1';
  private readonly mPageDesktopModeConfig: PageDesktopModeConfig;
  private readonly mPageDesktopLayoutConfig: PageDesktopLayoutConfig;
  private readonly mPageDesktopAppModeConfig: PageDesktopAppModeConfig;
  private mGridConfig = 1;
  private mGridLayoutTable = GridLayoutConfigs.GridLayoutTable;
  private readonly uri: string;
  private readonly helper: dataShare.DataShareHelper;
  private readonly mObserverList: SettingsModelObserver[] = [];
  private residentList: DockItemInfo[] = [];
  private mIsSupportForm6x4: boolean = true;

  private constructor() {
    let deviceType: string;
    this.mPageDesktopModeConfig = layoutConfigManager.getModeConfig(PageDesktopModeConfig.DESKTOP_MODE_CONFIG);
    deviceType = this.mPageDesktopModeConfig.getDeviceType();
    log.showInfo(`constructor deviceType:${deviceType}`);
    if (deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
      this.mGridLayoutTable = GridLayoutConfigs.GridLayoutTable;
    } else if (deviceType === CommonConstants.PAD_DEVICE_TYPE) {
      this.mGridLayoutTable = GridLayoutConfigs.PadGridLayoutTableHorizontal;
    } else {
      this.mGridLayoutTable = GridLayoutConfigs.GridLayoutTableHorizontal;
    }
    this.mPageDesktopLayoutConfig = layoutConfigManager.getFunctionConfig<PageDesktopLayoutConfig>(PageDesktopLayoutConfig.GRID_LAYOUT_INFO);
    this.mPageDesktopAppModeConfig = layoutConfigManager.getModeConfig(PageDesktopAppModeConfig.DESKTOP_APPLICATION_INFO);
    this.uri = settingsDataManager.getUri(CommonConstants.NAVIGATION_BAR_STATUS_KEY);
    this.helper = settingsDataManager.getHelper();
    log.showInfo(`constructor mGridLayoutTable:${JSON.stringify(this.mGridLayoutTable)}`);
  }

  static getInstance(): SettingsModel {
    if (!SettingsModel.mInstance) {
      SettingsModel.mInstance = new SettingsModel();
    }
    return SettingsModel.mInstance;
  }

  addObserver(observer: SettingsModelObserver): void {
    log.showDebug('addObserver');
    this.mObserverList.push(observer);
  }

  private notifyObservers(event: number): void {
    log.showDebug('notifyObservers');
    for (let i = 0; i < this.mObserverList.length; i++) {
      this.mObserverList[i](event);
    }
  }

  /**
   * force reload all config from disk.
   */
  forceReloadConfig(needSendNotification: boolean = true): void {
    if (this.mPageDesktopModeConfig) {
      this.mPageDesktopModeConfig.forceReloadConfig();
    }
    if (this.mPageDesktopLayoutConfig) {
      this.mPageDesktopLayoutConfig.forceReloadConfig();
    }
    if (this.mPageDesktopAppModeConfig) {
      this.mPageDesktopAppModeConfig.forceReloadConfig();
    }
    if (needSendNotification) {
      this.notifyObservers(SettingsModel.EVENT_FORCE_RELOAD);
    }
  }

  /**
   * Get the grid view presetting collection of layout config information table.
   *
   * @return {object} Grid view presetting collection object.
   */
  getGridLayoutTable(): GridLayoutConfig[] {
    return this.mGridLayoutTable;
  }

  /**
   * Get default layout information of grid view.
   *
   * @return {object} Default layout information of grid view.
   */
  getDefaultLayoutInfo(): Object {
    let fileName: string = DeviceHelper.isPhone() ? '/layoutInfo.json' : '/layoutInfo_pad.json';
    const defaultLayoutInfoFilePath = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).filesDir + fileName;
    return FileUtils.readJsonFile(defaultLayoutInfoFilePath);
  }

  /**
   * Get layout config of grid view.
   *
   * @return {object} Layout config of grid view.
   */
  getGridConfig(): GridLayoutConfig {
    this.mGridConfig = this.mPageDesktopModeConfig.getGridConfig();
    let gridLayout = this.mGridLayoutTable[0];
    for (let i = 0; i < this.mGridLayoutTable.length; i++) {
      if (this.mGridLayoutTable[i].id === this.mGridConfig) {
        gridLayout = this.mGridLayoutTable[i];
        break;
      }
    }
    log.showDebug(`getGridConfig mGridLayoutTable:${JSON.stringify(this.mGridLayoutTable)}`);
    log.showDebug(`getGridConfig mGridConfig:${this.mGridConfig}, gridLayout:${JSON.stringify(gridLayout)}`);
    return gridLayout;
  }

  /**
   * Set layout config id of grid view.
   *
   * @param gridConfig - Layout config id of grid view.
   */
  setGridConfig(gridConfig: number): void {
    this.mPageDesktopModeConfig.updateGridConfig(gridConfig);

    const config = this.getGridConfig();
    const gridLayoutInfo = this.mPageDesktopLayoutConfig.getGridLayoutInfo();
    this.mPageDesktopLayoutConfig.updateGridLayoutInfo(GridLayoutUtil.updateGridLayoutInfo(
      gridLayoutInfo, config.row, config.column
    ));
    this.forceReloadConfig();
  }

  /**
   * 更新当前布局网格列表
   *
   * @param row 行信息
   * @param column 列信息
   */
  public updateGridConfigInfo(row: number, column: number): void {
    let gridConfig = this.getGridConfig();
    gridConfig.row = row;
    gridConfig.column = column;
    const layoutDimension = `${row}X${column}`;
    gridConfig.layout = layoutDimension;
    gridConfig.name = layoutDimension;
    this.mIsSupportForm6x4 = this.checkCardAddAble(CommonConstants.CARD_DIMENSION_6x4);
  }

  /**
   * 是否支持大卡片,当前最大的卡片为6*4
   *
   * @param
   * @returns true支持大卡片
   */
  public isSupportLargeForm(cardDimension?: number): boolean {
    if (cardDimension === undefined || cardDimension === CommonConstants.CARD_DIMENSION_6x4) {
      return this.mIsSupportForm6x4;
    } else {
      return this.checkCardAddAble(cardDimension);
    }
  }

  /**
   * 判断卡片是否可放入布局
   *
   * @param cardDimension 卡片大小dimension
   * @returns true 可放入
   */
  public checkCardAddAble(cardDimension: number): boolean {
    if (CheckEmptyUtils.isEmpty(cardDimension)) {
      return false;
    }
    let formSize = CardItemInfo.getCardSize(cardDimension);
    let gridConfig = this.getGridConfig();
    if (DeviceHelper.isPad()) {
      let maxValue = Math.max(formSize[1], formSize[0]);
      return (gridConfig.row >= maxValue && gridConfig.column >= maxValue);
    } else {
      return (gridConfig.row >= formSize[1] && gridConfig.column >= formSize[0]);
    }
  }

  /**
   * Get appList config of workspace view.
   *
   * @return {object} appList config of workspace view.
   */
  getAppListInfo(isOuter?: boolean): GridLayoutItemInfo[] {
    return this.mPageDesktopAppModeConfig.getAppListInfo(isOuter);
  }

  /**
   * Determine if there is an application in the workspace.
   *
   * @return {boolean} true(exist).
   */
  isAppListInfoExist(): boolean {
    return this.mPageDesktopAppModeConfig.isConfigExist();
  }

  /**
   * Set layout config id of grid view.
   *
   * @param gridConfig - Layout config id of grid view.
   */
  setAppListInfo(appList: GridLayoutItemInfo[] | AppItemInfo[], isOuter?: boolean): void {
    this.mPageDesktopAppModeConfig.updateAppListInfo(appList, isOuter);
  }

  /**
   * Get the layout view type.
   *
   * @return {string} Layout view type, should one of 'Grid' or 'List' which is stored in LayoutConstants class.
   */
  getAppPageStartConfig(): string {
    return this.mPageDesktopModeConfig.getAppStartPageType();
  }

  /**
   * Set the layout view type.
   *
   * @param {string} type - Layout view type, should one of 'Grid' or 'List' which is stored in LayoutConstants class.
   */
  setAppPageStartConfig(type: string): void {
    this.mPageDesktopModeConfig.updateAppStartPageType(type);
  }

  /**
   * Set the device type.
   *
   * @param {string} deviceType - device type.
   */
  setDevice(deviceType: string): void {
    log.showInfo(`setDevice ${deviceType}`);
    if (deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
      this.mGridLayoutTable = GridLayoutConfigs.GridLayoutTable;
    } else if (deviceType === CommonConstants.PAD_DEVICE_TYPE) {
      log.showInfo(`setDevice mGridLayoutTable:${JSON.stringify(this.mGridLayoutTable)}`);
    } else {
      this.mGridLayoutTable = GridLayoutConfigs.GridLayoutTableHorizontal;
    }
    this.mPageDesktopModeConfig.updateDeviceType(deviceType);
  }

  /**
   * get the device type.
   *
   * @return {string} device type
   */
  getDevice(): string {
    return this.mPageDesktopModeConfig.getDeviceType();
  }

  /**
   * Remove layout information of grid view.
   */
  deleteLayoutInfo(): void {
    this.mPageDesktopLayoutConfig.deleteConfig();
  }

  /**
   * Update settingData by settingDataKey.
   */
  setValue(value: string): void {
    settingsDataManager.setValue(this.helper, CommonConstants.NAVIGATION_BAR_STATUS_KEY, value);
  }

  /**
   * get settingDataValue by settingDataKey.
   *
   * @return settingsDataValue by settingDataKey.
   */
  getValue(): string {
    return settingsDataManager.getValue(this.helper, CommonConstants.NAVIGATION_BAR_STATUS_KEY, SettingsModel.DEFAULT_VALUE);
  }

  /**
   * Monitor data changes.
   * @param callback
   */
  registerListenForDataChanges(callback: AsyncCallback<void>): void {
    this.helper.on('dataChange', this.uri, callback);
  }

  async refreshLayoutAfterRecover(): Promise<void> {
    return this.mPageDesktopLayoutConfig.refreshLayoutAfterRecover();
  }

  /**
   * Get dock items.
   *
   * @returns the dock items.
   */
  getResidentList(): DockItemInfo[] {
    return this.residentList;
  }

  /**
   * Update dock items.
   *
   * @param residentList the dock items
   */
  setResidentList(residentList: DockItemInfo[]): void {
    this.residentList = (residentList ??= []);
  }

  /**
   * 注册预置卡片更新回调
   *
   * @param callback 数据库操作回调
   */
  registerPresetCardUpdateCallback(callback: () => void): void {
    this.mPageDesktopLayoutConfig?.registerPresetFinishedCallback(callback);
  }
}