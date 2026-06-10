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
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { AppStorageUtil, LogDomain, LogHelper } from '@ohos/basicutils';
import {
    GlobalStatusCache,
    KeyGuardMode, KeyguardStatusService
} from '@ohos/screenlockcommon';
import { SettingsDBMonitor } from '@ohos/screenlockcomponent/src/main/ets/monitor/SettingsDBMonitor';
import { LostModeConstants, SpecialModeViewData } from '../model/SpecialModeViewData';
import { DesktopModeEnum, DesktopModeManager } from '@ohos/launchercommon/src/main/ets/TsIndex';

const TAG = 'ScreenLock-SpecialModeViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class SpecialModeViewModel {
  protected static specialModeViewModel: SpecialModeViewModel;
  public specialViewData: SpecialModeViewData;
  private desktopMode: DesktopModeEnum = DesktopModeEnum.BASE_MODE;

  constructor(data: SpecialModeViewData) {
    this.specialViewData = data;
    this.initLostModeData();
    this.registerDesktopModeChange();
  }

  initLostModeData(): void {
    log.showInfo('SpecialModeViewModel initData=' + this.specialViewData);
    if (this.specialViewData == undefined) {
      return;
    }
    // 数据监听
    let lockState: string = sSettingsUtil.getSecureValue(LostModeConstants.LOCK_STATE_KEY.split('|')[0],
      LostModeConstants.LOCK_STATE_DEFAULT_VALUE);
    let lockStatusStr: string = sSettingsUtil.getSecureValue(LostModeConstants.LOCK_INFO_KEY.split('|')[0],
      LostModeConstants.LOCK_INFO_DEFAULT_VALUE);
    let curState = lockState === LostModeConstants.LOCK_STATE_OPEN_VALUE;
    this.specialViewData.lastModeData.isLostMode = curState;
    this.specialViewData.lastModeData.lostModeLockedInfo = lockStatusStr;
    SettingsDBMonitor.getInstance().subscribe(LostModeConstants.LOCK_STATE_KEY, () => this.onLostModeDataChange());
    SettingsDBMonitor.getInstance().subscribe(LostModeConstants.LOCK_INFO_KEY, () => this.onLostModeDataChange());
    SettingsDBMonitor.getInstance().registerListener();
    GlobalStatusCache.getInstance().setStatus(LostModeConstants.LOCK_STATE_KEY, curState);
    GlobalStatusCache.getInstance().setStatus(LostModeConstants.LOCK_INFO_KEY,
      this.specialViewData.lastModeData.lostModeLockedInfo);
    this.updateLostModeView(curState);
  }

  onLostModeDataChange(): void {
    if (this.specialViewData == undefined) {
      return;
    }
    let lockStatusStr: string = sSettingsUtil.getSecureValue(LostModeConstants.LOCK_INFO_KEY.split('|')[0],
      LostModeConstants.LOCK_INFO_DEFAULT_VALUE);
    let lockState: string = sSettingsUtil.getSecureValue(LostModeConstants.LOCK_STATE_KEY.split('|')[0],
      LostModeConstants.LOCK_STATE_DEFAULT_VALUE);
    log.showInfo('LostModeViewModel onDataChange--value=' + lockState + ' == lockStatusStr=' + lockStatusStr);
    let curState = lockState === LostModeConstants.LOCK_STATE_OPEN_VALUE;
    this.specialViewData.lastModeData.isLostMode = curState;
    this.specialViewData.lastModeData.lostModeLockedInfo = lockStatusStr;
    GlobalStatusCache.getInstance().setStatus(LostModeConstants.LOCK_STATE_KEY, curState);
    GlobalStatusCache.getInstance().setStatus(LostModeConstants.LOCK_INFO_KEY,
      this.specialViewData.lastModeData.lostModeLockedInfo);
    this.updateLostModeView(curState);
  }

  /**
   * 注册热安全模式和紧急模式变化回调
   * @returns
   */
  public registerDesktopModeChange(): void {
    if (this.specialViewData == undefined) {
      return;
    }
    log.showInfo('register desktop mode change event');
    DesktopModeManager.getInstance()
      .registerModeChangeCallback('SCREENLOCK', async (preDesktopMode: DesktopModeEnum, targetDesktopMode: DesktopModeEnum) => {
        log.showInfo(`preDesktopMode:${preDesktopMode},targetDesktopMode:${targetDesktopMode}`);
        if (this.desktopMode == targetDesktopMode) {
          return;
        }
        this.desktopMode = targetDesktopMode;
        this.updateDesktopModeView(targetDesktopMode);
      });
  }

  updateLostModeView(curState: boolean): void {
    if (!this.specialViewData) {
      return;
    }
    log.showInfo('updateLostModeView: curState=' + curState);
    if (curState) {
      KeyguardStatusService.openMode(KeyGuardMode.LOST_MODE);
      this.specialViewData.curMode = KeyGuardMode.LOST_MODE;
      AppStorageUtil.setOrCreate('enableControllerCenter', false);
    } else {
      KeyguardStatusService.closeMode(KeyGuardMode.LOST_MODE);
      this.specialViewData.curMode = KeyGuardMode.DEFAULT;
      AppStorageUtil.setOrCreate('enableControllerCenter', true);
    }
  }

  updateDesktopModeView(mode: DesktopModeEnum): void {
    if (!this.specialViewData) {
      return;
    }
    if (KeyguardStatusService.isMode(KeyGuardMode.LOST_MODE)) {
      log.showInfo('updateDesktopModeView: cur is lostMode, desktopMode=' + mode);
      return;
    }
    log.showInfo('updateDesktopModeView: curmode=' + mode);
    if (mode === DesktopModeEnum.THERMAL_SAFE_MODE) {
      KeyguardStatusService.closeMode(KeyGuardMode.POWER_EMERGENCY);
      KeyguardStatusService.openMode(KeyGuardMode.THERMAL_SAFETY);
      this.specialViewData.curMode = KeyGuardMode.THERMAL_SAFETY;
    } else if (mode === DesktopModeEnum.EMERGENCY_MODE) {
      KeyguardStatusService.closeMode(KeyGuardMode.THERMAL_SAFETY);
      KeyguardStatusService.openMode(KeyGuardMode.POWER_EMERGENCY);
      this.specialViewData.curMode = KeyGuardMode.POWER_EMERGENCY;
    } else if (mode === DesktopModeEnum.BASE_MODE) {
      KeyguardStatusService.closeMode(KeyGuardMode.POWER_EMERGENCY);
      KeyguardStatusService.closeMode(KeyGuardMode.THERMAL_SAFETY);
      this.specialViewData.curMode = KeyGuardMode.DEFAULT;
    } else {
      KeyguardStatusService.openMode(KeyGuardMode.THERMAL_SAFETY);
      KeyguardStatusService.openMode(KeyGuardMode.POWER_EMERGENCY);
      this.specialViewData.curMode = KeyGuardMode.POWER_EMERGENCY;
    }
  }
}