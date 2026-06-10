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

import {
  CommonConstants,
  DockContinuableInfo,
  DockItemInfo,
  RecentLayoutCacheMgr,
  ResidentLayoutCacheMgr,
  SmartDockZoomFeatureSwitch
} from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, Logger, SingleBase } from '@ohos/basicutils';
import { DockRegionType } from './enum/SmartDockEnum';
import { SmartDockStyleConfig } from './SmartDockStyleConfig';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import { SmartDockZoomEvent } from '../viewmodel/SmartDockZoomEvent';
import RecentDockModel from '../model/RecentDockModel';

const TAG = 'SmartDock_V_ResidentLayout';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class SmartDockDropPositionUtils extends SingleBase {
  private static instance: SmartDockDropPositionUtils;

  static getInstance(): SmartDockDropPositionUtils {
    if (!SmartDockDropPositionUtils.instance) {
      SmartDockDropPositionUtils.instance = new SmartDockDropPositionUtils();
    }
    return SmartDockDropPositionUtils.instance;
  }

  /**
   * 获取因最近任务区减少导致的X轴方向偏移
   */
  public getRecentOffsetX(index: number, config: SmartDockStyleConfig): number {
    if (!config || !index || index < 0) {
      log.showWarn(TAG, 'get recent offsetX failed by illegal input');
      return 0;
    }
    const isZoom: boolean = SmartDockZoomFeatureSwitch.isSupportZoom() &&
      DockRegionLayoutModel.getInstance().getListCount() > SmartDockZoomEvent.getInstance().getMinZoomLimit();
    if (isZoom) {
      const leftSpaceOffset: number = this.getLeftSpaceOffset();
      const offsetForScaleChange: number = this.getOffsetForScaleChange(index, config);
      return leftSpaceOffset + offsetForScaleChange;
    }
    if (this.isExistRecentItem()) {
      return (config.mListItemWidth + config.mListItemGap) / 2;
    }
    let divWidth: number = RecentDockModel.getInstance(this.singleContext).getDividerWidth();
    return config.mDockPadding + (config.mListItemWidth + divWidth) / 2;
  }

  /**
   * 获取因缩放系数不同,图标在常驻区中距离变化导致的X轴方向偏移
   */
  private getOffsetForScaleChange(index: number, config: SmartDockStyleConfig): number {
    const model: DockRegionLayoutModel = DockRegionLayoutModel.getInstance();
    const lastScale: number =
      model.calculateScaleWithRegionNum(model.getRegionLayoutLength(DockRegionType.RECENT) + 1, DockRegionType.RECENT);
    // 偏移的基数为图标到常驻区背板左侧的距离,即图标背板间距加n-1个图标宽度与图标间距加半个图标宽度
    const itemPositionOffset: number = config.mDockPadding + config.mListItemWidth / 2 +
      index * (config.mListItemWidth + config.mListItemGap);
    return itemPositionOffset * (model.getScale() - lastScale);
  }

  /**
   * 获取因缩放系数不同,常驻区与屏幕距离变化导致的X轴方向偏移
   */
  private getLeftSpaceOffset(): number {
    const model: DockRegionLayoutModel = DockRegionLayoutModel.getInstance();
    const dockWidth: number =
      model.calculateLayoutWidth(DockRegionType.RECENT) + model.calculateLayoutWidth(DockRegionType.COLLABORATION) +
      model.calculateLayoutWidth(DockRegionType.RESIDENT);
    const lastDockWidth: number =
      model.calculateLayoutWidth(DockRegionType.RECENT, model.getRegionLayoutLength(DockRegionType.RECENT) + 1) +
      model.calculateLayoutWidth(DockRegionType.COLLABORATION) + model.calculateLayoutWidth(DockRegionType.RESIDENT);
    const lastScale: number =
      model.calculateScaleWithRegionNum(model.getRegionLayoutLength(DockRegionType.RECENT) + 1, DockRegionType.RECENT);
    const scale: number = model.getScale();

    let offset: number = (lastScale * lastDockWidth - scale * dockWidth) / 2;
    // 偏移的基数为dock常驻区背板左侧到屏幕左边缘的距离,若无协同区则为屏幕宽减dock区宽结果的二分之一,若有协同区,还要加上协同区长度
    if (model.calculateLayoutWidth(DockRegionType.COLLABORATION) > 0) {
      offset += (model.calculateLayoutWidth(DockRegionType.COLLABORATION)) * (scale - lastScale);
    }
    return offset;
  }

  /**
   * 获取因最近任务区减少导致的Y轴方向偏移
   */
  public getRecentOffsetY(config: SmartDockStyleConfig): number {
    if (!config) {
      log.showWarn(TAG, 'get recent offsetX failed by illegal input');
      return 0;
    }
    const model: DockRegionLayoutModel = DockRegionLayoutModel.getInstance();
    // 偏移的基数为图标中心点到背板底部距离,即图标宽度的一半加图标背板间距
    let offsetForScaleChange: number = (model.getIconSize() / 2 + config.mDockPadding);
    const lastScale: number =
      model.calculateScaleWithRegionNum(model.getRegionLayoutLength(DockRegionType.RECENT) + 1, DockRegionType.RECENT);
    return offsetForScaleChange * (lastScale - model.getScale()) / model.getScale();
  }

  /**
   * 判断Dock是否有最近使用区
   *
   * @returns 是否存在
   */
  private isExistRecentItem(): boolean {
    const recentList: DockItemInfo[] = RecentLayoutCacheMgr.getInstance().getAllDockItems();
    if (recentList.length > 0) {
      return true;
    }
    const deviceInfo: DockContinuableInfo | undefined = AppStorage.get<DockContinuableInfo>('continueDeviceInfo');
    if (!deviceInfo || CheckEmptyUtils.isEmpty(deviceInfo.bundleName) ||
      CheckEmptyUtils.isEmpty(deviceInfo.sourceDeviceName)) {
        return false;
    }
    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (residentList.find((item) => item.appIndex === 0 && item.typeId === CommonConstants.TYPE_APP &&
      item.bundleName === deviceInfo.bundleName)) {
        return false;
    }
    return true;
  }
}