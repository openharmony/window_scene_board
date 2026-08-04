/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { CommonUtils, LogDomain, LogHelper, RectInfo, SingletonHelper, } from '@ohos/basicutils';
import { SCBScreenProperty, ScenePanelState } from '@ohos/windowscene';
import { DesktopModeManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { SystemSceneConstants } from '../../gesturenavigation/SystemSceneConstants';
import { SCBNaviBarConstants } from '../SCBNaviBarConstants';
import { NAVIBarData } from './NAVIBarData';
import { power, thermal } from '@kit.BasicServicesKit';
import { gestureNavBarSettings } from '@ohos/gesturenavigation/src/main/ets/GestureNavBarSettings';

const TAG: string = 'naviBarViewData';
const RESPONSE_REGION: string = 'ResponseRegionParam';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);


@Observed
export class BarTranslateParam {
  private barTranslateX_: number = 0;
  private barTranslateY_: number = 0;
  private static mInstance: BarTranslateParam;

  static getInstance(): BarTranslateParam {
    if (!BarTranslateParam.mInstance) {
      BarTranslateParam.mInstance = new BarTranslateParam();
    }
    return BarTranslateParam.mInstance;
  }

  public get barTranslateX() {
    return this.barTranslateX_;
  }

  public get barTranslateY() {
    return this.barTranslateY_;
  }

  public set barTranslateX(barTranslateX: number) {
    if (CommonUtils.equals(this.barTranslateX_, barTranslateX)) {
      return;
    }
    this.barTranslateX_ = barTranslateX;
  }

  public set barTranslateY(barTranslateY: number) {
    if (CommonUtils.equals(this.barTranslateY_, barTranslateY)) {
      return;
    }
    this.barTranslateY_ = barTranslateY;
  }
}

@Observed
export class BarRadiusParam {
  private barRadius_: number = SystemSceneConstants.DEFAULT_BAR_RADIUS;
  public static mInstance: BarRadiusParam;

  static getInstance(): BarRadiusParam {
    if (!BarRadiusParam.mInstance) {
      BarRadiusParam.mInstance = new BarRadiusParam();
    }
    return BarRadiusParam.mInstance;
  }

  public get barRadius() {
    return this.barRadius_;
  }

  public set barRadius(barRadius: number) {
    if (CommonUtils.equals(this.barRadius_, barRadius)) {
      return;
    }
    this.barRadius_ = barRadius;
  }
}

@Observed
export class BarOpacityParam {
  private barOpacity_: number = SCBNaviBarConstants.GESTURE_NAV_NAVI_BAR_OPACITY;
  public static mInstance: BarOpacityParam;

  static getInstance(): BarOpacityParam {
    if (!BarOpacityParam.mInstance) {
      BarOpacityParam.mInstance = new BarOpacityParam();
    }
    return BarOpacityParam.mInstance;
  }

  public get barOpacity() {
    return this.barOpacity_;
  }

  public set barOpacity(barOpacity: number) {
    if (CommonUtils.equals(this.barOpacity_, barOpacity)) {
      return;
    }
    this.barOpacity_ = barOpacity;
  }
}

export enum WeakNotifyState {
  STATIC = 0,
  APPEAR = 1,
  ANIMATE = 2,
  DISAPPEAR = 3,
  EXPAND = 4
}

export enum BrightnessSceneType {
  DESKTOP = 0,
  SCREEN_LOCK = 1,
  AOD = 2
}

export enum NaviBarStatusFlag {
  DEFAULT_NAVI_BAR = 0,
}

@Observed
export class WeakNotifyParam {
  public weakNotifyPlayPosition: number = -3 * SystemSceneConstants.BAR_DEFAULT_WIDTH; // 起点位置
  public weakNotifyOpacity: number = 0;
  public weakNotifyVisibility: number = Visibility.None;
  public weakNotifyColorList: Array<[ResourceColor, number]> = SCBNaviBarConstants.WEAK_NOTIFY_COLOR_ONE; // 透明度
  public weakNotifyState: number = 0;
  public weakNotifyStartTime: number = 0;
  public weakNotifyDisAppearTime: number = SCBNaviBarConstants.APPEAR_DELAY;
  public static mInstance: WeakNotifyParam;

  static getInstance(): WeakNotifyParam {
    if (!WeakNotifyParam.mInstance) {
      WeakNotifyParam.mInstance = new WeakNotifyParam();
    }
    return WeakNotifyParam.mInstance;
  }
}

export class NaviBarShowParam {
  public scenePanelState: ScenePanelState = ScenePanelState.HOME;
  public navBarIsShow: boolean = true;
  public isNavigationBarEnable: boolean = false;
  public isTempShowNaviBar: boolean = false;
  public screenProperty: SCBScreenProperty = new SCBScreenProperty();
  public isInEmergencyOrThermalSafeMode: boolean = DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode();
  public isInOutLauncher: boolean = false;
  public isInExitLandScape: boolean = false;
}

