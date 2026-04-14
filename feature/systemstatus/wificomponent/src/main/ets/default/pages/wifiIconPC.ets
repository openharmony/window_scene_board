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
import connection from '@ohos.net.connection';
import { ArkTSUtils } from '@kit.ArkTS';
import { WifiDetailState } from '../common/Constants';
import Constants from '../common/Constants';
import { AsyncCallback, BusinessError } from '@ohos.base';
import Observer from '@ohos.telephony.observer';
import Settings from '@ohos.settings';
import dataShare from '@ohos.data.dataShare';
import data from '@ohos.telephony.data';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import {
  WifiUtils,
  WIFI_INACTIVE_HEIGHT,
  WifiDataPC
} from '../utils/WifiUtils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus, GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import plugin from '@ohos.pluginComponent';
import { pluginDistributedController } from '../controller/PluginDistributedController';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { StatusBarTipsChangeEvent } from '@ohos/systemuicommon/src/main/ets/TsIndex';

const WIFI_PLUGIN_TEMPLATE_NAME: string = 'pages/wifi/PluginWifiIcon.js';
const PLUGIN_WIFI_ICON: string = 'plugin_image_plugin_wifi_icon';
const TAG: string = 'wifiIconPC';
const BLACK_TAG: string = ' : ';
const WHITE_TAG: string = 'White : ';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const SETTINGS_BUNDLE_NAME = 'com.ohos.settings';
// 用户设置数据Uri前缀
const URI_BASE: string = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true';
// 当前通信共享状态的数据项名称
const DISTRIBUTED_STATE: string = 'distributed_modem_state';
// 当前通信共享状态的默认值
const DISTRIBUTED_STATE_DEFAULT: string = '0_sink';

@Component
struct WifiIconPC {
  @Consume contentColor: string;
  @State isIconHover: boolean | undefined = false;
  @ObjectLink animProperty: AnimProperty;
  @State iconWidth: Length = 0;
  @State iconHeight: Length = 0;

  @State mWifiData: WifiDataPC = new WifiDataPC();
  @State isShowSharedNetwork: boolean = false;
  @State mSharedNetworkDataFlowType: number = data.DataFlowType.DATA_FLOW_TYPE_UP_DOWN;
  @State isSharedNetworkAvailable: boolean = false;
  @State isNetworkSharing: boolean = false;
  private dataShareHelper: dataShare.DataShareHelper | undefined = undefined;
  private distributedUri: string = '';
  private netCon: connection.NetConnection = connection.createNetConnection({
    netCapabilities: {
      bearerTypes: [connection.NetBearType.BEARER_WIFI]
    }
  });
  private ethernetCon: connection.NetConnection = connection.createNetConnection({
    netCapabilities: {
      bearerTypes: [connection.NetBearType.BEARER_ETHERNET]
    }
  });
  private tagStr: string = BLACK_TAG;
  @State isEthernetAvailable: boolean = false;
  private getIcon: Function = ()=>{};
  private getActiveWifiIcon: Function = ()=>{log.showInfo('wifiIconPC getActiveWifiIcon')};
  private lock_: ArkTSUtils.locks.AsyncLock = new ArkTSUtils.locks.AsyncLock();
  slot = 'status_bar_wifi_panel';

