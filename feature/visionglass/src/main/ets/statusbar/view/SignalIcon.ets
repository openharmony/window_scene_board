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

import Constants from '@ohos/signalcomponent/src/main/ets/default/common/constants';
import mSignalModel from '@ohos/signalcomponent/src/main/ets/default/signalModel';
import data from '@ohos.telephony.data';
import AirplaneController from '@ohos/airplanecomponent/src/main/ets/default/controller/AirplaneController';
import Sim from '@ohos.telephony.sim';
import { resourceManager } from '@kit.LocalizationKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { EvtBus } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { SignalCardSituation, SimID } from '../common/SignalConstants';
import { ToggleViewData } from '@ohos/systemuicommon/src/main/ets/template/toggle/vm/ToggleViewData';

const TAG: string = 'SignalIcon';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);
const COMPONENT_ID_CELLULAR = TAG + '_Image_cellular';
const COMPONENT_ID_FLOW = TAG + '_Image_flow';
const COMPONENT_ID_CELLULAR_IMAGE = TAG + '_Image_cellularImage';

// 信号内容变化时(仅处理单双卡切换、无卡切换、有无移动数据传输、上下行dataFlow)广播事件，专门用于状态栏避孔。待跨孔实现后，该Event可删除
export class SignalIconChangeEvent {
  public static eventTypeName: string = 'SignalIconChangeEvent';
}

export class SignalStyle {
  public readonly cellularImageWidth: Length = '36px';
  public readonly cellularImageWidthLong: Length = '36px';
  public readonly cellularImageAirWidth: Length = '36px';
  public readonly cellularImageNoSimWidth: Length = '36px';
  public readonly cellularImageHeight: Length = '36px';
}

const SIM_COUNT_0 = 0;
@Component
export default struct SignalIcon {
  @StorageLink('cellularLevel') @Watch('refreshCellularInfo') cellularLevel: number[] =
    [Constants.CELLULAR_NO_SIM_CARD, Constants.CELLULAR_NO_SIM_CARD, Constants.CELLULAR_NO_SIM_CARD];
  @StorageLink('simCardIsActive') @Watch('refreshCellularInfo') simCardIsActive: boolean[] = [false, false, false];
  @StorageLink('signalObserved') signalObserved: boolean = false;
  @StorageLink('satelliteModeSwitch') satelliteModeSwitch: boolean = false;
  @State firstSlotId: number = 0;
  @State cardSituation: number = 0;
  @State @Watch('postSignalEvent') hasTwoSimCard: boolean = false;
  @StorageProp('AirplaneModel_AirplaneStatus') mAirplaneData: ToggleViewData = AirplaneController.getViewData();
  @State simCount: number = 0;
  @Consume contentColor: string;
  private signalIconChangeEvent: SignalIconChangeEvent = new SignalIconChangeEvent();

  refreshCellularInfo() {
    log.showInfo(`refreshCellularInfo  cellularLevel: ${this.cellularLevel[0]}, ${this.cellularLevel[1]}, ${this.cellularLevel[2]}`);
    // 单卡时，默认显示有卡片的卡槽的sim卡
    // 卡槽1有sim卡，卡槽2没有sim卡，cardSituation = 0
    if (this.cellularLevel[0] !== Constants.CELLULAR_NO_SIM_CARD &&
      this.cellularLevel[1] === Constants.CELLULAR_NO_SIM_CARD) {
      this.hasTwoSimCard = false;
      this.cardSituation = this.simCardIsActive[2] && this.cellularLevel[2] !== Constants.CELLULAR_NO_SIM_CARD && 0;
      log.showInfo('process slot 0 and slot 2');
    }
    // 均无卡时 使用卡0的图标组件来显示
    if (this.cellularLevel[0] === Constants.CELLULAR_NO_SIM_CARD &&
      this.cellularLevel[1] === Constants.CELLULAR_NO_SIM_CARD) {
      this.cardSituation = 0;
      log.showInfo('process slot no card 0');
    }
    // 卡槽1没有sim卡，卡槽2有sim卡，cardSituation = 1
    if (this.cellularLevel[0] === Constants.CELLULAR_NO_SIM_CARD &&
      this.cellularLevel[1] !== Constants.CELLULAR_NO_SIM_CARD) {
      this.hasTwoSimCard = false;
      this.cardSituation = this.simCardIsActive[2] && this.cellularLevel[2] !== Constants.CELLULAR_NO_SIM_CARD && 1;
      log.showInfo('process slot 1 and slot 2');
    }
    // 卡槽1和卡槽2都有sim卡，根据启用状态区分
    this.refreshCellularInfoByActiveState();
    log.showInfo(`refreshCellularInfo cellularLevel: ${this.cellularLevel.join(',')},Situation:${this.cardSituation}`);
  }

