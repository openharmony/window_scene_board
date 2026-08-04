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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  EventManager,
  EvtBus,
  obtainStartAbilityWithWant,
  PluginClickInfo,
  PluginInfo,
  PluginParseInfo,
  PluginPosition,
  PluginSlot,
  SCBWindowSceneConfig,
  sEventManager,
  WindowEvent,
  WindowPositionChangeEvent,
} from '@ohos/frameworkwrapper';
import lazy { SCBScreenSession } from '@ohos/windowscene/src/main/ets/screen/session/SCBScreenSession';
import lazy { StartAbilityUtil } from '@ohos/windowscene/src/main/ets/startAbility/StartAbilityUtil';
import lazy { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import lazy { SCBSceneSessionManager } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import { ExtAppConstants, SCBConstants } from '@ohos/commonconstants';
import lazy { PreShowEvent } from '@ohos/statusbarcomponent/src/main/ets/pc/utils/PreShowEvent';
import commonEvtMgr from '@ohos.commonEventManager';
import power from '@ohos.power';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import type { CommonEventData } from 'commonEvent/commonEventData';
import Constants from '../common/Constants';
import { RTLUtil } from '@ohos/componenthelper';
import { taskpool } from '@kit.ArkTS';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleScene, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ScreenSessionAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/ScreenSessionAdapter';

const TAG = 'Ctrl.PowerSavingToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const POWER_SAVE_MODE_INFO: commonEvtMgr.CommonEventSubscribeInfo = {
  events: [
    commonEvtMgr.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED,
  ]
};
const ISWAIT_CLEAR_TIMEOUT: number = 5000;

export class PowerSavingToggleController extends ToggleBaseViewModel {
  private mSubscriber: CommonEventSubscriber | null = null;
  private isWaitingLastActionDone: boolean = false;
  private callbackTimeoutTimeId: number = -1;
  private openLottie?: object;
  private mirrorOpenLottie?: object;
  private uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
  private evtMgr: EventManager = EvtBus.createEventManager();

  public startServiceFunc: (() => void) | undefined = () => {
    this.handleGoSettingWithScreenLock((): void => {
      this.goPowerModeSettings();
    })
  }

  constructor() {
    super();
    this.getViewData().label = $r('app.string.control_center_complex_toggle_powersaving_title');
    this.getViewData().isSymbolIcon = true;
    this.getViewData().icon = $r('sys.symbol.battery');
  }

  decorateStyle(style: ToggleStyle, scene?: ToggleScene | undefined): ToggleStyle | undefined {
    style.toggleParam?.isSupportRTL(true);
    return style;
  }

  setCustomCommonData(scene?: ToggleScene | undefined): void {
    if (scene === ToggleScene.PHONE) {
      // 不支持长按跳转和拉起二级界面
      this.customCommonData.isSupportLongClickAction = false;
    }
  }

  getLottieOpenDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getLottieCloseDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  getNewLottieCloseName(): string {
    return Constants.NEW_LOTTIE_DATA_CLOSE;
  }

  getNewLottieOpenName(): string {
    return Constants.NEW_LOTTIE_DATA_OPEN;
  }

  getMirrorLottieOpenName(): string {
    return Constants.LOTTIE_MIRROR_DATA_OPEN;
  }

  isLoadLottie(): boolean {
    return true;
  }

  initLottieData(): void {
    log.info(`initLottieData this.isAlreadyLoadLottie=${this.isAlreadyLoadLottie}`);
    if (this.isAlreadyLoadLottie) {
      return;
    }
    this.isAlreadyLoadLottie = true;
    this.loadLottieData(this.getNewLottieOpenName(), data => this.openLottie = data);
    this.loadLottieData(this.getMirrorLottieOpenName(), data => this.mirrorOpenLottie = data);
  }

  /**
   * 移除lottie缓存
   */
  removeAllLottieData(): void {
    log.showInfo('removeAllLottieData');
    this.openLottie = undefined;
    this.mirrorOpenLottie = undefined;
    this.isAlreadyLoadLottie = false;
  }

  matchLottieData(darkMode: boolean): object {
    return RTLUtil.isRTL() ? this.mirrorOpenLottie! : this.openLottie!;
  }

  isDarkReverse(): boolean {
    return true;
  }

  async onStart(): Promise<void> {
    super.onStart();
    log.info('onStart')
    this.createSubscribePowerSaveMode();
    // 初始化开关状态
    this.initPowerModeState();
  }

