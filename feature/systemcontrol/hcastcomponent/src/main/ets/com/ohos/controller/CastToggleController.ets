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

import {
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import {
  DeviceHelper,
  GlobalContext,
  PluginClickInfo,
  sSettingsUtil,
  TargetPanel,
} from '@ohos/frameworkwrapper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { FASlotName } from '@ohos/commonconstants';
import Constants from '../common/Constants';
import common from '@ohos.app.ability.common';
import rpc from '@ohos.rpc';
import { BusinessError } from '@ohos.base';
import Want from '@ohos.app.ability.Want';
import { commonEventManager } from '@kit.BasicServicesKit';
import { pluginComponentManager } from '@kit.ArkUI';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import wifiManager from '@ohos.wifiManager';
import access from '@ohos.bluetooth.access';
import { castReportUtils } from '../common/CastReportUtils';
import { DialogInfo } from '../model/DialogInfo';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleScene, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { AccessibilityVm } from '@ohos/systemuicommon/src/main/ets/vm/AccessibilityVm';
import CastToggleComponent from '../pages/CastToggleComponent';

const TAG = 'Model.CastToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const ACCESSIBILITY_MODE_DELAY_TIME : number = 700;

@Builder function castToggleBuilder() {
  CastToggleComponent()
}

export class CastToggleController extends ToggleBaseViewModel {
  private static instance?: CastToggleController = undefined;
  private stateSubscriber?: commonEventManager.CommonEventSubscriber;
  private rpcRemote?: rpc.IRemoteObject;
  private isWifiOpened: boolean = false;
  private isBluetoothOpened: boolean = true;
  private retryConnectTimes: number = 0;
  private dialogHandlerId: number = -1;
  private activeTask: number = -1;
  public openDetailPageFunc: (() => void) | undefined = () => {
    log.info('controlCenter cast longClick');
    if (DeviceHelper.isPC()) {
      this.resetRetryConnectTimes();
      this.handleClickWithScreenLock((): void => this.connectProjectionService());
    } else {
      this.handleOnControlCenterWithScreenLockForUIE((): void => this.openWirelessProjection(), true);
    }
    return true;
  }

  constructor() {
    super();
    this.getViewData().label = $r('app.string.wireless_projection_toggle');
    this.getViewData().icon = $r('sys.symbol.mirror_projection');
    this.onStart();
  }

  isPersist(): boolean {
    return true;
  }

  decorateStyle(style: ToggleStyle, scene?: ToggleScene | undefined): ToggleStyle | undefined {
    if (scene === ToggleScene.PC) {
      style.toggleParam?.labelArrow(true);
    }
    style.toggleParam?.isSymbolIcon(true)
      .symbolFontWeight(FontWeight.Medium)
      .symbolEffect(new PulseSymbolEffect())
      .setDialogComponent(castToggleBuilder)
    return style;
  }

  isLoadLottie(): boolean {
    return false;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    if (DeviceHelper.isEmulator()) {
      log.showInfo('Disable the cast on the simulator');
      this.getViewData().isUnavailable = true;
      return;
    }
    this.subscribeCastConnectState();
  }

  updateIcon(): void {
    this.getViewData().icon = this.getViewData().isOn ? $r('sys.symbol.screen_share_fill') : $r('sys.symbol.mirror_projection');
    if (this.getViewData().isOn) {
      this.getViewData().isSymbolActive = true;
      this.activeTask = setTimeout(() => {
        this.activeTask = -1;
        this.getViewData().isSymbolActive = false;
        log.showInfo('setTimeout isSymbolActive');
      }, 2000);
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
    if (this.activeTask !== -1) {
      clearTimeout(this.activeTask);
      this.activeTask = -1;
    }
    if (this.dialogHandlerId !== -1) {
      clearTimeout(this.dialogHandlerId);
      this.dialogHandlerId = -1;
    }
  }

  isAvailable(): boolean {
    return true;
  }

  handleOneClick(): void {
    log.info('controlCenter cast click');
    if (this.getViewData().isUnavailable) {
      log.showWarn('click disabled');
      return;
    }
    // UIE场景下，PC锁屏幕与手机不一致
    if (DeviceHelper.isPC()) {
      this.handleOnControlCenterWithScreenLock((): void => {
        if (this.getViewData().isOn) {
          this.publishCommonEvent(Constants.PUBLISH_EVENT_CAST_DISCONNECT_DEVICE);
        } else {
          this.resetRetryConnectTimes();
          this.connectProjectionService();
        }
      });
    } else {
      this.handleOnControlCenterWithScreenLockForUIE((): void => {
        if (this.getViewData().isOn) {
          this.publishCommonEvent(Constants.PUBLISH_EVENT_CAST_DISCONNECT_DEVICE);
        } else {
          this.openWirelessProjection();
        }
      }, true);
    }
    return;
  }

  private openWirelessProjection(): void {
    castReportUtils.reportUEProjectionStart(1);
    if (!this.checkPrivateVersion()) {
      this.publishCommonEvent(Constants.PUBLISH_EVENT_CLOSE_CAST_DIALOG);
      return;
    }
    if (!this.checkWifiBluetooth()) {
      this.publishCommonEvent(Constants.PUBLISH_EVENT_CLOSE_CAST_DIALOG);
      return;
    }
    this.startCastSearch();
  }

  public confirmClick(dialogCode: number): void {
    log.showInfo(`confirmClick dialogCode ${dialogCode}`);
    if (dialogCode === Constants.DIALOG_DEFAULT) {
      log.showWarn('dialogCode is undefined or default');
      return;
    }
    if (dialogCode === Constants.DIALOG_WIFI_BLUETOOTH) {
      this.offWifiBluetooth();
      castReportUtils.reportUEPrivacyDialogEvent(Constants.REPORT_DIALOG_CANCEL);
      this.execClick(() => {
        this.openWifiBluetooth();
        castReportUtils.reportUEWifiBtDialogEvent(this.isWifiOpened, this.isBluetoothOpened,
          Constants.REPORT_DIALOG_CONFIRM);
      });
    } else {
      this.execClick(() => {
        this.startCastSearch();
        castReportUtils.reportUEFailDialogEvent(Constants.REPORT_DIALOG_CONFIRM, dialogCode);
      });
    }
  }

  public cancelClick(dialogCode: number): void {
    if (dialogCode === Constants.DIALOG_DEFAULT) {
      return;
    }
    if (dialogCode === Constants.DIALOG_WIFI_BLUETOOTH) {
      this.offWifiBluetooth();
      castReportUtils.reportUEWifiBtDialogEvent(this.isWifiOpened, this.isBluetoothOpened,
        Constants.REPORT_DIALOG_CANCEL);
    } else {
      castReportUtils.reportUEFailDialogEvent(Constants.REPORT_DIALOG_CANCEL, dialogCode);
    }
  }

  private execClick(callback: Function) {
    if (DeviceHelper.isPC()) {
      this.handleClickWithScreenLock((): void => callback());
    } else {
      this.handleOnControlCenterWithScreenLockForUIE((): void => callback(), true);
    }
  }

  public reConnectService() {
    if (this.retryConnectTimes < Constants.MAX_RETRY_CONNECT_TIMES &&
      FASlotName.CAST === sToggleSubWindowController.getCurrentSubPanelSlot()) {
      this.retryConnectTimes++;
      log.showInfo(`retry connect ${this.retryConnectTimes}`);
      this.connectProjectionService();
    }
  }

  public resetRetryConnectTimes() {
    this.retryConnectTimes = 0;
  }

  public closeRetryConnect() {
    this.retryConnectTimes = Constants.MAX_RETRY_CONNECT_TIMES;
  }

  private connectProjectionService(): void {
    if (this.rpcRemote) {
      log.showInfo('remote is not undefined');
      this.sendRemoteRequest();
      return;
    }
    let options: common.ConnectOptions = {
      onConnect(elementName, remote) {
        log.showInfo('onConnect callback');
        CastToggleController.getInstance().closeRetryConnect();
        CastToggleController.getInstance().rpcRemote = remote;
        CastToggleController.getInstance().sendRemoteRequest();
      },
      onDisconnect(elementName) {
        log.showWarn('onDisconnect castsourceservice');
        CastToggleController.getInstance().rpcRemote = undefined;
        CastToggleController.getInstance().closeSubWindow();
        CastToggleController.getInstance().changeConnectStatus(false);
        CastToggleController.getInstance().reConnectService();
      },
      onFailed(code) {
        log.showWarn(`onFailed castsourceservice callback ${code}}`);
        CastToggleController.getInstance().rpcRemote = undefined;
        CastToggleController.getInstance().reConnectService();
      }
    };
    let want: Want = {
      bundleName: 'com.ohos.ohcast',
      abilityName: 'CastSourceServiceAbility'
    }
    if (DeviceHelper.isPC()) {
      want.parameters = {}
    } else {
      want.parameters = {
        requestCode: Constants.CONTROL_CENTER_PHONE_CLICK_CODE
      }
    }
    try {
      GlobalContext.getContext()?.connectServiceExtensionAbility(want, options);
    } catch (error) {
      log.showError(`cast connectServiceAbility error ${error.code}`);
    }
  }

  private closeSubWindow(): void {
    if (!DeviceHelper.isPC() && sToggleSubWindowController.getCurrentSubPanelSlot() === FASlotName.CAST) {
      log.showWarn('cast needCloseSubWindow');
      sToggleSubWindowController.hideWindow();
    }
  }

  private startCastSearch(): void {
    this.phoneStartProjection();
    this.resetRetryConnectTimes();
    this.connectProjectionService();
  }

  private phoneStartProjection(): void {
    if (!DeviceHelper.isPC() && DropDownPanelManager.getDropDownEvent().target === TargetPanel.CONTROL_CENTER_PANEL) {
      this.closeSubWindow();
      sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.CAST, {
        clickType: 'window',
        bundleName: 'com.ohos.ohcast',
        abilityName: 'CastSearchUIAbility',
        uiExtensionType: 'sys/commonUI',
        windowHeight: 398
      } as PluginClickInfo);
    }
  }

  sendRemoteRequest(): void {
    let option = new rpc.MessageOption();
    let data = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();
    let code = Constants.CONTROL_CENTER_PHONE_CLICK_CODE;
    if (DeviceHelper.isPC()) {
      code = Constants.CONTROL_CENTER_CLICK_CODE;
    }
    this.rpcRemote?.sendMessageRequest(code, data, reply, option).then((result: rpc.RequestResult) => {
      log.showWarn(`sendMessageRequest result: ${result.code}`);
    })
      .catch((error: Error) => {
        log.showError(`cast sendMessageRequest error ${error.message}`);
      }).finally(() => {
      data.reclaim();
      reply.reclaim();
    });
  }

  checkPrivateVersion(): boolean {
    let context: Context = GlobalContext.getContext();
    if (!context) {
      log.showError('getShareStare error! context is undefined or null');
      return false;
    }
    let privacyEnable: string = this.getSettingsValue(context, Constants.CAST_PRIVACY_VERSION,
      Constants.PRIVACY_VERSION_DEFAULT);
    let reShowPrivacy: string = this.getSettingsValue(context, Constants.CONTROL_CENTER_RESHOW_PRIVACY,
      Constants.PRIVACY_VERSION_NEWEST);
    if (privacyEnable !== Constants.PRIVACY_VERSION_NEWEST || reShowPrivacy !== Constants.PRIVACY_VERSION_NEWEST) {
      log.showInfo('privacy dialog show');
      AppStorage.setOrCreate<number>('castDialogCode', Constants.DIALOG_PRIVACY);
      castReportUtils.reportUEPrivacyDialogEvent(Constants.REPORT_DIALOG_SHOW);
    }
    return privacyEnable === Constants.PRIVACY_VERSION_NEWEST && reShowPrivacy === Constants.PRIVACY_VERSION_NEWEST;
  }

  private checkWifiBluetooth(): boolean {
    try {
      let btState: access.BluetoothState = access.getState();
      log.showInfo(`isBluetoothOpened bluetoothState is ${btState}`);
      this.isBluetoothOpened = btState === access.BluetoothState.STATE_ON ||
        btState === access.BluetoothState.STATE_TURNING_ON;
      log.showInfo(`isBluetoothOpened ${this.isBluetoothOpened}`);
    } catch (error) {
      log.showError(`get bluetooth state error: ${(error as BusinessError).code}, ${(error as BusinessError).message}`);
    }
    try {
      let wifiState: wifiManager.WifiDetailState = wifiManager.getWifiDetailState();
      log.showInfo(`isWifiOpened wifiState is ${wifiState}`);
      this.isWifiOpened = wifiState === 1 || wifiState === 2;
      log.showInfo(`isWifiOpened ${this.isWifiOpened}`);
    } catch (error) {
      log.showError(`get wifi state error: ${(error as BusinessError).code}, ${(error as BusinessError).message}`);
    }
    if (!this.isWifiOpened || !this.isBluetoothOpened) {
      log.showInfo(`wifi bluetooth`);
      AppStorage.setOrCreate<number>('castDialogCode', Constants.DIALOG_WIFI_BLUETOOTH);
      try {
        // 如果弹出wifi蓝牙弹窗，需监听状态变化，便于开启后关闭弹窗
        if (!this.isBluetoothOpened) {
          access.on('stateChange', (data: access.BluetoothState) => {
            if (AppStorage.get<number>('castDialogCode') === Constants.DIALOG_WIFI_BLUETOOTH) {
              this.wifiBluetoothChanged();
            }
          });
        }
        if (!this.isWifiOpened) {
          wifiManager.on('wifiStateChange', (wifiState) => {
            if (AppStorage.get<number>('castDialogCode') === Constants.DIALOG_WIFI_BLUETOOTH) {
              this.wifiBluetoothChanged();
            }
          });
        }
      } catch (err) {
        log.showError(`bluetoothState register listener Error: ${err.code}, ${err.message}`);
      }
      castReportUtils.reportUEWifiBtDialogEvent(this.isWifiOpened, this.isBluetoothOpened,
        Constants.REPORT_DIALOG_SHOW);
    }
    return this.isWifiOpened && this.isBluetoothOpened;
  }

  private wifiBluetoothChanged(): void {
    try {
      let btState: access.BluetoothState = access.getState();
      let wifiState: wifiManager.WifiDetailState = wifiManager.getWifiDetailState();
      this.isBluetoothOpened = btState === access.BluetoothState.STATE_ON ||
        btState === access.BluetoothState.STATE_TURNING_ON;
      this.isWifiOpened = wifiState === 1 || wifiState === 2;
      log.showInfo(`bluetoothState: ${btState}, wifiState: ${wifiState}`);
      if (this.isWifiOpened && this.isBluetoothOpened && AppStorage.get<number>('castDialogCode') ===
      Constants.DIALOG_WIFI_BLUETOOTH) {
        // 如果蓝牙wifi弹窗显示，检测到此时蓝牙wifi已打开，需关闭蓝牙wifi窗口
        AppStorage.setOrCreate<number>('castDialogCode', Constants.DIALOG_DEFAULT);
        this.offWifiBluetooth();
        // 启动无线投屏二级页面
        this.startCastSearch();
      }
    } catch (err) {
      log.showError(`wifiBluetoothChanged Error:${err.code}, ${err.message}`);
    }
  }

  private offWifiBluetooth(): void {
    try {
      access.off('stateChange', () => {
        log.showInfo('access off stateChange');
      });
      wifiManager.off('wifiStateChange', () => {
        log.showInfo('wifi off stateChange');
      });
    } catch (error) {
      log.showError(`offWifiBluetooth Error: ${error.code}, ${error.message}`);
    }
  }

  private openWifiBluetooth(): void {
    if (!this.isBluetoothOpened) {
      try {
        access.enableBluetooth();
        log.showInfo('userConfirm: opened bluetooth');
      } catch (error) {
        log.showError(`enableBluetooth error: ${(error as BusinessError).code}, ${(error as BusinessError).message}`);
      }
    }
    if (!this.isWifiOpened) {
      try {
        wifiManager.enableWifi();
        log.showInfo('userConfirm: opened wifi');
      } catch (error) {
        log.showError(`enableWifi error: ${(error as BusinessError).code}, ${(error as BusinessError).message}`);
      }
    }
    this.startCastSearch();
  }

  public setPrivacyAgree(): void {
    log.showInfo('action: userConfirm');
    let context: Context = GlobalContext.getContext();
    if (!context) {
      log.showError('getShareStare error! context is undefined or null');
      return;
    }
    this.setSettingsValue(context, Constants.CAST_PRIVACY_VERSION, Constants.PRIVACY_VERSION_NEWEST);
    this.setSettingsValue(context, Constants.CONTROL_CENTER_RESHOW_PRIVACY, Constants.PRIVACY_VERSION_NEWEST);
    //Delete the last connected device.
    this.setSettingsValue(context, Constants.LAST_CONNECTED_DEV_ID, '');
    if (!this.checkWifiBluetooth()) {
      return;
    }
    this.startCastSearch();
  }

  private subscribeCastConnectState(): void {
    if (this.stateSubscriber) {
      log.showInfo('stateSubscriber is already subscribe');
      return;
    }
    // 订阅连接状态事件
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [Constants.PUBLISH_EVENT_CAST_CONNECTED, Constants.PUBLISH_EVENT_CAST_DISCONNECTED,
        Constants.PUBLISH_EVENT_DIALOG_SHOW, Constants.PUBLISH_EVENT_OPEN_SUB_WINDOW,
        Constants.PUBLISH_EVENT_CLOSE_SUB_WINDOW],
      publisherPermission: Constants.PUBLISH_PERMISSION_MIRROR
    };
    // 创建订阅者回调
    try {
      commonEventManager.createSubscriber(subscribeInfo, (err: BusinessError, data) => {
        if (err) {
          log.showError(`createSubscriber error. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        log.showInfo('createSubscriber Succeeded');
        this.stateSubscriber = data;
        // 订阅公共事件回调
        if (this.stateSubscriber) {
          this.subscribeConnectStatus();
          this.publishCommonEvent(Constants.PUBLISH_EVENT_GET_CONNECT_STATE);
        } else {
          log.showError('subscriber is undefined');
        }
      });
    } catch (error) {
      log.showError(`commonEventManager createSubscriber error: ${error?.code}, ${error?.message}`);
    }
  }

  private subscribeConnectStatus(): void {
    if (!this.stateSubscriber) {
      log.showWarn('subscribeConnectStatus subscriber is undefined, to create');
      this.subscribeCastConnectState();
      return;
    }
    try {
      commonEventManager.subscribe(this.stateSubscriber, (err: BusinessError, data) => {
        if (err) {
          log.showError(`subscribe error. Code is ${err.code}, message is ${err.message}`);
          return;
        }
        log.showInfo(`event: ${data.event}`);
        this.closeRetryConnect();
        if (data.event === Constants.PUBLISH_EVENT_CAST_CONNECTED) {
          this.changeConnectStatus(true);
        } else if (data.event === Constants.PUBLISH_EVENT_CAST_DISCONNECTED) {
          this.changeConnectStatus(false);
        } else if (data.event === Constants.PUBLISH_EVENT_CLOSE_SUB_WINDOW) {
          sToggleSubWindowController.hideWindow();
        } else if (data.event === Constants.PUBLISH_EVENT_OPEN_SUB_WINDOW) {
          this.phoneStartProjection();
        } else if (Constants.PUBLISH_EVENT_DIALOG_SHOW) {
          let dialogInfo: DialogInfo = data.parameters?.dialogInfo as DialogInfo;
          log.showInfo(`castDialogCode ${dialogInfo?.code}`);
          if (dialogInfo?.code && DropDownPanelManager.getDropDownEvent().target === TargetPanel.CONTROL_CENTER_PANEL) {
            sToggleSubWindowController.hideWindow();
            this.showErrorDialog(dialogInfo);
          }
        } else {
          log.showError(`uninvalid event. event is ${data.event}`);
        }
      });
    } catch (error) {
      log.showError(`commonEventManager subscribe error: ${error?.code}, ${error?.message}`);
    }
  }

  private showErrorDialog(dialogInfo: DialogInfo): void {
    let isAccessibilityMode: boolean | undefined = this.isAccessibilityMode();
    let delayTime: number = 0;
    if (isAccessibilityMode) {
      delayTime = ACCESSIBILITY_MODE_DELAY_TIME;
    }
    this.dialogHandlerId = setTimeout(() => {
      this.dialogHandlerId = -1;
      AppStorage.setOrCreate<DialogInfo>('dialogInfo', dialogInfo);
      AppStorage.setOrCreate<number>('castDialogCode', dialogInfo?.code);
      castReportUtils.reportUEFailDialogEvent(Constants.REPORT_DIALOG_SHOW, dialogInfo?.code);
    }, delayTime);
  }

  private isAccessibilityMode(): boolean | undefined {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return AppStorage.get('isAccessibilityMode');
    } else {
      return AccessibilityVm.instance.isEnabled;
    }
  }

  changeConnectStatus(isOpen: boolean): void {
    this.getViewData().isOn = isOpen;
    this.updateIcon();
    if (DeviceHelper.isPC()) {
      this.setStatusBarVisible(isOpen);
    }
  }

  private unSubscribe(): void {
    if (!this.stateSubscriber) {
      log.showWarn('unSubscribe but stateSubscriber is undefined');
      return;
    }
    try {
      commonEventManager.unsubscribe(this.stateSubscriber, (err: BusinessError) => {
        if (err) {
          log.showError(`unsubscribe failed, code is ${err.code}, message is ${err.message}`);
        } else {
          this.stateSubscriber = undefined;
          log.showInfo('unsubscribe success');
        }
      });
    } catch (error) {
      this.stateSubscriber = undefined;
      let err: BusinessError = error as BusinessError;
      log.showError(`unsubscribe failed, code is ${err.code}, message is ${err.message}`);
    }
  }

  setStatusBarVisible(isVisible: boolean): void {
    pluginComponentManager.push({
      owner: {
        bundleName: 'com.ohos.sceneboard'
      },
      target: {
        bundleName: 'com.ohos.ohcast'
      },
      name: 'components/pages/plugin/PluginPcIcon.js',
      data: {},
      extraData: {
        requestVisible: isVisible
      }
    }, () => {
      log.showInfo(`push complete isVisible: ${isVisible}`);
    });
  }

  updateDisableState(): void {
    if (this.isSatelliteMode || DeviceHelper.isEmulator()) {
      this.getViewData().isUnavailable = true;
      return;
    }
    this.getViewData().isUnavailable = false;
  }

  publishCommonEvent(event: string, data: number = 0) {
    log.showInfo(`publishCommonEvent ${event}`);
    try {
      commonEventManager.publish(event, {
        bundleName: Constants.CAST_BUNDLE_NAME,
        parameters: { type: data }
      }, (err: BusinessError) => {
        if (err) {
          log.showError(`publishCommonEvent error code: ${err.code}`);
        }
      });
    } catch (error) {
      log.showError(`publishCommonEvent publish error code: ${error.code}`);
    }
  }

  getSettingsValue(context: Context, key: string, defaultValue: string): string {
    try {
      return sSettingsUtil.getSecureValue(key, defaultValue, context);
    } catch (error) {
      log.showError(`getSettingsValue error code: ${error?.code}, message: ${error?.message}`);
      return defaultValue;
    }
  }

  setSettingsValue(context: Context, key: string, value: string): boolean {
    try {
      return sSettingsUtil.setSecureValue(key, value, context);
    } catch (error) {
      log.showError(`setSettingsValue error code: ${error?.code}, message: ${error?.message}`);
      return false;
    }
  }

  /**
   * Get the instance of the CastToggleController class
   */
  static getInstance(): CastToggleController {
    if (!CastToggleController.instance) {
      CastToggleController.instance = new CastToggleController();
    }
    return CastToggleController.instance;
  };
}