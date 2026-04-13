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
import access from '@ohos.bluetooth.access';
import { BusinessError } from '@ohos.base';
import { commonEventManager } from '@kit.BasicServicesKit';
import settings from '@ohos.settings';
import { WindowAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/WindowAdapter';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  EventManager,
  EvtBus,
  obtainStartAbilityWithWant,
  PluginClickInfo,
  PluginSlot,
  WallpaperChangeEvent
} from '@ohos/frameworkwrapper';
import { ExtAppConstants, FASlotName } from '@ohos/commonconstants';
import { BaseController, CommonData } from '@ohos/controlcentercommon/Index';
import Constants from '../common/model/Constants';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { StringUtil } from '../common/model/StringUtil';
import { DeviceShowInfo } from '../common/model/DeviceShowInfo';
import { DataType } from '../common/model/DataType';
import PluginCardController from './PluginCardController';
import { ContinuityState } from '../common/model/ContinuityState';
import { SettingsDataUtils } from '../common/utils/SettingsDataUtils';
import { pluginCardReportUtil } from '../common/PluginCardReportUtil';
import { CollaborationSwitchManager } from '../common/utils/CollaborationSwitchManager';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';

const TAG = 'Model.SuperDeviceController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export enum PageMode {
  NONE,
  LIST,
  OTHER,
  EDIT
}

export class SuperDeviceController extends BaseController<CommonData> {
  private static instance?: SuperDeviceController;
  private mSuperDeviceToggleData: CommonData = new CommonData();
  private stateSubscriber?: commonEventManager.CommonEventSubscriber;
  private isWifiOpened: boolean = false;
  private isBluetoothOpened: boolean = true;
  private isCollaborationSwitchOpened: boolean = true;
  private pageMode: PageMode = PageMode.NONE;
  private eventManager: EventManager = EvtBus.createEventManager();
  private mWallpaperAvgColor: string = '#00ffffff';

  constructor() {
    super();
    this.onStart();
  }

  isLoadLottie(): boolean {
    return false;
  }

  /**
   * 设置当前展示页面  NONE：头等舱 LIST：二级列表页面 OTHER：控制中心收起后展示的页面
   * @returns
   */
  public setPageMode(pageMode: PageMode): void {
    log.showInfo(`setPageMode ${PageMode[pageMode]}`);
    this.pageMode = pageMode;
  }

  /**
   * 获取当前展示页面  NONE：头等舱 LIST：二级列表页面
   * @returns
   */
  public getPageMode(): PageMode {
    return this.pageMode;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    // 大桌面进程开启的时候处理的逻辑
    this.subscribeWindowState();
    if (DeviceHelper.isPC()) {
      this.eventManager.on(WallpaperChangeEvent, (data: WallpaperChangeEvent) => {
        this.mWallpaperAvgColor = data.avgColor;
      });
    }
  }

  /**
   * 是否需要监听卫星通信状态
   */
  needListenSatelliteMode(): boolean {
    return true;
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    this.unSubscribe();
    if (DeviceHelper.isPC()) {
      this.eventManager.offAll();
    }
  }

  isAvailable(): boolean {
    return true;
  }

  /**
   * 打开二级列表页面
   */
  public openSuperDeviceList(): void {
  log.showInfo(`openSuperDeviceList start`);
    this.mSuperDeviceToggleData.status = !this.mSuperDeviceToggleData.status;
    if (!this.checkSwitchStatus()) {
      return;
    }

    if (!this.checkAccountLogin()) {
      return;
    }

    if (!this.checkWifiBluetooth()) {
      return;
    }

    this.showSuperDeviceWindow();
  }

  /**
   * 弹窗确认按钮点击
   * @param dialogCode
   */
  public confirmClick(dialogCode: number): void {
    log.info(`confirmClick dialogCode ${dialogCode}`);
    if (dialogCode === Constants.DIALOG_DEFAULT) {
      log.warn('dialogCode is undefined or default');
      return;
    }

    if (dialogCode === Constants.DIALOG_ACCOUNT) {
      log.info('start login account');
      this.goAccountSettings();
    } else if (dialogCode === Constants.DIALOG_WIFI_BLUETOOTH) {
      this.openWifiBluetooth();
    } else if (dialogCode === Constants.DIALOG_SWITCH_STATUS) {
      this.openSuperDeviceSwitch();
    } else if (dialogCode === Constants.PHONE_DIALOG_WIFI ||
      dialogCode === Constants.PHONE_DIALOG_WIFI_LIST) {
      log.info(TAG, 'open wifi and page list');
      this.openWifiPageList();
    }
  }

