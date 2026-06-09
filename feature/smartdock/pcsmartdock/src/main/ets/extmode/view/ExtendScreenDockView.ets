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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CommonDockAppIconAreaView } from './CommonDockAppIconAreaView';
import { DockBackgroundView } from '../../default/layout/DockBackgroundView';
import { ToggleHomeForFixedDock } from '@ohos/togglehome';
import { SmartDockStyleConfig } from '@ohos/smartdock/src/main/ets/default/common/SmartDockStyleConfig';
import PcSmartDockViewModel from '../../default/viewmodel/SmartDockViewModel';
import { ExtendScreenDockViewData } from '../viewmodel/viewdata/ExtendScreenDockViewData';
import { CommonDockAppIconAreaViewData } from '../viewmodel/viewdata/CommonDockAppIconAreaViewData';
import { EsDockEventListener, EsDockEventManager } from '../viewmodel/event/EsDockEventManager';
import { ExtendScreenDockEvent } from '../viewmodel/event/ExtendScreenDockEvent';
import { DockItemInfo } from '@ohos/launchercommon';
import { ExtScreenModeDockViewModel } from '../viewmodel/ExtScreenModeDockViewModel';
import { curves } from '@kit.ArkUI';
import { DockArrowView } from './DockArrowView';
import { ArrowType } from '../../default/common/constants/FixedDockConstants';
import { SystemDockAreaView } from './SystemDockAreaView';
import { CommonDockAreaView } from './CommonDockAreaView';
import { SCBScreenProperty } from '@ohos/windowscene';
import { PcDockStyleConfig, PcSmartDockStyleManager } from '../../default/common/PcSmartDockStyleManager';

const TAG = 'ExtendScreenDockView';
const logger: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

/**
 * Dock栏组件-扩展屏Dock核心组件
 */
@Component
export struct ExtendScreenDockView {
  @Link screenProp: SCBScreenProperty;
  private mExtViewModel: ExtScreenModeDockViewModel = ExtScreenModeDockViewModel.getInstance();
  private isResidentMovingInAnim: boolean = false;
  private readonly dockChangeAnim: AnimateParam = {curve: curves.interpolatingSpring(0, 1, 528, 40)};
  private residentAreaViewData?: CommonDockAppIconAreaViewData;
  private mResidentScroller: Scroller = new Scroller();
  private mRecentScroller: Scroller = new Scroller();
  @Prop ratio: number = 1;
  @State dividerAnimateParam: AnimateParam = this.dockChangeAnim;
  @State dividerOffsetXAnim: number = 0;
  @State viewData: ExtendScreenDockViewData = new ExtendScreenDockViewData();
  @State enableScrollInteraction: boolean = true;
  @Link currColorMode: number;
  @Link itemColorMode: number;
  @Link isFullScreenLayout: boolean;

  private recentAppListChangeHandler: EsDockEventListener = (evt: ExtendScreenDockEvent): void => {
    logger.showInfo(`recentAppListChangeHandler-${evt.eventType}`);
    if (evt.eventType !== ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED) {
      return;
    }

    logger.showInfo('recentAppListChangeHandler');
    this.viewData.localRecentList = evt.eventParams as DockItemInfo[]
    this.refreshChildViewData();
    this.arrowVisibilityChangeCallback();
  };

  private residentAppListChangeHandler: EsDockEventListener = (evt: ExtendScreenDockEvent): void => {
    if (evt.eventType !== ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED) {
      return;
    }

    logger.showInfo('residentAppListChangeHandler');
    this.viewData.localResidentList = evt.eventParams as DockItemInfo[];
    this.refreshChildViewData();
    this.arrowVisibilityChangeCallback();
  };

  private systemAppListChangeHandler: EsDockEventListener = (evt: ExtendScreenDockEvent): void => {
    if (evt.eventType !== ExtendScreenDockEvent.EVENT_TYPE_SYSTEM_APPS_CHANGED) {
      return;
    }

    logger.showInfo('systemAppListChangeHandler');
    this.viewData.systemItemList = evt.eventParams as DockItemInfo[];
    this.refreshChildViewData();
    this.arrowVisibilityChangeCallback();
  };

