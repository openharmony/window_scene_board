/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { CommonConstants, DockItemInfo, GridLayoutUtil, SmartDockZoomFeatureSwitch } from '@ohos/launchercommon';
import SmartDockReorderLayout from '../layout/SmartDockReorderLayout';
import { SmartDockStyleMgr } from '../manager/SmartDockStyleMgr';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import { SmartDockStyleConfig } from './SmartDockStyleConfig';

const TAG: string = 'SmartDockReorderSolution';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DRAG_SAMPLE_FREQ = 60;

/**
 * dock栏挤位计算类
 */
export default class SmartDockReorderSolution {
  private static mInstance: SmartDockReorderSolution;
  private mSmartDockReorderLayout: SmartDockReorderLayout | undefined;
  private mSmartDockStyleConfig: SmartDockStyleConfig | undefined;
  private avgVX: number[] = [];
  private avgVY: number[] = [];

  constructor() {
  }

  static getInstance(): SmartDockReorderSolution {
    if (SmartDockReorderSolution.mInstance == null) {
      SmartDockReorderSolution.mInstance = new SmartDockReorderSolution();
    }
    return SmartDockReorderSolution.mInstance;
  }

  /**
   * 设置dock栏挤位方案
   *
   * @param smartDockReorderLayout 挤位方案
   */
  public setSmartDockReorderLayout(smartDockReorderLayout: SmartDockReorderLayout): void {
    this.mSmartDockReorderLayout = smartDockReorderLayout;
  }

  /**
   * 设置dock栏布局参数
   *
   * @param smartDockStyleConfig dock栏布局参数
   */
  public setSmartDockStyleConfig(smartDockStyleConfig: SmartDockStyleConfig): void {
    this.mSmartDockStyleConfig = smartDockStyleConfig;
  }

  /**
   * 获取当前挤位方案
   *
   * @param x 当前触点x坐标
   * @param y 当前触点y坐标
   * @param index 目标索引
   * @param dragItem 被拖拽元素
   */
  public getReorderSolution(x: number, y: number, index: number, dragItem: DockItemInfo): boolean {
    let direction: number[] = this.getDirectionVector(x, y, index);
    let isSuccess: boolean = false;
    /**
     * dock栏不支持上下挤位，将上下挤位转换成左右挤位，规则如下：
     * 向下挤位 -----> 向右挤位
     * 向上挤位 -----> 向左挤位
     */
    if (Math.abs(direction[0]) + Math.abs(direction[1]) > 0) {
      if (Math.abs(direction[0]) === 0) {
        direction[0] = direction[1];
      }
      isSuccess = this.pushViewsToTempLocation(index, direction[0], dragItem);
    }
    log.showWarn('getReorderSolution finish, isSuccess: %{public}s index: %{public}d', isSuccess, index);
    return isSuccess;
  }

  /**
   * 将拖拽元素添加到挤位方案
   *
   * @param index 目标索引
   * @param directionX x轴的挤位方向
   * @param dragItem 被拖拽元素
   * @returns 是否插入成功
   */
  private pushViewsToTempLocation(index: number, directionX: number, dragItem: DockItemInfo): boolean {
    if (!this.mSmartDockReorderLayout) {
      return false;
    }
    let itemIndex: number = this.mSmartDockReorderLayout.getItemIndex(dragItem);
    if (itemIndex < 0) {
      // 挤位方案中无元素时，强制添加到索引0的位置
      if (this.mSmartDockReorderLayout.getSolution().length === 0) {
        return this.mSmartDockReorderLayout.addItem(dragItem, 0);
      }
      // 如果自由多窗模式下，尝试往任务中心左边添加图标，那么改为在任务中心右侧第1个添加图标
      if (index === 0 && directionX === 1 &&
        this.mSmartDockReorderLayout.getItem(0)?.abilityName === CommonConstants.RECENT_ABILITY) {
        return this.mSmartDockReorderLayout.addItem(dragItem, index + 1);
      }

      /**
       * 拖拽元素不在挤位方案中，尝试添加到挤位方案中，规则如下：
       * 向左挤位 -----> 在右侧插入
       * 向右挤位 -----> 在左侧插入
       */
      if (directionX === -1) {
        return this.mSmartDockReorderLayout.addItem(dragItem, index + 1);
      }
      if (directionX === 1) {
        return this.mSmartDockReorderLayout.addItem(dragItem, index);
      }
    }
    let mDockItemInfo = this.mSmartDockReorderLayout.getItem(itemIndex);
    if (mDockItemInfo) {
      // 拖拽元素在在挤位方案中，调整元素相对位置
      return this.mSmartDockReorderLayout.adjustItem(mDockItemInfo, index);
    }
    return false;
  }

  /**
   * 获取挤位方向
   *
   * @param x 当前触点x坐标
   * @param y 当前触点y坐标
   * @param index 目标索引
   * @returns 挤位方向
   */
  private getDirectionVector(x: number, y: number, index: number): number[] {
    let center: number[] = this.getDockItemPosition(index);
    let deltaX: number = center[0] - x;
    let deltaY: number = center[1] - y;
    let resultDirection: number[] = [0, 0];
    if (deltaX === 0 && deltaY === 0) {
      // 重合时指定向右挤位
      resultDirection = [1, 0];
    } else {
      resultDirection = this.computeDirectionVector(deltaX, deltaY);
    }
    return resultDirection;
  }

