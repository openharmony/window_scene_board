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

import Radio from '@ohos.telephony.radio';
import Sim from '@ohos.telephony.sim';
// import Vsim from '@ohos.telephony.vsim';
import Observer from '@ohos.telephony.observer';
import {
  LogDomain,
  LogHelper,
  CommonUtils,
} from '@ohos/basicutils';
import {
  CutoutEvent,
  EvtBus,
  CustomPromise,
  GlobalContext,
  PluginSlot,
  EventManager,
  ViewArea as ScreenRect,
} from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import Constants, { CardSituation } from './common/constants';
import data from '@ohos.telephony.data';
import { CellularDataEnableEvent, LogWithHa, SatelliteModeSwitchEvent } from '@ohos/systemuicommon';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import commonEventManager from '@ohos.commonEventManager';
import dataShare from '@ohos.data.dataShare';
import type { BusinessError } from '@ohos.base';
import Settings from '@ohos.settings';
import StyleConfiguration, { SignalComponentStyle } from './common/StyleConfiguration';
import { PluginWidthChangeEvent, RegisterAPIProtector } from '@ohos/systemuicommon/Index';
import { taskpool } from '@kit.ArkTS';
import { StatusBarExceptionCode } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarExceptionCode';
// instrument ignore file
const TAG = 'SignalStatus-SignalModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const sRegisterAPIProtector: RegisterAPIProtector = RegisterAPIProtector.get();
const STRING_NULL: string = '';
const SEPARATOR: string = ' | ';
const WAIT_CLEAR_TIMEOUT: number = 5000;

let isInitObserver = false;
let lastSignalInfo: number[] = [];

const SYSTEM_SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    commonEventManager.Support.COMMON_EVENT_SPN_INFO_CHANGED
  ],
  publisherPermission: 'ohos.permission.SET_TELEPHONY_STATE'
};
const SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    'usual.event.SPN_INFO_CHANGED0',
    'usual.event.SPN_INFO_CHANGED1',
    'usual.event.SPN_INFO_CHANGED2'
  ],
  publisherPermission: 'ohos.permission.SET_TELEPHONY_STATE'
};

const IMS_SERVICE_READY_SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    'event.custom.ims.ACTION_IMS_SERVICE_READY'
  ],
  publisherPermission: 'ohos.permission.SET_TELEPHONY_STATE'
};

const NETWORK_STATE_CHANGE_SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    'usual.event.NETWORK_STATE_CHANGED'
  ],
  publisherPermission: 'ohos.permission.SET_TELEPHONY_STATE'
};

const SIM_STATE_CHANGE_SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    'usual.event.SIM_STATE_CHANGED'
  ],
  publisherPermission: 'ohos.permission.SET_TELEPHONY_STATE'
};


// 用户设置数据Uri前缀
const URI_BASE: string = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true';
// 当前通信共享状态的数据项名称
const DISTRIBUTED_STATE: string = 'distributed_modem_state';
const DISTRIBUTED_CELLULAR_DATA_SWITCH: string = 'distributed_cellular_data_switch';
// 当前通信共享状态的默认值
const DISTRIBUTED_STATE_DEFAULT: string = '0_sink';
const DISTRIBUTED_CELLULAR_DATA_SWITCH_DEFAULT: string = 'off';
// 显示通信共享图标的应设值
const DISTRIBUTED_SHOW_STATE: string = '1_sink';
const DISTRIBUTED_CELLULAR_DATA_SWITCH_ON: string = 'on';

export interface SimSpnInfo {
  isEmptySimCard: boolean;
  slotId: number;
  simName: string;
  isDomestic: boolean;
}

export const emptySim: SimSpnInfo = {
  isEmptySimCard: true,
  slotId: 0,
  simName: STRING_NULL,
  isDomestic: false
};

export interface EmergencyInfo {
  default: number;
  cardOne: number;
  cardTwo: number;
}

export const defaultEmergencyInfo: EmergencyInfo = {
  default: Constants.REG_STATE_NO_SERVICE,
  cardOne: Constants.REG_STATE_NO_SERVICE,
  cardTwo: Constants.REG_STATE_NO_SERVICE,
};

enum SimCardType {
  SIM_CARD_0 = 0,
  SIM_CARD_1 = 1,
  SIM_CARD_SKY = 2,
}

export enum SimNetworkStandardType {
  NONE,
  SECOND_G_TYPE,
  THIRD_G_TYPE,
  FOURTH_G_TYPE,
  FOURTH_PLUS_G_type,
  FIFTH_G_TYPE,
  H_TYPE,
  H_PLUS_TYPE,
  X_TYPE,
}
const SIGNAL_MARGIN_WIDTH = 2;
export class SignalModel {
  public mLevelLink?: AbstractProperty<number[]>;
  public mFlowTypeLink?: AbstractProperty<number[]>;
  public mFlowSlotId?: AbstractProperty<number>;
  public mIsRoaming?: AbstractProperty<boolean[]>;
  public mCfgTech?: AbstractProperty<number[]>;
  public mPlmnNumeric?: AbstractProperty<string[]>;
  public mHasSimCards?: AbstractProperty<boolean[]>;
  public mIsCellularDataEnabled?: AbstractProperty<boolean>;
  public mEmergency?: AbstractProperty<EmergencyInfo>;
  public mRegState?: AbstractProperty<number[]>;
  public mDataConnectState?: AbstractProperty<number[]>;
  public mEflForbidden?: AbstractProperty<string>;
  public mSimCardIsActive?: AbstractProperty<boolean[]>;
  public networkState?: AbstractProperty<string[]>;
  public mOperatorInfo?: AbstractProperty<SimSpnInfo[]>;
  public mSatelliteModeSwitch?: AbstractProperty<boolean>;
  public mDistributedModemState?: AbstractProperty<boolean>;
  public mIsDistributedCellularEnable?: AbstractProperty<boolean>;
  public mCutoutChange?: AbstractProperty<boolean>;
  public mCutoutInfo?: Map<number, ScreenRect> = new Map();
  public mCardSituation?: AbstractProperty<string>;
  public mImsState?: AbstractProperty<number[]>;

  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private mSystemSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private mImsServiceReadySubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private mNetworkStateChangeSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private mSimStateChangeSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private mSleepStateSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private ImsInfoPromiseCard1: CustomPromise<void> = new CustomPromise<void>();
  private ImsInfoPromiseCard2: CustomPromise<void> = new CustomPromise<void>();
  private dataShareHelper: dataShare.DataShareHelper | undefined = undefined;
  private distributedUri: string = '';

  // 是否在休眠中
  private isSleep: boolean = false;
  // 缓存的vSim值
  private vSimEnabled?: boolean;

  // 数据流量上下行箭头显隐时提前给cutoutAdapter发事件，调整图标位置，避免闪烁
  private style: SignalComponentStyle = StyleConfiguration.getSignalComponentStyle();
  private dataConnectState: boolean = false;
  private pluginWidthChangeEvent: PluginWidthChangeEvent = PluginWidthChangeEvent.create(PluginSlot.SLOT_STATUS_SIGNAL,
    ResUtils.getNumberFromLength(this.style.cellularImageWidth));

  private simStateChangeTimeIdMap: Map<number, number> = new Map([
    [SimCardType.SIM_CARD_0, -1],
    [SimCardType.SIM_CARD_1, -1],
    [SimCardType.SIM_CARD_SKY, -1]
  ]);
  private networkStateChangeTimeIdMap: Map<number, number> = new Map([
    [SimCardType.SIM_CARD_0, -1],
    [SimCardType.SIM_CARD_1, -1],
    [SimCardType.SIM_CARD_SKY, -1]
  ]);

  public stackSignalWidthNetworkType2Width: Map<SimNetworkStandardType, Length> = new Map([
    [SimNetworkStandardType.NONE, this.style.stackXSignalTypeImageWidth],
    [SimNetworkStandardType.SECOND_G_TYPE, this.style.stack2gSignalTypeImageWidth],
    [SimNetworkStandardType.THIRD_G_TYPE, this.style.stack3gSignalTypeImageWidth],
    [SimNetworkStandardType.FOURTH_G_TYPE, this.style.stack4gSignalTypeImageWidth],
    [SimNetworkStandardType.FOURTH_PLUS_G_type, this.style.stack4gPlusSignalTypeImageWidth],
    [SimNetworkStandardType.FIFTH_G_TYPE, this.style.stack5gSignalTypeImageWidth],
    [SimNetworkStandardType.H_TYPE, this.style.stackHSignalTypeImageWidth],
    [SimNetworkStandardType.H_PLUS_TYPE, this.style.stackHPlusSignalTypeImageWidth],
    [SimNetworkStandardType.X_TYPE, this.style.stackXSignalTypeImageWidth]
  ])

