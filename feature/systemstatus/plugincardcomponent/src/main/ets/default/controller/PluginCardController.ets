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

import type common from '@ohos.app.ability.common';
import type Want from '@ohos.app.ability.Want';
import type { BusinessError } from '@ohos.base';
import util from '@ohos.util';
import promptAction from '@ohos.promptAction'
import dataShare from '@ohos.data.dataShare';
import { CommonUtils, LogHelper, LogDomain } from '@ohos/basicutils';
import {
  GlobalContext,
  sEventManager,
  obtainLocalEvent, DeviceHelper
} from '@ohos/frameworkwrapper';

import {
  DfxSceneBoard,
  BizScene,
  BizStage,
  StageRes,
  BizState,
  DfxReportSceneInfo,
  DfxReportOnlineDevice,
  DfxDeviceInfo,
  TriggerMode,
} from '../DFX/DfxUtils';
import { AccountStateManager } from '../common/model/AccountStateManager';
import Constants, { ServerConnectState } from '../common/model/Constants'
import { PageMode, SuperDeviceController } from './SuperDeviceController';
import { ContinuityState } from '../common/model/ContinuityState';
import { DeviceShowInfo } from '../common/model/DeviceShowInfo';
import SuperDeviceExtServiceProxy from '../service/SuperDeviceExtServiceProxy'
import { SettingsDataUtils } from '../common/utils/SettingsDataUtils';
import { emitter } from '@kit.BasicServicesKit';
import { DeviceStateInfo } from '../common/model/DeviceStateInfo';
import { pluginCardReportUtil } from '../common/PluginCardReportUtil';
import { StringUtil } from '../common/model/StringUtil';
import sDropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';

const TAG: string = 'PluginCardController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const MAX_DEVICE_NUM: number = 2;
const MAIN_LAYOUT = 0;

@Observed
export class DeviceItem {
  public showInfo: DeviceShowInfo
  public isRefresh: boolean

  constructor(showInfo: DeviceShowInfo, isRefresh: boolean) {
    this.showInfo = showInfo;
    this.isRefresh = isRefresh;
  }

  public getItemKey(index: number): string {
    return this.showInfo.uniqueId + this.showInfo.getStateStr() + this.showInfo.extraInfo + index.toString();
  }
}

export default class PluginCardController {
  private static readonly CONNECT_RETRY_TIME = 300;
  public static deviceNumLink: AbstractProperty<number | null> | undefined = undefined;
  public static isRelease: boolean = false;
  protected records: Record<string, object> = {};
  private static instance: PluginCardController | undefined | null = undefined;
  // @internal
  private static want: Want = {
    bundleName: 'com.ohos.superdevice',
    abilityName: 'SuperDeviceServiceExtensionAbility',
  };
  private superDeviceExtServiceProxy: SuperDeviceExtServiceProxy | undefined | null = null;
  private deviceList: DeviceItem[] = [];
  private mListeners: DataChangeListener[] = [];
  private connectId: number = Constants.INVALID_ID;
  private radarAllDevices: DeviceShowInfo[] = [];
  private accountState: boolean = true;
  private dataHelper: dataShare.DataShareHelper | undefined = undefined;
  private isDisconnecting = false;
  private serverConnectedState: number = ServerConnectState.INIT_PAGE;

  static getInstance(): PluginCardController {
    if (!PluginCardController.instance) {
      log.showDebug(`first init PluginCardController`);
      PluginCardController.instance = new PluginCardController();
    }
    if (PluginCardController.instance) {
      PluginCardController.instance.initStorageLink();
    }
    return PluginCardController.instance;
  }

  public release(): void {
    if (PluginCardController.instance) {
      PluginCardController.isRelease = true;
      PluginCardController.instance.destroy();
      AccountStateManager.getInstance().unRegisterAccountStateListener();
      PluginCardController.getInstance().unRegisterSecurityDataChange();
    }
    PluginCardController.instance = null;
  }

