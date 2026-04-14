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

import { SCBSceneSessionManager, SCBScreenProperty } from '@ohos/windowscene';
import { AppIconCommonView } from '@ohos/launchercommon/Index';
import { DockType, GestureDockConstants, GestureDockMode } from '../common/GestureDockConstants';
import { GestureDockItemInfo } from '../dockbar/model/GestureDockItemInfo';
import { GestureDockViewParam } from '../dock/viewmodel/viewdata/GestureDockParam';
import { LengthMetrics } from '@kit.ArkUI';
import GestureDockAppItemViewDataMgr from './viewmodel/viewdata/GestureDockAppItemViewDataMgr';
import GestureDockAppItemViewEventMgr from './viewmodel/viewevent/GestureDockAppItemViewEventMgr';
import { DockAppItemParam } from './viewmodel/viewdata/GestureDockAppItemParam';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'GestureDockAppItemView';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * 侧边栏图标
 */
@Component
export struct GestureDockAppItemView {
  @Link screenProperty: SCBScreenProperty;
  @ObjectLink gestureDockItemInfo: GestureDockItemInfo;
  private viewDataMgr = new GestureDockAppItemViewDataMgr();
  private viewEventMgr: GestureDockAppItemViewEventMgr = new GestureDockAppItemViewEventMgr(this.viewDataMgr);
  @State appItemParam: DockAppItemParam = this.viewDataMgr.appItemParam;
  @State iconSize: number = GestureDockConstants.GESTURE_DOCK_ICON_SIZE;
  @Link gestureDockParam: GestureDockViewParam;
  itemOnClick: Function = (event: ClickEvent, item: GestureDockItemInfo, dockType: number) => {
  };
  private dockDirection: number = 0;
  private dockType: number = DockType.RESIDENT;

  aboutToAppear(): void {
    // 参数初始化
    this.viewDataMgr.screenProperty = this.screenProperty;
    this.viewDataMgr.gestureDockItemInfo = this.gestureDockItemInfo;
    this.viewDataMgr.gestureDockParam = this.gestureDockParam;
    this.viewDataMgr.dockDirection = this.dockDirection;
    this.viewDataMgr.dockType = this.dockType;
    this.viewDataMgr.itemOnClick = this.itemOnClick;
    // 调用初始化函数
    this.viewEventMgr.aboutToAppear();
  }

  aboutToDisappear(): void {
    this.viewEventMgr.aboutToDisappear();
  }

  aboutToReuse(param: Record<string, object>) {
    this.gestureDockItemInfo = param.appInfo as GestureDockItemInfo;
  }

  aboutToRecycle() {
    this.gestureDockItemInfo = new GestureDockItemInfo();
  }

  @Styles
  deleteImageStyle() {
    .width(GestureDockConstants.GESTURE_DOCK_EDIT_ICON)
    .height(GestureDockConstants.GESTURE_DOCK_EDIT_ICON)
    .draggable(false)
  }

  build() {
    ListItem() {
      Stack() {
        if (this.gestureDockParam.gestureDockShowMode === GestureDockMode.EDIT && this.dockType === DockType.RESIDENT) {
          Stack() {
            Image($r('app.media.gesture_dock_item_delete'))
              .deleteImageStyle()
          }
          .id(`${TAG}_${this.gestureDockItemInfo.bundleName + this.gestureDockItemInfo.moduleName +
          this.gestureDockItemInfo.abilityName}`)
          .focusBox({
            strokeWidth: new LengthMetrics(1),
            margin: LengthMetrics.vp(-1),
          })
          .onClick((event?: ClickEvent) => {
            this.viewEventMgr.deleteImageClick();
          })
          .zIndex(3)
          .opacity(this.appItemParam.badgeOpacity)
        }
        AppIconCommonView({
          item: this.gestureDockItemInfo,
          appIconConfig: this.viewDataMgr.appIconConfig,
          iconEvent: this.viewDataMgr.iconEvent,
          iconSize: this.iconSize,
          iconRadius: GestureDockConstants.GESTURE_DOCK_ICON_RADIUS
        }).offset({
          top: LengthMetrics.vp(GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2),
          end: LengthMetrics.vp(GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE / 2)
        })
          .id(this.viewDataMgr.getItemId())
          .zIndex(2)
      }
      // 非自由多窗,置灰应用不允许有手势事件响应
      .hitTestBehavior((!SCBSceneSessionManager.getInstance().isPcMode() && this.appItemParam.iconOpacity !== 1) ?
        HitTestMode.Block : HitTestMode.Default)
      .opacity(this.appItemParam.iconOpacity)
      .alignContent(Alignment.TopEnd)
      .width(GestureDockConstants.GESTURE_DOCK_ICON_SIZE + GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE)
      .height(GestureDockConstants.GESTURE_DOCK_ICON_SIZE + GestureDockConstants.GESTURE_DOCK_ITEM_DISTANCE)
      .transition(this.gestureDockParam.gestureDockShowMode === GestureDockMode.EDIT ?
        TransitionEffect.scale({
          x: GestureDockConstants.GESTURE_DOCK_SCALE,
          y: GestureDockConstants.GESTURE_DOCK_SCALE
        })
          .animation({ curve: Curve.Friction, duration: GestureDockConstants.GESTURE_DOCK_SCALE_ANIMATE_TIME })
          .combine(
            TransitionEffect.OPACITY.animation({
              curve: Curve.Sharp,
              duration: GestureDockConstants.GESTURE_DOCK_OPACITY_ANIMATE_TIME
            })
          ) : TransitionEffect.IDENTITY
      )
    }
    .focusBox({
      margin: LengthMetrics.vp(0),
    })
    .zIndex(1)
    .backgroundColor(this.viewDataMgr.mSmartDockStyleConfig.mItemBackgroundColor)
    .borderRadius(GestureDockConstants.GESTURE_DOCK_ICON_RADIUS)
    .translate({ x: this.appItemParam.translateX, y: this.appItemParam.translateY })
    .scale({ x: this.appItemParam.scaleSize, y: this.appItemParam.scaleSize })
    .opacity(this.appItemParam.alpha)
    .transition(TransitionEffect.IDENTITY)
    .visibility(this.appItemParam.visible)
  }
}