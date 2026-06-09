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

import { AppStorageUtil, LogDomain, LogHelper } from '@ohos/basicutils';
import { AccountMgr, DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { RTLUtil } from '@ohos/componenthelper';
// import privacyIndicatorManager from '@hms.security.privacyIndicatorManager';
import DeviceInfo from '@ohos.deviceInfo';
import componentUtils from '@ohos.arkui.componentUtils';
import { COMPONENT_ID_BATTERY_BORDER, COMPONENT_ID_BATTERY_ICON } from './constants';
import display from '@ohos.display';
import CommonEventManager from '@ohos.commonEventManager';
import { BusinessError, Callback } from '@ohos.base';
import { StatusBarExceptionCode } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarExceptionCode';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { DisplayAdapter, IDisplayAdapterInfo } from '@ohos/systemuicommon/src/main/ets/adapter/DisplayAdapter';
import { LogWithHa } from '@ohos/systemuicommon';
import { SingleHandModeChangeEvent } from '@ohos/systemuicommon/Index';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

// instrument ignore file
const TAG = 'PrivacyIndicatorModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const groupHeight = ResUtils.getNumberFromLength($r('app.float.plugin_phone_icon_height'));

const sceneBoardProcesssName = 'com.ohos.sceneboard';
export const productSeries: string = DeviceInfo.productSeries;

/**
 * 圆点尺寸接口
 */
export interface CircleSize {
  sizeFromBatterRight: number,
  width: number
}

/**
 * 根据设备定制化圆点尺寸 ,单位vp
 */
export function getCircleSize(): CircleSize {
  if (productSeries.includes('DCO') || productSeries.includes('LYA') || productSeries.includes('ALT')) {
    return { sizeFromBatterRight: 0, width: 4 };
  } else if (productSeries.includes('XYAO')) {
    return { sizeFromBatterRight: 1, width: 5 };
  } else {
    return { sizeFromBatterRight: 0, width: 5 };
  }
}

export const circleSize = getCircleSize();

/**
 * 电池动效属于相机还是麦克风
 */
export enum BatteryStage {
  // 无动效阶段
  initStage = 0,
  // 相机动效阶段
  cameraStage = 1,
  // 麦克风动效阶段
  microphoneStage = 2,
  // 相机关闭
  cameraClose = 3,
  // 麦克风关闭
  microphoneClose = 4,
}

/**
 * 检查在多个控制位中某个控制位是否为true
 *
 * @param control 多个控制位组成的一串数字
 * @param flag 需要检查的控制位
 * @returns 控制位是否为true
 */
export function controlIsTrue(control: number, flag: number): boolean {
  return (control & flag) === flag;
}


type ViewModelCallBack = (type: BatteryStage) => void;

/**
 * 隐私指示器麦克风、相机数据层
 */
export class PrivacyIndicatorViewModel {
  /**
   *   同步相机或麦克风调用动效阶段的回调函数
   */
  private mCallback: ViewModelCallBack | null = null;
  private statusBarPaddingRight: number = 0;
  private statusBarPaddingTop: string = '0';
  private turnOnIndicatorPosition: Array<number> = [];
  private isFolded: boolean = false;
  private singleHandMode: number = 0;
  private singleHandScale: number = 1;
  private singleHandX: number = -1;
  private singleHandY: number = -1;
  private singleHandW: number = -1;
  private singleHandH: number = -1;
  private privacyCallback: Callback<Array<ESObject>> =
    (data: Array<ESObject>): void => {
      this.processPrivacyRemindInfos(data);
    };
  public fakeLightIsShow: boolean = false;
  public setStatusBarPaddingRight(statusBarPaddingRight: number): void {
    this.statusBarPaddingRight = statusBarPaddingRight;
    log.showInfo(`this.statusBarPaddingRight is ${this.statusBarPaddingRight}`);
  }

  public setStatusBarPaddingTop(statusBarPaddingTop: string): void {
    this.statusBarPaddingTop = statusBarPaddingTop;
    log.showInfo(`this.statusBarPaddingTop is ${this.statusBarPaddingTop}`);
  }

  /**
   * 监听的权限列表
   */
  private needListenType: Array<ESObject> = [];
    // [privacyIndicatorManager.PrivacySensorType.CAMERA, privacyIndicatorManager.PrivacySensorType.MICROPHONE];

  /**
   * 账号SA启动事件subscriber
   */
  private subscriber: CommonEventManager.CommonEventSubscriber | null = null;

  /**
   *  注册监听相机和麦克风权限变化
   */
  public registerPrivacyStateChangeListener(): void {
    try {
      log.showInfo('registerPrivacyStateChangeListener');
      this.subscribeUserSwitched();
      // privacyIndicatorManager.on('sensorStateChange', this.privacyCallback);
    } catch (e) {
      log.showError('registerPrivacyStateChangeListener error');
    }
  }

  private processPrivacyRemindInfos(data: ESObject[]): void {
    data.forEach(async (privacyEventRemindInfo: ESObject) => {
      if (this.needListenType.includes(privacyEventRemindInfo.privacySensorType)) {
        log.showInfo(`bundleName:${privacyEventRemindInfo.bundleName}, privacySensorType: ${privacyEventRemindInfo.privacySensorType}, accessState: ${privacyEventRemindInfo.accessState}, remindFlags: ${privacyEventRemindInfo.remindFlags}`);
        this.processPrivacyRemindInfo(privacyEventRemindInfo);
      }
    });
  }

  private processPrivacyRemindInfo(privacyEventRemindInfo: ESObject): void {
    if (this.needListenType.includes(privacyEventRemindInfo.privacySensorType)) {
      // 监听到权限关闭
      /*if (privacyEventRemindInfo.accessState === privacyIndicatorManager.AccessState.ACCESSED) {
        log.showInfo(`close light:${privacyEventRemindInfo.privacySensorType}`);
        this.mCallback?.(privacyEventRemindInfo.privacySensorType ===
        privacyIndicatorManager.PrivacySensorType.CAMERA ? BatteryStage.cameraClose : BatteryStage.microphoneClose);
      }*/
      // 检测到麦克风或者相机调用权限
      /*if (privacyEventRemindInfo.accessState === privacyIndicatorManager.AccessState.ACCESSING) {
        // 如果5秒内重新打开应用，简单动效直接开灯
        if (controlIsTrue(privacyEventRemindInfo.remindFlags, 1)) {
          log.showInfo(`five seconds reopen,only open light`);
          this.turnOnIndicator(privacyEventRemindInfo.privacySensorType, 1);
          this.processReOpenCache(privacyEventRemindInfo);
        } else {
          log.showInfo(`privacySensorType ${privacyEventRemindInfo.privacySensorType} animate start`);
          this.mCallback?.(privacyEventRemindInfo.privacySensorType ===
          privacyIndicatorManager.PrivacySensorType.CAMERA ? BatteryStage.cameraStage : BatteryStage.microphoneStage);
        }
      }*/
    }
  }

  private processReOpenCache(privacyEventRemindInfo: ESObject): void {
    /*if (privacyEventRemindInfo.privacySensorType === privacyIndicatorManager.PrivacySensorType.CAMERA) {
      log.showInfo(`CameraLight reOpen`);
      AppStorageUtil.setOrCreate<boolean>('cacheCameraLightStatus', true);
    } else {
      AppStorageUtil.setOrCreate<boolean>('cacheMicroPhoneLightStatus', true);
      log.showInfo(`MicroPhoneLight reOpen`);
    }*/
  }

  /**
   *  取消注册
   */
  public unregisterPrivacyStateChangeListener(): void {
    try {
      log.showInfo('unregisterPrivacyStateChangeListener');
      // privacyIndicatorManager.off('sensorStateChange', this.privacyCallback);
      this.unsubscribe();
    } catch (e) {
      log.showError('unregisterPrivacyStateChangeListener error');
    }
  }

  /**
   * 获取当前使用的隐私权限列表,仅限麦克风和相机
   */
  public async getActivePrivacyIndicator(): Promise<ESObject[]> {
    /*return (await privacyIndicatorManager.getActiveIndicators())
      .filter((privacyEventRemindInfo: privacyIndicatorManager.Indicator) =>
        this.needListenType.includes(privacyEventRemindInfo.privacySensorType))
      .map((indicator: privacyIndicatorManager.Indicator): privacyIndicatorManager.PrivacySensorType =>
        indicator.privacySensorType);*/
    return [];
  }

  public setCallback(callback: ViewModelCallBack): void {
    this.mCallback = callback;
  }

  /**
   * 开灯
   */
  public turnOnIndicator(privacySensorType: ESObject, animationType: number,
    checkFakeLight: boolean = true): Promise<void> {
    if (checkFakeLight && this.fakeLightIsShow) {
      log.showInfo(`fakeLightIsShow ${this.fakeLightIsShow}`);
      return Promise.resolve();
    }
    let pos:ESObject = this.getLightPosition();
    let foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
    try {
      foldStatus = display.getFoldStatus();
    } catch (error) {
      log.showError(`privacyIndicatorManager get display.getFoldStatus failed, error: ${error}`);
    }
    let position: number[] = [pos.positionX, pos.positionY];
    this.turnOnIndicatorPosition = position;
    log.showInfo(`${privacySensorType} turnOnIndicator finished, positionX: ${pos.positionX}, positionY: ${pos.positionY}, ` +
      `turnOnIndicatorPosition: ${this.turnOnIndicatorPosition} singleHandScale: ${this.singleHandScale} singleHandMode: ${this.singleHandMode}` +
      `singleHandX: ${this.singleHandX}, singleHandX: ${this.singleHandY}, singleHandW: ${this.singleHandW}, singleHandH ${this.singleHandH}`);
    try {
      /*return privacyIndicatorManager.turnOnIndicator(privacySensorType, animationType, {
        positionX: pos.positionX,
        positionY: pos.positionY,
        screenWidth: pos.screenWidth,
        screenHeight: pos.screenHeight,
        screenRotation: pos.screenRotation,
        singleHandScale: this.singleHandScale,
        singleHandMode: this.singleHandMode,
        screenFoldStatus: foldStatus,
        singleHandOriginX: this.singleHandX,
        singleHandOriginY: this.singleHandY,
        singleHandWidth: this.singleHandW,
        singleHandHeight: this.singleHandH
      }, { width: ArkUIAdapter.vp2px(circleSize.width),
        height: ArkUIAdapter.vp2px(circleSize.width), singleHandScale: this.singleHandScale});*/
      return new Promise(()=>{});
    } catch (err) {
      LogWithHa.error(log, `turnOnIndicator ${privacySensorType} error`,
        StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, err, TAG);
      return Promise.resolve();
    }

  }

  /**
   * 更新单手模式信息
   */
  public updateSingleHandModeInfo(event: SingleHandModeChangeEvent): void {
    this.singleHandScale = event.scale;
    this.singleHandX = event.singleHandX;
    this.singleHandY = event.singleHandY;
    this.singleHandW = event.singleHandW;
    this.singleHandH = event.singleHandH;
    switch (event.mode) {
      case 'left':
        this.singleHandMode = 0;
        break;
      case 'right':
        this.singleHandMode = 1;
        break;
      default:
        this.singleHandMode = 0;
    }
  }

  /**
   * 判断最近一次调用安全隐私传递的开灯位置与当前位置是否一致
   */
  public isSameLightPosition(): boolean {
    if (this.turnOnIndicatorPosition.length <= 0) {
      return true;
    }
    let pos:ESObject = this.getLightPosition();
    let position: number[] = [pos.positionX, pos.positionY];
    return (this.turnOnIndicatorPosition.toString() !== position.toString());
  }

  /**
   * 计算灯中心位置
   */
  public getLightPosition(): ESObject {
    const displayClass = DisplayAdapter.getDefaultDisplaySync();
    log.showInfo(`width is ${displayClass.width},this.statusBarPaddingRight is ${this.statusBarPaddingRight}, ${displayClass.densityDPI}`);
    const paddingTop = ResUtils.getNumberFromLength(this.statusBarPaddingTop);
    let statusbarHeight = ResUtils.getNumberFromLength($r('app.float.status_bar_phone_height'));
    log.showInfo(`paddingTop now is ${paddingTop}, groupHeight is ${groupHeight}, statusbarheight is ${statusbarHeight}, statusBarPaddingRight is ${this.statusBarPaddingRight}`);
    return {
      positionX: (RTLUtil.isRTL() ?
        ArkUIAdapter.vp2px(this.statusBarPaddingRight) - ArkUIAdapter.vp2px(circleSize.sizeFromBatterRight) -
        ArkUIAdapter.vp2px(circleSize.width / 2) :
        displayClass.width - ArkUIAdapter.vp2px(this.statusBarPaddingRight) +
        ArkUIAdapter.vp2px(circleSize.sizeFromBatterRight) +
        ArkUIAdapter.vp2px(circleSize.width / 2)) ??
      this.calculatePosition(displayClass).positionX,
      positionY: this.calculatePositionY() ?? this.calculatePosition(displayClass).positionY,
      screenWidth: displayClass.width,
      screenHeight: displayClass.height,
      screenRotation: displayClass.rotation
    };
  }

  private calculatePositionY(): number {
    let statusbarHeight = ResUtils.getNumberFromLength($r('app.float.status_bar_phone_height'));
    const paddingTop = ResUtils.getNumberFromLength(this.statusBarPaddingTop);
    let positionY = 0;
    if (SystemUICcmConfig.instance.isEnabledLive2) {
      positionY = ArkUIAdapter.vp2px(paddingTop + groupHeight / 2);
    } else {
      positionY = ArkUIAdapter.vp2px(paddingTop + groupHeight / 2 + (statusbarHeight - groupHeight) / 2);
    }
    log.showInfo(`paddingTop: ${paddingTop}, statusbarHeight: ${statusbarHeight}, groupHeight: ${groupHeight}, positionY: ${positionY}`);
    return positionY;
  }

  private calculatePosition(displayClass: IDisplayAdapterInfo): ESObject {
    const oUiContext = getUiContext(COMPONENT_ID_BATTERY_ICON);
    let result: ESObject = {
      positionX: 0,
      positionY: 0,
      screenWidth: displayClass.width,
      screenHeight: displayClass.height,
      screenRotation: displayClass.rotation,
    };
    if (oUiContext === undefined) {
      log.showWarn(`calculatePosition UiContext is undefined!!`);
    } else {
      log.showInfo(`circle info sizeFromBatterRight: ${circleSize.sizeFromBatterRight}, width: ${circleSize.width}`);
      const circleSizeValue = ArkUIAdapter.vp2px(circleSize.sizeFromBatterRight + circleSize.width / 2);
      result.positionX = oUiContext.screenOffset.x + oUiContext.size.width + circleSizeValue;
      result.positionY = oUiContext.screenOffset.y + oUiContext.size.height / 2;
      log.showInfo(`battery caculate positionX: ${result.positionX},positionY: ${result.positionY}`);
    }
    return result;
  }

  /**
   * 图片偏移到开灯位置的距离
   */
  public getCircleTranslate(): number {
    const oUiContext = getUiContext(COMPONENT_ID_BATTERY_BORDER);
    let circleTranslate: number = 0;
    if (oUiContext === undefined) {
      log.showWarn(`getCircleTranslate oUiContext is undefined `);
      circleTranslate = 0;
    } else {
      log.showInfo(`getCircleTranslate oUiContext `);
      if (RTLUtil.isRTL()) {
        circleTranslate = oUiContext.screenOffset.x - this.getLightPosition().positionX + oUiContext.size.width / 2;
      } else {
        circleTranslate = this.getLightPosition().positionX - oUiContext.screenOffset.x - oUiContext.size.width / 2;
      }
    }
    return ArkUIAdapter.px2vp(circleTranslate);
  }

  public async getPrivacyStateByType(privacySensorType: ESObject):
  Promise<boolean | undefined> {
    log.showInfo(`getPrivacyStateByType ${privacySensorType}`);
    try {
      const userId = await AccountMgr.getCurrentAccountId();
      const findPrivacyDetailsElement: ESObject | undefined = {};
      /*(await privacyIndicatorManager.getPrivacyEventDetails(userId))
        .find((usedPrivacyDetailsElement: privacyIndicatorManager.PrivacyEventDetail) =>
          usedPrivacyDetailsElement.showAccessState === privacyIndicatorManager.AccessState.ACCESSING &&
          usedPrivacyDetailsElement.privacySensorType === privacySensorType);*/
      if (findPrivacyDetailsElement !== undefined) {
        log.showInfo(`${findPrivacyDetailsElement.bundleName} now using ${privacySensorType} privacySensorType`);
        return true;
      }
      log.showInfo(`no bundle use ${privacySensorType} privacySensorType`);
      return false;
    } catch (e) {
      LogWithHa.error(log, `getPrivacyStateByType ${privacySensorType} error`,
        StatusBarExceptionCode.PRIVACY_INDICATOR_FAIL, e, TAG);
      return undefined;
    }
  }

  /**
   * 订阅用户切换事件
   */
  private async subscribeUserSwitched(): Promise<void> {
    const subscribeInfo: CommonEventManager.CommonEventSubscribeInfo = {
      events: [CommonEventManager.Support.COMMON_EVENT_USER_SWITCHED]
    };
    try {
      log.showInfo(`subscribeUserSwitched`);
      this.subscriber = await CommonEventManager.createSubscriber(subscribeInfo);
      CommonEventManager.subscribe(this.subscriber, (err, data: CommonEventManager.CommonEventData) => {
        if (err && err?.code !== 0) {
          log.showError(`Can't handle common event, err: ${err?.message}`);
          return;
        }
        let oldVal = AppStorage.get<boolean>('privacyIndicatorUserChangeKey') || false;
        log.showInfo(`user changed, oldVal is ${oldVal}`);
        AppStorageUtil.setOrCreate<boolean>('privacyIndicatorUserChangeKey', !oldVal);
      });
    } catch (error) {
      log.showError(`subscribeUserSwitched error: ${error?.message}`);
    }
  }

  /**
   * 取消订阅
   */
  private async unsubscribe(): Promise<void> {
    try {
      await CommonEventManager.unsubscribe(this.subscriber);
      this.subscriber = null;
    } catch (err) {
      log.showWarn(TAG, `err,mes=${(err as BusinessError)?.message}`);
    }
  }
}


function getUiContext(uiId: string): componentUtils.ComponentInfo | undefined {
  try {
    const oUiContext = componentUtils.getRectangleById(uiId);
    if (oUiContext === undefined || (oUiContext.size.width === 0 || oUiContext.size.height === 0)) {
      LogWithHa.warn(log, `getRectangleById uiContext is invalid ${uiId}`);
      return undefined;
    }
    return oUiContext;
  } catch (error) {
    LogWithHa.warn(log, `getRectangleById catch error, return undefined ${uiId}`);
    return undefined;
  }
}


/**
 * 电池宽高
 */
export function getBatteryHeight(): componentUtils.Size | undefined {
  const oUiContext = getUiContext(COMPONENT_ID_BATTERY_BORDER);
  if (oUiContext === undefined) {
    log.showInfo(`getBatteryHeight oUiContext is undefined`);
    return undefined;
  }
  return oUiContext.size;
}