  private initLottieData(): void {
    log.showDebug(`initLottieData`);
    if (!CommonUtils.isEmpty(this.getLottieConnectName())) {
      this.loadLottieData(this.getLottieConnectName(), (value) => {
        this.records.connect = value;
      });
    }
    if (!CommonUtils.isEmpty(this.getLottieDisconnectName())) {
      this.loadLottieData(this.getLottieDisconnectName(), (value) => {
        this.records.disconnect = value;
      });
    }
  }

  protected loadLottieData(jsonName: string, callback: (value: object) => void): void {
    log.showDebug(`loadLottieData, jsonName =${jsonName}`);
    let resStr = new util.TextDecoder('utf-8', {
      ignoreBOM: true
    });
    try {
      let context = GlobalContext.getContext();
      context.resourceManager.getRawFile(jsonName, (err: Error, data: Uint8Array) => {
        if (data === null || data === undefined || data.buffer === undefined) {
          log.showError(`loadLottieData getRawFile error`);
          return;
        }
        let lottieStr = resStr.decode(new Uint8Array(data.buffer));
        let lottieData: object = JSON.parse(lottieStr);
        if (callback) {
          callback(lottieData);
        }
      });
    } catch (err) {
      log.showError(`context is undefined`);
    }
  }

  private getLottieConnectName(): string {
    return Constants.LOTTIE_DATA_CONNECT;
  }


  private getLottieDisconnectName(): string {
    return Constants.LOTTIE_DATA_DISCONNECT;
  }

  public getLottieRecords(): Record<string, object> {
    return this.records;
  }

  public setRadarAllDevices(devices: DeviceShowInfo[]): void {
    log.showInfo(`setRadarAllDevices, radarAllDevices.length: ${devices.length}`);
    let radarAllDevices: DeviceShowInfo[] = []
    for (let i = 0; i < devices.length; i++) {
      radarAllDevices.push(new DeviceShowInfo(devices[i].deviceId, devices[i].uniqueId, devices[i].deviceName,
        devices[i].deviceType,
        devices[i].networkId, devices[i].brMac, devices[i].extraInfo, devices[i].serviceRuleList));
    }
    this.radarAllDevices = radarAllDevices;
  }

  public getRadarAllDevices(): DeviceShowInfo[] {
    return this.radarAllDevices;
  }

  public setAccountState(accountState: boolean): void {
    log.showInfo(`setAccountState`);
    this.accountState = accountState;
  }

  public getAccountState(): boolean {
    log.showInfo(`getRadarAllDevices`);
    return this.accountState;
  }

  public getServerConnectedState(): number {
    return this.serverConnectedState;
  }

  /**
   * register setting data change
   */
  public registerSettingDataChange(): void {
    if (this.dataHelper) {
      return;
    }

    let helper =
      SettingsDataUtils.createDataHelper(Constants.SUPER_DEVICE_ENTRY) as Promise<dataShare.DataShareHelper>;
    helper.then((dataHelper) => {
      this.dataHelper = dataHelper;
      SettingsDataUtils.registerSecurityDataChange(dataHelper, Constants.STATE_KEY, () => {
        log.showInfo('dataChange: switch state is change')

        if (SettingsDataUtils.isSwitchOff()) {
          // 禁用，解订阅
          PluginCardController.getInstance().superDeviceExtServiceProxy?.clearTimeOutRunningTask();
          PluginCardController.getInstance().release();
          return;
        } else {
          PluginCardController.getInstance().init();
          let innerEvent: emitter.InnerEvent = {
            eventId: Constants.CONTROLLER_INIT_EVENT,
          };
          emitter.emit(innerEvent, {})
        }
      })
    }).catch((error: BusinessError) => {
      log.showError(`createDataHelper error: error code, ${error.code}; error message, ${error?.message}`);
    })
  }

  /**
   * unregister setting data change
   */
  public unRegisterSecurityDataChange(): void {
    SettingsDataUtils.unRegisterSecurityDataChange(this.dataHelper, Constants.STATE_KEY);
    this.dataHelper = undefined;
  }