  initSignalModel(): void {
    log.showInfo('initSignalModel');
    this.mLevelLink = AppStorage.setAndRef('cellularLevel',
      [Constants.CELLULAR_NO_SIM_CARD, Constants.CELLULAR_NO_SIM_CARD,
        Constants.CELLULAR_NO_SIM_CARD]); // 信号等级
    this.networkState =
      AppStorage.setAndRef('networkState', [STRING_NULL, STRING_NULL, STRING_NULL]);
    this.mOperatorInfo =
      AppStorage.setAndRef('mOperatorInfo', [emptySim, emptySim, emptySim]); // 运营商名称
    this.mFlowTypeLink = AppStorage.setAndRef('dataFlowType',
      [Constants.DATA_FLOW_TYPE_NONE, Constants.DATA_FLOW_TYPE_NONE,
        Constants.DATA_FLOW_TYPE_NONE]); // 数据上下行标识
    this.mDataConnectState = AppStorage.setAndRef('dataConnectState',
      [Constants.DATA_STATE_UNKNOWN, Constants.DATA_STATE_UNKNOWN,
        Constants.DATA_STATE_UNKNOWN]); // 数据连接状态
    this.mFlowSlotId = AppStorage.setAndRef('dataFlowSlotId', Constants.DATA_FLOW_SLOTID_DEFAULT);
    this.mIsRoaming = AppStorage.setAndRef('isRoaming', [false, false, false]);
    this.mCfgTech = AppStorage.setAndRef('cfgTech',
      [Constants.RADIO_TECHNOLOGY_UNKNOWN, Constants.RADIO_TECHNOLOGY_UNKNOWN,
        Constants.RADIO_TECHNOLOGY_UNKNOWN]); // 网络制式
    this.mPlmnNumeric =
      AppStorage.setAndRef('plmnNumeric', [Constants.NET_NULL, Constants.NET_NULL, Constants.NET_NULL]);
    this.mHasSimCards = AppStorage.setAndRef('hasSimCards', [false, false, false]);
    this.mIsCellularDataEnabled = AppStorage.setAndRef('isCellularDataEnabled', true);
    this.mEmergency = AppStorage.setAndRef('emergency', defaultEmergencyInfo);
    this.mRegState = AppStorage.setAndRef('regState',
      [Constants.REG_STATE_NO_SERVICE, Constants.REG_STATE_NO_SERVICE, Constants.REG_STATE_NO_SERVICE]);
    this.mEflForbidden = AppStorage.setAndRef('eflForbidden', 'false');
    this.mSimCardIsActive =
      AppStorage.setAndRef('simCardIsActive', [false, false, false]); // sim卡是否激活
    this.mSatelliteModeSwitch = AppStorage.setAndRef('satelliteModeSwitch', false);
    this.mDistributedModemState = AppStorage.setAndRef('distributedModemState', false);
    this.mIsDistributedCellularEnable = AppStorage.setAndRef('isDistributedCellularEnable', false);
    this.mCutoutChange = AppStorage.setAndRef('mCutoutChange', false);
    this.mCardSituation = AppStorage.setAndRef('mCardSituation', CardSituation.NO_CARD);
    this.mImsState = AppStorage.setAndRef('mImsState', [Constants.IS_REGISTER, Constants.IS_REGISTER, Constants.IS_REGISTER]);
    this.eventMgr.on(CellularDataEnableEvent, this.onCellularDataEnableEvent);
    this.eventMgr.on(SatelliteModeSwitchEvent, this.onSatelliteModeSwitchEvent);
    this.eventMgr.on(CutoutEvent, this.handleCutoutEvent);

    if (!this.isAvailable()) {
      log.showError('current device is not support Telephony');
      return;
    }
    if (!isInitObserver) {
      this.initObserver();
    }
    this.checkCellularStatus();
    this.handleEflForbidden();
    this.subscribeSpnInfo();
    this.subscribeImsServiceReadyInfo();
    this.initDistributedListener();
    this.subscribeSleepStateChange();
  }

