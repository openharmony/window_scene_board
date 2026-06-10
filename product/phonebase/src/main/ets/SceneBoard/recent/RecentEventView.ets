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
  SCBSceneContainerSession,
  SCBScreenProperty,
  scbEventExclusiveManager,
  EventType,
  RecentsStyleConstants,
} from '@ohos/windowscene';
import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import { StyleConstants } from '@ohos/launchercommon';
import { LockType, RecentAccessibilityUtils
} from './scenepanel/recentpanel/RecentAccessibilityUtils';
import { RecentZoomAlarm } from './scenepanel/recentpanel/RecentZoomAlarm';
import { SCBScenePanelFSM } from './scenepanel/SCBScenePanelFSM';
import { RecentClickReason } from './scenepanel/ScenePanelStates';
import { RecentEventViewModel } from './viewmodel/RecentEventViewModel';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { RecentLockIconModel } from './scenepanel/recentpanel/RecentLockIconModel';
import { AccessibilityManager } from '@ohos/frameworkwrapper';

const TAG = 'RecentEventView'
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG)

@Component
export struct RecentEventView {
  // do not delete this var.  RecentEventView will not update when sceneContainerSession changes.
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  @Link screenProperty: SCBScreenProperty;
  @State appName: string = '';
  private recentEventViewModel: RecentEventViewModel = new RecentEventViewModel(this.screenProperty);
  private readonly componentId: string = RecentEventViewModel.getComponentId(this.sceneContainerSession.containerId);
  private accessibilityModeChangeCallback = () => {
    if (AccessibilityManager.getInstance().getIsAccessibilityMode() && CheckEmptyUtils.isEmpty(this.appName)) {
      this.getAppName();
    }
  };

  aboutToAppear(): void {
    this.recentEventViewModel.init(this.sceneContainerSession);
    this.getAppName();
    AccessibilityManager.getInstance().registerAccessibilityChangeCallback(this.componentId,
      this.accessibilityModeChangeCallback);
  }

  aboutToDisappear(): void {
    AccessibilityManager.getInstance().unRegisterAccessibilityChangeCallback(this.componentId,
      this.accessibilityModeChangeCallback);
  }

  private updateNameCallback(name: string): void {
    if (CheckEmptyUtils.isEmpty(name)) {
      return;
    }
    this.appName = name;
  }

  private getAppName(): void {
    RecentAccessibilityUtils.textAnnouncedForClickTask(this.sceneContainerSession,
      (name: string): void => this.updateNameCallback(name));
  }