  private connectServiceExtensionAbility(onConnect: Function | undefined = undefined): void {
    log.showInfo(`connectServiceExtensionAbility enter`);
    if (this.isDisconnecting) {
      setTimeout(() => {
        log.showInfo(`is disconnecting,retry after 300ms.`);
        this.connectServiceExtensionAbility(onConnect);
      }, PluginCardController.CONNECT_RETRY_TIME);
    }
    if (this.superDeviceExtServiceProxy) {
      if (typeof onConnect === 'function') {
        log.showInfo(`onConnect`);
        onConnect();
      }
      return;
    }
    if (this.connectId !== Constants.INVALID_ID) {
      log.showInfo('has connected.');
      return;
    }
    try {
      this.connectId = GlobalContext.getContext().connectServiceExtensionAbility(PluginCardController.want,
        {
          onConnect: (elementName, proxy) => {
            log.showInfo(`onConnect ${elementName}`);
            this.superDeviceExtServiceProxy = new SuperDeviceExtServiceProxy(proxy);
            this.serverConnectedState = ServerConnectState.CONNECTED;
            if (typeof onConnect === 'function') {
              onConnect();
            }
          },
          onDisconnect: (elementName) => {
            log.showInfo(`onDisconnect ${elementName}`);
            this.superDeviceExtServiceProxy?.clearTimeOutRunningTask();
            this.superDeviceExtServiceProxy = null;
            this.connectId = Constants.INVALID_ID;
            this.isDisconnecting = false;
            this.serverConnectedState = ServerConnectState.DISCONNECTED;
            if (SuperDeviceController.getInstance().getPageMode() === PageMode.NONE &&
              ((!DeviceHelper.isPC() && sDropDownPanelManager.isPanelShowing()) ||
              DeviceHelper.isPC())) {
              log.showInfo('the current page is in the control center, occur proxy crash, retry subscribe');
              this.connectServiceExtensionAbility(() => {
                this.subscribeShowInfo();
              });
            }
          },
          onFailed: (code) => {
            log.showError(`onFailed ${code}`);
            this.superDeviceExtServiceProxy = null;
            this.connectId = Constants.INVALID_ID;
          }
        });
    } catch (err) {
      if (err.code) {
        log.error(TAG, 'connectServiceExtensionAbility failed. Err Code:', err);
      }
    }
  }

  /**
   * Init single instance. connect SuperDeviceExtService
   */
  public init(): void {
    log.showInfo(`connectService enter`);
    PluginCardController.isRelease = false;
    this.connectServiceExtensionAbility(() => {
      this.subscribeShowInfo();
    });
    this.superDeviceExtServiceProxy?.clearTimeOutRunningTask();
    this.initLottieData();
  }

  public retrySubscribe(): void {
    log.showInfo('proxy died, retry subscribe');
    this.connectServiceExtensionAbility(() => {
      this.subscribeShowInfo();
    });
  }

  public beAbleUnsubscribe(): void {
    if (this.superDeviceExtServiceProxy) {
      log.showInfo('this.superDeviceExtServiceProxy');
      let result = this.superDeviceExtServiceProxy.beAbleUnsubscribe();
      if (!result) {
        log.showError(`beAbleUnsubscribe failed`);
      }
    } else {
      PluginCardController.getInstance().unRegisterSecurityDataChange();
    }
  }

  /**
   * Destroy single instance
   */
  private destroy(): void {
    log.showInfo(`destroy`);
    this.unsubscribeShowInfo();
    this.disconnectService();
    this.records = {};
    this.deviceList = [];
    PluginCardController.deviceNumLink?.set(this.deviceList.length);
    this.notifyDataReload();
    AppStorage.delete('deviceNumber');
  }

  private disconnectService() {
    try {
      if (this.connectId === Constants.INVALID_ID) {
        log.showInfo(`connectId is invalid`);
        return;
      }
      GlobalContext.getContext().disconnectServiceExtensionAbility(this.connectId).then(() => {
        log.showInfo(`disconnect successes.`);
        this.isDisconnecting = true;
      }).catch((error: BusinessError) => {
        log.showError(`disconnect failed. Error code: ${error.code}`);
      });
    } catch (err) {
      if (err.code) {
        log.error(TAG, 'disconnectServiceExtensionAbility failed. Err Code:', err);
      }
    } finally {
      this.connectId = Constants.INVALID_ID;
      this.superDeviceExtServiceProxy = null;
    }
  }

