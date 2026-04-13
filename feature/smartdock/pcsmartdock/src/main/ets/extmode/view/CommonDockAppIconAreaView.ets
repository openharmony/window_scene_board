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
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  SingleContext
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
import { SCBScreenProperty } from '@ohos/windowscene';
import { PcDockStyleConfig, PcSmartDockStyleManager } from '../../default/common/PcSmartDockStyleManager';

const TAG = 'CommonDockAppIconAreaView';
const logger: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

/**
 * Dock栏组件-常驻区
 */
@Component
export struct CommonDockAppIconAreaView {
  @Link screenProp: SCBScreenProperty;
  @Prop ratio: number = 1;
  @Prop singleContext?: SingleContext;
  private isResident: boolean = true;
  private residentScroller?: Scroller;
  private recentScroller?: Scroller;
  private mViewModel: PcSmartDockViewModel = PcSmartDockViewModel.getInstance();
  @State viewData: CommonDockAppIconAreaViewData = new CommonDockAppIconAreaViewData();
  @State enableScrollInteraction: boolean = false;
  @Link currColorMode: number;
  @StorageLink('enableRenderGroupInExt') enableRenderGroupInExt: boolean = true;
  private recentScrollCount: number = 0;
  private residentScrollCount: number = 0;
  private mExtViewModel: ExtScreenModeDockViewModel = ExtScreenModeDockViewModel.getInstance();
  private onEsDockEvent = (event: ExtendScreenDockEvent): void => {
    logger.showInfo(`onEsDockEvent-${this.isResident}`);
    if (this.isResident && event.eventType === ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED) {
      logger.showInfo(`onEsDockEvent-resident-${(event.eventParams as DockItemInfo[]).length}`);
      this.viewData.localResidentList = event.eventParams;
      this.viewData.residentListAreaWidth = this.mExtViewModel.getModelData().residentListAreaWidth;
      return;
    }

    if (event.eventType === ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED) {
      logger.showInfo(`onEsDockEvent-recent-${(event.eventParams as DockItemInfo[]).length}`);
      this.viewData.localRecentList = event.eventParams;
      this.viewData.recentListAreaWidth = this.mExtViewModel.getModelData().recentListAreaWidth;
      this.viewData.residentListAreaWidth = this.mExtViewModel.getModelData().residentListAreaWidth;
      logger.showInfo(`2onEsDockEvent-${this.viewData.localRecentList.length}-${this.viewData.recentListAreaWidth}`);
      logger.showInfo(`3onEsDockEvent-${this.viewData.toString()}`);
    }
  };
  private listWidthChange = (isResident: boolean, additionWidth: number): void => {
    this.mExtViewModel.handleWidthChangeOnSingleAppHover(isResident, additionWidth);

    if (isResident) {
      this.viewData.additionResidentListWidth = this.mExtViewModel.getModelData().additionResidentListWidth;
      this.viewData.residentListAreaWidth = this.mExtViewModel.getModelData().residentListAreaWidth;
    } else {
      this.viewData.additionRecentListWidth = this.mExtViewModel.getModelData().additionRecentListWidth;
      this.viewData.recentListAreaWidth = this.mExtViewModel.getModelData().recentListAreaWidth;
    }

    logger.showInfo(`listWidthChange,isResident：${isResident}, ${additionWidth},` +
      `${this.viewData.residentListAreaWidth},${this.viewData.recentListAreaWidth},`);
  };

  public aboutToAppear(): void {
    this.initEventListener();

    this.initViewData();
  }

  public aboutToDisappear(): void {
    EsDockEventManager.getInstance()
      .unregisterEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED, this.onEsDockEvent);
    EsDockEventManager.getInstance()
      .unregisterEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED, this.onEsDockEvent);
  }

  private initViewData(): void {
    logger.showInfo(`CD1-${this.viewData.residentListAreaWidth}`);
    logger.showInfo(`CD2-${this.viewData.recentListAreaWidth}`);
    logger.showInfo(`CD3-${this.viewData.dockHeight}`);
    logger.showInfo(`CD4-${this.viewData.localResidentList.length}`);
    logger.showInfo(`CD5-${this.viewData.localRecentList.length}`);
    logger.showInfo(`CD6-${this.viewData.screenId}`);
  }

  private initEventListener(): void {
    EsDockEventManager.getInstance()
      .registerEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RESIDENT_APPS_CHANGED, this.onEsDockEvent);

    EsDockEventManager.getInstance()
      .registerEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_RECENT_APPS_CHANGED, this.onEsDockEvent);
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

  build() {
    List({ scroller: this.isResident ? this.residentScroller : this.recentScroller }) {
      ForEach(this.isResident ? this.viewData.localResidentList : this.viewData.localRecentList,
        (item: DockItemInfo) => {
          ListItem() {
            AppItem({
              screenProp: this.screenProp,
              singleContext: this.singleContext,
              screenId: this.viewData.screenId,
              ratio: this.ratio,
              appInfo: item as DockItemInfo,
              dockType: this.isResident ? SmartDockConstants.RESIDENT_DOCK_TYPE : SmartDockConstants.RECENT_DOCK_TYPE,
              residentFlag: this.isResident,
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
              .id(`${this.mViewModel.getIdPrefix(this.isResident)}_AppItem_${this.viewData.screenId}_${item?.keyName}`)
          }
          .transition(TransitionEffect.asymmetric(
            TransitionEffect.scale({ x: 0.2, y: 0.2 })
              .combine(TransitionEffect.translate({
                x: -0.5 * (this.viewData.dockListItemWidth + this.viewData.dockListItemGap * 1.5)
              }))
              .combine(TransitionEffect.opacity(0.0))
              .combine(TransitionEffect.scale({ x: 1.0, y: 1.0 }))
              .combine(TransitionEffect.opacity(1.0)),
            TransitionEffect.scale({ x: 0.2, y: 0.2 })
              .combine(TransitionEffect.translate({
                x: -0.5 * (this.viewData.dockListItemWidth + this.viewData.dockListItemGap)
              }))
              .combine(TransitionEffect.opacity(0.0))
          ))
        }, (item: DockItemInfo) => this.getItemForeachKey(item))
    }
    .alignListItem(ListItemAlign.Center)
    .id(this.isResident ? FixedDockResource.DOCK_RESIDENT_AREA_ID : FixedDockResource.DOCK_RECENT_AREA_ID)
    .listDirection(this.viewData.dockListDirection)
    .height(this.viewData.dockHeight)
    .renderGroup(this.enableRenderGroupInExt && this.isResident)
    .scrollSnapAlign(ScrollSnapAlign.START)
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
      this.isResident ? this.mExtViewModel.updateResidentArrowState(0) : this.mExtViewModel.updateRecentArrowState(0);
    })
    .onScrollStart(() => {
      logger.showDebug(`Ext onScrollStart ${this.isResident}`);
      this.isResident ? (this.residentScrollCount++) : (this.recentScrollCount++);
    })
    .onScrollStop(() => {
      logger.showDebug(`Ext onScrollStop ${this.isResident}`);

      this.mExtViewModel.handleDockListScrollEnd(this.isResident);
    })
  }
}