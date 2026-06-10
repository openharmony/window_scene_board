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

import SwitchDropdownPanel from '../switchdropdownpanel';
import { NotificationPanelView } from '@ohos/notificationcomponent/src/main/ets/view/NotificationPanelView';
import { LogDomain, LogHelper, ThreadUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import { TargetPanel } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { NtfListScrollController, NotificationInitiator } from '@ohos/notificationcomponent/newIndex';

const TAG = 'NotificationPanelDc';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
/**
 * 从控制中心横滑回到通知中心时，通知中心面板横向偏移初始值
 */
const DROP_PANEL_POSITION = 380;

@Component
export struct NotificationPanelDc {
  @State contentOpacity: number = 0;
  @State contentScale: number = 1;
  @State contentTransX: number = 0;
  @State contentTransY: number = 0;
  @Link contentZIndex: number;
  @Link isShowNotification: boolean;
  /**
   * 从控制中心横滑回到通知中心时，通知中心面板横向偏移量
   */
  @State horizontalDropPanelPosition: number = DROP_PANEL_POSITION;
  private listScroller: NtfListScrollController = new NtfListScrollController();

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    if (!ThreadUtil.isMainThread) {
      NotificationInitiator.get().init();
    }
  }

  build() {
    Stack() {
      SwitchDropdownPanel({
        contentOpacity: $contentOpacity,
        contentScale: $contentScale,
        contentTransX: $contentTransX,
        contentTransY: $contentTransY,
        contentZIndex: $contentZIndex,
        currentPanel: TargetPanel.NOTIFICATION_PANEL,
        listScroller: this.listScroller,
        horizontalDropPanelPosition: this.horizontalDropPanelPosition,
      })
      NotificationPanelView({
        contentScale: this.contentScale,
        changePosition: (val: number) => this.horizontalDropPanelPosition = val,
      })
    }
    .id(TAG)
    .width('100%')
    .height('100%')
    .opacity(this.contentOpacity)
    .scale({ x: this.contentScale, y: this.contentScale })
    .translate({ x: this.contentTransX, y: this.contentTransY })
    .zIndex(this.contentZIndex)
  }
}