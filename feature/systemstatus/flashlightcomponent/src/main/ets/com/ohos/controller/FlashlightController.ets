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
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import {
  DeviceHelper,
  GlobalContext,
  HiDfxEventUtil,
  EvtBus
} from '@ohos/frameworkwrapper';
import { FASlotName } from '@ohos/commonconstants';
import type featureAbility from '@ohos.ability.featureAbility';
import { FlashlightTipsUtil } from '@ohos/screenlockcommon/src/main/ets/utils/FlashlightTipsUtil';
import camera from '@ohos.multimedia.camera';
import parameter from '@ohos.systemParameterEnhance';
import Constants from '../common/Constants';
import commonEvtMgr from '@ohos.commonEventManager';
import { batteryInfo } from '@kit.BasicServicesKit';
import { promptAction } from '@kit.ArkUI';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import type { CommonEventData } from 'commonEvent/commonEventData';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { FlashlightLiveEvent } from '@ohos/systemuicommon';
import { FlashlightLiveManager } from '../manager/FlashlightLiveManager'

const TAG: string = 'Ctrl.FlashlightController';
const TORCH_MODE_ON: number = 1;
const TORCH_MODE_OFF: number = 0;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const TIME_OUT_DURATION: number = 5000;
const LOW_BATTERY_LIMIT: number = 6;

export class FlashlightController extends ToggleBaseViewModel {
  private isWaitingLastActionDone: boolean = false;
  private mCameraManager: camera.CameraManager | undefined = undefined;
  private isControlCenterVisible: boolean = false;
  private isBatteryLowerThreshold: boolean = false;
  private isTorchAvailable: boolean = true;
  private mSubscriber: CommonEventSubscriber | null = null;
  private readonly SYSTEM_COMMON_EVENTS: commonEvtMgr.CommonEventSubscribeInfo = {
    events: [
      commonEvtMgr.Support.COMMON_EVENT_BATTERY_CHANGED,
    ]
  };
  private mFlashlightDataCache: ToggleViewData = new ToggleViewData();

  constructor() {
    super();
    this.getViewData().icon = $r('app.media.ic_flashlight_off');
    this.getViewData().label = $r('app.string.control_center_complex_toggle_flashlight_title');
    this.onStart();
    FlashlightLiveManager.get().init();
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): FlashlightController {
    let controller: FlashlightController = SingletonHelper.getInstance(FlashlightController, TAG);
    return controller;
  }

  updateIcon(): void {
    // this.getViewData().isUnavailable || !this.getViewData().isOn
    if (!this.getViewData().isOn) {
      this.getViewData().icon = $r('app.media.ic_flashlight_off');
    } else {
      this.getViewData().icon = $r('app.media.ic_flashlight_on');
    }
  }

  getLottieOpenDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getLottieCloseDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  getNewLottieOpenName(): string {
    return Constants.NEW_LOTTIE_DATA_OPEN;
  }

  getNewLottieCloseName(): string {
    return Constants.NEW_LOTTIE_DATA_CLOSE;
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
    if (DeviceHelper.isEmulator()) {
      log.showInfo('Disable the Flashlight on the simulator');
      this.getViewData().isUnavailable = true;
      this.updateIcon();
      return;
    }

    if (!this.isAvailable()) {
      log.showError('current device is not support flashlight');
      return;
    }

    setTimeout(() => {
      this.initFlashlight();
    }, TIME_OUT_DURATION);

    if (batteryInfo.batterySOC < LOW_BATTERY_LIMIT) {
      this.isBatteryLowerThreshold = true;
      this.setLowBatteryFlashlightStatus();
    }
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    if (!this.isAvailable()) {
      log.showError('current device is not support flashlight');
      return;
    }
    // 注销
    try {
      this.mCameraManager?.off('torchStatusChange');
      if (this.mSubscriber) {
        commonEvtMgr.unsubscribe(this.mSubscriber);
        this.mSubscriber = null;
      }
    } catch (err) {
      log.error('unsubscribe failed:', err);
    }
  }

  handleUpdateState(): void {
  }

  isAvailable(): boolean {
    try {
      let supportFlashlight: boolean = parameter.getSync('const.sceneboard.support_flashlight', 'true') === 'true';
      log.showInfo(`isAvailable supportFlashlight:${supportFlashlight}`);
      return canIUse('SystemCapability.Multimedia.Camera.Core') && supportFlashlight;
    } catch (err) {
      log.showError(`isAvailable err:${err}`);
      return false;
    }
  }

