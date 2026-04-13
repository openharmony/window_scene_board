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

import wifiManager from '@ohos.wifiManager';
import statistics from '@ohos.net.statistics';
import { LinkSpeedData } from '../common/constants';
import {
  CommonUtils,
  LogDomain,
  LogHelper,
  SingletonHelper,
  DataProperty,
  AppStorageUtil
} from '@ohos/basicutils';
import {
  EvtBus,
  GlobalContext,
  PluginRequestEvent,
  ScreenOnOffEvent,
  PluginSlot,
  ViewType,
} from '@ohos/frameworkwrapper';
import type { EventManager } from '@ohos/frameworkwrapper';
import { BaseController } from '@ohos/controlcentercommon/Index';
import {
  CellularDataEnableEvent,
  LogWithHa,
  RealTimeNetworkSpeedEvent,
  ViewMgrPolicyViewCallback,
  ViewManagerAdapter,
} from '@ohos/systemuicommon';
import commonEvtMgr from '@ohos.commonEventManager';
import Observer from '@ohos.telephony.observer';
import Sim from '@ohos.telephony.sim';
import telephony from '@ohos.telephony.data';
import type { BusinessError } from '@ohos.base';
import { AirplaneStateEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { RegisterAPIProtector } from '@ohos/systemuicommon/Index';
import commonEventManager from '@ohos.commonEventManager';
import { StatusBarExceptionCode } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarExceptionCode';
// import Vsim from '@hms.telephony.vsim';
import dataShare from '@ohos.data.dataShare';
import Settings from '@ohos.settings';

// instrument ignore file
const TAG = 'Model.NetSpeedController';
const RETRY_INTERVAL: number = 3000;
const CIRCLE_COUNT: number = 3;
const AIRPLANE_MODE_STATUS_CLOSE = '0';
const TYPE_LO: string = 'lo';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const sRegisterAPIProtector: RegisterAPIProtector = RegisterAPIProtector.get();
const WAIT_CLEAR_TIMEOUT: number = 5000;
const DISTRIBUTED_CELLULAR_DATA_SWITCH_URI: string =
  'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true';
const DISTRIBUTED_CELLULAR_DATA_SWITCH: string = 'distributed_cellular_data_switch';
const DISTRIBUTED_CELLULAR_DATA_SWITCH_OFF: string = 'off';
const DISTRIBUTED_CELLULAR_DATA_SWITCH_ON: string = 'on';
const DISTRIBUTED_MODEM_STATE: string = 'distributed_modem_state';
const DISTRIBUTED_MODEM_STATE_DISCONNECTED: string = '0_sink';
const DISTRIBUTED_MODEM_STATE_CONNECTED: string = '1_sink';

const SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    commonEvtMgr.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED,
  ]
};

const SIM_STATE_CHANGE_SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    'usual.event.SIM_STATE_CHANGED'
  ],
  publisherPermission: 'ohos.permission.SET_TELEPHONY_STATE'
};

enum SimCardType {
  SIM_CARD_0 = 0,
  SIM_CARD_1 = 1,
  SIM_CARD_SKY = 2,
}

export interface AirplaneData {
  /**
   * 控制开关开启状态的显示
   */
  isOn: boolean;
}

export class NetSpeedController extends BaseController<LinkSpeedData> {
  public mLinkSpeedData: LinkSpeedData = new LinkSpeedData();

  private mSpeed?: AbstractProperty<number>;
  private lastSpeedValue: number = 0;
  private mIsFirst: boolean = true;
  private timerId: number = -1;
  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private hasSimCard: boolean = false;
  private mCurrentValue: number = 0;
  private mLastValue: number = 0;
  private dataShareHelper: dataShare.DataShareHelper | undefined = undefined;

  /**
   * 多事件管理器
   */
  private netSpeedEventMgr: EventManager = EvtBus.createEventManager();
  private isWifiActive: boolean = false;
  private isConnected: boolean = false;
  private statusBarViewEnable: boolean = true;

