/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import sceneSessionManager from '@ohos.sceneSessionManager'
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LayoutViewModel } from '@ohos/launchercommon';
import { ResUtils, SCBSceneSessionManager, SystemBarType } from '@ohos/windowscene';

const TAG = 'SCBSystemSceneUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class SCBSystemSceneUtils {
  private static instance: SCBSystemSceneUtils;
  constructor() {
  }

  /**
   * 单例对象
   *
   * @returns 单例对象
   */
  public static getInstance(): SCBSystemSceneUtils {
    if (!SCBSystemSceneUtils.instance) {
      SCBSystemSceneUtils.instance = new SCBSystemSceneUtils();
    }
    return SCBSystemSceneUtils.instance;
  }

  /**
   * get status bar height in px
   * @param screenId screen id
   * @returns status bar height
   */
  public getStatusBarHeightPx(screenId?: number): number {
    let statusBarHeight: number = 0;
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
    if (statusBar) {
      statusBarHeight = statusBar.currRect.height.getPx();
    }
    log.showDebug('getStatusBarHeightPx:' + statusBarHeight);
    return statusBarHeight;
  }

  /**
   * get status bar height in vp
   * @param screenId screen id
   * @returns status bar height
   */
  public getStatusBarHeightVP(uiContext: UIContext, screenId?: number): number {
    let statusBarHeight: number = 0;
    let statusBar = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(sceneSessionManager.SessionType.TYPE_STATUS_BAR, screenId);
    if (statusBar) {
      statusBarHeight = uiContext.px2vp(statusBar.currRect.height.getPx());
    }
    log.showDebug('getStatusBarHeightVp:' + statusBarHeight);
    return statusBarHeight;
  }

  /**
   * get dock height in px
   * @param uiContext uiContext
   * @param screenId screen id
   * @returns dock height
   */
  public getDockHeightPx(screenId?: number, uiContext?: UIContext): number {
    let dockHeight = 0;
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    if (dock) {
      dockHeight = dock.currRect.height.getPx();
    }
    log.showDebug('getDockHeightPx:' + dockHeight);
    return dockHeight;
  }

  /**
   * get dock height in vp
   * @param uiContext uiContext
   * @param screenId screen id
   * @returns dock height
   */
  public getDockHeightVP(uiContext: UIContext, screenId?: number): number {
    let dockHeight = 0;
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, screenId);
    if (dock) {
      dockHeight = uiContext.px2vp(dock.currRect.height.getPx());
    }
    log.showDebug('getDockHeightVp:' + dockHeight);
    return dockHeight;
  }

  /**
   * Converts a value in vp units to a value in px with UiContext
   *
   * @param uiContext the current UIContext instance
   * @param value the value
   * @returns
   */
  public vp2px(uiContext: UIContext | undefined, value: number): number {
    return uiContext ? uiContext.vp2px(value) : vp2px(value);
  }

  /**
   * Converts a value in px units to a value in vp with UiContext
   *
   * @param uiContext the current UIContext instance
   * @param value the value
   * @returns
   */
  public px2vp(uiContext: UIContext | undefined, value: number): number {
    return uiContext ? uiContext.px2vp(value) : px2vp(value);
  }
}