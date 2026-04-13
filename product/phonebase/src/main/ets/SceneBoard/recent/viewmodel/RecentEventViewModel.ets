/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { RotationConstants } from '@ohos/commonconstants';
import { HoverAnimationUtil } from '@ohos/launchercommon/Index';
import { ResUtils, SCBSceneContainerSession, SCBScreenProperty } from '@ohos/windowscene';
import { SCBOuterScenePanelManager } from '../../scenemanager/SCBOuterScenePanelManager';
import { RecentRotationUtil } from '../common/RecentRotationUtil';
import { recentRuntimeInstance } from '../scenepanel/recentpanel/RecentRuntimeModel';
import { SCBScenePanelFSM } from '../scenepanel/SCBScenePanelFSM';

const TAG = 'RecentEventViewModel';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class RecentEventViewModel {
  private screenProperty: SCBScreenProperty = new SCBScreenProperty();
  public containerSessionRotation: number = 0;
  public currentScaleX: number = 1;
  public currentScaleY: number = 1;
  public isInHover: boolean = false;
  // 此状态是为了限定手指点击和鼠标hover不可同时执行，否则scale会出现一直增长的情况
  public isNeedHoverAnimation: boolean = true;

  public constructor(screenProperty: SCBScreenProperty) {
    this.screenProperty = screenProperty;
  }

  private resetHoverScale(sceneContainerSession: SCBSceneContainerSession): void {
    if (this.isInHover) {
      this.isInHover = false;
      log.showInfo('reset hover scale before other scale change');
      this.executeHoverAnimation(false, sceneContainerSession);
    }
  }

  private executeHoverAnimation(isHover: boolean, sceneContainerSession: SCBSceneContainerSession): void {
    HoverAnimationUtil.hoverEffect(isHover, false, (hoverScale: number) => {
      sceneContainerSession?.needRenderScale.setScaleXWithDfx(this.currentScaleX * hoverScale, TAG, 'hover',
        sceneContainerSession.getName());
      sceneContainerSession?.needRenderScale.setScaleYWithDfx(this.currentScaleY * hoverScale, TAG, 'hover',
        sceneContainerSession.getName());
    });
  }

  private touchDownCallback(event: TouchEvent, containerId: number): void {
    let fingersNum = event.touches.length;
    if (fingersNum > 1) {
      log.showInfo('ignore touch down event, finger = ' + fingersNum);
      return;
    }
    recentRuntimeInstance.touchContainerIndex =
      recentRuntimeInstance.notRemovingSessionList.findIndex((item) => {
        return (item.containerId === containerId);
      });
    recentRuntimeInstance.touchEvent = event;
    SCBScenePanelFSM.getInstance().onTouchDown(event, TAG);
  }

  public static getPanGestureEvent(event: GestureEvent,
    screenProperty: SCBScreenProperty,
    sceneContainerSession: SCBSceneContainerSession): GestureEvent {
    if (!screenProperty || !sceneContainerSession) {
      log.showWarn(`getPanGestureEvent screenProperty or sceneContainerSession is null`);
      return event;
    }
    let screenRotation: number = RecentRotationUtil.getScreenRotation(screenProperty);
    let rotationAngleDiff = screenRotation - sceneContainerSession.currentRotation;
    // To facilitate classification, the angle is converted. E.G. (-270 + 360) % 360 = 90.
    let transformedAngleDiff: number =
      (rotationAngleDiff + RotationConstants.ROTATION_360) % RotationConstants.ROTATION_360;
    let tmpOffsetX: number = event.offsetX;
    // When the clockwise rotation angle difference is equal to 90 degrees or 270 degrees, the coordinate system of
    // the event is converted using the difference between the screen rotation angle and the application rotation angle.
      if (transformedAngleDiff === RotationConstants.ROTATION_90) {
        event.offsetX = -event.offsetY;
        event.offsetY = tmpOffsetX;
      } else if (transformedAngleDiff === RotationConstants.ROTATION_270) {
        event.offsetX = event.offsetY;
        event.offsetY = -tmpOffsetX;
      }
    return event;
  }

  public static getPanGestureDirection(screenProperty: SCBScreenProperty,
    containerSessionRotation: number): PanDirection {
    let screenRotation: number = RecentRotationUtil.getScreenRotation(screenProperty);
    return RecentRotationUtil.isSameRotation(screenRotation, containerSessionRotation)
      ? PanDirection.Vertical : PanDirection.Horizontal;
  }

  public static getClickAnnounceText(primaryName: string, isAppLockedForbidDelete: boolean): string {
    let announceText = primaryName;
    if (isAppLockedForbidDelete) {
      announceText = ResUtils.getInnerStringNumS($r('app.string.app_locked'), announceText);
    }
    return announceText;
  }

  public static getComponentId(containerId: number): string {
    return `RecentEventView_Text_${containerId}`;
  }

  public init(sceneContainerSession: SCBSceneContainerSession): void {
    this.currentScaleX = 1;
    this.currentScaleY = 1;
    this.isInHover = false;
    this.isNeedHoverAnimation = true;
    this.containerSessionRotation = sceneContainerSession.currentRotation;
  }

  public handleHoverEvent(isHover: boolean, sceneContainerSession: SCBSceneContainerSession): void {
    if (!this.isNeedHoverAnimation || this.isInHover === isHover) {
      return;
    }
    this.isInHover = isHover;
    if (isHover) {
      this.currentScaleX = sceneContainerSession?.needRenderScale.scaleX;
      this.currentScaleY = sceneContainerSession?.needRenderScale.scaleY;
    }
    this.executeHoverAnimation(isHover, sceneContainerSession);
  }

  public handleTouchEvent(event: TouchEvent, sceneContainerSession: SCBSceneContainerSession): void {
    if (event.type === TouchType.Down) {
      if (event.source !== SourceType.Mouse) {
        this.isNeedHoverAnimation = false;
      }
      this.resetHoverScale(sceneContainerSession);
      this.touchDownCallback(event!, sceneContainerSession.containerId);
      return;
    }
    if ((event.type === TouchType.Up || event.type === TouchType.Cancel) && event.source !== SourceType.Mouse) {
      this.isNeedHoverAnimation = true;
    }
  }
}
