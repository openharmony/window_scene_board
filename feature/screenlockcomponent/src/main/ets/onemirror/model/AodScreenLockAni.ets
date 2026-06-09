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

export default class AodScreenLockAni implements IMirrorToEnd {
  public aniConf: MirrorAniConfig;
  public elemType: number;
  private isBottomElem: boolean = false;

  public constructor(aniConf: MirrorAniConfig, elemType: number) {
    this.aniConf = aniConf;
    this.elemType = elemType;
    this.isBottomElem = this.elemType === MirrorElemType.Mirror_NOTIFICATION ||
      this.elemType === MirrorElemType.Mirror_AI_BAR;
  }

  public doWhenBeginSleep(): void {
    this.init();
  }

  public doWhenEndScreenOn(): void {
  }

  public doWhenOffScreen(): void {
    this.init();
  }

  public doWhenOnScreen(): void {
    this.init();
  }

  public doWhenDesktopToAOD(): void {
    this.aniConf.setScale(1.2);
    this.aniConf.setAlpha(0);
  }

  public doWhenScreenLockToAOD(): void {
    this.init();
  }

  private init(): void {
    this.aniConf.setScale(1);
    this.aniConf.setAlpha(1);
  }

  public doWhenAODToDesktop(): void {
  }

  public doWhenAODToScreenLock(): void {
  }

  public doWhenAODSCL2AOD(): void {
    this.aniConf.setScale(1.2);
    this.aniConf.setAlpha(0);
  }

  /**
   * 动效开始状态
   */
  public doWhenOffScreen2ScreenLockBegin(): void {
    if (this.isBottomElem) {
      this.aniConf.setScale(0.5);
    } else {
      this.aniConf.setScale(0.7);
    }
    this.aniConf.setAlpha(0);
  }

  /**
   * 动效结束状态
   */
  public doWhenOffScreen2ScreenLockEnd(): void {
    this.init();
  }
}
