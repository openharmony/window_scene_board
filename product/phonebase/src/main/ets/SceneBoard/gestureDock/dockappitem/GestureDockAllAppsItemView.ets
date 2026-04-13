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

import { GestureDockItemInfo } from '../dockbar/model/GestureDockItemInfo';
import { GestureDockConstants, GestureDockMode } from '../common/GestureDockConstants';
import { AppIconCommonView } from '@ohos/launchercommon/Index';
import { LengthMetrics } from '@kit.ArkUI';
import { GestureDockAllAppsIcon } from '../dockallapps/GestureDockAllAppsView';
import { AllAppsParam } from '../dockallapps/viewmodel/viewdata/GestureDockAllAppsParam';
import GestureDockAllAppsItemViewDataMgr from './viewmodel/viewdata/GestureDockAllAppsItemViewDataMgr';
import GestureDockAllAppsItemViewEventMgr from './viewmodel/viewevent/GestureDockAllAppsItemViewEventMgr';
import { DockAllAppsItemParam } from './viewmodel/viewdata/GestureDockAllAppsItemParam';
import { AllAppsConstants } from '../dockallapps/model/AllAppsConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'GestureDockAllAppsItemView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * allApps图标
 */
@Reusable
@Component
export struct GestureDockAllAppsItemView {
  private item: GestureDockItemInfo = new GestureDockItemInfo();
  @Consume isUseRenderGroup: boolean;
  @Link allAppsParam: AllAppsParam;
  private gestureDockAllAppsIcon: number = GestureDockAllAppsIcon.FLOAT_APPS;
  private gestureDockDirection: number = 0;
  private dockAddAppSource: number = 0;
  itemOnClick?: Function;
  private viewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
  private viewEventMgr: GestureDockAllAppsItemViewEventMgr = new GestureDockAllAppsItemViewEventMgr(this.viewDataMgr);
  @State appItemParam: DockAllAppsItemParam = new DockAllAppsItemParam();
  @State iconSize: number = AllAppsConstants.ALL_APPS_APP_SIZE;

  aboutToAppear(): void {
    this.viewDataMgr.item = this.item;
    this.viewDataMgr.gestureDockAllAppsIcon = this.gestureDockAllAppsIcon;
    this.viewDataMgr.gestureDockDirection = this.gestureDockDirection;
    this.viewDataMgr.dockAddAppSource = this.dockAddAppSource;
    this.viewDataMgr.allAppsParam = this.allAppsParam;
    this.viewDataMgr.allAppsStyleConfig = this.allAppsParam.allAppsStyleConfig;
    this.viewDataMgr.itemOnClick = this.itemOnClick;
    this.iconSize = this.allAppsParam.allAppsStyleConfig.iconSize;
    this.appItemParam = this.viewDataMgr.appItemParam;
    this.viewEventMgr.aboutToAppear();
  }

  aboutToDisappear(): void {
    this.viewEventMgr.aboutToDisappear();
  }

  aboutToReuse(params: Record<string, Object>): void {
    this.item = params.item as GestureDockItemInfo;
    this.aboutToAppear();
    this.viewDataMgr.itemOnClick = params.itemOnClick as Function;
  }

  aboutToRecycle(): void {
    this.aboutToDisappear();
  }

  build() {
    Column() {
      Stack() {
        RelativeContainer() {
          AppIconCommonView({
            item: this.item,
            appIconConfig: this.viewDataMgr.appIconConfig,
            iconEvent: this.viewDataMgr.iconEvent,
            iconSize: this.iconSize,
            appNameVm: this.viewDataMgr.appNameVm,
            nameFontColor: AllAppsConstants.ALL_APPS_APP_NAME_COLOR,
            iconRadius: this.viewDataMgr.allAppsStyleConfig?.iconRadius
          })
        }
        .zIndex(1)
        .focusable(this.allAppsParam.gestureDockShowMode === GestureDockMode.EDIT ? false : true)

        if (this.allAppsParam.gestureDockShowMode === GestureDockMode.EDIT && this.appItemParam.isShowBadge) {
          Image($r('app.media.gesture_dock_item_add'))
            .symbolStyle()
        }
      }
      .hitTestBehavior(this.viewEventMgr.viewDataMgr.getHitTestBehavior())
      .id(this.viewDataMgr.getItemId())
      .opacity(this.appItemParam.iconOpacity)
      .alignContent(Alignment.TopEnd)
    }
    .renderGroup(this.isUseRenderGroup)
    .width(this.viewDataMgr.allAppsStyleConfig?.itemWidth)
    .height(this.viewDataMgr.allAppsStyleConfig?.itemHeight)
    // 防止编辑图标被裁剪
    .padding(GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS / 2)
    .focusBox({
      margin: LengthMetrics.vp(0),
    })
    .clip(false)
  }

  @Styles
  symbolStyle() {
    .width(GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS)
    .height(GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS)
    .align(Alignment.TopEnd)
    .draggable(false)
    .offset({
      start: LengthMetrics.vp(GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2),
      top: LengthMetrics.vp(-GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2)
    })
    .onClick((event?: ClickEvent) => this.viewEventMgr.onAllAppsItemClick(event))
    .zIndex(2)
    .focusBox({
      margin: LengthMetrics.vp(1),
    })
  }
}