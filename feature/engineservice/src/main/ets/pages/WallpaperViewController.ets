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

import lazy fs from '@ohos.file.fs';
import lazy settings from '@ohos.settings';
import lazy UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import lazy { UIContext } from '@ohos.arkui.UIContext';
import lazy uiExtensionHost from '@ohos.uiExtensionHost';
import lazy window from '@ohos.window';
import { ScbState, WallpaperConstants, WallpaperType } from './WallpaperConstants';
import { Log } from '../utils/Log';
import { Constants, FoldStatus } from '../utils/Constants';
import { DeviceUtil } from '../utils/DeviceUtil';
import { JsonUtil } from '../utils/JsonUtil';
import { WallpaperAnimationConstant } from '../utils/WallpaperAnimationConstant';
import { WallpaperAnimator } from './WallpaperAnimator';
import { GlobalContext } from '../utils/GlobalContext';
import { AodViewController } from './aodmask/AodViewController';
import { WallpaperChoreographer } from './WallpaperChoreographer';

const TAG: string = 'WallpaperViewController';

const DEFAULT_DIM_VALUE: number = 0.35;

/**
 * A ViewController that would orchestrate the scaling of the wallpaper, as well as the visibility of home/lock
 * wallpaper component when static theme is used.
 *
 * @since 2024-02-27
 */
export class WallpaperViewController {
  private static instance: WallpaperViewController;

  private session?: UIExtensionContentSession;

  private windowProxy?: uiExtensionHost.UIExtensionHostWindowProxy;

  private wallpaperChoreographer: WallpaperChoreographer = new WallpaperChoreographer();

  private uiContext?: UIContext;

  private springAnimationList: () => void = () => {};

  private onSpringAnimationFinish: () => void = () => {};

  private smoothAnimationList: () => void = () => {};

  private onSmoothAnimationFinish: () => void = () => {};

  private currentScbState: ScbState = ScbState.UNKNOWN;

  private isNotifiedAnimationFinish: boolean = false;

  private lockType: WallpaperType = WallpaperType.UNKNOWN;

  private homeType: WallpaperType = WallpaperType.UNKNOWN;

  private isMashup: boolean = false;

  private initDynamicState: ScbState = ScbState.LOCKSCREEN;

  private aodFoldKs: number = DEFAULT_DIM_VALUE;

  private aodUnfoldKs: number = DEFAULT_DIM_VALUE;

  private isAodDimExist: boolean = false;

  private isFirstLoad: boolean = true;

  private previousDimKs: number = 1;

  private aodViewController: AodViewController = AodViewController.getInstance();

  private aodDimPath: string = '';

  // 桌面应用状态 true: 桌面打开了应用，false: 桌面无应用
  private isAppOpenedOnDesktop: boolean = false;

  private setDimFactor: (val: number) => void = (factor: number) => {
    if (this.lockType === WallpaperType.DYNAMIC) {
      return;
    }

    Log.info(TAG, `set factor ${factor}`);
    AppStorage.setOrCreate<number>(WallpaperConstants.KEY_AOD_DIM_FACTOR, factor);
    this.uiContext?.setDynamicDimming(WallpaperConstants.ID_LOCK, factor);
  };

  private setBlur: (val: number) => void = (blurRadius: number) => {
    AppStorage.setOrCreate<number>(WallpaperConstants.KEY_BLUR_RADIUS, blurRadius);
  };

  private setLightUpFactor: (val: number) => void = (factor: number) => {
    AppStorage.setOrCreate<number>(WallpaperConstants.KEY_LIGHT_UP_FACTOR, factor);
  }

  private setLockOpacity: (val: number) => void = (opacity: number) => {
    AppStorage.setOrCreate<number>(WallpaperConstants.KEY_LOCK_OPACITY, opacity);
  }

  private callbackMap: Map<String, (val: number) => void> = new Map([
    [WallpaperConstants.KEY_BLUR_RADIUS, this.setBlur],
    [WallpaperConstants.KEY_LIGHT_UP_FACTOR, this.setLightUpFactor],
    [WallpaperConstants.KEY_AOD_DIM_FACTOR, this.setDimFactor],
    [WallpaperConstants.KEY_LOCK_OPACITY, this.setLockOpacity],
  ]);