  refreshCellularInfoByActiveState() {
    // 卡槽1和卡槽2都有sim卡，根据启用状态区分
    if (this.cellularLevel[0] !== Constants.CELLULAR_NO_SIM_CARD &&
      this.cellularLevel[1] !== Constants.CELLULAR_NO_SIM_CARD) {
      this.hasTwoSimCard = true;
      // 双卡，卡1被激活，卡2关闭，显示卡1
      if (this.simCardIsActive[0] && !this.simCardIsActive[1]) {
        this.cardSituation =
          this.simCardIsActive[2] && this.cellularLevel[2] !== Constants.CELLULAR_NO_SIM_CARD && 0;
        log.showInfo('process slot 0 and slot 2');
      } else if (!this.simCardIsActive[0] && this.simCardIsActive[1]) { // 双卡，卡1关闭，卡2被激活，显示卡2
        this.cardSituation =
          this.simCardIsActive[2] && this.cellularLevel[2] !== Constants.CELLULAR_NO_SIM_CARD && 1;
        log.showInfo('process slot 1 and slot 2');
      } else if (!this.simCardIsActive[0] && !this.simCardIsActive[1]) { // 双卡，卡1关闭，卡2关闭，显示一张无信号的卡图标
        this.cardSituation =
          this.simCardIsActive[2] && this.cellularLevel[2] !== Constants.CELLULAR_NO_SIM_CARD && 3;
        log.showInfo('process slot 2');
      } else { // 双卡都被激活
        this.cardSituation =
          this.simCardIsActive[2] && this.cellularLevel[2] !== Constants.CELLULAR_NO_SIM_CARD && 2;
        log.showInfo('process slot 0 and slot 1 and slot 2');
      }
    }
  }

  postSignalEvent() {
    EvtBus.post(SignalIconChangeEvent, this.signalIconChangeEvent);
  }

