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

import fs from '@ohos.file.fs';
import commonEventManager from '@ohos.commonEventManager';
import image from '@ohos.multimedia.image';
import { BusinessError } from '@ohos.base';
import { SCBTransitionManager } from '@ohos/windowscene';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import type { SCBUnlockTransitionController } from '@ohos/windowscene';
import {
  DeviceHelper,
  EvtBus,
  GlobalContext,
  ThemeActivationEvent,
  WallpaperManager,
  WallpaperType
} from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils';
import display from '@ohos.display';
import {
  CommonEventMonitor,
  Constants,
  DisplayUtils,
  PerformanceMonitorUtil,
  ScreenLockApi,
  slWallpaperMgr,
  SLWallpaperType,
  UltraScreenStatus
} from '@ohos/screenlockcommon';
import { DisplayStateManager, FileUtil } from '@ohos/screenlockcommon/Index';
import ThemeHelperUtil from './ThemeHelperUtil';
import CommonEventManager from '@ohos.commonEventManager';
import {
  ScreenLockWallpaperChangeEvent
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/event/ImmersiveEvent';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import {
  ClockStaticStateType,
  SlMainStateType,
  SlStaticStateType,
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { Qualifier } from '@ohos/themeservicekit/Index';
import { eyeGazeSwingEvent } from '@ohos/screenlockcommon/src/main/ets/base/EyeGazeSwingEvent';
import { ThemeScene } from '@ohos/screenlockcommon/src/main/ets/constants/ThemeEditAndScreenLockConstants';
import sThemeUpgradeManager from './ThemeUpgradeManager';
import { CCMParamUtil } from '../../clock/common/CCMParamUtil';
import {
  AestheticColorArgs,
  ALL_COM_FAMILY,
  ClockComFamily,
  ClockLayout,
  ClockTextAlign,
  IThemeParam,
  LockscreenForm,
  LockscreenFormConfig,
  LockscreenThemeConfig
} from '../WidgetParam';
import { immersiveKgMgr } from '@ohos/systemuicommon';
import { slStateHelper } from '../utils/SlStateHelper';
import { PageDesktopOneShotManager } from '@ohos/launchercommon/src/main/ets/viewmodel/PageDesktopOneShotManager';
import { ThemeRemoteManager } from './ThemeRemoteManager'
import { HIS_COLOR_MAP } from '../../editsheet/models/AnyColor';

const TAG: string = 'ScreenLockThemeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export const SANDBOX_THEME_PATH_FLAG_A: string = '/data/themes/a/app/flag';

export const SANDBOX_THEME_PATH_SYSTEM_A: string = '/data/themes/a/system';

export const SANDBOX_THEME_PATH_FLAG_B: string = '/data/themes/b/app/flag';

export const SANDBOX_THEME_PATH_SYSTEM_B: string = '/data/themes/b/system';

export const SUB_SCREEN_THEME_PATH: string = '/sub_screen';

/*
 * 锁屏时钟、卡片等配置信息的限定符集合
 * */
export const SANDBOX_THEME_QUALIFIER: string[] = ['base'];

/*
 * 锁屏时钟、卡片等配置信息的默认主题限定符
 * */
export const DEFAULT_SANDBOX_THEME_QUALIFIER = 'base';

/**
 * 标识当前版本号，用于宫格升级适配处理
 */
export const CONFIG_VERSION = 2;

/*
 * 资源目录，主要用于存放图片、视频等资源
 * */
const SANDBOX_THEME_PATH_WALLPAPER: string = '/lock/base/resources/';
const SANDBOX_THEME_DARK_PATH_WALLPAPER: string = '/lock/dark/resources/';
/*
 * 描述配置文件，用于配置锁屏相关信息
 * */
const MANIFEST_PATH: string = '/lock/manifest.json';

/*
 * 描述配置文件，用于配置AOD锁屏时钟相关信息
 * */
const HOME_MANIFEST_PATH: string = '/home/manifest.json';

/*
 * description描述配置文件
 * */
const DESCRIPTION_PATH: string = '/description.json';

/*
 * 主题包里的高指纹动效文件
 * */
const SANDBOX_THEME_PATH_FINGER: string = '/lock/base/fingerprint_growth.json';

const DEFAULT_CLOCK_POSITIONX = 1;
const DEFAULT_CLOCK_POSITIONY = 0;
const SINGLE_DISPLAY_POCKET_SPECIAL_CLOCK_POSITIONX = 1;
const SINGLE_DISPLAY_POCKET_DEFAULT_CLOCK_POSITIONX = 2;

const WIDESCREEN_DEFAULT_CLOCK_POSITIONX = 3;

const PC_DEFAULT_CLOCK_POSITIONX = 6;
const PC_DEFAULT_CLOCK_POSITIONY = 1;

export const DIMENSION_4_2_PAD_LANDSCAPE_POSITION: number = 4;

export const DIMENSION_4_2_PAD_PORTRAIT_POSITION: number = 2;

const HALF: number = 2;

/*
 * 壁纸版本号，VERSION_CODE_5_1为壁纸合一
 * */
const VERSION_CODE_5_1: string = '500100000';

/**
 * 是否智慧屏
 */
const CLOCK_F_POSITION_X: number = 1;
const CLOCK_M_POSITION_X: number = 3;
const CLOCK_G_POSITION_X: number = 4;

export class WidgetPos {
  public posX: number = 0;
  public posY: number = 0;
}

export class DescriptionDataJson {
  public supportedModes: string[] = [];
}

export class DescriptionLockDataJson {
  public interactive: string[] | undefined = undefined;
}

export class ManifestContentDataJson {
  public clockColorForAod: string | undefined = undefined;
  public type: string = '';
  public clockFontFamily: string | undefined = undefined;
}

export class WallpaperConfigDataJson {
  public rectData: RectDataJson | undefined = undefined;
}

export class RectDataJson {
  public rect: Rect | undefined = undefined;
}

/**
 * 使能的主题元素
 */
enum ThemeActivationTarget {
  NIL = 0,
  UNLOCK = 1,
  HOME = 2,
  HOME_AND_UNLOCK = 3,
  AOD = 4,
  AOD_AND_UNLOCK = 5,
  AOD_AND_HOME = 6,
  ALL = 7,
  ONLY_LOCK_CLOCK = 8,
  ONLY_ICON = 9,
  OUTER_LOCK = 16,
  //内屏外屏主题同时使能
  WHOLE_THEME_ALL = 23,
}

export interface LockscreenThemeAodInfo {
  type: string;
  clock: AodClock;
}

export interface AodClock {
  color: string;
}

export interface ActivateThemeCallback {
  onThemeActivate?: (themeParam: LockscreenThemeConfig | undefined) => void;

  onMultiThemeActivate?: (themeParams: Map<Qualifier, LockscreenThemeConfig>) => void;
}

/**
 * 壁纸裁剪区域
 */
class Rect {
  public x: number = 0;
  public y: number = 0;
  public width: number = 0;
  public height: number = 0;
}

function getDefaultFont(clockLayout: ClockLayout = ClockLayout.DEFAULT_CLOCK_LAYOUT): string {
  if (CCMParamUtil.isUD()) {
    // 样式映射UD
    if (clockLayout === ClockLayout.NORMAL_CLOCK_LAYOUT) {
      return ClockComFamily.HARMONY_CLOCK_ULT_2_4;
    } else {
      return ClockComFamily.HARMONY_CLOCK_ULT_01;
    }
  }
  return ClockComFamily.HARMONY_CLOCK_01;
}

export const defaultClockParam: IThemeParam = {
  positionX: getDefaultPositionX(),
  positionY: getDefaultPositionY(),
  // DIMENSION_4_4
  layout: getDefaultLayout(),
  textShadow: true,
  textBlurEffect: true,
  signatureText: '',
  isShowAsCompound: false,
  editStatus: false,
  dateVisible: true,
  lunarVisible: true,
  signatureVisible: true,
  // CENTER
  textAlign: ClockTextAlign.CENTER,
  color: '#FFFFFF',
  fontFamily: getDefaultFont(getDefaultLayout()),
  aestheticColorArgs: new AestheticColorArgs(),
  isLightWallpaper: false,
  isDof: false,
  clockDegree: 0,
  version: CONFIG_VERSION,
};

export const defaultPortraitClockParam: IThemeParam = {
  positionX: DEFAULT_CLOCK_POSITIONX,
  positionY: DEFAULT_CLOCK_POSITIONY,
  // DIMENSION_4_4
  layout: getDefaultLayout(),
  textShadow: true,
  textBlurEffect: true,
  signatureText: '',
  isShowAsCompound: false,
  editStatus: false,
  dateVisible: true,
  lunarVisible: true,
  signatureVisible: true,
  // CENTER
  textAlign: ClockTextAlign.CENTER,
  color: '#FFFFFF',
  fontFamily: getDefaultFont(getDefaultLayout()),
  aestheticColorArgs: new AestheticColorArgs(),
  isLightWallpaper: false,
  isDof: false,
  clockDegree: 0,
  version: CONFIG_VERSION,
};

export const defaultFormParam: LockscreenForm = {
  list: [],
  positionY: -1,
};

export const defaultThemeParam: LockscreenThemeConfig = {
  clock: defaultClockParam,
  form: defaultFormParam,
};

export const defaultSinglePocketThemeParam: LockscreenThemeConfig = {
  clock: ObjectCopyUtil.deepClone(defaultClockParam),
  form: defaultFormParam,
};

export const defaultPortraitThemeParam: LockscreenThemeConfig = {
  clock: defaultPortraitClockParam,
  form: defaultFormParam,
};

/**
 * 锁屏主题切换事件
 */
export class ScreenLockThemeChangeEvent {
  public static readonly eventTypeName = 'ScreenLockThemeChangeEvent';

  // 是否屏幕状态触发的变化
  public isDisplayChange: boolean = false;
}

/**
 * 主题使能事件集合
 */
const THEME_EVENT_ARR: Set<number> = new Set([
  ThemeActivationTarget.UNLOCK,
  ThemeActivationTarget.HOME_AND_UNLOCK,
  ThemeActivationTarget.AOD_AND_UNLOCK,
  ThemeActivationTarget.ALL,
  ThemeActivationTarget.ONLY_LOCK_CLOCK,
  ThemeActivationTarget.HOME,
  ThemeActivationTarget.OUTER_LOCK | ThemeActivationTarget.UNLOCK,
  ThemeActivationTarget.OUTER_LOCK | ThemeActivationTarget.HOME,
  ThemeActivationTarget.OUTER_LOCK | ThemeActivationTarget.AOD,
  ThemeActivationTarget.OUTER_LOCK | ThemeActivationTarget.UNLOCK | ThemeActivationTarget.HOME,
  ThemeActivationTarget.OUTER_LOCK | ThemeActivationTarget.UNLOCK | ThemeActivationTarget.AOD,
  ThemeActivationTarget.OUTER_LOCK | ThemeActivationTarget.HOME | ThemeActivationTarget.AOD,
  ThemeActivationTarget.OUTER_LOCK | ThemeActivationTarget.UNLOCK | ThemeActivationTarget.HOME |
    ThemeActivationTarget.AOD,
  ThemeActivationTarget.WHOLE_THEME_ALL]);

export default class ScreenLockThemeManager {
  private static sInstance: ScreenLockThemeManager;

  public static getInstance(): ScreenLockThemeManager {
    if (!ScreenLockThemeManager.sInstance) {
      ScreenLockThemeManager.sInstance = new ScreenLockThemeManager();
    }
    return ScreenLockThemeManager.sInstance;
  }

  private wallpaper: image.PixelMap | undefined = undefined;

  private outerScreenWallpaper: image.PixelMap | undefined = undefined;

  private innerThemeParam: Map<Qualifier, LockscreenThemeConfig> | undefined = undefined;

  private outerThemeParam: Map<Qualifier, LockscreenThemeConfig> | undefined = undefined;

  private isStatic: boolean = false;

  private themeType: string = '';

  // 主题包中时钟字体名
  private clockFontFamily?: string;
  private outerClockFontFamily?: string;

  private isLockState: boolean = false;

  private _isGestureSupported: boolean = false;

  private activateThemeCallback: ActivateThemeCallback | undefined = undefined;

  private currentThemeParams?: Map<Qualifier, LockscreenThemeConfig>;

  private currentCropRect: Rect | undefined;

  public get isGestureSupported(): boolean {
    return this._isGestureSupported;
  }

  // 异壁纸主题配置使能开关
  private isSupportMultiSceneTheme: boolean = (DeviceHelper.isFoldButNotSmallFoldProduct() ||
    DeviceHelper.isPadOr2in1PcType() || DeviceHelper.isUltraScreenProduct()) &&
     !DeviceHelper.isPcNot2in1Device();

  private isInteractiveTheme: boolean = false; // 是否交互类主题

  private onThemeInteractiveChange?: Function;

  private unLockTransitionController: SCBUnlockTransitionController = {
    name: `${TAG}_wallpaper`,
    onLock: (): void => {
      if (!this.isLockState && this.themeType === 'script') {
        PerformanceMonitorUtil.reportScreenLockCommonEvent(Constants.SCREEN_LOCK_SCRIPT_THEME);
      }
      this.isLockState = true;
      this.loadWallpaper();
    },
    onUnlock: (): void => {
      this.isLockState = false;
      this.releaseWallpaper();
    }
  };

  private isWallpaperAllInOne: boolean = false; // 主题包是否壁纸归一

  private onThemeActivationEvent = (event: ThemeActivationEvent): void => {
    try {
      log.showInfo(`event on theme activate target: ${event.target}`);
      if (THEME_EVENT_ARR.has(event.target)) {
        // Activate new screen lock theme
        log.showInfo('Activate theme event is valid, start to apply theme');
        this.applyTheme(this.activateThemeCallback);
      } else if (event.target === ThemeActivationTarget.OUTER_LOCK) {
        log.showInfo('Activate outer theme event is valid, start to apply outer theme');
        this.applyOuterTheme(this.activateThemeCallback);
      } else {
        log.showInfo('Activate theme event is invalid');
      }
    } catch (e) {
      log.showError(`Exception when applay theme.`);
    }
  };


  public registerThemeInteractiveChange(callback: Function): void {
    this.onThemeInteractiveChange = callback;
  }

  public unregisterThemeInteractiveChange(): void {
    this.onThemeInteractiveChange = undefined;
  }

  public switchThemeWithFoldStateChange(onActivateTheme: ActivateThemeCallback): void {
    let themeChangeEvent: ScreenLockThemeChangeEvent = new ScreenLockThemeChangeEvent();
    if (!this.outerThemeParam || !this.innerThemeParam) {
      return;
    }
    this.onThemePreChange(this.innerThemeParam.get(DEFAULT_SANDBOX_THEME_QUALIFIER)?.clock);
    onActivateTheme.onThemeActivate?.(this.innerThemeParam.get(DEFAULT_SANDBOX_THEME_QUALIFIER));
    this.currentThemeParams = this.innerThemeParam;
    EvtBus.post(ScreenLockThemeChangeEvent, themeChangeEvent);
    immersiveKgMgr.notifyStateChange();
    // 小折叠产品监听解锁修改内屏进行壁纸替换
    this.setSlWallpaperImg();
  }

  private setSlWallpaperImg(): void {
    let image = this.wallpaper;
    slWallpaperMgr.setSlWallpaperImg(SLWallpaperType.TYPE_ENGINE_THEME, image);
  }

  constructor() {
    if (DeviceHelper.isPadOr2in1PcType()) {
      this.addThemeQualifier(ThemeScene.LAND);
    }
    if (DeviceHelper.isFoldButNotSmallFoldProduct()) {
      this.addThemeQualifier(ThemeScene.UNFOLDED);
      this.addThemeQualifier(ThemeScene.LAND_UNFOLDED);
    }
    if (DeviceHelper.isUltraScreenProduct()) {
      this.addThemeQualifier(ThemeScene.LAND);
      this.addThemeQualifier(ThemeScene.UNFOLDED);
      this.addThemeQualifier(ThemeScene.LAND_UNFOLDED);
      this.addThemeQualifier(ThemeScene.UNFOLDED2);
      this.addThemeQualifier(ThemeScene.LAND_UNFOLDED2);
    }
  }

  protected addThemeQualifier(qualifier: string): void {
    if (SANDBOX_THEME_QUALIFIER.indexOf(qualifier) === -1) {
      SANDBOX_THEME_QUALIFIER.push(qualifier);
    }
  }

  public registerThemeActiveEvent(onActivateTheme: ActivateThemeCallback): void {
    log.showInfo('registerThemeActiveEvent');
    // 接收应用删除公共广播事件，响应回调
    this.activateThemeCallback = onActivateTheme;
    CommonEventMonitor.registerThemeSubscriber(this.handleSubscriberCallback);

    // 接收主题使能事件，响应回调
    EvtBus.on(ThemeActivationEvent, this.onThemeActivationEvent);

    // Obtains default screen lock theme
    this.applyTheme(onActivateTheme);

    if (DeviceHelper.isPhoneOrPad()) {
      SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockTransitionController, false);
    }
  }

  public destroyThemeActiveEvent(): void {
    CommonEventMonitor.unRegisterThemeSubscriber();
    EvtBus.off(ThemeActivationEvent, this.onThemeActivationEvent);
    this.activateThemeCallback = undefined;
  }

  protected handleRemove(bundleName: string, activateThemeCallback: ActivateThemeCallback | undefined): void {
    log.showInfo('do handleRemove');
    this.getScreenLockThemeParams()
      .then((themePackageParams: Map<Qualifier, LockscreenThemeConfig>) => {
        this.handleRemoveInner(bundleName, activateThemeCallback, themePackageParams);
      }).catch((err: BusinessError) => {
      log.showError('handle Remove meet some error');
    });
  }

  private handleRemoveInner(bundleName: string, activateThemeCallback: ActivateThemeCallback | undefined,
    themePackageParams: Map<Qualifier, LockscreenThemeConfig>): void {
    let needDeleteFormList: boolean = false;
    themePackageParams.forEach((themePackageParam) => {
      let deleteIndex =
        themePackageParam.form.list.findIndex(formCfg => formCfg.formInfo.bundleName === bundleName);
      if (deleteIndex !== -1) {
        themePackageParam.form.list.splice(deleteIndex, 1);
        needDeleteFormList = true;
      }
    });

    log.info(`needDeleteFormList: ${needDeleteFormList}`);
    // 不需要更新
    if (!needDeleteFormList) {
      return;
    }

    const unlockThemePath: string | undefined = this.getCurrentThemePath();
    if (!unlockThemePath) {
      log.showError('Can not resolve unlockThemePath, unlockThemePath is undefined');
      return;
    }
    themePackageParams.forEach((themePackageParam, qualifier) => {
      const screenLockConfigPath: string = unlockThemePath + `/lock/${qualifier}/config.json`;
      if (themePackageParam && this.isEmptyObject(themePackageParam)) {
        log.info('save lock form config');
        try {
          let fileContent = JSON.stringify(themePackageParam);
          FileUtil.createJsonFile(screenLockConfigPath, fileContent);
        } catch (e) {
          log.showError(`failed to write file, error code = ${e.code}`);
        }
      }
    });
    if (themePackageParams.size <= 1) {
      activateThemeCallback?.onThemeActivate?.(themePackageParams.get(DEFAULT_SANDBOX_THEME_QUALIFIER));
    } else {
      activateThemeCallback?.onMultiThemeActivate?.(themePackageParams);
    }
  }

  protected isEmptyObject(obj: LockscreenThemeConfig): boolean {
    return (obj.clock === undefined) && (obj.form === undefined);
  }

  /**
   * 应用卸载事件回调
   * @param subscriber
   * @param callback
   */
  private handleSubscriberCallback = (eventData: commonEventManager.CommonEventData): void => {
    if (eventData.event === CommonEventManager.Support.COMMON_EVENT_PACKAGE_REMOVED) {
      this.handleRemove(eventData.bundleName ?? '', this.activateThemeCallback);
      return;
    }
  };

  /**
   * 核查配置中颜色配置信息，查看是否升级场景需刷新其颜色内容到配置
   * @param themePackageParams
   * @returns
   */
  private refreshAndStore(themePackageParams: Map<Qualifier, LockscreenThemeConfig>) {
    const mThemeManager: ThemeRemoteManager = new ThemeRemoteManager();
    let refreshed = false;

    // 判断当前颜色是否为历史版本修改颜色，并刷新读取的配置中内容
    themePackageParams.forEach((themeParams, qualifier) => {
      if (themeParams) {
        if (HIS_COLOR_MAP.has(themeParams.clock.color)) {
          refreshed = true;
          themeParams.clock.color = HIS_COLOR_MAP.get(themeParams.clock.color) ?? themeParams.clock.color;
        }
      }
      themePackageParams.set(qualifier, themeParams);
    })
    if (!refreshed) {
      return themePackageParams;
    }

    // 有刷新时，回写至当前配置中
    if (this.isSupportMultiSceneTheme) {
      mThemeManager.setMultiSceneThemeCfg(themePackageParams);
    } else {
      const saveTheme = themePackageParams.get(DEFAULT_SANDBOX_THEME_QUALIFIER);
      if (saveTheme) {
        mThemeManager.setCurrentThemeCfg(saveTheme);
      }
    }
    return themePackageParams;
  }

  protected async applyTheme(activateThemeCallback: ActivateThemeCallback | undefined): Promise<void> {
    this.innerThemeParam = await this.getScreenLockThemeParams(false);
    this.outerThemeParam = await this.getScreenLockThemeParams(true);
    this.parseManifestData();
    this.parseDescriptionData();
    this.getScreenLockThemeParams().then((themePackageParams: Map<Qualifier, LockscreenThemeConfig>) => {
      log.info('load LockThemeParams finish then applyTheme');
      themePackageParams = this.refreshAndStore(themePackageParams);
      this.currentThemeParams = themePackageParams;
      if (!this.isSupportMultiSceneTheme) {
        let curThemeParams = themePackageParams.get(DEFAULT_SANDBOX_THEME_QUALIFIER);
        if (curThemeParams) {
          sThemeUpgradeManager.upgradeBaseScene(curThemeParams);
        }
        this.onThemePreChange(curThemeParams?.clock);
        activateThemeCallback?.onThemeActivate?.(curThemeParams);
      } else {
        sThemeUpgradeManager.upgradeMultiScene(themePackageParams);
        let curQualifier = DeviceHelper.isFoldExpanded() ? ThemeScene.UNFOLDED : DEFAULT_SANDBOX_THEME_QUALIFIER;
        // 大屏幕机G态适配
        if (DeviceHelper.isUltraScreenProduct() && DeviceHelper.isGState()) {
          curQualifier = ThemeScene.UNFOLDED2;
        }
        const curThemeParams = themePackageParams.get(curQualifier);
        log.showInfo(`applyTheme ${curQualifier} ${curThemeParams?.clock?.aestheticColorArgs?.isChangeColor} ${curThemeParams?.clock?.color}`);
        activateThemeCallback?.onMultiThemeActivate?.(themePackageParams);
      }
      EvtBus.post(ScreenLockThemeChangeEvent, new ScreenLockThemeChangeEvent());
    });
    log.showInfo(`applyTheme isScreenLock:${ScreenLockApi.isScreenLockShow()}`);
    if (!ScreenLockApi.isScreenLockShow()) {
      // 非锁屏界面更新了主题需要清空原来缓存的失效时钟位置
      slStateHelper.getSlClockStaticState().clearClockRectInfo();
    }
    // 应用主题清空时钟位置缓存
    if (!DeviceHelper.isPcNot2in1Device() && ScreenLockApi.isScreenLockShow()) {
      this.releaseWallpaper();
      this.loadWallpaper();
    }
  }

  protected async applyOuterTheme(activateThemeCallback: ActivateThemeCallback | undefined): Promise<void> {
    this.innerThemeParam = await this.getScreenLockThemeParams(false);
    this.outerThemeParam = await this.getScreenLockThemeParams(true);
  }

  /**
   * 刷新时钟参数
   *
   * @returns 时钟参数
   */
  public async refreshThemeClockParam(): Promise<IThemeParam | undefined> {
      this.innerThemeParam = await this.getScreenLockThemeParams(false);
      this.currentThemeParams = this.innerThemeParam;
    return this.currentThemeParams.get(DEFAULT_SANDBOX_THEME_QUALIFIER)?.clock;
  }

  /**
   * 当前是否支持分屏主题
   *
   * @returns 是否支持分屏主题
   */
  public isSupportMultiScene(): boolean {
    return this.isSupportMultiSceneTheme;
  }

  onThemePreChange(clockParams: IThemeParam | undefined): void {
    this.parseManifestData();
    slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.setSlState(ClockStaticStateType.BRIGHTNESS,
      clockParams?.aestheticColorArgs.brightness);
    EvtBus.post(ScreenLockWallpaperChangeEvent, new ScreenLockWallpaperChangeEvent());
  };

  /**
   * 根据是否开启 显示和亮度->深色模式 获取主题包壁纸路径
   *
   * @returns 主题包壁纸路径
   */
  protected getWallpaperPath(isOuterScreen: boolean = false): string {
    let currentThemePath = this.getCurrentThemePath(isOuterScreen);
    let sandboxWallpaperPath = SANDBOX_THEME_PATH_WALLPAPER;

    const darkWallpaperPath: string = currentThemePath + SANDBOX_THEME_DARK_PATH_WALLPAPER +
    ThemeHelperUtil.getLockManifest(isOuterScreen).image.src;
    if (!GlobalContext.getContext()?.config.colorMode && this.isFileExist(darkWallpaperPath)) {
      return darkWallpaperPath;
    }

    if (this.isWallpaperAllInOne && !isOuterScreen) {
      return currentThemePath + sandboxWallpaperPath + ThemeHelperUtil.getLockManifest(isOuterScreen).image.src;
    }

    if (!isOuterScreen && DeviceHelper.isFold()) {
      sandboxWallpaperPath = this.getFoldValidSandboxPath(currentThemePath);
    }
    const wallpaperPath: string =
      currentThemePath + sandboxWallpaperPath + ThemeHelperUtil.getLockManifest(isOuterScreen).image.src;
    if (this.isFileExist(wallpaperPath)) {
      return wallpaperPath;
    }
    log.showError('getWallpaperPath error, no any picture');
    return '';
  }

  protected getFoldValidSandboxPath(currentThemePath?: string): string {
    // 大屏幕机路径降级取用：unfolded-land -> unfolded -> base
    let curQualifier = this.getCurrentThemeQualifier();
    let curSandBox = this.getSandboxPath(curQualifier);
    if (this.isFileExist(currentThemePath + curSandBox)) {
      return curSandBox;
    }
    let nextQualifier = curQualifier === ThemeScene.LAND_UNFOLDED ? ThemeScene.UNFOLDED : ThemeScene.BASE;
    let nextSandbox = this.getSandboxPath(nextQualifier);
    if (this.isFileExist(currentThemePath + nextSandbox)) {
      return nextSandbox;
    }
    return this.getSandboxPath(ThemeScene.BASE);
  }

  private getSandboxPath(qualifier: string): string {
    return `/lock/${qualifier}/resources/`;
  }

  protected isFileExist(path: string): boolean {
    try {
      if (fs.accessSync(path)) {
        return true;
      }
      return false;
    } catch (err) {
      log.showWarn(`accessSync failed with error code: ${err.code}`);
      return false;
    }
  }

  /**
   * get persistence cards
   *
   * @returns persistence cards
   */
  public async getPersistenceCardId(): Promise<string[]> {
    let configs = await this.getScreenLockThemeParams();
    let persistenceCards: string[] = [];
    configs.get(DEFAULT_SANDBOX_THEME_QUALIFIER)?.form.list.forEach(item => {
      persistenceCards.push(String(item.formInfo.cardId));
    });
    log.showInfo(`persistenceCards ${persistenceCards}`);
    return persistenceCards;
  }

  public getCropRect(): Rect | undefined {
    return this.currentCropRect;
  }

  private readCropRect(): Rect | undefined {
    try {
      const unlockThemePath: string | undefined = this.getCurrentThemePath();
      if (!unlockThemePath) {
        log.showWarn('unlockThemePath is undefined');
        return undefined;
      }

      let wallpaperConfigPath: string =
        unlockThemePath + `/lock/${this.getCurrentThemeQualifier()}/wallpaper_config.json`;
      if (!fs.accessSync(wallpaperConfigPath)) {
        log.showWarn('wallpaper config file not exists');
        return undefined;
      }
      const text: string = fs.readTextSync(wallpaperConfigPath);
      if (!text) {
        log.showWarn('wallpaper config file is empty');
        return undefined;
      }
      const wallpaperConfig = JSON.parse(text) as WallpaperConfigDataJson;
      if (wallpaperConfig?.rectData?.rect) {
        return wallpaperConfig?.rectData?.rect as Rect;
      }
    } catch (e) {
      log.showError(`readCropRect error, code: ${e?.code}`);
    }
    return undefined;
  }

  protected async getWallpaper(isOuterScreen: boolean = false): Promise<image.PixelMap | undefined> {
    try {
      const wallpaperPath: string = this.getWallpaperPath(isOuterScreen);
      if (!wallpaperPath) {
        return isOuterScreen ? this.outerScreenWallpaper : this.wallpaper;
      }
      if (this.isWallpaperAllInOne && !isOuterScreen) {
        this.currentCropRect = this.readCropRect();
      }
      const cropImageSource = this.readWallpaper(wallpaperPath, isOuterScreen);
      log.showInfo(`succ get wallpaper,` +
        ` path is sys_A = ${wallpaperPath.includes(SANDBOX_THEME_PATH_SYSTEM_A)}`);
      return cropImageSource;
    } catch (e) {
      log.showError('Can not get sreenlock wallpaper, error');
    }
    return isOuterScreen ? this.outerScreenWallpaper : this.wallpaper;
  }

  /**
   * 获取当前锁屏主题配置
   *
   * @returns 锁屏主题配置
   */
  public getCurrentThemeParams(): Map<Qualifier, LockscreenThemeConfig> | undefined {
    return this.currentThemeParams;
  }

  /**
   * 根据壁纸类型获取壁纸
   *
   * @param wallpaperType 壁纸类型
   * @returns 壁纸图片
   */
  public async readWallpaper(wallpaperPath: string, isOuterScreen: boolean = false,
    cropRect?: Rect): Promise<image.PixelMap | undefined> {
    log.showInfo('readWallpaper');
    if(!cropRect) {
      cropRect = this.currentCropRect;
    }
    let wallpaper: image.PixelMap | undefined = undefined;
    let fd: number | undefined = undefined;
    let imageSource: image.ImageSource | undefined = undefined;
    if (!wallpaperPath) {
      log.showInfo('getWallpaper error, reason: can not resolve unlockThemePath');
      // 对于没有主题路径的场景（2v版本或模拟器）,则读取默认壁纸资源
      return isOuterScreen ? this.outerScreenWallpaper : this.wallpaper;
    }
    try {
      fd = (await fs.open(wallpaperPath, fs.OpenMode.READ_ONLY)).fd;
      imageSource = image.createImageSource(fd);
      const imageInfo: image.ImageInfo = await imageSource.getImageInfo();
      let decodingOptions: image.DecodingOptions;
      if (this.isWallpaperAllInOne && cropRect) {
        // 根据cropRect裁切壁纸
        decodingOptions = this.getDecodingOptions(imageInfo, cropRect);
      } else {
        // 当前壁纸图片大小为2772*2772，而直板机仅需1344*2772大小即可，对壁纸进行裁切保证内存最小
        decodingOptions = this.getDecodingOptions(imageInfo);
      }
      wallpaper = await imageSource.createPixelMap(decodingOptions);
      PixelMapUtil.addName(wallpaper, 'ScrLockThemeMgr_readWallpaper');
      log.showInfo('getWallpaper end');
    } catch (error) {
      log.showError('getWallpaper error, error :', error);
    } finally {
      if (imageSource) {
        await imageSource.release();
      }
      if (fd) {
        fs.closeSync(fd);
      }
    }
    return wallpaper;
  }

  protected getDecodingOptions(imageInfo: image.ImageInfo, cropRect?: Rect): image.DecodingOptions {
    if ((DeviceHelper.isFold() && !DeviceHelper.isSmallFoldProduct()) || DeviceHelper.isPadOr2in1PcType()) {
      return this.getFoldExpandOptions(cropRect);
    }
    return this.getNormalOptions(imageInfo, cropRect);
  }

  protected getFoldExpandOptions(cropRect?: Rect): image.DecodingOptions {
    let decodingOptions: image.DecodingOptions = {
      editable: true,
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
    };
    if (cropRect) {
      // 根据cropRect裁切壁纸
      decodingOptions = {
        editable: true,
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
        desiredRegion: {
          size: {
            height: cropRect.height, width: cropRect.width
          }, x: cropRect.x, y: cropRect.y
        }
      };
    }
    return decodingOptions;
  }

  protected getNormalOptions(imageInfo: image.ImageInfo, cropRect?: Rect): image.DecodingOptions {
    let decodingOptions: image.DecodingOptions = {
      editable: true,
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
    };
    try {
      let x: number = 0;
      let y: number = 0;
      let imageWidth: number = imageInfo.size.width;
      let imageHeight: number = imageInfo.size.height;
      if (cropRect) {
        x = cropRect.x;
        y = cropRect.y;
        imageWidth = cropRect.width;
        imageHeight = cropRect.height;
      }
      const displayData: display.Display = display.getDefaultDisplaySync();
      const screenWidth: number = displayData.width;
      const screenHeight: number = displayData.height;
      let displayRatio: number = screenHeight / screenWidth;
      let imageRatio: number = imageHeight / imageWidth;
      let isImageWider: boolean = imageRatio < displayRatio;
      // 将image宽高比转换为屏幕宽高比
      const alteredHeight: number = isImageWider ? imageHeight : displayRatio * imageWidth;
      const alteredWidth: number = isImageWider ? 1 / displayRatio * imageHeight : imageWidth;
      // 根据宽高比重新计算裁剪区域
      let horizontalRegionStart: number = imageWidth > alteredWidth ? (imageWidth - alteredWidth) / HALF : 0;
      let verticalRegionStart: number = imageHeight > alteredHeight ? (imageHeight - alteredHeight) / HALF : 0;
      x += horizontalRegionStart;
      y += verticalRegionStart;
      log.showInfo(`desiredRegion alteredHeight: ${alteredHeight}, alteredWidth: ${alteredWidth}, x: ${x}, y: ${y}`);
      decodingOptions = {
        editable: true,
        desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
        desiredRegion: {
          size: {
            height: alteredHeight, width: alteredWidth
          }, x: x, y: y
        },
        desiredSize: alteredHeight > screenHeight ? { height: screenHeight, width: screenWidth } : undefined
      };
    } catch (e) {
      log.showError('Can not get decodingOptions');
    }
    return decodingOptions;
  }

  protected loadWallpaper(): void {
    this.refreshThemeVersion();
    log.showInfo(`loadWallpaper, is wallpaper all in one: ${this.isWallpaperAllInOne}`);
    if (!this.wallpaper) {
      if (this.isWallpaperAllInOne) {
        this.currentCropRect = this.readCropRect();
      }
      log.showInfo('loadWallpaper...');
      WallpaperManager.getInstance().getWallpaperCache(WallpaperType.SCEENLOCK, TAG, false).then(image => {
        if (!ScreenLockApi.isScreenLockShow()) {
          log.showInfo('unlock, not need wallpaper.');
          return;
        }
        log.showInfo('load wallpaper');
        this.wallpaper = image;
        this.setSlWallpaperImg();
      });
    }
  }

  protected releaseWallpaper(): void {
    this.wallpaper = undefined;
    this.outerScreenWallpaper = undefined;
    log.showInfo('release wallpaper');
    WallpaperManager.getInstance().releaseWallpaperCache(WallpaperType.SCEENLOCK, TAG);
    WallpaperManager.getInstance().releaseWallpaperCache(WallpaperType.SCREENLOCK_SUBSCREEN, TAG);
    slWallpaperMgr.setSlWallpaperImg(SLWallpaperType.TYPE_ENGINE_THEME);
  }

  public isStaticWallpaper(): boolean {
    return this.isStatic;
  }

  public parseDescriptionData(): void {
    // 主题变更时先解注册，防止上一个生效的主题影响下一个主题
    eyeGazeSwingEvent.unSubscribe();

    const unlockThemePath: string | undefined = this.getCurrentThemePath();
    if (!unlockThemePath) {
      log.showError('Can not resolve unlockThemePath');
      return;
    }

    try {
      let manifestPath = unlockThemePath + DESCRIPTION_PATH;
      const text = fs.readTextSync(manifestPath);
      const test = JSON.parse(text) as DescriptionDataJson;
      const supportedModes: string[] = test?.supportedModes;
      let isSupportKeepWatching = supportedModes.some(supportedMode => supportedMode === 'KEEP_WATCHING');
      this._isGestureSupported = supportedModes.some(supportedMode => supportedMode === 'AIR_GESTURE');
      log.showInfo(`isSupportKeepWatching is ${isSupportKeepWatching}, Gesture support is ${this._isGestureSupported}`);
      eyeGazeSwingEvent.setCurrentThemeSupport(isSupportKeepWatching);
      this.parseLockDescriptionData(unlockThemePath);
    } catch (e) {
      log.showError(`Can not resolve static ${e?.code}`);
    }
  }

  private parseLockDescriptionData(unlockThemePath: string): void {
    try {
      let descriptionPath = unlockThemePath + '/lock' + DESCRIPTION_PATH;
      const text = fs.readTextSync(descriptionPath);
      const test = JSON.parse(text) as DescriptionLockDataJson;
      const interactive: string[] | undefined = test?.interactive;
      this.isInteractiveTheme = !!(interactive?.some(type => type === 'lock'));
      log.showInfo(`isInteractiveTheme =${this.isInteractiveTheme}`);
    } catch (e) {
      this.isInteractiveTheme = false;
      log.showError(`Can not resolve static ${e?.code}`);
    } finally {
      this.onThemeInteractiveChange?.();
    }
  }

  public parseManifestData(): void {
    const unlockThemePath: string | undefined = this.getCurrentThemePath();
    if (!unlockThemePath) {
      log.showError('Can not resolve unlockThemePath');
      return;
    }

    let lockColor = '';
    let homeColor = '';
    try {
      let manifestPath = unlockThemePath + MANIFEST_PATH;
      const text = fs.readTextSync(manifestPath);
      const manifestContent = JSON.parse(text) as ManifestContentDataJson;
      if (manifestContent?.clockColorForAod) {
        lockColor = manifestContent?.clockColorForAod;
      }
      this.isStatic = manifestContent.type === 'image';
      this.themeType = manifestContent.type;
      // 主题包默认时钟字体名
      let themeClockFont = this.getCheckFontFamily(manifestContent.clockFontFamily);
        this.clockFontFamily = themeClockFont;
      log.showInfo(`isStatic = ${this.isStatic}, themeType = ${this.themeType}, ${themeClockFont}`);
    } catch (e) {
      log.showError(`Can not resolve static ${e?.code}`);
    }

    try {
      let manifestPath = unlockThemePath + HOME_MANIFEST_PATH;
      const text = fs.readTextSync(manifestPath);
      const manifestContent = JSON.parse(text) as ManifestContentDataJson;
      if (manifestContent?.clockColorForAod) {
        homeColor = manifestContent?.clockColorForAod;
      }
    } catch (e) {
      log.showError(`Can not resolve aod manifest ${e?.code}`);
    }

    let aodClockColor: string | undefined = undefined;
    if (lockColor && homeColor && lockColor === homeColor) {
      aodClockColor = lockColor;
    }
    log.showInfo(`aodClockColor ${aodClockColor}`);
    slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.setSlState(ClockStaticStateType.AOD_CLOCK_COLOR,
      aodClockColor);
  }

  private getCheckFontFamily(oriFont?: string): string | undefined {
    if (!oriFont) {
      return undefined;
    }
    // 校验字体有效性
    return ALL_COM_FAMILY.find((font) => font === oriFont);
  }

  protected getCurrentThemePath(isOuterScreen: boolean = false): string | undefined {
    try {
      if (fs.accessSync(SANDBOX_THEME_PATH_FLAG_A)) {
        return isOuterScreen ? SANDBOX_THEME_PATH_SYSTEM_A + SUB_SCREEN_THEME_PATH : SANDBOX_THEME_PATH_SYSTEM_A;
      } else if (fs.accessSync(SANDBOX_THEME_PATH_FLAG_B)) {
        return isOuterScreen ? SANDBOX_THEME_PATH_SYSTEM_B + SUB_SCREEN_THEME_PATH : SANDBOX_THEME_PATH_SYSTEM_B;
      }
    } catch (e) {
      log.showError(`Check file access failed: ${e?.message}`);
    }
    return undefined;
  }

  public async getScreenLockThemeParams(isOuterScreen?: boolean): Promise<Map<Qualifier, LockscreenThemeConfig>> {
    if (isOuterScreen === undefined) {
      isOuterScreen = false;
    }
    const unlockThemePath: string | undefined = this.getCurrentThemePath(isOuterScreen);
    return this.readThemeParams(unlockThemePath, isOuterScreen);
  }

  protected async readThemeParams(unlockThemePath: string | undefined,
    isOuterScreen: boolean = false): Promise<Map<Qualifier, LockscreenThemeConfig>> {
    let defaultBaseConfig = this.getDefaultThemeParams(ThemeScene.BASE);
    let themeParams: Map<Qualifier, LockscreenThemeConfig> =
      new Map([[DEFAULT_SANDBOX_THEME_QUALIFIER, defaultBaseConfig]]);
    if (!unlockThemePath) {
      log.showError('Can not resolve unlockThemePath, return defaultParam');
      return themeParams;
    }

    try {
      SANDBOX_THEME_QUALIFIER.forEach((qualifier) => {
        if (DEFAULT_SANDBOX_THEME_QUALIFIER !== qualifier && !this.isSupportMultiSceneTheme) {
          return;
        }
        const themePath: string = unlockThemePath + `/lock/${qualifier}/config.json`;
        if (!fs.accessSync(themePath)) {
          log.info(`lockscreen config file not exists: ${qualifier}`);
          // 文件不存在，尝试默认主题样式
          let defaultParam = this.tryCreateDefaultThemeParams(qualifier, isOuterScreen);
          defaultParam && themeParams.set(qualifier, defaultParam);
          return;
        }
        const text = fs.readTextSync(themePath);

        if (!text) {
          log.info('lockscreen config file is empty');
          return;
        }
        let themeParam = this.parseAndValidateThemeParam(text, isOuterScreen);
        themeParams.set(qualifier, themeParam);
      });
      return themeParams;
    } catch (e) {
      log.showError('Can not read lockscreen style config, error');
    }
    return themeParams;
  }

  private tryCreateDefaultThemeParams(qualifier: string, isOuterScreen: boolean = false):
    LockscreenThemeConfig | undefined {
    // 存在主题字体，则默认配置主题样式
    let themeClockFont = isOuterScreen ? this.outerClockFontFamily : this.clockFontFamily;
    if (!Boolean(themeClockFont)) {
      return undefined;
    }
    let defaultCfg = ObjectCopyUtil.deepClone(this.getDefaultThemeParams(qualifier));
    // 替换主题字体
    this.trySetThemeClockFont(defaultCfg.clock, isOuterScreen);
    return defaultCfg;
  }

  /**
   * 多形态默认主题样式
   *
   * @param qualifier 形态
   * @returns 默认主题样式
   */
  public getDefaultThemeParams(qualifier: string = ThemeScene.BASE): LockscreenThemeConfig {
    // 多形态默认样式
    if (qualifier === ThemeScene.BASE) {
      return this.isSupportMultiSceneTheme ? defaultPortraitThemeParam : defaultThemeParam;
    }
    if (DeviceHelper.isUltraScreenProduct()) {
      let gSateThemeParam = ObjectCopyUtil.deepClone(defaultThemeParam);
      this.setGStateDefaultThemeParam(qualifier, gSateThemeParam);
      return gSateThemeParam;
    }
    return defaultThemeParam;
  }

  public getDefaultClockParams(currentQualifier: string = this.getCurrentThemeQualifier()): LockscreenThemeConfig {
    const currentThemeParam:LockscreenThemeConfig = this.getDefaultThemeParams(currentQualifier);
    if (DeviceHelper.isUltraScreenProduct()) {
      if (DisplayUtils.getUltraScreenStatus() === UltraScreenStatus.M_STATUS) {
        currentThemeParam.clock.positionX = CLOCK_M_POSITION_X;
      } else if (DisplayUtils.getUltraScreenStatus() === UltraScreenStatus.G_STATUS) {
        currentThemeParam.clock.positionX = CLOCK_G_POSITION_X;
      } else {
        currentThemeParam.clock.positionX = CLOCK_F_POSITION_X;
      }
    }
    return currentThemeParam;
  }

  /**
   * 超大屏G态默认样式
   *
   * @param qualifier 形态
   * @param sourceParam 原样式
   */
  public setGStateDefaultThemeParam(qualifier: string, sourceParam: LockscreenThemeConfig): void {
    if (qualifier === ThemeScene.UNFOLDED2 || qualifier === ThemeScene.LAND_UNFOLDED2) {
      sourceParam.clock.layout = ClockLayout.NORMAL_CLOCK_LAYOUT;
      sourceParam.clock.fontFamily = ClockComFamily.HARMONY_CLOCK_ULT_2_4;
      if (qualifier === ThemeScene.UNFOLDED2) {
        sourceParam.clock.positionX = DEFAULT_CLOCK_POSITIONX;
      } else {
        sourceParam.clock.positionX = WIDESCREEN_DEFAULT_CLOCK_POSITIONX;
      }
    }
  }

  public getScrenLockHigtFingerThemeParams(): string | undefined {
    const fingerThemePath: string | undefined = this.getCurrentThemePath();
    if (!fingerThemePath) {
      log.showError('Can not resolve unlockThemePath, return undefined fingerPrint');
      return undefined;
    }
    try {
      const fingerThemeFile: string | undefined = fingerThemePath + SANDBOX_THEME_PATH_FINGER;
      if (!fs.accessSync(fingerThemeFile)) {
        log.showError('lockscreen config file not exists fingerPrint');
        return undefined;
      }
      const text = fs.readTextSync(fingerThemeFile);
      if (!text) {
        log.showWarn('lockscreen config file is empty fingerPrint');
        return undefined;
      }
      return fingerThemeFile;
    } catch (error) {
      log.showError('Can not read lockscreen style config fingerPrint, error:' + error);
    }
    return undefined;
  }

  protected parseAndValidateThemeParam(data: string, isOuterScreen: boolean = false): LockscreenThemeConfig {
    try {
      const themeData: LockscreenThemeConfig = JSON.parse(data);
      // config.json中的字体优先级更高
      let hasFont = Boolean(themeData?.clock?.fontFamily);
      let clockConfigData: IThemeParam = this.parseClockConfig(themeData?.clock ||
      this.getDefaultClockThemeParam(isOuterScreen));
      log.showInfo(`parseAndValidateThemeParam: ${hasFont}, ${clockConfigData?.layout}, ${clockConfigData?.positionX}`);
      // 无优先级字体时，取manifest.json中字体
      if (!hasFont) {
        this.trySetThemeClockFont(clockConfigData, isOuterScreen);
      }
      let fromConfigData: LockscreenForm | undefined = this.parseFormConfig(themeData?.form || defaultFormParam);
      if (fromConfigData) {
        return {
          clock: clockConfigData,
          form: fromConfigData,
        }
      }
    } catch (e) {
      log.showError(`Parse theme param error: ${e?.message}`);
    }

    return defaultThemeParam;
  }

  private trySetThemeClockFont(clockCfg: IThemeParam, isOuterScreen: boolean = false): void {
    if (!clockCfg) {
      return;
    }
    // 取主题中manifest.json中字体
    let themeClockFont = isOuterScreen ? this.outerClockFontFamily : this.clockFontFamily;
    if (themeClockFont && Boolean(themeClockFont)) {
      let matchFont = this.getMatchFontFamily(clockCfg.layout, themeClockFont);
      if (matchFont) {
        clockCfg.fontFamily = matchFont;
      }
    }
  }

  private getMatchFontFamily(clockType: ClockLayout, themeFont: string): string | undefined {
    // 当主题配置字体为UD字体时，需匹配对应时钟样式下的UD字体
    let isUDFont = themeFont === ClockComFamily.HARMONY_CLOCK_ULT_01 ||
      themeFont === ClockComFamily.HARMONY_CLOCK_ULT_2_4;
    if (isUDFont) {
      // 1号时钟样式
      if (clockType === ClockLayout.DEFAULT_CLOCK_LAYOUT) {
        return ClockComFamily.HARMONY_CLOCK_ULT_01;
      }
      // 2/3/4号时钟样式
      if (clockType === ClockLayout.NORMAL_CLOCK_LAYOUT ||
        clockType === ClockLayout.NORMAL_CLOCK_LAYOUT_LEFT ||
        clockType === ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL) {
        return ClockComFamily.HARMONY_CLOCK_ULT_2_4;
      }
      // 其他样式，不支持UD
      return undefined;
    }
    // 非UD直接保持主题配置
    return themeFont;
  }

  private getDefaultClockThemeParam(isOuterScreen: boolean = false): IThemeParam {
    if (isOuterScreen) {
      defaultSinglePocketThemeParam.clock.positionX = SINGLE_DISPLAY_POCKET_DEFAULT_CLOCK_POSITIONX;
      return defaultSinglePocketThemeParam.clock;
    }
    return defaultClockParam;
  }

  protected parseClockConfig(clockConfigParam: IThemeParam): IThemeParam {
    let clockConfigData: IThemeParam = clockConfigParam || defaultClockParam;
    clockConfigData.positionX = clockConfigParam.positionX ?? defaultClockParam.positionX;
    clockConfigData.positionY = clockConfigParam.positionY ?? defaultClockParam.positionY;
    clockConfigData.layout = clockConfigParam.layout ?? defaultClockParam.layout;
    clockConfigData.textShadow = clockConfigParam.textShadow ?? defaultClockParam.textShadow;
    clockConfigData.textBlurEffect = clockConfigParam.textBlurEffect ?? defaultClockParam.textBlurEffect;
    clockConfigData.signatureText = clockConfigParam.signatureText ?? defaultClockParam.signatureText;
    clockConfigData.editStatus = clockConfigParam.editStatus ?? defaultClockParam.editStatus;
    clockConfigData.dateVisible = clockConfigParam.dateVisible ?? defaultClockParam.dateVisible;
    clockConfigData.lunarVisible = clockConfigParam.lunarVisible ?? defaultClockParam.lunarVisible;
    clockConfigData.signatureVisible = clockConfigParam.signatureVisible ?? defaultClockParam.signatureVisible;
    clockConfigData.textAlign = clockConfigParam.textAlign ?? defaultClockParam.textAlign;
    clockConfigData.color = clockConfigParam.color ?? defaultClockParam.color;
    clockConfigData.fontFamily = clockConfigParam.fontFamily ?? defaultClockParam.fontFamily;
    clockConfigData.aestheticColorArgs = clockConfigParam.aestheticColorArgs ?? defaultClockParam.aestheticColorArgs;
    clockConfigData.isLightWallpaper = clockConfigParam.isLightWallpaper ?? defaultClockParam.isLightWallpaper;
    clockConfigData.isDof = clockConfigParam.isDof ?? defaultClockParam.isDof;
    clockConfigData.clockDegree = clockConfigParam.clockDegree ?? defaultClockParam.clockDegree;
    clockConfigData.version = clockConfigParam.version ?? 0;

    // handle illegal layout
    if (!Object.values(ClockLayout).includes(clockConfigData.layout.valueOf())) {
      clockConfigData.layout = defaultClockParam.layout;
    }
    return clockConfigData;
  }

  protected parseFormConfig(formDataParam: LockscreenForm): LockscreenForm | undefined {
    if (!formDataParam) {
      log.showInfo('formDataParam is undefined');
      return undefined;
    }
    let result: LockscreenForm = {
      list: this.parseFormListConfig(formDataParam.list),
      positionY: formDataParam.positionY,
    };
    return result;
  }

  private parseFormListConfig(formListDataParam: LockscreenFormConfig[]): LockscreenFormConfig[] {
    try {
      if (!formListDataParam || formListDataParam.length > 4) {
        log.showInfo('Invalid config Info from theme package.');
        return [];
      }

      log.showInfo('parse form param success');
      return formListDataParam;
    } catch (e) {
      log.showError(`Parse theme param error: ${e?.message}`);
    }

    return [];
  }

  private refreshThemeVersion(): void {
    try {
      const unlockThemePath: string | undefined = this.getCurrentThemePath();
      if (!unlockThemePath) {
        log.showError('Can not resolve unlockThemePath, unlockThemePath is undefined');
        return;
      }
      const wallpaperConfigPath: string = unlockThemePath + '/lock/base/wallpaper_config.json';

      if (!fs.accessSync(wallpaperConfigPath)) {
        log.showError('base wallpaper config file not exists');
        return;
      }
      const text: string = fs.readTextSync(wallpaperConfigPath);
      if (!text) {
        log.showError('wallpaper config file is empty');
        return;
      }
      if (JSON.parse(text)?.versionCode) {
        const version: string = String(JSON.parse(text).versionCode);
        this.isWallpaperAllInOne = (version === VERSION_CODE_5_1);
      }
    } catch (error) {
      log.showError('Can not read wallpaper config, errorCode:' + error?.code);
    }
  }

  private getCurrentThemeQualifier(): string {
    const slStaticState: ISlState | undefined = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);
    const isFoldExpand: boolean = slStaticState?.getSlState(SlStaticStateType.FOLD_EXPAND_STATE) as boolean ?? false;
    const isPortrait: boolean = DisplayStateManager.getInstance().isPortrait() ?? false;

    log.showInfo(`isPortrait: ${isPortrait}, foldExpand: ${isFoldExpand}`);

    if (DeviceHelper.isPadOr2in1PcType()) {
      if (isPortrait) {
        return ThemeScene.BASE;
      } else {
        return ThemeScene.LAND;
      }
    } else if (DeviceHelper.isLargeInFoldProduct()) {
      if (isFoldExpand) {
        if (isPortrait) {
          return ThemeScene.UNFOLDED;
        } else {
          return ThemeScene.LAND_UNFOLDED;
        }
      } else {
        return ThemeScene.BASE;
      }
    }
    return ThemeScene.BASE;
  }

  /**
   * 当前主题是否互动类型
   *
   * @return 是否互动类型
   */
  public isInteractiveCurrentTheme(): boolean {
    return this.isInteractiveTheme;
  }

  public notifyUpdateCardStyle(styleParam: string): void {
    if (styleParam.includes('HarmonyClockArt')) {
      log.showInfo('skip notifyUpdateCardStyle, reason: HarmonyClockArt');
      return;
    }
    try {
      PageDesktopOneShotManager.getInstance().notifyUpdateCardStyle(styleParam);
    } catch (e) {
      log.showError(`Failed to notify update card style, error code = ${e.code}`);
    }
  }

  /**
   * 获取锁屏壁纸原图
   */
  public async getWallpaperSource(): Promise<image.PixelMap | undefined> {
    let wallpaperPath = this.getWallpaperPath();
    if (!wallpaperPath) {
      log.showInfo('get source wallpaper error, reason: can not resolve unlockThemePath');
      return undefined;
    }
    let wallpaper: image.PixelMap | undefined = undefined;
    let fd: number | undefined = undefined;
    let imageSource: image.ImageSource | undefined = undefined;

    try {
      fd = (await fs.open(wallpaperPath, fs.OpenMode.READ_ONLY)).fd;
      imageSource = image.createImageSource(fd);
      wallpaper = await imageSource.createPixelMap();
      PixelMapUtil.addName(wallpaper, 'ScrLockThemeMgr_SourceWallpaper');
      log.showInfo('getWallpaper end');
    } catch (error) {
      log.showError('getWallpaper error, error :', error?.code);
    } finally {
      if (imageSource) {
        await imageSource.release();
      }
      if (fd) {
        FileUtil.closeFile(fd);
      }
    }
    return wallpaper;
  }
}

export function getDefaultPositionX(): number {
  if (DeviceHelper.isPcNot2in1Device()) {
    return PC_DEFAULT_CLOCK_POSITIONX;
  } else if (DeviceHelper.isPadOr2in1PcType() ||
      DeviceHelper.isFoldButNotSmallFoldProduct() || (
      DeviceHelper.isUltraScreenProduct() && !DeviceHelper.isFState()
  )) {
    return WIDESCREEN_DEFAULT_CLOCK_POSITIONX;
  } else {
    return DEFAULT_CLOCK_POSITIONX;
  }
}

function getDefaultPositionY(): number {
  return DeviceHelper.isPcNot2in1Device() ? PC_DEFAULT_CLOCK_POSITIONY : DEFAULT_CLOCK_POSITIONY;
}

function getDefaultLayout(): ClockLayout {
  if (DeviceHelper.isPhone()) {
    return ClockLayout.DEFAULT_CLOCK_LAYOUT;
  } else if (DeviceHelper.isPadOr2in1PcType()) {
    return ClockLayout.NORMAL_CLOCK_LAYOUT;
  } else {
    return ClockLayout.DIMENSION_2_4;
  }
}