  /**
   * ctor for WVC, on initialising, current scb state need to be given to sync wallpaper status
   */
  private constructor() {
    let initState: ScbState = AppStorage.get<ScbState>('initScbState') ?? ScbState.UNKNOWN;
    if (DeviceUtil.isLiteSpecDevice()) {
      WallpaperAnimationConstant.BLUR_RADIUS = [0, 0, 0, 0];
    }
    if (!DeviceUtil.isEnabledLightUpEffectDevice()) {
      WallpaperAnimationConstant.LIGHT_UP_FACTOR = [1, 1, 1, 1];
    }
    this.onScbUpdate(initState);
    this.parseDimKs();
  }

  /**
   * Get this controller's singleton instance.
   * The source of control of the wallpaper view must be unified, thus using singleton.
   *
   * @returns WallpaperViewController singleton instance
   */
  public static getInstance(): WallpaperViewController {
    if (!WallpaperViewController.instance) {
      WallpaperViewController.instance = new WallpaperViewController();
    }
    return WallpaperViewController.instance;
  }

  /**
   * Notify SceneBoard when animation is finished.
   * For dynamic wallpaper, engine would call the callback
   * For static, this will be called when scale animation ends.
   */
  public notifyAnimationFinish(): void {
    if (this.isNotifiedAnimationFinish) {
      Log.warn(TAG, 'Skipping repetitive animation finish notification.');
      return;
    }

    Log.info(TAG, 'On sending animation finish message.');
    try {
      this.session?.sendData({
        'isAnimationFinish': true,
        'taskId': GlobalContext.getContext().getObject('animationTaskId') ?? -1,
      });
      this.isNotifiedAnimationFinish = true;
    } catch (err) {
      Log.error(TAG, `Internal error on notifying animation finish, ${err?.code} - ${err?.message}`);
    }
  }

  /**
   * Notify Theme finish loading.
   */
  public notifyThemeFinishLoading(): void {
    try {
      this.session?.sendData({
        'themeFinishLoading': true,
      });
    } catch (err) {
      Log.error(TAG, `Internal error on notifying theme finish loading, ${err?.code} - ${err?.message}`);
    }
  }

  /**
   * Send live view list.
   *
   * @param liveViewList Live view scene list
   */
  public sendLiveViewList(liveViewList: string[]): void {
    try {
      this.session?.sendData({
        'requestLiveViewList': true,
        'liveViewList': liveViewList
      });
    } catch (err) {
      Log.error(TAG, `Internal error on notifying theme finish loading, ${err?.code} - ${err?.message}`);
    }
  }

  /**
   * Notify SceneBoard when gesture motion need call back.
   *
   * @param hasGesture send or not.
   */
  public notifyGestureMotionCallback(hasGesture: boolean): void {
    Log.info(TAG, 'On sending animation gesture motion callback message.');
    try {
      this.session?.sendData({ 'gestureMotion': hasGesture });
    } catch (err) {
      Log.error(TAG, `Internal error on notifying gesture motion callback, ${err?.code} - ${err?.message}`);
    }
  }

  /**
   * Notify SceneBoard when theme switch scene finish.
   */
  public notifyThemeSceneSwitchFinish(): void {
    Log.info(TAG, 'On sending theme scene switch message.');
    try {
      this.session?.sendData({ 'themeSceneSwitchFinish': true });
    } catch (err) {
      Log.error(TAG, `Internal error on notifying theme scene switch, ${err?.code} - ${err?.message}`);
    }
  }

  /**
   * 通知大桌面截图结束
   */
  public updateBaseImageEnd(): void {
    try {
      this.session?.sendData({ 'updateBaseImageEnd': '' });
    } catch (err) {
      Log.error(TAG, `Internal error on notifying animation finish, ${err?.code} - ${err?.message}`);
    }
  }

  /**
   * 通知大桌面动效结束
   */
  public notifyAnimationFinishAll(): void {
    try {
      this.session?.sendData({
        'isAnimationFinish': true,
        'taskId': GlobalContext.getContext().getObject('animationTaskId') ?? -1,
      });
    } catch (err) {
      Log.error(TAG, `Internal error on notifying animation finish, ${err?.code} - ${err?.message}`);
    }
  }