  aboutToAppear() {
    this.simCount = Sim.getMaxSimCount();
    log.showInfo(`aboutToAppear this.simCount is ${this.simCount}`);
    if (!this.signalObserved) {
      mSignalModel.initSignalModel();
      this.signalObserved = true;
    }
    this.refreshCellularInfo();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Row() {
      if (this.mAirplaneData.isOn) {
        AirPlaneIcon()
      } else if (this.satelliteModeSwitch) {
        SatelliteIcon()
      } else if (this.simCount > SIM_COUNT_0) {
        if (this.cardSituation === SignalCardSituation.SINGLE_SIM_0) { // 单卡0
          SingleSignalIcon({ slotId: SimID.SINGLE_SIM_0, signalIconChangeEvent: this.signalIconChangeEvent })
        } else if (this.cardSituation === SignalCardSituation.SINGLE_SIM_1) { // 单卡1
          SingleSignalIcon({ slotId: SimID.SINGLE_SIM_1, signalIconChangeEvent: this.signalIconChangeEvent })
        } else if (this.cardSituation === SignalCardSituation.DOUBLE_SIM_1) { // 双卡01
          SingleSignalIcon({ slotId: SimID.SINGLE_SIM_0, signalIconChangeEvent: this.signalIconChangeEvent })
          Row().width('1vp').height('100%')
          SingleSignalIcon({ slotId: SimID.SINGLE_SIM_1, signalIconChangeEvent: this.signalIconChangeEvent })
        } else if (this.cardSituation === SignalCardSituation.NONE_SIM) { // 无卡
          EmptySignalIcon()
        } else if (this.cardSituation === SignalCardSituation.SKY_TONE_U_SINGLE_SIM_0) { // 天际通 +单卡0
          SingleSignalIcon({ slotId: SimID.SKY_TONE, signalIconChangeEvent: this.signalIconChangeEvent })
          Row().width('1vp').height('100%')
          SingleSignalIcon({ slotId: SimID.SINGLE_SIM_0, signalIconChangeEvent: this.signalIconChangeEvent })
        } else if (this.cardSituation === SignalCardSituation.SKY_TONE_U_SINGLE_SIM_1) { // 天际通 +单卡1
          SingleSignalIcon({ slotId: SimID.SKY_TONE, signalIconChangeEvent: this.signalIconChangeEvent })
          Row().width('1vp').height('100%')
          SingleSignalIcon({ slotId: SimID.SINGLE_SIM_1, signalIconChangeEvent: this.signalIconChangeEvent })
        } else if (this.cardSituation === SignalCardSituation.SKY_TONE_U_NONE_SIM) { // 天际通 +无卡
          SingleSignalIcon({ slotId: SimID.SKY_TONE, signalIconChangeEvent: this.signalIconChangeEvent })
        } else if (this.cardSituation === SignalCardSituation.SKY_TONE_U_DOUBLE_SIM_1) { // 天际通 +双卡
          SingleSignalIcon({ slotId: SimID.SKY_TONE, signalIconChangeEvent: this.signalIconChangeEvent })
          Row().width('1vp').height('100%')
          SingleSignalIcon({ slotId: SimID.SINGLE_SIM_0, signalIconChangeEvent: this.signalIconChangeEvent })
          Row().width('1vp').height('100%')
          SingleSignalIcon({ slotId: SimID.SINGLE_SIM_1, signalIconChangeEvent: this.signalIconChangeEvent })
        }
      }
    }
    .height('100%')
    .opacity($r('app.float.icon_component_opacity'))
  }
}

