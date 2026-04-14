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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sSCBOobeManager } from '@ohos/windowscene';

const TAG = 'ImmersiveAni';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ImmersiveAni implements IMirrorToEnd {
  private aniConf: MirrorAniConfig;

  public constructor(aniConf: MirrorAniConfig) {
    this.aniConf = aniConf;
  }

  elemType?: number | undefined;

  doWhenAODToDesktop(): void {
    throw new Error('Method not implemented.');
  }

  doWhenAODToScreenLock(): void {
    throw new Error('Method not implemented.');
  }

  doWhenAODSCL2AOD(): void {
    throw new Error('Method not implemented.');
  }

  doWhenOffScreen2ScreenLockEnd(): void {
    throw new Error('Method not implemented.');
  }

  public doWhenBeginSleep(): void {
    this.hide();
  }

  public doWhenEndScreenOn(): void {
  }

  public doWhenOffScreen(): void {
    this.hide();
  }

  public doWhenOnScreen(): void {
    this.hide();
  }

  public doWhenDesktopToAOD(): void {
  }

  public doWhenScreenLockToAOD(): void {
    this.hide();
  }

  private hide(): void {
    // Oobe阶段禁止进入AOD
    if (sSCBOobeManager.isOobeActivated()) {
      return;
    }
  }

  doWhenOffScreen2ScreenLockBegin(): void {
    this.hide();
  }
}