  private mSimStateChangeSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private isSkyToneActive: boolean = false;
  private simStateChangeTimeIdMap: Map<number, number> = new Map([
    [SimCardType.SIM_CARD_0, -1],
    [SimCardType.SIM_CARD_1, -1],
    [SimCardType.SIM_CARD_SKY, -1]
  ]);

  private async registerDistributedCellularListener(): Promise<void> {
    let context = GlobalContext.getContext();
    try {
      dataShare.createDataShareHelper(context, DISTRIBUTED_CELLULAR_DATA_SWITCH_URI,
        (err: BusinessError, data: dataShare.DataShareHelper) => {
          if (err !== undefined) {
            log.showError(`createDataShareHelper error code:${err.code}, message:${err.message}`);
            return;
          }
          this.dataShareHelper = data;
          this.dataShareHelper?.on('dataChange', DISTRIBUTED_CELLULAR_DATA_SWITCH_URI, () => {
            onDistributedCellularChanged();
          });
        });
    } catch (err) {
      log.error(`createDataShareHelper error code:${err?.code}, message:${err?.message}`);
    }

    const onDistributedCellularChanged = (): void => {
      let modemState = DISTRIBUTED_MODEM_STATE_DISCONNECTED;
      try {
        modemState = Settings.getValueSync(context, DISTRIBUTED_MODEM_STATE, DISTRIBUTED_MODEM_STATE_DISCONNECTED);
        log.showInfo(`${DISTRIBUTED_MODEM_STATE}=${modemState}`);
      } catch (e) {
        log.error(`get modem state value error`);
        return;
      }
      // 只在分布式通信连接上的情况下，才更新网速是否显示
      if (modemState !== DISTRIBUTED_MODEM_STATE_CONNECTED) {
        log.showInfo('modem state invalid');
        return;
      }

      let switchValue = DISTRIBUTED_CELLULAR_DATA_SWITCH_OFF;
      try {
        switchValue = Settings.getValueSync(context, DISTRIBUTED_CELLULAR_DATA_SWITCH,
          DISTRIBUTED_CELLULAR_DATA_SWITCH_OFF);
        log.showInfo(`${DISTRIBUTED_CELLULAR_DATA_SWITCH}=${switchValue}`);
      } catch (e) {
        log.error(`get switch value error`);
        return;
      }
      let isDistributedCellularEnabled = (switchValue === DISTRIBUTED_CELLULAR_DATA_SWITCH_ON);
      log.showInfo('isDistributedCellularEnable=' + isDistributedCellularEnabled);
      this.mLinkSpeedData.isCellularConnected = isDistributedCellularEnabled;
      this.handleUpdateState();
    };

    onDistributedCellularChanged();
  }

  /**
   * 状态栏界面显隐
   */
  private viewVisibleChangeCallback: ViewMgrPolicyViewCallback = {
    viewType: ViewType.STATUS_BAR,
    onShow: () => {
      this.statusBarViewEnable = true;
      this.setSpeed(this.lastSpeedValue);
    },
    onHide: () => {
      this.statusBarViewEnable = false;
    }
  }

  unregisterDistributedCellularListener(): void {
    try {
      this.dataShareHelper?.off('dataChange', DISTRIBUTED_CELLULAR_DATA_SWITCH_URI);
      log.showInfo('unregister distribute data share listener success');
    } catch (err) {
      log.error(`unregister distribute data share listener error: ${err?.message}`);
    }
  }