@Component
struct SingleSignalIcon {
  @StorageLink('networkState') @Watch('refreshNetworkState') networkState: string[] =
    [Constants.NET_NULL, Constants.NET_NULL, Constants.NET_NULL];
  @StorageLink('cellularLevel') @Watch('refreshCellularDisplay') cellularLevel: number[] =
    [Constants.CELLULAR_NO_SIM_CARD, Constants.CELLULAR_NO_SIM_CARD, Constants.CELLULAR_SIGNAL_NO];
  @StorageLink('regState') @Watch('refreshCellularDisplay') regState: number[] =
    [Constants.REG_STATE_NO_SERVICE, Constants.REG_STATE_NO_SERVICE];
  @StorageLink('isRoaming') @Watch('refreshCellularDisplay') isRoaming: boolean[] = [false, false, false];
  @StorageLink('cfgTech') @Watch('refreshCellularDisplay') cfgTech: number[] =
    [Constants.RADIO_TECHNOLOGY_UNKNOWN, Constants.RADIO_TECHNOLOGY_UNKNOWN, Constants.RADIO_TECHNOLOGY_UNKNOWN];
  @StorageLink('plmnNumeric') plmnNumeric: string[] = [Constants.NET_NULL, Constants.NET_NULL, Constants.NET_NULL];
  @StorageLink('dataFlowType') @Watch('handleRefreshFlowType') dataFlowType: number[] =
    [Constants.DATA_FLOW_TYPE_NONE, Constants.DATA_FLOW_TYPE_NONE, Constants.DATA_FLOW_TYPE_NONE];
  @StorageLink('dataConnectState') @Watch('handleRefreshFlowType') dataConnectState: number[] =
    [Constants.DATA_STATE_UNKNOWN, Constants.DATA_STATE_UNKNOWN, Constants.DATA_STATE_UNKNOWN];
  @StorageLink('dataFlowSlotId') @Watch('handleRefreshFlowType') defaultCellularDataSlotid: number =
    Constants.DATA_FLOW_SLOTID_DEFAULT;
  @StorageLink('isCellularDataEnabled') @Watch('handleRefreshFlowType') isCellularDataEnabled: boolean = true;
  @StorageLink('simCardIsActive') @Watch('refreshCellularDisplay') simCardIsActive: boolean[] = [false, false, false];
  @StorageLink('eflForbidden') eflForbidden: string = 'false';
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @State style: SignalStyle = new SignalStyle();
  @State cellularTypeDisplay: Resource = $r('app.media.ic_statusbar_signal_type_x'); // 网络制式图片左上角
  @State cellularImageDisplay: Resource = $r('app.media.ic_statusbar_signal_nosim'); // 卡信号栏格数图标
  @State cellFlowTypeDisplay: Resource = $r('app.media.ic_statusbar_signal_up_down'); // 数据上下行图片左下角
  @State @Watch('onSignalChange') isFlowTypeDisplay: boolean = false;
  @State @Watch('onSignalChange') isCellularTypeDisplay: boolean = false;
  @State @Watch('onSignalChange') dataFlow: boolean = false;
  @State showXg: boolean = true;
  @Prop slotId: number = 0;
  @Consume statusBarType: number;
  /**
   * 内容颜色
   */
  @Consume contentColor: string;
  @Prop signalIconChangeEvent: SignalIconChangeEvent;

  async aboutToAppear() {
    this.defaultCellularDataSlotid = await data.getDefaultCellularDataSlotId();
    log.showInfo(`aboutToAppear, defaultCellularDataSlotid: ${this.defaultCellularDataSlotid}`);
    this.refreshNetworkState();
  }

  refreshNetworkState() {
    log.showInfo('refreshNetworkState operatorName');
    // 网络状态刷新，需要同步刷新信号显示
    this.refreshCellularDisplay();
    this.handleRefreshFlowType();
  }

  refreshCellularDisplay() {
    this.showXg = true;
    this.dataFlow = this.isDataFlow(this.slotId);
    this.cellularTypeDisplay = this.updateCellularType(this.slotId);
    this.cellularImageDisplay = this.updateCellularImage(this.slotId);
  }

  handleRefreshFlowType() {
    log.showInfo(`handleRefreshFlowType, slotId  --${this.slotId}--statusBarType: ${this.statusBarType}`);
    // 更新完数据卡后，需要同步刷新信号显示图标
    this.refreshCellularDisplay();
    let flowtype = this.updateCellularFlowType(this.slotId);
    if (flowtype === null) {
      log.showInfo('handleRefreshFlowType, flowtype == null');
      this.isFlowTypeDisplay = false;
      return;
    }
    this.cellFlowTypeDisplay = flowtype;
    this.isFlowTypeDisplay = true;
  }

  /*
   * 是否有数据传输,有数据传输：信号塔 长 ||无数据传输：信号塔 短
   */
  isDataFlow(slotId: number): boolean {
    log.showInfo(`isDataFlow, slotId ${slotId} flowType: ${this.dataFlowType[slotId]} regState:${this.regState[slotId]} dataConnectState:${this.dataConnectState[slotId]}`);
    // 无服务时
    if (this.regState[slotId] !== Constants.REG_STATE_IN_SERVICE) {
      return false;
    }
    // 移动数据关闭后，不展示上下行图标
    log.showInfo(`handleRefreshFlowType isCellularDataEnabled: ${this.isCellularDataEnabled}`);
    if (!this.isCellularDataEnabled) {
      return false
    }
    // 蜂窝数据链路处于未连接状态
    if (this.dataConnectState[slotId] !== Constants.DATA_STATE_CONNECTED) {
      return false;
    }
    return [Constants.DATA_FLOW_TYPE_DOWN,
      Constants.DATA_FLOW_TYPE_UP,
      Constants.DATA_FLOW_TYPE_UP_DOWN,
      Constants.DATA_FLOW_TYPE_DORMANT,
      Constants.DATA_FLOW_TYPE_NONE].includes(this.dataFlowType[slotId]);
  }

