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

import locationManager from '@ohos.geoLocationManager';
import {
  CommonUtils,
  LogDomain,
  LogHelper,
  SingletonHelper,
  AppStorageUtil,
} from '@ohos/basicutils';
import {
  EvtBus,
  PluginRequestEvent,
  DeviceHelper,
  obtainStartAbilityWithWant,
  PluginSlot,
  GlobalContext,
  sSettingsUtil,
  AccountMgr,
  CapsuleVisibleEvent
} from '@ohos/frameworkwrapper';
import { ExtAppConstants } from '@ohos/commonconstants';
import { StatusBarAnimateLocationData } from '../common/Constants';
import Constants from '../common/Constants';
import taskpool from '@ohos.taskpool';
import dataShare from '@ohos.data.dataShare';
import type { BusinessError } from '@ohos.base';
/*import superPrivacyManager from '@ohos.security.superPrivacyManager';
import privacyIndicatorManager from '@hms.security.privacyIndicatorManager';*/
import { DropDownPanelManager, EdmAdminManager } from '@ohos/systemuicommon/Index';
import Prompt from '@ohos.promptAction';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { StatusBarExceptionCode } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarExceptionCode';
import { LogWithHa } from '@ohos/systemuicommon';
// instrument ignore file
const TAG = 'Model.LocationController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
// 定位从显示变为不显示时，延迟隐藏时间，默认5秒
const HIDE_DELAY_TIME: number = 5000;
// 定位图标显示类型 1普通 2高清
const SHOW_TYPE_NORMAL = 1;
const SHOW_TYPE_HD = 2;
// 无效用户id
const INVALID_USER_ID: number = -1;
// 常规用户id
const NORMAL_USER_ID: number = 100;
// 用户设置数据Uri前缀
const URI_BASE: string = 'datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_';
// 用户设置数据中定位状态的key
const LOCATION_SET_KEY: string = 'location_working_state';
// 当前定位状态的数据项名称
const LOCATION_WORKING_STATE: string = 'location_working_state';
// 当前定位状态的默认值
const LOCATION_WORKING_STATE_DEFAULT: string = '0';
const sceneBoardProcesssName = 'com.ohos.sceneboard';
const PERSIST_EDM_LOCATION_CONFIG = 'persist.edm.location_policy';

@Observed
export class LocationData {
  public showType: number = 0;
  public isShow: boolean = false;
  public isSuperPrivacyMode: boolean = false;
  public isSuperPrivacyModeOnWhenFolded: boolean = false;
}

export class LocationController extends ToggleBaseViewModel {
  private mLocationData: LocationData = new LocationData();
  private mStatusBarAnimateLocationData: StatusBarAnimateLocationData = new StatusBarAnimateLocationData();

  private isWaitingToHide: boolean = false;
  private delayHideTimerId: number = 0;
  private isWaitingLastActionDone: boolean = false;
  private mdName: string | undefined = DeviceHelper.isPC() ? undefined : 'phone_settings';
  private dataShareHelper: dataShare.DataShareHelper | undefined = undefined;
  private showType: number = 0;
  private locationUri: string = '';

  constructor() {
    super();
    this.getViewData().label = $r('app.string.control_center_complex_toggle_location_title');
    this.getViewData().isSymbolIcon = true;
    this.getViewData().icon = $r('sys.symbol.local');
    this.onStart();
    this.initLocationPrivacyState();
    this.registerPrivacyStateChangeListener();
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): LocationController {
    return SingletonHelper.getInstance(LocationController, TAG);
  }

  getLottieOpenName(): string {
    return Constants.LOTTIE_DATA_OPEN;
  }

  getLottieCloseName(): string {
    return Constants.LOTTIE_DATA_CLOSE;
  }

  getLottieDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  getLottieOpenDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getLottieCloseDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  getNewLottieCloseName(): string {
    return Constants.NEW_LOTTIE_DATA_CLOSE;
  }

