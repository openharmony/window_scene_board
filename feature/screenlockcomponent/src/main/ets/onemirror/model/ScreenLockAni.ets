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
import MirrorAniConfig from './MirrorAnimationConf';
import IMirrorToEnd from './IMirrorToEnd';

export default class ScreenLockAni implements IMirrorToEnd {
  public aniConf: MirrorAniConfig;

  public constructor(screenLockConf: MirrorAniConfig) {
    this.aniConf = screenLockConf;
  }

  public doWhenBeginSleep(): void {
    this.init();
  }

  public doWhenEndScreenOn(): void {
    this.init();
  }

  private init(): void {
    this.aniConf.setScale(1);
    this.aniConf.setAlpha(1);
  }

  public doWhenOffScreen(): void {
    this.aniConf.setScale(0.95);
  }

  public doWhenOnScreen(): void {
    this.init();
  }

  public doWhenDesktopToAOD(): void {
    this.init();
  }

  public doWhenScreenLockToAOD(): void {
    this.init();
  }

  public doWhenAODToDesktop(): void {
    this.init();
  }

  public doWhenAODToScreenLock(): void {
    this.init();
  }

  public doWhenAODSCL2AOD(): void {
  }

  public doWhenOffScreen2ScreenLockBegin(): void {
    this.aniConf.setScale(0.95);
    this.aniConf.setAlpha(0);
  }

  public doWhenOffScreen2ScreenLockEnd(): void {
    this.init();
  }
}
