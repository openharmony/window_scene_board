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

import sharing from '@ohos.net.sharing';
import commonEvtMgr from '@ohos.commonEventManager';
import call from '@ohos.telephony.call';
import wifiManager from '@ohos.wifiManager';
import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  EvtBus,
  obtainStartAbilityWithWant,
  sEventManager,
  PluginClickInfo,
  PluginRequestEvent,
  PluginSlot,
  sSettingsUtil,
} from '@ohos/frameworkwrapper';
import { ExtAppConstants, FASlotName } from '@ohos/commonconstants';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { EdmAdminManager } from '@ohos/systemuicommon/src/main/ets/manager/EdmAdminManager';
import { HotSpotAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/HotSpotAdapter';
import { LogWithHa, PluginWidthChangeEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ToggleScene, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import Constants, { HotSpotData } from '../common/Constants';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import type { CommonEventSubscribeInfo } from 'commonEvent/commonEventSubscribeInfo';
import type { CommonEventData } from 'commonEvent/commonEventData';
import StyleConfiguration, { StatusBarHotSpotComponentStyle } from '../common/StyleConfiguration';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { StatusBarExceptionCode } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarExceptionCode';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';

const TAG: string = 'Ctrl.HotSpotController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const AIRPLANE_MODE_STATUS_CLOSE: string = '0';
const ISWAIT_CLEAR_TIMEOUT: number = 5000;
const AIR_PLANE_MODE: string = 'settings.telephony.airplanemode';
const SUB_WINDOW_HEIGHT: number = 409;
const WIFI_CONN_SUCCESS: number = 4;
const WIFI_DISCONNECT: number = 6;
const PERSIST_EDM_HOTSPOT_CONFIG: string = 'persist.edm.tethering_disallowed';

const HOTSPOT_CHANGE_SUBSCRIBE_INFO: CommonEventSubscribeInfo = {
  events: [
    commonEvtMgr.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED, // 飞行模式变化
    commonEvtMgr.Support.COMMON_EVENT_WIFI_AP_STA_JOIN, // 热点接入
    commonEvtMgr.Support.COMMON_EVENT_WIFI_AP_STA_LEAVE, // 热点断开
    commonEvtMgr.Support.COMMON_EVENT_WIFI_CONN_STATE, // wifi链接状态变化
  ]
};

export class HotSpotController extends ToggleBaseViewModel {
  private mHotSpotData: HotSpotData = new HotSpotData();
  private isWaitingLastActionDone: boolean = false;
  private mSubscriber: CommonEventSubscriber | null = null;
  private mdName: string | undefined = DeviceHelper.isPC() ? undefined : 'phone_settings';
  private hasVoiceCapability: boolean = true;
  private callbackTimeoutTimeId: number = -1;
  private style: StatusBarHotSpotComponentStyle = StyleConfiguration.getStatusBarHotSpotComponentStyle();
  private pluginWidthChangeEvent = PluginWidthChangeEvent.create(this.getSbPluginSlot(),
    ResUtils.getNumberFromLength(this.style.statusBarHotSpotWidth));
  private sharingStateChangeCallback = (data: sharing.InterfaceSharingStateInfo) => {
    if (data.type === sharing.SharingIfaceType.SHARING_WIFI) {
      this.onHotSpotStateChange(data.state === sharing.SharingIfaceState.SHARING_NIC_SERVING);
    }
  };

  public openDetailPageFunc: (() => void) | undefined = (toggleId?: string) => {
    log.showInfo(`handleLongClick, toggleId: ${toggleId}`);
    if (this.getViewData().isUnavailable) {
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_HOTSPOT_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      log.showInfo('hotspot disabled');
      return;
    }
    if (this.customCommonData.scene === ToggleScene.PHONE) {
      this.handleOnControlCenterWithScreenLockForUIE((): void => {
        sToggleSubWindowController.showSubWindowByClickInfo(toggleId ?? FASlotName.HOTSPOT, {
          clickType: 'window',
          bundleName: 'com.ohos.settings',
          abilityName: 'HotspotExtensionAbility',
          uiExtensionType: 'sys/commonUI',
          windowHeight: SUB_WINDOW_HEIGHT
        } as PluginClickInfo);
      }, true);
    } else {
      this.handleGoSettingWithScreenLock((): void => {
        this.goHotSpotSettings();
      });
    }
  }

  constructor() {
    super();
    this.getViewData().label = $r('app.string.control_center_complex_toggle_hotspot_title');
    this.getViewData().isSymbolIcon = true;
    this.getViewData().icon = $r('sys.symbol.hotspot');
    this.onStart();
  }

  setCustomCommonData(scene?: ToggleScene | undefined): void {
    // 设置场景
    this.customCommonData.scene = scene;
  }

  decorateStyle(style: ToggleStyle): ToggleStyle {
    style.toggleParam?.hasSubLabel(true);
    style.toggleParam?.subLabelOpacity(ResUtils.getConvertNumber($r('app.float.Control_center_long_button_sub_label_opacity')));
    style.toggleParam?.subLabelMaxLines(1);
    return style;
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): HotSpotController {
    return SingletonHelper.getInstance(HotSpotController, TAG);
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

  getLottieDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  /**
   * 标示热点图标
   */
  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_HOT_SPOT;
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
      log.showInfo('Disable the HotSpot on the simulator');
      this.getViewData().isUnavailable = true;
      return;
    }

    if (!this.isAvailable()) {
      log.showError('current device is not support sharing');
      return;
    }

    this.initAirplaneState();
    this.subscribeHotspotChange();
    this.updateDisableState();

    try {
      sharing.isSharing().then((isSharing: boolean) => {
        this.getViewData().isOn = isSharing;
        this.handleStatusBarState(this.getViewData().isOn);
        this.getWifiAPConnectNum();
        this.updateSubLabel();
      }).catch((err: Error) => {
        LogWithHa.error(log, `call isSharing failed: message is ${err?.message}`, StatusBarExceptionCode.HOT_SPOT_FAIL,
          err, TAG);
      });
      HotSpotAdapter.registerInterfaceSharingStateChange({ callback: this.sharingStateChangeCallback },
        `${TAG}_registerInterfaceSharingStateChange`);
    } catch (err) {
      LogWithHa.error(log, `init sharing error: ${err?.message}`, StatusBarExceptionCode.HOT_SPOT_FAIL, err, TAG);
    }

    log.showInfo('onStart sharingStateChange done.');

    try {
      this.hasVoiceCapability = call.hasVoiceCapability();
    } catch (err) {
      LogWithHa.error(log, `getVoiceCapability error: ${err?.message}`, StatusBarExceptionCode.HOT_SPOT_FAIL, err, TAG);
    }
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    if (!this.isAvailable()) {
      log.showError('current device is not support sharing');
      return;
    }
    try {
      HotSpotAdapter.unRegisterInterfaceSharingStateChange({ callback: this.sharingStateChangeCallback },
        `${TAG}_unRegisterInterfaceSharingStateChange`);
      if (this.mSubscriber) {
        commonEvtMgr.unsubscribe(this.mSubscriber);
        this.mSubscriber = null;
      }
    } catch (error) {
      LogWithHa.error(log, `interfaceSharingStateChange unsubscribe error`, StatusBarExceptionCode.HOT_SPOT_FAIL, error,
        TAG);
    }
  }

  handleStatusBarState(newState: boolean): void {
    log.showInfo(`status bar status change, newState: ${newState}`);
    // 更新图标可见性
    if (this.sbPluginRequest.isVisible() !== newState) {
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
      // 如果是关闭热点，将连接数置零
      if (!newState) {
        this.mHotSpotData.connectNum = 0;
      }
    }
    this.updatePluginWidthChangeEvent();
  }

  getData(): HotSpotData {
    return this.mHotSpotData;
  }

  isAvailable(): boolean {
    return canIUse('SystemCapability.Communication.NetManager.NetSharing') && this.hasVoiceCapability;
  }

  /**
   * 是否需要监听卫星通信状态
   */
  needListenSatelliteMode(): boolean {
    return true;
  }

  handleOneClick(): void {
    log.showInfo(`handleClick, status: ${this.getViewData().isOn}, waiting: ${this.isWaitingLastActionDone}`);
    if (this.getViewData().isUnavailable) {
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_HOTSPOT_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      log.showInfo('hotspot disabled');
      return;
    }
    this.getViewData().isOn = !this.getViewData().isOn;
    if (!this.isWaitingLastActionDone) {
      this.isWaitingLastActionDone = true;
      this.handleCallbackTimeout();
      this.switchHotspotStatus(this.getViewData().isOn);
    }
  }

  private initAirplaneState(): void {
    let state = sSettingsUtil.getValue(AIR_PLANE_MODE, AIRPLANE_MODE_STATUS_CLOSE);
    log.showInfo(`initAirplaneState state = ${state}`);
    if (state !== AIRPLANE_MODE_STATUS_CLOSE) {
      this.mHotSpotData.isAirplaneMode = true;
      this.updateDisableState();
    }
  }

  private subscribeHotspotChange(): void {
    try {
      commonEvtMgr.createSubscriber(HOTSPOT_CHANGE_SUBSCRIBE_INFO).then((subscriber) => {
        log.showInfo('init createSubscriber end');
        this.mSubscriber = subscriber;
        commonEvtMgr.subscribe(subscriber, (err: BusinessError, data: CommonEventData) => {
          if (err) {
            LogWithHa.error(log, `Can't handle common event, err: ${err?.message}`,
              StatusBarExceptionCode.HOT_SPOT_FAIL, err, TAG);
            return;
          }
          log.showInfo(`receive event data:${data?.event}`);
          this.handleHotSpotChangeEvent(data);
        });
      });
    } catch (error) {
      LogWithHa.error(log, `subscribe airplane error`, StatusBarExceptionCode.HOT_SPOT_FAIL, error, TAG);
    }
  }

  handleHotSpotChangeEvent(data: CommonEventData): void {
    if (data && data.event === commonEvtMgr.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED) {
      log.showInfo('airplane mode status change ' + data?.event);
      this.handleAirplaneModeChange(data);
      return;
    } else if (data && data.event === commonEvtMgr.Support.COMMON_EVENT_WIFI_AP_STA_JOIN) {
      log.showInfo(`hotspot join status change ${data?.event}`);
      this.getWifiAPConnectNum();
      this.updateSubLabel();
      return;
    } else if (data && data.event === commonEvtMgr.Support.COMMON_EVENT_WIFI_AP_STA_LEAVE) {
      log.showInfo(`hotspot leave status change ${data?.event}`);
      this.getWifiAPConnectNum();
      this.updateSubLabel();
      return;
    } else if (data && data.event === commonEvtMgr.Support.COMMON_EVENT_WIFI_CONN_STATE) {
      log.showInfo(`handleHotSpotChangeEvent wifi state ：${data.code}`);
      if (data.code === WIFI_CONN_SUCCESS || data.code === WIFI_DISCONNECT) {
        this.updateDisableState();
      }
    }
  }

  private handleAirplaneModeChange(data: CommonEventData): void {
    if (String(data.code) === AIRPLANE_MODE_STATUS_CLOSE) {
      this.mHotSpotData.isAirplaneMode = false;
      this.updateDisableState();
    } else {
      this.mHotSpotData.isAirplaneMode = true;
      this.updateDisableState();
      try {
        if (!wifiManager.isOpenSoftApAllowed()) {
          this.onHotSpotStateChange(false);
        }
      } catch (error) {
        LogWithHa.error(log, `onHotSpotStateChange IsOpenSoftApAllowed failed: ${error?.message}`,
          StatusBarExceptionCode.HOT_SPOT_FAIL, error, TAG);
      }
    }
  }

  private getWifiAPConnectNum(): void {
    try {
      let stations = wifiManager.getStations();
      this.mHotSpotData.connectNum = stations.length;
      log.showInfo(`wifi AP connect number: ${this.mHotSpotData.connectNum}`);
      this.updatePluginWidthChangeEvent();
    } catch (error) {
      LogWithHa.error(log, `get connect number failed: ${error?.message}`, StatusBarExceptionCode.HOT_SPOT_FAIL, error,
        TAG);
    }
  }

  /**
   * 更新快捷开关的置灰状态
   */
  updateDisableState(): void {
    if (DeviceHelper.isEmulator() || this.isSatelliteMode ||
      !EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_HOTSPOT_CONFIG)) {
      this.getViewData().isUnavailable = true;
      log.showInfo(`updateDisableState isUnavailable: ${this.getViewData().isUnavailable}`);
      return;
    }
    if (this.mHotSpotData.isAirplaneMode) {
      try {
        let isInHotspotSupported: boolean = wifiManager.isOpenSoftApAllowed();
        if (!isInHotspotSupported) {
          this.getViewData().isUnavailable = true;
          this.getViewData().isOn = false;
          return;
        }
      } catch (error) {
        LogWithHa.error(log, `updateDisableState isOpenSoftApAllowed failed: ${error?.message}`,
          StatusBarExceptionCode.HOT_SPOT_FAIL, error, TAG);
      }
    }
    this.getViewData().isUnavailable = false;
    log.showInfo(`updateDisableState isUnavailable: ${this.getViewData().isUnavailable}`);
  }

  private switchHotspotStatus(isOn: boolean): void {
    if (isOn) {
      sharing.startSharing(sharing.SharingIfaceType.SHARING_WIFI).then(() => {
        log.showInfo('startSharing success');
      }).catch((err: Error) => {
        LogWithHa.error(log, `startSharing failed: ${err?.message}`, StatusBarExceptionCode.HOT_SPOT_FAIL, err, TAG);
        this.isWaitingLastActionDone = false;
        this.onHotSpotStateChange(false);
      });
    } else {
      sharing.stopSharing(sharing.SharingIfaceType.SHARING_WIFI).then(() => {
        log.showInfo('stopSharing success');
      }).catch((err: Error) => {
        LogWithHa.error(log, `stopSharing failed: ${err?.message}`, StatusBarExceptionCode.HOT_SPOT_FAIL, err, TAG);
        this.isWaitingLastActionDone = false;
        this.onHotSpotStateChange(false);
      });
    }
  }

  private onHotSpotStateChange(state: boolean): void {
    log.showWarn(`onHotSpotStateChange, waiting: ${this.isWaitingLastActionDone},new state:${state},\
      ui state:${this.getViewData().isOn}, disabled:${this.getViewData().isUnavailable}`);
    if (this.isWaitingLastActionDone) {
      // 更新状态栏热点样式
      this.handleStatusBarState(state);
      this.updateSubLabel();
      this.isWaitingLastActionDone = false;
      if (state !== this.getViewData().isOn) {
        this.switchHotspotStatus(this.getViewData().isOn);
      }
      return;
    }
    this.isWaitingLastActionDone = false;
    this.getViewData().isOn = state;
    // 更新状态栏热点样式
    this.handleStatusBarState(this.getViewData().isOn);
    this.updateSubLabel();
  }

  private updateSubLabel(): void {
    if (this.mHotSpotData.connectNum <= 0) {
      this.getViewData().subLabel = $r('app.string.control_center_complex_toggle_hotspot_no_device');
      return;
    }
    this.getViewData().subLabel = $r('app.plural.control_center_complex_toggle_hotspot_device_count',
      this.mHotSpotData.connectNum, this.mHotSpotData.connectNum);
  }

  private handleCallbackTimeout(): void {
    if (this.callbackTimeoutTimeId !== -1) {
      clearTimeout(this.callbackTimeoutTimeId);
      this.callbackTimeoutTimeId = -1;
    }
    this.callbackTimeoutTimeId = setTimeout(() => {
      log.showInfo('reset wait action flag');
      this.isWaitingLastActionDone = false;
      this.callbackTimeoutTimeId = -1;
    }, ISWAIT_CLEAR_TIMEOUT);
  }

  private goHotSpotSettings(): void {
    EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
      bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
      uri: 'hotspot_data_settings',
      moduleName: this.mdName
    }));
  }

  private updatePluginWidthChangeEvent(): void {
    if (this.sbPluginRequest.isVisible() && this.mHotSpotData.connectNum === 0) {
      this.pluginWidthChangeEvent.setWidth(ResUtils.getNumberFromLength(this.style.statusBarHotSpotWidth));
    } else if (this.sbPluginRequest.isVisible() && this.mHotSpotData.connectNum > 0) {
      this.pluginWidthChangeEvent.setWidth(ResUtils.getNumberFromLength(this.style.statusBarHotSpotWidthWithNumber));
    }
    if (this.pluginWidthChangeEvent.getChangeDelta() > 0 &&
      this.pluginWidthChangeEvent.getChangeDelta() < ResUtils.getNumberFromLength(this.style.statusBarHotSpotWidth)) {
      EvtBus.post(PluginWidthChangeEvent, this.pluginWidthChangeEvent);
    }
  }
}