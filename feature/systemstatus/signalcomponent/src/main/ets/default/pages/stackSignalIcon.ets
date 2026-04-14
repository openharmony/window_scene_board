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

import Constants from '../common/constants';
import mSignalModel, { SimNetworkStandardType } from '../signalModel';
import { LogDomain, Logger } from '@ohos/basicutils';
import { PluginSlot } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import { StyleConfigurationCommon } from '@ohos/systemuicommon';
import { CommonStyle } from '@ohos/systemuicommon';
import StyleConfiguration, { SignalComponentStyle } from '../common/StyleConfiguration';
import data from '@ohos.telephony.data';
import type { BusinessError } from '@ohos.base';

const TAG = 'SignalComponent-StackSignalIcon';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const COMPONENT_ID_CELLULAR = TAG + '_Image_cellular';
const COMPONENT_ID_FLOW = TAG + '_Image_flow';
const COMPONENT_ID_CELLULAR_IMAGE = TAG + '_Image_cellularImage';

@Component
export default struct StackSingleSignalIcon {
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
  @StorageLink('isCellularDataEnabled') @Watch('handleRefreshFlowType') isCellularDataEnabled: boolean = true;
  @StorageLink('simCardIsActive') @Watch('refreshCelluarDisplay') simCardIsActive: boolean[] = [false, false, false];
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State style: SignalComponentStyle = StyleConfiguration.getSignalComponentStyle();
  @State cellularTypeDisplay: Resource = $r('app.media.ic_statusbar_signal_type_x');
  @State cellularImageDisplay: Resource = $r('app.media.ic_statusbar_signal_nosim'); // 卡信号栏格数图标
  @State cellFlowTypeDisplay: Resource = $r('app.media.ic_statusbar_signal_stack_0_up_down'); // 数据上下行图片左下角
  @State isFlowTypeDisplay: boolean = false;
  @State isCellularTypeDisplay: boolean = false;
  @State dataFlow: boolean = false;
  @StorageLink('eflForbidden') eflForbidden: string = 'false';
  @State showXg: boolean = true;
  @Prop slotId: number = 0;
  @Prop isRTL: boolean = false;
  @Consume statusBarType: number;
  /**
   * 内容颜色
   */
  @Consume contentColor: string;
  @StorageLink('dataFlowSlotId') @Watch('handleRefreshFlowType') defaultCellularDataSlotid: number =
    Constants.DATA_FLOW_SLOTID_DEFAULT;

  aboutToAppear() {
    this.getDefaultCellularDataSlotId();
    log.showInfo(TAG, `aboutToAppear`);
    this.refreshNetworkState();
  }

  getDefaultCellularDataSlotId(): void {
    try {
      data.getDefaultCellularDataSlotId((err: BusinessError, contextData: number) => {
        if (err) {
          log.error(`getDefaultCellularDataSlotId fail,callback: err->${err?.code}, contextData->${contextData}`);
        } else {
          this.defaultCellularDataSlotid = contextData;
        }
      });
    } catch (error) {
      log.error(`getDefaultCellularDataSlotId fail err->${error?.code}`);
    }
  }

  refreshNetworkState() {
    log.showInfo(TAG, 'refreshNetworkState operatorName');
    // 网络状态刷新，需要同步刷新信号显示
    this.refreshCelluarDisplay();
    this.handleRefreshFlowType();
  }

  refreshCelluarDisplay() {
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
    log.showInfo(TAG, `cellFlowTypeDisplay = ${this.cellFlowTypeDisplay.params}`);
    this.isFlowTypeDisplay = true;
  }

  private getRoamingSignal(slotId: number, signalLevel: number) {
    if (this.dataFlow) {
      return this.isRoaming[slotId] ? $r(`app.media.ic_statusbar_signal_roaming_stack_${slotId}_${signalLevel}`) :
      $r(`app.media.ic_statusbar_signal_stack_${slotId}_${signalLevel}`);
    }
    return this.isRoaming[slotId] ? $r(`app.media.ic_statusbar_signal_roaming_stack_${slotId}_${signalLevel}`) :
    $r(`app.media.ic_statusbar_signal_stack_${slotId}_${signalLevel}`);
  }