  handleOneClick(): void {
    // 需要实现UI点亮功能
    this.getViewData().isOn = !this.getViewData().isOn
    log.showInfo(`handleClick, status: ${this.getViewData().isOn}, waiting:${this.isWaitingLastActionDone}, unavailable:${this.getViewData().isUnavailable}`);
    this.updateIcon();
    // if (this.getViewData().isUnavailable) {
    //   log.showWarn('unavailable');
    //   if (this.isBatteryLowerThreshold) {
    //     this.lowBatteryShowToast();
    //   }
    //   return;
    // }
    // // 如果是扩展新形态小折叠产品折叠外屏状态则进入提示页
    // if (FlashlightTipsUtil.isOpenFlashlightTips(!this.getViewData().isOn)) {
    //   log.showInfo('open external screen flashlight tips page');
    //   FlashlightTipsUtil.showFlashlightTipsPage();
    // } else {
    //   if (!this.getViewData().isOn) {
    //     this.postFlashlightLiveEvent(true);
    //   }
    //   this.setFlashlightDataStatus(!this.getViewData().isOn);
    //   if (!this.isWaitingLastActionDone) {
    //     this.isWaitingLastActionDone = true;
    //     this.switchFlashlightStatus(this.getViewData().isOn);
    //   }
    // }
  }

  private initFlashlight(): void {
    log.info('initFlashlight');
    try {
      this.mCameraManager = camera.getCameraManager(GlobalContext.getInstance().getObject('desktopContext') as featureAbility.Context);
      if (!this.mCameraManager) {
        log.error('get camera manager failed');
        return;
      }
      this.setFlashlightDataStatus(this.mCameraManager.getTorchMode() === TORCH_MODE_ON);
      this.setFlashlightDataIsUnAvailable(false);
      this.mCameraManager.on('torchStatusChange', (err, status) => {
        if (err) {
          log.error('torchStatusChange err:', err);
        } else {
          this.onFlashlightStateChange(status);
        }
      });
      // 订阅电量变化事件
      this.createSubscriberBatteryChanged();
    } catch (err) {
      log.error('initFlashlight failed:', err);
    }
  }

  private createSubscriberBatteryChanged(): void {
    try {
      commonEvtMgr.createSubscriber(this.SYSTEM_COMMON_EVENTS).then((subscriber) => {
        log.showInfo('init createSubscriber end');
        this.mSubscriber = subscriber;
        this.subscribeBatteryChanged(subscriber);
      });
    } catch (error) {
      log.showError('createSubscriber error');
    }
  }

  private subscribeBatteryChanged(subscriber: CommonEventSubscriber): void {
    try {
      commonEvtMgr.subscribe(subscriber, (err: object | undefined, data: CommonEventData) => {
        if (err) {
          log.showError(`Can't handle common event, err: ${err}`);
          return;
        }
        log.showInfo(`receive event data:${data?.event}`);
        this.handleBatteryChangedEvent(data);
      });
    } catch (error) {
      log.showError('subscribe error');
    }
  }

  private handleBatteryChangedEvent(data: CommonEventData): void {
    let currentBatterySoc: number = data.parameters?.soc;
    if (currentBatterySoc !== undefined) {
      // 电量不大于 5% 时禁用手电筒
      this.isBatteryLowerThreshold = currentBatterySoc < LOW_BATTERY_LIMIT;
      log.showInfo(`currentBatterySoc: ${currentBatterySoc}, isBatteryLowerThreshold: ${this.isBatteryLowerThreshold}`);
      this.setLowBatteryFlashlightStatus();
    }
  }

  private setLowBatteryFlashlightStatus(): void {
    if (this.isBatteryLowerThreshold) {
      this.switchFlashlightStatus(false);
    }
    this.setFlashlightDataIsUnAvailable(this.isBatteryLowerThreshold || !this.isTorchAvailable);
  }

  private lowBatteryShowToast(): void {
    promptAction.showToast({
      message: $r('app.string.ic_tools_disable_battery_low'),
      showMode: promptAction.ToastShowMode.SYSTEM_TOP_MOST
    });
  }

  private switchFlashlightStatus(isOn: boolean): void {
    try {
      this.mCameraManager?.setTorchMode(isOn ? TORCH_MODE_ON : TORCH_MODE_OFF);
    } catch (err) {
      log.error(`switchFlashlightStatus to ${isOn} failed: `, err);
      this.isWaitingLastActionDone = false;
      this.setFlashlightDataStatus(false);
    }
  }

