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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenProperty } from '@ohos/windowscene';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { GestureDockConstants } from './common/GestureDockConstants';
import { GestureDockBarView } from './dockbar/GestureDockBarView';
import GestureDockViewDataMgr from './dock/viewmodel/viewdata/GestureDockViewDataMgr';
import { GestureDockViewModel } from './dock/viewmodel/GestureDockViewModel';
import { GestureDockViewParam } from './dock/viewmodel/viewdata/GestureDockParam';
import { GestureDockAllAppsView } from './dockallapps/GestureDockAllAppsView';
import GestureDockViewEventMgr, { GestureDockState } from './dock/viewmodel/viewevent/GestureDockViewEventMgr';

const TAG = 'SCBGestureDock';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

export enum GestureDockApps {
  RECENT_APPS = 0,
  DOCK_APPS = 1,
}

@Component
export struct SCBGestureDock {
  private persistentId: number = 0;
  private viewDataMgr: GestureDockViewDataMgr = new GestureDockViewDataMgr();
  private viewEventMgr: GestureDockViewEventMgr = new GestureDockViewEventMgr(this.viewDataMgr);

  @State gestureDockParam: GestureDockViewParam = this.viewDataMgr.gestureDockParam;
  @Link screenProperty: SCBScreenProperty;

  aboutToAppear(): void {
    log.showInfo(`[${TAG}] about to appear,persistentId is ${this.persistentId}`);
    GestureDockViewModel.getInstance().initViewModel(this.viewEventMgr);
    this.viewEventMgr.aboutToAppear(this.screenProperty, this.persistentId);
  }

  aboutToDisappear(): void {
    log.showInfo(`[${TAG}] about to disappear`);
    this.viewEventMgr.aboutToDisappear();
    GestureDockViewModel.getInstance().clearViewModel();
  }

  build() {
    Stack() {
      this.blankStackBuilder()

      if (this.isShowAllApps()) {
        this.AllAppsBuilder();
      }

      GestureDockBarView({
        gestureDockParam: this.gestureDockParam,
        screenProperty: this.screenProperty,
      })

      if (this.isShowAllApps()) {
        this.dividerBuilder();
      }
    }
    .width('100%')
    .height('100%')
    .dragStyle()
  }

  private isShowAllApps(): boolean {
    return this.gestureDockParam.isShowAllApps &&
      (this.gestureDockParam.gestureDockDirection !== GestureDockState.GESTURE_DOCK_IN ||
      this.gestureDockParam.isDisappearing);
  }

  @Builder
  blankStackBuilder() {
    Stack() {
    }
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
    .onClick(() => {
      this.viewEventMgr.onBlankAreaClick();
    })
    .onTouch((event: TouchEvent) => {
      this.viewEventMgr.onBlankAreaTouch(event);
    })
    .focusable(false)
  }

  @Builder
  AllAppsBuilder() {
    GestureDockAllAppsView({
      screenProperty: this.screenProperty,
    })
      .transition(TransitionEffect.OPACITY.animation({ duration: 300, curve: Curve.Sharp }))
      .translate({ x: this.gestureDockParam.allAppsTranslation })
  }

  @Builder
  dividerBuilder() {
    Divider()
      .vertical(true)
      .strokeWidth('1px')
      .color(GestureDockConstants.COLOR_TEXT_SECONDARY)
      .position({
        x: this.viewDataMgr.getDividerPositionX(this.screenProperty.width),
        y: 0
      })
      .transition(TransitionEffect.OPACITY.animation({ duration: 300, curve: Curve.Sharp }))
      .translate({ x: this.gestureDockParam.allAppsTranslation })
  }

  @Styles
  dragStyle() {
    .onDragEnter((event?: DragEvent, extraParams?: string) => {
      this.viewEventMgr.handleDragEnter();
    })
    .onDragMove((event: DragEvent, extraParams?: string) => {
      this.viewEventMgr.handleDragMove(event);
    })
    .onDrop((event: DragEvent, extraParams?: string) => {
      this.viewEventMgr.handleDragDrop(event);
    })
  }
}