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

import Constants, { CardSituation } from '../common/constants';
import mSignalModel, { SimNetworkStandardType } from '../signalModel';
import { LogDomain, Logger } from '@ohos/basicutils';
import { EvtBus, PluginSlot } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { RTLUtil } from '@ohos/componenthelper';
import { StyleConfigurationCommon, scbStatusBarStatusManager,
  StatusBarSignalIconCallBack, StackSignalInfo } from '@ohos/systemuicommon';
import { CommonStyle } from '@ohos/systemuicommon';
import StyleConfiguration, { SignalComponentStyle } from '../common/StyleConfiguration';
import data from '@ohos.telephony.data';
import AirplaneController from '@ohos/airplanecomponent/src/main/ets/default/controller/AirplaneController';
import Sim from '@ohos.telephony.sim';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import StackSingleSignalIcon from './stackSignalIcon';
import { curves, LengthMetrics } from '@kit.ArkUI';
import type { BusinessError } from '@ohos.base';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';
import { GlobalContext } from '@ohos/frameworkwrapper';
// instrument ignore file
const TAG = 'SignalComponent-SignalIcon';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

const COMPONENT_ID_CELLULAR = TAG + '_Image_cellular';
const COMPONENT_ID_FLOW = TAG + '_Image_flow';
const COMPONENT_ID_CELLULAR_IMAGE = TAG + '_Image_cellularImage';

// 信号内容变化时(仅处理单双卡切换、无卡切换、有无移动数据传输、上下行dataFlow)广播事件，专门用于状态栏避孔。待跨孔实现后，该Event可删除
export class SignalIconChangeEvent {
  public static eventTypeName: string = 'SignalIconChangeEvent';
}

interface SignalIconWidthInfo {
  actualWidth: number;
  reservedFlowIconWidth: number;
}

@Component
export default struct SignalIcon {
  @StorageLink('cellularLevel') cellularLevel: number[] =
    [Constants.CELLULAR_NO_SIM_CARD, Constants.CELLULAR_NO_SIM_CARD, Constants.CELLULAR_NO_SIM_CARD];
  @StorageLink('simCardIsActive') simCardIsActive: boolean[] = [false, false, false];
  @StorageLink('signalObserved') signalObserved: boolean = false;
  @StorageLink('satelliteModeSwitch') satelliteModeSwitch: boolean = false;
  @StorageLink('distributedModemState') distributedModemState: boolean = false;
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State firstSlotId: number = 0;
  @StorageProp('AirplaneModel_AirplaneStatus') mAirplaneData: ToggleViewData = AirplaneController.getViewData();
  @State simCount: number = 0;
  /**
   * 内容颜色
   */
  @Consume contentColor: string;

  aboutToAppear() {
    this.simCount = Sim.getMaxSimCount();
    log.showInfo(TAG, `aboutToAppear this.simCount is ${this.simCount}`);
    if (!this.signalObserved) {
      mSignalModel.initSignalModel();
      this.signalObserved = true;
    }
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisappear');
  }