  /**
   * 根据偏移量计算挤位方向
   *
   * @param deltaX X轴位置差值
   * @param deltaY Y轴位置差值
   * @returns result 挤位方向
   */
  private computeDirectionVector(deltaX: number, deltaY: number): number[] {
    let result: number[] = [0, 0];
    if (deltaX === 0) {
      result[1] = Math.sign(deltaY);
    } else {
      let angle: number = Math.atan(deltaY / deltaX);
      if (Math.abs(Math.cos(angle)) > 0.5) {
        result[0] = Math.sign(deltaX);
      }
      if (Math.abs(Math.sin(angle)) > 0.5) {
        result[1] = Math.sign(deltaY);
      }
    }
    return result;
  }

  /**
   * 寻找最近落点
   *
   * @param x 当前触点x坐标
   * @param y 当前触点y坐标
   * @returns 最近落点索引
   */
  public findNearestArea(x: number, y: number): number {
    if (!this.mSmartDockReorderLayout) {
      return 0;
    }
    const residentList: DockItemInfo[] = this.mSmartDockReorderLayout.getSolution();
    // 挤位方案为空时，最近落点索引为0
    if (residentList.length === 0) {
      return 0;
    }
    let bestLocation: number = CommonConstants.INVALID_VALUE;
    let bestDistance: number = Number.MAX_SAFE_INTEGER;
    for (let i = 0; i < residentList.length; ++i) {
      let cellCoords: number[] = this.getDockItemPosition(i);
      let distance: number = Math.hypot(cellCoords[0] - x, cellCoords[1] - y);
      if (distance <= bestDistance) {
        bestDistance = distance;
        bestLocation = i;
      }
    }
    return bestLocation;
  }

  /**
   * 记录拖拽手势的方向
   *
   * @param vX 拖拽的横向方向
   * @param vY 拖拽的纵向方向
   */
  public recordV(vX: number, vY: number): void {
    if (this.avgVX.length >= DRAG_SAMPLE_FREQ) {
      this.avgVX.shift();
    }
    this.avgVX.push(vX);
    if (this.avgVY.length >= DRAG_SAMPLE_FREQ) {
      this.avgVY.shift();
    }
    this.avgVY.push(vY);
  }
  
  /**
   * 是否可以覆盖
   *
   * @param x 当前触点x坐标
   * @param y 当前触点y坐标
   * @param index 目标索引
   * @param dragItem 拖拽元素
   * @returns 是否可以覆盖
   */
  public isCanCover(x: number, y: number, index: number, dragItem: DockItemInfo): boolean {
    // 拖拽小文件夹时无法合并
    if (GridLayoutUtil.isSmallFolder(dragItem)) {
      return false;
    }
    if (!this.mSmartDockReorderLayout || !this.mSmartDockStyleConfig) {
      return false;
    }
    // 目标元素为空或拖拽元素与目标元素相同时无法合并
    let dockItem: DockItemInfo | undefined = this.mSmartDockReorderLayout.getItem(index);
    if (!dockItem || dockItem.keyName === dragItem.keyName || dockItem.abilityName === CommonConstants.RECENT_ABILITY) {
      return false;
    }
    let center: number[] = this.getDockItemPosition(index);
    const coverResult = GridLayoutUtil.canCreateFolder(
      this.mSmartDockStyleConfig.mListItemWidth,
      [x, y],
      center,
      this.avgVX,
      this.avgVY
    );
    return coverResult;
  }

  /**
   * 获取solution中指定索引元素的中心点坐标
   *
   * @param index 指定索引
   * @returns 中心点坐标
   */
  public getDockItemPosition(index: number): number[] {
    if (!this.mSmartDockReorderLayout || !this.mSmartDockStyleConfig) {
      return [CommonConstants.INVALID_VALUE, CommonConstants.INVALID_VALUE];
    }
    const residentList: DockItemInfo[] = this.mSmartDockReorderLayout.getSolution();
    if (index < 0 || index >= residentList.length) {
      return [CommonConstants.INVALID_VALUE, CommonConstants.INVALID_VALUE];
    }

    const centerX: number = SmartDockStyleMgr.getInstance().getDockItemCenter(residentList.length, index);
    const screenHeight: number = AppStorage.get<number>('screenHeight') as number;
    const dockHeight: number = AppStorage.get<number>('dockHeight') as number;
    const centerY: number = this.getDockItemCenterY(screenHeight, dockHeight);
    return [centerX, centerY];
  }

  /**
   * 计算dock栏图标Y轴中心坐标
   */
  public getDockItemCenterY(screenHeight: number, dockHeight: number): number {
    const dockRegionLayoutModel: DockRegionLayoutModel = DockRegionLayoutModel.getInstance();
    // smartDock设置了margin参数，使得smartDock的高度dockHeight加上smartDockMargin超出了屏幕高度，从而导致实际布局的smartDock高度被挤压
    // 计算实际落位点时，需要对dockHeight进行等比缩放，以适应被挤压后的smartDock布局
    const smartDockHeight: number =
      dockHeight * (screenHeight - SmartDockStyleConfig.getInstance().mSmartDockMarginTop) / screenHeight;

    if (SmartDockZoomFeatureSwitch.isSupportZoom()) {
      return screenHeight - smartDockHeight + (this.mSmartDockStyleConfig?.mDockHeight ?? 0) -
        dockRegionLayoutModel.getDockHeight() / 2;
    }
    // 直板机简易模式需考虑图标与dock上边缘的间距，图标越小间距越大，使图标中心固定
    return screenHeight - smartDockHeight +
      (this.mSmartDockStyleConfig?.mDockHeight ?? 0) / 2 - dockRegionLayoutModel.getSimpleModeMarginTop();
  }
}