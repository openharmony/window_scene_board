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


import lazy { AnimationConstants } from './AnimationConstants';
import lazy { AodMaskDataManager } from './AodMaskDataManager';

import lazy { WallpaperViewController } from '../WallpaperViewController';
import { AodManager } from '../AodManager';
import { PathReloadStrategy, RootPathChangeListener } from '../../utils/PathReloadStrategy';
import { ScbState } from '../WallpaperConstants';
import { WindowReloadListener } from '../../reloadmanager/ReloadStrategy';
import { Log } from '../../utils/Log';
import { WindowReloadStrategy } from '../../reloadmanager/WindowReloadStrategy';
import { GlobalContext } from '../../utils/GlobalContext';

const TAG: string = 'AodViewController';

const ROTATE_CALIBRATION_DELAY: number = 150;

export class AodViewController {
  public isRenderAodMask: boolean = true;

  public isPlaying: boolean = false;

  private static instance: AodViewController;

  private isAodExited: boolean = false;

  private aodDataMgr: AodMaskDataManager = AodMaskDataManager.getInstance();

  private aodMgr: AodManager = new AodManager();

  public aodMaskGeoAnimation: AnimateParam = {
    curve: Curve.FastOutSlowIn,
  };

  public aodMaskOpacityAnimation: AnimateParam = {
    curve: Curve.Friction,
  };

  public wallpaperGeoAnimation: AnimateParam = {
    curve: Curve.FastOutSlowIn,
  };

  public quickApply: AnimateParam = {
    duration: 0,
    tempo: 0,
    iterations: 0,
    onFinish: () => {
    },
  };

  private rootPathListener: RootPathChangeListener = {
    onRootPathChange: async () => {
      this.getAodStatus();
      // 开启自定义aod时初始化isAodExited状态
      if (this.isRenderAodMask) {
        this.isAodExited = WallpaperViewController.getInstance().getCurrentScbState() !== ScbState.AOD;
      }
      AodMaskDataManager.getInstance().loadImageParam();
    },
  };

  private windowReloadListener: WindowReloadListener = {
    reloadWindow: async (resourceQualifier: number, screenWidth: number, screenHeight: number) => {
      if (!this.isAodExited) {
        return;
      }

      // Calibrate mask target on rotation
      const offsetY: number = this.aodDataMgr.getExitTarget();
      this.aodMaskGeoAnimation.delay = ROTATE_CALIBRATION_DELAY;

      animateToImmediately(this.aodMaskGeoAnimation, () => {
        AppStorage.setOrCreate<string[]>('aodMaskOffset', ['0', `${offsetY}px`]);
      });
    }
  };

  private getAodStatus(): void {
    const isAodEnabled: boolean = this.aodMgr.getAodSwitchState() === 1;

    // 判断是否启用半屏Aod
    const isTransitPartialAod: boolean = this.aodMgr.isTransitPartialAod();
    Log.info(TAG, `isAodEnabled ${isAodEnabled}, isTransitPartialAod ${isTransitPartialAod}`);
    this.isRenderAodMask = isAodEnabled && isTransitPartialAod;
    AppStorage.setOrCreate<boolean>('isRenderAodMask', this.isRenderAodMask);

    // 判断是否启用全屏Aod
    let isFullAodEnable: boolean = isAodEnabled && this.aodMgr.isFullAod();
    Log.info(TAG, `isFullAodEnable = ${isFullAodEnable}`);
    AppStorage.setOrCreate<boolean>('isFullAodEnable', isFullAodEnable);

    let isOnlinePartialAod: boolean = isAodEnabled && this.aodMgr.isOnlinePartialAod();
    Log.info(TAG, `isOnlinePartialAod = ${isOnlinePartialAod}`);
    AppStorage.setOrCreate<boolean>('isOnlinePartialAod', isOnlinePartialAod);
  }

  private constructor() {
    PathReloadStrategy.getInstance().addUpdateRootPathListener(this.rootPathListener);
    this.aodMgr.initAodSettingsSubscriber(() => {
      this.getAodStatus();
    });
    this.getAodStatus();
    WindowReloadStrategy.getInstance().addReloadListener(this.windowReloadListener);
    GlobalContext.getContext().setObject('CUSTOM_CLOCK_AOD_OFFSET_X', 0);
    GlobalContext.getContext().setObject('CUSTOM_CLOCK_AOD_OFFSET_Y', 0);
  }

  private destructor(): void {
    PathReloadStrategy.getInstance().removeUpdateRootPathListener(this.rootPathListener);
    this.aodMgr.destroyAodSettingsSubscriber();
    WindowReloadStrategy.getInstance().removeReloadListener(this.windowReloadListener);
  }

  public static getInstance(): AodViewController {
    if (!AodViewController.instance) {
      AodViewController.instance = new AodViewController();
    }

    return AodViewController.instance;
  }

  /**
   * Process Mask and wallpaper transition animation
   *
   * @param scbState SceneBoard state
   */
  public onTransition(scbState: ScbState): void {
    if (scbState === ScbState.SLEEP || scbState === ScbState.UNKNOWN) {
      return;
    }
    scbState === ScbState.AOD ? this.enterAod() : this.exitAod();
  }

