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

import { BusinessError } from '@ohos.base';
import wifiManager from '@ohos.wifiManager';
import data from '@ohos.telephony.data';
import dataShare from '@ohos.data.dataShare';
import Observer from '@ohos.telephony.observer';
import { WifiDetailState, WifiData } from '../common/Constants';
import {
  LogDomain,
  LogHelper,
  SingletonHelper,
  TraceUtil,
  DomainName,
  CommonUtils,
  DataProperty,
  AppStorageUtil,
} from '@ohos/basicutils';
import lazy { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import {
  HiDfxEventUtil,
  DeviceHelper,
  sEventManager,
  obtainLocalEvent,
  EvtBus,
  PluginSlot,
  PluginInfo,
  PluginRequestEvent,
  ScreenOnOffEvent,
  EventManager,
  PluginPosition,
  PluginClickInfo,
  sSettingsUtil,
  GlobalContext,
  ViewType,
} from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants, FASlotName } from '@ohos/commonconstants';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { EdmAdminManager } from '@ohos/systemuicommon/src/main/ets/manager/EdmAdminManager';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import taskpool from '@ohos.taskpool';
import connection from '@ohos.net.connection';
import { performanceMonitor } from '@kit.ArkUI';
import {
  MultiDeviceCollaborationServiceEnableEvent
} from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import { AirplaneStateEvent,  ViewMgrPolicyViewCallback } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/plugin/info/StatusBarType';
import { DataShareUtils } from '@ohos/systemuicommon/src/main/ets/datasharemanager/DataShareUtils';
import { AntiTheftUtil } from '@ohos/systemuicommon/src/main/ets/utils/AntiTheftUtil';
import {
  ControlCenterHiSysEventUtil
} from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import { WindowPositionChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/Events';
import { RegisterAPIProtector } from '@ohos/systemuicommon/src/main/ets/statusbar/RegisterAPIProtector';
import commonEventManager from '@ohos.commonEventManager';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import Constants from '../common/Constants';
import { ToggleScene, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { WifiDecorator } from '@ohos/controlcentercommon/src/main/ets/toggle/decorator/WifiDecorator';
import { StatusBarExceptionCode } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarExceptionCode';
import { ViewManagerAdapter } from '@ohos/systemuicommon';
import Prompt from '@ohos.promptAction';
// instrument ignore file
const TAG: string = 'Model.WifiController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const sRegisterAPIProtector: RegisterAPIProtector = RegisterAPIProtector.get();

const netCon = connection.createNetConnection({
  netCapabilities: {
    bearerTypes: [connection.NetBearType.BEARER_WIFI]
  }
});
// 表示该网络应具有访问Internet的能力
const NET_CAPABILITY_VALIDATED: number = 16;
// 表示网络类型为wifi
const BEARER_WIFI: number = 1;

const LOCAL_EVENT_TYPE: string = 'local';
const CALLBACK_WAIT_TIME: number = 5000;
const ISWAIT_CLEAR_TIMEOUT: number = 5000;
export type QuickOff = () => void;
const PERSIST_EDM_WIFI_CONFIG = 'persist.edm.wifi_enable';
const PERSIST_EDM_WIFI_FORCE_OPEN_CONFIG: string = 'persist.edm.force_open_wifi';
const URI_BASE: string = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true';
const DISTRIBUTED_STATE: string = 'distributed_modem_state';
const DISTRIBUTED_STATE_DEFAULT: string = '0_sink';

export class WifiController extends ToggleBaseViewModel {
  private isWaitingLastActionDone: boolean = false;
  private mWifiData: WifiData = new WifiData();
  private mWifiState: WifiDetailState = WifiDetailState.STATE_UNKNOWN;
  private waitCallbackId: number | null = null;
  private taskPoolSequence: taskpool.SequenceRunner = new taskpool.SequenceRunner(taskpool.Priority.LOW);
  private taskTimerId?: number;
  private airplaneStatus: boolean = false;
  private multiDeviceCollaborationSwitch: boolean = true;
  private wifiControllerEventMgr: EventManager = EvtBus.createEventManager();
  private callbackTimeoutTimeId: number = -1;
  private registerQuickOff?: QuickOff;
  private isDistributedConnected: boolean = false;
  private onNetworkSharing: boolean = false;
  private distributedUri: string = '';
  private dataShareHelper: dataShare.DataShareHelper | undefined = undefined;
  private isSelfHealing: boolean = false;
  private selfHealingSub: commonEventManager.CommonEventSubscriber | undefined = undefined;
  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: ['usual.event.wifi.selfcure.STATE_CHANGED'],
    publisherPermission: 'ohos.permission.SET_WIFI_CONFIG'
  };
  private isWifiNetState: number | undefined = undefined;
  private wifiNetStateSub: commonEventManager.CommonEventSubscriber | undefined = undefined;
  private wifiNetStateInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: ['usual.event.wifi.INTERNET_ACCESS_CHANGE'],
    publisherPermission: 'ohos.permission.SET_WIFI_CONFIG'
  };
  private lastSignalLevel: number = Constants.DEFAULT_WIFI_INFO;
  private lastDataFlowType: number = Constants.DATA_FLOW_TYPE_NONE;
  private statusBarViewEnable:boolean = true;

  /**
   * 状态栏界面显隐
   */
  private viewVisibleChangeCallback: ViewMgrPolicyViewCallback = {
    viewType: ViewType.STATUS_BAR,
    onShow: () => {
      this.statusBarViewEnable = true;
      this.mWifiData.signalLevel = this.lastSignalLevel;
      this.mWifiData.dataFlowType = this.lastDataFlowType;
    },
    onHide: () => {
      this.statusBarViewEnable = false;
    }
  }

  setShowSignalLevel(signalLevel: number, showSignalLevel: number): number {
    this.lastSignalLevel = signalLevel;
    if (this.statusBarViewEnable) {
      return signalLevel;
    }
    return showSignalLevel;
  }

  setShowDataFlowType(dataFlowType: number, showDataFlowType: number): number {
    this.lastDataFlowType = dataFlowType;
    if (this.statusBarViewEnable) {
      return dataFlowType;
    }
    return showDataFlowType;
  }

  public openDetailPageFunc: (() => void) | undefined = () => {
    if (this.getViewData().isUnavailable) {
      log.showWarn('openDetailPage disabled');
      if (!this.isWifiEdmPolicyAvailable()) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      return;
    }
    if (DeviceHelper.isPC()) {
      //由于PC设置应用不开源，故屏蔽控制中心点击WIfi图标拉起wifi设置面板的功能
    } else {
      this.handleOnControlCenterWithScreenLockForUIE(
        ():void => this.showWifiSubWindow(FASlotName.WIFI_UI_EXTENSION), true);
    }
  };

  constructor() {
    super();
    this.onStart();
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): WifiController {
    return SingletonHelper.getInstance(WifiController, TAG);
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
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  isLoadLottie(): boolean {
    return true;
  }

  decorateStyle(style: ToggleStyle, scene: ToggleScene): ToggleStyle {
    if (scene === ToggleScene.PHONE || scene === ToggleScene.SINGLE_FOLD_OUTER_SCREEN) {
      style = new WifiDecorator().decorateEventHandler(style);
    }
    return style;
  }

  /**
   * 获取Wifi状态
   */
  getWifiDetailState(): WifiDetailState {
    let curState: WifiDetailState = WifiDetailState.STATE_UNKNOWN;
    let wifiCurState: number = WifiDetailState.STATE_UNKNOWN;
    try {
      wifiCurState = wifiManager.getWifiDetailState();
    } catch (error) {
      LogWithHa.error(log, `getWifiDetailState error:${error?.message}`, StatusBarExceptionCode.WIFI_FAIL, error, TAG);
    }
    log.showDebug(`getWifiDetailState- ${wifiCurState} | ${this.mWifiState}`);

    switch (wifiCurState) {
      case WifiDetailState.STATE_INACTIVE:
      case WifiDetailState.STATE_DEACTIVATING:
        curState = WifiDetailState.STATE_INACTIVE;
        break;
      case WifiDetailState.STATE_ACTIVE:
      case WifiDetailState.STATE_ACTIVATING:
        curState = WifiDetailState.STATE_ACTIVE;
        break;
      case WifiDetailState.STATE_SEMI_ACTIVE:
      case WifiDetailState.STATE_SEMI_ACTIVATING:
        curState = WifiDetailState.STATE_SEMI_ACTIVE;
        break;
      default:
        break;
    }
    return curState;
  }

  private onMultiDeviceCollaborationSwitchChange = (event: MultiDeviceCollaborationServiceEnableEvent): void => {
    const isEnable: boolean = event.isMultiDeviceCollaborationServiceEnable();
    log.showDebug('onMultiDeviceCollaborationSwitchChange isEnable: ' + isEnable);
    this.multiDeviceCollaborationSwitch = isEnable;
  };

  private onAirplaneStateChange = (event: AirplaneStateEvent): void => {
    log.showDebug('onAirplaneStateChange isEnable: ' + event.airplaneState);
    this.airplaneStatus = event.getAirplaneState();
  }

  setLabel(label: string | Resource) {
    this.getViewData().label = label;
    this.mWifiData.wifiName = label;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    this.setLabel(Constants.DEFAULT_WIFI_NAME);
    this.getViewData().isSymbolIcon = true;
    this.getViewData().icon = $r('sys.symbol.wifi');
    AppStorageUtil.setOrCreate('WifiModel_WifiStatus', this.mWifiData, new DataProperty(true, false));
    this.mWifiData = AppStorage.get<WifiData>('WifiModel_WifiStatus') as WifiData;
    try {
      this.registerEvents();
      this.onWifiStateChange(this.getWifiDetailState());
      if (wifiManager.isConnected()) {
        this.handleConnectionChange(true);
      } else {
        this.handleConnectionChange(false);
      }
      this.initModeChangeSwitchEvent();
    } catch (error) {
      LogWithHa.error(log, `onStart error : ${error?.message}`, StatusBarExceptionCode.WIFI_FAIL, error, TAG);
    }
    this.registerQuickOff?.();
    this.registerQuickOff = EvtBus.on(ScreenOnOffEvent, this.handleScreenOnOffEvent);
    this.initSelfHealing();
    this.initWifiNetState();
    this.updateDisableState();
    log.showInfo('onStart finish');
    ViewManagerAdapter.registerViewCallback(this.viewVisibleChangeCallback, `${TAG}_registerViewCallback`);
  }

  public registerWifiStateChange = () => {
    try {
      wifiManager.on('wifiStateChange', (data: number) => {
        log.showDebug(`onstart wifiStateChange data: ${data}`);
        this.onWifiStateChange(this.getWifiDetailState());
      });
    } catch (err) {
      LogWithHa.error(log, `register wifiStateChange failed`, StatusBarExceptionCode.WIFI_FAIL, err, TAG);
    }
  }

  public registerWifiConnectionChange = () => {
    try {
      wifiManager.on('wifiConnectionChange', (data: number) => {
        this.isSelfHealing = (data === 6 ? false : this.isSelfHealing);
        log.showInfo(`updateDisableState isSelfHealing : ${this.isSelfHealing}`);
        this.handleConnectionChange(data == 1 ? true : false)
      });
    } catch (err) {
      LogWithHa.error(log, `register WifiConnectionChange failed`, StatusBarExceptionCode.WIFI_FAIL, err, TAG);
    }
  }

  public registerWifiRssiChange = () => {
    try {
      wifiManager.on('wifiRssiChange', (data: number) => {
        this.handleRssiChange()
      });
    } catch (err) {
      LogWithHa.error(log, `register WifiRssiChange failed`, StatusBarExceptionCode.WIFI_FAIL, err, TAG);
    }
  }

  public registerWifiStreamChange = () => {
    try {
      wifiManager.on('streamChange', (data: number) => {
        this.onStreamChange(data)
      });
    } catch (err) {
      LogWithHa.error(log, `register WifiStreamChange failed`, StatusBarExceptionCode.WIFI_FAIL, err, TAG);
    }
  }

  private initSharedNetworkListener(): void {
    log.showInfo('initSharedNetworkListener');
    if (!this.getVirtualModemSwitchState()) {
      log.showError('Distributed modem is not supported');
      return;
    }
    if (!DeviceHelper.isPC() && !DeviceHelper.isPad()) {
      log.showError('current device is not pc or pad');
      return;
    }

    this.initDistributedListener();
    this.subscribeSharingNetworkDataState();
  }

  private initDistributedListener(): void {
    let context = GlobalContext.getContext();
    this.distributedUri = URI_BASE;
    try {
      dataShare.createDataShareHelper(context, this.distributedUri,
        (err: BusinessError, data: dataShare.DataShareHelper) => {
          if (err !== undefined) {
            log.showError(`createDataShareHelper error code:${err.code}, message:${err.message}`);
            return;
          }
          log.showInfo('distributed_modem_state createDataShareHelper success.');
          this.dataShareHelper = data;
          this.dataShareHelper?.on('dataChange', this.distributedUri, () => {
            onDistributedSetChange();
          });
        });
    } catch (err) {
      log.showError(`distributed_modem_state createDataShareHelper error code:${err?.code}, message:${err?.message}`);
    }
    const onDistributedSetChange = (): void => {
      let stateValue = DISTRIBUTED_STATE_DEFAULT;
      stateValue = sSettingsUtil.getValue(DISTRIBUTED_STATE, DISTRIBUTED_STATE_DEFAULT);
      if (stateValue == null || stateValue.length === 0) {
        log.showError('onDistributedSetChange stateValue is invalid or empty');
      } else {
        this.isDistributedConnected = stateValue !== DISTRIBUTED_STATE_DEFAULT;
        log.showInfo('onDistributedSetChange, update isShowSharedNetwork state');
      }
    };
    onDistributedSetChange();
  }

  private subscribeSharingNetworkDataState(): void {
    try {
      Observer.on('cellularDataConnectionStateChange', value => {
        log.showDebug(`sharedNetworkDataConnectionStateChange:${value?.state}, ${value?.network}`);
        let preNetworkSharingState: boolean = this.onNetworkSharing;
        this.onNetworkSharing = (value.state === data.DataConnectState.DATA_STATE_CONNECTED) &&
        this.isDistributedConnected;
        if (preNetworkSharingState !== this.onNetworkSharing) {
          if (this.onNetworkSharing) {
            this.updateWifiName();
          } else {
            this.resetWifiName();
          }
        }
      });
    } catch (error) {
      log.showError(`init observer cellularDataConnectionStateChange failed message: ${error.message}`);
    }
  }

  private updateWifiName(): void {
    log.showInfo(`update wifiName, onNetworkSharing: ${this.onNetworkSharing}, ` +
      `iswifiConnected: ${this.mWifiData.isConnected}, isWifiNetworkAvailable: ${this.mWifiData.isNetworkAvailable}`);
    if (this.onNetworkSharing && (!this.mWifiData.isConnected || !this.mWifiData.isNetworkAvailable)) {
      this.setLabel(sSettingsUtil.getValue('distributed_modem_device_name', Constants.DEFAULT_WIFI_NAME));
    }
  }

  private resetWifiName(): void {
    log.showInfo('reset wifiName');
    if (!this.mWifiData.isConnected) {
      this.setLabel(Constants.DEFAULT_WIFI_NAME);
    } else {
      this.setWifiStatus();
    }
  }

  private destroySharedNetworkListener(): void {
    try {
      this.dataShareHelper?.off('dataChange', this.distributedUri);
      Observer.off('cellularDataConnectionStateChange');
      log.showInfo('unregister distribute data share listener success.');
    } catch (err) {
      log.showError(`unregister distribute data share listener error: ${err?.message}`);
    }
  }

  private getVirtualModemSwitchState(): boolean {
    try {
      let state: string = systemParameterEnhance.getSync('const.booster.virtual_modem_switch', 'false');
      log.showInfo(`virtual modem switch state is : ${state}`);
      return state === 'true';
    } catch (error) {
      log.showError(`Failed to get virtual modem switch. Code: ${error?.code}, message: ${error?.message}`);
      return false;
    }
  }

  registerEvents() {
    sRegisterAPIProtector.run(TAG, 'wifiStateChange', this.registerWifiStateChange);
    sRegisterAPIProtector.run(TAG, 'registerWifiConnectionChange', this.registerWifiConnectionChange);
    sRegisterAPIProtector.run(TAG, 'registerWifiRssiChange', this.registerWifiRssiChange);
    sRegisterAPIProtector.run(TAG, 'registerWifiStreamChange', this.registerWifiStreamChange);
    this.initSharedNetworkListener();
    try {
      if (wifiManager.isConnected()) {
        this.handleConnectionChange(true);
      } else {
        this.handleConnectionChange(false);
      }
      netCon.register(() => {
        log.showInfo(`register NetConnection.`);
      });
    } catch (error) {
      LogWithHa.error(log, `handle net connection error : ${error?.message}`,
        StatusBarExceptionCode.WIFI_FAIL, error, TAG);
    }
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    this.destroySharedNetworkListener();
    ViewManagerAdapter.unRegisterViewCallback(this.viewVisibleChangeCallback, `${TAG}_registerViewCallback`);
    try {
      wifiManager.off('wifiStateChange');
      wifiManager.off('wifiConnectionChange');
      wifiManager.off('wifiRssiChange');
      wifiManager.off('streamChange');
    } catch (error) {
      LogWithHa.error(log, `wifiManager.off error : ${error?.message}`, StatusBarExceptionCode.WIFI_FAIL, error, TAG);
    }
    netCon.unregister(() => {
      log.showInfo(`unregister NetConnection.`);
    });
    this.wifiControllerEventMgr.offAll();
    try {
      if (this.selfHealingSub) {
        commonEventManager.unsubscribe(this.selfHealingSub);
        this.selfHealingSub = undefined;
      }
    } catch (error) {
      log.showError(`unsubscribe selfHealingSub error : ${error.message}`)
    }
    try {
      if (this.wifiNetStateSub) {
        commonEventManager.unsubscribe(this.wifiNetStateSub);
        this.wifiNetStateSub = undefined;
      }
    } catch (error) {
      log.showError(`unsubscribe wifiNetStateSub error : ${error.message}`)
    }
  }

  /**
   * wifi状态广播
   * @returns
   */
  private async initWifiNetState(): Promise<void> {
    try {
      log.showInfo(`receive wifiNetState createSubscriber start`);
      this.wifiNetStateSub = await commonEventManager.createSubscriber(this.wifiNetStateInfo);
    } catch (error) {
      log.showError(`create wifiNetState subscriber failed. Code is ${error?.code}, message is ${error?.message}`);
      return;
    }

    try {
      log.showInfo(`receive wifiNetState createSubscriber subscribe`);
      commonEventManager.subscribe(this.wifiNetStateSub, (err, data) => {
        if (err) {
          LogWithHa.error(log, `wifiNetState subscribe callback err`, StatusBarExceptionCode.WIFI_FAIL, err, TAG);
          return;
        }
        if (CommonUtils.isInvalid(data)) {
          LogWithHa.error(log, `wifiNetState data is invalid`, StatusBarExceptionCode.WIFI_FAIL, err, TAG);
          return;
        }
        log.showInfo(`receive wifiNetState subscribe callback ${data?.code} , ${this.isWifiNetState}`);
        if (data?.code === 1) {
          this.mWifiData.isNetworkAvailable = true;
          this.resetWifiName();
        } else {
          this.mWifiData.isNetworkAvailable = false;
          this.updateWifiName();
        }
      });
    } catch (error) {
      LogWithHa.error(log, `Failed to wifiNetState subscribe`, StatusBarExceptionCode.WIFI_FAIL, error, TAG);
    }
  }

  initModeChangeSwitchEvent(): void {
    // 飞行模式开关
    let airplaneMode: ToggleViewData | undefined = AppStorage.get('AirplaneModel_AirplaneStatus');
    this.airplaneStatus = airplaneMode ? airplaneMode.isOn : false;
    this.wifiControllerEventMgr.on(AirplaneStateEvent, this.onAirplaneStateChange);
    log.showInfo('onstart initModeChangeSwitchEvent data: ' + this.airplaneStatus);

    // 互联互通服务开关
    this.multiDeviceCollaborationSwitch = DataShareUtils.getSettingsValueSync(
      SettingsKeyConstants.MULTI_DEVICE_COLLABORATION_SERVICE_SWITCH,
      SettingsConstants.MULTI_DEVICE_COLLABORATION_SERVICE_SWITCH_DEFAULT) ===
      SettingsConstants.MULTI_DEVICE_COLLABORATION_SERVICE_SWITCH_DEFAULT;
    log.showInfo('onstart multiDeviceCollaborationSwitch: ' + this.multiDeviceCollaborationSwitch);
    this.wifiControllerEventMgr.on(MultiDeviceCollaborationServiceEnableEvent,
      this.onMultiDeviceCollaborationSwitchChange);
  }

  private async initSelfHealing(): Promise<void> {
    try {
      this.selfHealingSub = await commonEventManager.createSubscriber(this.subscribeInfo);
    } catch (error) {
      log.showError(`create selfHealing subscriber failed. Code is ${error?.code}, message is ${error?.message}`);
      return;
    }

    try {
      commonEventManager.subscribe(this.selfHealingSub, (err, data) => {
        if (err) {
          log.showError(`subscribe callback err:${err}`);
          return;
        }
        if (CommonUtils.isInvalid(data)) {
          return;
        }
        this.isSelfHealing = data?.parameters?.isSelfCureOnGoing;
        log.showInfo(`receive subscribe callback data: ${this.isSelfHealing}`);
      });
    } catch (error) {
      log.showError(`Failed to subscribe. Code is ${error?.code}, message is ${error?.message}`);
    }
  }

  /**
   * 是否需要监听卫星通信状态
   */
  needListenSatelliteMode(): boolean {
    return true;
  }

  /**
   * 标示WiFi图标
   */
  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_WIFI;
  }

  addStateChangedListener(): void {
  }

  removeStateChangedListener(): void {
  }

  onWifiStateChange(wifiCurState: number): void {
    if (wifiCurState === WifiDetailState.STATE_INACTIVE) {
      log.showInfo(`onWifiStateChange isSelfHealing : ${this.isSelfHealing}`);
      this.isSelfHealing = false;
    }
    log.showInfo(`onWifiStateChange wifiCurState:${wifiCurState}`)
    //data: the callback of on, 0: inactive, 1: active, 2: activating, 3: de-activating 4:Semi-activating 5：Semi-active
    if (wifiCurState === WifiDetailState.STATE_UNKNOWN) {
      return;
    }
    if (wifiCurState === WifiDetailState.STATE_DEACTIVATING || wifiCurState === WifiDetailState.STATE_SEMI_ACTIVATING) {
      // 在刚关闭wifi时立即刷新状态栏wifi的UI，而不是等到断开之后再刷新
      log.showDebug('onWifiStateChange data === 3 or 4, set isConnected to false')
      this.handleConnectionChange(false);
      return;
    }
    try {
      let currentIsConnected = wifiManager.isConnected();
      log.showDebug(`currentIsConnected: ${currentIsConnected},isConnected: ${this.mWifiData.isConnected}`);
      if (this.mWifiData.isConnected !== currentIsConnected) {
        this.handleConnectionChange(currentIsConnected);
      }
    } catch (error) {
      LogWithHa.error(log, `query isConnected error : ${error?.message}`,
        StatusBarExceptionCode.WIFI_FAIL, error, TAG);
    }
    if (wifiCurState === WifiDetailState.STATE_ACTIVE || wifiCurState === WifiDetailState.STATE_INACTIVE) {
      clearTimeout(this.waitCallbackId);
    }
    let status: boolean = wifiCurState === WifiDetailState.STATE_ACTIVE ||
      wifiCurState === WifiDetailState.STATE_ACTIVATING;
    this.mWifiState = wifiCurState;
    // 状态回调打点
    ControlCenterHiSysEventUtil.reportQuickToggleTristateMode({
      TOGGLE_NAME: FASlotName.WIFI,
      CURRENT_STATE: wifiCurState,
      TIMESTAMP: this.isWaitingLastActionDone ? DropDownPanelManager.getLastDropdownTime().toString() : undefined
    });
    // 切换WIFI设置界面开关，改变图标状态
    if (!this.isWaitingLastActionDone && this.getViewData().isOn !== status) {
      log.showDebug('onWifiStateChange isWaitingLastActionDone false and state different, set to same');
      this.getViewData().isOn = status;
      this.updateIcon();
    }
    // 多次点击图标，图标状态和回调状态不匹配，更新底层状态
    if (this.isWaitingLastActionDone && this.getViewData().isOn !== status) {
      log.showDebug('onWifiStateChange wifiData.status != current')
      this.switchWifiStatus(this.getViewData().isOn ?? false);
      return;
    }
    this.isWaitingLastActionDone = false;
  }

  onStreamChange(data: number): void {
    log.showDebug(`onStreamChange data : ${data}`)
    // wifi 上下行 0:data none  1: stream down, 2: stream up, 3: stream bidirectional
    this.mWifiData.dataFlowType = this.setShowDataFlowType(data, this.mWifiData.dataFlowType);
  }

  private handleStatusBarState(newState: boolean): void {
    let oldState = this.sbPluginRequest.isVisible();
    if (oldState !== newState) {
      log.showInfo(`status bar status change, newState: ${newState}, oldState: ${oldState}`);
      // 发送事件，触发PluginRootComponent组件中的状态更新，进而统一控制整个图标的显示与隐藏。
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }

  handleConnectionChange(isConnected: boolean): void {
    try {
      this.mWifiData.isConnected = isConnected;
      log.showInfo(`handleUpdateState start, connect status: ${isConnected}, isMeteredHotspot: ${this.mWifiData.isMetered}`)
      // 更新WiFi状态栏图标可见性
      this.handleStatusBarState(isConnected);
      if (this.getViewData().isOn && this.mWifiData.isConnected) {
        this.mWifiData.isMetered = wifiManager.isMeteredHotspot();
        this.setWifiStatus();
      } else {
        this.mWifiData.isMetered = Constants.DEFAULT_WIFI_METERED;
        this.setLabel(Constants.DEFAULT_WIFI_NAME);
        this.mWifiData.signalLevel = this.setShowSignalLevel(Constants.DEFAULT_WIFI_INFO, this.mWifiData.signalLevel);
        this.mWifiData.supportedWifiCategory = Constants.CATEGORY_DEFAULT;
        this.mWifiData.isNetworkAvailable = true;
        this.updateWifiName();
      }
    } catch (error) {
      LogWithHa.error(log, `handleUpdateState error`, StatusBarExceptionCode.WIFI_FAIL, error, TAG);
    }
    log.showInfo(`handleUpdateState, status: ${this.getViewData().isOn}, isConnected: ${this.mWifiData?.isConnected}, isMertered: ${this.mWifiData.isMetered}`);
  }

  // 信号变化触发状态栏wifi图标变化
  handleRssiChange() {
    log.showDebug(`handleRssiChange start, status: ${this.getViewData().isOn},isConnected: ${this.mWifiData?.isConnected},signalLevel: ${this.mWifiData?.signalLevel}`);
    if (this.getViewData().isOn && this.mWifiData.isConnected) {
      this.setSignalLevelDelay();
    } else {
      this.mWifiData.signalLevel = this.setShowSignalLevel(Constants.DEFAULT_WIFI_INFO, this.mWifiData.signalLevel);
    }
    log.showDebug(`handleRssiChange end, signalLevel: ${this.mWifiData?.signalLevel}`);
  }

  getData(): WifiData {
    return this.mWifiData;
  }

  isAvailable(): boolean {
    return true;
  }

  private waitCallback(): void {
    this.waitCallbackId = setTimeout(() => {
      if (!this.isWaitingLastActionDone) {
        return;
      }
      this.isWaitingLastActionDone = false;
      try {
        this.onWifiStateChange(wifiManager.getWifiDetailState());
      } catch (err) {
        LogWithHa.error(log, `isCellularDataEnabled call failed: ${err.message}`,
          StatusBarExceptionCode.WIFI_FAIL, err, TAG);
      }
    }, CALLBACK_WAIT_TIME);
  }

  private switchWifiStatus(isOn: boolean): void {
    try {
      taskpool.execute(switchWifi, isOn, this.multiDeviceCollaborationSwitch, this.airplaneStatus)
        .then((result: Object) => {
          log.showInfo(`switchWifi ${isOn} result ${result}`);
          this.waitCallback();
          if (!result) {
            log.showInfo('switchWifi fail, set isWaitingLastActionDone to false')
            this.isWaitingLastActionDone = false;
          }
        }).catch((error: BusinessError) => {
        LogWithHa.error(log, `switchWifiStatus BusinessError: ${error?.message}`,
          StatusBarExceptionCode.WIFI_FAIL, error, TAG);
      });
    } catch (error) {
      LogWithHa.error(log, `switchWifiStatus catch error`, StatusBarExceptionCode.WIFI_FAIL, error, TAG);
    }
  }

  // 获取底层数据的执行被延迟了 100 毫秒，如果在这个时间窗口内再次调用它，它的执行将被取消。
  private setSignalLevelDelay() {
    this.checkClearTask();
    this.taskTimerId = setTimeout(() => {
      try {
        let task = new taskpool.Task(getRssi);
        log.showInfo(`SignalLevel start taskpool ${this.mWifiData?.signalLevel}`);
        this.taskPoolSequence.execute(task).then((result: Object) => {
          this.mWifiData.signalLevel = this.setShowSignalLevel(result as number, this.mWifiData.signalLevel);
          this.taskTimerId = undefined;
          log.showWarn(`setSignalLevelDelay:result ${result}`);
        }).catch((error: BusinessError) => {
          LogWithHa.error(log, `setSignalLevel BusinessError`, StatusBarExceptionCode.WIFI_FAIL, error, TAG);
        });
      } catch (error) {
        LogWithHa.error(log, `setSignalLevel catch error`, StatusBarExceptionCode.WIFI_FAIL, error, TAG);
        log.error('setSignalLevel catch error', error);
      }
    }, 100);
  }


  private async setWifiStatus() {
    try {
      let result = await taskpool.execute(getWifiStatus) as WifiData;
      this.setLabel(result?.wifiName);
      log.showWarn(`WifiStatus level:${result.signalLevel} category:${result.supportedWifiCategory}`);
      this.mWifiData.signalLevel = this.setShowSignalLevel(result.signalLevel as number, this.mWifiData.signalLevel);
      this.mWifiData.supportedWifiCategory = result.supportedWifiCategory;
    } catch (error) {
      LogWithHa.error(log, `setWifiStatus failed, error`, StatusBarExceptionCode.WIFI_FAIL, error, TAG);
      this.mWifiData.supportedWifiCategory = Constants.CATEGORY_DEFAULT;
    }
  }

  private checkClearTask(): void {
    if (this.taskTimerId != undefined) {
      clearTimeout(this.taskTimerId)
    }
  }

  private handleScreenOnOffEvent = (event: ScreenOnOffEvent): void => {
    this.mWifiData.isScreenOff = event.isScreenOff();
    log.showInfo(`isScreenOff： ${this.mWifiData.isScreenOff}`);
  };

  handleOneClick(): void {
    let nextState = this.getNextWifiDetailState();
    log.showInfo(`handleClick, status: ${this.getViewData().isOn}, waiting: ${this.isWaitingLastActionDone}, state:${this.mWifiState}, nextState:${nextState}`);
    if (this.getViewData().isUnavailable) {
      log.showWarn('click disabled');
      if (!this.isWifiEdmPolicyAvailable()) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      return;
    }
    // 防盗值守判断
    if (this.getViewData().isOn && AntiTheftUtil.antiTheftConfirm(GlobalContext.getContext())) {
      const resource: Resource = $r('app.string.control_center_anti_theft_for_toggle');
      AntiTheftUtil.antiTheftShowToast(resource);
      log.showWarn('anti-theft, click disabled');
      return;
    }
    // CLICK打点
    ControlCenterHiSysEventUtil.reportQuickToggleTristateModeClick({
      TOGGLE_NAME: FASlotName.WIFI,
      CURRENT_STATE: this.mWifiState,
      NEXT_STATE: nextState,
      TIMESTAMP: DropDownPanelManager.getLastDropdownTime().toString(),
      SCREENTYPE: 0,
    });
    this.getViewData().isOn = !this.getViewData().isOn;
    this.updateIcon();
    this.mWifiState = nextState;
    if (!this.isWaitingLastActionDone) {
      // 不处理下一次点击事件，直到收到底层回调
      log.showInfo('handleClick, no handle event until get switchWifiStatus result')
      this.isWaitingLastActionDone = true;
      this.handleCallbackTimeout();
      this.switchWifiStatus(this.getViewData().isOn ?? false);
    }
  }

  openDetailPage() {
    if (DeviceHelper.isPC()) {
      // pc点击文字弹出二级窗口，并关闭控制中心面板
      sEventManager.publish(obtainLocalEvent(LOCAL_EVENT_TYPE, false));
      windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
      // 设置二级页面窗口位置
      let position = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_WIFI_PANEL);
      if (StatusBarType.isMacStyle(AppStorage.get('statusBarType') as number)) {
        let controlCenterPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
        position.left = controlCenterPosition.left + controlCenterPosition.width - position.width;
      }
      EvtBus.post(WindowPositionChangeEvent,
        { windowName: PluginSlot.SLOT_STATUS_WIFI_PANEL,
          position: PluginPosition.POSITION_RIGHT,
          area: position,
          caller: PluginSlot.SLOT_STATUS_CONTROL_CENTER});
      let info = AppStorage.get<PluginInfo>(PluginSlot.SLOT_STATUS_WIFI_PANEL + '_info');
      windowMgr.setWindowData(PluginSlot.SLOT_STATUS_WIFI_PANEL, info);
      windowMgr.showWindowWithAnim(PluginSlot.SLOT_STATUS_WIFI_PANEL, true);
      sEventManager.publish(obtainLocalEvent(LOCAL_EVENT_TYPE, true));
    } else {
      this.handleOnControlCenterWithScreenLockForUIE(
        ():void => this.showWifiSubWindow(FASlotName.WIFI_UI_EXTENSION), true);
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
      this.callbackTimeoutTimeId = -1;
    }, ISWAIT_CLEAR_TIMEOUT);
  }

  getNextWifiDetailState(): WifiDetailState {
    if (!this.multiDeviceCollaborationSwitch || this.airplaneStatus) {
      return this.getViewData().isOn ? WifiDetailState.STATE_INACTIVE : WifiDetailState.STATE_ACTIVE;
    }
    if (this.mWifiState !== WifiDetailState.STATE_ACTIVE) {
      return WifiDetailState.STATE_ACTIVE;
    } else {
      return WifiDetailState.STATE_SEMI_ACTIVE;
    }
  }

  private showWifiSubWindow(slot: string): void {
    log.showInfo(`showWifiSubWindow, slot${slot}`);
    HiDfxEventUtil.reportQuickToggleSubMenuClick(slot);
    performanceMonitor.begin('INTO_CC_SUB_WIFI_ANI', performanceMonitor.ActionType.LAST_UP);
    sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.WIFI_UI_EXTENSION, {
      clickType: 'window',
      bundleName: 'com.ohos.settings',
      abilityName: 'WifiUIExtensionSettingsAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: 398
    } as PluginClickInfo);
  }

  updateDisableState(): void {
    if (this.isSatelliteMode || !this.isWifiEdmPolicyAvailable()) {
      this.getViewData().isUnavailable = true;
      return;
    }
    this.getViewData().isUnavailable = false;
  }

  /**
   * wifi的edm管控用户是否可以操作，需要满足（非强制开启+非禁用）
   * @returns
   */
  private isWifiEdmPolicyAvailable(): boolean {
    return EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_WIFI_CONFIG) &&
    EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_WIFI_FORCE_OPEN_CONFIG)
  }

  updateIcon() {
    log.showInfo('updateIcon');
    this.getViewData().isSymbolIcon = true;
    this.getViewData().icon = $r('sys.symbol.wifi');
  }
}