  private arrowVisibilityChangeCallback = (): void => {
    this.viewData.isResidentArrowShow = this.mExtViewModel.getModelData().arrowModel?.isResidentArrowShow ?? false;
    this.viewData.isRecentArrowShow = this.mExtViewModel.getModelData().arrowModel?.isRecentArrowShow ?? false;
  };

  private widthChangeCallback = (): void => {
    this.viewData.residentListAreaWidth = this.mExtViewModel.getModelData().residentListAreaWidth;
  };

  public aboutToAppear(): void {
    logger.showInfo('Start');

    this.initViewData();

    // 注册列表事件监听
    EsDockEventManager.getInstance()
      .registerEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED,
        this.residentAppListChangeHandler);
    EsDockEventManager.getInstance()
      .registerEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED,
        this.recentAppListChangeHandler);

    EsDockEventManager.getInstance()
      .registerEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_SYSTEM_APPS_CHANGED,
        this.systemAppListChangeHandler);

    EsDockEventManager.getInstance().registerArrowChangeCallback(this.arrowVisibilityChangeCallback);
    EsDockEventManager.getInstance().registerWidthChangeCallback(this.widthChangeCallback);
  }

  public aboutToDisappear(): void {
    EsDockEventManager.getInstance()
      .unregisterEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED,
        this.residentAppListChangeHandler);
    EsDockEventManager.getInstance()
      .unregisterEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED,
        this.recentAppListChangeHandler);
    EsDockEventManager.getInstance()
      .unregisterEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_SYSTEM_APPS_CHANGED,
        this.systemAppListChangeHandler);
    EsDockEventManager.getInstance().unregisterArrowChangeCallback(this.arrowVisibilityChangeCallback);
    EsDockEventManager.getInstance().unregisterWidthChangeCallback(this.widthChangeCallback);
  }

  private initViewData(): void {
    logger.showInfo(` IVD-${this.mExtViewModel.getModelData().toString()} `);
    logger.showInfo(` IVD-${this.viewData.localResidentList.length}`);

    ExtScreenModeDockViewModel.getInstance().initScroller(this.mResidentScroller, this.mRecentScroller);

    this.refreshChildViewData();
    this.resizeWidthAfterAnimation();
  }

  private refreshChildViewData(): void {
    if (!this.residentAreaViewData) {
      this.residentAreaViewData = new CommonDockAppIconAreaViewData();
    }
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    this.residentAreaViewData.screenId = this.viewData.screenId;
    this.residentAreaViewData.systemItemList = this.viewData.systemItemList;
    this.residentAreaViewData.localResidentList = this.viewData.localResidentList;
    this.residentAreaViewData.localRecentList = this.viewData.localRecentList;
    this.residentAreaViewData.isResidentArrowShow = this.viewData.isResidentArrowShow;
    this.residentAreaViewData.residentListAreaWidth = this.viewData.residentListAreaWidth;
    this.residentAreaViewData.recentListAreaWidth = this.viewData.recentListAreaWidth;
    this.residentAreaViewData.dockHeight = config.mDockHeight;
    this.residentAreaViewData.dockListDirection = Axis.Horizontal;
    this.residentAreaViewData.baseResidentListWidth = this.mExtViewModel.getModelData().baseResidentListWidth;
    this.residentAreaViewData.baseRecentListWidth = this.mExtViewModel.getModelData().baseRecentListWidth;
    this.residentAreaViewData.residentMaxNum = this.mExtViewModel.getModelData().residentMaxNum;
    this.residentAreaViewData.recentMaxNum = this.mExtViewModel.getModelData().recentMaxNum;
    logger.showInfo(`RESIDENT-${this.residentAreaViewData.localResidentList.length},${this.residentAreaViewData.systemItemList.length},${this.residentAreaViewData.localRecentList.length}`);
  }

  private getHoverSpaceWidth(): number {
    let width = this.viewData.residentListAreaWidth;
    if (this.viewData.isResidentArrowShow) {
      width += 2 * PcSmartDockStyleManager.getStyle(this.screenProp).mRecentArrowWidth;
    }
    return width;
  }

  private resizeWidthAfterAnimation = (): void => {
    this.viewData.residentListAreaWidth = this.mExtViewModel.getModelData().residentListAreaWidth;
  };

  private listWidthChange = (isResident: boolean, additionWidth: number): void => {
    this.mExtViewModel.handleWidthChangeOnSingleAppHover(isResident, additionWidth);
    this.viewData.residentListAreaWidth = this.mExtViewModel.getModelData().residentListAreaWidth;
  };

  /**
   * 更新分割线动画参数
   */
  private updateDividerOffsetXAnim() {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    const itemWidth = (config.mListItemWidth + config.mListItemGap / 2);
    const leftGap = (this.viewData.isResidentArrowShow ? config.mRecentArrowGap : config.mListItemGap / 2);
    const rightGap = (this.viewData.isRecentArrowShow ? config.mRecentArrowGap : config.mListItemGap / 2);
    if (this.isResidentMovingInAnim) {
      this.dividerOffsetXAnim = itemWidth + (rightGap - leftGap - config.mResidentSplitLineWidth) / 2;
    } else {
      this.dividerOffsetXAnim = (itemWidth + rightGap - leftGap - config.mResidentSplitLineWidth) / 2;
    }
    logger.showInfo(`updateDividerOffsetXAnim: ${this.dividerOffsetXAnim}`);
  }

  build() {
    Stack({ alignContent: Alignment.Start }) {
      // Dock栏自定义背景
      DockBackgroundView({
        isFullScreenLayout: this.isFullScreenLayout,
        currColorMode: this.currColorMode
      })

      // 真正的Dock内容区域
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.Center,
        alignItems: ItemAlign.Center
      }) {
        Row() {
          SystemDockAreaView({
            screenProp: this.screenProp,
            ratio: this.ratio,
            listWidthChange: this.listWidthChange,
            viewData: this.residentAreaViewData,
            currColorMode: this.itemColorMode
          })

          if (this.viewData.isResidentArrowShow) {
            DockArrowView({
              screenProp: this.screenProp,
              arrowType: ArrowType.RESIDENT_LEFT,
              isResident: true,
              ratio: this.ratio,
              enableScrollInteraction: this.enableScrollInteraction,
              currColorMode: this.currColorMode
            })
          }

          CommonDockAreaView({
            screenProp: this.screenProp,
            isResident: true,
            ratio: this.ratio,
            listWidthChange: this.listWidthChange,
            viewData: this.residentAreaViewData,
            residentScroller: this.mResidentScroller,
            enableScrollInteraction: this.enableScrollInteraction,
            currColorMode: this.itemColorMode
          })
            .layoutWeight(1)

          // Dock图标区域-常驻区 - 右箭头
          if (this.viewData.isResidentArrowShow) {
            DockArrowView({
              screenProp: this.screenProp,
              arrowType: ArrowType.RESIDENT_RIGHT,
              isResident: true,
              ratio: this.ratio,
              enableScrollInteraction: this.enableScrollInteraction,
              currColorMode: this.currColorMode
            })
          }
        }
        .width(this.getHoverSpaceWidth())
        .onHover((isHover: boolean) => {
          this.mExtViewModel.handleDockAppListHover(isHover, this.resizeWidthAfterAnimation);
        })
      }
      .padding({
        left: PcSmartDockStyleManager.getStyle(this.screenProp).mListItemGap,
        right: PcSmartDockStyleManager.getStyle(this.screenProp).mListItemGap
      })
      .size({ width: '100%', height: '100%' })

      // 一键回桌面UI
      Row() {
        ToggleHomeForFixedDock({
          toggleHomeWidth: PcSmartDockStyleManager.getStyle(this.screenProp).mToggleHomeWidth,
        })
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
      .height('100%')
      .hitTestBehavior(HitTestMode.Transparent)
      .visibility(Visibility.Hidden)
    }
    .width('100%')
    .height('100%')
  }
}