  /**
   * 窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    if (event.isWindowShow() && event.windowName === PluginSlot.SLOT_STATUS_CONTROL_CENTER) {
      let controlCenterPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
      if (!controlCenterPosition) {
        return
      }
      windowMgr.updateWindowPosition(PluginSlot.SLOT_STATUS_POWER_SAVING, {
        left: controlCenterPosition.left,
        top: controlCenterPosition.top,
        width: controlCenterPosition.width,
        // 避免当页面关闭又打开过快时导致窗口有一瞬间可视
        height: 0,
      });
      let preShowEvent: PreShowEvent = new PreShowEvent();
      preShowEvent.setValue(true);
      EvtBus.post(PreShowEvent, preShowEvent);
    } else if (event.isWindowHide() && (event.windowName === PluginSlot.SLOT_STATUS_POWER_SAVING ||
      event.windowName === PluginSlot.SLOT_STATUS_CONTROL_CENTER)) {
      log.showInfo('destroy power saving panel');
      let preShowEvent: PreShowEvent = new PreShowEvent();
      preShowEvent.setValue(false);
      EvtBus.post(PreShowEvent, preShowEvent);
    }
  }

  private createSubscribePowerSaveMode(): void {
    try {
      commonEvtMgr.createSubscriber(POWER_SAVE_MODE_INFO).then((subscriber) => {
        log.showInfo('init createSubscriber end');
        this.mSubscriber = subscriber;
        this.subscribePowerSaveMode(subscriber);
        // 省电模式订阅属于异步接口,等订阅完查询开关状态
        setTimeout(() => {
          this.initPowerModeState();
        }, ISWAIT_CLEAR_TIMEOUT);
      });
    } catch (error) {
      log.showError('createSubscriber error');
    }
  }

  private subscribePowerSaveMode(subscriber: CommonEventSubscriber) {
    try {
      commonEvtMgr.subscribe(subscriber, (err: object | undefined, data: CommonEventData) => {
        if (err) {
          log.error(`Can't handle common event, err: ${err}`);
          return;
        }
        log.showInfo(`receive event data:${data?.event}`);
        this.handleCommonEvent(data);
      });
    } catch (error) {
      log.showError('subscribe error');
    }
  }

  private handleCommonEvent(data: CommonEventData): void {
    if (!data) {
      return;
    }
    if (data.event === commonEvtMgr.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED) {
      log.showInfo(`handleCommonEvent data: ` + data.data)
      let powerSavingMode = Number(data.data) === Constants.MODE_POWER_SAVE ? true : false;
      if (!this.isWaitingLastActionDone) {
        this.getViewData().isOn = powerSavingMode;
        return;
      }
      this.isWaitingLastActionDone = false;
      // 状态不一致则需要改变底层状态
      if (powerSavingMode != this.getViewData().isOn) {
        this.switchPowerMode(!powerSavingMode);
      }
    }
  }

  private initPowerModeState(): void {
    this.getViewData().isOn = false;
    try {
      let powerMode: number = power.getPowerMode() as number;
      this.getViewData().isOn = powerMode === Constants.MODE_POWER_SAVE;
      log.showInfo(`onstart mPowerSavingData data: ${this.getViewData().isOn}`);
    } catch (error) {
      log.showError(`initPowerModeState failed, message is ${error?.message}`);
    }
  }


  onStop(): void {
    super.onStop();
    this.evtMgr.offAll();
    if (this.mSubscriber) {
      commonEvtMgr.unsubscribe(this.mSubscriber);
      this.mSubscriber = null;
    }
    log.showInfo('onStop');
  }

  isAvailable(): boolean {
    return true;
  }

  handleOneClick(): boolean {
    log.info('handleClick start');
    this.updatePowerModeData();
    return true;
  }

  private updatePowerModeData(): void {
    log.showInfo(`updatePowerModeData, old status: ${this.getViewData().isOn}`);
    this.getViewData().isOn = !this.getViewData().isOn;
    if (!this.isWaitingLastActionDone) {
      this.isWaitingLastActionDone = true;
      this.handleCallbackTimeout();
      this.switchPowerMode(this.getViewData().isOn);
    }
  }

  private switchPowerMode(isOn: boolean): void {
    taskpool.execute(switchPowerMode, isOn).then((result: Object) => {
      log.showInfo(`switchPowerMode result: ${result}`);
      if (result as number !== 0) {
        log.showWarn('switchPowerMode fail, set to false');
        this.isWaitingLastActionDone = false;
        this.getViewData().isOn = !this.getViewData().isOn;
      }
    });
  }

  private handleCallbackTimeout(): void {
    if (this.callbackTimeoutTimeId !== -1) {
      clearTimeout(this.callbackTimeoutTimeId);
    }
    this.callbackTimeoutTimeId = setTimeout(() => {
      log.showInfo('reset wait action flag');
      this.isWaitingLastActionDone = false;
      this.callbackTimeoutTimeId = -1;
    }, ISWAIT_CLEAR_TIMEOUT);
  }

  private goPowerModeSettings(): void {
    if (this.uiType === SCBConstants.UITYPE_PC) {
      StartAbilityUtil.startAbilityFromOther({
        bundleName: ExtAppConstants.PKG_PC_SETTINGS,
        abilityName: ExtAppConstants.ABILITY_PC_SETTINGS_AUDIO,
        uri: 'pc_powerandbattery_settings',
        moduleName: 'pc_settings'
      });
    } else {
      EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
        bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
        abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
        uri: 'battery',
        moduleName: 'phone_settings'
      }));
    }
  }
}

@Concurrent
async function switchPowerMode(isOn: boolean): Promise<number> {
  try {
    await power.setPowerMode(isOn ? power.DevicePowerMode.MODE_POWER_SAVE : power.DevicePowerMode.MODE_NORMAL);
    return 0;
  } catch (err) {
    return err?.code;
  }
}