  isWhite(): boolean {
    log.showInfo(`wifiIconPC contentColor:${this.contentColor}`)
    return this.contentColor === '#000000' ? false : true;
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      if (this.isShowSharedNetwork) {
        Image(pluginDistributedController.getSharedNetworkImage(this.isWhite(),
        this.isNetworkSharing, this.mSharedNetworkDataFlowType))
          .interpolation(ImageInterpolation.Medium)
          .draggable(false)
          .id(PLUGIN_WIFI_ICON)
          .objectFit(ImageFit.Contain)
          .fillColor($r('app.color.statusbar_wifi_dark_color'))
          .width(this.iconWidth)
          .height(this.iconHeight)
          .scale({ x: this.animProperty?.scaleX, y: this.animProperty?.scaleY })
      } else {
        Image(this.getIcon(this.slot)?.(this.mWifiData, this.isWhite()))
          .interpolation(ImageInterpolation.Medium)
          .draggable(false)
          .id(PLUGIN_WIFI_ICON)
          .objectFit(ImageFit.Contain)
          .fillColor($r('app.color.statusbar_wifi_dark_color'))
          .width(this.iconWidth)
          .height(this.iconHeight)
          .scale({ x: this.animProperty?.scaleX, y: this.animProperty?.scaleY })

        if ((this.mWifiData.state === WifiDetailState.STATE_ACTIVE) && this.mWifiData.isConnected) {
          Image(this.getActiveWifiIcon(this.mWifiData, this.isWhite()))
            .interpolation(ImageInterpolation.Medium)
            .draggable(false)
            .id(PLUGIN_WIFI_ICON)
            .objectFit(ImageFit.Contain)
            .fillColor($r('app.color.statusbar_wifi_dark_color'))
            .width(this.iconWidth)
            .height(this.iconHeight)
            .scale({ x: this.animProperty?.scaleX, y: this.animProperty?.scaleY })
        }
      }
    }
    .id('WiFiIconPC')
  }


  aboutToAppear(): void {
    this.tagStr = this.isWhite() ? WHITE_TAG : this.tagStr;
    log.info(`${TAG + this.tagStr} aboutToAppear`);
    if (WifiUtils.isWifiActive()) {
      this.mWifiData.state = WifiDetailState.STATE_ACTIVE;
      if (wifiManager.isConnected()) {
        this.handleConnectionChange(true);
      } else {
        this.handleConnectionChange(false);
      }
    }
    WifiUtils.wifiStateChangeOn(TAG + this.tagStr, this.onWifiDetailStateChange);
    WifiUtils.wifiRssiChangeOn(TAG + this.tagStr, this.onWifiRssiChange);
    WifiUtils.wifiConnectionChangeOn(TAG + this.tagStr, this.onWifiConnectionChange);
    WifiUtils.wifiStreamChangeOn(TAG + this.tagStr, this.onWifiStreamChange);
    this.netCon.register(() => {
      log.info(`${TAG + this.tagStr} register NetConnection.`);
    });
    // 订阅网络能力变化事件。调用register后，才能接收到此事件通知
    this.netCon.on('netCapabilitiesChange', this.onNetCapabilitiesChange);
    // 订阅有线网络以太网事件。
    this.ethernetCon.register(() => {
      log.info(`${TAG + this.tagStr} register ethernetCon.`);
    });
    this.ethernetCon.on('netCapabilitiesChange', this.onEthernetCapabilitiesChange);
    this.ethernetCon.on('netLost', this.onEthernetNetLost);
    this.initDistributedListener();
    this.subscribeSharingNetworkDataState();
    this.subscribeSharingNetworkDataFlowChange();
  }

  aboutToDisappear(): void {
    log.info(`${TAG + this.tagStr} aboutToDisappear.`);
    WifiUtils.wifiStateChangeOff(TAG + this.tagStr, this.onWifiDetailStateChange);
    WifiUtils.wifiRssiChangeOff(TAG + this.tagStr, this.onWifiRssiChange);
    WifiUtils.wifiConnectionChangeOff(TAG + this.tagStr, this.onWifiConnectionChange);
    WifiUtils.wifiStreamChangeOff(TAG + this.tagStr, this.onWifiStreamChange);
    this.netCon.unregister(() => {
      log.info(`${TAG + this.tagStr} unregister NetConnection.`);
    });
    this.ethernetCon.unregister(() => {
      log.info(`${TAG + this.tagStr} unregister EthernetConnection.`);
    });
    try {
      Observer.off('cellularDataConnectionStateChange', this.onCellularDataConnectionStateChange);
      Observer.off('cellularDataFlowChange', this.onCellularDataFlowChange);
      log.info(`${TAG + this.tagStr} unregister distribute data share listener success.`);
    } catch (err) {
      log.error(`${TAG + this.tagStr} unregister distribute data share listener error: ${err?.message}`);
    }
    this.unRegDataShareHelper();
  }

  private distributedSetChange() : void {
    let stateValue = DISTRIBUTED_STATE_DEFAULT;
    try {
      stateValue = Settings.getValueSync(GlobalContext.getContext(), DISTRIBUTED_STATE, DISTRIBUTED_STATE_DEFAULT);
      log.info(`${TAG + this.tagStr} get ${DISTRIBUTED_STATE} value is ${stateValue}`);
    } catch (e) {
      stateValue = DISTRIBUTED_STATE_DEFAULT;
      log.error(`${TAG + this.tagStr} get settings switch value error. use default`);
    }
    if (stateValue == null || stateValue.length === 0) {
      log.error(`${TAG + this.tagStr} onDistributedSetChange stateValue is invalid or empty`);
    } else {
      this.isSharedNetworkAvailable = stateValue !== DISTRIBUTED_STATE_DEFAULT;
      log.info(`${TAG + this.tagStr} onDistributedSetChange, update isShowSharedNetwork state`);
      this.updateSharedNetworkShowState();
      pluginDistributedController.setSharedNetworkAvailableState(this.isSharedNetworkAvailable);
    }
  }

  onDistributedSetChange: AsyncCallback<void> = () => {
    this.distributedSetChange();
  };

  /**
   * 状态栏通信共享图标设置项监听初始化
   */
  private async initDistributedListener(): Promise<void> {
    log.info(`${TAG + this.tagStr} initDistributedListener.`);
    this.distributedUri = URI_BASE;

    await this.lock_.lockAsync(async () =>{
      this.dataShareHelper = await dataShare.createDataShareHelper(GlobalContext.getContext(), this.distributedUri);
      this.dataShareHelper?.on('dataChange', this.distributedUri, this.onDistributedSetChange);
    });

    this.distributedSetChange();
  }

  private async unRegDataShareHelper(): Promise<void> {
    await this.lock_.lockAsync(() => {
      this.dataShareHelper?.off('dataChange', this.distributedUri, this.onDistributedSetChange);
    });
  }

  private handleDataConnectState(dataConnectState: data.DataConnectState) : void {
    this.isNetworkSharing = (dataConnectState === data.DataConnectState.DATA_STATE_CONNECTED);
    pluginDistributedController.setNetworkSharingState(this.isNetworkSharing);
    this.updateSharedNetworkShowState();
  }

  onCellularDataConnectionStateChange = (value: Observer.DataConnectionStateInfo): void => {
    log.info(`${TAG + this.tagStr} sharedNetworkDataConnectionStateChange:${value?.state}, ${value?.network}`);
    this.handleDataConnectState(value?.state);
  };

  private subscribeSharingNetworkDataState(): void {
    try {
      data.getCellularDataState().then((dataConnectState: data.DataConnectState) => {
        log.showInfo(`getCellularDataState: ${dataConnectState}`);
        this.handleDataConnectState(dataConnectState);
      });
      Observer.on('cellularDataConnectionStateChange', this.onCellularDataConnectionStateChange);
    } catch (error) {
      log.error(`${TAG +
      this.tagStr} init observer cellularDataConnectionStateChange failed message: ${error.message}`);
    }
  }

  onCellularDataFlowChange = (dataFlowInfo: Observer.DataFlowType): void => {
    log.info(`${TAG + this.tagStr} SharedNetworkDataFlowChange:${dataFlowInfo}`);
    this.mSharedNetworkDataFlowType = dataFlowInfo;
  };

  private subscribeSharingNetworkDataFlowChange(): void {
    try {
      Observer.on('cellularDataFlowChange', this.onCellularDataFlowChange);
    } catch (error) {
      log.error(`${TAG + this.tagStr} init observer cellularDataFlowChange failed message: ${error.message}`);
    }
  }

  private updateSharedNetworkShowState(): void {
    this.isShowSharedNetwork = this.isSharedNetworkAvailable &&
      (!this.mWifiData.isConnected || !this.mWifiData.isNetworkAvailable);
    pluginDistributedController.setShowState(this.isShowSharedNetwork);
    log.info(`${TAG + this.tagStr} updateSharedNetworkShowState, isShowSharedNetwork =  ${this.isShowSharedNetwork}`);
  }

  private getVirtualModemSwitchState(): boolean {
    try {
      let state: string = systemParameterEnhance.getSync('const.booster.virtual_modem_switch', 'false');
      log.info(`${TAG + this.tagStr} virtual modem switch state is : ${state}`);
      return state === 'true';
    } catch (error) {
      log.error(`${TAG + this.tagStr} Failed to get virtual modem switch. Code: ${error?.code}, message: ${error?.message}`);
      return false;
    }
  }

  onNetCapabilitiesChange = (data: connection.NetCapabilityInfo): void => {
    let caps = data?.netCap?.networkCap;
    let types = data?.netCap?.bearerTypes;
    log.info(`${TAG + this.tagStr} netCapabilitiesChange, networkCap: ${JSON.stringify(caps)}`);
    if (WifiUtils.isBearerWifi(types)) {
      if (WifiUtils.isWifiNetworkValidated(caps)) {
        this.mWifiData.isNetworkAvailable = true;
      } else {
        this.mWifiData.isNetworkAvailable = false;
      }
      this.updateSharedNetworkShowState();
    }
  };

  onWifiConnectionChange = (state: number): void => {
    log.info(`${TAG + this.tagStr} onWifiConnectionChange state : ${state}`);
    this.handleConnectionChange(state == 1 ? true : false);
  };

  onEthernetCapabilitiesChange = (data: connection.NetCapabilityInfo): void => {
    let caps = data?.netCap?.networkCap;
    let types = data?.netCap?.bearerTypes;
    log.info(`${TAG + this.tagStr} onEthernetCapabilitiesChange, networkCap: ${JSON.stringify(caps)}`);
    if (WifiUtils.isBearerEthernet(types)) {
      // 判断当前以太网是否连通，以太网连通则状态栏WIFI图标优先显示以太网有线连接图标
      this.mWifiData.isEthernetAvailable = WifiUtils.isEthernetNetworkValidated(caps);
      this.refreshNetworkTips();
    }
  };

  onEthernetNetLost = (data: connection.NetHandle): void => {
    log.info(`${TAG + this.tagStr} onEthernetNetLost callback netid: ${data?.netId}`);
    // 断网后将网络标记为不可用，刷新图标
    this.mWifiData.isEthernetAvailable = false;
    this.refreshNetworkTips();
  };

  private refreshNetworkTips() {
    AppStorage.setOrCreate<boolean>('EthernetAvailableStatus', this.mWifiData.isEthernetAvailable);
    EvtBus.post(StatusBarTipsChangeEvent,
      StatusBarTipsChangeEvent.create(PluginSlot.SLOT_STATUS_WIFI_PANEL,
        this.mWifiData.isEthernetAvailable ? ResUtils.getInnerStringByName('ethernet_status_connected') : ''));
  }

  private handleConnectionChange(isConnected: boolean): void {
    try {
      this.mWifiData.isConnected = isConnected;
      log.info(`${TAG + this.tagStr} handleConnectionChange status: ${this.mWifiData.isConnected}`)
      log.info(`${TAG + this.tagStr} wifiConnectionChange, update isShowSharedNetwork state`);
      this.updateSharedNetworkShowState();
      if (this.mWifiData.isConnected) {
        this.mWifiData.isMetered = wifiManager.isMeteredHotspot();
        this.setWifiStatus();
      } else {
        this.mWifiData.isMetered = false;
        this.mWifiData.wifiName = Constants.DEFAULT_WIFI_NAME;
        this.mWifiData.signalLevel = Constants.WIFI_SIGNAL_NO;
        this.mWifiData.supportedWifiCategory = Constants.CATEGORY_DEFAULT;
        this.mWifiData.isNetworkAvailable = false;
      }
    } catch (error) {
      log.info(`${TAG + this.tagStr} handleConnectionChange error: ${error?.message}`);
    }
    log.info(`${TAG + this.tagStr} handleConnectionChange isMertered: ${this.mWifiData.isMetered}`);
  }

  private setWifiStatus() : void {
    wifiManager.getLinkedInfo().then(data => {
      this.mWifiData.wifiName = data?.ssid;
      this.mWifiData.signalLevel = wifiManager.getSignalLevel(data?.rssi, data?.band);
      this.mWifiData.supportedWifiCategory = data?.supportedWifiCategory;
      log.info(`${TAG + this.tagStr} setWifiStatus, wifiName: ${WifiUtils.getLogSsidString(this.mWifiData.wifiName)},
       signalLevel: ${this.mWifiData.signalLevel}, supportedWifiCategory: ${this.mWifiData.supportedWifiCategory}`);
    }).catch((error: BusinessError) => {
      log.error(`${TAG + this.tagStr} get linked info error`);
    });
  }

  onWifiDetailStateChange = (state: number): void => {
    log.info(`${TAG + this.tagStr} onWifiDetailStateChange state : ${state}`);
    // 控制状态栏WLAN开关状态变化
    if (state === WifiDetailState.STATE_ACTIVE) {
      this.mWifiData.state = state;
      return;
    }
    if (state === WifiDetailState.STATE_INACTIVE) {
      this.mWifiData.state = state;

      // 恢复模板高度默认值
      this.updatePluginWindowHeight(WIFI_PLUGIN_TEMPLATE_NAME, WIFI_INACTIVE_HEIGHT);
    }
  };

  onWifiRssiChange = (rssi: number): void => {
    log.info(`${TAG + this.tagStr} onWifiRssiChange rssi : ${rssi},
     isConnected: ${this.mWifiData.isConnected}, signalLevel: ${this.mWifiData.signalLevel}`);
    if (this.mWifiData.isConnected) {
      wifiManager.getLinkedInfo().then(data => {
        if (!this.mWifiData.isNetworkAvailable) {
          log.info(`${TAG + this.tagStr} network available state : ${this.mWifiData.isNetworkAvailable}`);
        }
        log.info(`${TAG + this.tagStr} onWifiRssiChange connState : ${data?.connState}`);
        if (data?.connState === wifiManager.ConnState.CONNECTED) {
          let level: number = wifiManager.getSignalLevel(data?.rssi, data?.band);
          log.info(`${TAG + this.tagStr} onWifiRssiChange ssid : ${WifiUtils.getLogSsidString(data?.ssid)}, level = ${level}`);
          // 控制状态栏WLAN信号强弱状态变化
          this.mWifiData.signalLevel = level;
        } else {
          log.info(`${TAG + this.tagStr} getLinkedInfo state is not CONNECTED.`);
          this.mWifiData.signalLevel = Constants.WIFI_SIGNAL_NO;
        }
      }).catch((error: BusinessError) => {
        log.error(`${TAG + this.tagStr} get linked info error`);
      });
    } else {
      this.mWifiData.signalLevel = Constants.WIFI_SIGNAL_NO;
    }
  };

  onWifiStreamChange = (data: number): void => {
    log.info(`${TAG + this.tagStr} onStreamChange data : ${data}`)
    // wifi 上下行 0:data none  1: stream down, 2: stream up, 3: stream bidirectional
    this.mWifiData.dataFlowType = data;
  }

  updatePluginWindowHeight(pluginTemplateName: string, height: number): void {
    log.info(`${TAG} updatePluginWindowHeight name is ${pluginTemplateName}, height: ${height}`);
    plugin.push({
      owner: {
        bundleName: SETTINGS_BUNDLE_NAME
      },
      want: {
        bundleName: SETTINGS_BUNDLE_NAME
      },
      name: pluginTemplateName,
      data: {},
      // 请求更新弹窗高度
      extraData: {
        requestWindowHeight: height
      }
    } as PushParametersI, () => {
      log.info(`${TAG} update plugin window height complete. name is ${pluginTemplateName}`);
    });
  }
}

interface PushParametersI extends plugin.PushParameters {
  owner: Want;
}

@Observed
export class AnimProperty {
  public slot: string = '';
  /**
   * 图标是否正在动画
   */
  public isPluginIconAnimating: boolean = false;
  /**
   * 图标横向缩放
   */
  public scaleX: number = 1;
  /**
   * 图标纵向缩放
   */
  public scaleY: number = 1;
  /**
   * 底板横向缩放
   */
  public backgroundScaleX: number = 1;
  /**
   * 底板纵向缩放
   */
  public backgroundScaleY: number = 1;

  constructor(slot: string) {
    this.slot = slot;
  }
}

export default WifiIconPC;