  /**
   * Allows the UIExtensionSession instance be passed to the view controller for notifying animation end.
   *
   * @param uiExtSession Current UI Extension Session instance.
   */
  public setUiExtSession(uiExtSession: UIExtensionContentSession): void {
    this.session = uiExtSession;
    this.windowProxy = uiExtSession.getUIExtensionHostWindowProxy();
  }

  /**
   * Pass the UIContext from the component which using the WVC
   *
   * @param uiContext UIContext instance, mostly used to play dimming animation
   */
  public setUiContext(uiContext: UIContext): void {
    this.uiContext = uiContext;
  }

  /**
   * Notify the WVC the current wallpaper type to avoid unnecessary animations
   *
   * @param type Current theme's wallpaper type
   */
  public setWallpaperType(lockType: WallpaperType, homeType: WallpaperType): void {
    this.lockType = lockType;
    this.homeType = homeType;
    this.isMashup = this.lockType !== this.homeType;
  }

  /**
   * 设置桌面应用打开状态
   *
   * @param isAppOpenedOnDesktop 桌面应用状态 true: 桌面打开了应用，false: 桌面无应用
   */
  public setAppDesktopState(isAppOpenedOnDesktop: boolean): void {
    this.isAppOpenedOnDesktop = isAppOpenedOnDesktop;
  }

  /**
   * Acquire the correct state for DWDS to init or reload
   *
   * @returns Init state for dynamic wallpaper to init animation
   */
  public getInitDynamicState(): ScbState {
    return this.initDynamicState;
  }

  /**
   * Refresh wallpaper view key params when SCB state's has been changed.
   *
   * @param targetState Destination SceneBoard state, which used to get target view prop value
   */
  public onScbUpdate(targetState: ScbState): void {
    if (targetState === ScbState.UNKNOWN) {
      if (this.aodViewController.isRenderAodMask) {
        this.aodViewController.syncAodPosition();
      }
      return;
    }

    this.isNotifiedAnimationFinish = false;
    this.currentScbState = targetState;

    this.refreshInitDynamicState(targetState);

    // No animation required when screen off w/o AOD, only to set values.
    // Using animateToImmediately to fast-forward prop change
    if (targetState === ScbState.SLEEP) {
      this.quickApplySleepState();
      this.updateVisibility(targetState);
      return;
    }

    // Unless it's all dynamic, lock opacity must be refreshed
    if (this.lockType !== WallpaperType.DYNAMIC || this.homeType !== WallpaperType.DYNAMIC) {
      this.updateVisibility(targetState);
      this.invalidateProperty(WallpaperConstants.DIRTY_MASK_LOCK_OPACITY);

      // Only non-dynamic lock needs dimming
      if (this.lockType !== WallpaperType.DYNAMIC) {
        this.getAodDimFactor();
        this.invalidateProperty(WallpaperConstants.DIRTY_MASK_DIM);
      }
    }

    this.invalidateProperty(WallpaperConstants.DIRTY_MASK_LIGHT_UP);
    this.invalidateProperty(WallpaperConstants.DIRTY_MASK_BLUR);

    if (this.aodViewController.isRenderAodMask) {
      this.aodViewController.onTransition(targetState);
    }

    let dirtyMask: number = this.wallpaperChoreographer.getActualDirtyMask(targetState);
    if (dirtyMask === 0) {
      Log.info(TAG, 'No animation would be submitted.');
      return;
    }

    if (targetState === ScbState.DESKTOP) {
      this.cancelBlur();
    }

    this.prepareAlphaAnimationParam(targetState);

    this.prepareAnimation(dirtyMask, targetState);
    this.wallpaperChoreographer.submitAnimation(WallpaperAnimationConstant.ID_ANIMATION_SMOOTH,
      this.smoothAnimationList, this.onSmoothAnimationFinish);
    this.wallpaperChoreographer.submitAnimation(WallpaperAnimationConstant.ID_ANIMATION_SPRING,
      this.springAnimationList, this.onSpringAnimationFinish);
    this.resetAnimationList();
  }