@Concurrent
function switchWifi(isOn: boolean, multiDeviceCollaborationSwitch: boolean, airplaneStatus: boolean): boolean {
  try {
    if (!isOn) {
      if (multiDeviceCollaborationSwitch && !airplaneStatus) {
        wifiManager.enableSemiWifi();
      } else {
        wifiManager.disableWifi();
      }
    } else {
      wifiManager.enableWifi();
    }
    return true;
  } catch (err) {
    return false;
  }
}

@Concurrent
async function getRssi(): Promise<number> {
  let data = await wifiManager.getLinkedInfo();
  let signalLevel: number = wifiManager.getSignalLevel(data.rssi, data.band);
  return signalLevel;
}

@Concurrent
async function getWifiStatus(): Promise<WifiData> {
  const traceName: string = `Model.WifiController_getLinkedInfo`;
  TraceUtil.startTrace(DomainName.SYS_UI, traceName);
  let wifiData = new WifiData();
  const info = await wifiManager.getLinkedInfo();
  wifiData.wifiName = info?.ssid;
  wifiData.signalLevel = wifiManager.getSignalLevel(info.rssi, info.band);
  //  流水线SDK该方法对应的字段还未生效
  let category = Reflect.get(info, 'supportedWifiCategory') as number | undefined;
  wifiData.supportedWifiCategory = category ? category : Constants.CATEGORY_DEFAULT;
  TraceUtil.endTrace(DomainName.SYS_UI, traceName);
  return wifiData;
}

let sWifiController = SingletonHelper.getInstance(WifiController, TAG);

export default sWifiController as WifiController;