@Observed
export class NAVIBarViewData {
  public isShowNotificationCapsule: boolean = false;
  private static mInstance: NAVIBarViewData;
  private naviBarData: NAVIBarData = NAVIBarData.getInstance();
  public isShowingNaviBar: boolean = true;
  // 胶囊高度
  public capsuleHeight: number = SCBNaviBarConstants.CAPSULE_HEIGHT_INIT;
  public capsuleWidth: number = this.naviBarData.naviBarWidth;
  public capsuleBlur: number = 0;
  public capsuleScale: ScaleOptions = {
    x: 1,
    y: 1,
    centerX: '50%',
    centerY: '100%'
  };
  public textScale: ScaleOptions = {
    x: 1,
    y: 1,
    centerX: '50%',
    centerY: '50%'
  };
  // 导航条透明度
  public naviBarOpacity: number = 1;
  public isToastShow: boolean = false;
  public isInEmergencyOrThermalSafeMode: boolean = DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode();
  public naviBarBottomMargin: number = gestureNavBarSettings.getNaviBarMarginBottom();
  public isTempShowNaviBar: boolean = false;
  public isNavigationBarEnable: boolean = true;
  public isInMidScene: boolean = false;
  public isInWindowModeFullScreen: boolean = false;
  public barTranslateParam = BarTranslateParam.getInstance();
  public barRadiusParam = BarRadiusParam.getInstance();
  public barOpacityParam = BarOpacityParam.getInstance();
  public naviBarHotAreaRect: RectInfo = new RectInfo();
  public brightnessOptions: BrightnessOptions = SCBNaviBarConstants.BRIGHTNESS_OPTIONS_TYPE1;
  public weakNotifyParam = WeakNotifyParam.getInstance();
  public isInExitLandScape: boolean = false;
  public navBarIsShow: boolean = true;
  public scenePanelState: ScenePanelState = ScenePanelState.HOME;
  public specialScenePanelState: ScenePanelState = ScenePanelState.HOME;
  // 是否进入平板自由多窗
  public isInMultiWindowMode: boolean = false;
  // 是否取消了inputMonitor拖拽监听
  public isOffInputMonitor: boolean = false;
  public thermalLevel: thermal.ThermalLevel = thermal.ThermalLevel.NORMAL;
  public powerMode: power.DevicePowerMode = power.DevicePowerMode.MODE_NORMAL;
  public naviBarUseAppColor: boolean = false;
  // 是否进入deliver应用
  public isEnterDeliver: boolean = false;
  public isScreenLock: boolean = false;
  public isFloatingNavShow: boolean = false;
  public clickBackStatus: boolean = false;

  static getInstance(): NAVIBarViewData {
    if (!NAVIBarViewData.mInstance) {
      NAVIBarViewData.mInstance = new NAVIBarViewData();
    }
    return NAVIBarViewData.mInstance;
  }

  /**
   * 判断是否使用纯色模式
   * @returns true:是 false:否
   */
  public isNeedToUsePureColor(): boolean {
    log.showInfo(`powerMode:${this.powerMode} thermalLevel:${this.thermalLevel} isEnterDeliver:${this.isEnterDeliver}`);
    return this.thermalLevel > SCBNaviBarConstants.OVERHEAT_LEVEL || this.isEnterDeliver ||
      this.powerMode === SCBNaviBarConstants.LOW_POWER_LEVEL || this.naviBarData.naviBarPureColorMode;
  }

  /**
   * 获取导航条透明度
   * @returns
   */
  public getNavibarOpacity(): number {
    if ((this.isFloatingNavShow && !this.isScreenLock) || this.isShowNotificationCapsule || this.isInExitLandScape) {
      log.showInfo(`isFloatingNavShow: ${this.isFloatingNavShow}, isScreenLock: ${this.isScreenLock}, isShowNotificationCapsule: ${this.isShowNotificationCapsule}, isInExitLandScape: ${this.isInExitLandScape}`);
      return 0;
    }
    return this.naviBarOpacity;
  }

  /**
   * 获取导航条无障碍可用性等级
   *
   * @returns 无障碍可用性等级
   */
  public getNavibarAccessibilityLevel(): string {
    if (this.getNavibarOpacity() === 0) {
      return 'no';
    }
    return 'auto';
  }

  /**
   * 判断是否使用应用内导航条色彩方案
   * @returns true:使用应用内方案 false:不使用
   */
  public isInFullScreen(): boolean {
    // 中景模式使用桌面导航条
    if (this.isInMidScene) {
      log.showInfo('return with midScene');
      return false;
    }

    // 全屏，锁屏上全屏，自由多窗模式，都是算作全屏，使用反色+模糊的导航条颜色方案
    return this.scenePanelState === ScenePanelState.FULLSCENE || this.naviBarUseAppColor ||
      this.specialScenePanelState === ScenePanelState.FULLSCENE ||
      (this.isInMultiWindowMode && this.isInWindowModeFullScreen);
  }
}
