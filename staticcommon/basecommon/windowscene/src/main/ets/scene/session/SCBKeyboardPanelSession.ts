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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { BusinessError } from '@kit.BasicServicesKit';
import { SCBSystemSceneSession, SystemSessionInfo, SystemSessionChangeCallback } from './SCBSystemSceneSession';
import { SCBKeyboardManager } from './SCBKeyboardManager';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'SCBKeyboardPanelSession';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Session of keyboard panel
 *
 */
@Observed
export class SCBKeyboardPanelSession extends SCBSystemSceneSession {
  public hotAreaBottom: number = 0;
  public isLandscape: boolean = false;
  public isExpandStatus: boolean = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
  public keyboardViewMode: sceneSessionManager.KeyboardViewMode = 
    sceneSessionManager?.KeyboardViewMode?.NON_IMMERSIVE_MODE;
  public isGradientMode: boolean = false;
  private isHotSwitch: boolean = false;
  private panelAdjustHeight: number = 0;
  private panelRealHeight: number = -1;
  public panelShadow: sceneSessionManager.WindowShadowConfig = { radius: 0, color: '', offsetX: 0, offsetY: 0 };

  constructor(session: sceneSessionManager.SceneSession, systemSessionInfo: SystemSessionInfo,
              sessionChangeCallback?: SystemSessionChangeCallback) {
    super(session, systemSessionInfo, sessionChangeCallback);
  }

  public getPanelRealHeight(): number {
    // panelRealHeight 由 avoidHeight 计算得来，镜像/特定窗口模式下可能出现 0（不可用）
    // 对于显示状态下的键盘，优先回退到 panelAdjustHeight（面板自身高度），确保避让逻辑可用
    if (this.panelRealHeight <= 0) {
      return this.panelAdjustHeight;
    }
    return this.panelRealHeight;
  }

  public setPanelRealHeight(panelHeight: number): void {
    this.panelRealHeight = panelHeight;
  }

  /**
   * @description: set panel adjust height
   *
   * @returns 
   */
  public setPanelAdjustHeight(panelAdjustHeight: number): void {
    this.panelAdjustHeight = panelAdjustHeight;
  }

  /**
   * @description: registe keyboard panel listener
   *
   * @returns
   */
  public registerListener(): void {
    this.isLandscape = DeviceHelper.isLandscape();
    this.registerPanelShadow();
  }

  private registerPanelShadow(): void {
    try {
      this.panelShadow = { radius: 0, color: '', offsetX: 0, offsetY: 0 };
      SCBKeyboardManager.getInstance().getKeyboardSession()?.session.on('setWindowShadows',
        (shadowConfig: sceneSessionManager.WindowShadowConfig ) => {
          this.panelShadow = shadowConfig;
        });
    } catch(err) {
      let error = err as BusinessError;
      log.showError(`on setWindowShadows code: ${error.code}, message: ${error.message}`);
    }
  }

  public getIsHotSwitch(): boolean {
    return this.isHotSwitch;
  }

  public setHotSwitch(hotSwitch: boolean): void {
    this.isHotSwitch = hotSwitch;
  }

  public setVisibility(visibility: boolean): void {
    super.setVisibility(visibility);
  }
}
