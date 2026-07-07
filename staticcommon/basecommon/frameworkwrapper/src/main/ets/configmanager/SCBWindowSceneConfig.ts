/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';

const TAG = 'SCBWindowSceneConfig';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Scene session manager
 */
export class SCBWindowSceneConfig {
  windowSceneConfig: sceneSessionManager.AppWindowSceneConfig;
  systemConfig: sceneSessionManager.SystemConfig | undefined = undefined;
  /**
   * Get the singleton of the window scene config.
   */
  static getInstance(): SCBWindowSceneConfig {
    if (!globalThis.SCBWindowSceneConfigInstance) {
      globalThis.SCBWindowSceneConfigInstance = new SCBWindowSceneConfig();
    }

    return globalThis.SCBWindowSceneConfigInstance;
  }

  public loadWindowSceneConfig(): void {
    this.windowSceneConfig = sceneSessionManager.getWindowSceneConfig();
    this.systemConfig = sceneSessionManager.getSystemConfig();

    // Convert uiType to match SCBConstants
    if (this.windowSceneConfig.multiWindowUIType === 'HandsetSmartWindow') {
      this.windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
    } else if (this.windowSceneConfig.multiWindowUIType === 'FreeFormMultiWindow') {
      this.windowSceneConfig.uiType = SCBConstants.UITYPE_PC;
    } else if (this.windowSceneConfig.multiWindowUIType === 'TabletSmartWindow') {
      this.windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
    }

    log.showInfo('Window scene config, floatCornerRadius: ' + this.windowSceneConfig.floatCornerRadius +
      ', focusedShadow offsetX: ' + this.windowSceneConfig.focusedShadow.offsetX + ', offsetY: ' +
      this.windowSceneConfig.focusedShadow.offsetY + ', radius: ' + this.windowSceneConfig.focusedShadow.radius +
      ', color: ' + this.windowSceneConfig.focusedShadow.color + ', unfocusedShadow offsetX: ' +
      this.windowSceneConfig.unfocusedShadow.offsetX + ', offsetY: ' + this.windowSceneConfig.unfocusedShadow.offsetY +
      ', radius: ' + this.windowSceneConfig.unfocusedShadow.radius + ', color: ' +
      this.windowSceneConfig.unfocusedShadow.color + ', uiType: ' + this.windowSceneConfig.uiType +
      ', backgroundScreenLock: ' + this.windowSceneConfig.backgroundScreenLock + ', rotationMode: ' +
      this.windowSceneConfig.rotationMode + ' upDownStatusBarConfig:' +
      JSON.stringify(this.windowSceneConfig.upDownStatusBarConfig) +', rotationMode:'+ this.windowSceneConfig.rotationMode);
    log.showInfo(`load systemConfig: ${JSON.stringify(this.systemConfig)}`);
    if (!this.windowSceneConfig.leftRightStatusBarConfig) {
      log.showInfo('Not Configured Window Immersive!');
    } else {
      const {desktopStatusBarConfig, leftRightStatusBarConfig, upDownStatusBarConfig} = this.windowSceneConfig;
      log.showInfo('Window Immersive Config, desktopStatusBarConfig: { showHide: ' + desktopStatusBarConfig.showHide +
        ', contentColor: ' + desktopStatusBarConfig.contentColor + ', backgroundColor: ' + desktopStatusBarConfig.backgroundColor + '}, ' +
        'leftRightStatusBarConfig: { showHide: ' + leftRightStatusBarConfig.showHide +
        ', contentColor: ' + leftRightStatusBarConfig.contentColor + ', backgroundColor: ' + leftRightStatusBarConfig.backgroundColor + '}, ' +
        'upDownStatusBarConfig: { showHide: ' + upDownStatusBarConfig.showHide +
        ', contentColor: ' + upDownStatusBarConfig.contentColor + ', backgroundColor: ' + upDownStatusBarConfig.backgroundColor + '};');
    }
  }

  /**
   * phone device
   */
  public isPhone(): boolean {
    return this.windowSceneConfig?.uiType === SCBConstants.UITYPE_PHONE;
  }
}