  private async subscribeSleepStateChange(): Promise<void> {
    const SLEEP_STATE_CHANGED_SUBSCRIBE_INFO: commonEventManager.CommonEventSubscribeInfo = {
      events: [
        'COMMON_EVENT_USER_SLEEP_STATE_CHANGED'
      ],
      publisherPermission: 'ohos.permission.PERCEIVE_SMART_POWER_SCENARIO'
    };
    try {
      log.showInfo(`subscribeSleepStateChange`);
      this.mSleepStateSubscriber = await commonEventManager.createSubscriber(SLEEP_STATE_CHANGED_SUBSCRIBE_INFO);
      commonEventManager.subscribe(this.mSleepStateSubscriber, (err, data: commonEventManager.CommonEventData) => {
        if (err && err?.code !== 0) {
          LogWithHa.error(log, `Can't handle common event, err: ${err?.message}`,
            StatusBarExceptionCode.SIGNAL_FAIL, err, TAG);
          return;
        }
        this.isSleep = data?.parameters?.isSleep;
        log.showInfo(`get isSleep: ${this.isSleep}`)
        if (!this.isSleep) {
          this.setCardSituation(this.mLevelLink?.get()!, this.mSimCardIsActive?.get()!);
        }
      });
    } catch (error) {
      LogWithHa.error(log, `createSubscriber error: ${error?.message}`,
        StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  public isDataFlow(slotId: number): boolean {
    // 无服务时
    if (this.mRegState?.get()[slotId]!== Constants.REG_STATE_IN_SERVICE) {
      return false;
    }
    // 移动数据关闭后，不展示上下行图标
    if (!this.mIsCellularDataEnabled?.get() && slotId !== 2) {
      return false
    }
    // 蜂窝数据链路处于未连接状态
    if (this.mDataConnectState?.get()[slotId] !== Constants.DATA_STATE_CONNECTED) {
      return false;
    }
    // 非子卡在位
    if (slotId === 2 && this.getSkyToneStatus() !== 2) {
      return false;
    }
    return [Constants.DATA_FLOW_TYPE_DOWN,
      Constants.DATA_FLOW_TYPE_UP,
      Constants.DATA_FLOW_TYPE_UP_DOWN,
      Constants.DATA_FLOW_TYPE_DORMANT,
      Constants.DATA_FLOW_TYPE_NONE].includes(this.mFlowTypeLink?.get()[slotId]!);
  }

  public getNormalIconWidth(slotId: number): number {
    // 天际通图标宽度
    if (slotId === 2) {
      return this.getSkyToneWidth();
    }
    const level = this.mLevelLink?.get()[slotId]!;
    let isCellularTypeDisplay = true;
    if (level < Constants.CELLULAR_SIGNAL_NO || level > Constants.CELLULAR_SIGNAL_FULL) {
      isCellularTypeDisplay = false;
    }
    let iconWidth: Length = this.style.cellularImageWidth;
    if (isCellularTypeDisplay) {
      if (this.isDataFlow(slotId)) {
        iconWidth = this.style.cellularImageWidthLong;
      }
    } else {
      iconWidth = this.style.cellularImageNoSimWidth;
    }
    return ResUtils.getNumberFromLength(iconWidth);
  }

  public getReservedFlowIconWidth(slotId: number): number {
    const level = this.mLevelLink?.get()[slotId]!;
    let isCellularTypeDisplay = true;
    if (level < Constants.CELLULAR_SIGNAL_NO || level > Constants.CELLULAR_SIGNAL_FULL) {
      isCellularTypeDisplay = false;
    }
    let iconWidth: Length = this.style.cellularImageWidth;
    if (isCellularTypeDisplay) {
      iconWidth = this.style.cellularImageWidthLong;
    } else {
      iconWidth = this.style.cellularImageNoSimWidth;
    }
    return ResUtils.getNumberFromLength(iconWidth);
  }

  public mGetCellularType(slotId: number): SimNetworkStandardType {
    // 无服务时，蜂窝网图标显示为×
    if (this.mRegState?.get()[slotId] !== Constants.REG_STATE_IN_SERVICE) {
      log.showWarn(`updateCellularType regState no service with slotId  --${slotId}`);
      return SimNetworkStandardType.X_TYPE;
    }

    let signalType = this.mCfgTech?.get()[slotId];
    log.showWarn(`updateCellularType, slotId  --${slotId}-- signalType: ${signalType} `);
    let networkType: SimNetworkStandardType = SimNetworkStandardType.NONE;
    switch (signalType) {
      case Constants.RADIO_TECHNOLOGY_GSM:
      case Constants.RADIO_TECHNOLOGY_1XRTT:
        networkType = SimNetworkStandardType.SECOND_G_TYPE;
        break;
      case Constants.RADIO_TECHNOLOGY_WCDMA:
      case Constants.RADIO_TECHNOLOGY_HSPA:
      case Constants.RADIO_TECHNOLOGY_HSPAP:
      case Constants.RADIO_TECHNOLOGY_TD_SCDMA:
      case Constants.RADIO_TECHNOLOGY_EVDO:
      case Constants.RADIO_TECHNOLOGY_EHRPD:
        networkType = SimNetworkStandardType.THIRD_G_TYPE;
        break;
      case Constants.RADIO_TECHNOLOGY_LTE:
      case Constants.RADIO_TECHNOLOGY_LTE_CA:
      case Constants.RADIO_TECHNOLOGY_IWLAN:
        networkType = SimNetworkStandardType.FOURTH_G_TYPE;
        break;
      case Constants.RADIO_TECHNOLOGY_NR:
        networkType = SimNetworkStandardType.FIFTH_G_TYPE;
        break;
      case Constants.RADIO_TECHNOLOGY_UNKNOWN:
      default:
        networkType = SimNetworkStandardType.X_TYPE;
        break;
    }
    let custNetworkType = this.updateCustCellularType(slotId);
    if (custNetworkType !== SimNetworkStandardType.NONE) {
      return custNetworkType;
    }
    return networkType;
  }

  private updateCustCellularType(slotId: number): SimNetworkStandardType {
    if (this.mCfgTech?.get()[slotId] === Constants.RADIO_TECHNOLOGY_LTE_CA) {
      // 对所有运营商只要无线网络处于LTE_CA就显示4G+图标
      return SimNetworkStandardType.FOURTH_PLUS_G_type;
    }
    if (this.isUnicom(this.mPlmnNumeric?.get()[slotId])) {
      switch (this.mCfgTech?.get()[slotId]) {
        case Constants.RADIO_TECHNOLOGY_HSPA:
          return SimNetworkStandardType.H_TYPE;
        case Constants.RADIO_TECHNOLOGY_HSPAP:
          return SimNetworkStandardType.H_PLUS_TYPE;
        default:
          return SimNetworkStandardType.NONE;
      }
    }

    if (this.mCfgTech?.get()[slotId] === Constants.RADIO_TECHNOLOGY_NR) {
      return SimNetworkStandardType.FIFTH_G_TYPE;
    }
    return SimNetworkStandardType.NONE;
  }

  /**
   * 是否是中国联通
   *
   * @param {string} plmn 运营商编码
   * @return {boolean} 是否是中国联通
   */
  private isUnicom(plmn: string | undefined): boolean {
    switch (plmn) {
      case Constants.UNICOM_GSM_PLMN:
      case Constants.UNICOM_WCDMA_PLMN:
        return true;
      default:
        return false;
    }
  }

  private getAccessibilitySimText(slotId: number): string {
    const res = GlobalContext.getContext()?.resourceManager;
    const simCardIsActives: boolean[] = this.mSimCardIsActive?.get()!;
    // 单张卡不播报SIM卡号
    if (!simCardIsActives[0] || !simCardIsActives[1] || !res) {
      return '';
    }

    if (slotId === 0) {
      return res.getStringByNameSync('accessibility_status_bar_sim1', 1);
    } else {
      return res.getStringByNameSync('accessibility_status_bar_sim2', 2);
    }
  }

  private getAccessibilitySignalRoamingText(slotId: number): string {
    const res = GlobalContext.getContext()?.resourceManager;
    if (!res) {
      return '';
    }
    const regStates: number[] = this.mRegState?.get()!;
    if (regStates[slotId] !== Constants.REG_STATE_IN_SERVICE) {
      return res.getStringByNameSync('accessibility_status_bar_no_service');
    }
    const level: number = this.mLevelLink?.get()[slotId]!;
    switch (level) {
      case Constants.CELLULAR_SIGNAL_NO:
        return res.getStringByNameSync('accessibility_status_bar_no_service');
      case Constants.CELLULAR_SIGNAL_MIN:
        return res.getStringByNameSync('accessibility_status_bar_no_signal_roaming_1_lan');
      case Constants.CELLULAR_SIGNAL_LOW:
        return res.getStringByNameSync('accessibility_status_bar_no_signal_roaming_2_lan');
      case Constants.CELLULAR_SIGNAL_HALF:
        return res.getStringByNameSync('accessibility_status_bar_no_signal_roaming_3_lan');
      case Constants.CELLULAR_SIGNAL_HIGH:
        return res.getStringByNameSync('accessibility_status_bar_no_signal_roaming_4_lan');
      case Constants.CELLULAR_SIGNAL_FULL:
        return res.getStringByNameSync('accessibility_status_bar_no_signal_roaming_5_lan');
      case Constants.CELLULAR_NO_SIM_CARD:
      default:
        return res.getStringByNameSync('accessibility_status_bar_no_sim');
    }
  }

  private getAccessibilityCellularTypeText(slotId: number): string {
    if (this.mRegState?.get()[slotId] !== Constants.REG_STATE_IN_SERVICE) {
      return '';
    }
    switch (this.mCfgTech?.get()[slotId]) {
      case Constants.RADIO_TECHNOLOGY_GSM:
      case Constants.RADIO_TECHNOLOGY_1XRTT:
        return '2G';
      case Constants.RADIO_TECHNOLOGY_WCDMA:
      case Constants.RADIO_TECHNOLOGY_HSPA:
      case Constants.RADIO_TECHNOLOGY_HSPAP:
      case Constants.RADIO_TECHNOLOGY_TD_SCDMA:
      case Constants.RADIO_TECHNOLOGY_EVDO:
      case Constants.RADIO_TECHNOLOGY_EHRPD:
        return '3G';
      case Constants.RADIO_TECHNOLOGY_LTE:
      case Constants.RADIO_TECHNOLOGY_LTE_CA:
      case Constants.RADIO_TECHNOLOGY_IWLAN:
        return '4G';
      case Constants.RADIO_TECHNOLOGY_NR:
        // 因保密要求网络类型为5G时不播报类型
        return '';
      case Constants.RADIO_TECHNOLOGY_UNKNOWN:
      default:
        return '';
    }
  }

  private getEachSimAccessibilityText(slotId: number): string {
    return this.getAccessibilitySimText(slotId) + ' ' +
    this.getAccessibilityCellularTypeText(slotId) +
    this.getAccessibilitySignalRoamingText(slotId);
  }

  public getAccessibilityText(accMode: boolean): string {
    if (!accMode) {
      return '';
    }
    return this.getEachSimAccessibilityText(0) + this.getEachSimAccessibilityText(1);
  }

  public getSkyToneWidth(): number {
    const cardSituation: string = this.mCardSituation?.get()!;
    if (cardSituation[2] !== '1') {
      return 0;
    }
    if (this.getSkyToneStatus() !== 2) {
      return ResUtils.getNumberFromLength(this.style.onlySignalImageWidth);
    }
    const dataFlow: boolean = this.isDataFlow(2);
    if (this.mGetCellularType(2) === SimNetworkStandardType.FIFTH_G_TYPE &&
      this.mEflForbidden?.get()! && !dataFlow) {
      return ResUtils.getNumberFromLength(this.style.onlySignalImageWidth);
    }
    return ResUtils.getNumberFromLength(this.style.cellularImageWidthLong);
  }

  /**
   * 状态栏通信共享图标设置项监听初始化
   */
  private async initDistributedListener(): Promise<void> {
    if (!this.getVirtualModemSwitchState()) {
      this.mDistributedModemState?.set(false);
      return;
    }
    let context = GlobalContext.getContext();
    this.distributedUri = URI_BASE;
    try {
      dataShare.createDataShareHelper(context, this.distributedUri,
        (err:BusinessError, data:dataShare.DataShareHelper) => {
          if (err !== undefined) {
            LogWithHa.error(log, `createDataShareHelper error code:${err?.code}, message:${err?.message}`);
            log.showError(`createDataShareHelper error code:${err.code}, message:${err.message}`);
            return;
          }
          log.showInfo('distributed_modem_state createDataShareHelper success');
          this.dataShareHelper = data;
          this.dataShareHelper?.on('dataChange', this.distributedUri, () => {
            onDistributedSetChange();
          });
        });
    } catch (err) {
      LogWithHa.error(log, `distributed_modem_state createDataShareHelper error code:${err?.code}, message:${err?.message}`,
        StatusBarExceptionCode.SIGNAL_FAIL, err, TAG);
    }
    const onDistributedSetChange = (): void => {
      let stateValue = DISTRIBUTED_STATE_DEFAULT;
      let switchValue = DISTRIBUTED_CELLULAR_DATA_SWITCH_DEFAULT;
      try {
        stateValue = Settings.getValueSync(context, DISTRIBUTED_STATE, DISTRIBUTED_STATE_DEFAULT);
        log.showInfo(`get ${DISTRIBUTED_STATE} value is ${stateValue}`);
        switchValue = Settings.getValueSync(context, DISTRIBUTED_CELLULAR_DATA_SWITCH,
          DISTRIBUTED_CELLULAR_DATA_SWITCH_DEFAULT);
        log.showInfo(`get ${DISTRIBUTED_CELLULAR_DATA_SWITCH} value is ${switchValue}`);
      } catch (e) {
        stateValue = DISTRIBUTED_STATE_DEFAULT;
        switchValue = DISTRIBUTED_CELLULAR_DATA_SWITCH_DEFAULT;
        LogWithHa.error(log, `get settings switch value error. use default`, StatusBarExceptionCode.SIGNAL_FAIL, e, TAG);
      }
      if (CommonUtils.isEmpty(stateValue)) {
        LogWithHa.error(log, `onDistributedSetChange stateValue is invalid or empty`, StatusBarExceptionCode.SIGNAL_FAIL);
      } else {
        this.mDistributedModemState?.set(stateValue === DISTRIBUTED_SHOW_STATE);
      }
      if (CommonUtils.isEmpty(switchValue)) {
        LogWithHa.error(log, `onDistributedSetChange stateValue is invalid or empty`, StatusBarExceptionCode.SIGNAL_FAIL);
      } else {
        this.mIsDistributedCellularEnable?.set(switchValue === DISTRIBUTED_CELLULAR_DATA_SWITCH_ON);
      }
    };
    onDistributedSetChange();
  }

  private getVirtualModemSwitchState(): boolean {
    try {
      let state: string = systemParameterEnhance.getSync('const.booster.virtual_modem_switch', 'false');
      log.info(`virtual modem switch state is : ${state}`);
      return state === 'true';
    } catch (error) {
      LogWithHa.error(log, `Failed to get virtual modem switch. Code: ${error?.code}, message: ${error?.message}`,
        StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
      return false;
    }
  }

  uninitSignalModel(): void {
    log.showInfo('uninitSignalModel');
    this.unInitObserver();
    try {
      Radio.off('imsRegStateChange', 0, Radio.ImsServiceType.TYPE_VOICE);
      Radio.off('imsRegStateChange', 1, Radio.ImsServiceType.TYPE_VOICE);
    } catch (error) {
      LogWithHa.error(log, `offRadio error: ${error?.message}`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
    try {
      this.dataShareHelper?.off('dataChange', this.distributedUri);
      log.showInfo('unregister distribute data share listener success');
    } catch (err) {
      LogWithHa.error(log, `unregister distribute data share listener error: ${err?.message}`,
        StatusBarExceptionCode.SIGNAL_FAIL, err, TAG);
    }
    if (this.mImsServiceReadySubscriber) {
      try {
        commonEventManager.unsubscribe(this.mImsServiceReadySubscriber);
        this.mImsServiceReadySubscriber = null;
      } catch (error) {
        LogWithHa.error(log, `commonEvtMgr unsubscribe error: ${error?.message}`,
          StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
      }
    }
  }

  isAvailable(): boolean {
    try {
      return canIUse('SystemCapability.Telephony.CoreService');
    } catch (err) {
      LogWithHa.error(log, `isAvailable err: ${err?.message}`, StatusBarExceptionCode.SIGNAL_FAIL, err, TAG);
      return false;
    }
  }

  /**
   * Check the connection type and signal level of cellular network
   */
  checkCellularStatus(): void {
    // 分别查询卡槽1和卡槽2的sim卡状态信息
    this.queryHasSimCard(0);
    this.queryHasSimCard(1);
    this.handleSimCardIsActive(0);
    this.handleSimCardIsActive(1);
    this.handleDataConnectState(0);
    this.handleDataConnectState(1);
  }

  queryHasSimCardByAccountInfo(slotId: number): void {
    try {
      Sim.getSimAccountInfo(slotId, (accountErr, accountInfo) => {
        // 进一步验证是否有卡
        if (Constants.NO_SIM_CARD_ERROR_CODE.includes(accountErr?.code)) {
          this.setHasSimCard(slotId, false);
          this.handleNoSimCard(slotId);
          log.showInfo(`slotId ${slotId} accountErr ${accountErr}}`);
          return;
        }

       this.setHasSimCard(slotId, true);

        // 查询卡是否激活
        if (accountInfo) {
          this.setSimCardIsActive(slotId, accountInfo.isActive);
        }

        //The interface of getting the cellular signal status is unavailable temporarily
        this.getSignalInformation(slotId);
        if (!isInitObserver) {
          this.initObserver();
        }
      });
    } catch (error) {
      // 标记无卡和无服务
      this.setHasSimCard(slotId, false);
      this.setEmergency(Constants.REG_STATE_NO_SERVICE, slotId);
      LogWithHa.error(log, `Sim.getSimAccountInfo error: ${error?.message}`,
        StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  queryHasSimCard(slotId: number): void {
    try {
      Sim.hasSimCard(slotId, (err, value) => {
        if (value === true) {
          this.queryHasSimCardByAccountInfo(slotId);
        } else {
          log.showInfo(`no sim card: slotId:${slotId} err:${err?.message} value: ${value}`);
          this.setHasSimCard(slotId, false);
          this.handleNoSimCard(slotId);
        }
      });
    } catch (error) {
      // 标记无卡和无服务
      this.setHasSimCard(slotId, false);
      this.setEmergency(Constants.REG_STATE_NO_SERVICE, slotId);
      LogWithHa.error(log, `Sim.hasSimCard error`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  getSignalInformation(slotId: number): void {
    try {
      Radio.getSignalInformation(slotId, (err, value) => {
        if (err) {
          // Failed to call the interface，error is not null
          LogWithHa.error(log, `slotId:${slotId} failed to getSimState because ${err?.message}`,
            StatusBarExceptionCode.SIGNAL_FAIL, err, TAG);
          // When failed to call the interface, set the result as no signal
          this.setSimLevelLink(slotId, Constants.CELLULAR_SIGNAL_NO);
        } else {
          if (!value || !value.length) {
            log.showInfo(`${slotId} value from api is empty, set 0`);
            this.setSimLevelLink(slotId, Constants.CELLULAR_SIGNAL_NO);
          } else {
            this.setSimLevelLink(slotId, value[0].signalLevel);
          }
        }

        //The interface of getting the cellular signal status is unavailable temporarily
        Radio.getNetworkState(slotId, (err, value) => {
          if (err) {
            // Failed to call the interface，error is not null
            LogWithHa.error(log, `failed to getnetworkState because ${slotId} ${err?.message}`,
              StatusBarExceptionCode.SIGNAL_FAIL, err, TAG);
            // When failed to call the interface, set the result as no signal
            this.handleResetSimInfo(slotId);
            this.setEmergency(Constants.REG_STATE_NO_SERVICE, slotId);
          } else {
            if (!value) {
              log.showInfo(`slotId: ${slotId} value from api is empty, set 0`);
              this.handleResetSimInfo(slotId);
              this.setEmergency(Constants.REG_STATE_NO_SERVICE, slotId);
            } else {
              log.showWarn(`slotId: ${slotId} ,regState value: ${value.regState} ,cfgTech value: ${value.cfgTech}`);
              this.setEmergency(value.regState, slotId);
              this.setSimIsRoaming(slotId, value.isRoaming);
              this.setSimCfgTech(slotId, value.cfgTech);
              this.setSimPlmnNumeric(slotId, value.plmnNumeric);
              this.setSimRegState(slotId, value.regState);
            }
          }
        });
      });
    } catch (err) {
      LogWithHa.error(log, `getSignalInformation failed, message : ${err?.message}, code : ${err?.code}`,
        StatusBarExceptionCode.SIGNAL_FAIL, err, TAG);
    }
  }

  handleEmergency(): void {
    try {
      Radio.getNetworkState((err, data) => {
        if (err) {
          LogWithHa.error(log, `failed to getnetworkState without card because ${err?.message}`,
            StatusBarExceptionCode.SIGNAL_FAIL, err, TAG);
          this.setEmergency(Constants.REG_STATE_NO_SERVICE);
          return;
        }
        if (data) {
          log.showInfo(`getnetworkState without card info isEmergency:${data?.isEmergency}`);
          this.setEmergency(data.regState);
        }
      });
    } catch (error) {
      this.setEmergency(Constants.REG_STATE_NO_SERVICE);
      LogWithHa.error(log, `handleEmergency Radio error`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  handleDataConnectState(slotId: number): void {
    try {
      data.getCellularDataState().then((dataConnectState: data.DataConnectState) => {
        try {
          this.getDefaultCellularDataSlotId(dataConnectState, slotId);
        } catch (error) {
          log.error(`getDefaultCellularDataSlotId fail err->${error?.code}`);
        }
      });
    } catch (error) {
      LogWithHa.error(log, `getCellularDataState error: ${error?.message}`, StatusBarExceptionCode.SIGNAL_FAIL, error,
        TAG);
    }
  }

  getDefaultCellularDataSlotId(dataConnectState: data.DataConnectState, slotId: number): void {
    data.getDefaultCellularDataSlotId((err: BusinessError, contextData: number) => {
      if (err) {
        log.error(`getDefaultCellularDataSlotId fail,callback: err->${err?.code}, contextData->${contextData}`);
      } else {
        let defaultCellularDataSlotId = contextData;
        log.showInfo(`get defaultCellularDataSlotId: ${defaultCellularDataSlotId} dataConnectState: ${dataConnectState}`);
        if (defaultCellularDataSlotId === slotId) {
          this.setDataConnectState(slotId, dataConnectState);
        } else {
          this.setDataConnectState(slotId, Constants.DATA_STATE_UNKNOWN);
        }
      }
    });
  }

  handleEflForbidden(): void {
    try {
      let eflForbidden = systemParameterEnhance.getSync('const.telephony.efl_forbidden', 'false');
      log.showInfo(`eflForbidden value: ${eflForbidden}`);
      this.mEflForbidden?.set(eflForbidden);
    } catch (error) {
      LogWithHa.error(log, `handleEmergency  error`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  handleNoSimCard(slotId: number): void {
    this.handleEmergency();
    log.showError(`slotId: ${slotId} - hasSimCard failed to hasSimCard because`);
    this.setSimLevelLink(slotId, Constants.CELLULAR_NO_SIM_CARD);
    this.setSimCfgTech(slotId, Constants.RADIO_TECHNOLOGY_UNKNOWN);
    this.setSimCardIsActive(slotId, false);
    this.handleResetSimInfo(slotId);
    if (!isInitObserver) {
      this.initObserver();
    }
  }

  handleResetSimInfo(slotId: number): void {
    this.setSimIsRoaming(slotId, false);
    this.setSimCfgTech(slotId, Constants.RADIO_TECHNOLOGY_UNKNOWN);
    this.setSimPlmnNumeric(slotId, Constants.NET_NULL);
    this.setSimRegState(slotId, Constants.REG_STATE_NO_SERVICE);
  }

  setEmergency(emergency: number, slotId: number = -1): void {
    log.showDebug(`setEmergency-- slotId: ${slotId} emergency: ${emergency}`);
    let tempEmergency: EmergencyInfo = this.mEmergency?.get()!;
    if (slotId === 0) {
      tempEmergency.cardOne = emergency;
    } else if (slotId === 1) {
      tempEmergency.cardTwo = emergency;
    }
    // 无论什么情况这个default都要是最新的emergency
    tempEmergency.default = emergency;
    this.mEmergency?.set(tempEmergency);
  }

  setSimLevelLink(slotId: number, level: number): void {
    let levelLink: number[] = this.mLevelLink?.get()!;
    levelLink[slotId] = level;
    lastSignalInfo[slotId] = level;
    log.showInfo(`setSimLevelLink-- slotId: ${slotId} -- to level: ${level} `);
    this.mLevelLink?.set(levelLink);

    this.setCardSituation(levelLink, this.mSimCardIsActive?.get()!);
  }

  async getVSimEnabled(): Promise<boolean> {
    if (this.isSleep && this.vSimEnabled !== undefined) {
      return this.vSimEnabled;
    }
    this.vSimEnabled = await taskpool.execute(getVSimEnabledByTaskpool) as boolean;
    return this.vSimEnabled;
  }

  async setCardSituation(levelLink: number[], simCardIsActive: boolean[]): Promise<void> {
    const isVSimEnabled = await this.getVSimEnabled();
    log.showDebug(`setCardSituation: levelLink: ${levelLink.join(',')}, simCardIsActive: ${simCardIsActive.join(',')}`);
    // 均无卡时 使用卡0的图标组件来显示(空卡图标)
    if (levelLink[0] === Constants.CELLULAR_NO_SIM_CARD &&
      levelLink[1] === Constants.CELLULAR_NO_SIM_CARD &&
      (!isVSimEnabled || (levelLink[2] === Constants.CELLULAR_NO_SIM_CARD && isVSimEnabled))) {
      log.showDebug(`setCardSituation: ${CardSituation.NO_CARD_EMPTY}`);
      this.mCardSituation?.set(CardSituation.NO_CARD_EMPTY);
      return;
    }

    // 仅天际通(当卡1和卡2都无卡时, 判断天际通有无不再判断其是否激活)
    if (levelLink[0] === Constants.CELLULAR_NO_SIM_CARD &&
      levelLink[1] === Constants.CELLULAR_NO_SIM_CARD &&
      levelLink[2] !== Constants.CELLULAR_NO_SIM_CARD && isVSimEnabled) {
      log.showDebug(`setCardSituation: ${CardSituation.SINGLE_CARD_SKY}`);
      this.mCardSituation?.set(CardSituation.SINGLE_CARD_SKY);
      return;
    }

    const cardSituation: string[] = [];
    if (levelLink[0] !== Constants.CELLULAR_NO_SIM_CARD && levelLink[1] !== Constants.CELLULAR_NO_SIM_CARD) {
      cardSituation[0] = simCardIsActive[0] ? '1' : '0';
      cardSituation[1] = simCardIsActive[1] ? '1' : '0';
      cardSituation[2] = simCardIsActive[2] && levelLink[2] !== Constants.CELLULAR_NO_SIM_CARD && isVSimEnabled ? '1' : '0';
    } else {
      cardSituation[0] = levelLink[0] !== Constants.CELLULAR_NO_SIM_CARD ? '1' : '0';
      cardSituation[1] = levelLink[1] !== Constants.CELLULAR_NO_SIM_CARD ? '1' : '0';
      cardSituation[2] = simCardIsActive[2] && levelLink[2] !== Constants.CELLULAR_NO_SIM_CARD && isVSimEnabled ? '1' : '0';
    }

    log.showDebug(`setCardSituation: ${cardSituation.join('')}`);
    this.mCardSituation?.set(cardSituation.join(''));
  }

  setSimRegState(slotId: number, regState: number): void {
    if (regState < Constants.REG_STATE_IN_SERVICE) {
      this.setDataConnectState(slotId, Constants.DATA_STATE_UNKNOWN);
    }

    let regStates: number[] = this.mRegState?.get()!;
    regStates[slotId] = regState;
    this.mRegState?.set(regStates);
  }

  setSimIsRoaming(slotId: number, isRoaming: boolean): void {
    let isRoamings: boolean[] = this.mIsRoaming?.get()!;
    isRoamings[slotId] = isRoaming;
    log.showDebug(`setSimIsRoaming-- slotId: ${slotId} -- to isRoaming: ${isRoaming} `);
    this.mIsRoaming?.set(isRoamings);
  }

  setSimCfgTech(slotId: number, cfgTech: number): void {
    let cfgTechs: number[] = this.mCfgTech?.get()!;
    cfgTechs[slotId] = cfgTech;
    this.mCfgTech?.set(cfgTechs);
  }

  setSimPlmnNumeric(slotId: number, plmnNumeric: string): void {
    let plmnNumerics: string[] = this.mPlmnNumeric?.get()!;
    plmnNumerics[slotId] = plmnNumeric;
    log.showDebug(`setSimPlmnNumeric-- slotId: ${slotId} -- to plmnNumeric: ${plmnNumeric} `);
    this.mPlmnNumeric?.set(plmnNumerics);
  }

  setSimInfo(slotId: number, operatorInfo: SimSpnInfo): void {
    let simInfo: string[] = this.networkState?.get()!;
    simInfo[slotId] = operatorInfo.simName;
    this.networkState?.set(simInfo);

    let tempInfo: SimSpnInfo[] = this.mOperatorInfo?.get()!;
    tempInfo[slotId] = operatorInfo;
    this.mOperatorInfo?.set(tempInfo);
  }

  setIMSInfo(slotID: number, imsRefInfo: Radio.ImsRegInfo): void {
    // IMS是否注册
    const isRegistered: boolean = imsRefInfo.imsRegState === Radio.ImsRegState.IMS_REGISTERED;
    let imsIconState = isRegistered ? Constants.IS_REGISTER : Constants.IS_UNREGISTER;
    // 若 IMS 成功注册、是否处于4G或NR网络下
    if (isRegistered && (imsRefInfo.imsRegTech === Radio.ImsRegTech.REGISTRATION_TECH_LTE ||
        imsRefInfo.imsRegTech === Radio.ImsRegTech.REGISTRATION_TECH_NR)) {
      imsIconState = Constants.IS_HD_REGISTER_TECH;
    } else if (isRegistered && imsRefInfo.imsRegTech === Radio.ImsRegTech.REGISTRATION_TECH_IWLAN) {
      imsIconState = Constants.IS_WLAN_REGISTER_TECH;
    }
    log.showInfo(`setIMSInfo ${slotID}, ${imsIconState}`);
    let imsState: number[] = this.mImsState?.get()!;
    imsState[slotID] = imsIconState;
    this.mImsState?.set(imsState);
  }

  /**
   * init the observer of the cellular and signal
   */
  initObserver(): void {
    log.showInfo('initObserver');
    isInitObserver = true;
    this.subscribeSignalInfoChange();
    this.subscribeNetworkStateChange();
    this.subscribeSimStateChange();
    this.subscribeCellularDataFlowChange();
    this.subscribeCellularDataConnectionStateChange();
    this.subscribeIccAccountInfoChange();
    this.subscribeIMSChange();
  }

  // 刷新sim卡状态，只关注信号类型与信号级别，屏蔽信号dBm差异
  private handleSignalInfoChange(slotId: number, signalInfoChange: Radio.SignalInformation[]): void {
    if (!signalInfoChange || !signalInfoChange.length) {
      log.showInfo(`signalInfoChange invalid. ${slotId}`);
      this.queryHasSimCard(slotId);
      return;
    }

    const signalInfo: Radio.SignalInformation = signalInfoChange[0];
    if (lastSignalInfo[slotId] !== signalInfo?.signalLevel) {
      log.showInfo(`card${slotId} info change from:${lastSignalInfo[slotId]}to:${signalInfo.signalLevel}`);
      this.queryHasSimCard(slotId);
    }
    lastSignalInfo[slotId] = signalInfo?.signalLevel;
  }

  // 双卡要分别查询卡1和卡2
  private subscribeSignalInfoChange(): void {
    try {
      Observer.on('signalInfoChange', { slotId: 0 }, (signalInfoChange) => {
        this.handleSignalInfoChange(0, signalInfoChange);
      });
      Observer.on('signalInfoChange', { slotId: 1 }, (signalInfoChange) => {
        this.handleSignalInfoChange(1, signalInfoChange);
      });
      Observer.on('signalInfoChange', { slotId: 2 }, (signalInfoChange) => {
        this.handleSignalInfoChange(2, signalInfoChange);
      });
    } catch (error) {
      LogWithHa.error(log, `init observer signalInfoChange failed message: ${error?.message}`,
        StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  private handleNetworkStateChangeTimeout(data: commonEventManager.CommonEventData): void {
    if (this.networkStateChangeTimeIdMap.has(data?.parameters?.slotId)) {
      let networkStateChangeTimeoutTimeId = this.networkStateChangeTimeIdMap.get(data?.parameters?.slotId);
      if (networkStateChangeTimeoutTimeId !== -1) {
        clearTimeout(networkStateChangeTimeoutTimeId);
        this.networkStateChangeTimeIdMap.set(data?.parameters?.slotId, -1);
      }
      networkStateChangeTimeoutTimeId = setTimeout(() => {
        log.showInfo(`networkStateChange card ${data?.parameters?.slotId}`);
        this.queryHasSimCard(data?.parameters?.slotId);
        this.networkStateChangeTimeIdMap.set(data?.parameters?.slotId, -1);
      }, WAIT_CLEAR_TIMEOUT);
      this.networkStateChangeTimeIdMap.set(data?.parameters?.slotId, networkStateChangeTimeoutTimeId);
    }
  }

  // 网络状态改变
  private subscribeNetworkStateChange(): void {
    sRegisterAPIProtector.run(TAG, 'networkStateChange0',
      this.subscribeNetworkStateChangeFunc as (...args: Object[]) => void, SimCardType.SIM_CARD_0);
    sRegisterAPIProtector.run(TAG, 'networkStateChange1',
      this.subscribeNetworkStateChangeFunc as (...args: Object[]) => void, SimCardType.SIM_CARD_1);
    sRegisterAPIProtector.run(TAG, 'networkStateChangeSKY',
      this.subscribeNetworkStateChangeFunc as (...args: Object[]) => void, SimCardType.SIM_CARD_SKY);
    this.subscribeNetworkStateChangeBroadcast();
  }
  public subscribeNetworkStateChangeFunc = (simSlotId: number): void => {
    Observer.on('networkStateChange', { slotId: simSlotId }, (networkState) => {
      log.showInfo(`networkStateChange card ${simSlotId}: ${networkState?.plmnNumeric}`);
      this.queryHasSimCard(simSlotId);
    });
  };

  private async subscribeNetworkStateChangeBroadcast(): Promise<void> {
    try {
      log.showInfo('subscribeNetworkStateChange');
      this.mNetworkStateChangeSubscriber =
        await commonEventManager.createSubscriber(NETWORK_STATE_CHANGE_SUBSCRIBE_INFO);
      commonEventManager.subscribe(this.mNetworkStateChangeSubscriber, (err, data) => {
        if (err) {
          log.showError(`Failed to subscribe common event. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        this.handleNetworkStateChangeTimeout(data);
      });
    } catch (error) {
      LogWithHa.error(log, `createSubscriber error: ${error?.message}`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  isTelecom(plmn: string): boolean {
    switch (plmn) {
      case Constants.TELECOM_CDMA_PLMN:
      case Constants.TELECOM_CDMA2_PLMN:
      case Constants.TELECOM_FDD_PLMN:
        return true;
      default:
        return false;
    }
  }

  subscribeIMSChange(): void {
    log.showInfo(`subscribeIMSChange`);
    this.ImsInfoPromiseCard1 = new CustomPromise<void>();
    this.ImsInfoPromiseCard2 = new CustomPromise<void>();
    /*
    * 1、手动通过 getImsRegInfo 获取IMS最新信息
    * 2、再注册 imsRegStateChange 变化回调
    * 3、时序控制需要保证 getImsRegInfo 在 imsRegStateChange 之前，避免旧数据覆盖新数据
     */
    Radio.getImsRegInfo(0, Radio.ImsServiceType.TYPE_VOICE, (err: BusinessError, imsRefInfo: Radio.ImsRegInfo) => {
      log.showWarn(`radio getImsRegInfo 0, error code: ${err?.code},` +
        ` state: ${imsRefInfo?.imsRegState}, tech: ${imsRefInfo?.imsRegTech}.`);
      !err && this.setIMSInfo(0, imsRefInfo);
      this.ImsInfoPromiseCard1.resolve();
    });
    Radio.getImsRegInfo(1, Radio.ImsServiceType.TYPE_VOICE, (err: BusinessError, imsRefInfo: Radio.ImsRegInfo) => {
      log.showWarn(`radio getImsRegInfo 1, error code: ${err?.code},` +
        ` state: ${imsRefInfo?.imsRegState}, tech: ${imsRefInfo?.imsRegTech}.`);
      !err && this.setIMSInfo(1, imsRefInfo);
      this.ImsInfoPromiseCard2.resolve();
    });
    try {
      Radio.on('imsRegStateChange', 0, Radio.ImsServiceType.TYPE_VOICE, async (imsRefInfo: Radio.ImsRegInfo) => {
        log.showWarn(`radio on receive 0, state: ${imsRefInfo?.imsRegState}, tech: ${imsRefInfo?.imsRegTech}.`);
        await this.ImsInfoPromiseCard1;
        log.showWarn(`radio on await pass 0`);
        this.setIMSInfo(0, imsRefInfo);
      });
      Radio.on('imsRegStateChange', 1, Radio.ImsServiceType.TYPE_VOICE, async (imsRefInfo: Radio.ImsRegInfo) => {
        log.showWarn(`radio on receive 1, state: ${imsRefInfo?.imsRegState}, tech: ${imsRefInfo?.imsRegTech}.`);
        await this.ImsInfoPromiseCard2;
        log.showWarn(`radio on await pass 1`);
        this.setIMSInfo(1, imsRefInfo);
      });
    } catch (error) {
      LogWithHa.error(log, `radio ims sub failed ${error?.message}`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
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
        this.queryHasSimCard(data?.parameters?.slotId);
        this.simStateChangeTimeIdMap.set(data?.parameters?.slotId, -1);
      }, WAIT_CLEAR_TIMEOUT);
      this.simStateChangeTimeIdMap.set(data?.parameters?.slotId, simStateChangeTimeoutTimeId);
    }
  }

  private subscribeSimStateChange(): void {
    sRegisterAPIProtector.run(TAG, 'simStateChange0',
      this.subscribeSimStateChangeFunc as (...args: Object[]) => void, SimCardType.SIM_CARD_0);
    sRegisterAPIProtector.run(TAG, 'simStateChange1',
      this.subscribeSimStateChangeFunc as (...args: Object[]) => void, SimCardType.SIM_CARD_1);
    sRegisterAPIProtector.run(TAG, 'simStateChangeSKY',
      this.subscribeSimStateChangeFunc as (...args: Object[]) => void, SimCardType.SIM_CARD_SKY);
    this.subscribeSimStateChangeBroadcast();
  }
  public subscribeSimStateChangeFunc = (simSlotId: number): void => {
    Observer.on('simStateChange', { slotId: simSlotId }, (simStateInfo) => {
      log.showInfo(`simStateChange card ${simSlotId}: ${simStateInfo?.state}`);
      this.queryHasSimCard(simSlotId);
    });
  };

  private async subscribeSimStateChangeBroadcast(): Promise<void> {
    try {
      log.showInfo('subscribeSimStateChange');
      this.mSimStateChangeSubscriber = await commonEventManager.createSubscriber(SIM_STATE_CHANGE_SUBSCRIBE_INFO);
      commonEventManager.subscribe(this.mSimStateChangeSubscriber, (err, data) => {
        if (err) {
          log.showError(`Failed to subscribe common event. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        this.handleSimStateChangeTimeout(data);
      });
    } catch (error) {
      LogWithHa.error(log, `createSubscriber error: ${error?.message}`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  private subscribeCellularDataFlowChange(): void {
    try {
      Observer.on('cellularDataFlowChange', { slotId: 0 }, (dataFlowInfo) => {
        log.showInfo(`cellularDataFlowChange card0:${dataFlowInfo}`);
        this.setFlowTypeLink(0, dataFlowInfo);
      });
      Observer.on('cellularDataFlowChange', { slotId: 1 }, (dataFlowInfo) => {
        log.showInfo(`cellularDataFlowChange card1:${dataFlowInfo}`);
        this.setFlowTypeLink(1, dataFlowInfo);
      });
      Observer.on('cellularDataFlowChange', { slotId: 2 }, (dataFlowInfo) => {
        log.showInfo(`cellularDataFlowChange card2:${dataFlowInfo}`);
        this.setFlowTypeLink(2, dataFlowInfo);
      });
    } catch (error) {
      // fanhao
      LogWithHa.error(log, `init observer cellularDataFlowChange failed message: ${error?.message}`,
        StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  private subscribeCellularDataConnectionStateChange(): void {
    try {
      Observer.on('cellularDataConnectionStateChange', { slotId: 0 }, value => {
        log.showInfo(`cellularDataConnectionStateChange card0:${value?.state}, ${value?.network}`);
        this.setFlowSlotId();
        this.setDataConnectState(0, value.state);
        this.dataConnectState = value.state === Constants.DATA_STATE_CONNECTED;
        this.updatePluginWidthChangeEvent();
      });
      Observer.on('cellularDataConnectionStateChange', { slotId: 1 }, value => {
        log.showInfo(`cellularDataConnectionStateChange card1:${value?.state}, ${value?.network}`);
        this.setFlowSlotId();
        this.setDataConnectState(1, value.state);
        this.dataConnectState = value.state === Constants.DATA_STATE_CONNECTED;
        this.updatePluginWidthChangeEvent();
      });
      Observer.on('cellularDataConnectionStateChange', { slotId: 2 }, value => {
        log.showInfo(`cellularDataConnectionStateChange card2:${value?.state}, ${value?.network}`);
        this.setFlowSlotId();
        this.setDataConnectState(2, value.state);
        this.dataConnectState = value.state === Constants.DATA_STATE_CONNECTED;
        this.updatePluginWidthChangeEvent();
      });
    } catch (error) {
      LogWithHa.error(log, `init observer cellularDataConnectionStateChange failed message: ${error?.message}`,
        StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  private subscribeIccAccountInfoChange(): void {
    try {
      Observer.on('iccAccountInfoChange', () => {
        log.showInfo('iccAccountInfoChange');
        this.setFlowSlotId();
        this.handleSimCardIsActive(0);
        this.handleSimCardIsActive(1);
        this.handleSimCardIsActive(2);

        this.queryHasSimCard(0);
        this.queryHasSimCard(1);
        this.queryHasSimCard(2);
      });
    } catch (error) {
      LogWithHa.error(log, `init observer iccAccountInfoChange failed message: ${error?.message}`,
        StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  private async subscribeSpnInfo(): Promise<void> {
    try {
      log.showInfo(`subscribeSpnInfo`);
      this.mSystemSubscriber = await commonEventManager.createSubscriber(SYSTEM_SUBSCRIBE_INFO);
      commonEventManager.subscribe(this.mSystemSubscriber, this.handleSpnChangedEvent);
    } catch (error) {
      LogWithHa.error(log, `createSubscriber error: ${error?.message}`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
    try {
      log.showInfo(`subscribeSpnInfo`);
      this.mSubscriber = await commonEventManager.createSubscriber(SUBSCRIBE_INFO);
      commonEventManager.subscribe(this.mSubscriber, this.handleSpnChangedEvent);
    } catch (error) {
      LogWithHa.error(log, `createSubscriber error: ${error?.message}`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  private async subscribeImsServiceReadyInfo(): Promise<void> {
    try {
      log.showInfo('subscribeImsServiceReadyInfo');
      this.mImsServiceReadySubscriber = await commonEventManager.createSubscriber(IMS_SERVICE_READY_SUBSCRIBE_INFO);
      commonEventManager.subscribe(this.mImsServiceReadySubscriber, () => {
        try {
          log.showInfo('unsubscribeIMSChange');
          Radio.off('imsRegStateChange', 0, Radio.ImsServiceType.TYPE_VOICE);
          Radio.off('imsRegStateChange', 1, Radio.ImsServiceType.TYPE_VOICE);
        } catch (error) {
          LogWithHa.error(log, `offRadio error: ${error?.message}`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
        }
        this.subscribeIMSChange();
      });
    } catch (error) {
      LogWithHa.error(log, `createSubscriber error: ${error?.message}`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  private handleSpnChangedEvent: (err: BusinessError, data: commonEventManager.CommonEventData) => void =
    (err, data: commonEventManager.CommonEventData) => {
    if (err && err?.code !== 0) {
      LogWithHa.error(log, `Can't handle common event, err: ${err?.message}`, StatusBarExceptionCode.SIGNAL_FAIL, err, TAG);
      return;
    }
    log.showInfo(`receive spn event data:${data?.event}`);
    if (data && (SUBSCRIBE_INFO.events.indexOf(data.event) !== -1 ||
      data.event === commonEventManager.Support.COMMON_EVENT_SPN_INFO_CHANGED)) {
      const CUR_SLOT_ID: number = data.parameters?.CUR_SLOT_ID;
      const CUR_PLMN: string = data.parameters?.CUR_PLMN;
      const CUR_PLMN_SHOW: number = data.parameters?.CUR_PLMN_SHOW;
      const CUR_SPN_SHOW: number = data.parameters?.CUR_SPN_SHOW;
      const CUR_SPN: string = data.parameters?.CUR_SPN;
      const DOMESTIC_SPN: string = data.parameters?.DOMESTIC_SPN;
      // 依据参数直接拼接运营商名称得到最终结果
      let simName: string = STRING_NULL;
      if (CUR_PLMN_SHOW && !CommonUtils.isEmpty(CUR_PLMN)) {
        simName = CUR_PLMN;
      }
      if (CUR_SPN_SHOW && !CommonUtils.isEmpty(CUR_SPN)) {
        simName = CommonUtils.isEmpty(simName) ? CUR_SPN : `${simName}${SEPARATOR}${CUR_SPN}`;
      }
      let isDomestic: boolean = !CommonUtils.isEmpty(DOMESTIC_SPN);
      if (isDomestic) {
        simName = CommonUtils.isEmpty(simName) ? DOMESTIC_SPN : `${DOMESTIC_SPN}${SEPARATOR}${simName}`;
      }
      let simInfo: SimSpnInfo = {
        isEmptySimCard: CommonUtils.isEmpty(simName),
        slotId: CUR_SLOT_ID,
        simName: simName,
        isDomestic: isDomestic
      };
      log.showInfo(`handleSpnChangedEvent slotId : ${CUR_SLOT_ID} , simName : ${simName} , isDomestic : ${isDomestic}`);
      this.setSimInfo(CUR_SLOT_ID, simInfo);
    }
  };

  /**
   * 刷新上下行数据连接类型
   *
   * @param slotId 卡ID
   * @param dataFlowInfo 蜂窝数据流类型
   */
  setFlowTypeLink(slotId: number, dataFlowInfo: number): void {
    let flowTypeLink: number[] = this.mFlowTypeLink?.get()!;
    flowTypeLink[slotId] = dataFlowInfo;
    this.mFlowTypeLink?.set(flowTypeLink);
  }

  /**
   * 刷新蜂窝数据链路连接状态
   *
   * @param slotId 卡ID
   * @param dataConnectState 蜂窝数据链路连接状态
   */
  setDataConnectState(slotId: number, dataConnectState: number): void {
    let dataConnectStateLink: number[] = this.mDataConnectState?.get()!;
    dataConnectStateLink[slotId] = dataConnectState;
    this.mDataConnectState?.set(dataConnectStateLink);
  }

  /**
   * 刷新卡账户ID
   */
  setFlowSlotId(): void {
    try {
      data.getDefaultCellularDataSlotId((err: BusinessError, contextData: number) => {
        if (err) {
          log.error(`getDefaultCellularDataSlotId fail,callback: err->${err?.code}, contextData->${contextData}`);
        } else {
          let defaultSlotId = contextData;
          log.showInfo(`get defaultSlotId: ${defaultSlotId}`);
          this.mFlowSlotId?.set(defaultSlotId);
        }
      });
    } catch (error) {
      log.error(`getDefaultCellularDataSlotId fail err->${error?.code}`);
    }
  }

  /**
   * 刷新SIM卡激活状态
   * Update SIM card active status
   *
   * @param slotId 卡ID
   * @param isActive 卡是否被激活
   */
  setSimCardIsActive(slotId: number, isActive: boolean): void {
    let simCardIsActives: boolean[] = this.mSimCardIsActive?.get()!;
    simCardIsActives[slotId] = isActive;
    log.showDebug(`setSimCardIsActive slotId: ${slotId} -- to isActive: ${isActive} `);
    this.mSimCardIsActive?.set(simCardIsActives);

    this.setCardSituation(this.mLevelLink?.get()!, simCardIsActives);
  }

  setHasSimCard(slotId: number, hasSimCard: boolean): void {
    let hasSimCards: boolean[] = this.mHasSimCards?.get()!;

    hasSimCards[slotId] = hasSimCard;
    log.showDebug(`setHasSimCard slotId: ${slotId} -- to hasSimCard: ${hasSimCard}, hasSimCards: ${hasSimCards.join(',')}`);

    this.mHasSimCards?.set(hasSimCards);
  }

  /**
   * 获取指定卡槽SIM卡的帐户信息
   * Get SIM card account info
   *
   * @param slotId 卡ID
   */
  handleSimCardIsActive(slotId: number): void {
    try {
      Sim.getSimAccountInfo(slotId).then((data: Sim.IccAccountInfo) => {
        log.showInfo(`card ${slotId} getSimAccountInfo success`);
        if (data.slotIndex === slotId && CommonUtils.isBoolean(data.isActive)) {
          this.setSimCardIsActive(slotId, data.isActive);
        }
      }).catch((err: Error) => {
        LogWithHa.error(log, `card ${slotId} getSimAccountInfo failed, err->${err?.message}`,
          StatusBarExceptionCode.SIGNAL_FAIL, err, TAG);
      });
    } catch (error) {
      LogWithHa.error(log, `card ${slotId} getSimAccountInfo error message: ${error?.message}`,
        StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
  }

  /**
   * Uninit the observer of the cellular and signal
   */
  unInitObserver(): void {
    log.showInfo('unInitObserver');
    try {
      Observer.off('signalInfoChange');
      Observer.off('networkStateChange');
      Observer.off('simStateChange');
      isInitObserver = false;
    } catch (error) {
      LogWithHa.error(log, `unInitObserver error`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
    }
    if (this.mSimStateChangeSubscriber) {
      try {
        commonEventManager.unsubscribe(this.mSimStateChangeSubscriber);
        this.mSimStateChangeSubscriber = null;
      } catch (error) {
        LogWithHa.error(log, `commonEvtMgr unsubscribe error: ${error?.message}`,
          StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
      }
    }
    if (this.mNetworkStateChangeSubscriber) {
      try {
        commonEventManager.unsubscribe(this.mNetworkStateChangeSubscriber);
        this.mNetworkStateChangeSubscriber = null;
      } catch (error) {
        LogWithHa.error(log, `commonEvtMgr unsubscribe error: ${error?.message}`,
          StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
      }
    }
    if (this.mSubscriber) {
      try {
        commonEventManager.unsubscribe(this.mSubscriber);
        this.mSubscriber = null;
      } catch (error) {
        LogWithHa.error(log, `commonEvtMgr unsubscribe error`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
      }
    }
    if (this.mSystemSubscriber) {
      try {
        commonEventManager.unsubscribe(this.mSystemSubscriber);
        this.mSystemSubscriber = null;
      } catch (error) {
        LogWithHa.error(log, `commonEvtMgr unsubscribe error`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
      }
    }
    if (this.mSleepStateSubscriber) {
      try {
        commonEventManager.unsubscribe(this.mSleepStateSubscriber);
        this.mSleepStateSubscriber = null;
      } catch (error) {
        LogWithHa.error(log, `commonEvtMgr unsubscribe error`, StatusBarExceptionCode.SIGNAL_FAIL, error, TAG);
      }
    }
  }

  /**
   * 显示移动数据开关事件设置变化回调
   *
   * @param event 显示移动数据开关事件
   */
  private onCellularDataEnableEvent = (event: CellularDataEnableEvent): void => {
    const isEnable: boolean = event.isCellularDataEnabled();
    log.showInfo('onCellularDataEnableEvent isEnable: ' + isEnable);
    this.mIsCellularDataEnabled?.set(isEnable);
    // 数据流量开关变化时提前发宽度变化事件
    this.updatePluginWidthChangeEvent();
  };

  /**
   * 仙人掌开关事件设置变化回调
   * @param event 仙人掌开关事件
   */
  private onSatelliteModeSwitchEvent = (event: SatelliteModeSwitchEvent): void => {
    const isEnable: boolean = event.satelliteModeSwitch();
    log.showInfo('onSatelliteModeSwitchEvent switch: ' + isEnable);
    this.mSatelliteModeSwitch?.set(isEnable);
  };

  private handleCutoutEvent = (event: CutoutEvent): void => {
    if (!event?.cutoutRect) {
      log.showInfo('handleCutoutEvent cutout rect is null.');
      return;
    }
    this.mCutoutInfo?.set(event.cutoutPosition, event.cutoutRect);
    // 用一个布尔变量触发挖孔信息改变的刷新
    this.mCutoutChange?.set(!this.mCutoutChange?.get()!);
  };

  /**
   * 获取孔类型和宽度
   * @returns
   */
  public getCutoutInfo(): CutoutEvent {
    let cutoutEvent = CutoutEvent.create(0, null);
    let orders = [CutoutEvent.CUTOUT_MID, CutoutEvent.CUTOUT_LEFT, CutoutEvent.CUTOUT_RIGHT];
    for (let order of orders) {
      let info = this.mCutoutInfo?.get(order);
      if (!CommonUtils.isInvalidRect(info)) {
        cutoutEvent.cutoutPosition = order;
        cutoutEvent.cutoutRect = info!;
        break;
      }
    }
    return cutoutEvent;
  }

  public updatePluginWidthChangeEvent(stackWidth?: number): void {
    if (stackWidth && stackWidth > 0) {
      this.pluginWidthChangeEvent.setWidth(stackWidth);
      EvtBus.post(PluginWidthChangeEvent, this.pluginWidthChangeEvent);
      return;
    }
    if (this.mLevelLink && this.mLevelLink[0] === Constants.CELLULAR_NO_SIM_CARD &&
      this.mLevelLink[1] === Constants.CELLULAR_NO_SIM_CARD &&
      this.mLevelLink[2] === Constants.CELLULAR_NO_SIM_CARD) {
      return;
    }
    const cellularImageWidth = ResUtils.getNumberFromLength(this.style.cellularImageWidth);
    let width = cellularImageWidth;
    if (this.mIsCellularDataEnabled?.get() && this.dataConnectState) {
      width = ResUtils.getNumberFromLength(this.style.cellularImageWidthLong);
    }
    const marginWidth = SIGNAL_MARGIN_WIDTH;
    const cardSituation: string = this.mCardSituation?.get()!;
    if (cardSituation === CardSituation.DUAL_CARD_0_1 ||
      cardSituation === CardSituation.DUAL_CARD_SKY_0 ||
      cardSituation === CardSituation.DUAL_CARD_SKY_1) {
      width = width + cellularImageWidth + marginWidth;
    } else if (cardSituation === CardSituation.TRIPLE_CARD) {
      width = width + cellularImageWidth * 2 + marginWidth * 2;
    }

    this.pluginWidthChangeEvent.setWidth(width);
    if (this.pluginWidthChangeEvent.getChangeDelta() > 0 &&
      this.pluginWidthChangeEvent.getChangeDelta() <= (cellularImageWidth + marginWidth)) {
      EvtBus.post(PluginWidthChangeEvent, this.pluginWidthChangeEvent);
    }
  }

  public getSkyToneStatus(): number {
    let status = -1;
    try {
      // status = JSON.parse(Vsim.getVSimPlatformCapability()).curVSimCardType;
    } catch {
      log.error('get getSkyToneStatus error');
    }
    log.showInfo(`getSkyToneStatus: ${status}`);
    return status;
  }
}

/**
 * 获取VSim启用状态
 *
 * @returns 是否启用VSim
 */
async function getVSimEnabledByTaskpool(): Promise<boolean> {
  'use concurrent';
  const TAG = 'SignalStatus-SignalModel';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
  try {
    /*const isVSimEnabled:ESObject = Vsim.getVSimStatus().isVSimEnabled;
    log.showInfo(`vsim status is ${isVSimEnabled}`);
    return isVSimEnabled;*/
    return false;
  } catch (err) {
    log.showError(`getVSimEnabled error: ${err.message}`);
    return false;
  }
}

let mSignalModel = new SignalModel();

export default mSignalModel as SignalModel;