  private lockProcessAfterGesture(gestureEvent: GestureEvent): void {
    log.showInfo(`lockProcessAfterGesture -> offsetY: ${gestureEvent.offsetY}`);
    let maxSlideDistance = recentLayoutConfigInstance.isNeedMultiRowLayout() ?
      RecentsStyleConstants.MULTI_ROW_MAX_SLIDE_DISTANCE : RecentsStyleConstants.SINGLE_ROW_MAX_SLIDE_DISTANCE;
    // 下滑超过最大阈值并且全屏/悬浮窗卡片才可以进行进行加锁/解锁处理
    if (gestureEvent.offsetY >= maxSlideDistance / RecentsStyleConstants.SLIDE_FOLLOWING_RATE &&
      this.sceneContainerSession.secondarySession === null) {
      log.showInfo('The conditions are met and enter lockProcessAfterGesture!');
      let lockType: number = LockType.UNLOCK;
      log.info(`isAppLockedForbidDelete ${this.sceneContainerSession.isAppLockedForbidDelete}`);
      if (this.sceneContainerSession.isAppLockedForbidDelete) {
        RecentLockIconModel.lockIconDisAppearAnimate(this.sceneContainerSession, this.appName);
        lockType = LockType.UNLOCK;
      } else {
        RecentLockIconModel.lockStateChange(this.sceneContainerSession, true);
        RecentAccessibilityUtils.textAnnouncedForLockApp(this.appName, LockType.LOCK);
        RecentLockIconModel.lockIconAppearAnimate(this.sceneContainerSession);
        lockType = LockType.LOCK;
      }
      // 下划卡片锁定打点
      log.showInfo(`slide lock report,bundleName:${this.sceneContainerSession.getBundleName()},lockType: ${lockType}`);
      RecentLockIconModel.reportSlideLock(this.sceneContainerSession, lockType);
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopStart })
      .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
      .onTouch((event: TouchEvent): void => {
        this.recentEventViewModel.handleTouchEvent(event, this.sceneContainerSession);
      })
      .id(this.componentId)
      .accessibilityText(RecentEventViewModel.getClickAnnounceText(this.appName,
        this.sceneContainerSession.isAppLockedForbidDelete))
      .onHover((isHover: boolean): void => this.recentEventViewModel.handleHoverEvent(isHover,
        this.sceneContainerSession))
      .onClick((event: ClickEvent) => {
        if (!this.sceneContainerSession.primarySession ||
        scbEventExclusiveManager.isExclusive(EventType.RECENT_CARD_CLICK)) {
          return;
        }
        SCBScenePanelFSM.getInstance().onClick(RecentClickReason.START_APP, this.sceneContainerSession);
      })
      .gesture(
        GestureGroup(GestureMode.Exclusive,
          PanGesture({ fingers: 1, direction: RecentEventViewModel.getPanGestureDirection(
            this.screenProperty, this.recentEventViewModel.containerSessionRotation), distance: 5 })
            .onActionStart((event?: GestureEvent) => {
              if (!this.sceneContainerSession.primarySession) {
                return;
              }
              AppStorage.setOrCreate('isInRecentEventViewGesture', true);
              scbEventExclusiveManager.setEventExclusive(EventType.RECENT_CARD_UPSLIDE, true);

              SCBScenePanelFSM.getInstance().consumeRecentStartEvent(this.sceneContainerSession.containerId,
                RecentEventViewModel.getPanGestureEvent(event as GestureEvent, this.screenProperty,
                  this.sceneContainerSession));
              RecentZoomAlarm.getInstance().cancel('gesture start');
            })
            .onActionUpdate((event?: GestureEvent) => {
              if (!this.sceneContainerSession.primarySession) {
                return;
              }
              SCBScenePanelFSM.getInstance().consumeRecentUpdateEvent(this.sceneContainerSession.containerId,
                RecentEventViewModel.getPanGestureEvent(event as GestureEvent, this.screenProperty,
                  this.sceneContainerSession));
            })
            .onActionEnd((event?: GestureEvent) => {
              let convertedEvent: GestureEvent = RecentEventViewModel.getPanGestureEvent(event as GestureEvent,
                this.screenProperty, this.sceneContainerSession);
              this.lockProcessAfterGesture(convertedEvent);
              if (!this.sceneContainerSession.primarySession) {
                return;
              }
              AppStorage.setOrCreate('isInRecentEventViewGesture', false);
              scbEventExclusiveManager.setEventExclusive(EventType.RECENT_CARD_UPSLIDE, false);
              SCBScenePanelFSM.getInstance().consumeRecentEndEvent(this.sceneContainerSession.containerId,
                convertedEvent);
            })
            .onActionCancel((event?: GestureEvent) => {
              let convertedEvent: GestureEvent = RecentEventViewModel.getPanGestureEvent(event as GestureEvent,
                this.screenProperty, this.sceneContainerSession);
              this.lockProcessAfterGesture(convertedEvent);
              AppStorage.setOrCreate('isInRecentEventViewGesture', false);
              scbEventExclusiveManager.setEventExclusive(EventType.RECENT_CARD_UPSLIDE, false);
              SCBScenePanelFSM.getInstance().consumeRecentCancelEvent(this.sceneContainerSession.containerId,
                convertedEvent);
            })
        )
      )
  }
}