  private cancelBlur(): void {
    let cancelBlur: () => void = () => {
      this.setBlur(0);
    };
    this.wallpaperChoreographer.submitAnimation(WallpaperAnimationConstant.ID_ANIMATION_QUICK_APPLY, cancelBlur);
  }

  /**
   * 根据目标scb状态和桌面应用打开状态设置淡入淡出动效参数
   *
   * @param targetState 目标scb状态
   */
  private prepareAlphaAnimationParam(targetState: ScbState): void {
    if (targetState === ScbState.DESKTOP) {
      if (this.isAppOpenedOnDesktop) {
        // 解锁到应用界面，增加延时，保证壁纸的变化用户不可见, delay: 150, duration: 150
        WallpaperAnimator.setSmoothAnimationDelay(WallpaperAnimationConstant.ALPHA_DELAY_DEFAULT);
        WallpaperAnimator.setSmoothAnimationDuration(WallpaperAnimationConstant.ALPHA_DURATION);
      } else {
        // 解锁到桌面, delay: 0, duration: 150
        WallpaperAnimator.setSmoothAnimationDelay(WallpaperAnimationConstant.ALPHA_NO_DELAY);
        WallpaperAnimator.setSmoothAnimationDuration(WallpaperAnimationConstant.ALPHA_DURATION);
      }
    } else {
      if (this.isAppOpenedOnDesktop) {
        // 应用界面锁屏不播放动效, delay: 0, duration: 0
        WallpaperAnimator.setSmoothAnimationDelay(WallpaperAnimationConstant.ALPHA_NO_DELAY);
        WallpaperAnimator.setSmoothAnimationDuration(WallpaperAnimationConstant.ALPHA_NO_DURATION);
      } else {
        // 桌面锁屏播放动效, delay: 150, duration: 150
        WallpaperAnimator.setSmoothAnimationDelay(WallpaperAnimationConstant.ALPHA_DELAY_DEFAULT);
        WallpaperAnimator.setSmoothAnimationDuration(WallpaperAnimationConstant.ALPHA_DURATION);
      }
    }
  }

  private quickApplySleepState(): void {
    let quickApplyList: () => void = () => {
      this.setLightUpFactor(WallpaperAnimationConstant.LIGHT_UP_FACTOR[ScbState.SLEEP]);
      this.setBlur(WallpaperAnimationConstant.BLUR_RADIUS[ScbState.SLEEP]);
      this.setLockOpacity(WallpaperAnimationConstant.LOCK_OPACITY[ScbState.SLEEP]);
    };
    this.wallpaperChoreographer.submitAnimation(WallpaperAnimationConstant.ID_ANIMATION_QUICK_APPLY, quickApplyList,
      () => this.hideUnseenWallpaper());
  }

  private invalidateProperty(propertyMask: number): void {
    this.wallpaperChoreographer.setDirtyMask(propertyMask);
  }

  private updateVisibility(scbState: ScbState): void {
    if (scbState === ScbState.DESKTOP) {
      Log.warn(TAG, 'show home wallpaper');
      AppStorage.setOrCreate<Visibility>('homeVis', Visibility.Visible);
    } else {
      Log.warn(TAG, 'show lock wallpaper');
      AppStorage.setOrCreate<Visibility>('lockVis', Visibility.Visible);
    }
  }

  private prepareAnimation(dirtyMask: number, targetScbState: ScbState): void {
    let tempMask: number = dirtyMask;
    if ((tempMask & WallpaperConstants.DIRTY_MASK_LOCK_OPACITY) === WallpaperConstants.DIRTY_MASK_LOCK_OPACITY) {
      this.smoothAnimationList = () => {
        this.setLockOpacity(WallpaperAnimationConstant.LOCK_OPACITY[targetScbState]);
      };

      this.onSmoothAnimationFinish = () => {
        Log.info(TAG, 'SmoothAnimation is finished.');
        this.hideUnseenWallpaper();
      };

      // Do not accidentally add opacity change to spring animation list.
      tempMask &= ~WallpaperConstants.DIRTY_MASK_LOCK_OPACITY;
    }

    this.springAnimationList = () => {
      for (let i: number = 0; i < WallpaperConstants.WALLPAPER_PROPERTY_LIST.length; i++) {
        if ((tempMask & 1) !== 1) {
          tempMask >>= 1;
          continue;
        }

        const prop: string = WallpaperConstants.WALLPAPER_PROPERTY_LIST[i];
        const value: number = WallpaperAnimationConstant.ANIMATION_PARAMETER_LIST[i][targetScbState];
        if (this.callbackMap.has(prop)) {
          this.callbackMap.get(prop)?.(value);
        }
        tempMask >>= 1;
      }
    };

    this.onSpringAnimationFinish = () => {
      Log.info(TAG, 'SpringAnimation is finished.');
      // Avoid taking over dynamic's notification under certain conditions
      if ((this.lockType !== WallpaperType.DYNAMIC || this.currentScbState === ScbState.DESKTOP) &&
        !this.aodViewController.isPlaying) {
        this.notifyAnimationFinish();
      }
    };
  }

