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
import {
  SingletonHelper,
  LogDomain,
  LogHelper,
  TraceUtil,
  DomainName,
  AppStorageUtil,
  DataProperty
} from '@ohos/basicutils';
import Constants from '../common/Constants';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ScreenSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenSessionAdapter';
import { PromptAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/PromptAdapter';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { SceneSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/SceneSessionAdapter';
import { EvtBus, EventManager, MultiWindowRotateChangeEvent } from '@ohos/frameworkwrapper';

const TAG = 'Model.AutoRotateController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class AutoRotateController extends ToggleBaseViewModel {
  private lockTemporarily: boolean = false;
  private eventManager: EventManager = EvtBus.createEventManager();

  constructor() {
    super();
    this.getViewData().icon = $r('app.media.ic_controlcenter_rotate_lock_off');
    this.getViewData().label = $r('app.string.control_center_complex_toggle_auto_rotate_title')
    this.onStart();
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): AutoRotateController {
    return SingletonHelper.getInstance(AutoRotateController, TAG);
  }

  getLottieOpenDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  getLottieCloseDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
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

  getLottieDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  isLoadLottie(): boolean {
    return true;
  }

  isDarkReverse(): boolean {
    return true;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    AppStorageUtil.setOrCreate('AutoRotateModel_AutoRotateStatus', this.getViewData(), new DataProperty(true, false));
    this.handleUpdateState();
    this.eventManager.on(MultiWindowRotateChangeEvent, this.updateRotateState);
  }

  public updateRotateState = (event: MultiWindowRotateChangeEvent): void => {
    let isRotateUnavailable = event.isRotateUnavailable;
    if (this.getViewData().isUnavailable !== isRotateUnavailable) {
      this.getViewData().isUnavailable = isRotateUnavailable;
    }
    log.showInfo(`updateRotateState, isUnavailable: ${this.getViewData().isUnavailable}`);
  }

  updateIcon(): void {
    this.getViewData().icon = this.getViewData().isOn ? $r('app.media.ic_controlcenter_rotate_lock_off') : $r('app.media.ic_controlcenter_rotate_lock_on');
  }

  onStop(): void {
    super.onStop();
    this.eventManager.offAll();
    log.showInfo('onStop');
  }

  onSetEnable(enable: boolean): void {
    this.getViewData().isUnavailable = !enable;
    log.showInfo(`onSetEnable:${enable}`);
  }

  addStateChangedListener(): void {
  }
  removeStateChangedListener(): void {
  }

  async handleUpdateState(): Promise<void> {
    let isLocked = await ScreenSessionAdapter.getScreenOrientationLocked();
    this.getViewData().isOn = isLocked;
    this.updateIcon();
    log.showInfo(`handleUpdateState, isScreenRotationLocked: ${this.getViewData().isOn}`);
  }

  isAvailable(): boolean {
    return true;
  }

  async handleOneClick(): Promise<void> {
    log.showInfo(`handleClick, current status: ${this.getViewData().isOn}`);
    if (this.getViewData().isUnavailable) {
      try {
        let isMultiWinPcMode: boolean = await SceneSessionAdapter.isPcMode();
        if (isMultiWinPcMode) {
          PromptAdapter.showToast(ResUtils.getInnerString($r('app.string.multi_window_opened')));
        }
        log.showInfo(`handleClick, auto rotate disabled`);
        return;
      } catch (err) {
        log.showError(`handleClick failed, err code: ${err?.code}, msg: ${err?.message}`);
      }
    }
    ScreenSessionAdapter.setIsRestoreRotation(false);
    if (this.getViewData().isOn) {
      // status true means icon is on, rotate is locked, next click should unlock, set false
      ScreenSessionAdapter.setScreenOrientationLocked(false);
    } else {
      ScreenSessionAdapter.setScreenOrientationLocked(true);
    }
    this.getViewData().isOn = !this.getViewData().isOn;
    this.updateIcon();
  }

  async lockRotationTemporarily(): Promise<void> {
    TraceUtil.startTrace(DomainName.CC, 'lockRotationTemporarily');
    if (!this.getViewData().isOn) {
      this.lockTemporarily = true;
      ScreenSessionAdapter.setScreenOrientationLocked(true);
    }
    TraceUtil.endTrace(DomainName.CC, 'lockRotationTemporarily');
  }

  async restoreAutoRotation(): Promise<void> {
    TraceUtil.startTrace(DomainName.CC, 'restoreAutoRotation');
    if (this.lockTemporarily) {
      ScreenSessionAdapter.setScreenOrientationLocked(false);
      this.lockTemporarily = false;
    }
    TraceUtil.endTrace(DomainName.CC, 'restoreAutoRotation');
  }

  isLockedTemporarily(): boolean {
    return this.lockTemporarily;
  }
}

let sAutoRotateController = SingletonHelper.getInstance(AutoRotateController, TAG);

export default sAutoRotateController as AutoRotateController;