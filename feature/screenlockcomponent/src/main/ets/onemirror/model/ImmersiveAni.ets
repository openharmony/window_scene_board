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
import MirrorAniConfig from './MirrorAnimationConf';
import IMirrorToEnd from './IMirrorToEnd';
import { ImmersiveAodStyle, immersiveKgMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sSCBOobeManager } from '@ohos/windowscene';
import IAodProxy from '../model/IAodProxy';
import MirrorAnimationUtil from '../utils/MirrorAnimationUtil';

const TAG = 'ImmersiveAni';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ImmersiveAni implements IMirrorToEnd {
  private aniConf: MirrorAniConfig;
  private aodProxy: IAodProxy;
  private aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);

  public constructor(aniConf: MirrorAniConfig, aodProxy: IAodProxy) {
    this.aniConf = aniConf;
    this.aodProxy = aodProxy;
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
  }

  public doWhenScreenLockToAOD(): void {
    this.hide();
  }

  private initScreenLock(): void {
    if (!this.aodStyle) {
      log.showWarn('immersive one mirror initScreenLock failed.');
      return;
    }
    if (!this.aodStyle.isAod) {
      return;
    }
    log.showInfo('immersive one mirror set aod to false.');
    this.aodStyle.isAod = false;
  }

  private hide(): void {
    // Oobe阶段禁止进入AOD
    if (sSCBOobeManager.isOobeActivated() || !this.aodProxy?.isAODEnable()) {
      return;
    }
    if (!this.aodStyle) {
      log.showWarn('immersive one mirror hide failed.');
      return;
    }
    if (this.aodStyle.isAod) {
      return;
    }
    log.showInfo('immersive one mirror set aod to true.');
    this.aodStyle.isAod = true;
  }

  public doWhenAODToDesktop(): void {
    this.initScreenLock();
  }

  public doWhenAODToScreenLock(): void {
  }

  public doWhenAODSCL2AOD(): void {
  }

  doWhenOffScreen2ScreenLockEnd(): void {
    this.initScreenLock();
  }

  doWhenOffScreen2ScreenLockBegin(): void {
    this.hide();
  }
}