  // 仅回调会影响宽度的场景
  onSignalChange(): void {
    EvtBus.post(SignalIconChangeEvent, this.signalIconChangeEvent);
  }

  /*
   * 是否是中国联通
   *
   * @param {string} plmn 运营商编码
   * @return {boolean} 是否是中国联通
   */
  isUnicom(plmn: string): boolean {
    switch (plmn) {
      case Constants.UNICOM_GSM_PLMN:
      case Constants.UNICOM_WCDMA_PLMN:
        return true;
      default:
        return false;
    }
  }

  /*
   * Get the string of cellular type
   *
   * @param {number} type - number of cellular type
   * @return {string} typeString type of cellular type
   */
  private updateCellularType(slotId: number) {
    // 无服务时，蜂窝网图标显示为×
    if (this.regState[slotId] !== Constants.REG_STATE_IN_SERVICE) {
      log.showInfo(`updateCellularType regState no service with slotId  --${slotId}`);
      return slotId === 2 ? $r('app.media.ic_statusbar_skytone_signal_type_x') :
      $r('app.media.ic_statusbar_signal_type_x');
    }
    let signalType = this.cfgTech[slotId];
    log.showInfo(`updateCellularType, slotId  --${slotId}-- signalType: ${signalType} --statusBarType: ${this.statusBarType} --dataFlow: ${this.dataFlow} eflForbidden: ${this.eflForbidden}`);
    let typeImage: Resource;
    switch (signalType) {
      case Constants.RADIO_TECHNOLOGY_GSM:
      case Constants.RADIO_TECHNOLOGY_1XRTT:
        typeImage = slotId === 2 ? $r('app.media.ic_statusbar_signal_type_2g_lang') :
          this.dataFlow ? $r('app.media.ic_statusbar_signal_type_2g_lang') :
          $r('app.media.ic_statusbar_signal_type_2g_short');
        break;
      case Constants.RADIO_TECHNOLOGY_WCDMA:
      case Constants.RADIO_TECHNOLOGY_HSPA:
      case Constants.RADIO_TECHNOLOGY_HSPAP:
      case Constants.RADIO_TECHNOLOGY_TD_SCDMA:
      case Constants.RADIO_TECHNOLOGY_EVDO:
      case Constants.RADIO_TECHNOLOGY_EHRPD:
        typeImage = slotId === 2 ? $r('app.media.ic_statusbar_signal_type_3g_lang') :
          this.dataFlow ? $r('app.media.ic_statusbar_signal_type_3g_lang') :
          $r('app.media.ic_statusbar_signal_type_3g_short');
        break;
      case Constants.RADIO_TECHNOLOGY_LTE:
      case Constants.RADIO_TECHNOLOGY_LTE_CA:
      case Constants.RADIO_TECHNOLOGY_IWLAN:
        typeImage = slotId === 2 ? $r('app.media.ic_statusbar_signal_type_4g_lang') :
          this.dataFlow ? $r('app.media.ic_statusbar_signal_type_4g_lang') :
          $r('app.media.ic_statusbar_signal_type_4g_short');
        break;
      case Constants.RADIO_TECHNOLOGY_NR:
        if (this.eflForbidden === 'true') {
          this.showXg = false;
        }
        typeImage = slotId === 2 ? $r('app.media.ic_statusbar_signal_type_5g_lang') :
          this.dataFlow ? $r('app.media.ic_statusbar_signal_type_5g_lang') :
          $r('app.media.ic_statusbar_signal_type_5g_short');
        break;
      case Constants.RADIO_TECHNOLOGY_UNKNOWN:
      default:
        typeImage = slotId === 2 ? $r('app.media.ic_statusbar_skytone_signal_type_x') :
        $r('app.media.ic_statusbar_signal_type_x');
        break;
    }
    let custImage = this.updateCustCellularType(slotId);
    typeImage = custImage === null ? typeImage : custImage;
    return typeImage;
  }

