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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
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

const TAG = 'SystemDockAreaView';
const logger: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

/**
 * Dock栏组件-系统入口区
 */
@Component
export struct SystemDockAreaView {
  @Link screenProp: SCBScreenProperty;
  @Prop ratio: number = 1;
  private listWidthChange = () => {};
  private mViewModel: PcSmartDockViewModel = PcSmartDockViewModel.getInstance();
  private viewData: CommonDockAppIconAreaViewData = new CommonDockAppIconAreaViewData();
  @StorageLink('enableRenderGroupInExt') enableRenderGroupInExt: boolean = true;
  @State systemItemList: DockItemInfo[] = [];
  @State enableScrollInteraction: boolean = false;
  private onEsDockEvent = (event: ExtendScreenDockEvent): void => {
    logger.showInfo(`onEsDockEvent-system`);
    if (event.eventType === ExtendScreenDockEvent.EVENT_TYPE_SYSTEM_APPS_CHANGED) {
      logger.showInfo(`onEsDockEvent-system-${(event.eventParams as DockItemInfo[]).length}`);
      this.viewData.systemItemList = event.eventParams as DockItemInfo[];
      this.systemItemList = [...this.viewData.systemItemList];
      return;
    }
  };

  @Link currColorMode: number;

  public aboutToAppear(): void {
    this.initEventListener();

    this.initViewData();
  }

  public aboutToDisappear(): void {
    logger.showInfo(`aboutToDisappear`);
    EsDockEventManager.getInstance()
      .unregisterEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_SYSTEM_APPS_CHANGED,
        this.onEsDockEvent);
  }

  private initViewData(): void {
    logger.showInfo(`CD3-${this.viewData.dockHeight}`);
    logger.showInfo(`CD4-${this.viewData.systemItemList.length}`);
    logger.showInfo(`CD6-${this.viewData.screenId}`);
    this.systemItemList = [...this.viewData.systemItemList];
  }

  private initEventListener(): void {
    EsDockEventManager.getInstance()
      .registerEsDockEventListener(ExtendScreenDockEvent.EVENT_TYPE_SYSTEM_APPS_CHANGED,
        this.onEsDockEvent);
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
    List() {
      ForEach(this.systemItemList, (item: DockItemInfo) => {
          ListItem() {
            AppItem({
              screenProp: this.screenProp,
              screenId: this.viewData.screenId,
              ratio: this.ratio,
              appInfo: item as DockItemInfo,
              dockType: SmartDockConstants.RESIDENT_DOCK_TYPE,
              systemFlag: true,
              residentFlag: true,
              wpsPreExitFunc: undefined,
              listWidthChange: this.listWidthChange,
              currColorMode: this.currColorMode,
              enableScrollInteraction: this.enableScrollInteraction,
              updateAppItem: (appInfo:DockItemInfo): DockItemInfo => {
                this.viewData.systemItemList.forEach((item) => {
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
    .id(FixedDockResource.DOCK_SYSTEM_AREA_ID)
    .listDirection(this.viewData.dockListDirection)
    .height(PcSmartDockStyleManager.getStyle(this.screenProp).mDockHeight)
    .renderGroup(this.enableRenderGroupInExt)
    .scrollSnapAlign(ScrollSnapAlign.START)
    .enableScrollInteraction(false)
    .edgeEffect(EdgeEffect.None)
    .scrollBar(BarState.Off)
  }
}