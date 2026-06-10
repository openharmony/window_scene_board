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

import { SCBConstants } from '@ohos/commonconstants';
import { CommonUtils } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SCBScenePanelSession';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

@Observed
export class SCBBackgroundBlurSession {
  public bgBlurScale: number = 0;
  public bgBlurColor: string = SCBConstants.DEFAULT_SCENE_BG_COLOR;

  /**
   * How to Set Background Blur
   *
   * @param { Number } blurScale
   * @param { callerFunctionName } caller Function Name
   */
  public setBgBlurScale(blurScale: number, callerFunctionName: string): void {
    if (CommonUtils.equals(this.bgBlurScale, blurScale)) {
      return;
    }
    log.showWarn(`setBgBlurScale, blurScale: ${this.bgBlurScale} to ${blurScale},` +
      `caller function name: ${callerFunctionName}`);
    this.bgBlurScale = blurScale;
  }

  /**
   * Set background blur color
   *
   * @param { String } blurColor
   */
  public setBgBlurColor(blurColor: string): void {
    if (this.bgBlurColor === blurColor) {
      return;
    }
    this.bgBlurColor = blurColor;
  }
}

@Observed
export class SCBScenePanelSession {
  public defaultPanelZIndex: number;
  public panelZIndex: number;
  public isBgBlurEnable: boolean = false;
  public isBgBlurAboveKeyguardEnabled: boolean = false;

  /**
   * initializer
   *
   * @param { Number } defaultPanelZIndex
   */
  public init(defaultPanelZIndex: number): void {
    this.defaultPanelZIndex = defaultPanelZIndex;
    this.panelZIndex = defaultPanelZIndex;
  }

  /**
   * Sets the z-index value of the panel
   *
   * @param { Number } zIndex
   */
  public setPanelZIndex(zIndex: number): void {
    if (this.panelZIndex === zIndex) {
      return;
    }
    this.panelZIndex = zIndex;
  }

  /**
   * enable background blur
   *
   * @param { Boolean } isBlurEnable
   * @param { callerFunctionName } caller Function Name
   */
  public setBgBlurEnable(isBlurEnable: boolean, callerFunctionName: string): void {
    if (this.isBgBlurEnable === isBlurEnable) {
      return;
    }
    log.showWarn(`setBgBlurEnable, isBlurEnable: ${isBlurEnable}, caller function name: ${callerFunctionName}`);
    this.isBgBlurEnable = isBlurEnable;
  }

  /**
   * Set background blur status for above keyguard
   *
   * @param { Boolean } isBlurEnable
   * @param { callerName } caller Function Name
   */
  public setBgBlurAboveKeyguardStatus(isBlurEnable: boolean, callerName: string): void {
    if (isBlurEnable === this.isBgBlurAboveKeyguardEnabled) {
      return;
    }
    log.showWarn(`set isBgBlurAboveKeyguardEnabled: ${isBlurEnable}, caller name: ${callerName}`);
    this.isBgBlurAboveKeyguardEnabled = isBlurEnable;
  }
}