  /*
   * 信号类型国内三大运营商定制显示
   *
   * @param {number} slotId - 卡槽槽位
   * @return {string} cellularImage image of cellular signal
   */
  private updateCustCellularType(slotId: number) {
    log.showInfo(`updateCustCellularType, slotId  --${slotId}--cfgTech: ${this.cfgTech[slotId]} --statusBarType: ${this.statusBarType} --dataFlow: ${this.dataFlow}`);
    if (this.cfgTech[slotId] === Constants.RADIO_TECHNOLOGY_LTE_CA) {
      // 对所有运营商只要无线网络处于LTE_CA就显示4G+图标
      return slotId === 2 ? $r('app.media.ic_statusbar_signal_type_4gplus_lang') :
        this.dataFlow ? $r('app.media.ic_statusbar_signal_type_4gplus_lang') :
        $r('app.media.ic_statusbar_signal_type_4gplus_short');
    }

    if (this.isUnicom(this.plmnNumeric[slotId])) {
      switch (this.cfgTech[slotId]) {
        case Constants.RADIO_TECHNOLOGY_HSPA:
          return slotId === 2 ? $r('app.media.ic_statusbar_signal_type_h_lang') :
            this.dataFlow ? $r('app.media.ic_statusbar_signal_type_h_lang') :
            $r('app.media.ic_statusbar_signal_type_h_short');
        case Constants.RADIO_TECHNOLOGY_HSPAP:
          return slotId === 2 ? $r('app.media.ic_statusbar_signal_type_hplus_lang') :
            this.dataFlow ? $r('app.media.ic_statusbar_signal_type_hplus_lang') :
            $r('app.media.ic_statusbar_signal_type_hplus_short');
        default:
          return null;
      }
    }

    if (this.cfgTech[slotId] === Constants.RADIO_TECHNOLOGY_NR) {
      if (this.eflForbidden === 'true') {
        this.showXg = false;
      }
      return slotId === 2 ? $r('app.media.ic_statusbar_signal_type_5g_lang') :
        this.dataFlow ? $r('app.media.ic_statusbar_signal_type_5g_lang') :
        $r('app.media.ic_statusbar_signal_type_5g_short');
    }
    return null;
  }

  private getRoamingSignal(slotId: number, signalLevel: number) {
    if (this.dataFlow) {
      return slotId === 2 ? $r(`app.media.ic_statusbar_skystone_signal_${signalLevel}_lang`) :
        this.isRoaming[slotId] ? $r(`app.media.ic_statusbar_signal_roaming_${signalLevel}_lang`) :
        $r(`app.media.ic_statusbar_signal_${signalLevel}_lang`);
    }
    return slotId === 2 ? $r(`app.media.ic_statusbar_skystone_signal_${signalLevel}_lang`) :
      this.isRoaming[slotId] ? $r(`app.media.ic_statusbar_signal_roaming_${signalLevel}_short`) :
      $r(`app.media.ic_statusbar_signal_${signalLevel}_short`);
  }

