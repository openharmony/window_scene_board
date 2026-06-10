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
  LogDomain,
  LogHelper,
  CheckEmptyUtils
} from '@ohos/basicutils';
import { DockItemInfo, SmartDockStyleConfig } from '@ohos/launchercommon';
import { FixedDockResource } from '../../default/common/constants/FixedDockConstants';
import AppItem from '../../default/layout/AppItem';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import { CommonDockAppIconAreaViewData } from '../viewmodel/viewdata/CommonDockAppIconAreaViewData';
import PcSmartDockViewModel from '../../default/viewmodel/SmartDockViewModel';
import { EsDockEventManager } from '../viewmodel/event/EsDockEventManager';
import { ExtendScreenDockEvent } from '../viewmodel/event/ExtendScreenDockEvent';
import { ExtScreenModeDockViewModel } from '../viewmodel/ExtScreenModeDockViewModel';
import { curves } from '@kit.ArkUI';
import { SCBScreenProperty } from '@ohos/windowscene';
import { PcDockStyleConfig, PcSmartDockStyleManager } from '../../default/common/PcSmartDockStyleManager';

const TAG = 'CommonDockAreaView';
const logger: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

/**
 * Dock栏组件-常驻区
 */
@Component
export struct CommonDockAreaView {
  @Link screenProp: SCBScreenProperty;
  @Prop ratio: number = 1;
  private isResident: boolean = true;
  private residentScroller?: Scroller;
  private mViewModel: PcSmartDockViewModel = PcSmartDockViewModel.getInstance();
  @State viewData: CommonDockAppIconAreaViewData = new CommonDockAppIconAreaViewData();
  @StorageLink('enableRenderGroupInExt') enableRenderGroupInExt: boolean = true;
  private recentScrollCount: number = 0;
  private residentScrollCount: number = 0;
  private listWidthChange = () => {};
  private mExtViewModel: ExtScreenModeDockViewModel = ExtScreenModeDockViewModel.getInstance();
  private readonly dockChangeAnim: AnimateParam = {curve: curves.interpolatingSpring(0, 1, 528, 40)};
  @State dividerAnimateParam: AnimateParam = this.dockChangeAnim;
  @Link enableScrollInteraction: boolean;
  private onEsDockEvent = (event: ExtendScreenDockEvent): void => {
    logger.showInfo(`onEsDockEvent-common`);
    if (event.eventType === ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED) {
      logger.showInfo(`onEsDockEvent-resident-${(event.eventParams as DockItemInfo[]).length}`);
      this.viewData.localResidentList = event.eventParams as DockItemInfo[];
      this.viewData.residentListAreaWidth = this.mExtViewModel.getModelData().residentListAreaWidth;
      this.viewData.isResidentArrowShow = this.mExtViewModel.getModelData().arrowModel?.isResidentArrowShow ?? false;
      return;
    }
    if (event.eventType === ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED) {
      logger.showInfo(`onEsDockEvent-recent-${(event.eventParams as DockItemInfo[]).length}`);
      this.viewData.localRecentList = event.eventParams as DockItemInfo[];
      this.viewData.residentListAreaWidth = this.mExtViewModel.getModelData().residentListAreaWidth;
      this.viewData.isResidentArrowShow = this.mExtViewModel.getModelData().arrowModel?.isResidentArrowShow ?? false;
      logger.showInfo(`2onEsDockEvent-${this.viewData.localRecentList.length}-${this.viewData.recentListAreaWidth}`);
      logger.showInfo(`3onEsDockEvent-${this.viewData.toString()}`);
    }
  };

  @Link currColorMode: number;

  public aboutToAppear(): void {
    this.initEventListener();

    this.initViewData();
  }

