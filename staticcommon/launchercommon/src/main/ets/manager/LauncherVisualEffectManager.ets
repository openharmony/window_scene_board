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
  BlurEffect,
  BlurEffectType,
  VisualEffectConstants,
  StartExitMotionLevel,
} from '@ohos/commonconstants/src/main/ets/constants/VisualEffectConstants';
import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import { StateEx, SCBVisualEffectMgr } from '@ohos/componenthelper';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { editModeManager } from '../TsIndex';
import { ScenePanelState } from '@ohos/windowscene/src/main/ets/TsIndex';
import { folderGesData } from '../folder/model/FolderGestureData';
import { FolderManager } from '../folder/next/common/model/FolderManager'
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import power from '@ohos.power';
import { StartAndExitVisualEffectManager } from './StartAndExitVisualEffectManager';

const TAG: string = 'LauncherVisualEffectManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const ONE_STEP_DEFAULT: number = 0;
const ONE_STEP_SHOW_BG_AND_ICON: number = 2;
const ONE_STEP_ENTER_SPLIT: number = 3;
const ONE_STEP_ENTER_FLOATING: number = 4;
const ONE_STEP_ENTER_MID_SCENE: number = 5;
const MASK_COLOR_FOR_DEFAULT: string = '#19000000';
const MASK_COLOR_RECENT_LIGHT: string = '#3F000000';
const MASK_COLOR_RECENT_DARK: string = '#38000000';
const MASK_COLOR_FOLDER_LIGHT: string = '#12000000';
const MASK_COLOR_FOLDER_DARK: string = '#66000000';
const MASK_COLOR_NEGATIVE_DARK: string = '#4D000000';
const MASK_COLOR_GLOBALSEARCH_DARK: string = '#66000000';
const DARK_COLOR_MODE: number = 0;
const LIGHT_COLOR_MODE: number = 1;

/**
 * 多任务视效框管理类
 */