  constructor() {
    super();
    this.onStart();
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    AppStorageUtil.setOrCreate('linkspeedModel_linkspeedStatus', this.mLinkSpeedData, new DataProperty(true, false));
    this.mLinkSpeedData = AppStorage.get<LinkSpeedData>('linkspeedModel_linkspeedStatus') as LinkSpeedData;
    this.handleCheckNetwork();
    sRegisterAPIProtector.run(TAG, 'WifiConnectionChange', this.registerWifiConnectionChange);
    sRegisterAPIProtector.run(TAG, 'WifiStateChange', this.registerWifiStateChange);
    try {
      this.registerScreenOnOffEvent();
    } catch (error) {
      LogWithHa.error(log, `registerScreenOnOffEvent failed error->${error?.message}`, StatusBarExceptionCode.NET_SPEED_FAIL,
        error, TAG);
    }
    this.observerSimCard();
    this.mSpeed = AppStorage.setAndRef('speed', 0);
    sRegisterAPIProtector.run(TAG, 'RealTimeNetworkSpeedEvent', this.registerRealTimeNetworkSpeedEvent);
    sRegisterAPIProtector.run(TAG, 'CellularDataEnableEvent', this.registerCellularDataEnableEvent);
    this.registerDistributedCellularListener();
    this.handleUpdateState();
    this.airplaneModeChange();
    this.handleHasSimCard();
    ViewManagerAdapter.registerViewCallback(this.viewVisibleChangeCallback, `${TAG}_registerViewCallback`);
  }

  public registerWifiConnectionChange = (): void => {
    try {
      wifiManager.on('wifiConnectionChange', (data) => {
        this.isConnected = data === 1 ? true : false;
        this.handleUpdateState();
      });
    } catch (e) {
      log.error(`wifiConnectionChange.on catch error code:${e?.code} message:${e?.message}`);
    }
  };

  public registerWifiStateChange = (): void => {
    try {
      wifiManager.on('wifiStateChange', (data) => {
        if (data === 2) {
          this.isConnected = false;
        }
        this.isWifiActive = data === 1 ? true : false;
        this.handleUpdateState();
      });
    } catch (e) {
      log.error(`wifiStateChange.on catch error code:${e?.code} message:${e?.message}`);
    }
  };

  public registerRealTimeNetworkSpeedEvent = (): void => {
    this.netSpeedEventMgr.on(RealTimeNetworkSpeedEvent, this.onRealTimeNetworkSpeedEvent);
  };

  public registerCellularDataEnableEvent = (): void => {
    this.netSpeedEventMgr.on(CellularDataEnableEvent, this.onCellularDataEnableEvent);
  };

  handleCheckNetwork(): void {
    try {
      this.isWifiActive = wifiManager.isWifiActive();
    } catch (error) {
      LogWithHa.error(log, `wifiManager.isWifiActive error: ${error?.message}`, StatusBarExceptionCode.NET_SPEED_FAIL,
        error, TAG);
    }
    try {
      this.isConnected = wifiManager.isConnected();
    } catch (error) {
      LogWithHa.error(log, `wifiManager.isConnected error: ${error?.message}`, StatusBarExceptionCode.NET_SPEED_FAIL,
        error, TAG);
    }
    this.setHasSimCard();
    telephony.isCellularDataEnabled().then((enabled: boolean) => {
      if (!CommonUtils.isInvalid(this.mLinkSpeedData)) {
        this.mLinkSpeedData.isCellularConnected = enabled;
      } else {
        log.showWarn('mLinkSpeedData isInvalid');
      }
    }).catch((error: BusinessError) => {
      log.showError(`telephony.isCellularDataEnabled error: ${error?.message}`);
    });
    log.showInfo(`handleCheckNetwork, isWifiActive:${this.isWifiActive},isConnected:${this.isConnected},hasSimCard:${this.hasSimCard},isCellularConnected:${this.mLinkSpeedData.isCellularConnected}`);
  }