  getNewLottieOpenName(): string {
    return Constants.NEW_LOTTIE_DATA_OPEN;
  }

  isLoadLottie(): boolean {
    return true;
  }

  isDarkReverse(): boolean {
    return true;
  }

  /**
   * 是否需要监听卫星通信状态
   */
  needListenSatelliteMode(): boolean {
    return true;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    if (!this.isAvailable()) {
      log.showError('current device is not support location');
      return;
    }
    this.updateDisableState();
    this.initLocationState();

    try {
      locationManager.on('locationEnabledChange', (state) => {
        this.onLocationStateChange(state);
      });
      // superPrivacyManager.on('superPrivacyModeChange', this.onSuperPrivacyModeChange);
    } catch (error) {
      LogWithHa.error(log, `locationManager register enable state error`,
        StatusBarExceptionCode.LOCATION_FAIL, error, TAG);
    }

    this.initLocationListener();

    //初始化校验状态是否关闭，隐藏位置图标
    if (this.getStatusBarLocationIconIsVisible() !== true) {
      // 发送事件，触发PluginRootComponent组件中的状态更新，进而统一控制整个图标的显示与隐藏。
      this.sbPluginRequest.setIsVisible(false);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }

  initLocationState(): void {
    try {
      let state: boolean = locationManager.isLocationEnabled();
      this.onLocationStateChange(state);
    } catch (error) {
      LogWithHa.error(log, `init location state error`,
        StatusBarExceptionCode.LOCATION_FAIL, error, TAG);
    }
  }

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    if (!this.isAvailable()) {
      log.showError('current device is not support location');
      return;
    }

    try {
      locationManager.off('locationEnabledChange');
      // superPrivacyManager.off('superPrivacyModeChange', this.onSuperPrivacyModeChange);
    } catch (error) {
      LogWithHa.error(log, `locationManager unregister enable state error`,
        StatusBarExceptionCode.LOCATION_FAIL, error, TAG);
    }

    try {
      this.dataShareHelper?.off('dataChange', this.locationUri);
      log.showInfo('unregister location data share listener success');
    } catch (err) {
      LogWithHa.error(log, `unregister location data share listener error: ${err?.message}`,
        StatusBarExceptionCode.LOCATION_FAIL, err, TAG);
      log.showError(`unregister location data share listener error: ${err?.message}`);
    }

    if (this.delayHideTimerId) {
      clearTimeout(this.delayHideTimerId);
      this.delayHideTimerId = 0;
    }
    this.isWaitingToHide = false;
  }

  /**
   * 获取用户定位设置Uri
   */
  private async getUri(): Promise<string> {
    let userId = await AccountMgr.getCurrentAccountId();
    log.showInfo(`getUri userId: ${userId}, key: ${LOCATION_SET_KEY}`);
    if (!CommonUtils.isNumber(userId) || userId === INVALID_USER_ID) {
      log.showWarn('userId is invaild, use NORMAL_USER_ID instead');
      userId = NORMAL_USER_ID;
    }
    return URI_BASE + userId + '?Proxy=true&key=' + LOCATION_SET_KEY;
  }