  private resetAnimationList(): void {
    this.springAnimationList = () => {};
    this.onSpringAnimationFinish = () => {};
    this.smoothAnimationList = () => {};
    this.onSmoothAnimationFinish = () => {};
  }

  public hideUnseenWallpaper(): void {
    // Let load publisher to freeze dynamic layer to prevent racing
    if (this.isFirstLoad) {
      this.isFirstLoad = false;
      return;
    }

    if (AppStorage.get<number>('lockOpacity') === 0) {
      AppStorage.setOrCreate<Visibility>('lockVis', Visibility.None);
      return;
    }

    if (AppStorage.get<number>('lockOpacity') === 1) {
      AppStorage.setOrCreate<Visibility>('homeVis', Visibility.None);
      return;
    }
  }

  private getAodDimFactor(): void {
    // Cancel dimming on transitional partial AOD
    if (this.aodViewController.isRenderAodMask) {
      WallpaperAnimationConstant.AOD_DIM_FACTOR[ScbState.AOD] = 1;
      return;
    } else {
      // Recover dim value from last record
      WallpaperAnimationConstant.AOD_DIM_FACTOR[ScbState.AOD] = this.previousDimKs;
    }

    // Cache dim value on each use
    if (this.isAodDimExist) {
      Log.info(TAG, 'aodDim directory exist, skip');
      this.previousDimKs = WallpaperAnimationConstant.AOD_DIM_FACTOR[ScbState.AOD];
      return;
    }

    let aodDimKs: number = 0;
    try {
      if (!getContext()) {
        return;
      }
      aodDimKs = Number(settings.getValueSync(getContext(), WallpaperConstants.KEY_AOD_DIM_KS,
        '', settings.domainName.USER_SECURITY));
      if (Number.isNaN(aodDimKs) || aodDimKs === 0) {
        Log.warn(TAG, 'Failed to read proper dimming factor from settings');
        return;
      }
      WallpaperAnimationConstant.AOD_DIM_FACTOR[ScbState.AOD] = aodDimKs;
    } catch (err) {
      Log.error(TAG, `Error on getting AOD dim factor ${err?.message}`);
    }
  }

  /**
   * Parse the AOD darkening file
   */
  public parseDimKs(): void {
    let aodKsJsonPath: string = `${Constants.SANDBOX_PATH_SHARE}/aod/dim_ks.json`;
    let aodKsJsonOutScreenPath: string =
      `${Constants.SANDBOX_PATH_SHARE}/${Constants.THEME_COMMON_SUBS_DIR}/aod/dim_ks.json`;
    this.parseAodCoefficient(aodKsJsonPath);
    this.parseAodCoefficient(aodKsJsonOutScreenPath);
    Log.info(TAG, `parseDimKs aodFoldKs: ${this.aodFoldKs}, aodUnfoldKs:${this.aodUnfoldKs}`);

    WallpaperAnimationConstant.AOD_DIM_FACTOR[ScbState.AOD] =
      DeviceUtil.isFoldExpanded() ? this.aodUnfoldKs : this.aodFoldKs;
    this.previousDimKs = WallpaperAnimationConstant.AOD_DIM_FACTOR[ScbState.AOD];
  }