  build() {
    Row() {
      if (this.mAirplaneData.isOn) {
        AirPlaneIcon()
      } else if (this.distributedModemState) {
        DistributedModemIcon()
      } else if (this.satelliteModeSwitch) {
        SatelliteIcon()
      } else if (this.simCount > 0) {
        SimCardIcon()
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
  @StorageLink('cellularLevel') @Watch('refreshCelluarDisplay') cellularLevel: number[] =
    [Constants.CELLULAR_NO_SIM_CARD, Constants.CELLULAR_NO_SIM_CARD, Constants.CELLULAR_SIGNAL_NO];
  @StorageLink('regState') @Watch('refreshCelluarDisplay') regState: number[] =
    [Constants.REG_STATE_NO_SERVICE, Constants.REG_STATE_NO_SERVICE];
  @StorageLink('isRoaming') @Watch('refreshCelluarDisplay') isRoaming: boolean[] = [false, false, false];
  @StorageLink('cfgTech') @Watch('refreshCelluarDisplay') cfgTech: number[] =
    [Constants.RADIO_TECHNOLOGY_UNKNOWN, Constants.RADIO_TECHNOLOGY_UNKNOWN, Constants.RADIO_TECHNOLOGY_UNKNOWN];
  @StorageLink('plmnNumeric') plmnNumeric: string[] = [Constants.NET_NULL, Constants.NET_NULL, Constants.NET_NULL];
  @StorageLink('dataFlowType') @Watch('handleRefreshFlowType') dataFlowType: number[] =
    [Constants.DATA_FLOW_TYPE_NONE, Constants.DATA_FLOW_TYPE_NONE, Constants.DATA_FLOW_TYPE_NONE];
  @StorageLink('dataConnectState') @Watch('handleRefreshFlowType') dataConnectState: number[] =
    [Constants.DATA_STATE_UNKNOWN, Constants.DATA_STATE_UNKNOWN, Constants.DATA_STATE_UNKNOWN];
  @StorageLink('dataFlowSlotId') @Watch('handleRefreshFlowType') defaultCellularDataSlotid: number =
    Constants.DATA_FLOW_SLOTID_DEFAULT;
  @StorageLink('isCellularDataEnabled') @Watch('handleRefreshFlowType') isCellularDataEnabled: boolean = true;
  @StorageLink('simCardIsActive') @Watch('refreshCelluarDisplay') simCardIsActive: boolean[] = [false, false, false];
  @StorageLink('eflForbidden') eflForbidden: string = 'false';
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State style: SignalComponentStyle = StyleConfiguration.getSignalComponentStyle();
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
  private skyToneStatus: number = -1;

  aboutToAppear() {
    this.getDefaultCellularDataSlotId();
    log.showInfo(TAG, `aboutToAppear, defaultCellularDataSlotid: ${this.defaultCellularDataSlotid}`);
    this.refreshNetworkState();
  }

  getDefaultCellularDataSlotId(): void {
    try {
      data.getDefaultCellularDataSlotId((err: BusinessError, contextData: number) => {
        if (err) {
          log.error(TAG, `getDefaultCellularDataSlotId fail,callback: err->${err?.code}, contextData->${contextData}`);
        } else {
          this.defaultCellularDataSlotid = contextData;
        }
      });
    } catch (error) {
      log.error(TAG, `getDefaultCellularDataSlotId fail err->${error?.code}`);
    }
  }

  refreshNetworkState() {
    log.showInfo(TAG, 'refreshNetworkState operatorName');
    // 网络状态刷新，需要同步刷新信号显示
    this.refreshCelluarDisplay();
    this.handleRefreshFlowType();
  }

  refreshCelluarDisplay() {
    this.skyToneStatus = mSignalModel.getSkyToneStatus();
    this.showXg = true;
    this.dataFlow = mSignalModel.isDataFlow(this.slotId);
    this.cellularTypeDisplay = this.updateCellularType(this.slotId);
    this.cellularImageDisplay = this.updateCellularImage(this.slotId);
  }

  handleRefreshFlowType() {
    // 更新完数据卡后，需要同步刷新信号显示图标
    this.refreshCelluarDisplay();
    let flowtype = this.updateCellularFlowType(this.slotId);
    if (flowtype === null) {
      log.showInfo(TAG, 'handleRefreshFlowType, flowtype == null');
      this.isFlowTypeDisplay = false;
      return;
    }
    this.cellFlowTypeDisplay = flowtype;
    this.isFlowTypeDisplay = true;
  }

  /**
   * Get the string of cellular type
   *
   * @param {number} type - number of cellular type
   * @return {string} typeString type of cellular type
   */
  private updateCellularType(slotId: number) {
    // 无服务时，蜂窝网图标显示为×
    if (this.regState[slotId] !== Constants.REG_STATE_IN_SERVICE) {
      log.showWarn(TAG, `updateCellularType regState no service with slotId  --${slotId}`);
      return slotId === 2 ? $r('app.media.ic_statusbar_skytone_signal_type_x') : $r('app.media.ic_statusbar_signal_type_x');
    }

    let signalType = this.cfgTech[slotId];
    log.showWarn(TAG, `updateCellularType, slotId  --${slotId}-- signalType: ${signalType} --statusBarType: ${this.statusBarType} --dataFlow: ${this.dataFlow} eflForbidden: ${this.eflForbidden}`);
    let typeImage: Resource;
    switch (signalType) {
      case Constants.RADIO_TECHNOLOGY_GSM:
      case Constants.RADIO_TECHNOLOGY_1XRTT:
        typeImage = slotId === 2 ? $r('app.media.ic_statusbar_signal_type_2g_lang') : this.dataFlow ? $r('app.media.ic_statusbar_signal_type_2g_lang') :
        $r('app.media.ic_statusbar_signal_type_2g_short');
        break;
      case Constants.RADIO_TECHNOLOGY_WCDMA:
      case Constants.RADIO_TECHNOLOGY_HSPA:
      case Constants.RADIO_TECHNOLOGY_HSPAP:
      case Constants.RADIO_TECHNOLOGY_TD_SCDMA:
      case Constants.RADIO_TECHNOLOGY_EVDO:
      case Constants.RADIO_TECHNOLOGY_EHRPD:
        typeImage = slotId === 2 ? $r('app.media.ic_statusbar_signal_type_3g_lang') : this.dataFlow ? $r('app.media.ic_statusbar_signal_type_3g_lang') :
        $r('app.media.ic_statusbar_signal_type_3g_short');
        break;
      case Constants.RADIO_TECHNOLOGY_LTE:
      case Constants.RADIO_TECHNOLOGY_LTE_CA:
      case Constants.RADIO_TECHNOLOGY_IWLAN:
        typeImage = slotId === 2 ? $r('app.media.ic_statusbar_signal_type_4g_lang') : this.dataFlow ? $r('app.media.ic_statusbar_signal_type_4g_lang') :
        $r('app.media.ic_statusbar_signal_type_4g_short');
        break;
      case Constants.RADIO_TECHNOLOGY_NR:
        if (this.eflForbidden === 'true') {
          this.showXg = false;
        }
        typeImage = slotId === 2 ? $r('app.media.ic_statusbar_signal_type_5g_lang') : this.dataFlow ? $r('app.media.ic_statusbar_signal_type_5g_lang') :
        $r('app.media.ic_statusbar_signal_type_5g_short');
        break;
      case Constants.RADIO_TECHNOLOGY_UNKNOWN:
      default:
        typeImage = slotId === 2 ? $r('app.media.ic_statusbar_skytone_signal_type_x') : $r('app.media.ic_statusbar_signal_type_x');
        break;
    }
    let custImage = this.updateCustCellularType(slotId);
    typeImage = custImage === null ? typeImage : custImage;
    return typeImage;
  }

  /**
   * 信号类型国内三大运营商定制显示
   *
   * @param {number} slotId - 卡槽槽位
   * @return {string} cellularImage image of cellular signal
   */
  private updateCustCellularType(slotId: number) {
    log.showInfo(TAG, `updateCustCellularType, slotId  --${slotId}--cfgTech: ${this.cfgTech[slotId]} --statusBarType: ${this.statusBarType} --dataFlow: ${this.dataFlow}`);
    if (this.cfgTech[slotId] == Constants.RADIO_TECHNOLOGY_LTE_CA) {
      // 对所有运营商只要无线网络处于LTE_CA就显示4G+图标
      return slotId === 2 ? $r('app.media.ic_statusbar_signal_type_4gplus_lang') : this.dataFlow ? $r('app.media.ic_statusbar_signal_type_4gplus_lang') :
      $r('app.media.ic_statusbar_signal_type_4gplus_short');
    }

    if (this.isUnicom(this.plmnNumeric[slotId])) {
      switch (this.cfgTech[slotId]) {
        case Constants.RADIO_TECHNOLOGY_HSPA:
          return slotId === 2 ? $r('app.media.ic_statusbar_signal_type_h_lang') : this.dataFlow ? $r('app.media.ic_statusbar_signal_type_h_lang') :
          $r('app.media.ic_statusbar_signal_type_h_short');
        case Constants.RADIO_TECHNOLOGY_HSPAP:
          return slotId === 2 ? $r('app.media.ic_statusbar_signal_type_hplus_lang') : this.dataFlow ? $r('app.media.ic_statusbar_signal_type_hplus_lang') :
          $r('app.media.ic_statusbar_signal_type_hplus_short');
        default:
          return null;
      }
    }

    if (this.cfgTech[slotId] == Constants.RADIO_TECHNOLOGY_NR) {
      if (this.eflForbidden === 'true') {
        this.showXg = false;
      }
      return slotId === 2 ? $r('app.media.ic_statusbar_signal_type_5g_lang') : this.dataFlow ? $r('app.media.ic_statusbar_signal_type_5g_lang') :
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
    return slotId === 2 ? $r(`app.media.ic_statusbar_skystone_signal_${signalLevel}_${this.getSkyToneSignalType()}`) :
      this.isRoaming[slotId] ? $r(`app.media.ic_statusbar_signal_roaming_${signalLevel}_short`) :
      $r(`app.media.ic_statusbar_signal_${signalLevel}_short`);
  }

  private getSkyToneSignalType(): string {
    return this.showXg ? 'lang' : 'short';
  }

  /**
   * Get the cellular signal image
   *
   * @param {number} level - signal level from signalModel
   * @return {string} cellularImage image of cellular signal
   */
  private updateCellularImage(slotId: number) {
    let level = this.cellularLevel[slotId]
    log.showWarn(TAG, `updateCellularImage, slotId  --${slotId}--level: ${level} --statusBarType: ${this.statusBarType} --dataFlow: ${this.dataFlow}`);
    let cellularImage: Resource;
    this.isCellularTypeDisplay = true;
    if (slotId === 2 && this.skyToneStatus !== 2) {
      this.isCellularTypeDisplay = false;
      return $r('app.media.ic_statusbar_skystone_signal_0_short');
    }
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
      log.showWarn(TAG, `updateCellularImage regState no service with slotId  --${slotId}`);
      if (this.dataFlow) {
        cellularImage = slotId === 2 ? $r('app.media.ic_statusbar_skystone_signal_0_lang') :
          this.isRoaming[slotId] ? $r('app.media.ic_statusbar_signal_roaming_0_lang') :
          $r('app.media.ic_statusbar_signal_0_lang');
      } else {
        cellularImage = slotId === 2 ? $r(`app.media.ic_statusbar_skystone_signal_0_${this.getSkyToneSignalType()}`) :
          this.isRoaming[slotId] ? $r('app.media.ic_statusbar_signal_roaming_0_short') :
          $r('app.media.ic_statusbar_signal_0_short');
      }
    }

    log.showDebug(TAG, 'updateCellularImage = ' + cellularImage);
    return cellularImage;
  }

  private updateCellularFlowType(slotId: number): Resource | null {
    log.showInfo(TAG, `updateCellularFlowType, slotId  --${slotId}--flowType: ${this.dataFlowType[slotId]} --statusBarType: ${this.statusBarType}`);
    let cellularFlowTypeImage: Resource | null;
    // 天际通非子卡在位
    if (slotId === 2 && this.skyToneStatus !== 2) {
      return null;
    }
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

  // 仅回调会影响宽度的场景
  onSignalChange(): void {
    EvtBus.post(SignalIconChangeEvent, this.signalIconChangeEvent);
  }

  /**
   * 移动信号图标宽度计算
   *
   * @return 宽度
   */
  private getIconWidth(): Length | undefined {
    // 天际通图标宽度
    if (this.slotId === 2) {
      // 不显示网络制式时候的长度
      if (this.skyToneStatus !== 2 || (!this.showXg && !this.dataFlow)) {
        return ResUtils.getNumberFromLength(this.style.onlySignalImageWidth);
      }
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
          .width(this.getIconWidth())
          .height(this.style.cellularImageHeight)
          .fillColor(this.contentColor)
          .onError((err) => {
            log.showWarn(TAG, `cellularTypeDisplay flow error:${err?.message}`);
          })
      }

      if (this.isFlowTypeDisplay && this.dataFlow) {
        Image(this.cellFlowTypeDisplay)
          .draggable(false)
          .id(COMPONENT_ID_FLOW)
          .width(this.style.cellularImageWidth)
          .height(this.style.cellularImageHeight)
          .fillColor(this.contentColor)
          .margin({ start: LengthMetrics.vp(2) })
          .onError((err) => {
            log.showWarn(TAG, `flowTypeDisplay flow error:${err?.message}`);
          })
      }

      Image(this.cellularImageDisplay)
        .draggable(false)
        .id(COMPONENT_ID_CELLULAR_IMAGE)
        .width(this.getIconWidth())
        .height(this.style.cellularImageHeight)
        .fillColor(this.contentColor)
        .onError((err) => {
          log.showWarn(TAG, `signalIcon flow error:${err?.message}`);
        })
    }.flexShrink(1)
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }

  private getAccessibilitySimText(slotId: number) {
    const res = GlobalContext.getContext()?.resourceManager;
    // 天际通sim卡名称
    if (slotId === 2) {
      return res.getStringByNameSync('accessibility_status_bar_skytone');
    }
    // 单张卡不播报SIM卡号
    if (!this.simCardIsActive[0] || !this.simCardIsActive[1]) {
      return '';
    }

    if (slotId === 0) {
      return res.getStringByNameSync('accessibility_status_bar_sim1', 1);
    } else {
      return res.getStringByNameSync('accessibility_status_bar_sim2', 2);
    }
  }

  private getAccessibilityCellularTypeText(slotId: number) {
    if (this.regState[slotId] !== Constants.REG_STATE_IN_SERVICE || (slotId === 2 && this.skyToneStatus !== 2)) {
      return '';
    }
    switch (this.cfgTech[slotId]) {
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

  private getAccessibilitySignalRoamingText(slotId: number) {
    const res = GlobalContext.getContext()?.resourceManager;
    if ((this.regState[slotId] !== Constants.REG_STATE_IN_SERVICE && this.isCellularTypeDisplay) ||
      (slotId === 2 && this.skyToneStatus !== 2)) {
      return res.getStringByNameSync('accessibility_status_bar_no_service');
    }

    switch (this.cellularLevel[slotId]) {
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

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    return this.getAccessibilitySimText(this.slotId) + ' ' +
    this.getAccessibilityCellularTypeText(this.slotId) +
    this.getAccessibilitySignalRoamingText(this.slotId);
  }

  /**
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
}

@Component
struct EmptySignalIcon {
  @State style: SignalComponentStyle = StyleConfiguration.getSignalComponentStyle();
  @Consume contentColor: string;

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    return res.getStringByNameSync('accessibility_status_bar_empty_signal');
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      Image($r('app.media.ic_statusbar_signal_type_x'))
        .draggable(false)
        .id(COMPONENT_ID_CELLULAR)
        .objectFit(ImageFit.Contain)
        .width(this.style.cellularImageWidth)
        .height(this.style.cellularImageHeight)
        .fillColor(this.contentColor)
        .onError((err) => {
          log.showWarn(TAG, `x flow error:${err?.message}`);
        })
      Image($r('app.media.ic_statusbar_signal_0_short'))
        .draggable(false)
        .id(COMPONENT_ID_CELLULAR_IMAGE)
        .objectFit(ImageFit.Contain)
        .width(this.style.cellularImageWidth)
        .height(this.style.cellularImageHeight)
        .fillColor(this.contentColor)
        .onError((err) => {
          log.showWarn(TAG, `0short flow error:${err?.message}`);
        })
    }.flexShrink(1)
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }
}

@Component
struct AirPlaneIcon {
  @State style: SignalComponentStyle = StyleConfiguration.getSignalComponentStyle();
  /**
   * 内容颜色
   */
  @Consume contentColor: string;

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    return res.getStringByNameSync('accessibility_status_bar_airplane_mode');
  }

  build() {
    Row() {
      Image($r('app.media.ic_status_bar_airplane_mode'))
        .matchTextDirection(true)
        .draggable(false)
        .id(TAG + '_Image_airplaneIcon')
        .objectFit(ImageFit.Contain)
        .width(this.style.cellularImageAirWidth)
        .height(this.style.cellularImageHeight)
        .fillColor(this.contentColor)
        .onError((err) => {
          log.showWarn(TAG, `airplaneMode flow error:${err?.message}`);
        })
    }
    .id(TAG + '_AirPlaneIcon')
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }
}

@Component
struct SatelliteIcon {
  @State style: SignalComponentStyle = StyleConfiguration.getSignalComponentStyle();
  @Consume contentColor: string;

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    return res.getStringByNameSync('accessibility_status_bar_satellite_mode');
  }

  build() {
    Row() {
      Image($r('app.media.ic_status_bar_satellite_mode'))
        .draggable(false)
        .id(TAG + '_Image_satelliteIcon')
        .objectFit(ImageFit.Contain)
        .width(this.style.cellularImageAirWidth)
        .height(this.style.cellularImageHeight)
        .fillColor(this.contentColor)
        .onError((err) => {
          log.showWarn(TAG, `satelliteMode flow error:${err?.message}`);
        })
    }
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
    .id(TAG + '_SatelliteIcon')
  }
}

@Component
struct SimCardIcon {
  @StorageLink('mCardSituation') @Watch('onCardSituationChange') cardSituation: CardSituation = CardSituation.NO_CARD;
  @State @Watch('postSignalEvent') hasTwoSimCard: boolean = false;
  @State style: SignalComponentStyle = StyleConfiguration.getSignalComponentStyle();
  @State isStacked: boolean = false;
  /**
   * 是否镜像语言
   */
  @State isRTL: boolean = false;
  @State isShowSimSkyTone: boolean = true;
  @State isShowSkyToneFix: boolean = false;
  @State lastSituation: CardSituation = CardSituation.NO_CARD;
  @StorageLink('eflForbidden') eflForbidden: string = 'false';
  private simGap = ResUtils.getNumberFromLength($r('app.float.signal_icon_margin_width'));
  private SPRINT_CURVE = curves.springMotion(0.4, 0.8);
  private cacheAvailableArea: number = 100;
  /**
   * 镜像语言变化回调
   */
  private onRTLChangeEvent = (isRTL: boolean): void => this.onRTLChange(isRTL);

  aboutToAppear(): void {
    this.onCardSituationChange();
    scbStatusBarStatusManager.setSignalCallback(this.statusbarCallback);
    RTLUtil.registerRtlChangeCallback(this.onRTLChangeEvent);
  }

  aboutToDisappear(): void {
    scbStatusBarStatusManager.clearSignalCallback();
    RTLUtil.unregisterRtlChangeCallback(this.onRTLChangeEvent);
  }
  private signalIconChangeEvent: SignalIconChangeEvent = new SignalIconChangeEvent();

  private statusbarCallback: StatusBarSignalIconCallBack = {
    stackSignal: (availableArea: number): StackSignalInfo => {
      return this.stackSignal(availableArea);
    }
  }

  onCardSituationChange() {
    this.setHasTwoSimCard();
    if (!this.hasTwoSimCard) {
      this.doSignalAni(false);
      mSignalModel.updatePluginWidthChangeEvent();
    } else if (this.hasTwoSimCard) {
      this.stackSignal(this.cacheAvailableArea);
    }
  }

  setHasTwoSimCard(): void {
    const firstTwoCards = this.cardSituation.slice(0, 2);
    if (firstTwoCards === '11') {
      this.hasTwoSimCard = true;
    } else {
      this.hasTwoSimCard = false;
    }
  }

  postSignalEvent(): void {
    EvtBus.post(SignalIconChangeEvent, this.signalIconChangeEvent);
  }

  private onRTLChange(isRTL: boolean): void {
    log.showInfo(TAG, `onRTLChange ${isRTL}`);
    this.isRTL = isRTL;
  }

  private getNormalIconWidth(): SignalIconWidthInfo {
    let groupWidth: number = 0;
    // 无卡场景
    if (this.cardSituation === CardSituation.NO_CARD) {
      groupWidth = ResUtils.getNumberFromLength(this.style.cellularImageWidth);
      return { actualWidth: groupWidth, reservedFlowIconWidth: groupWidth };
    }
    if (this.cardSituation === CardSituation.NO_CARD_EMPTY) {
      groupWidth = ResUtils.getNumberFromLength(this.style.cellularImageNoSimWidth);
      return { actualWidth: groupWidth, reservedFlowIconWidth: groupWidth };
    }
    let usedCardCount = 0;
    let reservedWidth = 0;
    for (let i = 0; i < 3; i++) {
      if (this.cardSituation[i] === '1') {
        const curIconWidth = mSignalModel.getNormalIconWidth(i);
        groupWidth += curIconWidth;
        if (i === 0 || i === 1) {
          reservedWidth += mSignalModel.getReservedFlowIconWidth(i);
        } else {
          reservedWidth += curIconWidth;
        }
        usedCardCount += 1;
      }
    }
    // 要加上卡的间隙
    if (usedCardCount > 0) {
      groupWidth += this.simGap * (usedCardCount - 1);
      reservedWidth += this.simGap * (usedCardCount - 1);
    }
    return { actualWidth: groupWidth, reservedFlowIconWidth: reservedWidth };
  }

  private actualUsedWidth(width: number): number {
    let simWidth = 0;
    // 没有双卡，即没有堆叠
    if (this.cardSituation === CardSituation.NO_CARD) {
      simWidth = ResUtils.getNumberFromLength(this.style.cellularImageWidth);
    } else if (!this.hasTwoSimCard) {
      this.isStacked = false;
      if (this.cardSituation[0] === '1' || this.cardSituation === CardSituation.NO_CARD_EMPTY) {
        simWidth = mSignalModel.getNormalIconWidth(0);
      } else if (this.cardSituation[1] === '1') {
        simWidth = mSignalModel.getNormalIconWidth(1);
      }
    } else {
      // 堆叠的宽度
      simWidth = this.predictSignalWidth();
    }
    const skyToneWidth: number = mSignalModel.getSkyToneWidth();
    let fakeUsedWidth = skyToneWidth + simWidth + this.simGap;
    log.showInfo(TAG, `fakeUsedWidth: ${fakeUsedWidth}-${simWidth}-${this.cardSituation}`);
    if (width < fakeUsedWidth) {
      fakeUsedWidth = simWidth;
      this.isShowSkyToneFix = false;
    } else {
      this.isShowSkyToneFix = true;
    }
    return fakeUsedWidth;
  }

  public stackSignal = (availableArea: number): StackSignalInfo => {
    this.cacheAvailableArea = availableArea;
    const normalGroupWidth: SignalIconWidthInfo = this.getNormalIconWidth();
    // 可用空间足够显示当前卡
    if (availableArea > normalGroupWidth.reservedFlowIconWidth) {
      this.isShowSkyToneFix = true;
      this.doSignalAni(false);
      return { actualWidth: normalGroupWidth.actualWidth, isHide: false };
    }
    const preWidth: number = this.predictSignalWidth();
    // 堆叠的塔都放不下，隐藏即可
    if (availableArea < preWidth) {
      return { actualWidth: 0, isHide: false, hideSignal: true };
    }
    const actualUsedWidth = this.actualUsedWidth(availableArea);
    this.doSignalAni(this.hasTwoSimCard);
    return { actualWidth: actualUsedWidth, isHide: this.isStacked || !this.isShowSimSkyTone };
  }

  // 预测堆叠后的信号塔宽度，用以做胶囊最大宽度避让
  private predictSignalWidth = (): number => {
    if (!this.hasTwoSimCard) {
      let curUsedSim = this.cardSituation[1] === '1' ? 1 : 0;
      return mSignalModel.getNormalIconWidth(curUsedSim);
    }
    const sim1NetType = mSignalModel.mGetCellularType(0);
    const sim2NetType = mSignalModel.mGetCellularType(1);
    let sim1Width = ResUtils.getNumberFromLength(mSignalModel.stackSignalWidthNetworkType2Width.get(sim1NetType));
    let sim2Width = ResUtils.getNumberFromLength(mSignalModel.stackSignalWidthNetworkType2Width.get(sim2NetType));
    if (sim1NetType === SimNetworkStandardType.FIFTH_G_TYPE && this.eflForbidden === 'true') {
      sim1Width = ResUtils.getNumberFromLength(this.style.stackSignalImageWidth);
    }
    if (sim2NetType === SimNetworkStandardType.FIFTH_G_TYPE && this.eflForbidden === 'true') {
      sim2Width = ResUtils.getNumberFromLength(this.style.stackSignalImageWidth);
    }
    return Math.max(sim1Width, sim2Width);
  }

  @State normalScale: number = 1;
  @State normalOpacity: number = 1;
  @State stackOpacity: number = 0;

  private doSignalAni(isStack: boolean): void {
    if (isStack === this.isStacked) {
      this.stackOpacity = isStack ? 1 : 0;
      this.normalOpacity = isStack ? 0 : 1;
      this.normalScale = isStack ? 0 : 1;
      this.lastSituation = this.cardSituation;
      this.isShowSimSkyTone = this.isShowSkyToneFix;
      return;
    }
    animateTo({
      duration: 167,
      curve: Curve.Linear,
      onFinish: () => {
        this.lastSituation = this.cardSituation;
      }
    },
      () => {
        this.stackOpacity = isStack ? 1 : 0;
        this.normalOpacity = isStack ? 0 : 1;
      })
    animateTo({
      curve: this.SPRINT_CURVE,
    },
      () => {
        this.isStacked = isStack;
        this.normalScale = isStack ? 0 : 1;
        this.isShowSimSkyTone = this.isShowSkyToneFix;
      })
  }

  build() {
    // 无卡
    if (this.cardSituation === CardSituation.NO_CARD) {
      EmptySignalIcon()
    } else {
      if (this.isShowSimSkyTone) {
        this.skyToneGroup()
      }
      this.stackGroup()
      this.normalGroup()
    }
  }

  @Builder
  skyToneGroup() {
    if (this.cardSituation[2] === '1') {
      SingleSignalIcon({ slotId: 2, signalIconChangeEvent: this.signalIconChangeEvent })
    }
    // 有天际通但不只有天际通
    if (this.cardSituation[2] === '1' && this.cardSituation !== CardSituation.SINGLE_CARD_SKY) {
      Row().width($r('app.float.signal_icon_margin_width')).height('100%')
    }
  }

  @Builder
  normalGroup() {
    Row() {
      if ((this.cardSituation[0] === '1' && this.lastSituation[0] === '1') ||
        this.cardSituation === CardSituation.NO_CARD_EMPTY) {
        SingleSignalIcon({ slotId: 0, signalIconChangeEvent: this.signalIconChangeEvent })
      }
      // 卡1和卡2均有
      if ((this.lastSituation === CardSituation.DUAL_CARD_0_1 &&
        this.cardSituation === CardSituation.DUAL_CARD_0_1) ||
        (this.lastSituation === CardSituation.TRIPLE_CARD && this.cardSituation === CardSituation.TRIPLE_CARD)) {
        Row().width($r('app.float.signal_icon_margin_width')).height('100%')
      }
      if (this.cardSituation[1] === '1' && this.cardSituation !== CardSituation.NO_CARD_EMPTY &&
        this.lastSituation[1] === '1') {
        SingleSignalIcon({ slotId: 1, signalIconChangeEvent: this.signalIconChangeEvent })
      }
    }.justifyContent(FlexAlign.End)
    .scale({ x: this.normalScale, y: this.normalScale, centerX: '70%', centerY: '50%' })
    .opacity(this.normalOpacity)
    .visibility(this.isStacked ? Visibility.None : Visibility.Visible)
  }

  @Builder
  stackGroup() {
    Stack({ alignContent: this.isRTL ? Alignment.Start : Alignment.End }) {
      if (this.cardSituation[0] === '1' || this.cardSituation === CardSituation.NO_CARD_EMPTY) {
        StackSingleSignalIcon({ slotId: 0, isRTL: this.isRTL })
      }
      if (this.cardSituation[1] === '1' && this.cardSituation !== CardSituation.NO_CARD_EMPTY) {
        StackSingleSignalIcon({ slotId: 1, isRTL: this.isRTL })
      }
    }.id('stack_signal_group')
    .opacity(this.stackOpacity)
    .visibility(this.isStacked ? Visibility.Visible : Visibility.None)
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(mSignalModel.getAccessibilityText(AccessibilityVm.instance.isEnabled))
  }
}

@Component
struct DistributedModemIcon {
  @State style: SignalComponentStyle = StyleConfiguration.getSignalComponentStyle();
  @State distributedModemDisplay: Resource = $r('app.media.ic_status_bar_distributed_modem');
  @StorageLink('dataFlowType') @Watch('handleRefreshFlowType') dataFlowType: number[] =
    [Constants.DATA_FLOW_TYPE_UP_DOWN, Constants.DATA_FLOW_TYPE_NONE, Constants.DATA_FLOW_TYPE_NONE];
  // 信号卡注册状态
  @StorageLink('regState') @Watch('handleRefreshFlowType') regState: number[] =
    [Constants.REG_STATE_NO_SERVICE, Constants.REG_STATE_NO_SERVICE];
  //是否开启移动数据
  @StorageLink('isCellularDataEnabled') @Watch('handleRefreshFlowType') isCellularDataEnabled: boolean = true;
  // 是否开启分布式移动数据
  @StorageLink('isDistributedCellularEnable') @Watch('handleRefreshFlowType') isDistributedCellularEnable: boolean = true;
  // 蜂窝数据链路连接状态
  @StorageLink('dataConnectState') @Watch('handleRefreshFlowType') dataConnectState: number[] =
    [Constants.DATA_STATE_UNKNOWN, Constants.DATA_STATE_UNKNOWN, Constants.DATA_STATE_UNKNOWN];
  @Consume contentColor: string;

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    return res.getStringByNameSync('accessibility_status_bar_distributed_mode');
  }

  build() {
    Row() {
      Image(this.distributedModemDisplay)
        .matchTextDirection(true)
        .draggable(false)
        .id(TAG + '_Image_distributedModemIcon')
        .objectFit(ImageFit.Contain)
        .height(this.style.cellularImageHeight)
        .width(this.style.distributedImageWidth)
        .fillColor(this.contentColor)
        .onError((err) => {
          log.showWarn(TAG, `distributedModemDisplay flow error:${err?.message}`);
        })
    }
    .id(TAG + '_DistributedIcon')
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }

  handleRefreshFlowType() {
    let slotId = 0; // 通信共享开关打开复用SIM卡0的数据上下行状态
    let dataflow = this.isDataFlow(slotId);
    let cellularFlowTypeImage: Resource | null;
    if (!dataflow) {
      cellularFlowTypeImage = $r('app.media.ic_status_bar_distributed_modem');
    } else {
      cellularFlowTypeImage = this.getCellularFlowTypeImageWhenHasDataFlow(slotId);
    }
    this.distributedModemDisplay = cellularFlowTypeImage;
  }

  /**
   * 有数据传输时获取需要展示的icon
   */
  getCellularFlowTypeImageWhenHasDataFlow(slotId: number) {
    let cellularFlowTypeImage: Resource | null;
    switch (this.dataFlowType[slotId]) {
      case Constants.DATA_FLOW_TYPE_DOWN:
        cellularFlowTypeImage = $r('app.media.ic_status_bar_distributed_down');
        break;
      case Constants.DATA_FLOW_TYPE_UP:
        cellularFlowTypeImage = $r('app.media.ic_status_bar_distributed_up');
        break;
      case Constants.DATA_FLOW_TYPE_UP_DOWN:
        cellularFlowTypeImage = $r('app.media.ic_status_bar_distributed_up_down');
        break;
      case Constants.DATA_FLOW_TYPE_NONE:
      case Constants.DATA_FLOW_TYPE_DORMANT:
        cellularFlowTypeImage = $r('app.media.ic_status_bar_distributed_up_down_0');
        break;
      default:
        cellularFlowTypeImage = $r('app.media.ic_status_bar_distributed_modem');
        break;
    }
    return cellularFlowTypeImage;
  }


  /**
   * 是否有数据传输,有数据传输：true ||无数据传输：false
   */
  isDataFlow(slotId: number): boolean {
    log.showInfo(TAG, `distributedModem isDataFlow, slotId: ${slotId} flowType: ${this.dataFlowType[slotId]} ` +
    `regState: ${this.regState[slotId]} dataConnectState: ${this.dataConnectState[slotId]} ` +
    `isCellularDataEnabled: ${this.isCellularDataEnabled} ` +
    `isDistributedCellularEnable: ${this.isDistributedCellularEnable}`);
    // 无服务时，不展示上下行图标
    if (this.regState[slotId] !== Constants.REG_STATE_IN_SERVICE) {
      return false;
    }
    // 移动数据关闭后，不展示上下行图标
    if (!this.isCellularDataEnabled && !this.isDistributedCellularEnable) {
      return false
    }
    // 蜂窝数据链路不处于连接状态，不展示上下行图标
    if (this.dataConnectState[slotId] !== Constants.DATA_STATE_CONNECTED) {
      return false;
    }
    return [Constants.DATA_FLOW_TYPE_DOWN,
      Constants.DATA_FLOW_TYPE_UP,
      Constants.DATA_FLOW_TYPE_UP_DOWN,
      Constants.DATA_FLOW_TYPE_DORMANT,
      Constants.DATA_FLOW_TYPE_NONE].includes(this.dataFlowType[slotId]);
  }
}
