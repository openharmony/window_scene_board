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

import {
  SingletonHelper,
  LogDomain,
  LogHelper,
  DataProperty,
  AppStorageUtil
} from '@ohos/basicutils';
import {
  PluginSlot,
  EvtBus,
  PluginRequestEvent,
  DeviceHelper,
  sEventManager,
  obtainStartAbilityWithWant,
} from '@ohos/frameworkwrapper';
import { ExtAppConstants } from '@ohos/commonconstants';
import nfcManager from '@ohos.nfc.controller';
import Constants from '../common/Constants';
import taskpool from '@ohos.taskpool';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { StatusBarExceptionCode } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarExceptionCode';
import { EdmAdminManager } from '@ohos/systemuicommon/src/main/ets/manager/EdmAdminManager';

// instrument ignore file
const TAG: string = 'Model.NfcController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const ISWAIT_CLEAR_TIMEOUT: number = 2000;
const PERSIST_EDM_NFC_CONFIG: string = 'persist.edm.nfc_disable';

export class NfcController extends ToggleBaseViewModel {
  private isWaitingLastActionDone: boolean = false;
  private mdName: string | undefined = DeviceHelper.isPC() ? undefined : 'phone_settings';
  private callbackTimeoutTimeId: number = -1;

  constructor() {
    super();
    this.getViewData().label = $r('app.string.control_center_complex_toggle_nfc_mode_title');
    this.getViewData().icon = $r('app.media.ic_notification_nfc_filled');
    this.onStart();
  }

  public static getInstance(): NfcController {
    return SingletonHelper.getInstance(NfcController, TAG);
  }

  isPersist(): boolean {
    return true;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    AppStorageUtil.setOrCreate('NfcModel_NfcStatus', this.getViewData(), new DataProperty(true, false));
    this.viewData = AppStorage.get<ToggleViewData>('NfcModel_NfcStatus') as ToggleViewData;
    if (DeviceHelper.isEmulator()) {
      log.showInfo('Disable the NFC on the simulator');
      this.getViewData().isUnavailable = true;
      return;
    }
    this.updateDisableState();
    if (!this.isAvailable()) {
      log.showWarn('nfc is not available');
      return;
    }

    let state: nfcManager.NfcState = nfcManager.getNfcState();
    this.onNfcStateChange(state);
    nfcManager.on('nfcStateChange', (state: nfcManager.NfcState) => {
      this.onNfcStateChange(state);
    });
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    if (!this.isAvailable()) {
      log.showWarn('nfc is not available');
      return;
    }
    nfcManager.off('nfcStateChange');
  }

  isLoadLottie(): boolean {
    return true;
  }

  getLottieOpenDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getLottieCloseDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  getLottieOpenName(): string {
    return Constants.LOTTIE_DATA_OPEN;
  }

  getLottieCloseName(): string {
    return Constants.LOTTIE_DATA_CLOSE;
  }

  getNewLottieOpenName(): string {
    return Constants.NEW_LOTTIE_DATA_OPEN;
  }

  getNewLottieCloseName(): string {
    return Constants.NEW_LOTTIE_DATA_CLOSE;
  }