  private initStorageLink(): void {
    log.showDebug(`do PluginCardController init task `);
    try {
      PluginCardController.deviceNumLink = AppStorage.setAndRef('deviceNumber', 0);
    } catch (err) {
      log.showError(`do PluginCardController init task fail:${err.code}`);
    }
  }

  private subscribeShowInfo(): void {
    if (this.superDeviceExtServiceProxy) {
      log.showInfo(`subscribeShowInfo enter`)
      let result = this.superDeviceExtServiceProxy.subscribeShowInfo();
      if (!result) {
        log.showError(`subscribe DeviceShowInfo failed`);
      }
      return;
    }
    this.connectServiceExtensionAbility(() => {
      this.superDeviceExtServiceProxy?.subscribeShowInfo();
    });
  }

  private unsubscribeShowInfo(): void {
    if (this.superDeviceExtServiceProxy) {
      log.showInfo(`unsubscribeShowInfo enter`)
      let result = this.superDeviceExtServiceProxy.unsubscribeShowInfo();
      if (!result) {
        log.showError(`unsubscribe DeviceShowInfo failed`);
      }
    }
  }

  public showToast(errorMsg: string): void {
    try {
      log.showInfo(`PageMode ${PageMode[SuperDeviceController.getInstance().getPageMode()]}`);
      if (SuperDeviceController.getInstance().getPageMode() === PageMode.NONE) {
        promptAction.showToast({
          message: errorMsg,
          duration: 3000,
          showMode: 2,
        })
      }
    } catch (error) {
      log.showError(`showToast args error code is ${error.code}, message is ${error.message}`);
    }
  }

  public deviceListUpdate(deviceList: DeviceShowInfo[]): void {
    log.showInfo(`new deviceList size:${deviceList.length} , old deviceList size:${this.deviceList.length}`);
    pluginCardReportUtil.reportUECollaborationStateEvent(deviceList, undefined, this.deviceList);

    deviceList.forEach((showInfo): void => log.showInfo(`new device:${showInfo.deviceType}`));
    const tempList = deviceList.length > MAX_DEVICE_NUM ? deviceList.splice(0, MAX_DEVICE_NUM) : deviceList;
    PluginCardController.deviceNumLink?.set(tempList.length);
    for (let oldIdx = 0; oldIdx < this.deviceList.length; oldIdx++) {
      let newIdx = tempList.findIndex(showInfo => (
        showInfo.uniqueId === this.deviceList[oldIdx].showInfo.uniqueId));
      if (newIdx < 0) {
        this.deleteData(oldIdx);
        oldIdx--;
        continue;
      }

      tempList[newIdx].setIsClickPluginCard(this.deviceList[oldIdx].showInfo.getIsClickPluginCard());
      this.refreshData(oldIdx, tempList[newIdx]);
      tempList.splice(newIdx, 1);
    }
    tempList.forEach((showInfo): void => this.pushData(showInfo));
    this.deviceList.forEach((item): void => log.showInfo(`old device:${item.showInfo.deviceType}`));
  }

  public notifyStateUpdate(key: string, serviceName: string, state: ContinuityState,
    errorMessage: string, errorCode?: string): void {
    const idx = this.deviceList.findIndex(item => (item.showInfo.uniqueId === key));
    if (idx < 0) {
      log.showError(`The device does not exist.`);
      return;
    }
    let serviceIndex =
      this.deviceList[idx].showInfo.serviceRuleList.findIndex(service => service.serviceName === serviceName);
    if (serviceIndex < 0) {
      log.showError(`The service does not exist.`);
      return;
    }
    let currentState = this.deviceList[idx].showInfo.serviceRuleList[serviceIndex].state;
    log.showInfo(`idx:${idx}, serviceName:${serviceName}, old state:${currentState}, new state:${state}`);
    this.deviceList[idx].showInfo.serviceRuleList[serviceIndex].state = state;
    this.refreshData(idx, this.deviceList[idx].showInfo);
    if (errorMessage.length > 0) {
      log.showError(`Service collaboration failure, errorMessage:${errorMessage}`);
      this.showToast(errorMessage);

      let deviceStateInfo: DeviceStateInfo = {
        key: key,
        serviceName: serviceName,
        state: state,
        error: errorMessage,
        errorCode: errorCode
      }
      pluginCardReportUtil.reportUECollaborationStateEvent(undefined, deviceStateInfo, this.deviceList);
    }
  }

