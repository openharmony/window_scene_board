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

import { CheckEmptyUtils, LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import { NumberConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import {
  CenterConstants,
  CommonConstants,
  DockItemInfo,
  GridLayoutUtil,
  layoutConfigManager,
  RecentLayoutCacheMgr,
  ResidentLayoutCacheMgr,
  SmartDockZoomFeatureSwitch
} from '@ohos/launchercommon';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import FeatureConstants from '../common/constants/FeatureConstants';
import type { SmartDockStyleInterface } from '../common/interfaces/SmartDockStyleInterface';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import { IconType } from '@ohos/launchercommon/src/main/ets/bean/DockItemInfo';
import { DockRegionType } from '../common/enum/SmartDockEnum';
import { CollaborationLayoutCacheMgr } from '@ohos/launchercommon/src/main/ets/dock/cache/CollaborationLayoutCacheMgr';

const TAG = 'SmartDockStyleMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const NUMBER_DOUBLE: number = 2;

/**
 * SmartDock style interface impl
 */
export class SmartDockStyleMgr implements SmartDockStyleInterface {
  private static mInstance: SmartDockStyleMgr;
  protected readonly mSmartDockStyleConfig: SmartDockStyleConfig;
  private layoutModel: DockRegionLayoutModel;
  private mDockCenter: number = 0;

  constructor() {
    this.mSmartDockStyleConfig =
      layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
    this.layoutModel = DockRegionLayoutModel.getInstance();
    log.showInfo('Launcher SmartDockStyleMgr constructor!');
  }

  static getInstance(): SmartDockStyleMgr {
    if (SmartDockStyleMgr.mInstance == null) {
      SmartDockStyleMgr.mInstance = new SmartDockStyleMgr();
    }
    return SmartDockStyleMgr.mInstance;
  }

  /**
   * get SmartDockStyleConfig
   */
  getStyleConfig(): SmartDockStyleConfig {
    return layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
  }

  /**
   * update drag effective area when dockList changed
   */
  async updateDockParams(deviceType: string): Promise<void> {
    const screenWidth: number = AppStorage.get('screenWidth') ?? 0;
    const screenHeight: number = AppStorage.get('screenHeight') ?? 0;
    const sysUIBottomHeight: number = AppStorage.get('sysUIBottomHeight') ?? 0;
    const dockHeight: number = AppStorage.get('dockHeight') ?? 0;
    let mResidentWidth: number = this.getListWidth(ResidentLayoutCacheMgr.getInstance().getAllDockItems(), deviceType);
    AppStorage.setOrCreate('residentWidth', mResidentWidth);
    AppStorage.setOrCreate('dockPadding', this.getDockPadding(mResidentWidth, deviceType));
    let mRecentWidth: number = this.getListWidth(AppStorage.get('recentList') ?? [], deviceType);
    if (deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
      mResidentWidth = this.mSmartDockStyleConfig.mDockPadding * NumberConstants.CONSTANT_NUMBER_TWO +
        this.mSmartDockStyleConfig.mMaxDockNum * (this.mSmartDockStyleConfig.mListItemWidth) +
        (this.mSmartDockStyleConfig.mMaxDockNum - 1) * (this.mSmartDockStyleConfig.mListItemGap);
      mRecentWidth = 0;
    }
    log.showInfo(`updateDockParams screenWidth:${screenWidth}, screenHeight:${screenHeight}, sysUIBottomHeight:${sysUIBottomHeight}, dockHeight:${dockHeight}, mResidentWidth:${mResidentWidth}, mRecentWidth:${mRecentWidth}`);
  }

  /**
   * 重置dock中心
   */
  public reSetDockCenter(): void {
    this.mDockCenter = 0;
  }

  /**
   * 初始化dock栏元素中心点x坐标
   * @param dockCenter 当前dock栏中心点
   */
  public initDockItemCenterArray(dockCenter: number): void {
    log.showInfo('initDockItemCenterArray, dockCenter: %{public}d', this.mDockCenter);
    // i为dock栏元素个数， j为元素索引
    for (let i = 1; i <= this.mSmartDockStyleConfig.mMaxDockNum; i++) {
      CenterConstants.itemCenterX[i] = [];
      let dockLeft: number = dockCenter - (i * this.mSmartDockStyleConfig.mListItemWidth + (i - 1) *
      this.mSmartDockStyleConfig.mListItemGap) / NumberConstants.CONSTANT_NUMBER_TWO;
      for (let j = 0; j < i; j++) {
        CenterConstants.itemCenterX[i][j] = dockLeft + j * (this.mSmartDockStyleConfig.mListItemWidth +
        this.mSmartDockStyleConfig.mListItemGap) +
          this.mSmartDockStyleConfig.mListItemWidth / NumberConstants.CONSTANT_NUMBER_TWO;
      }
    }
  }

  /**
   * 获取dock栏recent区宽度
   * @return dock区recent栏宽度
   */
  public getRecentLayoutWidth(): number {
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      return AppStorage.get<number>('pcModeRecentWidth') ?? 0;
    } else {
      return this.layoutModel.getRegionLayoutWidth(DockRegionType.RECENT);
    }
  }

  /**
   * 获取dock常驻区宽度
   *
   * @return dock常驻区宽度
   */
  public getResidentLayoutWidth(): number {
    return AppStorage.get<number>('residentLayoutWidth') ?? 0;
  }

  /**
   * 获取含指定元素个数的dock栏中索引对应元素x坐标
   *
   * @param length dock栏元素个数 index元素索引
   */
  public getDockItemCenter(length: number, index: number): number {
    let isShowContinuableItem = AppStorage.get<boolean>('isShowContinuableItem');
    // 判断是否在缩放是为了支持已超上限用户无感拖出dock,后续缩放底座能力支持后去除
    const isLengthValid: boolean =
      length < 0 || (length > this.mSmartDockStyleConfig.mMaxDockNum && !SmartDockZoomFeatureSwitch.isSupportZoom());
    const isIndexValid: boolean = index < 0 || index > length;
    const noContinuableItemValid: boolean =
      (!isShowContinuableItem && length === 0) || (!isShowContinuableItem && index === length);
    if (isLengthValid || isIndexValid || noContinuableItemValid) {
      log.showError('getDockItemCenter invalid params, length: %{public}d, index: %{public}d', length, index);
      return CommonConstants.INVALID_VALUE;
    }
    let num: number = length;
    if (isShowContinuableItem) {
      num = length + 1;
      log.showInfo('show continueItem');
    }
    let recentWidth: number = this.getRecentLayoutWidth();
    const dividerWidth: number = this.layoutModel.getDividerWidth();
    const screenWidth: number = AppStorage.get<number>('screenWidth') ?? 0;
    let residentCenter: number = 0;
    // 手机折叠态时，dock栏中心点等于屏幕宽度的一半
    if (DeviceHelper.isPhone() && !GridLayoutUtil.isLargeFoldOrTrifoldExpanded()) {
      residentCenter = screenWidth / NUMBER_DOUBLE;
    } else {
      let leftWidth = screenWidth;
      if (recentWidth > 0) {
        leftWidth -= (recentWidth + dividerWidth);
      }
      if (DeviceHelper.isPad()) {
        let collaborationWidth: number =
          this.layoutModel.calculateRegionWidthWithScale(
            CollaborationLayoutCacheMgr.getInstance().getAllDockItems().length);
        if (collaborationWidth > 0) {
          leftWidth += (collaborationWidth + dividerWidth);
        }
      }
      residentCenter = leftWidth / NUMBER_DOUBLE;
    }
    let center: number = residentCenter + (index - (num - 1) / NUMBER_DOUBLE) *
      (this.layoutModel.getIconSize() + this.layoutModel.getSpace(num));
    return RTLUtil.getPositionByRTL(center, screenWidth);
  }

  /**
   * 获取当前dock栏recent栏的最大可拉伸长度
   * @return 使用拖动条拖拽时，recent栏拉长至屏幕边缘的最大宽度
   */
  public getMaxRecentWidth(): number {
    const smartDockWidthWithoutRecent: number = this.getSmartDockWidthWithoutRecent();
    const screenWidth: number = AppStorage.get<number>('screenWidth') ?? 0;
    return screenWidth - smartDockWidthWithoutRecent;
  }

  protected getDockPadding(residentWidth: number,
    deviceType: string): RectInfo {
    let paddingNum: number = this.mSmartDockStyleConfig.mDockPadding;
    const residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
      paddingNum = (residentWidth - (residentList.length * this.mSmartDockStyleConfig.mListItemWidth +
        (residentList.length - 1) * (this.mSmartDockStyleConfig.mListItemGap))) / NumberConstants.CONSTANT_NUMBER_TWO;
    }
    log.showInfo(`getDockPadding paddingNum: ${paddingNum}`);
    let rectInfo: RectInfo = new RectInfo();
    rectInfo.left = paddingNum;
    rectInfo.right = paddingNum;
    rectInfo.top = this.mSmartDockStyleConfig.mDockPadding;
    rectInfo.bottom = this.mSmartDockStyleConfig.mDockPadding;
    return rectInfo;
  }

  /**
   * 计算dock栏分区的宽度，根据输入的应用数量与设备类型输出分区的宽度
   * @param itemList 应用列表
   * @param deviceType 设备类型
   */
  protected getListWidth(itemList: DockItemInfo[], deviceType: string): number {
    let width = 0;
    const num = itemList.length;
    const maxDockNum = this.getStyleConfig().mMaxDockNum;
    if (deviceType === CommonConstants.DEFAULT_DEVICE_TYPE) {
      width = this.mSmartDockStyleConfig.mDockPadding * NUMBER_DOUBLE +
        num * (this.mSmartDockStyleConfig.mListItemWidth) + (num - 1) * (this.mSmartDockStyleConfig.mListItemGap);
      log.showInfo(`getListWidth mDockPadding: ${this.mSmartDockStyleConfig.mDockPadding},
        mMaxDockNum: ${maxDockNum}, getListWidth width : ${width}`);
      if (width <= 0) {
        width = this.mSmartDockStyleConfig.mDockPadding * NUMBER_DOUBLE + maxDockNum *
          (this.mSmartDockStyleConfig.mListItemWidth) + (maxDockNum - 1) * (this.mSmartDockStyleConfig.mListItemGap);
      }
      return width;
    }
    if (typeof itemList === 'undefined' || itemList == null || itemList.length === 0) {
      return width;
    }
    width = this.mSmartDockStyleConfig.mDockPadding * NUMBER_DOUBLE +
      num * (this.mSmartDockStyleConfig.mListItemWidth) + (num - 1) * (this.mSmartDockStyleConfig.mListItemGap);
    return width;
  }

  // 获取当前dock栏总体宽度减去recent宽度，为recent背板拖拽提供变量，recent背板最大宽度 = 屏幕宽度 - dock栏总体宽度减去recent宽度
  private getSmartDockWidthWithoutRecent(): number {
    let smartDockWidthWithoutRecent: number = 0;
    const residentWidth: number = AppStorage.get<number>('residentLayoutWidth') as number;
    const dividerWidth: number = this.layoutModel.getDividerWidth();

    smartDockWidthWithoutRecent = residentWidth + dividerWidth;
    return smartDockWidthWithoutRecent;
  }

  private getRecentList(): DockItemInfo[] {
    if (SCBSceneSessionManager.getInstance().isPcMode()) {
      return AppStorage.get<DockItemInfo[]>('recentList') ?? [];
    } else {
      return RecentLayoutCacheMgr.getInstance().getAllDockItems();
    }
  }

  /**
   * 获取Dock中指定ID元素的中心点坐标
   *
   * @param itemId 元素ID
   */
  public getDockItemCenterPosition(itemId: string): number[] {
    const rectInfo: RectInfo = ItemUtils.getRectById(itemId);
    return [(rectInfo.left + rectInfo.right) / 2, (rectInfo.top + rectInfo.bottom) / 2];
  }

  /**
   * 获取含指定元素个数的dock栏中索引对应元素x坐标
   *
   * @param length dock栏元素个数
   * @param index 元素索引
   * @param region dock区域
   */
  public getDockItemCenterXByRegion(length: number, index: number, region: DockRegionType): number {
    const isLengthValid: boolean = length < 0;
    const isIndexValid: boolean = index < 0 || index > length;
    if (isLengthValid || isIndexValid) {
      return CommonConstants.INVALID_VALUE;
    }

    const recentWidth: number = this.getRecentLayoutWidth();
    const residentWidth: number = this.getResidentLayoutWidth();
    const dividerWidth: number = this.layoutModel.getDividerWidth();
    const screenWidth: number = AppStorage.get<number>('screenWidth') ?? 0;

    let leftWidth: number = screenWidth;
    switch (region) {
      case DockRegionType.RESIDENT:
        if (recentWidth > 0) {
          leftWidth -= (recentWidth + dividerWidth);
        }
        break;
      case DockRegionType.RECENT:
        if (residentWidth > 0) {
          leftWidth += (residentWidth + dividerWidth);
        }
        break;
      case DockRegionType.COLLABORATION:
        if (residentWidth > 0) {
          leftWidth -= (residentWidth + dividerWidth);
        }
        if (recentWidth > 0) {
          leftWidth -= (recentWidth + dividerWidth);
        }
        break;
    }
    let residentCenter = leftWidth / NUMBER_DOUBLE;
    let center: number = residentCenter + (index - (length - 1) / NUMBER_DOUBLE) *
      (this.layoutModel.getListItemWidth() + this.layoutModel.getSpace(length));
    return RTLUtil.getPositionByRTL(center, screenWidth);
  }

  /**
   * 获取元素Y坐标中心
   */
  public getDockItemCenterY(): number {
    const screenHeight: number = AppStorage.get<number>('screenHeight') as number;
    const dockHeight: number = AppStorage.get<number>('dockHeight') as number;
    // smartDock设置了margin参数，使得smartDock的高度dockHeight加上smartDockMargin超出了屏幕高度，从而导致实际布局的smartDock高度被挤压
    // 计算实际落位点时，需要对dockHeight进行等比缩放，以适应被挤压后的smartDock布局
    const smartDockHeight: number =
      dockHeight * (screenHeight - SmartDockStyleConfig.getInstance().mSmartDockMarginTop) / screenHeight;
    // 根据dock栏顶部计算落位相对位置
    const centerY = screenHeight - smartDockHeight + this.mSmartDockStyleConfig.mDockHeight / 2;
    log.showInfo('getDockItemCenterY centerY: %{public}d', centerY);
    return centerY;
  }
}