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

import { CheckEmptyUtils, LogDomain, LogHelper, SingleContext } from '@ohos/basicutils';
import { DeviceHelper, HiSysEventUtil } from '@ohos/frameworkwrapper';
import {
  CommonConstants,
  DockContinuableInfo,
  DockItemInfo,
  HiSysContinueFuncResult,
  layoutConfigManager,
  SCBHiSysEventUtil,
  SmartDockZoomFeatureSwitch
} from '@ohos/launchercommon';
import { SmartDockStyleConfig } from '../common/SmartDockStyleConfig';
import FeatureConstants from '../common/constants/FeatureConstants';
import RecentDockModel from '../model/RecentDockModel';
import DockRegionLayout from './DockRegionLayout';
import { DockRegionType } from '../common/enum/SmartDockEnum';
import { DockRegionLayoutModel } from '../model/DockRegionLayoutModel';
import { IconType } from '@ohos/launchercommon/src/main/ets/bean/DockItemInfo';
import { IDividerDragEvent } from '../interface/IDividerDragEvent';
import { ILayoutRefreshHandler } from '../interface/ILayoutRefreshHandler';
import { SmartDockStyleMgr } from '../manager/SmartDockStyleMgr';
import { SmartDockZoomEvent } from '../viewmodel/SmartDockZoomEvent';

const TAG = 'SmartDock_V_ScbRecentLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ITEMS_CHANGED_MAX_FLAG: number = 3;
const MAX_RECENT_COUNT: number = 4;

/**
 * ScbRecentLayout
 *
 * @since 2022-10-09
 */