  /**
   * NFC图标标示
   */
  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_NFC;
  }

  addStateChangedListener(): void {
  }

  removeStateChangedListener(): void {
  }

  private onNfcStateChange(state: nfcManager.NfcState): void {
    log.showWarn(`on nfc state change: ${state} isWaitingLastActionDone ${this.isWaitingLastActionDone}`);
    if (state !== nfcManager.NfcState.STATE_ON && state !== nfcManager.NfcState.STATE_OFF) {
      return;
    }
    let newState: boolean = (state === nfcManager.NfcState.STATE_ON);
    // 状态栏nfc图标展示隐藏处理
    this.handleStatusBarState(newState);
    if (this.isWaitingLastActionDone) {
      this.isWaitingLastActionDone = false;
      clearTimeout(this.callbackTimeoutTimeId);
      if (newState !== this.getViewData().isOn) {
        this.switchNfcState(this.getViewData().isOn);
      }
      return;
    }
    this.getViewData().isOn = newState;
  }

  /**
   * 状态栏nfc状态控制处理方法
   * @param newState
   */
  private handleStatusBarState(newState: boolean): void {
    let oldState = this.sbPluginRequest.isVisible();
    if (oldState !== newState) {
      // 更新图标可见性
      log.showInfo(`status bar status change, newState: ${newState}, oldState: ${oldState}`);
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }

  isAvailable(): boolean {
    return canIUse('SystemCapability.Communication.NFC.Core') && nfcManager.getNfcState !== undefined;
  }

  handleOneClick(): void {
    log.showInfo(`handleClick, status: ${this.getViewData().isOn}, waiting: ${this.isWaitingLastActionDone}`);
    if (this.getViewData().isUnavailable) {
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_NFC_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      log.showWarn('nfc disabled');
      return;
    }
    this.handleClickWithScreenLock(():void => this.updateNfc());
  }

  private updateNfc(): void {
    this.getViewData().isOn = !this.getViewData().isOn;
    if (!this.isWaitingLastActionDone) {
      this.isWaitingLastActionDone = true;
      this.handleCallbackTimeout();
      this.switchNfcState(this.getViewData().isOn);
    }
  }

  private switchNfcState(isOn: boolean): void {
    log.showInfo('switchNfcState start');
    taskpool.execute(switchNfc, isOn).then(result => {
      log.info(`switchNfc to ${isOn}, result: ${result}`);
      if (result !== 0) {
        this.isWaitingLastActionDone = false;
        this.onNfcStateChange(nfcManager.NfcState.STATE_OFF);
      }
    }).catch((err: Error) => {
      LogWithHa.error(log, `switchNfcState error`, StatusBarExceptionCode.NFC_FAIL, err, TAG);
    });
  }

  /**
   * 更新快捷开关的置灰状态
   */
  updateDisableState(): void {
    if (DeviceHelper.isEmulator() || !EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_NFC_CONFIG)) {
      this.getViewData().isUnavailable = true;
    } else {
      this.getViewData().isUnavailable = false;
    }
    log.showInfo(`updateDisableState isUnavailable: ${this.getViewData().isUnavailable}`);
  }

  private updateNfcState(nfcState: nfcManager.NfcState): void {
    let newNfcState: boolean = nfcState === nfcManager.NfcState.STATE_ON ? true : false;
    if (this.getViewData().isOn !== newNfcState) {
      log.showInfo(`NfcState change status oldNfcState:${newNfcState},newNfcState:${this.getViewData().isOn}`);
      this.switchNfcState(this.getViewData().isOn);
    }
  }

  private handleCallbackTimeout(): void {
    if (this.callbackTimeoutTimeId !== -1) {
      clearTimeout(this.callbackTimeoutTimeId);
      this.callbackTimeoutTimeId = -1;
    }
    this.callbackTimeoutTimeId = setTimeout(() => {
      log.showInfo('reset wait action flag');
      this.isWaitingLastActionDone = false;
      try {
        this.updateNfcState(nfcManager.getNfcState());
      } catch (err) {
        LogWithHa.error(log, `getNfc switch status failed: ${err?.message}`, StatusBarExceptionCode.NFC_FAIL, err, TAG);
      }
      this.callbackTimeoutTimeId = -1;
    }, ISWAIT_CLEAR_TIMEOUT);
  }

}

function switchNfc(isOn: boolean): number {
  'use concurrent';
  try {
    if (isOn) {
      nfcManager.enableNfc();
    } else {
      nfcManager.disableNfc();
    }
    return 0;
  } catch (err) {
    return err?.code;
  }
}

let sNfcController: NfcController = SingletonHelper.getInstance(NfcController, TAG);

export default sNfcController as NfcController;