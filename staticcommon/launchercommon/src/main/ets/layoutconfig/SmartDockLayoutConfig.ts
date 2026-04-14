/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, LogHelper, SingleContext, singleManager } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/utils/GlobalContext';
import preferences from '@ohos.data.preferences';
import { ILayoutConfig } from './ILayoutConfig';
import { CommonConstants } from '../constants/CommonConstants';
import { DockItemInfo } from '../bean/DockItemInfo';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { GetLayoutInfoFromConfig } from './GetLayoutInfoFromConfig';
import type DefaultDesktopLayoutInfo from '../configs/DefaultDesktopLayoutInfo';
import { DesktopDataLoader, LayoutViewModel } from '../TsIndex';

/**
 * Desktop Dock function layout configuration
 */
const TAG = 'SmartDockLayoutConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class SmartDockLayoutConfig extends ILayoutConfig {

  public static singleName: string = 'SmartDockLayoutConfig';

  /**
   * Dock Feature Layout Configuration Index
   */
  static SMART_DOCK_LAYOUT_INFO = CommonConstants.SMART_DOCK_LAYOUT_INFO;

  /**
   * Dock function layout data
   */
  protected mDockLayoutInfo: DockItemInfo[] = [];

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.initConfig();
  }

  /**
   * Get an instance of the workspace function layout configuration
   */
  static getInstance(ctx?: SingleContext): SmartDockLayoutConfig {
    return singleManager.get<SmartDockLayoutConfig>(SmartDockLayoutConfig, ctx);
  }

  initConfig(): void {
    const config = this.loadPersistConfig();
    this.mDockLayoutInfo = config as DockItemInfo[];
  }

  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON;
  }

  getConfigType(): number {
    return CommonConstants.LAYOUT_CONFIG_TYPE_FUNCTION;
  }

  getConfigName(): string {
    return SmartDockLayoutConfig.SMART_DOCK_LAYOUT_INFO;
  }

  public getPersistConfigJson(): string {
    return JSON.stringify(this.mDockLayoutInfo);
  }

  /**
   * 更新dock区数据加载器
   *
   * @param desktopDataLoader
   */
  updateDesktopDataLoader(desktopDataLoader: DesktopDataLoader): void {
    this.mDesktopDataLoader = desktopDataLoader;
  }

  /**
   * Update dock layout data
   *
   * @params gridLayoutInfo:dock layout data
   */
  updateDockLayoutInfo(dockLayoutInfo: DockItemInfo[]): void {
    this.mDockLayoutInfo = dockLayoutInfo;
  }

  /**
   * Update dock layout data and persist
   *
   * @params gridLayoutInfo:dock layout data
   */
  updateDockLayoutInfoAndPersist(dockLayoutInfo: DockItemInfo[]): void {
    this.mDockLayoutInfo = dockLayoutInfo;
    super.persistConfig();
  }

  /**
   * Get dock layout data
   *
   * @return dock layout data
   */
  async getDockLayoutInfo(): Promise<Array<DockItemInfo>> {
    if (CheckEmptyUtils.isEmpty(this.mDesktopDataLoader)) {
      log.showError('the DesktopDataLoader is not init');
      this.mDesktopDataLoader = DesktopDataLoader.getInstance(LayoutViewModel.getInstance(this.singleContext).getDesktopModel(), this.singleContext);
    }
    try {
      const configLayoutInfo: DefaultDesktopLayoutInfo | undefined = await this.mDesktopDataLoader?.loadFromJsonConfig();
      const dockAppList = this.convertAppLayout2DockLayout(configLayoutInfo?.layoutInfo ?? []);
      if (!CheckEmptyUtils.isEmptyArr(dockAppList)) {
        this.mDockLayoutInfo = dockAppList;
      }
    } catch (error) {
      log.showError(`promise getAllLayoutConfigFile failed, error code: ${error.code}, message: ${error.message}.`);
    }
    return this.mDockLayoutInfo;
  }

  private convertAppLayout2DockLayout(layoutInfo: GridLayoutItemInfo[]): Array<DockItemInfo> {
    let dockAppList: Array<DockItemInfo> = [];
    if (!CheckEmptyUtils.isEmptyArr(layoutInfo)) {
      layoutInfo.filter(item => item.container === CommonConstants.CONTAINER_SMARTDOCK)
        .sort((firstItem, secondItem) => (firstItem.column ?? 0) - (secondItem.column ?? 0))
        .forEach(element => {
          let newItem: DockItemInfo = new DockItemInfo();
          newItem.itemType = element.typeId;
          newItem.bundleName = element.bundleName;
          newItem.abilityName = element.abilityName;
          newItem.moduleName = element.moduleName;
          newItem.column = element.column;
          newItem.intent = element.intent;
          if (element.layoutInfo) {
            newItem.layoutInfo = element.layoutInfo;
          }
          dockAppList.push(newItem);
        });
    }
    log.showInfo(`convertAppLayout2DockLayout end, dockAppList length : ${dockAppList.length}`);
    return dockAppList;
  }

  /**
   * 获取预制的布局文件
   *
   * @returns 布局信息
   */
  protected async getAllLayoutConfigFile(): Promise<DefaultDesktopLayoutInfo | null> {
    return GetLayoutInfoFromConfig.getInstance(this.singleContext).getAllLayoutConfigFile();
  }

  /**
   * 获取简易布局是否已从预置布局读取标志位
   * @returns true 已加载
   */
  getSimpleConfigStatus(): boolean {
    try {
      let pref = preferences.getPreferencesSync(GlobalContext.getContext(),
        { name: CommonConstants.SMART_DOCK_LAYOUT_INFO });
      return pref.getSync(CommonConstants.LOAD_DEFAULT_SIMPLE_DOCK_LAYOUT, 'false') === 'true';
    } catch (err) {
      log.showError('getSimpleConfigStatus error %{public}d: %{public}s', err.code, err.message);
    }
    return false;
  }

  /**
   * 设置系统初次加载预置简易布局标志位
   */
  putSimpleConfigStatus(): void {
    try {
      let pref = preferences.getPreferencesSync(GlobalContext.getContext(),
        { name: CommonConstants.SMART_DOCK_LAYOUT_INFO });
      pref.putSync(CommonConstants.LOAD_DEFAULT_SIMPLE_DOCK_LAYOUT, 'true');
      pref.flush().then(() => {
        log.showInfo('put value of %{public}s success', CommonConstants.LOAD_DEFAULT_SIMPLE_DOCK_LAYOUT);
      }).catch((err: Error) => {
        log.showError('put value error: %{public}s', err.message);
      });
    } catch (err) {
      log.showError('putSimpleConfigStatus error %{public}d: %{public}s', err.code, err.message);
    }
  }
}
