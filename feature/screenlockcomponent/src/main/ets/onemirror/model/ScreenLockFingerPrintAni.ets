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
import type MirrorAniConfig from './MirrorAnimationConf';
import type IMirrorToEnd from './IMirrorToEnd';

const SET_BLUR_NUM_0_0 = 0;
const SET_BLUR_NUM_0_1 = 1;
const SET_BLUR_NUM_0_3 = 300;

export default class ScreenLockFingerPrintAni implements IMirrorToEnd {
  public aniConf: MirrorAniConfig;

  public constructor(aniConf: MirrorAniConfig) {
    this.aniConf = aniConf;
  }

  public doWhenBeginSleep(): void {
    this.hide();
  }

  public doWhenEndScreenOn(): void {
    this.init();
  }

  public doWhenOffScreen(): void {
    this.init();
  }

  public doWhenOnScreen(): void {
    this.hide();
  }

  public doWhenDesktopToAOD(): void {
    this.hide();
  }

  public doWhenScreenLockToAOD(): void {
    this.init();
  }

  private init(): void {
    this.aniConf.setScale(SET_BLUR_NUM_0_1);
    this.aniConf.setAlpha(SET_BLUR_NUM_0_1);
    this.aniConf.setBlur(SET_BLUR_NUM_0_0);
  }

  private hide(): void {
    this.aniConf.setScale(SET_BLUR_NUM_0_0);
    this.aniConf.setAlpha(SET_BLUR_NUM_0_0);
    this.aniConf.setBlur(SET_BLUR_NUM_0_3);
  }

  public doWhenAODToDesktop(): void {
  }

  public doWhenAODToScreenLock(): void {
  }

  public doWhenAODSCL2AOD(): void {
  }

  public doWhenOffScreen2ScreenLockBegin(): void {
    this.hide();
  }

  public doWhenOffScreen2ScreenLockEnd(): void {
    this.init();
  }
}