  /**
   * 状态栏定位图标设置项监听初始化
   */
  private async initLocationListener(): Promise<void> {
    let context = GlobalContext.getContext();
    this.locationUri = await this.getUri();
    try {
      dataShare.createDataShareHelper(context, this.locationUri,
        (err:BusinessError, data:dataShare.DataShareHelper) => {
        if (err !== undefined) {
          LogWithHa.error(log, `CreateDataShareHelper error code: ${err?.code}, message: ${err?.message}`,
            StatusBarExceptionCode.LOCATION_FAIL, err, TAG);
          return;
        }
        log.showInfo('CreateDataShareHelper success');
        this.dataShareHelper = data;
        this.dataShareHelper?.on('dataChange', this.locationUri, () => {
          log.showDebug('Location dataChange');
          onLocationSetChange();
        });
      });
    } catch (err) {
      LogWithHa.error(log, `CreateDataShareHelper error code: ${err?.code}, message: ${err?.message}`,
        StatusBarExceptionCode.LOCATION_FAIL, err, TAG);
    }
    const onLocationSetChange = (): void => {
      let stateValue: string = sSettingsUtil.getSystemValue(LOCATION_WORKING_STATE, LOCATION_WORKING_STATE_DEFAULT);
      if (CommonUtils.isEmpty(stateValue)) {
        LogWithHa.error(log, `onLocationSetChange stateValue is invalid or empty`,
          StatusBarExceptionCode.LOCATION_FAIL);
      } else {
        log.showInfo(`Location set changed to --> ${stateValue}`);
        this.showType = parseInt(stateValue);
        this.handleLocationSetChange();
      }
    };
    onLocationSetChange();
  }

  /**
   * 处理定位图标设置项变化
   */
  private handleLocationSetChange(): void {
    let beforeIsShow: boolean = this.mLocationData.isShow ?? false;
    let afterIsShow: boolean = (this.showType === SHOW_TYPE_NORMAL || this.showType === SHOW_TYPE_HD) ?? false;
    log.showInfo(`handleLocationSetChange, beforeIsShow: ${beforeIsShow}, afterIsShow: ${afterIsShow}`);
    if (beforeIsShow && !afterIsShow) {
      // 原本定位图标为显示, 现在定位设置变为不显示，开始倒计时
      log.showInfo('before is show, changed to hide, start delay counting');
      this.setDelayHide();
    } else if (beforeIsShow && afterIsShow && this.isWaitingToHide) {
      // 原本定位图标为显示，当前处于等待倒计时结束状态，但定位设置又变为显示，清除倒计时
      log.showInfo('before is show, is waiting to hide but changed to show, clear delay');
      this.clearDelayHide();
    } else {
      // 其它情况，直接更新显示状态
      log.showDebug('other scene, update show state');
      this.handleUpdateState();
      log.showError(`SBS=> ${this.mLocationData.isSuperPrivacyMode} - ${this.getViewData().isOn} - ${this.mStatusBarAnimateLocationData.isShow}`);
      this.handleStatusBarState();
    }
  }

  /**
   * 状态栏定位图标延迟隐藏定时器设定
   */
  private setDelayHide(): void {
    this.isWaitingToHide = true;
    this.delayHideTimerId = setTimeout(() => {
      log.showInfo(`Location icon show changed to hide, delay ${HIDE_DELAY_TIME} ms end, hide start`);
      this.isWaitingToHide = false;
      this.handleUpdateState();
      this.handleStatusBarState();
    }, HIDE_DELAY_TIME);
  }

  /**
   * 状态栏定位图标延迟隐藏定时器取消
   */
  private clearDelayHide(): void {
    this.isWaitingToHide = false;
    clearTimeout(this.delayHideTimerId);
    this.handleUpdateState();
    this.handleStatusBarState();
  }

  private onLocationStateChange(state: boolean): void {
    log.showWarn(`onLocationStateChange new ${state} , old: ${this.getViewData().isOn}`);
    this.handleStatusBarState();
    if (this.isWaitingLastActionDone) {
      this.isWaitingLastActionDone = false;
      if (state !== this.getViewData().isOn) {
        this.switchLocationState(this.getViewData().isOn);
      }
      log.showInfo('onLocationStateChange isWaitingLastActionDone return');
      return;
    }
    this.handleUpdateState();
  }

  private onSuperPrivacyModeChange = (mode: ESObject): void => {
    log.showWarn('onSuperPrivacyModeChange. current mode: ' + mode);
    this.updateSuperPrivacyStatus(mode);
    this.handleStatusBarState();
    this.updateDisableState();
  };

