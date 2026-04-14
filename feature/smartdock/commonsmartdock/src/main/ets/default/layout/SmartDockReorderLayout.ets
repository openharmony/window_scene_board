/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  CommonConstants,
  GridLayoutItemInfo,
  DockItemInfo,
  GridLayoutUtil,
  DockContinuableInfo
} from '@ohos/launchercommon';
import SmartDockConstants from '../common/constants/SmartDockConstants';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import { SmartDockStyleMgr } from '../manager/SmartDockStyleMgr';
import type ctx from '@ohos.app.ability.common';

const TAG: string = 'SmartDockReorderLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * dock栏挤位布局类
 */
export default class SmartDockReorderLayout {
  private static mInstance: SmartDockReorderLayout;
  private mSolutionLayout: DockItemInfo[] = [];
  private mSmartDockStyleConfig: SmartDockStyleConfig | undefined;
  private desktopContext: ctx.ServiceExtensionContext = GlobalContext.getContext();

  constructor() {
  }

  static getInstance(): SmartDockReorderLayout {
    if (SmartDockReorderLayout.mInstance == null) {
      SmartDockReorderLayout.mInstance = new SmartDockReorderLayout();
    }
    return SmartDockReorderLayout.mInstance;
  }

  /**
   * 设置dock栏布局参数
   *
   * @param smartDockStyleConfig 设置dock布局参数
   */
  public setSmartDockStyleConfig(smartDockStyleConfig: SmartDockStyleConfig): void {
    this.mSmartDockStyleConfig = smartDockStyleConfig;
  }

  /**
   * 初始化挤位方案
   *
   * @param dragItem 拖拽元素
   * @param residentList dock栏原始布局
   */
  public initSolution(dragItem: DockItemInfo, residentList: DockItemInfo[]): void {
    if (this.mSolutionLayout.length === 0) {
      this.mSolutionLayout = Array.from(residentList);
      this.moveItem(dragItem);
      log.showInfo('solution for dock has initialized');
    }
  }

  /**
   * 获取挤位方案
   *
   * @returns 挤位方案
   */
  public getSolution(): DockItemInfo[] {
    return this.mSolutionLayout;
  }

  /**
   * 清空挤位方案
   */
  public clearSolution(): void {
    this.mSolutionLayout = [];
    log.showInfo('solution for dock has cleared');
  }

  /**
   * 将元素添加到挤位方案中的指定位置
   *
   * @param item 待添加元素
   * @param index 目标索引
   * @returns 是否添加成功
   */
  public addItem(item: DockItemInfo, index: number): boolean {
    if (!this.mSmartDockStyleConfig) {
      return false;
    }
    if (index < 0 || index > this.mSolutionLayout.length ||
      this.mSolutionLayout.length >= this.mSmartDockStyleConfig.mMaxDockNum) {
      return false;
    }
    let itemIndex: number = this.getItemIndex(item);
    if (itemIndex >= 0) {
      return false;
    }

    this.mSolutionLayout.splice(index, 0, item);
    this.moveItem(item);
    log.showWarn('addItem success, key: %{public}s index: %{public}d', item.keyName, index);
    return true;
  }

  /**
   * 将元素从挤位方案中删除
   * @param item 待删除元素
   *
   * @returns 是否删除成功
   */
  public delItem(item: DockItemInfo): boolean {
    let itemIndex: number = this.getItemIndex(item);
    if (itemIndex < 0) {
      return false;
    }

    this.mSolutionLayout.splice(itemIndex, 1);
    this.moveItem(item);
    log.showWarn('delItem success, key: %{public}s index: %{public}d', item.keyName, itemIndex);
    return true;
  }

  /**
   * 将元素调整至挤位方案中的指定位置
   *
   * @param item 待调整元素
   * @param index 目标索引
   * @returns 是否调整成功
   */
  public adjustItem(item: DockItemInfo, index: number): boolean {
    if (index < 0 || index >= this.mSolutionLayout.length) {
      return false;
    }
    let itemIndex: number = this.getItemIndex(item);
    if (itemIndex < 0) {
      return false;
    }

    this.mSolutionLayout.splice(itemIndex, 1);
    this.mSolutionLayout.splice(index, 0, item);
    this.moveItem(item);
    log.showWarn('adjustItem success, key: %{public}s index: %{public}d', item.keyName, index);
    return true;
  }

  /**
   * 触发拖拽相关动效
   */
  private moveItem(item: DockItemInfo): void {
    let length: number = this.mSolutionLayout.length;
    this.desktopContext.eventHub.emit(SmartDockConstants.RESIDENT_RESHAPE_EVENT, length);

    this.mSolutionLayout.forEach((value: DockItemInfo, index: number) => {
      if (item.keyName !== value.keyName) {
        const center: number = SmartDockStyleMgr.getInstance().getDockItemCenter(length, index);
        this.desktopContext.eventHub.emit(`${SmartDockConstants.DOCK_ITEM_SQUEEZE_START}${value.keyName}`, center, false);
      }
    });
    if (AppStorage.get<boolean>('isShowContinuableItem')) {
      let deviceInfo: DockContinuableInfo | undefined = AppStorage.get<DockContinuableInfo>('continueDeviceInfo');
      const center: number = SmartDockStyleMgr.getInstance().getDockItemCenter(length, length);
      this.desktopContext.eventHub.emit(`${SmartDockConstants.DOCK_ITEM_SQUEEZE_START}${deviceInfo?.srcBundleName}`, center, false);
    }
  }

  /**
   * 获取指定元素在挤位方案中的索引
   *
   * @param item 待获取元素
   * @return 目标索引
   */
  public getItemIndex(item: DockItemInfo): number {
    let res: number = this.mSolutionLayout.findIndex((value: DockItemInfo) => {
      if (item.typeId === CommonConstants.TYPE_FOLDER) {
        return item.keyName === value.keyName;
      } else {
        return GridLayoutUtil.checkGridItemEqual(item as Object as GridLayoutItemInfo,
          value as Object as GridLayoutItemInfo);
      }
    });
    return res;
  }

  /**
   * 获取挤位方案中指定位置的元素
   *
   * @param index 目标索引
   * @return 目标索引元素
   */
  public getItem(index: number): DockItemInfo | undefined {
    if (index < 0 || index >= this.mSolutionLayout.length) {
      return undefined;
    }
    return this.mSolutionLayout[index];
  }
}