  public getCurrentServiceName(showInfo: DeviceShowInfo): string {
    const serviceIndex = showInfo.serviceRuleList.findIndex(service => service.priority === 0);
    if (serviceIndex < 0) {
      log.showError('current service do not support')
      return '';
    }
    return showInfo.serviceRuleList[serviceIndex].serviceName;
  }

  public setDeviceState(showInfo: DeviceShowInfo, state: ContinuityState, index: number): void {
    const currentService = this.getCurrentServiceName(showInfo);
    if (currentService.length === 0) {
      log.showError('serviceName is null');
      return;
    }
    const serviceIndex = showInfo.serviceRuleList.findIndex(service => service.serviceName === currentService);
    if (serviceIndex < 0) {
      log.showError('current service do not support');
      return;
    }
    log.info('serviceName setDeviceState');
    showInfo.serviceRuleList[serviceIndex].state = state;
    this.refreshData(index, showInfo);
  }

  public getCurrentState(showInfo: DeviceShowInfo): ContinuityState {
    const currentService = this.getCurrentServiceName(showInfo);
    if (currentService.length === 0) {
      log.showError('serviceName is null');
      return ContinuityState.IDLE;
    }
    const serviceIndex = showInfo.serviceRuleList.findIndex(service => service.serviceName === currentService);
    if (serviceIndex < 0) {
      log.showError('current service do not support');
      return ContinuityState.IDLE;
    }
    return showInfo.serviceRuleList[serviceIndex].state;
  }

  public startContinuity(showInfo: DeviceShowInfo, serviceName: string): void {
    log.showInfo('startContinuity');
    if (this.superDeviceExtServiceProxy) {
      let result = this.superDeviceExtServiceProxy.startContinuity(showInfo, serviceName);
      if (!result) {
        log.showError('start Continuity failed');
      }
      let dfxDeviceInfo: DfxDeviceInfo = {
        PEER_DEV_NAME: DfxSceneBoard.getInstance().getAnonymousDeviceName(showInfo.deviceName),
        PEER_BT_MAC: DfxSceneBoard.getInstance().getAnonymousBtMAC(showInfo.brMac),
        PEER_NET_ID: DfxSceneBoard.getInstance().getAnonymousDeviceUdID(showInfo.networkId),
        PEER_DEV_TYPE: DfxSceneBoard.getInstance().getDeviceType(showInfo.deviceType, showInfo.deviceClass),
        SERVICE_NAME: serviceName
      };
      let dfxReportInfo: DfxReportSceneInfo = {
        FUNC: 'startContinuity', BIZ_SCENE: BizScene.plCardStartContinuity, BIZ_STAGE: BizStage.STAGE1,
        STAGE_RES: StageRes.SUCCESS, BIZ_STATE: BizState.START, TRIGGER_MODE: TriggerMode.PLUGINCARD,
        CONCURRENT_ID: DfxSceneBoard.getInstance().getAnonymousDeviceId(StringUtil.
        checkStrIsEmpty(showInfo.networkId) ? showInfo.brMac : showInfo.networkId)
      };
      DfxSceneBoard.getInstance().reportClickAndShowState(dfxReportInfo, dfxDeviceInfo);
      return;
    }
    log.showInfo('SuperDevice, SuperDevice is not connected, startConnect');
    this.connectServiceExtensionAbility(() => {
      this.superDeviceExtServiceProxy?.startContinuity(showInfo, serviceName);
      let dfxDeviceInfo: DfxDeviceInfo = {
        PEER_DEV_NAME: DfxSceneBoard.getInstance().getAnonymousDeviceName(showInfo.deviceName),
        PEER_BT_MAC: DfxSceneBoard.getInstance().getAnonymousBtMAC(showInfo.brMac),
        PEER_NET_ID: DfxSceneBoard.getInstance().getAnonymousDeviceUdID(showInfo.networkId),
        PEER_DEV_TYPE: DfxSceneBoard.getInstance().getDeviceType(showInfo.deviceType, showInfo.deviceClass),
        SERVICE_NAME: serviceName
      }
      let dfxReportInfo: DfxReportSceneInfo = {
        FUNC: 'startContinuity', BIZ_SCENE: BizScene.plCardStartContinuity, BIZ_STAGE: BizStage.STAGE1,
        STAGE_RES: StageRes.SUCCESS, BIZ_STATE: BizState.START, TRIGGER_MODE: TriggerMode.PLUGINCARD,
        CONCURRENT_ID: DfxSceneBoard.getInstance().getAnonymousDeviceId(StringUtil.
        checkStrIsEmpty(showInfo.networkId) ? showInfo.brMac : showInfo.networkId)
      }
      DfxSceneBoard.getInstance().reportClickAndShowState(dfxReportInfo, dfxDeviceInfo);
    });
  }