  private updateSuperPrivacyStatus(mode: ESObject): void {
    // switch (mode) {
    //   case superPrivacyManager.SuperPrivacyMode.OFF:
    //     this.mLocationData.isSuperPrivacyMode = false;
    //     this.mLocationData.isSuperPrivacyModeOnWhenFolded = false;
    //     break;
    //   case superPrivacyManager.SuperPrivacyMode.ON_WHEN_FOLDED:
    //     this.mLocationData.isSuperPrivacyMode = true;
        this.mLocationData.isSuperPrivacyModeOnWhenFolded = true;
        // break;
    //   case superPrivacyManager.SuperPrivacyMode.ALWAYS_ON:
    //     this.mLocationData.isSuperPrivacyMode = true;
    //     this.mLocationData.isSuperPrivacyModeOnWhenFolded = false;
    //     break;
    //   default:
    //     this.mLocationData.isSuperPrivacyMode = false;
    //     this.mLocationData.isSuperPrivacyModeOnWhenFolded = false;
    //     break;
    // }
  }

  private ObtainCurrentLocationSwitchStatus(): boolean | undefined {
    let isEnable: boolean | undefined;
    try {
      isEnable = locationManager.isLocationEnabled();
    } catch (e) {
      const error = e as BusinessError;
      LogWithHa.error(log, `Obtain current location switch status error, code: ${error?.code}, message: ${error?.message}.`,
        StatusBarExceptionCode.LOCATION_FAIL, e, TAG);
    }
    return isEnable;
  }

  public getStatusBarLocationIconIsVisible(): boolean | undefined {
    const isLocationSwitchEnable: boolean | undefined = this.ObtainCurrentLocationSwitchStatus();
    if (isLocationSwitchEnable === undefined) {
      log.showError(`obtain current location switch status fail.`);
      return undefined;
    }
    /* 定位开关打开且有应用使用定位，则展示定位图标 */
    return isLocationSwitchEnable && this.mStatusBarAnimateLocationData.isShow;
  }