  handleUpdateState(isAirplane: boolean = true): void {
    let mAirplaneData: AirplaneData = AppStorage.get('AirplaneModel_AirplaneStatus') as AirplaneData;
    let airplaneStatus:boolean = mAirplaneData?.isOn;
    if (!isAirplane) {
      airplaneStatus = isAirplane;
    }
    log.showInfo(`handleUpdateState, isWifiActive: ${this.isWifiActive} isConnected: ${this.isConnected}
    hasSimCard: ${this.hasSimCard} isCellularConnected: ${this.mLinkSpeedData.isCellularConnected} airplaneStatus: ${airplaneStatus}`);
    this.mLinkSpeedData.isWifiConnected = this.isWifiActive && this.isConnected;
    let isShowSpeed: boolean = this.mLinkSpeedData.showNetWorkSpeed &&
      (this.mLinkSpeedData.isWifiConnected || !airplaneStatus && this.isSimSkyToneEnable());
    this.mLinkSpeedData.status = isShowSpeed;
    // 更新状态栏图标可见性
    this.handleStatusBarState(isShowSpeed);
    if (!this.mLinkSpeedData.isScreenOff && isShowSpeed) {
      this.createLinkSpeedQueryInterval();
    } else {
      this.clearLinkSpeedQueryInterval();
    }
    log.showInfo(`handleUpdateState, netSpeed end: ${this.mLinkSpeedData?.status}`);
  }

  private isSimSkyToneEnable(): boolean {
    if (this.isSkyToneActive) {
      return this.getSkyToneStatus() === 2;
    }
    return this.hasSimCard && this.mLinkSpeedData.isCellularConnected;
  }

  private handleSimStateChangeTimeout(data: commonEventManager.CommonEventData): void {
    if (this.simStateChangeTimeIdMap.has(data?.parameters?.slotId)) {
      let simStateChangeTimeoutTimeId = this.simStateChangeTimeIdMap.get(data?.parameters?.slotId);
      if (simStateChangeTimeoutTimeId !== -1) {
        clearTimeout(simStateChangeTimeoutTimeId);
        this.simStateChangeTimeIdMap.set(data?.parameters?.slotId, -1);
      }
      simStateChangeTimeoutTimeId = setTimeout(() => {
        log.showInfo(`simStateChange card ${data?.parameters?.slotId}`);
        this.handleHasSimCard();
        this.simStateChangeTimeIdMap.set(data?.parameters?.slotId, -1);
      }, WAIT_CLEAR_TIMEOUT);
      this.simStateChangeTimeIdMap.set(data?.parameters?.slotId, simStateChangeTimeoutTimeId);
    }
  }

  private observerSimCard(): void {
    sRegisterAPIProtector.run(TAG, 'simStateChange_SIM_CARD_0',
      this.registerSimStateChange as (...args: Object[]) => void, SimCardType.SIM_CARD_0);
    sRegisterAPIProtector.run(TAG, 'simStateChange_SIM_CARD_1',
      this.registerSimStateChange as (...args: Object[]) => void, SimCardType.SIM_CARD_1);
    sRegisterAPIProtector.run(TAG, 'simStateChange_SIM_CARD_SKY',
      this.registerSimStateChange as (...args: Object[]) => void, SimCardType.SIM_CARD_SKY);
    sRegisterAPIProtector.run(TAG, 'iccAccountInfoChange', this.registerIccAccountInfoChange);
    this.subscribeSimStateChangeBroadcast();
  }