@Component
export default struct ScbRecentLayout {
  mRecentDockMaxNumber: number = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM;
  @Prop singleContext?: SingleContext;
  mSmartDockStyleConfig: SmartDockStyleConfig =
    layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG, FeatureConstants.FEATURE_NAME);
  onItemClick?: Function;
  buildMenu?: Function;
  private layoutModel: DockRegionLayoutModel = DockRegionLayoutModel.getInstance();
  private recentDockListRotate: Array<DockItemInfo> = [];
  private recentDockModel: RecentDockModel = RecentDockModel.getInstance(this.singleContext);
  private deviceType: string = '';
  private visibleCount: number = 0;
  private dividerDragEvent: IDividerDragEvent = {
    onActionUpdate: (event?: GestureEvent) => {
      //向左拉长超过图标数量时增加阻尼曲线 y=x−0.25𝑥^2的导数1 -0.5𝑥
      let num = this.recentDockListRotate.length + 1;
      const recentWidthWithOneMoreApp: number =
        this.layoutModel.getListPadding() * 2 + num * this.layoutModel.getListItemWidth() +
          (num - 1) * this.layoutModel.getSpace(this.recentDockListRotate.length);
      const maxRecentWidth: number = SmartDockStyleMgr.getInstance().getMaxRecentWidth();
      // 背板能拉伸的最大宽度为一个图标宽度，若这个拉伸宽度导致背板超过手机屏幕，则使背板最大拉伸至屏幕两侧
      return Math.min(recentWidthWithOneMoreApp, maxRecentWidth);
    },
    onActionEnd: (layoutWidth: number, event?: GestureEvent) => {
      let spaceValue = this.layoutModel.getSpace(this.recentDockListRotate.length);
      this.visibleCount =
        this.recentDockModel.computeVisibleCount(this.recentDockListRotate, this.visibleCount, spaceValue, layoutWidth);
      this.recentDockModel.updateVisibleCount(this.visibleCount, true);
      this.recentDockModel.setRecentListRotateNum(this.visibleCount);
      return this.recentDockModel.getRecentLayoutWidthUp(this.visibleCount, spaceValue);
    }
  };
  private refreshHandler: ILayoutRefreshHandler = {
    calculateLayoutWidth: (): number => {
      return this.getListWidth();
    },
    reloadItems: (): Array<DockItemInfo> => {
      return this.queryRecentItems();
    }
  };
  // 触发接续出场/退场动效
  @State isContinueShow: boolean = false;
  // 触发最近任务列表增加/减少动效
  @State itemsChangeFlag: number = 0;
  @Link @Watch('onRecentListChange') recentDockList: Array<DockItemInfo>;
  @StorageLink('residentList') @Watch('onResidentListChange') appList: Array<DockItemInfo> = [];
  @StorageLink('isPortrait') isPortrait: boolean = true;

  private isResidentElement(bundleName: string, appIndex: number = 0): boolean {
    let item = this.appList.find((value) => bundleName === value.bundleName && value.appIndex === appIndex &&
      value.typeId === 0);
    return !CheckEmptyUtils.isEmpty(item);
  }

  private getListWidth(): number {
    if (this.recentDockListRotate.length === 0) {
      return 0;
    }

    //实际显示图标数量
    this.visibleCount = this.recentDockModel.getVisibleCount();
    let realVisibleCount = this.recentDockListRotate.length;
    if (realVisibleCount >= this.visibleCount && this.visibleCount != 0) {
      realVisibleCount = this.visibleCount;
    }

    // 竖屏状态recent区最大个数不能使用mRecentDockMaxNumber和visibleCount直接判断
    let maxNum = this.mRecentDockMaxNumber;
    let isPadPortraitHaveTask = this.recentDockModel.isPadPortraitHaveTask(this.isPortrait, this.recentDockListRotate);
    if (isPadPortraitHaveTask) {
      maxNum = this.mSmartDockStyleConfig.mMaxDockNum - this.appList.length + 1;
    }
    let num = realVisibleCount > maxNum ? maxNum : realVisibleCount;
    return this.layoutModel.calculateRegionWidth(num);
  }

  private onRecentListChange(): void {
    log.showInfo('onRecentListChange');
    this.onItemsListChange();
  }

  private onResidentListChange(): void {
    log.showInfo('onResidentListChange');
    this.onItemsListChange();
  }

  private onItemsListChange(): void {
    if (this.itemsChangeFlag > ITEMS_CHANGED_MAX_FLAG) {
      this.itemsChangeFlag = 0;
    } else {
      this.itemsChangeFlag++;
    }
  }

  private queryRecentItems(): Array<DockItemInfo> {
    let tempRecentItems = this.recentDockList.slice();

    let isPadPortraitHaveTask: boolean = this.recentDockModel.isPadPortraitHaveTask(this.isPortrait, tempRecentItems);
    if (!SmartDockZoomFeatureSwitch.isSupportZoom() && isPadPortraitHaveTask) {
      const recentListLength = this.mSmartDockStyleConfig.mMaxDockNum - this.appList.length + 1;
      tempRecentItems = tempRecentItems.slice(0, recentListLength < 1 ? 1 : recentListLength);
    }

    // 最近区达到最大数量，且存在接续图标时，裁剪最后一个图标，保证最大数量不越界
    if (tempRecentItems.length > this.mRecentDockMaxNumber) {
      tempRecentItems = tempRecentItems.slice(0, tempRecentItems.length - 1);
    }
    if (!SmartDockZoomFeatureSwitch.isSupportZoom() || !isPadPortraitHaveTask) {
      this.recentDockModel.setRecentListRotateNum(tempRecentItems.length < this.visibleCount ?
      tempRecentItems.length : this.visibleCount);
    } else {
      let recentListLength = MAX_RECENT_COUNT + this.mSmartDockStyleConfig.mMaxDockNum -
        this.appList.length;
      recentListLength = Math.min(recentListLength, MAX_RECENT_COUNT);

      this.recentDockModel.setRecentListRotateNum(tempRecentItems.length < recentListLength ?
      tempRecentItems.length : recentListLength);
      SmartDockZoomEvent.getInstance().onDockRefresh(DockRegionType.RECENT, recentListLength);
      tempRecentItems = tempRecentItems.slice(0, recentListLength < 1 ? 1 : recentListLength);
    }

    this.recentDockListRotate = tempRecentItems;
    return tempRecentItems;
  }

  aboutToAppear(): void {
    log.showInfo('RecentLayout aboutToAppear');
    this.mRecentDockMaxNumber = this.mSmartDockStyleConfig.mRecentDockMaxNumber;
    this.visibleCount = this.recentDockModel.getVisibleCount();
  }

  aboutToDisappear(): void {
    log.showInfo('RecentLayout aboutToDisappear');
  }

  build() {
    DockRegionLayout({
      dividerDragEvent: this.dividerDragEvent,
      singleContext: this.singleContext,
      refreshHandler: this.refreshHandler,
      buildMenu: this.buildMenu,
      deviceType: this.deviceType,
      isContinueShow: this.isContinueShow,
      itemsChangeFlag: this.itemsChangeFlag,
      region: DockRegionType.RECENT,
      onItemClick: (event: ClickEvent, item: DockItemInfo) => {
        log.showInfo(`RecentLayout onClick, ${item.iconType}`);
        if (this.onItemClick) {
          this.onItemClick(event, item);
        }
        HiSysEventUtil.reportDockRecentAppClick(item.bundleName);
      }
    });
  }
}