  private parseAodCoefficient(path: string): void {
    try {
      if (!fs.accessSync(path)) {
        Log.warn(TAG, `path has not access!`);
        return;
      }
      let content: object | undefined = JsonUtil.jsonParse(fs.readTextSync(path));
      if (!content) {
        Log.error(TAG, `parseAodCoefficient content is null`);
        return;
      }
      this.isAodDimExist = true;
      for (let key of Object.keys(content)) {
        let attribute: string = content[key];
        if (!attribute || !attribute['typeName']) {
          continue;
        }

        if (DeviceUtil.isDoubleDisplayPocketProduct()) {
          if (path.includes(Constants.THEME_COMMON_SUBS_DIR) && attribute['typeName'] === 'base') {
            this.aodFoldKs = attribute['ksValue'] ? attribute['ksValue'] as number : this.aodFoldKs;
          } else {
            this.aodUnfoldKs = attribute['ksValue'] ? attribute['ksValue'] as number : this.aodUnfoldKs;
          }
        } else {
          if (attribute['typeName'] === 'base') {
            this.aodFoldKs = attribute['ksValue'] ? attribute['ksValue'] as number : this.aodFoldKs;
          } else if (attribute['typeName'] === 'unfolded') {
            this.aodUnfoldKs = attribute['ksValue'] ? attribute['ksValue'] as number : this.aodUnfoldKs;
          } // else use default value
        }
      }
    } catch (e) {
      Log.error(TAG, `fail parseAodCoefficient error: ${e?.message}`);
      return;
    }
  }

  /**
   * Updates the AOD dark coefficient
   *
   * @param foldScreenStatus Folded screen status
   */
  public updateAodCoefficient(qualifier: number): void {
    const foldBitPosition: number = 2;
    let foldScreenStatus: number = qualifier >> foldBitPosition; // Check qualifier's value in bit 2
    if (foldScreenStatus === FoldStatus.UNFOLD) {
      WallpaperAnimationConstant.AOD_DIM_FACTOR[ScbState.AOD] = this.aodUnfoldKs;
    } else {
      WallpaperAnimationConstant.AOD_DIM_FACTOR[ScbState.AOD] = this.aodFoldKs;
    }
    this.previousDimKs = WallpaperAnimationConstant.AOD_DIM_FACTOR[ScbState.AOD];
  }

  private refreshInitDynamicState(scbState: ScbState): void {
    if (scbState !== ScbState.SLEEP && scbState !== ScbState.LOCKSCREEN && scbState !== ScbState.DESKTOP &&
      scbState !== ScbState.AOD) {
      // 壁纸初始状态仅支持SLEEP，LOCKSCREEN，DESKTOP，AOD四种类型,非四种类型默认按锁屏处理
      scbState = ScbState.LOCKSCREEN;
      Log.warn(TAG, 'Invalid init scb state, use LOCKSCREEN as default');
    }
    if (this.isMashup) {
      this.initDynamicState = this.homeType === WallpaperType.DYNAMIC ? ScbState.DESKTOP : scbState;
    } else {
      this.initDynamicState = scbState;
    }
    Log.info(TAG, `refreshInitDynamicState: ${this.initDynamicState}`);
  }

  /**
   * 根据初始scb状态获取默认动画状态
   *
   * @returns 默认动画状态
   */
  public getInitAnimationState(): number {
    switch (this.initDynamicState) {
      case ScbState.LOCKSCREEN:
        return Constants.LOCKSCREEN_STATUS;
      case ScbState.DESKTOP:
        return Constants.LAUNCHER_STATUS;
      case ScbState.AOD:
      case ScbState.SLEEP:
        return Constants.AOD_STATUS;
      default:
        Log.error(TAG, `Illegal init scb state ${this.initDynamicState}`);
        return Constants.LOCKSCREEN_STATUS;
    }
  }

  /**
   * 获取窗口尺寸
   *
   * @returns 窗口尺寸
   */
  public getWindowRect(): window.Rect | undefined {
    if (!this.windowProxy) {
      Log.warn(TAG, 'UIExtensionHostWindowProxy not set.');
      return undefined;
    }
    return this.windowProxy.properties.uiExtensionHostWindowProxyRect;
  }

  /**
   * 获取当前scb状态
   *
   * @returns scb状态
   */
  public getCurrentScbState(): ScbState {
    return this.currentScbState;
  }

  /**
   * 销毁引擎
   */
  public destroy(): void {
  }
}