  /**
   * Sync the latest AOD position as anti-screen-burn is enabled
   */
  public syncAodPosition(): void {
    if (!this.isRenderAodMask) {
      return;
    }

    // Might just not need to sync it at all
    if (this.isAodExited) {
      return;
    }

    Log.info(TAG, `set offset for anti screen burn`)
    // Quickly set AOD mask to real AOD's anti screen burn position
    let offsetArr: number[] = [GlobalContext.getContext().getObject('CUSTOM_CLOCK_AOD_OFFSET_X') as number,
      GlobalContext.getContext().getObject('CUSTOM_CLOCK_AOD_OFFSET_Y') as number];
    let wallpaperOffsetX: number = this.aodDataMgr.getWallpaperOffset()[0] + offsetArr[0];
    let wallpaperOffsetY: number = this.aodDataMgr.getWallpaperOffset()[1] + offsetArr[1];
    animateToImmediately(this.quickApply, () => {
      AppStorage.setOrCreate<number[]>('aodMaskOffset', offsetArr);
      AppStorage.setOrCreate<number[]>('wallpaperOffset', [wallpaperOffsetX, wallpaperOffsetY]);
    });
  }

  private enterAod(): void {
    AppStorage.setOrCreate<string[]>('aodMaskOffset', ['0', `${this.aodDataMgr.getExitTarget()}px`]);
    this.isAodExited = false;
    this.isRenderAodMask = true;
    this.isPlaying = true;

    this.aodMaskGeoAnimation.delay = AnimationConstants.AOD_MASK_GEO_ENTER_DELAY;
    this.aodMaskGeoAnimation.duration = AnimationConstants.AOD_MASK_GEO_ENTER_DURATION;

    this.aodMaskOpacityAnimation.delay = AnimationConstants.AOD_MASK_OPACITY_ENTER_DELAY;
    this.aodMaskOpacityAnimation.duration = AnimationConstants.AOD_MASK_OPACITY_ENTER_DURATION;

    // AOD's enter means wallpaper's exit
    this.wallpaperGeoAnimation.delay = AnimationConstants.WALLPAPER_GEO_EXIT_DELAY;
    this.wallpaperGeoAnimation.duration = AnimationConstants.WALLPAPER_GEO_EXIT_DURATION;

    this.setAnimationFinishCallback(this.aodMaskGeoAnimation, this.aodMaskOpacityAnimation, this.wallpaperGeoAnimation);

    // Scale + offset
    animateToImmediately(this.aodMaskGeoAnimation, () => {
      AppStorage.setOrCreate<number[]>('aodMaskOffset', [0, 0]);
      AppStorage.setOrCreate<number>('aodMaskScale', 1);
    });

    // Opacity
    animateToImmediately(this.aodMaskOpacityAnimation, () => {
      AppStorage.setOrCreate<number>('aodMaskOpacity', 1);
    });

    // Wallpaper offset
    const wallpaperOffset: number[] = this.aodDataMgr.getWallpaperOffset();
    const wallpaperScale: number = this.aodDataMgr.getWallpaperScale();
    animateToImmediately(this.wallpaperGeoAnimation, () => {
      AppStorage.setOrCreate<number[]>('wallpaperOffset', wallpaperOffset);
      AppStorage.setOrCreate<number>('innerWallpaperScale', wallpaperScale);
    });
  }

  private exitAod(): void {
    if (this.isAodExited) {
      return;
    }
    this.isPlaying = true;

    this.aodMaskGeoAnimation.delay = AnimationConstants.AOD_MASK_GEO_EXIT_DELAY;
    this.aodMaskGeoAnimation.duration = AnimationConstants.AOD_MASK_GEO_EXIT_DURATION;

    this.aodMaskOpacityAnimation.delay = AnimationConstants.AOD_MASK_OPACITY_EXIT_DELAY;
    this.aodMaskOpacityAnimation.duration = AnimationConstants.AOD_MASK_OPACITY_EXIT_DURATION;

    // AOD's exit means wallpaper's enter
    this.wallpaperGeoAnimation.delay = AnimationConstants.WALLPAPER_GEO_ENTER_DELAY;
    this.wallpaperGeoAnimation.duration = AnimationConstants.WALLPAPER_GEO_ENTER_DURATION;

    this.setAnimationFinishCallback(this.aodMaskGeoAnimation, this.aodMaskOpacityAnimation, this.wallpaperGeoAnimation);

    const offsetY: number = this.aodDataMgr.getExitTarget();

    // Scale + offset
    animateToImmediately(this.aodMaskGeoAnimation, () => {
      AppStorage.setOrCreate<string[]>('aodMaskOffset', ['0', `${offsetY}px`]);
      AppStorage.setOrCreate<number>('aodMaskScale', AnimationConstants.AOD_INVISIBLE_SCALE);
    });

    // Opacity
    animateToImmediately(this.aodMaskOpacityAnimation, () => {
      AppStorage.setOrCreate<number>('aodMaskOpacity', 0);
    });

    // Wallpaper offset
    animateToImmediately(this.wallpaperGeoAnimation, () => {
      AppStorage.setOrCreate<number[]>('wallpaperOffset', [0, 0]);
      AppStorage.setOrCreate<number>('innerWallpaperScale', 1);
    });
    this.isAodExited = true;
  }

  /**
   * 为播放完成最晚的动画设置动画播放完成回调
   * 需要在动画参数设置完成后，开始播放前调用
   *
   * @param 需要播放的动画数组
   */
  private setAnimationFinishCallback(...animations: AnimateParam[]): void {
    const animation: AnimateParam = animations.reduce((a1, a2) => {
      if (((a1.duration ?? 0) + (a1.delay ?? 0)) > ((a2.duration ?? 0) + (a2.delay ?? 0))) {
        return a1;
      } else {
        return a2;
      }
    });
    animation.onFinish = () => {
      Log.info(TAG, 'Aod animation end')
      this.isPlaying = false;
      WallpaperViewController.getInstance().notifyAnimationFinish();
      animation.onFinish = () => {
      };
    }
  }
}