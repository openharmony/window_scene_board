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

import Intl from '@ohos.intl';
import { MobileDataData } from '../common/Constants';
import {
  LogDomain,
  LogHelper,
  SingletonHelper,
} from '@ohos/basicutils';
import {
  GlobalContext,
  DeviceHelper,
  PluginClickInfo,
  sEventManager,
  obtainStartAbilityWithWant,
  sSettingsUtil,
  EvtBus,
  WindowEvent,
} from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import type { EventManager } from '@ohos/frameworkwrapper';
import { EdmAdminManager } from '@ohos/systemuicommon/Index';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import Constants from '../common/Constants';
import commonEvtMgr from '@ohos.commonEventManager';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import type { CommonEventData } from 'commonEvent/commonEventData';
import telephony from '@ohos.telephony.data';
import observer from '@ohos.telephony.observer';
import sim from '@ohos.telephony.sim';
import { CellularDataEnableEvent } from '@ohos/systemuicommon';
import call from '@ohos.telephony.call';
import radio from '@ohos.telephony.radio';
// import vsim from '@hms.telephony.vsim'
import Prompt from '@ohos.promptAction';
import Settings from '@ohos.settings';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { connection, statistics } from '@kit.NetworkKit';
import { ExtAppConstants, FASlotName, WindowConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import { getSimLabelSync, SimLabel, SimType } from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubSimGetLabel';

const TAG: string = 'Ctrl.MobileDataController';
const AIRPLANE_MODE_STATUS_CLOSE: string = '0';
const MAX_SIM_COUNT_LIMIT: number = 2;
const AIR_PLANE_MODE: string = 'settings.telephony.airplanemode';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const CALLBACK_WAIT_TIME: number = 20000;
const WAIT_ENABLE_TIME: number = 1500;
const WAIT_ENABLE_NUM: number = 5;
const SINGLE_SIM_HEIGHT: number = 216;
const DEFAULT_SIM_HEIGHT: number = 280;
const PERSIST_EDM_MOBILE_DATA_CONFIG: string = 'persist.edm.mobile_data_policy';
const EDM_MOBILE_DATA_POLICY_NONE: string = 'none';
const EDM_MOBILE_DATA_POLICY_FORCE_OPEN: string = 'force_open';
const DISTRIBUTED_MODEM_STATE: string = 'distributed_modem_state';
const DISTRIBUTED_MODEM_STATE_DEFAULT: string = '0_sink';
const DISTRIBUTED_MODEM_STATE_CONNECTED: string = '1_sink';

const SUBSCRIBE_INFO : EventSubscribeInfo = {
  events: [
    commonEvtMgr.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED
  ]
};

interface EventSubscribeInfo {
  events: Array<string>;
}

class SimStatedData {
  public simStates: sim.SimState;
  public isSmiActive: boolean;

  constructor(simStates: sim.SimState, isSimActive: boolean) {
    this.simStates = simStates;
    this.isSmiActive = isSimActive;
  }
}

export class MobileDataController extends ToggleBaseViewModel {
  private mMobileDataData: MobileDataData = new MobileDataData();
  private maxSimCount: number = 0;
  private simStates: SimStatedData[] = [];
  private mobileDataEvtMgr: EventManager = EvtBus.createEventManager();
  private isWaitingLastActionDone: boolean = false;
  private isCellularDataOn: boolean = false;
  private mSubscriber: CommonEventSubscriber | null = null;
  private mdName: string | undefined = DeviceHelper.isPC() ? undefined : 'phone_settings';
  private waitCallbackId: number | null = null;
  private isVSimEnabled: boolean | undefined = undefined;
  private toastResource: Resource = $r('app.string.control_center_complex_toggle_mobiledata_toast');
  private isGettingTrafficDataUsage: boolean = false;

  public openDetailPageFunc: (() => void) | undefined = (toggleId?: string) => {
    log.showInfo(`handleLongClick, toggleId: ${toggleId}`);
    if (this.getViewData().isUnavailable) {
      if (this.isVSimEnabled) {
        this.mobileDataShowToast(this.toastResource);
      }
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_MOBILE_DATA_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      log.showInfo('mobile data disabled');
      return;
    }
    if (DeviceHelper.isPC()) {
      log.showWarn('handleLongClick: skip long click on pc');
      return;
    } else {
      this.handleOnControlCenterWithScreenLockForUIE((): void => this.showMobileDataSubWindow(toggleId), true);
      return;
    }
  }

  public static getInstance(): MobileDataController {
    return SingletonHelper.getInstance(MobileDataController, TAG);
  }

  constructor() {
    super();
    this.getViewData().label = $r('app.string.control_center_complex_toggle_mobiledata_title');
    this.getViewData().icon = $r('app.media.ic_mobiledata');
    this.onStart();
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

  /**
   * 是否需要监听卫星通信状态
   */
  needListenSatelliteMode(): boolean {
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
    this.getViewData().isUnavailable = true;
    if (!this.isAvailable()) {
      log.showError('current device is not support mobile data');
      return;
    }

    this.initAirplaneState();
    this.subscribeAirplaneMode();
    try {
      this.initSimStates(WAIT_ENABLE_NUM);
      this.initMobileDataStates();
      this.initWindowEvent();
      this.updateDisableState();
    } catch (err) {
      log.error(`init mobile data error: ${err}`);
    }
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    if (!this.isAvailable()) {
      log.showError('current device is not support mobile data');
      return;
    }
    observer.off('simStateChange');
    observer.off('iccAccountInfoChange');
    if (this.mSubscriber) {
      commonEvtMgr.unsubscribe(this.mSubscriber);
      this.mSubscriber = null;
    }
    this.mobileDataEvtMgr.offAll();
  }
  
  updateLabel() {
    if (this.getViewData().isOn) {
      if (this.mMobileDataData.actualSimCount > 1 && this.mMobileDataData.currentSimSlot > 0) {
        this.getViewData().label = this.mMobileDataData.currentSimType === SimType.PSIM ?
        $r('app.string.control_center_complex_toggle_mobiledata_title_on', this.mMobileDataData.currentSimSlot) :
        $r('app.string.control_center_complex_toggle_mobiledata_title_on_esim', this.mMobileDataData.currentSimSlot);
      } else {
        this.getViewData().label = $r('app.string.control_center_complex_toggle_mobiledata_title');
      }
      if (!this.isGettingTrafficDataUsage) {
        try {
          sim.getSimAccountInfo(this.mMobileDataData.currentSimSlot - 1).then(accountInfo => {
            this.getTrafficDataUsage(accountInfo.simId).then((totalFlows: number) => {
              this.isGettingTrafficDataUsage = false;
              let flowText: string = this.getFlowText(totalFlows);
              this.getViewData().subLabel = $r('app.string.control_center_complex_toggle_mobiledata_usage', flowText);
              log.showInfo(`update simSlot ${this.mMobileDataData.currentSimSlot} traffic data usage complete`);
            }).catch((err: Error) => {
              log.showError(`getTrafficDataUsage failed, err: ${err}`);
            })
          }).catch((err: Error) => {
            log.showError(`getSimAccountInfo failed, err: ${err}`);
          })
        } catch (err) {
          log.showError(`updateLabel failed, err: ${err}`);
        }
      }
    } else {
      this.getViewData().label = $r('app.string.control_center_complex_toggle_mobiledata_title');
    }
  }

  private async getTrafficDataUsage(simId: number = 0): Promise<number> {
    log.showInfo(`current simId: ${simId}`);
    this.isGettingTrafficDataUsage = true;
    let currentDate: Date = new Date();
    let dayOfMonth: number = currentDate.getDate();
    let month: number = currentDate.getMonth();
    let year: number = currentDate.getFullYear();
    let startDate: Date = this.getStartDate(year, month, dayOfMonth, simId);
    let endDate: Date = this.getEndDate(year, month, dayOfMonth);
    let startTime: number = Math.floor(startDate.getTime() / 1000);
    let endTime: number = Math.floor(endDate.getTime() / 1000);
    let network: statistics.NetworkInfo = {
      type: connection.NetBearType.BEARER_CELLULAR,
      startTime: startTime,
      endTime: endTime,
      simId: simId,
    };
    try {
      let data: statistics.UidNetStatsInfo = await statistics.getTrafficStatsByNetwork(network);
      let statsInfos: Map<string, object> = new Map<string, object>(Object.entries(data));
      let totalFlows: number = 0;
      for (const item of statsInfos) {
        let flows: object = item[1];
        totalFlows += this.countFlows(flows);
      }
      return totalFlows;
    } catch (e) {
      log.showError(`getTrafficStatsByNetwork failed, ${e?.code}, ${e?.message}`);
      this.isGettingTrafficDataUsage = false;
      return 0;
    }
  }

  private countFlows(flows: object): number {
    let flow: Map<string, object> = new Map<string, object>(Object.entries(flows));
    let txBytes: number = Number(flow.get('txBytes'));
    let rxBytes: number = Number(flow.get('rxBytes'));
    return (isNaN(txBytes) ? 0 : txBytes) + (isNaN(rxBytes) ? 0 : rxBytes);
  }

  private getStartDate(year: number, month: number, dayOfMonth: number, simId: number): Date {
    const monthlyStartDate: string = `net_stats_${simId}_monthly_start_date`;
    let startDay: number = Number(sSettingsUtil.getValue(monthlyStartDate, undefined));
    // 套餐默认从当月1号开始
    let startDate: Date = new Date(year, month, 1);
    if (!isNaN(startDay)) {
      if (startDay < 1) {
        return startDate;
      }
      let maxDay: number = this.getMaxDayOfMonth(year, month);
      let realStartDay: number = Math.min(startDay, maxDay);
      if (dayOfMonth < realStartDay) {
        // 套餐开始日期为15号但是今天是5号的情况,也就是从上个月开始算
        if (month === 0) {
          // 当前月份为1月的情况，套餐开始月份则为上一年的12月startDay号
          startDate = new Date(year - 1, 11, realStartDay);
        } else {
          let prevMaxDay: number = this.getMaxDayOfMonth(year, month - 1);
          startDate = new Date(year, month - 1, Math.min(startDay, prevMaxDay));
        }
      } else {
        startDate = new Date(year, month, realStartDay);
      }
    }
    return startDate;
  }

  private getEndDate(year: number, month: number, dayOfMonth: number): Date {
    return new Date(year, month, dayOfMonth + 1);
  }

  private getMaxDayOfMonth(year: number, month: number): number {
    let date: Date = new Date(year, month, 1);
    date.setMonth(date.getMonth() + 1);
    date.setDate(0);
    return date.getDate();
  }

  private getFlowText(flow: number): string {
    const unit: string[] = ['byte', 'kilobyte', 'megabyte', 'gigabyte', 'terabyte'];
    let i: number = 0;
    while (flow >= 1024 && i < 4) {
      flow = flow / 1024;
      i++;
    }
    const formatter = new Intl.NumberFormat(new Intl.Locale().baseName, {
      style: 'unit',
      unit: unit[i],
    });
    return formatter.format(Number.parseFloat(flow.toFixed(2)));
  }

  handleUpdateState(): void {
  }

  isAvailable(): boolean {
    return canIUse('SystemCapability.Telephony.CoreService') &&
      canIUse('SystemCapability.Telephony.StateRegistry') &&
      canIUse('SystemCapability.Telephony.CellularData') &&
      canIUse('SystemCapability.Notification.CommonEvent') &&
      call.hasVoiceCapability();
  }

  private mobileDataShowToast(msg: Resource): void {
    Prompt.showToast({
      message: msg,
      showMode: 2
    });
  }

  handleOneClick(): void {
    log.showInfo(`handleClick, status: ${this.getViewData().isOn}, waiting: ${this.isWaitingLastActionDone}`);
    if (this.getViewData().isUnavailable) {
      if (this.isVSimEnabled) {
        this.mobileDataShowToast(this.toastResource);
      }
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_MOBILE_DATA_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      log.showWarn('mobile data disabled');
      return;
    }
    this.getViewData().isOn = !this.getViewData().isOn;
    this.updateLabel();
    if (!this.isWaitingLastActionDone) {
      this.isWaitingLastActionDone = true;
      this.switchMobileDataStatus(this.getViewData().isOn);
    }
  }

  private initAirplaneState(): void {
    let state = sSettingsUtil.getValue(AIR_PLANE_MODE, AIRPLANE_MODE_STATUS_CLOSE);
    log.showInfo(`initAirplaneState state = ${state}`);
    if (state !== AIRPLANE_MODE_STATUS_CLOSE) {
      this.mMobileDataData.isAirplaneMode = true;
    }
  }

  private subscribeAirplaneMode(): void {
    try {
      commonEvtMgr.createSubscriber(SUBSCRIBE_INFO).then((subscriber) => {
        log.showInfo('init createSubscriber end');
        this.mSubscriber = subscriber;
        commonEvtMgr.subscribe(subscriber, (err: object | undefined, data: CommonEventData) => {
          if (err) {
            log.error(`Can't handle common event, err: ${err}`);
            return;
          }
          log.showInfo(`receive event data:${data?.event}`);
          this.handleCommonEvent(data);
        });
      });
    } catch (error) {
      log.showError('subscribe airplane error');
    }
  }

  private handleCommonEvent(data: CommonEventData): void {
    if (!data) {
      return;
    }
    if (data.event === commonEvtMgr.Support.COMMON_EVENT_AIRPLANE_MODE_CHANGED) {
      this.mMobileDataData.isAirplaneMode = String(data.code) !== AIRPLANE_MODE_STATUS_CLOSE;
      if (!this.mMobileDataData.isAirplaneMode) {
        this.updateToggleState();
      }
      this.updateDisableState();
    }
  }

  private showMobileDataSubWindow(toggleId?: string): void {
    sToggleSubWindowController.showSubWindowByClickInfo(toggleId ?? FASlotName.MOBILE_DATA, {
      clickType: 'window',
      bundleName: 'com.ohos.simcardmanagement',
      abilityName: 'MobileDataChangeExtAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: (this.maxSimCount === 2 ? DEFAULT_SIM_HEIGHT : SINGLE_SIM_HEIGHT),
    } as PluginClickInfo);
  }

  private waitCallback(): void {
    this.waitCallbackId = setTimeout(() => {
      if (!this.isWaitingLastActionDone) {
        return;
      }
      this.isWaitingLastActionDone = false;
      try {
        telephony.isCellularDataEnabled().then((enabled: boolean) => {
          this.getViewData().isOn = enabled;
          this.updateLabel();
        }).catch((err: object) => {
          log.error(`isCellularDataEnabled call failed: ${err}`);
        });
      } catch (err) {
        log.error(`isCellularDataEnabled call failed: ${err}`);
      }
    }, CALLBACK_WAIT_TIME);
  }

  private initSimStates(times: number): void {
    if (times <= 0) {
      log.showError('initSimStates times is end');
      return;
    }
    this.maxSimCount = sim.getMaxSimCount();
    log.showInfo(`max sim count is ${this.maxSimCount}`);
    if (this.maxSimCount < 0 || this.maxSimCount > MAX_SIM_COUNT_LIMIT) {
      log.showError(`invalid max sim count ${this.maxSimCount}`);
      this.maxSimCount = 0;
      // 获取最大SIM卡数失败，需要重试，避免短时数据异常导致注册监听失败
      setTimeout(() => {
        this.initSimStates(times - 1);
      }, WAIT_ENABLE_TIME);
      return;
    }

    this.simStates = new Array<SimStatedData>(this.maxSimCount);
    for (let i = 0; i < this.maxSimCount; i++) {
      this.simStates[i] = new SimStatedData(sim.SimState.SIM_STATE_UNKNOWN, false);
    }

    for (let i = 0; i < this.maxSimCount; i++) {
      try {
        sim.isSimActive(i).then((isSimActive: boolean) => {
          this.simStates[i].isSmiActive = isSimActive;
          log.showInfo('slotId: ' + i + ' isSmiActive: ' + isSimActive);
          this.updateDisableState();
        }).catch((err : Error) => {
          log.error(`isSimActive err:${err}`);
        });
      } catch (err) {
        log.error(`getSimAcitveStates:${err}`);
      }
      try {
        observer.on('simStateChange', { slotId: i }, (simState: observer.SimStateData) => {
          this.onSimStateChange(simState.state, i);
        });
        sim.getSimState(i, (err: object | undefined, state: sim.SimState) => {
          if (err) {
            log.error(`get sim state (${i}) failed: ${err}`);
          } else {
            this.onSimStateChange(state, i);
          }
        });
        observer.on('iccAccountInfoChange', () => {
          log.showInfo('on iccAccountInfoChange');
          this.getSimAcitveStates(i);
          this.updateDataSimId();
        });
      } catch (e) {
        // SIM卡状态监听失败，需要重试
        setTimeout(() => {
          this.initSimStates(times - 1);
        }, WAIT_ENABLE_TIME);
        log.error(`observe sim ${i} failed, ${e}`);
      }
    }
  }

  private getSimAcitveStates(slotId: number): void {
    try {
      sim.isSimActive(slotId).then((isSimActive: boolean) => {
        this.simStates[slotId].isSmiActive = isSimActive;
        this.updateDisableState();
      }).catch((err : Error) => {
        log.error(`isSimActive err:${err}`);
      });
    } catch (err) {
      log.error(`getSimAcitveStates:${err}`);
    }
  }

  private initMobileDataStates(): void {
    this.mobileDataEvtMgr.on(CellularDataEnableEvent, (event: CellularDataEnableEvent) => {
      clearTimeout(this.waitCallbackId);
      this.onCellularDataStateChange(event.isCellularDataEnabled());
    });
    this.tryInitEnabled(WAIT_ENABLE_NUM);
  }

  private tryInitEnabled(times: number): void {
    if (times <= 0) {
      log.showError('times is end');
      return;
    }
    log.showInfo(`tryInitEnabled, times is ${times}`);
    try {
      telephony.isCellularDataEnabled().then((enabled: boolean) => {
        this.onCellularDataStateChange(enabled);
      }).catch((err: object) => {
        log.showError(`isCellularDataEnabled call failed: ${err}`);
        setTimeout(() => {
          this.tryInitEnabled(times - 1);
        }, WAIT_ENABLE_TIME);
      });
    } catch (err) {
      setTimeout(() => {
        this.tryInitEnabled(times - 1);
      }, WAIT_ENABLE_TIME);
    }
  }

  private initWindowEvent(): void {
    this.mobileDataEvtMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.windowName === WindowConstants.WINDOW_NAME_DROPDOWN && event.isWindowStartShow()) {
        this.updateLabel();
      }
    })
  }

  private switchMobileDataStatus(isOn: boolean): void {
    if (isOn) {
      telephony.enableCellularData().then(() => {
        this.waitCallback();
        log.showInfo('enableCellularData success');
      }).catch((err: object) => {
        log.error(`enableCellularData failed: ${err}`);
        this.onCellularDataStateChange(false);
      });
    } else {
      telephony.disableCellularData().then(() => {
        this.waitCallback();
        log.showInfo('disableCellularData success');
      }).catch((err: object) => {
        log.error(`disableCellularData failed: ${err}`);
        this.onCellularDataStateChange(false);
      });
    }
  }

  private onSimStateChange(simState: sim.SimState, simId: number): void {
    log.showInfo(`onSimStateChange(${simId}): ${simState}, ${this.simStates}`);
    if (this.simStates[simId] !== undefined) {
      this.simStates[simId].simStates = simState;
    }
    this.updateDisableState();
  }

  private onCellularDataStateChange(enabled: boolean): void {
    log.showInfo(`onCellularDataStateChange, waiting: ${this.isWaitingLastActionDone},new state:${enabled},\
      ui state:${this.getViewData().isOn}, disabled:${this.getViewData().isUnavailable}`);
    this.isCellularDataOn = enabled;
    if (enabled) {
      this.updateDataSimId();
    }
    if (this.isWaitingLastActionDone && !this.getViewData().isUnavailable) {
      this.isWaitingLastActionDone = false;
      if (enabled !== this.getViewData().isOn) {
        this.switchMobileDataStatus(this.getViewData().isOn);
      }
      return;
    }
    this.isWaitingLastActionDone = false;
    this.getViewData().isOn = this.isCellularDataOn && this.mMobileDataData.actualSimCount > 0;
    this.updateLabel();
  }

  /**
   * 更新快捷开关的置灰状态
   */
  public updateDisableState(): void {
    // 飞行模式以及卫星模式，开关置灰且关闭
    if (this.mMobileDataData.isAirplaneMode || this.isSatelliteMode) {
      this.getViewData().isUnavailable = true;
      this.getViewData().isOn = false;
      log.showInfo(`updateDisableState isUnavailable true cause airplane or satellite`);
      return;
    }
    // EDM管控，开关只置灰，不做额外处理
    if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_MOBILE_DATA_CONFIG)) {
      this.getViewData().isUnavailable = true;
      log.showInfo(`updateDisableState isUnavailable true cause edm`);
      return;
    }
    try {
      // this.isVSimEnabled = vsim.getVSimStatus()?.isVSimEnabled;
    } catch (err) {
      this.isVSimEnabled = false;
      log.showError(`getVSimStatus error: ${err.code}`);
    }
    // 天际通，开关置灰
    if (this.isVSimEnabled) {
      log.showInfo(`updateDisableState isUnavailable true cause vsim`);
      this.getViewData().isUnavailable = true;
      return;
    }
    this.updateToggleState();
  }

  /**
   * 刷新当前开关以及文本
   */
  private updateToggleState(): void {
    this.mMobileDataData.actualSimCount = this.simStates.filter((state: SimStatedData) => {
      return ((state.simStates === sim.SimState.SIM_STATE_READY) ||
        (state.simStates === sim.SimState.SIM_STATE_LOADED)) &&
        (state.isSmiActive);
    }).length;
    log.showInfo(`actualSimCount:${this.mMobileDataData.actualSimCount}, isCellularDataOn: ${this.isCellularDataOn}`);
    this.getViewData().isUnavailable = this.mMobileDataData.actualSimCount <= 0 || this.getDistributedModemState();
    this.getViewData().isOn = this.isCellularDataOn && this.mMobileDataData.actualSimCount > 0;
    this.updateLabel();
  }

  private updateDataSimId(): void {
    log.showInfo(`updateDataSimId start`);
    try {
      radio.getPrimarySlotId().then((slotId) => {
        let curSimLabel: SimLabel = getSimLabelSync(slotId);
        this.mMobileDataData.currentSimType = curSimLabel?.simType ?? SimType.PSIM;
        this.mMobileDataData.currentSimSlot = curSimLabel?.index ?? slotId + 1;
        log.showInfo(`getPrimarySlotId succ: slotId:${slotId}, SimType:${curSimLabel?.simType}, currentSimSlot:${curSimLabel?.index}`);
        this.updateLabel();
      }).catch((err : Error) => {
        log.showError(`getPrimarySlotId failed: ${err}`);
      });
    } catch (err) {
      log.showError(`updateDataSimId failed: ${err}`);
    }
  }

  private goMobileDataSettings(): void {
    EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
      bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
      uri: 'mobile_data_settings_entry',
      moduleName: this.mdName
    }));
  }

  /**
   * 读取分布式通信连接状态
   */
  private getDistributedModemState(): boolean {
    let context = GlobalContext.getContext();
    let modemState = DISTRIBUTED_MODEM_STATE_DEFAULT;
    try {
      modemState = Settings.getValueSync(context, DISTRIBUTED_MODEM_STATE, DISTRIBUTED_MODEM_STATE_DEFAULT);
      log.showInfo(`get ${DISTRIBUTED_MODEM_STATE} value is ${modemState}`);
    } catch (e) {
      modemState = DISTRIBUTED_MODEM_STATE_DEFAULT;
      log.showError(`get distributed_modem_state value error. use default`);
    }
    return modemState === DISTRIBUTED_MODEM_STATE_CONNECTED;
  }
}