  /*
   * Get the cellular signal image
   *
   * @param {number} level - signal level from signalModel
   * @return {string} cellularImage image of cellular signal
   */
  private updateCellularImage(slotId: number) {
    let level = this.cellularLevel[slotId]
    log.showInfo(`updateCellularImage, slotId  --${slotId}--level: ${level} --statusBarType: ${this.statusBarType} --dataFlow: ${this.dataFlow}`);
    let cellularImage: Resource;
    this.isCellularTypeDisplay = true;
    switch (level) {
      case Constants.CELLULAR_SIGNAL_NO:
        cellularImage = this.getRoamingSignal(slotId, Constants.CELLULAR_SIGNAL_NO);
        break;
      case Constants.CELLULAR_SIGNAL_MIN:
        cellularImage = this.getRoamingSignal(slotId, Constants.CELLULAR_SIGNAL_MIN);
        break;
      case Constants.CELLULAR_SIGNAL_LOW:
        cellularImage = this.getRoamingSignal(slotId, Constants.CELLULAR_SIGNAL_LOW);
        break;
      case Constants.CELLULAR_SIGNAL_HALF:
        cellularImage = this.getRoamingSignal(slotId, Constants.CELLULAR_SIGNAL_HALF);
        break;
      case Constants.CELLULAR_SIGNAL_HIGH:
        cellularImage = this.getRoamingSignal(slotId, Constants.CELLULAR_SIGNAL_HIGH);
        break;
      case Constants.CELLULAR_SIGNAL_FULL:
        cellularImage = this.getRoamingSignal(slotId, Constants.CELLULAR_SIGNAL_FULL);
        break;
      case Constants.CELLULAR_NO_SIM_CARD:
      default:
        cellularImage = $r('app.media.ic_statusbar_signal_nosim');
        this.isCellularTypeDisplay = false;
        break;
    }

    // 无服务且有卡时，信号图标显示为0级信号图标
    if (this.regState[slotId] !== Constants.REG_STATE_IN_SERVICE && this.isCellularTypeDisplay) {
      log.showInfo(`updateCellularImage regState no service with slotId  --${slotId}`);
      if (this.dataFlow) {
        cellularImage = slotId === 2 ? $r('app.media.ic_statusbar_skystone_signal_0_lang') :
          this.isRoaming[slotId] ? $r('app.media.ic_statusbar_signal_roaming_0_lang') :
          $r('app.media.ic_statusbar_signal_0_lang');
      } else {
        cellularImage = slotId === 2 ? $r('app.media.ic_statusbar_skystone_signal_0_lang') :
          this.isRoaming[slotId] ? $r('app.media.ic_statusbar_signal_roaming_0_short') :
          $r('app.media.ic_statusbar_signal_0_short');
      }
    }
    return cellularImage;
  }

  private updateCellularFlowType(slotId: number): Resource | null {
    log.showInfo(`updateCellularFlowType, slotId  --${slotId}--flowType: ${this.dataFlowType[slotId]} --statusBarType: ${this.statusBarType}`);
    let cellularFlowTypeImage: Resource | null;
    switch (this.dataFlowType[slotId]) {
      case Constants.DATA_FLOW_TYPE_DOWN:
        cellularFlowTypeImage = $r('app.media.ic_statusbar_signal_down');
        break;
      case Constants.DATA_FLOW_TYPE_UP:
        cellularFlowTypeImage = $r('app.media.ic_statusbar_signal_up');
        break;
      case Constants.DATA_FLOW_TYPE_UP_DOWN:
        cellularFlowTypeImage = $r('app.media.ic_statusbar_signal_up_down');
        break;
      case Constants.DATA_FLOW_TYPE_NONE:
      case Constants.DATA_FLOW_TYPE_DORMANT:
        cellularFlowTypeImage = $r('app.media.ic_statusbar_signal_up_down_none');
        break;
      default:
        cellularFlowTypeImage = null;
        break;
    }
    return cellularFlowTypeImage;
  }