  public aboutToDisappear(): void {
    EsDockEventManager.getInstance()
      .unregisterEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED,
        this.onEsDockEvent);
    EsDockEventManager.getInstance()
      .unregisterEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED,
        this.onEsDockEvent);
  }

  private initViewData(): void {
    logger.showInfo(`CD1-${this.viewData.residentListAreaWidth}`);
    logger.showInfo(`CD3-${this.viewData.dockHeight}`);
    logger.showInfo(`CD4-${this.viewData.localResidentList.length}`);
    logger.showInfo(`CD4-${this.viewData.localRecentList.length}`);
    logger.showInfo(`CD4-${this.viewData.isResidentArrowShow}`);
    logger.showInfo(`CD6-${this.viewData.screenId}`);
  }

  private initEventListener(): void {
    EsDockEventManager.getInstance()
      .registerEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED,
        this.onEsDockEvent);
    EsDockEventManager.getInstance()
      .registerEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED,
        this.onEsDockEvent);
  }

  private isDividerShow(): boolean {
    if (this.viewData.isResidentArrowShow) {
      return !CheckEmptyUtils.isEmptyArr(this.viewData.localResidentList) &&
        (!CheckEmptyUtils.isEmptyArr(this.viewData.localRecentList));
    } else {
      return (!CheckEmptyUtils.isEmptyArr(this.viewData.localRecentList));
    }
  }

  private getItemForeachKey(item: DockItemInfo): string {
    let config: PcDockStyleConfig = PcSmartDockStyleManager.getStyle(this.screenProp);
    let keyName = item.bundleName + item.appIndex + item.abilityName +
    item.appId + config?.mIconSize;
    if (!CheckEmptyUtils.isEmpty(item?.shortcutId)) {
      keyName = keyName + item?.shortcutId
    }

    // 应用多开,增加key值，避免被刷新
    if (!CheckEmptyUtils.checkStrIsEmpty(item?.appInstanceKey)) {
      keyName = keyName + item.appInstanceKey;
    }
    if (!CheckEmptyUtils.isEmpty(item?.persistentId)) {
      keyName = keyName + item?.persistentId;
    }
    return keyName;
  }

  @Builder
  dockDividerBuilder() {
    Divider()
      .align(Alignment.Center)
      .vertical(true)
      .strokeWidth(PcSmartDockStyleManager.getStyle(this.screenProp).mResidentSplitLineWidth)
      .height((!this.viewData.isResidentArrowShow ? 20 : 28) * this.ratio)
      .color(this.isDarkMode() ? '#33FFFFFF' : '#33000000')
      .margin({
        left: (!this.viewData.isResidentArrowShow ?
          PcSmartDockStyleManager.getStyle(this.screenProp).mListItemGap / 2 : 0),
        right: (!this.viewData.isResidentArrowShow ?
          PcSmartDockStyleManager.getStyle(this.screenProp).mListItemGap / 2 : 0)
      })
      .lineCap(LineCapStyle.Round)
      .transition(
        TransitionEffect.asymmetric(
          TransitionEffect.scale({ x: 0, y: 0 })
            .animation(this.dividerAnimateParam)
            .combine(TransitionEffect.OPACITY),
          TransitionEffect
            .scale({ x: 0, y: 0 })
            .animation(this.dividerAnimateParam)
            .combine(TransitionEffect.OPACITY)
        ))
  }

  private isDarkMode(): boolean {
    return this.currColorMode === 0;
  }

  build() {
    List({ scroller: this.residentScroller}) {
      ForEach(this.viewData.localResidentList, (item: DockItemInfo) => {
          ListItem() {
            AppItem({
              screenProp: this.screenProp,
              screenId: this.viewData.screenId,
              ratio: this.ratio,
              appInfo: item as DockItemInfo,
              dockType: SmartDockConstants.RESIDENT_DOCK_TYPE,
              residentFlag: true,
              wpsPreExitFunc: undefined,
              listWidthChange: this.listWidthChange,
              currColorMode: this.currColorMode,
              enableScrollInteraction: this.enableScrollInteraction,
              updateAppItem: (appInfo:DockItemInfo): DockItemInfo => {
                this.viewData.localResidentList.forEach((item) => {
                  if (appInfo.bundleName === item.bundleName) {
                    appInfo = item;
                  }
                })
                return appInfo;
              }
            })
              .id(`${this.mViewModel.getIdPrefix(true)}_AppItem_${this.viewData.screenId}_${item?.keyName}`)
          }
          .transition(TransitionEffect.asymmetric(
            TransitionEffect.scale({ x: 0.25, y: 0.25 })
              .combine(TransitionEffect.translate(
                { x: -0.5 * (PcSmartDockStyleManager.getStyle(this.screenProp).mListItemWidth) }))
              .combine(TransitionEffect.opacity(0.0))
              .animation({ curve: curves.interpolatingSpring(0, 1, 528, 40), delay: 0 }),
            TransitionEffect.scale({ x: 0.25, y: 0.25 })
              .combine(TransitionEffect.translate({ x: -0.5 * (PcSmartDockStyleManager
                .getStyle(this.screenProp).mListItemWidth) }))
              .combine(TransitionEffect.opacity(0.0))
              .animation({ duration: 100, curve: Curve.FastOutLinearIn })
          ))
        }, (item: DockItemInfo) => this.getItemForeachKey(item))

      if (this.isDividerShow()) {
        ListItem() {
          this.dockDividerBuilder()
        }
      }

      ForEach(this.viewData.localRecentList, (item: DockItemInfo) => {
          ListItem() {
            AppItem({
              screenProp: this.screenProp,
              screenId: this.viewData.screenId,
              ratio: this.ratio,
              appInfo: item as DockItemInfo,
              dockType: SmartDockConstants.RECENT_DOCK_TYPE,
              residentFlag: false,
              wpsPreExitFunc: undefined,
              listWidthChange: this.listWidthChange,
              currColorMode: this.currColorMode,
              enableScrollInteraction: this.enableScrollInteraction,
              updateAppItem: (appInfo:DockItemInfo): DockItemInfo => {
                this.viewData.localResidentList.forEach((item) => {
                  if (appInfo.bundleName === item.bundleName) {
                    appInfo = item;
                  }
                })
                return appInfo;
              }
            })
              .id(`${this.mViewModel.getIdPrefix(false)}_AppItem_${this.viewData.screenId}_${item?.keyName}`)
          }
          .transition(TransitionEffect.asymmetric(
            TransitionEffect.scale({ x: 0.25, y: 0.25 })
              .combine(TransitionEffect.translate({ x: -0.5 * (PcSmartDockStyleManager
                .getStyle(this.screenProp).mListItemWidth) }))
              .combine(TransitionEffect.opacity(0.0))
              .animation({ curve: curves.interpolatingSpring(0, 1, 528, 40), delay: 50 }),
            TransitionEffect.scale({ x: 0.25, y: 0.25 })
              .combine(TransitionEffect.translate({ x: -0.5 * (PcSmartDockStyleManager
                .getStyle(this.screenProp).mListItemWidth) }))
              .combine(TransitionEffect.opacity(0.0))
              .animation({ duration: 100, curve: Curve.FastOutLinearIn })
          ))
        }, (item: DockItemInfo) => this.getItemForeachKey(item))
    }
    .alignListItem(ListItemAlign.Center)
    .id(FixedDockResource.DOCK_COMMON_AREA_ID)
    .listDirection(this.viewData.dockListDirection)
    .height('100%')
    .renderGroup(this.enableRenderGroupInExt)
    .scrollSnapAlign(ScrollSnapAlign.START)
    .enableScrollInteraction(this.enableScrollInteraction)
    .edgeEffect(EdgeEffect.None)
    .scrollBar(BarState.Off)
    .onReachStart(() => {
      logger.showDebug(`Ext onReachStart ${this.isResident}`);
      this.mExtViewModel.handleDockListReachStart(this.isResident);
    })
    .onReachEnd(() => {
      logger.showDebug(`Ext onReachEnd ${this.isResident}`);
      this.mExtViewModel.handleDockListReachEnd(this.isResident);
    })
    .onDidScroll(() => {
      this.mExtViewModel.updateResidentArrowState(0);
    })
    .onScrollStart(() => {
      logger.showDebug(`Ext onScrollStart ${this.isResident}`);
      this.mExtViewModel.handleDockListScrollStart();
      ContextMenu.close();
    })
    .onScrollStop(() => {
      logger.showDebug(`Ext onScrollStop ${this.isResident}`);
      this.mExtViewModel.handleDockListScrollEnd(this.isResident);
    })
  }
}