  public stopContinuity(showInfo: DeviceShowInfo, serviceName: string): void {
    log.showInfo('stopContinuity');
    if (this.superDeviceExtServiceProxy) {
      let result = this.superDeviceExtServiceProxy.stopContinuity(showInfo, serviceName);
      if (!result) {
        log.showInfo('stop Continuity failed');
        return;
      }
      let dfxDeviceInfo: DfxDeviceInfo = {
        PEER_DEV_NAME: DfxSceneBoard.getInstance().getAnonymousDeviceName(showInfo.deviceName),
        PEER_BT_MAC: DfxSceneBoard.getInstance().getAnonymousBtMAC(showInfo.brMac),
        PEER_NET_ID: DfxSceneBoard.getInstance().getAnonymousDeviceUdID(showInfo.networkId),
        PEER_DEV_TYPE: DfxSceneBoard.getInstance().getDeviceType(showInfo.deviceType, showInfo.deviceClass),
        SERVICE_NAME: serviceName
      }
      let dfxReportInfo: DfxReportSceneInfo = {
        FUNC: 'stopContinuity', BIZ_SCENE: BizScene.plCardStopContinuity, BIZ_STAGE: BizStage.STAGE1,
        STAGE_RES: StageRes.SUCCESS, BIZ_STATE: BizState.START, TRIGGER_MODE: TriggerMode.PLUGINCARD,
        CONCURRENT_ID: DfxSceneBoard.getInstance().getAnonymousDeviceId(StringUtil.
        checkStrIsEmpty(showInfo.networkId) ? showInfo.brMac : showInfo.networkId)
      }
      DfxSceneBoard.getInstance().reportClickAndShowState(dfxReportInfo, dfxDeviceInfo);
      this.notifyStateUpdate(showInfo.uniqueId, serviceName, ContinuityState.DISCONNECTING, '');
      return;
    }
    log.showInfo('SuperDevice, SuperDevice is not connected, startConnect');
    this.connectServiceExtensionAbility(() => {
      this.superDeviceExtServiceProxy?.stopContinuity(showInfo, serviceName);
      let dfxDeviceInfo: DfxDeviceInfo = {
        PEER_DEV_NAME: DfxSceneBoard.getInstance().getAnonymousDeviceName(showInfo.deviceName),
        PEER_BT_MAC: DfxSceneBoard.getInstance().getAnonymousBtMAC(showInfo.brMac),
        PEER_NET_ID: DfxSceneBoard.getInstance().getAnonymousDeviceUdID(showInfo.networkId),
        PEER_DEV_TYPE: DfxSceneBoard.getInstance().getDeviceType(showInfo.deviceType, showInfo.deviceClass),
        SERVICE_NAME: serviceName
      }
      let dfxReportInfo: DfxReportSceneInfo = {
        FUNC: 'stopContinuity', BIZ_SCENE: BizScene.plCardStopContinuity, BIZ_STAGE: BizStage.STAGE1,
        STAGE_RES: StageRes.SUCCESS, BIZ_STATE: BizState.START, TRIGGER_MODE: TriggerMode.PLUGINCARD,
        CONCURRENT_ID: DfxSceneBoard.getInstance().getAnonymousDeviceId(StringUtil.
        checkStrIsEmpty(showInfo.networkId) ? showInfo.brMac : showInfo.networkId)
      }
      DfxSceneBoard.getInstance().reportClickAndShowState(dfxReportInfo, dfxDeviceInfo);
    });
  }