  private onFlashlightStateChange(state: camera.TorchStatusInfo): void {
    log.showInfo('onFlashlightStateChange, waiting: %{public}s, old:%{public}s/%{public}s, ' +
      'new:%{public}s/%{public}s, cache:%{public}s/%{public}s, level:%{public}d', this.isWaitingLastActionDone,
      this.getViewData().isOn, this.getViewData().isUnavailable, state.isTorchActive, !state.isTorchAvailable,
      this.mFlashlightDataCache.isOn, this.mFlashlightDataCache.isUnavailable, state.torchLevel
    );

    this.isTorchAvailable = state.isTorchAvailable;
    if (!state.isTorchActive) {
      // 监听手电筒关闭
      this.postFlashlightLiveEvent(false);
    }
    this.setFlashlightDataIsUnAvailable(!state.isTorchAvailable);
    if (this.isWaitingLastActionDone && state.isTorchAvailable) {
      this.isWaitingLastActionDone = false;
      if (this.getViewData().isOn !== state.isTorchActive) {
        this.switchFlashlightStatus(this.getViewData().isOn);
      }
      return;
    }

    this.isWaitingLastActionDone = false;
    this.setFlashlightDataStatus(state.isTorchActive);
  }

  /**
   * 发布通知
   */
  private async postFlashlightLiveEvent(status: boolean | string): Promise<void> {
    log.showInfo(`postFlashlightLiveEvent start`);
    let state: boolean = false;
    if ((typeof status === 'boolean' && status) || typeof status === 'string' && status === 'true') {
      state = true;
    }
    let event = new FlashlightLiveEvent();
    event.isOn = state;
    EvtBus.post(FlashlightLiveEvent, event);
  };

  private setFlashlightDataStatus(status: boolean): void {
    if (this.isControlCenterVisible) {
      this.getViewData().isOn = status;
      this.updateIcon();
      this.mFlashlightDataCache.isOn = status;
    } else {
      this.mFlashlightDataCache.isOn = status;
    }
    log.showInfo(`setFlashlightDataStatus visible:${this.isControlCenterVisible}, status:${status}`);
  }

  private setFlashlightDataIsUnAvailable(value: boolean): void {
    let isUnavailable: boolean = this.isBatteryLowerThreshold ? this.isBatteryLowerThreshold : value;
    if (this.isControlCenterVisible) {
      this.getViewData().isUnavailable = isUnavailable;
      this.updateIcon();
      this.mFlashlightDataCache.isUnavailable = isUnavailable;
    } else {
      this.mFlashlightDataCache.isUnavailable = isUnavailable;
    }
    log.showInfo(`setFlashlightDataIsUnAvailable visible:${this.isControlCenterVisible}, value:${isUnavailable}`);
  }

  public setControlCenterVisible(isVisible: boolean): void {
    this.isControlCenterVisible = isVisible;
  }
  public updateUIFromCache(): void {
    this.getViewData().isUnavailable = DeviceHelper.isEmulator() || this.mFlashlightDataCache.isUnavailable;
    //this.getViewData().isOn = this.mFlashlightDataCache.isOn;
    this.updateIcon();
    log.showInfo(`updateUIFromCache: ${this.getViewData().isUnavailable}, ${this.getViewData().isOn}`);
  }

  /**
   * get flash light switch state
   *
   * @param isOpen intent type
   * @returns flash light switch state
   */
  public getSwitchAvailable(isOpen: boolean): number {
    return this.mFlashlightDataCache.isUnavailable ?
      (isOpen ? Constants.FLASH_LIGHT_UNAVAILABLE_OPEN : Constants.FLASH_LIGHT_UNAVAILABLE_CLOSE) : 0;
  }

  /**
   * set flash light switch state
   *
   * @param value flash light switch state
   * @returns is success
   */
  public setSwitchState(value: boolean | string): boolean {
    try {
      if (this.mCameraManager === undefined) {
        this.mCameraManager = camera.getCameraManager(GlobalContext.getInstance().getObject('desktopContext') as featureAbility.Context);
      }
      log.showInfo(`setSwitchState: ${value}`);
      this.postFlashlightLiveEvent(value);
      if (typeof value === 'boolean') {
        this.mCameraManager.setTorchMode(value ? TORCH_MODE_ON : TORCH_MODE_OFF);
        // 上报开关响应语音助手事件
        HiDfxEventUtil.reportToggleClick(FASlotName.FLASHLIGHT, HiDfxEventUtil.TOGGLE_TYPE_INTENT);
        return true;
      } else if (typeof value === 'string') {
        this.mCameraManager.setTorchMode(value === 'true' ? TORCH_MODE_ON : TORCH_MODE_OFF);
        // 上报开关响应语音助手事件
        HiDfxEventUtil.reportToggleClick(FASlotName.FLASHLIGHT, HiDfxEventUtil.TOGGLE_TYPE_INTENT);
        return true;
      } else {
        log.error(`setForAll error: not supported type`);
        return false;
      }
    } catch (err) {
      log.error(`switchFlashlightStatus to ${value} failed: `, err);
      return false;
    }
  }
}