  /*
   * 移动信号图标宽度计算
   *
   * @return 宽度
   */
  private getIconWidth(): Length | undefined {
    // 天际通图标宽度
    if (this.slotId === 2) {
      return ResUtils.getNumberFromLength(this.style.cellularImageWidthLong);
    }
    let iconWidth: Length = this.style.cellularImageWidth;
    if (this.isCellularTypeDisplay) {
      if (this.dataFlow) {
        iconWidth = this.style.cellularImageWidthLong;
      }
    } else {
      iconWidth = this.style.cellularImageNoSimWidth;
    }
    return ResUtils.getNumberFromLength(iconWidth);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      if (this.isCellularTypeDisplay && this.showXg) {
        Image(this.cellularTypeDisplay)
          .draggable(false)
          .id(COMPONENT_ID_CELLULAR)
          .objectFit(ImageFit.Contain)
          .width(this.getIconWidth())
          .height('app.float.icon_regular_size')
          .fillColor(this.contentColor)
      }

      if (this.isFlowTypeDisplay && this.dataFlow) {
        Image(this.cellFlowTypeDisplay)
          .draggable(false)
          .id(COMPONENT_ID_FLOW)
          .objectFit(ImageFit.Contain)
          .width(this.style.cellularImageWidth)
          .height('app.float.icon_regular_size')
          .fillColor(this.contentColor)
      }

      Image(this.cellularImageDisplay)
        .draggable(false)
        .objectFit(ImageFit.Contain)
        .id(COMPONENT_ID_CELLULAR_IMAGE)
        .width(this.getIconWidth())
        .height('app.float.icon_regular_size')
        .fillColor(this.contentColor)
    }.flexShrink(1)
    .accessibilityGroup(this.isAccessibilityMode)
    .accessibilityLevel('yes')
  }
}

@Component
struct EmptySignalIcon {
  @State style: SignalStyle = new SignalStyle();
  @Consume contentColor: string;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  private getAccessibilityText(): string {
    if (!this.isAccessibilityMode) {
      return '';
    }
    const res: resourceManager.ResourceManager = getContext(this).resourceManager;
    return res.getStringByNameSync('accessibility_status_bar_empty_signal');
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r('app.media.ic_statusbar_signal_type_x'))
        .draggable(false)
        .id(COMPONENT_ID_CELLULAR)
        .objectFit(ImageFit.Contain)
        .width(this.style.cellularImageWidth)
        .height('app.float.icon_regular_size')
        .fillColor(this.contentColor)
      Image($r('app.media.ic_statusbar_signal_0_short'))
        .draggable(false)
        .id(COMPONENT_ID_CELLULAR_IMAGE)
        .objectFit(ImageFit.Contain)
        .width(this.style.cellularImageWidth)
        .height('app.float.icon_regular_size')
        .fillColor(this.contentColor)
    }.flexShrink(1)
    .accessibilityGroup(this.isAccessibilityMode)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }
}

@Component
struct AirPlaneIcon {
  @State style: SignalStyle = new SignalStyle();
  /**
   * 内容颜色
   */
  @Consume contentColor: string;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;

  build() {
    Row() {
      Image($r('app.media.ic_status_bar_airplane_mode'))
        .matchTextDirection(true)
        .draggable(false)
        .id(TAG + '_Image_airplaneIcon')
        .objectFit(ImageFit.Contain)
        .width(this.style.cellularImageAirWidth)
        .height('app.float.icon_regular_size')
        .fillColor(this.contentColor)
    }
    .id(TAG + '_AirPlaneIcon')
    .accessibilityGroup(this.isAccessibilityMode)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }

  private getAccessibilityText(): string {
    if (!this.isAccessibilityMode) {
      return '';
    }
    const res: resourceManager.ResourceManager = getContext(this).resourceManager;
    return res.getStringByNameSync('accessibility_status_bar_airplane_mode');
  }
}

@Component
struct SatelliteIcon {
  @State style: SignalStyle = new SignalStyle();
  @Consume contentColor: string;

  build() {
    Row() {
      Image($r('app.media.ic_status_bar_satellite_mode'))
        .matchTextDirection(true)
        .draggable(false)
        .id(TAG + '_Image_satelliteIcon')
        .objectFit(ImageFit.Contain)
        .width(this.style.cellularImageAirWidth)
        .height(this.style.cellularImageHeight)
        .fillColor(this.contentColor)
    }
    .id(TAG + '_SatelliteIcon')
  }
}