export class LauncherVisualEffectManager {
  // 控制桌面是否透明
  public launcherOpacity: StateEx<number> = new StateEx(1);
  // 是否使用模糊合并，默认关闭
  public isUseEffect: boolean = false;
  // 壁纸模糊效果是否开启
  public isWallpaperBlurEffect: StateEx<boolean> = new StateEx(false);
  // 控制壁纸模糊效果是否透明
  public wallpaperBlurOpacity: StateEx<number> = new StateEx(0);
  // 适配动效期间堆叠卡片背景blendMode效果
  public isBlurAnimRunning: StateEx<boolean> = new StateEx(false);
  // 是否显示蒙版
  public isShowMask: StateEx<boolean> = new StateEx(false);
  // 蒙版颜色
  public maskColor: StateEx<string> = new StateEx(MASK_COLOR_FOR_DEFAULT);
  //是否显示文件夹壁纸模糊效果
  public isShowFolderBlurEffect: StateEx<boolean> = new StateEx(false);
  public isShowGlobalSearchBlurEffect: StateEx<boolean> = new StateEx(false);
  private readonly ANIMATION_CURVE: string = 'cubic-bezier(0.10, 0.34, 0.33, 1.00)';
  // 当多任务显示时，控制其它视图是否透明，如负一屏、全搜、编辑模式等
  private othersOpacity: StateEx<number> = new StateEx(1);
  private folderOpacity: StateEx<number> = new StateEx(1);
  private editModeButtonOpacity: StateEx<number> = new StateEx(1);
  private isShowUIExtension: boolean = false;
  private blurEffect: BlurEffect = new BlurEffect();
  private isRecentBlurEffectDisable: boolean = false;
  private isNegativeBlurEffectDisable: boolean = false;
  private isFolderBlurEffectDisable: boolean = false;
  private isGlobalSearchBlurEffectDisable: boolean = false;
  private isLauncherSwiperCustomEnable: boolean = false;
  private isLauncherOpAnimDisable: boolean = false;
  private colorMode: number = 0;
  private isTransitionBlurEffectDisable: boolean = false;
  private isPowerSaveMode: boolean = false;
  private mSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
    events: [
      commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED
    ]
  };

  /**
   * 获取视效json文件中的相关参数
   */
  public initParams(): void {
    this.isRecentBlurEffectDisable =
      SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.IS_RECENT_BLUR_DISABLED);
    this.isNegativeBlurEffectDisable =
      SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.IS_NEGATIVESCREEN_BLUR_DISABLED);
    this.isFolderBlurEffectDisable =
      SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.FOLDER_BLUR_EFFECT_DISABLE);
    this.isGlobalSearchBlurEffectDisable =
      SCBVisualEffectMgr.getFeatureParam(VisualEffectConstants.GLOBAL_SEARCH_BLUR_EFFECT_DISABLE) === 'true';
    this.isLauncherSwiperCustomEnable =
      SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.LAUNCHER_SWIPER_CUSTOM_ENABLED);
    this.colorMode = GlobalContext.getContext().config.colorMode as number;
    const startExitMotionLevel: StartExitMotionLevel =
      SCBVisualEffectMgr.getStartExitMotionLevel(VisualEffectConstants.ICON_START_EXIT_MOTION_BLUR_LEVEL);
    const isStartExitBlurDisable =
      SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.ICON_START_EXIT_BLUR_DISABLE);
    this.isTransitionBlurEffectDisable =
      !isStartExitBlurDisable && startExitMotionLevel === StartExitMotionLevel.WALLPAPER_BLUR;
    this.initPowerMode();
    this.registerPowerSaveModeChange();
  }

  /**
   * 初始化电池模式
   */
  private initPowerMode(): void {
    let curPowerMode: power.DevicePowerMode = power.DevicePowerMode.MODE_NORMAL;
    try {
      curPowerMode = power.getPowerMode();
    } catch (err) {
      log.showError(`Get device power mode failed , err: ${err?.code}, errMessage: ${err?.message}`);
    }
    if (curPowerMode === power.DevicePowerMode.MODE_POWER_SAVE ||
      curPowerMode === power.DevicePowerMode.MODE_EXTREME_POWER_SAVE) {
      this.isPowerSaveMode = true;
      StartAndExitVisualEffectManager.getInstance().setIsPowerSaveMode(true);
    }
    this.updateFolderBlurEffect();
    this.updateGlobalSearchBlurEffect();
  }

  /**
   * 监听电池模式的改变
   */
  private registerPowerSaveModeChange(): void {
    log.showWarn('register power save mode change event');
    this.mSubscriber = commonEventManager.createSubscriberSync(this.subscribeInfo);
    if (this.mSubscriber === null) {
      log.showError(`create subscriber error!`);
      return;
    }
    commonEventManager.subscribe(this.mSubscriber,
      (err: BusinessError, data: commonEventManager.CommonEventData) => {
        if (err) {
          log.showError(`Can't handle common event, err: ${err.code}, err: ${err.message}`);
          return;
        }
        if (data?.event === commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED) {
          log.showWarn(`power mode changed, current mode: ${data.code}`);
          if (data.code === power.DevicePowerMode.MODE_POWER_SAVE ||
            data.code === power.DevicePowerMode.MODE_EXTREME_POWER_SAVE) {
            this.isPowerSaveMode = true;
            StartAndExitVisualEffectManager.getInstance().setIsPowerSaveMode(true);
            if (!this.isRecentBlurEffectDisable) {
              this.registerRecentBlurEvent();
              this.registerIconStartExitBlurEvent();
              this.registerFolderFullBlurEvent();
            }
          } else {
            this.isPowerSaveMode = false;
            this.isLauncherOpAnimDisable = false;
            StartAndExitVisualEffectManager.getInstance().setIsPowerSaveMode(false);
            this.updateFolderBlurEffect();
            this.updateGlobalSearchBlurEffect();
          }
        }
      });
  }

  /**
   * 多任务是否禁用实时模糊
   * @returns true：禁用模糊， false：不禁用
   */
  public isRecentBlurEffectDisabled(): boolean {
    log.showDebug(`isRecentDisable: ${this.isRecentBlurEffectDisable} ${this.isPowerSaveMode}
      ${this.blurEffect.isRecentBlurEffect}`);
    return this.isRecentBlurEffectDisable || this.isPowerSaveMode || this.blurEffect.isRecentBlurEffect ||
      this.launcherOpacity.value !== 1;
  }

  /**
   * 负一屏是否禁用实时模糊
   * @returns true：禁用模糊， false：不禁用
   */
  public isNegativeBlurEffectDisabled(): boolean {
    return this.isNegativeBlurEffectDisable || this.isPowerSaveMode || this.blurEffect.isNegativeScreenEffect;
  }

  /**
   * 全搜是否禁用实时模糊
   * @returns true：禁用模糊， false：不禁用
   */
  public isGlobalSearchBlurEffectDisabled(): boolean {
    let isGlobalSearchDisabled: boolean = this.isGlobalSearchBlurEffectDisable || this.isPowerSaveMode ||
      this.blurEffect.isGlobalSearchEffect;
    log.showWarn(`isGlobalSearchBlurEffectDisabled ${isGlobalSearchDisabled}`);
    return isGlobalSearchDisabled;
  }

  /**
   * 文件夹是否禁用实时模糊
   * @returns true：禁用模糊， false：不禁用
   */
  public isFolderBlurEffectDisabled(): boolean {
    let isFolderEffect = this.isFolderBlurEffectDisable || this.isPowerSaveMode || this.blurEffect.isFolderBlurEffect;
    log.showWarn(`isFolderDisabled ${isFolderEffect}`);
    return isFolderEffect;
  }

  /**
   * 启动退出是否禁用实时模糊
   * @returns true：禁用模糊， false：不禁用
   */
  public isTransitionBlurEffectDisabled(): boolean {
    return this.isTransitionBlurEffectDisable;
  }

  /**
   * 注册多任务模糊监听器
   */
  public registerRecentBlurEvent(): void {
    if (this.isRecentBlurEffectDisabled()) {
      log.showInfo('registerRecentBlurEvent success');
      GlobalContext.getContext()?.eventHub.on(VisualEffectConstants.IS_RECENT_BLUR_EFFECT,
        (isEnabled: boolean, blurAnimDelayTime: number) =>
        this.startBlurAnim(isEnabled, BlurEffectType.RECENT, false, blurAnimDelayTime));
    }
  }

  /**
   * 反注册多任务模糊监听器
   */
  public unRegisterRecentBlurEvent(): void {
    if (this.isRecentBlurEffectDisable || (!this.isPowerSaveMode && !this.blurEffect.isRecentBlurEffect)) {
      log.showInfo('unRegisterRecentBlurEvent success');
      GlobalContext.getContext()?.eventHub.off(VisualEffectConstants.IS_RECENT_BLUR_EFFECT);
    }
  }

  /**
   * 多任务模糊事件触发
   */
  public triggerRecentBlurEvent(isEnabled: boolean): void {
    if (this.isRecentBlurEffectDisabled()) {
      GlobalContext.getContext()?.eventHub.emit(VisualEffectConstants.IS_RECENT_BLUR_EFFECT, isEnabled);
    }
  }


  /**
   * 注册启动退出模糊监听器
   */
  public registerIconStartExitBlurEvent(): void {
    if (this.isTransitionBlurEffectDisable) {
      GlobalContext.getContext()?.eventHub.on(VisualEffectConstants.ICON_START_EXIT_BLUR_EFFECT,
        (isEnabled: boolean, blurAnimDelayTime: number) =>
        this.startBlurAnim(isEnabled, BlurEffectType.ICON_START_EXIT, false, blurAnimDelayTime));
    }
  }

  /**
   * 反注册启动退出模糊监听器
   */
  public unRegisterIconStartExitBlurEvent(): void {
    if (this.isTransitionBlurEffectDisable) {
      GlobalContext.getContext()?.eventHub.off(VisualEffectConstants.ICON_START_EXIT_BLUR_EFFECT);
    }
  }

  /**
   * 启动退出模糊事件触发
   */
  public triggerIconStartExitBlurEvent(isEnabled: boolean): void {
    if (this.isTransitionBlurEffectDisable) {
      GlobalContext.getContext()?.eventHub.emit(VisualEffectConstants.ICON_START_EXIT_BLUR_EFFECT, isEnabled);
    }
  }

  /**
   * 根据ScenePanel状态触发多任务动效，并识别桌面是否需要做淡入淡出动效
   * @param fromState 上一个ScenePanel状态
   * @param curState 当前ScenePanel状态
   * @param blurAnimDelayTime 壁纸模糊动效的延时
   * @returns true: 启用壁纸模糊效果, false: 不启用壁纸模糊效果
   */
  public triggerDesktopBlurByPanelState(fromState: ScenePanelState, curState: ScenePanelState,
    blurAnimDelayTime?: number): boolean {
    log.showInfo(`triggerDesktopBlurByPanelState blurAnimDelayTime:${blurAnimDelayTime}, fromState: ${fromState}, curState: ${curState}`);
    this.isLauncherOpAnimDisable = this.isLauncherOpAnimDisabled(fromState, curState);
    let isBlurEnabled: boolean = curState === ScenePanelState.RECENT || curState === ScenePanelState.QUICK_SWITCH;
    if (fromState !== ScenePanelState.QUICK_SWITCH || curState !== ScenePanelState.FULLSCENE) {
      GlobalContext.getContext()?.eventHub.emit(
        VisualEffectConstants.IS_RECENT_BLUR_EFFECT, isBlurEnabled, blurAnimDelayTime);
    }
    return isBlurEnabled;
  }

  /**
   * 根据分屏多窗状态触发多任务动效，并识别桌面是否需要做淡入淡出动效
   * @param fromState 上一个OneStep状态
   * @param curState 当前OneStep状态
   */
  public triggerDesktopBlurByOneStepState(fromState: number, curState: number): void {
    if (!this.isRecentBlurEffectDisable || fromState !== ONE_STEP_DEFAULT || (curState !== ONE_STEP_SHOW_BG_AND_ICON &&
      curState !== ONE_STEP_ENTER_SPLIT && curState !== ONE_STEP_ENTER_FLOATING &&
      curState !== ONE_STEP_ENTER_MID_SCENE)) {
      return;
    }
    log.showInfo('triggerDesktopBlurByOneStepState');
    this.isLauncherOpAnimDisable = true;
    GlobalContext.getContext()?.eventHub.emit(VisualEffectConstants.IS_RECENT_BLUR_EFFECT, true);
  }

  /**
   * 退出壁纸模糊效果, 保证此场景下桌面透明渐变效果启用
   */
  public exitBlurWithLauncherOpAnim(blurAnimDelayTime: number = 0): void {
    if (this.isRecentBlurEffectDisabled()) {
      log.showInfo('exitBlurWithLauncherOpAnim');
      this.isLauncherOpAnimDisable = false;
      GlobalContext.getContext()?.eventHub.emit(VisualEffectConstants.IS_RECENT_BLUR_EFFECT, false, blurAnimDelayTime);
    }
  }

  /**
   * 多任务快切场景下，等快切动效结束后退出模糊
   */
  public exitBlurWithoutAnim(): void {
    if (this.isRecentBlurEffectDisabled()) {
      log.showInfo('exitBlurWithoutAnim');
      this.onBlurAnimEvent(false, BlurEffectType.RECENT);
    }
  }

  /**
   * 注册文件夹模糊监听器
   */
  public registerFolderFullBlurEvent(): void {
    if (this.isFolderBlurEffectDisabled()) {
      GlobalContext.getContext()?.eventHub.on(VisualEffectConstants.FOLDER_BLUR_EFFECT,
        (effectValue: boolean, isFolderClosed: boolean) =>
        this.startBlurAnim(effectValue, BlurEffectType.FOLDER, isFolderClosed));
    }
  }

  /**
   * 反注册文件夹模糊监听器
   */
  public unRegisterFolderFullBlurEvent(): void {
    if (this.isFolderBlurEffectDisable || (!this.isPowerSaveMode && !this.blurEffect.isFolderBlurEffect)) {
      GlobalContext.getContext()?.eventHub.off(VisualEffectConstants.FOLDER_BLUR_EFFECT);
    }
  }

  /**
   * 文件夹模糊事件触发
   * @returns true：触发， false：不触发
   */
  public triggerFolderFullBlurEvent(isEnabled: boolean): boolean {
    if (this.isFolderBlurEffectDisabled()) {
      if (editModeManager.isInEditMode()) {
        this.updateBlurEffect(isEnabled, BlurEffectType.EDIT_MODE_FOLDER);
        AppStorage.setOrCreate('editModeFolderBlurEffect', isEnabled);
      } else {
        GlobalContext.getContext()?.eventHub.emit(VisualEffectConstants.FOLDER_BLUR_EFFECT, isEnabled, false);
      }
      this.updateFolderBlurEffect();
      return true;
    }
    return false;
  }

  /**
   * 返回模糊触发场景
   * @returns true：触发， false：不触发, undefined: 不触发
   */
  public isBlurEffectEnabledByType(effectType: BlurEffectType): boolean | undefined {
    switch (effectType) {
      case BlurEffectType.RECENT:
        return this.blurEffect.isRecentBlurEffect;
      case BlurEffectType.NEGATIVE_SCREEN:
        return this.blurEffect.isNegativeScreenEffect;
      case BlurEffectType.FOLDER:
        return this.blurEffect.isFolderBlurEffect;
      case BlurEffectType.EDIT_MODE_FOLDER:
        return this.blurEffect.isEditModeFolderEffect;
      case BlurEffectType.GLOBAL_SEARCH:
        return this.blurEffect.isGlobalSearchEffect;
      case BlurEffectType.ICON_START_EXIT:
        return this.blurEffect.isStartExitBlurEffect;
      default:
        return undefined;
    }
  }

  /**
   * 从应用内手势上滑前隐藏桌面，避免后续跟手时漏桌面图标
   */
  public hideLauncher(): void {
    if (launcherVisualEffectMgr.isRecentBlurEffectDisabled() && this.launcherOpacity.value === 1) {
      log.showWarn('hideLauncher');
      this.launcherOpacity.value = 0;
    }
  }

  private isLauncherOpAnimDisabled(fromState: ScenePanelState, curState: ScenePanelState): boolean {
    return this.launcherOpacity.value === 0 &&
      (fromState === ScenePanelState.RECENT && curState === ScenePanelState.FULLSCENE ||
        fromState === ScenePanelState.FULLSCENE && curState === ScenePanelState.RECENT ||
        fromState === ScenePanelState.FULLSCENE && curState === ScenePanelState.QUICK_SWITCH ||
        fromState === ScenePanelState.QUICK_SWITCH && curState === ScenePanelState.FULLSCENE ||
        fromState === ScenePanelState.HOME && curState === ScenePanelState.QUICK_SWITCH);
  }

  /**
   * 是否启用壁纸模糊效果
   * @returns true：启用， false：不启用
   */
  private isWallpaperBlurEffectEnabled(): boolean {
    const isWallpaperBlurEffectEnabled: boolean =
      this.blurEffect.isRecentBlurEffect || this.blurEffect.isNegativeScreenEffect ||
      this.blurEffect.isFolderBlurEffect || this.blurEffect.isGlobalSearchEffect ||
      this.blurEffect.isStartExitBlurEffect
    log.showWarn(`isWallpaperBlurEffectEnabled: ${isWallpaperBlurEffectEnabled}, isRecentBlurEffect: ` +
      `${this.blurEffect.isRecentBlurEffect}, isNegativeScreenEffect: ${this.blurEffect.isNegativeScreenEffect}` +
      `isFolderBlurEffect: ${this.blurEffect.isFolderBlurEffect}, isGlobalSearchEffect:` +
      `${this.blurEffect.isGlobalSearchEffect}, isStartExitBlurEffect: ${this.blurEffect.isStartExitBlurEffect}`);
    return isWallpaperBlurEffectEnabled;
  }

  private checkBlurAnimIsInvalid(newState: boolean, effectType: BlurEffectType): boolean {
    let oldState: boolean | undefined = this.isBlurEffectEnabledByType(effectType);
    log.showWarn(`oldState: ${oldState}, newState: ${newState} effectType: ${effectType}`);
    if (oldState === newState) {
      if (newState) {
        return this.launcherOpacity.value === 0 && this.wallpaperBlurOpacity.value === 1;
      } else {
        return this.launcherOpacity.value === 1 && this.wallpaperBlurOpacity.value === 0;
      }
    }
    return false;
  }

  private startBlurAnim(isEnabled: boolean, effectType: BlurEffectType, isFolderClosed: boolean = false,
    blurAnimDelayTime: number = 0): void {
    log.showWarn(`startBlurAnim isEnabled: ${isEnabled}, effectType: ${effectType}`);
    if (this.checkBlurAnimIsInvalid(isEnabled, effectType)) {
      log.showWarn('checkBlurAnimIsInvalid return.');
      return;
    }
    if (effectType === BlurEffectType.ICON_START_EXIT && !isEnabled) {
      this.updateBlurEffect(isEnabled, effectType);
      return;
    }
    if (effectType === BlurEffectType.ICON_START_EXIT && isEnabled) {
      this.onPreBlurAnim(effectType);
      animateToImmediately({
        duration: 100,
        curve: Curve.Smooth,
        onFinish: () => {
          this.onBlurAnimFinish();
        }
      }, () => {
        this.isUseEffect = true;
        this.updateBlurEffect(isEnabled, effectType);
        this.setWallpaperBlurActive();
      });
      return;
    }

    if (isFolderClosed) {
      this.onBlurAnimEvent(isEnabled, effectType);
    } else {
      this.onPreBlurAnim(effectType);
      animateTo({
        delay: blurAnimDelayTime,
        duration: 200,
        curve: effectType === BlurEffectType.RECENT ? this.ANIMATION_CURVE : Curve.Smooth,
        onFinish: () => {
          this.onBlurAnimFinish();
        }
      }, () => {
        this.isUseEffect = true;
        this.onBlurAnimEvent(isEnabled, effectType);
      });
    }
  }

  private onBlurAnimEvent(isEnabled: boolean, effectType: BlurEffectType, progress: number = -1): void {
    this.updateBlurEffect(isEnabled, effectType);
    this.addMaskByBlurEffect();
    this.setLauncherOpacity(progress, effectType);
    this.setWallpaperBlurOpacity(progress, effectType);
    if (effectType === BlurEffectType.RECENT) {
      this.setOthersOpacity(isEnabled);
      if (!folderGesData.isAddDialogOpening()) {
        this.folderOpacity.value = this.othersOpacity.value;
      }
      if (!this.isShowUIExtension) {
        this.editModeButtonOpacity.value = this.othersOpacity.value;
      }
    }
  }

  /**
   * 根据负一屏,全搜滑动进度处理动效
   * @param progress 负一屏,全搜滑动进度值，effectType：默认负一屏
   */
  public onProgressChange(progress: number, effectType: BlurEffectType = BlurEffectType.NEGATIVE_SCREEN): void {
    log.showInfo(`onProgressChange start:${progress}; effectType:${effectType}`);
    // 负一屏合全搜拉起时必须要隐藏图标,其他场景按需维护
    if (![BlurEffectType.NEGATIVE_SCREEN, BlurEffectType.GLOBAL_SEARCH].includes(effectType)) {
      const isFolderOpen: boolean = FolderManager.getInstance().isFolderOpen();
      log.showInfo(`onProgressChange isFolderOpen:${isFolderOpen}; effectType:${effectType}`);
      if (isFolderOpen) {
        log.showWarn('onProgressChange isFolderOpen return.');
        return;
      }
    }
    let isEnable: boolean = progress > 0;
    this.onBlurAnimEvent(isEnable, effectType, progress);
    this.isUseEffect = this.isWallpaperBlurEffectEnabled();
    log.showInfo(`onProgressChange end`);
  }

  public updateBlurEffect(isEnabled: boolean, effectType: BlurEffectType): void {
    log.showInfo(`updateBlurEffect isEnabled: ${isEnabled}, effectType: ${effectType}`);
    switch (effectType) {
      case BlurEffectType.FOLDER:
        this.blurEffect.isFolderBlurEffect = isEnabled;
        this.updateFolderBlurEffect();
        break;
      case BlurEffectType.RECENT:
        this.blurEffect.isRecentBlurEffect = isEnabled;
        break;
      case BlurEffectType.NEGATIVE_SCREEN:
        this.blurEffect.isNegativeScreenEffect = isEnabled;
        break;
      case BlurEffectType.EDIT_MODE_FOLDER:
        this.blurEffect.isEditModeFolderEffect = isEnabled;
        break;
      case BlurEffectType.GLOBAL_SEARCH:
        this.blurEffect.isGlobalSearchEffect = isEnabled;
        this.updateGlobalSearchBlurEffect();
        break;
      case BlurEffectType.ICON_START_EXIT:
        this.blurEffect.isStartExitBlurEffect = isEnabled;
        break;
      default:
        break;
    }
    if (this.blurEffect.isRecentBlurEffect || this.blurEffect.isFolderBlurEffect) {
      this.blurEffect.isStartExitBlurEffect = false;
    }
    this.isWallpaperBlurEffect.value = this.isWallpaperBlurEffectEnabled();
  }

  private setLauncherOpacity(progress: number, reason?: string): void {
    if (this.isLauncherOpAnimDisable || this.isShowUIExtension) {
      return;
    }
    let launcherOpacity: number = 0;
    if (progress < 0) {
      launcherOpacity = this.isWallpaperBlurEffect.value ? 0 : 1;
    } else {
      launcherOpacity = 1 - progress;
    }
    this.setLauncherOpacityWithDfx(launcherOpacity, reason)
  }

  private setWallpaperBlurOpacity(progress: number, reason?: string): void {
    let wallpaperBlurOpacity: number = 0;
    if (progress < 0) {
      wallpaperBlurOpacity = this.isWallpaperBlurEffect.value ? 1 : 0;
    } else {
      wallpaperBlurOpacity = progress;
    }
    this.setWallpaperBlurOpacityWithDfx(wallpaperBlurOpacity, reason);
  }

  /**
   * 设置桌面透明度
   * @param value 桌面透明度
   * @param callerFunctionName 调用来源
   */
  public setLauncherOpacityWithDfx(value: number, callerFunctionName?: string): void {
    if (this.launcherOpacity.value === value) {
      return;
    }
    log.showWarn(`setLauncherOpacityValue ${value}, caller function name: ${callerFunctionName}`);
    this.launcherOpacity.value = value;
  }

  /**
   * 设置壁纸模糊透明度
   * @param value 壁纸模糊透明度
   * @param callerFunctionName 调用来源
   */
  public setWallpaperBlurOpacityWithDfx(value: number, callerFunctionName?: string): void {
    if (this.wallpaperBlurOpacity.value === value) {
      return;
    }
    log.showWarn(`setWallpaperBlurOpacityValue ${value}, caller function name: ${callerFunctionName}`);
    this.wallpaperBlurOpacity.value = value;
  }

  /**
   * 设置去壁纸模糊
   * @param callerFunctionName
   */
  public setWallpaperBlurInactive(callerFunctionName: string = 'sceneContainerTransitionOut'): void {
    if (this.blurEffect.isStartExitBlurEffect || this.blurEffect.isFolderBlurEffect) {
      this.setLauncherOpacityWithDfx(1, callerFunctionName);
      this.setWallpaperBlurOpacityWithDfx(0, callerFunctionName);
    }
  }

  /**
   * 设置上壁纸模糊
   * @param callerFunctionName
   */
  public setWallpaperBlurActive(callerFunctionName: string = 'sceneContainerTransitionIn'): void {
    if (this.blurEffect.isStartExitBlurEffect) {
      this.setLauncherOpacityWithDfx(0, callerFunctionName);
      this.setWallpaperBlurOpacityWithDfx(1, callerFunctionName);
    }
  }

  private setOthersOpacity(isEnabled: boolean): void {
    this.othersOpacity.value = isEnabled ? 0 : 1;
  }

  /**
   * 当多任务显示时，负一屏需要透明
   * @returns 负一屏透明度
   */
  public getNegativeScreenOpacity(): StateEx<number> {
    return this.othersOpacity;
  }

  /**
   * 当多任务显示时，全搜需要透明
   * @returns 全搜透明度
   */
  public getGlobalSearchOpacity(): StateEx<number> {
    return this.othersOpacity;
  }

  /**
   * 当多任务显示时，打开的文件夹需要透明
   * @returns 文件夹组件透明度
   */
  public getOpenFolderOpacity(): StateEx<number> {
    return this.folderOpacity;
  }

  /**
   * 当多任务显示时，编辑模式下按钮需要透明
   * @returns 编辑模式下按钮透明度
   */
  public getEditModeButtonOpacity(): StateEx<number> {
    return this.editModeButtonOpacity;
  }

  /**
   * 当多任务显示时，编辑模式下topBar需要透明
   * @returns 编辑模式下topBar透明度
   */
  public getEditModeTopBarOpacity(): StateEx<number> {
    return this.othersOpacity;
  }

  /**
   * 当多任务显示时，桌面弹框需要透明
   * @returns 桌面弹框透明度
   */
  public getDesktopDialogOpacity(): StateEx<number> {
    return this.othersOpacity;
  }

  /**
   * 当多任务显示时，编辑模式下UI需要透明
   * @returns 编辑模式下UI透明度
   */
  public getEditModeExtensionUIOpacity(): StateEx<number> {
    return this.othersOpacity;
  }

  /**
   * 桌面滑动定制裁剪是否启用
   * @returns true：启用定制裁剪， false：不启用定制裁剪
   */
  public isLauncherSwiperCustomEnabled(): boolean {
    return this.isLauncherSwiperCustomEnable;
  }

  /**
   * 编辑模式下UIExtension是否显示
   * @param isShow: UIExtension是否显示
   */
  public setShowUIExtension(isShow: boolean): void {
    this.isShowUIExtension = isShow;
  }

  private onPreBlurAnim(effectType: BlurEffectType): void {
    this.isBlurAnimRunning.value = true;
    this.hideLauncherForUIExtension();
    if (effectType !== BlurEffectType.FOLDER) {
      this.hideFolderForAddDialog();
    }
  }

  private onBlurAnimFinish(): void {
    this.isBlurAnimRunning.value = false;
    this.unRegisterRecentBlurEventIfNeed();
    if (!this.isWallpaperBlurEffect.value) {
      this.resetAnimData();
    } else {
      this.showFolderForAddDialog();
    }
    log.showWarn(`startBlurAnim onFinish => launcherOpacity: ${this.launcherOpacity.value}` +
      `, wallpaperBlurOpacity: ${this.wallpaperBlurOpacity.value}`);
  }

  private hideLauncherForUIExtension(): void {
    if (this.isShowUIExtension) {
      this.launcherOpacity.value = 0;
      this.editModeButtonOpacity.value = 0;
    }
  }

  private hideFolderForAddDialog(): void {
    if (folderGesData.isAddDialogOpening()) {
      this.folderOpacity.value = 0;
    }
  }

  private showFolderForAddDialog(): void {
    if (folderGesData.isAddDialogOpening() && !this.blurEffect.isRecentBlurEffect) {
      this.folderOpacity.value = 1;
    }
  }

  private resetAnimData(): void {
    this.isUseEffect = false;
    this.setLauncherOpacityWithDfx(1, 'resetAnimData');
    this.editModeButtonOpacity.value = 1;
    this.folderOpacity.value = 1;
    this.isShowMask.value = false;
  }

  private resetLauncherVisualEffect(): void {
    this.isUseEffect = false;
    this.setLauncherOpacityWithDfx(1, 'reset');
    this.setWallpaperBlurOpacity(0, 'reset');
    this.isShowMask.value = false;
    this.othersOpacity.value = 1;
    this.editModeButtonOpacity.value = 1;
    this.folderOpacity.value = 1;
  }

  /**
   * 更新颜色模式
   */
  public updateColorMode(colorMode: number): void {
    this.colorMode = colorMode;
  }

  private addMaskByBlurEffect(): void {
    this.isShowMask.value = true;
    this.updateMastColor();
  }

  private updateMastColor(): void {
    const isLightColorMode: boolean = this.colorMode === LIGHT_COLOR_MODE;
    const isDarkColorMode: boolean = this.colorMode === DARK_COLOR_MODE;
    if (!isLightColorMode && !isDarkColorMode) {
      this.maskColor.value = MASK_COLOR_FOR_DEFAULT;
      return;
    }
    if (this.blurEffect.isRecentBlurEffect) {
      this.maskColor.value = isLightColorMode ? MASK_COLOR_RECENT_LIGHT : MASK_COLOR_RECENT_DARK;
    } else if (this.blurEffect.isFolderBlurEffect) {
      this.maskColor.value = isLightColorMode ? MASK_COLOR_FOLDER_LIGHT : MASK_COLOR_FOLDER_DARK;
    } else if (this.blurEffect.isNegativeScreenEffect) {
      this.maskColor.value = isLightColorMode ? MASK_COLOR_FOR_DEFAULT : MASK_COLOR_NEGATIVE_DARK;
    } else {
      this.maskColor.value = isLightColorMode ? MASK_COLOR_FOR_DEFAULT : MASK_COLOR_GLOBALSEARCH_DARK;
    }
  }

  private unRegisterRecentBlurEventIfNeed(): void {
    if (!this.isRecentBlurEffectDisable && !this.isPowerSaveMode && !this.blurEffect.isRecentBlurEffect &&
      this.launcherOpacity.value === 1) {
      GlobalContext.getContext()?.eventHub.off(VisualEffectConstants.IS_RECENT_BLUR_EFFECT);
    }
  }

  private updateFolderBlurEffect(): void {
    log.showWarn(`updateFolderBlurEffect disable:${this.isFolderBlurEffectDisable} powerSaveMode:${this.isPowerSaveMode}
      isFolderBulr:${this.blurEffect.isFolderBlurEffect}`);
    this.isShowFolderBlurEffect.value =
      this.isFolderBlurEffectDisable || this.isPowerSaveMode || this.blurEffect.isFolderBlurEffect;
  }

  private updateGlobalSearchBlurEffect():void{
    this.isShowGlobalSearchBlurEffect.value = this.isGlobalSearchBlurEffectDisable || this.isPowerSaveMode ||
      this.blurEffect.isGlobalSearchEffect;
  }
}

// 单例
export let launcherVisualEffectMgr: LauncherVisualEffectManager =
  SingletonHelper.getInstance(LauncherVisualEffectManager, TAG);
