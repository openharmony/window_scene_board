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

import { LogDomain, LogHelper, ThreadUtil } from '@ohos/basicutils';
import { DeviceModeEnum, RotationConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { DisplayEvent } from '@ohos/windowscene';
import lazy { SCBRotateChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import { EmergencyThermalAppType } from '../constants/DeviceModeType';
import { CutoutVm } from '../statusbar/vm/CutoutVm';
import { InnerEventUtil } from '../utils/InnerEventUtil';
import { Singleton } from '../utils/Singleton';
import { display } from '@kit.ArkUI';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { ThreadSync } from '../messageChannel/ThreadSync';
import { EmergencyThermalSafeManager } from '../manager/EmergencyThermalSafeManager';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuiutils/src/main/ets/base/LayoutUtils';
import lazy {
  SCBTripleStateChange
} from '@ohos/launchercommon/src/main/ets/utils/UltraScreenExpandAnimUtils';
import { ResourceVm } from './ResourceVm';
import { DeviceRotateVm } from './DeviceRotateVm';
import { EventEmitter } from '../utils/EventEmitter';
import { CutoutInfoUtil } from '../utils/CutoutInfoUtil';
import { ArkUIAdapter } from '../utils/ArkUIAdapter';
import { SceneSessionAdapter } from '../adapter/SceneSessionAdapter';
import settings from '@ohos.settings';
import { DisplayAdapter } from '../adapter/DisplayAdapter';
import lazy { messageChannel } from '../messageChannel/MessageChannel';
import { SystemUICcmConfig } from '../utils/SystemUICcmConfig';
import { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import DeviceInfo from '@ohos.deviceInfo';
import { StatusBarMaintenance } from '../maintenance/statusbar/StatusBarMaintenance'


const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'DeviceInfoVm');
const WIDTH_THRESHOLD_SMALL = 600;

interface DeviceInfoVmEvent {
  foldStatusChange: undefined;
  deviceModeChange: DeviceModeEnum;
}

/**
 * 设备信息ViewModel
 */
@ThreadSync.VmDecorator
@ObservedV2
export class DeviceInfoVm {
  @Singleton.decorate()
  public static get instance(): DeviceInfoVm {
    return new DeviceInfoVm();
  }

  /**
   * 是否为横屏
   */
  @Trace public isLandscape: boolean = false;
  /**
   * 是否为展开态，直板机永远不为展开态（注意区分小折叠），折叠屏展开后为展开态
   */
  @Trace public isExpand: boolean = false;
  /**
   * 屏幕宽度，单位px
   */
  @Trace public width: number = 0;
  /**
   * 屏幕高度，单位px
   */
  @Trace public height: number = 0;
  /**
   * 设备模式
   */
  @Trace public deviceMode: DeviceModeEnum = DeviceModeEnum.BASE_MODE;
  /**
   * 紧急模式下受信任的应用列表
   */
  @Trace public emergencyModelTrustAppList: string[] = [];
  /**
   * 屏幕真实旋转角度
   */
  @Trace public realRotateAngle: number = RotationConstants.ROTATION_90;
  /**
   * 屏幕旋转开始结束枚举
   */
  @Trace public orientationReason: SCBRotateChangeReason | undefined =
    ThreadUtil.isMainThread ? SCBRotateChangeReason.UNSPECIFIED : undefined;
  /**
   * 屏幕方向
   */
  @Trace public orientation: display.Orientation = display.Orientation.PORTRAIT;
  /**
   * 竖屏下是否是中挖孔，默认为true
   * 折叠屏展开，pad等竖屏下可能不是中挖孔
   */
  @Trace public isPortraitMiddleCutout: boolean = true;


  /**
   * XT设备形态
   */
  @Trace public xtLayoutType: XTLayoutType = LayoutUtils.getFoldDisplayMode();

  /**
   * XT设备折叠形态切换类型枚举
   */
  @Trace public tripleStateChange: SCBTripleStateChange = SCBTripleStateChange.INVALID;

  /**
   * 屏幕每次宽度变化时的变化量
   */
  @Trace public widthChangeDelta: number = 0;

  /**
   * 自由多窗PC模式
   */
  @Trace public isMultiWinPcMode: boolean = false;

  /**
   * 上一次屏幕旋转方向，在XT设备MG切换时需使用上一次方向判断需执行的动效
   */
  public lastOrientation: display.Orientation = display.Orientation.PORTRAIT;

  private deviceRadiusConfig: number[] = [];
  /**
   * 竖屏宽度
   */
  public verticalScreenWidth: number = 0;

  /**
   * 状态栏padding定制设备
   */
  public isCustomDevice: boolean = ['VYG', 'SGT', 'SGP', 'SGU', 'SDJ', 'LNJ'].includes(DeviceInfo.productSeries);

  public emitter = new EventEmitter<DeviceInfoVmEvent>();

  constructor() {
  }

  public init(): void {
    this.initDeviceRadiusConfig();
    try {
      InnerEventUtil.on(DisplayEvent, this.handleDisplayEvent.bind(this));

      if (ThreadUtil.isMainThread) {
        SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.onRegisterRotateChangeEvent.bind(this));
        this.registerPcModeChange();
      }
    } catch (e) {
      log.error(`Init device info error:`, e);
    }
  }

  public unInit(): void {
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.onRegisterRotateChangeEvent.bind(this));
  }

  /**
   * 设备是否为紧急模式
   * @returns 紧急模式时返回true
   */
  public isEmergencyMode(): boolean {
    return this.deviceMode === DeviceModeEnum.EMERGENCY_MODE || this.deviceMode === DeviceModeEnum.THERMAL_SAFE_MODE;
  }
  /**
   * 是否为XT设备G态左挖孔形态，通过屏幕旋转方向是否为LANDSCAPE_INVERTED判断
   * @returns
   */
  public isXTLandscapeInvertedStatus(): boolean {
    return LayoutUtils.isXTProductType() && this.xtLayoutType === XTLayoutType.G &&
      this.orientation === display.Orientation.LANDSCAPE_INVERTED;
  }
  /**
   * 是否为xt设备特殊形态：G态+反向横屏+非镜像语言
   * @returns
   */
  public isXTSpecialState(): boolean {
    return this.isXTLandscapeInvertedStatus() && !ResourceVm.instance.isRTL;
  }

  /**
   * 是否应用可显示通知，开启紧急模式下仅规定的白名单应用可显示，未开启时都可显示
   * @param bundleName 包名
   * @returns
   */
  public isShowNotification(bundleName: string): boolean {
    if (!this.isEmergencyMode()) {
      return true;
    }
    return this.emergencyModelTrustAppList.includes(bundleName);
  }

  /**
   * 设置设备模式
   * @param deviceMode
   */
  public setDeviceMode(deviceMode: DeviceModeEnum): void {
    log.showInfo(`Set device mode: ${deviceMode}`);
    this.deviceMode = deviceMode;
  }

  /**
   * 设置紧急模式下的应用白名单
   * @param emergencyAppList
   */
  public setEmergencyAppList(emergencyAppList: EmergencyThermalAppType[]): void {
    this.emergencyModelTrustAppList = emergencyAppList?.map((item) => item?.appItem?.bundleName) ?? [];
    log.showInfo(`Set emergency app list: [${this.emergencyModelTrustAppList}]`);
    EmergencyThermalSafeManager.instance.setBundleWhiteList(this.emergencyModelTrustAppList);
  }

  private handleDisplayEvent(event: DisplayEvent): void {
    try {
      let uiContext: UIContext | undefined = ArkUIAdapter.uiContext;
      if (uiContext) {
        log.showInfo(`uiContext is ${uiContext}`);
        uiContext?.runScopedTask(() => {
          this.setDisplayEvent(event);
        });
      } else {
        log.showInfo(`uiContext is undefined`);
        this.setDisplayEvent(event);
      }
    } catch (e) {
      LogWithHa.error(log, `Handle display change event error: ${e}`);
    }
  };

  private setDisplayEvent(event: DisplayEvent) {
    log.showInfo(`Handle display change event, width: ${event.display?.bounds.width}, height: ${event.display?.bounds.height}`);
    const defaultDisplay = display.getDefaultDisplaySync();
    CutoutInfoUtil.instance.getCutoutInfo(defaultDisplay).then((data: display.CutoutInfo) => {
      ArkUIAdapter.runWithScope(() => {
        // 屏幕宽高属性更新
        this.updateWHStatus(defaultDisplay);
        // 旋转属性更新
        this.updateRotateStatus(defaultDisplay);
        // 折叠展开属性更新
        this.updateExpandStatus(defaultDisplay);
        // 挖孔信息更新
        CutoutVm.instance.updateCutoutInfoByCutoutRect(data, this.width, this.height);
        CutoutVm.instance.orientation = defaultDisplay.orientation;
      })
      this.isPortraitMiddleCutout =
        CutoutVm.instance.isMiddleCutout() && this.orientation === display.Orientation.PORTRAIT;
      log.showWarn(`display prop change: width: ${this.width}, height: ${this.height}, landscape: ${this.isLandscape}, isExpand: ${this.isExpand}, orientation: ${this.orientation}, cutoutInfo: [${CutoutVm.instance.top}, ${CutoutVm.instance.left}, ${CutoutVm.instance.width}, ${CutoutVm.instance.height}], isInStatusBar: ${CutoutVm.instance.isInStatusBar()}, isMiddleCutout: ${CutoutVm.instance.isMiddleCutout()}, cutoutPosition: ${CutoutVm.instance.position}, isPortraitMiddleCutout: ${this.isPortraitMiddleCutout}`);
      this.reportCutoutInfo(defaultDisplay, data);
    }).catch(() => {
      ArkUIAdapter.runWithScope(() => {
        // 屏幕宽高属性更新
        this.updateWHStatus(defaultDisplay);
        // 旋转属性更新
        this.updateRotateStatus(defaultDisplay);
        // 折叠展开属性更新
        this.updateExpandStatus(defaultDisplay);
      })
      LogWithHa.error(log, `getCutoutInfo error, update basic value: ${this.getDeviceInfoStr()}`);
    });
  }

  private reportCutoutInfo(defaultDisplay: display.Display, data: display.CutoutInfo) {
    try {
      const cutoutInfoForReport: string =
        `${defaultDisplay.width}-${defaultDisplay.height}-${defaultDisplay.orientation}-(${data?.boundingRects[0]?.top}-${data?.boundingRects[0]?.left}-${data?.boundingRects[0]?.width}-${data?.boundingRects[0]?.height})`;
      new StatusBarMaintenance().reportStatusBarInfo(undefined, { cutoutInfo: cutoutInfoForReport });
    } catch (error) {
      log.error(`retport cutout info fail`, error);
    }
  }

  private updateWHStatus(defaultDisplay: display.Display): void {
    // 屏幕宽高属性更新
    const oldWidth = this.width;
    this.width = defaultDisplay.width ?? 0;
    CutoutVm.instance.displayWidth = this.width;
    this.widthChangeDelta = ArkUIAdapter.px2vp(this.width - oldWidth);
    this.height = defaultDisplay.height ?? 0;
  }

  private updateRotateStatus(defaultDisplay: display.Display): void {
    // 旋转属性更新
    this.isLandscape = defaultDisplay.orientation === display.Orientation.LANDSCAPE ||
      defaultDisplay.orientation === display.Orientation.LANDSCAPE_INVERTED;
    CutoutVm.instance.isLandscape = this.isLandscape;
    this.verticalScreenWidth = this.isLandscape ? this.verticalScreenWidth : this.width;
    this.realRotateAngle = defaultDisplay.rotation * 90;
    this.lastOrientation = this.orientation;
    this.orientation = defaultDisplay.orientation;
    if (this.lastOrientation !== this.orientation) {
      log.showWarn(`display change, last orientation is ${this.lastOrientation}, now orientation is ${this.orientation}, realRotateAngle is: ${this.realRotateAngle}`);
      DeviceRotateVm.instance.onDeviceRotateChange();
    }
  }

  /**
   * 更新屏幕折叠展开状态
   * @param foldStatus
   * @returns
   */
  private updateExpandStatus(defaultDisplay: display.Display): void {
    const prevIsExpand = this.isExpand;

    if (LayoutUtils.isXTProductType()) {
      const oldType = this.xtLayoutType;
      const layoutType = CutoutInfoUtil.instance.getXTLayoutTypeFromCache(defaultDisplay);
      this.xtLayoutType = layoutType ? layoutType : LayoutUtils.getFoldDisplayMode();
      CutoutVm.instance.xtLayoutType = this.xtLayoutType;
      if (oldType !== this.xtLayoutType) {
        this.tripleStateChange = this.getTripleDeviceStateChangeType(oldType, this.xtLayoutType);
        log.showInfo(`updateExpandStatus, isExpand: ${this.isExpand}, xtLayoutType: ${this.xtLayoutType}, tripleStateChange: ${this.tripleStateChange}`);
      }
      this.isExpand = this.xtLayoutType !== XTLayoutType.F;
    } else {
      this.isExpand = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    }

    // 折叠展开形态发生变化, 触发相关事件
    if (prevIsExpand !== this.isExpand) {
      log.showInfo(`updateExpandStatus isExpand changed: ${prevIsExpand} -> ${this.isExpand}`);
    }
  }

  private getTripleDeviceStateChangeType(oldType: number, newType: number): SCBTripleStateChange {
    if (!LayoutUtils.isXTProductType()) {
      return SCBTripleStateChange.INVALID;
    }
    if (oldType === XTLayoutType.F) {
      if (newType === XTLayoutType.M) {
        return SCBTripleStateChange.F_TO_M;
      }
      if (newType === XTLayoutType.G) {
        return SCBTripleStateChange.F_TO_G;
      }
    } else if (oldType === XTLayoutType.M) {
      if (newType === XTLayoutType.F) {
        return SCBTripleStateChange.M_TO_F;
      }
      if (newType === XTLayoutType.G) {
        return SCBTripleStateChange.M_TO_G;
      }
    } else if (oldType === XTLayoutType.G) {
      if (newType === XTLayoutType.F) {
        return SCBTripleStateChange.G_TO_F;
      }
      if (newType === XTLayoutType.M) {
        return SCBTripleStateChange.G_TO_M;
      }
    }
    return SCBTripleStateChange.INVALID;
  }

  /**
   * 读取CCM上的配置，类型为字符串，多个值以英文逗号分割，第一个值为直板机的圆角，或折叠屏的外屏圆角，第二个值为折叠屏内屏的圆角
   */
  private initDeviceRadiusConfig(): void {
    let value: string = '';
    try {
      value = systemParameterEnhance.getSync('const.product.real_device_radius', '');
      log.showInfo(`getDeviceRadiusConfig, read config file success, real_device_radius: ${value}`);
      this.deviceRadiusConfig = value.split(',').map((item) => parseFloat(item)).filter((item) => !Number.isNaN(item));
    } catch (error) {
      log.error(`getDeviceRadiusConfig, read config file failed:`, error);
    }
  }

  /**
   * 获取屏幕圆角
   */
  public getDeviceRadius(): number {
    const defaultOuterRadius = 38;
    const defaultInnerRadius = 28;
    // 如果屏幕展开.
    if (this.isExpand) {
      return this.deviceRadiusConfig[1] ?? defaultInnerRadius;
    }
    // 直板机或折叠屏外屏
    return this.deviceRadiusConfig[0] ?? defaultOuterRadius;
  }

  /**
   * 监听屏幕变化，比handleDisplayEvent更早触发
   */
  private onRegisterRotateChangeEvent(screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason): void{
    log.showWarn(`onRegisterRotateChangeEvent, orientationReason: ${reason}, realRotateAngle: ${screenProperty?.rotation}`);
    this.orientationReason = reason;
    this.realRotateAngle = screenProperty?.rotation;
    if (!SystemUICcmConfig.instance.isEnabledWorker) {
      if (reason === SCBRotateChangeReason.ROTATE_BEGIN) {
        DeviceRotateVm.instance.beginRotation();
      } else if (reason === SCBRotateChangeReason.ROTATE_END) {
        DeviceRotateVm.instance.endRotation();
      }
    } else {
      messageChannel.sendMessage('onRegisterRotateChangeEvent', reason);
    }
  }

  /**
   * 监听数据库自由多窗字段变化
   */
  private registerPcModeChange() {
    let result: boolean = false;
    try {
      result = settings.registerKeyObserver(
        GlobalContext.getContext(), SettingsKeyConstants.WINDOW_PCMODE_SWITCH_STATUS, settings.domainName.USER_PROPERTY, async () => {
        this.isMultiWinPcMode = await SceneSessionAdapter.isPcMode();
      });
    } catch (err) {
      log.showError(`registerPcModeChange failed, err code: ${err?.code}, msg: ${err?.message}`);
    }
    log.showInfo(`registerPcModeChange, result: ${result}`);
  }

  @Computed
  public get onDeviceModeChange(): void {
    EmergencyThermalSafeManager.instance.setDeviceModeState(this.deviceMode);
    EmergencyThermalSafeManager.instance.setBundleWhiteList(this.emergencyModelTrustAppList);
    return;
  }

  // emitter需要监听状态变量再emit，否则无法在对端线程生效。
  @Monitor('deviceMode')
  emitterDeviceModeChange (): void {
    this.emitter.emit('deviceModeChange', this.deviceMode);
  }

  @Monitor('xtLayoutType', 'isExpand')
  emitterFoldChange (): void {
    this.emitter.emit('foldStatusChange', undefined);
  }

  /**
   * 当前是否为宽屏
   *
   * @returns true 宽屏
   */
  isWidestScreen(): boolean {
    return ArkUIAdapter.px2vp(this.width) > WIDTH_THRESHOLD_SMALL;
  }

  private getDeviceInfoStr(): string {
    return `width: ${this.width}, height: ${this.height}, orientation: ${this.orientation}, rotateAngle: ${
      this.realRotateAngle}, isLandscape: ${this.isLandscape}, isExpand: ${this.isExpand}, xtLayoutType: ${
      this.xtLayoutType}`;
  }
}