  private goAccountSettings(): void {
    let mdName: string | undefined = DeviceHelper.isPC() ? undefined : 'phone_settings';

    EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
      bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
      uri: 'hms_account_home_settings',
      moduleName: mdName
    }));
    pluginCardReportUtil.reportUEClickOpenHWAccountEvent();
  }

  handleClick(): boolean {
    if (!DeviceHelper.isPC()) {
      this.handleOnControlCenterWithScreenLockForUIE((): void => {
        SuperDeviceController.getInstance().openSuperDeviceList();
      }, true);
    } else {
      this.handleOnControlCenterWithScreenLock((): void => {
        const controller = PluginCardController.getInstance();
        let isAccountReady = AppStorage.get('isAccountReady') as boolean;
        let pivotX = this.getAnimPivotX(PluginSlot.SLOT_STATUS_CONTROL_CENTER) ?? '';
        let pivotY = this.getAnimPivotY(PluginSlot.SLOT_STATUS_CONTROL_CENTER) ?? '';
        controller.openPageList(this.mWallpaperAvgColor, isAccountReady, pivotX, pivotY);
        this.setPageMode(PageMode.LIST);
      });
    }
    return true;
  }

  /**
   * 渲染item的点击事件
   *
   * @param item 点击图标的设备信息
   * @param index 点击图标的设备在设备列表索引
   */
  public onUserClickEvent(item: DeviceShowInfo, index: number): void {
    if (item === undefined || item === null) {
      log.showError('onUserClickEvent item is undefined');
      return;
    }
    this.handleOnControlCenterWithScreenLock((): void => {
      log.showInfo('user click, networkId = ' +
      StringUtil.getAnonymousData(item.networkId, DataType.NET_ID) + ', brMac =' +
      StringUtil.getAnonymousData(item.brMac, DataType.BT_MAC));
      const controller = PluginCardController.getInstance();
      const currentService = controller.getCurrentServiceName(item);
      if (currentService.length === 0) {
        log.showError('serviceName is null');
        return;
      }
      let currentState = controller.getCurrentState(item);
      if (currentState === ContinuityState.CONNECTED || currentState === ContinuityState.CONNECTING ||
        currentState === ContinuityState.PREPARE) {
        controller.stopContinuity(item, currentService);
        item.setIsClickPluginCard(true);
        controller.setDeviceState(item, ContinuityState.DISCONNECTING, index);
      } else if (currentState === ContinuityState.IDLE) {
        controller.startContinuity(item, currentService);
        item.setIsClickPluginCard(true);
        controller.setDeviceState(item, ContinuityState.CONNECTING, index);
      } else {
        log.showError('The current status does not support collaboration, This click is invalid');
      }
    }, false);
  }

  public checkSwitchStatus(): boolean {
    let isStateOn = SettingsDataUtils.getSettingsData(Constants.STATE_KEY, Constants.STATE_ON_FLAG,
      settings.domainName.USER_SECURITY) ===
    Constants.STATE_ON_FLAG ? true : false;
    if (isStateOn) {
      log.showInfo('Switch is on');
      return true;
    } else {
      log.showInfo('Switch is off');
      AppStorage.setOrCreate<number>('superDeviceDialogCode', Constants.DIALOG_SWITCH_STATUS);
      return false;
    }
  }

  private checkWifiBluetooth(): boolean {
    try {
      let btState: access.BluetoothState = access.getState();
      log.info(TAG, `isBluetoothOpened bluetoothState is ${btState}`);
      this.isBluetoothOpened = btState === access.BluetoothState.STATE_ON ||
        btState === access.BluetoothState.STATE_TURNING_ON;
      log.info(TAG, `isBluetoothOpened ${this.isBluetoothOpened}`);
    } catch (error) {
      log.error(TAG,
        `get bluetooth state error: ${(error as BusinessError).code}, ${(error as BusinessError).message}`);
    }
    try {
      let wifiState: wifiManager.WifiDetailState = wifiManager.getWifiDetailState();
      log.info(TAG, `isWifiOpened wifiState is ${wifiState}`);
      this.isWifiOpened = wifiState === 1 || wifiState === 2;
      log.info(TAG, `isWifiOpened ${this.isWifiOpened}`);
    } catch (error) {
      log.error(TAG, `get wifi state error: ${(error as BusinessError).code}, ${(error as BusinessError).message}`);
    }
    let collaborationSwitchState: string = CollaborationSwitchManager.getCollaborationSwitchState();
    log.info(TAG, `isCollaborationSwitchOpened collaboration switch state is ${collaborationSwitchState}`);
    this.isCollaborationSwitchOpened = collaborationSwitchState === Constants.COLLABORATION_SERVICE_SWITCH_ON;
    log.info(TAG, `isCollaborationSwitchOpened ${this.isCollaborationSwitchOpened}`);

    if (!this.isBluetoothOpened) {
      log.info(`wifi bluetooth`);
      AppStorage.setOrCreate<number>('superDeviceDialogCode', Constants.DIALOG_WIFI_BLUETOOTH);
    }
    return this.isBluetoothOpened;
  }

  public checkWifi(): boolean {
    try {
      let wifiState: wifiManager.WifiDetailState = wifiManager.getWifiDetailState();
      log.info(TAG, `isWifiOpened wifiState is ${wifiState}`);
      let isOpened = wifiState === 1 || wifiState === 2;
      log.info(TAG, `isOpened ${isOpened}`);
      return isOpened;
    } catch (error) {
      log.error(TAG, `get wifi state error: ${(error as BusinessError).code}, ${(error as BusinessError).message}`);
    }
    return false;
  }

  public publishDialogEvent(event: number) {
    log.info(`event: ${event}`);
    AppStorage.setOrCreate<number>('superDeviceDialogCode', event);
  }

  private openWifi() {
    let isOpenWifi: boolean = this.checkWifi();
    if (!isOpenWifi) {
      try {
        wifiManager.enableWifi();
        log.info('userConfirm: opened wifi');
      } catch (error) {
        log.error(`enableWifi error: ${(error as BusinessError).code},
         ${(error as BusinessError).message}`);
        return;
      }
    }
  }

  public openWifiPageList() : void {
    this.openWifi();
    this.showSuperDeviceWindow();
  }

  private openWifiBluetooth(): void {
    if (!this.isBluetoothOpened && !this.isWifiOpened) {
      pluginCardReportUtil.reportUEClickOpenWLANBtEvent();
    }

    if (!this.isBluetoothOpened) {
      try {
        access.enableBluetooth();
        log.info('userConfirm: opened bluetooth');
      } catch (error) {
        log.error(`enableBluetooth error: ${(error as BusinessError).code}, ${(error as BusinessError).message}`);
        return;
      }

      pluginCardReportUtil.reportUEClickOpenBluetoothEvent();
    }
    if (!this.isWifiOpened) {
      try {
        wifiManager.enableWifi();
        log.info('userConfirm: opened wifi');
      } catch (error) {
        log.error(`enableWifi error: ${(error as BusinessError).code}, ${(error as BusinessError).message}`);
        return;
      }

      pluginCardReportUtil.reportUEClickOpenWLANEvent();
    }

    this.showSuperDeviceWindow();
  }

  private openSuperDeviceSwitch(): void {
    SettingsDataUtils.setSwitchSync(Constants.STATE_KEY, Constants.STATE_ON_FLAG, settings.domainName.USER_SECURITY);
  }

  private checkAccountLogin(): boolean {
    let isAccountLogin = AppStorage.get('isAccountReady') as boolean;
    if (isAccountLogin) {
      log.info(`Aleady login account`);
      return true;
    } else {
      log.info('The account is not logged in');
      AppStorage.setOrCreate<number>('superDeviceDialogCode', Constants.DIALOG_ACCOUNT);
      return false;
    }
  }

  // 固定写法，供UI获取
  getData(): CommonData {
    return this.mSuperDeviceToggleData;
  }

  private subscribeWindowState(): void {
    if (this.stateSubscriber) {
      log.info('stateSubscriber is already subscribe');
      return;
    }
    // 订阅连接状态事件
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [Constants.PUBLISH_EVENT_OPEN_SUB_WINDOW, Constants.PUBLISH_EVENT_CLOSE_SUB_WINDOW,
      Constants.START_CONTINUITY, Constants.PUBLISH_EVENT_OPEN_DIALOG],
      publisherBundleName: Constants.SUPER_DEVICE_BUNDLE_NAME
    };
    // 创建订阅者回调
    commonEventManager.createSubscriber(subscribeInfo, (err: BusinessError, data) => {
      if (err) {
        log.error(`createSubscriber error. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      log.info('createSubscriber Succeeded');
      this.stateSubscriber = data;
      // 订阅公共事件回调
      if (this.stateSubscriber) {
        this.subscribeConnectStatus();
      } else {
        log.error('subscriber is undefined');
      }
    });
  }

  private subscribeConnectStatus(): void {
    if (!this.stateSubscriber) {
      log.warn('subscribeConnectStatus subscriber is undefined, to create');
      this.subscribeWindowState();
      return;
    }
    commonEventManager.subscribe(this.stateSubscriber, (err: BusinessError, data) => {
      if (err) {
        log.error(`subscribe error. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      log.info(`event: ${data.event}`);
      if (data.event === Constants.PUBLISH_EVENT_CLOSE_SUB_WINDOW) {
        this.setPageMode(PageMode.NONE);
        sToggleSubWindowController.hideWindow();
      } else if (data.event === Constants.PUBLISH_EVENT_OPEN_SUB_WINDOW) {
        this.showSuperDeviceWindow();
      } else if (data.event === Constants.PUBLISH_EVENT_OPEN_DIALOG) {
        this.handleOpenDialogEvent();
      } else {
        log.error(`uninvalid event. event is ${data.event}`);
      }
    });
  }

  handleOpenDialogEvent() {
    this.setPageMode(PageMode.NONE);
    sToggleSubWindowController.hideWindow();
    this.publishDialogEvent(Constants.PHONE_DIALOG_WIFI_LIST);
  }

  autoTriggerContinuity(uniqueId: string) {
    if (StringUtil.checkStrIsEmpty(uniqueId)) {
      log.warn('device unique id is undefined');
      return;
    }
    const controller = PluginCardController.getInstance();
    let allDevices = controller.getRadarAllDevices();

    let deviceIndex = allDevices.findIndex((showInfo) => showInfo.uniqueId === uniqueId);
    if (deviceIndex < 0) {
      log.error('not find target device');
    }
    this.onUserClickEvent(allDevices[deviceIndex], deviceIndex);
  }

  /**
   * 打开二级列表页面
   */
  private showSuperDeviceWindow(): void {
    log.warn(`showSuperDeviceWindow`);
    sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.SUPER_DEVICE, {
      clickType: 'window',
      bundleName: Constants.SUPER_DEVICE_BUNDLE_NAME,
      abilityName: 'ListPageAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: Constants.LIST_HEIGHT
    } as PluginClickInfo);
    this.setPageMode(PageMode.LIST);
  }

  private unSubscribe(): void {
    if (!this.stateSubscriber) {
      log.warn('unSubscribe but stateSubscriber is undefined');
      return;
    }
    try {
      commonEventManager.unsubscribe(this.stateSubscriber, (err: BusinessError) => {
        if (err) {
          log.error(`unsubscribe failed, code is ${err.code}, message is ${err.message}`);
        } else {
          this.stateSubscriber = undefined;
          log.info('unsubscribe success');
        }
      });
    } catch (error) {
      this.stateSubscriber = undefined;
      let err: BusinessError = error as BusinessError;
      log.error(`unsubscribe failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  publishCommonEvent(event: string, eventInfo?: string): void {
    log.info(`publishCommonEvent ${event}`);
    let pivotX = this.getAnimPivotX(PluginSlot.SLOT_STATUS_CONTROL_CENTER) ?? '';
    let pivotY = this.getAnimPivotY(PluginSlot.SLOT_STATUS_CONTROL_CENTER) ?? '';
    try {
      commonEventManager.publish(event, {
        bundleName: Constants.SUPER_DEVICE_BUNDLE_NAME,
        parameters: { 'deviceUniqueId': eventInfo ?? '',
          'pivotX': pivotX,
          'pivotY': pivotY }
      }, (err: BusinessError) => {
        if (err) {
          log.error(`publishCommonEvent error code: ${err.code}`);
        }
      });
    } catch (error) {
      log.error(`publishCommonEvent publish error code: ${error.code}`);
    }
  }

  /**
   * 将缩放值转为字符串形式百分数
   *
   * @param value 缩放比
   * @returns 百分数形式的缩放百分比
   */
  toPercentage(value: number): string {
    let valueUpper = value > 1 ? 1 : value;
    let valueDown = valueUpper < 0 ? 0 : valueUpper;
    return `${(valueDown * 100).toFixed(0)}%`;
  }

  /**
   * 获取锚点信息，X轴上位置
   *
   * @param windowName 窗口名
   * @returns 获取窗口动效锚点 X轴位置
   */
  getAnimPivotX(windowName: string) {
    let pivotX: number = WindowAdapter.getWindowAnimPivot(windowName)[0] ?? 0;
    return this.toPercentage(pivotX);
  }

  /**
   * 获取锚点信息，y轴上位置
   *
   * @param windowName 窗口名
   * @returns 获取窗口动效锚点 Y轴位置
   */
  getAnimPivotY(windowName: string) {
    let pivotY: number = WindowAdapter.getWindowAnimPivot(windowName)[1] ?? 0;
    return this.toPercentage(pivotY);
  }

  /**
   * Get the instance of the SuperDeviceController class
   */
  static getInstance(): SuperDeviceController {
    if (!SuperDeviceController.instance) {
      SuperDeviceController.instance = new SuperDeviceController();
    }
    return SuperDeviceController.instance;
  }
}