  private updateCellularType(slotId: number): Resource {
    let typeImage: Resource;
    const netWorkType = mSignalModel.mGetCellularType(slotId);
    log.showInfo(TAG, `updateCellularType ${netWorkType}`);
    switch (netWorkType) {
      case SimNetworkStandardType.SECOND_G_TYPE:
        typeImage = $r(`app.media.ic_statusbar_signal_type_2g_stack_${slotId}`);
        break;
      case SimNetworkStandardType.THIRD_G_TYPE:
        typeImage = $r(`app.media.ic_statusbar_signal_type_3g_stack_${slotId}`);
        break;
      case SimNetworkStandardType.FOURTH_G_TYPE:
        typeImage = $r(`app.media.ic_statusbar_signal_type_4g_stack_${slotId}`);
        break;
      case SimNetworkStandardType.FOURTH_PLUS_G_type:
        typeImage = $r(`app.media.ic_statusbar_signal_type_4gplus_stack_${slotId}`);
        break;
      case SimNetworkStandardType.FIFTH_G_TYPE:
        if (this.eflForbidden === 'true') {
          this.showXg = false;
        }
        typeImage = $r(`app.media.ic_statusbar_signal_type_5g_stack_${slotId}`);
        break;
      case SimNetworkStandardType.H_TYPE:
        typeImage = $r(`app.media.ic_statusbar_signal_type_h_stack_${slotId}`);
        break;
      case SimNetworkStandardType.H_PLUS_TYPE:
        typeImage = $r(`app.media.ic_statusbar_signal_type_hplus_stack_${slotId}`);
        break;
      case SimNetworkStandardType.X_TYPE:
      default:
        typeImage = $r(`app.media.ic_statusbar_signal_type_x_stack_${slotId}`);
    }
    return typeImage;
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
        cellularImage = this.isRoaming[slotId] ? $r(`app.media.ic_statusbar_signal_roaming_stack_${slotId}_0`) :
        $r(`app.media.ic_statusbar_signal_stack_${slotId}_0`);
      } else {
        cellularImage = this.isRoaming[slotId] ? $r(`app.media.ic_statusbar_signal_roaming_stack_${slotId}_0`) :
        $r(`app.media.ic_statusbar_signal_stack_${slotId}_0`);
      }
    }
    log.showInfo(TAG, `updateCellularImage = ${cellularImage.params} ${this.isCellularTypeDisplay}`);
    return cellularImage;
  }

  private updateCellularFlowType(slotId: number): Resource | null {
    log.showInfo(TAG, `updateCellularFlowType, slotId  --${slotId}--flowType: ${this.dataFlowType[slotId]} --statusBarType: ${this.statusBarType}`);
    let cellularFlowTypeImage: Resource | null;
    // 堆叠不考虑天际通
    if (slotId > 1) {
      return null;
    }
    switch (this.dataFlowType[slotId]) {
      case Constants.DATA_FLOW_TYPE_DOWN:
        cellularFlowTypeImage = $r(`app.media.ic_statusbar_signal_stack_${slotId}_down`);
        break;
      case Constants.DATA_FLOW_TYPE_UP:
        cellularFlowTypeImage = $r(`app.media.ic_statusbar_signal_stack_${slotId}_up`);
        break;
      case Constants.DATA_FLOW_TYPE_UP_DOWN:
        cellularFlowTypeImage = $r(`app.media.ic_statusbar_signal_stack_${slotId}_up_down`);
        break;
      case Constants.DATA_FLOW_TYPE_NONE:
      case Constants.DATA_FLOW_TYPE_DORMANT:
        cellularFlowTypeImage = $r(`app.media.ic_statusbar_signal_stack_${slotId}_up_down_none`);
        break;
      default:
        cellularFlowTypeImage = null;
        break;
    }
    return cellularFlowTypeImage;
  }

  build() {
    Stack({ alignContent: this.isRTL ? Alignment.Start : Alignment.End }) {
      if (this.isCellularTypeDisplay && this.showXg) {
        Image(this.cellularTypeDisplay)
          .draggable(false)
          .id(COMPONENT_ID_CELLULAR)
          .width(mSignalModel.stackSignalWidthNetworkType2Width.get(mSignalModel.mGetCellularType(this.slotId)))
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
          .width(this.style.stackSignalImageWidth)
          .height(this.style.cellularImageHeight)
          .fillColor(this.contentColor)
          .onError((err) => {
            log.showWarn(TAG, `flowTypeDisplay flow error:${err?.message}`);
          })
      }
      Image(this.cellularImageDisplay)
        .draggable(false)
        .id(COMPONENT_ID_CELLULAR_IMAGE)
        .width(this.style.stackSignalImageWidth)
        .height(this.style.cellularImageHeight)
        .fillColor(this.contentColor)
        .onError((err) => {
          log.showWarn(TAG, `signalIcon flow error:${err?.message}`);
        })
    }.flexShrink(1)
  }
}