  public registerSimStateChange = (simSlotId: number): void => {
    try {
      Observer.on('simStateChange', { slotId: simSlotId }, () => this.handleHasSimCard());
    } catch (err) {
      LogWithHa.error(log, `registerSimStateChange failed: ${err?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, err, TAG);
    }
  };

  public registerIccAccountInfoChange = (): void => {
    Observer.on('iccAccountInfoChange', () => {
      log.showInfo('iccAccountInfoChange');
      this.handleHasSimCard();
    });
  };

  private async subscribeSimStateChangeBroadcast(): Promise<void> {
    try {
      log.showInfo('subscribeSimStateChange');
      this.mSimStateChangeSubscriber = await commonEventManager.createSubscriber(SIM_STATE_CHANGE_SUBSCRIBE_INFO);
      commonEventManager.subscribe(this.mSimStateChangeSubscriber, (err, data) => {
        if (err) {
          LogWithHa.error(log, `Failed to subscribe common event. Code is ${err?.code}, message is ${err?.message}`,
            StatusBarExceptionCode.NET_SPEED_FAIL, err, TAG);
          return;
        }
        this.handleSimStateChangeTimeout(data);
      });
    } catch (error) {
      LogWithHa.error(log, `createSubscriber error: ${error?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
    }
  }

  private async setHasSimCard(): Promise<void> {
    let hasSimCard0: boolean = false;
    let hasSimCard1: boolean = false;
    let hasSimCard2: boolean = false;
    try {
      hasSimCard0 = await Sim.hasSimCard(0);
    } catch (error) {
      LogWithHa.error(log, `hasSimCardSync0 error: ${error?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
    }
    try {
      hasSimCard1 = await Sim.hasSimCard(1);
    } catch (error) {
      LogWithHa.error(log, `hasSimCardSync1 error: ${error?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
    }
    hasSimCard2 = await this.getSimCardIsActive(2);
    this.isSkyToneActive = hasSimCard2;
    log.showInfo(`hasSimCard0: ${hasSimCard0}, hasSimCard1:${hasSimCard1}, hasSimCard2:${hasSimCard2}`);
    this.hasSimCard = hasSimCard0 || hasSimCard1 || hasSimCard2;
  }

  /**
   * 获取指定卡槽SIM卡的帐户信息
   * Get SIM card account info
   *
   * @param slotId 卡ID
   */
  private async getSimCardIsActive(slotId: number): Promise<boolean> {
    try {
      const accountInfo = await Sim.getSimAccountInfo(slotId);
      log.showInfo(`slotIndex: ${accountInfo.slotIndex}, isActive: ${accountInfo.isActive}`);
      return accountInfo.slotIndex === slotId && CommonUtils.isBoolean(accountInfo.isActive);
    } catch (e) {
      LogWithHa.error(log, `getSimCardIsActive error, code:${e?.code}, msg: ${e?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, e, TAG);
      return false;
    }
  }

  /**
   * 控制状态栏图标显示与隐藏，与控制中心逻辑解耦
   * @param newState
   */
  private handleStatusBarState(newState: boolean): void {
    let oldState = this.sbPluginRequest.isVisible();
    if (oldState !== newState) {
      log.showInfo(`status bar status change, newState: ${newState}, oldState: ${oldState}`);
      // 发送事件，触发PluginRootComponent组件中的状态更新，进而统一控制整个图标的显示与隐藏。
      this.sbPluginRequest.setIsVisible(newState);
      this.postEventWithTimeout();
    }
  }

  private postEventWithTimeout(): void {
    // 网速图标如果显示，延后10ms。避免与wifi图标，信号箭头一起出现，导致跨孔闪烁
    if (this.sbPluginRequest.isVisible()) {
      setTimeout(() => {
        EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
      }, 10);
    } else {
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }

  createLinkSpeedQueryInterval(): void {
    log.showWarn(`createLinkSpeedQueryInterval start: ${this.timerId}`);
    if (this.timerId > 0) {
      return;
    }
    this.mIsFirst = true;
    this.timerId = setInterval(() => {
      this.getLinkedInfo();
    }, RETRY_INTERVAL);
    log.showWarn(`createLinkSpeedQueryInterval end: ${this.timerId}`);
  }

  clearLinkSpeedQueryInterval(): void {
    log.showWarn(`clearLinkSpeedQueryInterval: ${this.timerId}`);
    if (this.timerId > 0) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }
  registerScreenOnOffEvent(): void {
    EvtBus.on(ScreenOnOffEvent, this.handleScreenOnOffEvent);
  }

  unregisterScreenOnOffEvent(): void {
    EvtBus.off(ScreenOnOffEvent, this.handleScreenOnOffEvent);
  }

  async getLinkedInfo(): Promise<void> {
    let result = await Promise.all([
      this.getAllTxBytes(),
      this.getAllRxBytes(),
      this.getIfaceRxBytes(),
      this.getIfaceTxBytes(),
    ]);
    let netUpSpeed = result[0];
    let netDownSpeed = result[1];
    let netUpLoSpeed = result[2];
    let netDownLoSpeed = result[3];
    this.mCurrentValue = netUpSpeed + netDownSpeed - (netUpLoSpeed + netDownLoSpeed);
    let value = Math.abs(this.mCurrentValue - this.mLastValue) / CIRCLE_COUNT;
    this.mLastValue = this.mCurrentValue;
    if (this.mIsFirst) {
      this.mIsFirst = false;
      value = 0;
    }
    this.setSpeed(value);
  }

  setSpeed(value: number): void {
    this.lastSpeedValue = value;
    if (!this.statusBarViewEnable) {
      return;
    }
    this.mSpeed?.set(value);
  }

  private async getAllTxBytes(): Promise<number> {
    let stats: number = 0;
    try {
      stats = await statistics.getAllTxBytes(); // 获取所有网卡实时上行流量
    } catch (error) {
      LogWithHa.error(log, `net, getAllTxBytes error: ${error?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
    }
    return stats;
  }

  private async getAllRxBytes(): Promise<number> {
    let stats: number = 0;
    try {
      stats = await statistics.getAllRxBytes(); // 获取所有网卡实时下行流量
    } catch (error) {
      LogWithHa.error(log, `net, getAllRxBytes error: ${error?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
    }
    return stats;
  }

  private async getIfaceTxBytes(): Promise<number> {
    let stats: number = 0;
    try {
      stats = await statistics.getIfaceTxBytes(TYPE_LO); // 获取指定网卡实时上行流量
    } catch (error) {
      LogWithHa.error(log, `net, getIfaceTxBytes error: ${error?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
    }
    return stats;
  }

  private async getIfaceRxBytes(): Promise<number> {
    let stats: number = 0;
    try {
      stats = await statistics.getIfaceRxBytes(TYPE_LO); // 获取指定网卡实时下行流量
    } catch (error) {
      LogWithHa.error(log, `net, getIfaceRxBytes error: ${error?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
    }
    return stats;
  }

  handleHasSimCard(): void {
    this.setHasSimCard().then(() => {
      this.handleUpdateState();
    });
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    try {
      wifiManager.off('wifiConnectionChange');
      wifiManager.off('wifiStateChange');
    } catch (err) {
      log.showError(`unInitPolicy fail ,error is ${err.message}`);
    }
    this.mLastValue = 0;
    this.mIsFirst = true;
    try {
      if (this.mSubscriber) {
        commonEvtMgr.unsubscribe(this.mSubscriber);
        this.mSubscriber = null;
      }
    } catch (error) {
      LogWithHa.error(log, `unsubscribe error, error->${error?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
    }
    try {
      Observer.off('simStateChange');
    } catch (error) {
      LogWithHa.error(log, `simStateChange off, error->${error?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
    }
    try {
      this.unregisterScreenOnOffEvent();
    } catch (error) {
      LogWithHa.error(log, `unregisterScreenOnOffEvent failed error->${error?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
    }
    if (this.mSimStateChangeSubscriber) {
      try {
        commonEventManager.unsubscribe(this.mSimStateChangeSubscriber);
        this.mSimStateChangeSubscriber = null;
      } catch (error) {
        LogWithHa.error(log, `commonEvtMgr unsubscribe error`, StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
      }
    }
    this.unregisterDistributedCellularListener();
    ViewManagerAdapter.unRegisterViewCallback(this.viewVisibleChangeCallback, `${TAG}_registerViewCallback`);
  }

  private getSkyToneStatus(): number {
    let status = -1;
    try {
      // status = JSON.parse(Vsim.getVSimPlatformCapability()).curVSimCardType;
    } catch {
      log.error('get getSkyToneStatus error');
    }
    log.showInfo(`getSkyToneStatus: ${status}`);
    return status;
  }

  private handleScreenOnOffEvent = (event: ScreenOnOffEvent): void => {
    this.mLinkSpeedData.isScreenOff = event.isScreenOff();
    log.showInfo(`isScreenOff： ${this.mLinkSpeedData.isScreenOff}`);
    this.handleUpdateState();
  };

  /**
   * 显示移动数据开关事件设置变化回调
   *
   * @param event 显示移动数据开关事件
   */
  private onCellularDataEnableEvent = (event: CellularDataEnableEvent): void => {
    const isEnable: boolean = event.isCellularDataEnabled();
    log.showInfo('NetSpeed onCellularDataEnableEvent isEnable: ' + isEnable);
    this.mLinkSpeedData.isCellularConnected = isEnable;
    this.handleUpdateState();
  };

  /**
   * 状态栏显示实时网速开关开启设置变化回调
   *
   * @param event 状态栏显示实时网速开关是否开启
   */
  private onRealTimeNetworkSpeedEvent = (event: RealTimeNetworkSpeedEvent): void => {
    const isEnable: boolean = event.isRealTimeNetworkSpeedEnable();
    log.showInfo('NetSpeed isRealTimeNetworkSpeedEnable isEnable: ' + isEnable);
    this.mLinkSpeedData.showNetWorkSpeed = isEnable;
    this.handleUpdateState();
  };

  /**
   * 飞行模式开关事件处理
   */
  airplaneModeChange(): void {
    try {
      commonEvtMgr.createSubscriber(SUBSCRIBE_INFO).then((subscriber) => {
        log.showInfo('createSubscriber end');
        this.mSubscriber = subscriber;
        commonEvtMgr.subscribe(subscriber, (err, data) => {
          if (err && err.code !== 0) {
            LogWithHa.error(log, `airplaneModeChange,can't handle common event, err: ${err?.message}`,
              StatusBarExceptionCode.NET_SPEED_FAIL, err, TAG);
            return;
          }
          if (data && data.event === commonEvtMgr.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED) {
            log.showInfo('airplaneModeChange,status change ' + data.data + 'code : ' + data.code);
            if (String(data.code) === AIRPLANE_MODE_STATUS_CLOSE) {
              EvtBus.post(AirplaneStateEvent, AirplaneStateEvent.getInstance(false));
            } else {
              EvtBus.post(AirplaneStateEvent, AirplaneStateEvent.getInstance(true));
            }
            let status: boolean = true;
            if (String(data.code) === AIRPLANE_MODE_STATUS_CLOSE) {
              status = false;
            }
            log.showInfo(`airplaneMode: ${status} mLinkSpeedData: ${this.mLinkSpeedData?.status}`);
            // 更新状态栏图标可见性
            if (status && !this.mLinkSpeedData.isWifiConnected) {
              this.sbPluginRequest.setIsVisible(false);
            } else {
              this.sbPluginRequest.setIsVisible(this.mLinkSpeedData.status);
            }
            this.postEventWithTimeout();
            this.handleUpdateState(status);
          }
        });
      });
    } catch (error) {
      LogWithHa.error(log, `airplaneModeChange,subscribe error, err: ${error?.message}`,
        StatusBarExceptionCode.NET_SPEED_FAIL, error, TAG);
    }
  }

  /**
   * 标示网速图标
   */
  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_NET_SPEED;
  }

  addStateChangedListener(): void {
  }

  removeStateChangedListener(): void {
  }

  getData(): LinkSpeedData {
    return this.mLinkSpeedData;
  }

  isAvailable(): boolean {
    return true;
  }
}

let sNetSpeedController = SingletonHelper.getInstance(NetSpeedController, TAG);

export default sNetSpeedController as NetSpeedController;