  /**
   * 打开PC二级列表
   *
   * @param mWallpaperAvgColor 背景颜色
   * @param isLoginAccount 是否登录账号
   * @param pivotX 控制中心面板X轴中心位置
   * @param pivotY 控制中心面板Y轴中心位置
   */
  public openPageList(mWallpaperAvgColor: string, isLoginAccount: boolean, pivotX?: string, pivotY?: string): void {
    log.showInfo('openPageList');
    if (this.superDeviceExtServiceProxy) {
      let result = this.superDeviceExtServiceProxy.openPageList(mWallpaperAvgColor, isLoginAccount, pivotX, pivotY);
      if (!result) {
        log.showInfo('openPageList failed');
      }
      return;
    }
    log.showInfo('SuperDevice, SuperDevice is not connected, startConnect');
    this.connectServiceExtensionAbility(() => {
      this.superDeviceExtServiceProxy?.openPageList(mWallpaperAvgColor, isLoginAccount, pivotX, pivotY);
    });
  }

  public getDeviceList(): DeviceItem[] {
    return this.deviceList;
  }

  public pushData(data: DeviceShowInfo): void {
    let deviceItem = new DeviceItem(data, false);
    this.deviceList.push(deviceItem);
    this.notifyDataAdd(this.deviceList.length - 1);
  }

  public deleteData(index: number): void {
    if (index >= 0 && index < this.deviceList.length) {
      this.deviceList.splice(index, 1);
      this.notifyDataDelete(index);
    }
  }

  public refreshData(index: number, data: DeviceShowInfo): void {
    let deviceItem = new DeviceItem(data, true);
    this.deviceList[index] = deviceItem;
    this.notifyDataChange(index);
  }

  // implementation of IDataSource
  // @internal
  public totalCount(): number {
    return this.deviceList.length;
  }

  // @internal
  public getData(index: number): DeviceItem | null {
    return (index >= 0 && index < this.totalCount()) ? this.deviceList[index] : null
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    if (this.mListeners.indexOf(listener) < 0) {
      this.mListeners.push(listener);
    }
  }

  public unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.mListeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener');
      this.mListeners.splice(pos, 1);
    }
  }

  // 通知LazyForEach组件需要重载所有子组件
  public notifyDataReload(): void {
    this.mListeners.forEach(listener => {
      log.showInfo('notifyDataReload');
      listener.onDataReloaded();
    })
  }

  // 通知LazyForEach组件需要在index对应索引处添加子组件
  public notifyDataAdd(index: number): void {
    this.mListeners.forEach(listener => {
      log.showInfo('notifyDataAdd');
      listener.onDataAdd(index);
    })
  }

  // 通知LazyForEach组件在index对应索引处数据有变化，需要重建该子组件
  public notifyDataChange(index: number): void {
    this.mListeners.forEach(listener => {
      log.showInfo('notifyDataChange');
      listener.onDataChange(index);
    })
  }

  // 通知LazyForEach组件需要在index对应索引处删除该子组件
  public notifyDataDelete(index: number): void {
    this.mListeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  // 通知LazyForEach组件将from索引和to索引处的子组件进行交换
  public notifyDataMove(from: number, to: number): void {
    this.mListeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }


  /**
   * 息屏时关闭窗口
   */
  public onScreenOff(): void {
    log.showInfo('receive screen off');
    if (SuperDeviceController.getInstance().getPageMode() === PageMode.NONE) {
      SuperDeviceController.getInstance().setPageMode(PageMode.OTHER);
    }
    this.hideWindow();
    this.unRegisterSecurityDataChange();
    this.beAbleUnsubscribe();
  }

  /**
   * 隐藏二级页面窗口
   *
   */
  public hideWindow(): void {
    log.showInfo(`PluginCardController hideWindow`);
    sEventManager.publish(obtainLocalEvent('ControlCenterState', MAIN_LAYOUT));
  }
}