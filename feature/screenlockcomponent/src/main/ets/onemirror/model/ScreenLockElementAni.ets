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
import MirrorAniConfig, { MirrorElemType } from './MirrorAnimationConf';
import IMirrorToEnd from './IMirrorToEnd';

export default class ScreenLockElementAni implements IMirrorToEnd {
  public aniConf: MirrorAniConfig;
  public elemType: number;

  public constructor(aniConf: MirrorAniConfig, elemType: number) {
    this.aniConf = aniConf;
    this.elemType = elemType;
  }

  public doWhenBeginSleep(): void {
    this.hide();
  }

  public doWhenEndScreenOn(): void {
    this.initScreenLock();
  }


  public doWhenOffScreen(): void {
    this.hide();
  }

  public doWhenOnScreen(): void {
    this.hide();
  }

  public doWhenDesktopToAOD(): void {
    this.hide();
  }


  public doWhenScreenLockToAOD(): void {
    this.initScreenLock();
  }

  private initScreenLock(): void {
    this.aniConf.setScale(1);
    this.aniConf.setAlpha(1);
  }

  private hide(): void {
    if (this.elemType === MirrorElemType.Mirror_LOCK_ICON) {
      this.aniConf.setScale(0.7);
    } else {
      this.aniConf.setScale(0);
    }
    this.aniConf.setAlpha(0);
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
    this.initScreenLock();
  }
}
