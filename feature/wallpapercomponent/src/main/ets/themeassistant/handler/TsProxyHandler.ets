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
  AodElemPosition,
  AodPositionType,
} from '@ohos/themeservice';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { systemDateTime } from '@kit.BasicServicesKit';
import { ThemeFreezeReason } from '../ThemeConstant';
import { DesktopModeEnum } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG: string = 'TsProxyHandler';

const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class TsProxyHandler {
  private uiExtProxy?: UIExtensionProxy;

  public constructor(uiProxy: UIExtensionProxy) {
    this.uiExtProxy = uiProxy;
  }

  public sendScbStateUpdate(srcState: number, dstState: number, isSafeMode: boolean): void {
    this.uiExtProxy?.send({
      'scbStateChange': true,
      'scbState': dstState,
      'sender': TAG,
      'isSafeMode': isSafeMode,
      'srcState': srcState,
    });
  }

  /**
   * Send Window Status
   *
   * @param sceneState 0 foreground else background
   */
  public sendWindowSceneState(sceneState: number): void {
    this.uiExtProxy?.send({
      'sceneState': sceneState,
    });
  }

  public sendInteractiveUpdate(interactiveType: number, x: number, y: number, source: string): void {
    this.uiExtProxy?.send({
      'interactiveType': interactiveType,
      'x': x,
      'y': y,
      'source': source,
    });
  }

  public sendMainPageStateUpdate(mpState: number): void {
    this.uiExtProxy?.send({
      'mainPageStateType': mpState,
    });
  }

  public sendAnimationUpdate(animationState: number): void {
    this.uiExtProxy?.send({
      'animationType': animationState,
    });
  }

  /**
   * Notify TE about dynamic wallpaper animation
   *
   * @param srcState Starting SCB State
   * @param dstState Incoming SCB State
   * @param isPlayAnimation True if animation actually needed, false if only needs to jump to the target frame
   * @param timestamp Used as task id to assign with finish callback task
   */
  public sendDynamicAnimationUpdate(srcState: number, dstState: number, isPlayAnimation: boolean,
    timestamp: number): void {
    this.uiExtProxy?.send({
      'dynamicAnimation': true,
      'srcState': srcState,
      'dstState': dstState,
      'isPlayAnimation': isPlayAnimation,
      'taskId': timestamp,
      'sender': TAG,
    });
  }

  public sendRootPathUpdate(rootPath: string): void {
    this.uiExtProxy?.send({
      'rootPath': rootPath,
    });
  }

  /**
   * AOD status update
   */
  public sendAodStateUpdate(): void {
    this.uiExtProxy?.send({
      'aodStateChange': true,
    });
  }

  /**
   * Update the theme scene by theme engine.
   *
   * @param {string} event - The type of event triggering the update
   */
  public updateThemeScene(event: string): void {
    this.uiExtProxy?.send({
      'updateThemeScene': true,
      'event': event,
    });
  }

  /**
   * Send live view event to theme engine.
   *
   * @param {string} hashCode - The unique identifier of the event
   * @param {string} event - The name of the event
   * @param {number} status - The status of the event
   */
  public sendLiveViewEvent(eventType: number, hashCode:string, event: string, status: number): void {
    this.uiExtProxy?.send({
      'liveViewEventChange': true,
      'eventType': eventType,
      'hashCode': hashCode,
      'event': event,
      'status': status
    });
  }

  /**
   * Update ThemeEngine freeze status if using dynamic ThemeEngine
   *
   * @param status true means freeze ThemeEngine while false means unfreeze ThemeEngine
   * @param isProximity means proximity scenario
   * @param freezeReason means freeze reason, current DROPDOWN_PANEL use this param
   */
  public sendEngineFreezeStatusUpdate(status: boolean, isProximity?: boolean, freezeReason?: ThemeFreezeReason): void {
    this.uiExtProxy?.send({
      'engineFreezeStatusChange': status,
      'isProximity': isProximity ?? false,
      'freezeReason': freezeReason ?? -1,
      'time': systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false),
    });
  }

  /**
   * BeforeChangeTheme, do something
   */
  public sendBeforeChangeTheme(): void {
    this.uiExtProxy?.send({
      'beforeChangeTheme': '',
    });
  }

  /**
   * enable gesture motion callback
   *
   * @param enable enable gesture motion callback
   */
  public sendGestureMotionEnable(enable: boolean): void {
    this.uiExtProxy?.send({
      'gestureMotionEnable': enable,
    });
  }

  /**
   * update AOD clock base image
   */
  public updateClockBaseImage(): void {
    try {
      this.uiExtProxy?.send({
        'updateClockBaseImage': '',
      });
    } catch (err) {
      LOG.error(`updateClockBaseImage error : ${err}`);
    }
  }

  /**
   * Update AOD information to theme engine
   *
   * @param aodPosition Contains information on AOD type and positions
   */
  public sendAodPosition(aodPosition: AodElemPosition): void {
    if (!aodPosition || !aodPosition.background) {
      return;
    }
    switch (aodPosition.type) {
      case AodPositionType.PART_AOD_COMMON:{
        this.uiExtProxy?.send({
          'aodOffsetUpdate': true,
          'offsetX': aodPosition.background?.offsetX,
          'offsetY': aodPosition.background?.offsetY,
        });
        break;
      }
      case AodPositionType.PART_AOD_REALTIME_RENDER: {
        this.uiExtProxy?.send({
          'aodGeometryUpdate': true,
          'aodPosX': aodPosition.background?.x,
          'aodPosY': aodPosition.background?.y,
          'aodWidth': aodPosition.background?.width,
          'aodHeight': aodPosition.background?.height,
          'backgroundPath': aodPosition.backgroundPath,
          'isScreenOn':aodPosition.isScreenOn,
        });
        break;
      }
      default: {
        LOG.warn(TAG, 'Unknown AOD type.');
        return;
      }
    }
  }

  /**
   * send desktop mode
   *
   * @param preDesktopMode Previous mode
   * @param targetDesktopMode Current mode
   */
  public sendDesktopModeUpdate(preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum): void {
    this.uiExtProxy?.send({
      'updateDesktopBaseMode': true,
      'preDesktopMode': preDesktopMode,
      'targetDesktopMode': targetDesktopMode,
    });
  }

  /**
   * 发送桌面应用打开状态
   *
   * @param isAppOpenedOnDesktop 桌面应用状态 true: 桌面打开了应用，false: 桌面无应用
   */
  public sendDesktopAppState(isAppOpenedOnDesktop: boolean): void {
    this.uiExtProxy?.send({
      'updateDesktopAppState': true,
      'isAppOpenedOnDesktop': isAppOpenedOnDesktop,
    });
  }
}