  private handleStatusBarState(state?: boolean): void {
    let newState: boolean | undefined = state ?? this.getStatusBarLocationIconIsVisible();
    if (newState === undefined) {
      log.showError(`get new status bar location icon visiblle flag fail.`);
      return;
    }
    let oldState = this.sbPluginRequest.isVisible();
    log.showInfo(`status bar status change, newState: ${newState}, oldState: ${oldState}`);
    if (oldState !== newState) {
      // 发送事件，触发PluginRootComponent组件中的状态更新，进而统一控制整个图标的显示与隐藏。
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);

      // 胶囊事件
      EvtBus.post(CapsuleVisibleEvent, {
        pluginSlot: this.getSbPluginSlot(),
        visible: newState
      } as CapsuleVisibleEvent);
    }
  }

  /**
   * 位置图标标示
   */
  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_LOCATION;
  }

  addStateChangedListener(): void {
  }

  removeStateChangedListener(): void {
  }

  handleUpdateState(): void {
    try {
      let isEnable = locationManager.isLocationEnabled();
      let isShow: boolean = (this.showType === SHOW_TYPE_NORMAL || this.showType === SHOW_TYPE_HD) ?? false;
      this.getViewData().isOn = isEnable;
      this.mLocationData.isShow = isShow;
      this.mLocationData.showType = this.showType;
      log.showInfo(`handleUpdateState, this.getViewData().isOn ${this.getViewData().isOn} isEnable:${isEnable}, isShow:${isShow}, showType:${this.showType}`);
    } catch (error) {
      LogWithHa.error(log, `handleUpdateState error`, StatusBarExceptionCode.LOCATION_FAIL, error, TAG);
    }
  }

  getData(): LocationData {
    return this.mLocationData;
  }

  isAvailable(): boolean {
    return canIUse('SystemCapability.Location.Location.Core');
  }

  handleOneClick(): void {
    log.showInfo(`handleClick, status: ${this.getViewData()?.isOn}, waiting: ${this.isWaitingLastActionDone}`);
    if (this.getViewData().isUnavailable) {
      if (this.mLocationData.isSuperPrivacyMode) {
        this.locationShowToast();
      } else if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_LOCATION_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      log.showInfo('click disabled');
      return;
    }
    this.handleClickWithScreenLock((): void => this.updateLocationData());
    try {
      if (!locationManager.isLocationPrivacyConfirmed(locationManager.LocationPrivacyType.STARTUP)) {
        log.showInfo('location privacy confirmed');
        DropDownPanelManager.animToDismissEvent();
      }
    } catch (error) {
      LogWithHa.error(log, `location privacy confirmed failed`, StatusBarExceptionCode.LOCATION_FAIL, error, TAG);
    }
  }

  private locationShowToast(): void {
    Prompt.showToast({
      message: $r('app.string.control_center_super_privacy_for_location_toggle'),
      showMode: Prompt.ToastShowMode.SYSTEM_TOP_MOST
    });
  }

  private goSettings(): void {
    EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
      bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
      uri: 'location_manager_settings',
      moduleName: this.mdName
    }));
  }

  private updateLocationData(): void {
    log.showInfo(`updateLocationData, old status: ${this.getViewData()?.isUnavailable}`);
    this.getViewData().isOn = !this.getViewData().isOn;
    if (!this.isWaitingLastActionDone) {
      log.showInfo(`switchLocationState to new status: ${this.getViewData()?.isUnavailable}`);

      // 如果是关闭位置服务，直接发出事件通知父组件隐藏，避免位置图标和其父组件隐藏时间不一致，导致卡顿。
      // 相关逻辑：setDelayHide()
      if (!this.getViewData().isOn) {
        this.handleStatusBarState(false);
      }

      this.isWaitingLastActionDone = true;
      this.switchLocationState(this.getViewData().isOn);
    }
  }

  private switchLocationState(isOn: boolean): void {
    if (isOn) {
      try {
        locationManager.enableLocation().catch((result: Object) => {
          log.showError(`switchLocation result: ${result}`);
          this.resetLocationState(false);
        });
      } catch (err) {
        LogWithHa.error(log, `enable location failed`, StatusBarExceptionCode.LOCATION_FAIL, err, TAG);
        this.resetLocationState(false);
      }
      return;
    }
    taskpool.execute(switchLocation, isOn).then((result: Object) => {
      log.showInfo(`switchLocation result: ${result}`);
      if (result as number !== 0) {
        this.resetLocationState(false);
      }
    }).catch((error: Error) => {
      LogWithHa.error(log, `switchLocation error`, StatusBarExceptionCode.LOCATION_FAIL, error, TAG);
    });
  }

  private resetLocationState(state: boolean) {
    log.showWarn('switchLocation fail, set to false');
    this.isWaitingLastActionDone = false;
    this.onLocationStateChange(state);
  }

  updateDisableState(): void {
    if (this.isSatelliteMode || !EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_LOCATION_CONFIG)) {
      this.getViewData().isUnavailable = true;
    } else {
      this.getViewData().isUnavailable =
        this.mLocationData.isSuperPrivacyMode && (!this.mLocationData.isSuperPrivacyModeOnWhenFolded ||
          (DeviceHelper.isSubDisplayMode() && this.mLocationData.isSuperPrivacyModeOnWhenFolded));
    }
    log.showInfo(`updateDisableState mLocationData.isUnavailable: ${this.getViewData().isUnavailable}`);
  }

  /**
   *  注册监听位置信息
   */
  private registerPrivacyStateChangeListener(): void {
    log.showInfo('registerLocationPrivacyStateChangeListener');
    try {
      /*privacyIndicatorManager.on('sensorStateChange', (data) => {
        this.processPrivacyRemindInfos(data);
      });*/
    } catch (e) {
      LogWithHa.error(log, `registerLocationPrivacyStateChangeListener error`,
        StatusBarExceptionCode.LOCATION_FAIL, e, TAG);
    }
  }

  private async processPrivacyRemindInfos(data: ESObject[]): Promise<void> {
    data.forEach(async (info:ESObject) => {
      this.processInfo(info);
    });
  }

  /**
   * aidataservice服务使用位置时间不确定，如果在状态栏注册之前使用会导致状态栏一直收不到回调
   * 在注册之前获取当前是否有应用调用位置
   */
  public async initLocationPrivacyState(): Promise<void> {
    log.showInfo('initLocationPrivacyState');
    try {
      // const userId = await AccountMgr.getCurrentAccountId();
      // const usedLocationDetails =
      //   await privacyIndicatorManager.getPrivacyEventDetailsByPrivacySensorType(
      //     privacyIndicatorManager.PrivacySensorType.LOCATION,
      //     userId);
      // const findUsedLocationDetail =
      //   usedLocationDetails.find(usedLocationDetailsElement => usedLocationDetailsElement.showAccessState ===
      //   privacyIndicatorManager.AccessState.ACCESSING);
      // if (findUsedLocationDetail !== undefined) {
      //   log.showInfo(`${findUsedLocationDetail.bundleName} has used location`);
        this.mStatusBarAnimateLocationData.isShow = true;
        this.mStatusBarAnimateLocationData.isReOpen = false;
        AppStorageUtil.setOrCreate<StatusBarAnimateLocationData>('statusBarAnimateLocationDataKey',
          this.mStatusBarAnimateLocationData);
        this.handleStatusBarState();
        return;
      // }
      log.showInfo(`no bundle using location`);
      this.handleStatusBarState(false);
    } catch (e) {
      LogWithHa.error(log, `initLocationPrivacyState error`, StatusBarExceptionCode.LOCATION_FAIL, e, TAG);
    }
  }

  private processInfo(info: ESObject): void {
    /*if (info.privacySensorType === privacyIndicatorManager.PrivacySensorType.LOCATION) {
      log.showInfo(`bundle:${info?.bundleName},type: ${info?.privacySensorType},state:${info?.accessState},remindFlags:${info?.remindFlags}`);
      // 监听到权限关闭
      if (info.accessState === privacyIndicatorManager.AccessState.ACCESSED) {
        log.showInfo(`registerLocationPrivacyStateChangeListener, close location`);
        this.mStatusBarAnimateLocationData.isShow = false;
        this.mStatusBarAnimateLocationData.isReOpen = false;
      }
      // 监听到权限调用
      if (info.accessState === privacyIndicatorManager.AccessState.ACCESSING) {
        log.showInfo(`registerLocationPrivacyStateChangeListener, open location, isReOpen is ${controlIsTrue(info.remindFlags, 1)}`);
        this.mStatusBarAnimateLocationData.isShow = true;
        this.mStatusBarAnimateLocationData.isReOpen = controlIsTrue(info.remindFlags, 1);
      }
      AppStorageUtil.setOrCreate<StatusBarAnimateLocationData>('statusBarAnimateLocationDataKey', this.mStatusBarAnimateLocationData);
      this.handleStatusBarState();
    }*/
  }
}

function switchLocation(isOn: boolean): number {
  'use concurrent';
  try {
    if (isOn) {
      locationManager.enableLocation().catch((err:Error)=>{
          console.log('xzl-err:'+err)
      })
    } else {
      locationManager.disableLocation();
    }
    return 0;
  } catch (err) {
    return err?.code;
  }
}

/**
 * 检查在多个控制位中某个控制位是否为true
 *
 * @param control 多个控制位组成的一串数字
 * @param flag 需要检查的控制位
 * @returns 控制位是否为true
 */
function controlIsTrue(control: number, flag: number): boolean {
  return (control & flag) === flag;
}
