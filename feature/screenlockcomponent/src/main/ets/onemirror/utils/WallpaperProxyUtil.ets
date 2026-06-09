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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AodElemPosition, DynamicWallPaperState, themeWallpaperAniMgr } from '@ohos/themeservice';

const TAG = 'OneMirrorViewModel-WallpaperProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const WALLPAPER_SCREEN_ON_START = 0;
const WALLPAPER_SCREEN_ON_END = 4;

export default class WallpaperProxy {
  private static wallpaperProxy: WallpaperProxy = new WallpaperProxy();
  /**
   * 是否局部AOD
   */
  private isPartAod: boolean = false;

  private constructor() {
  }

  public static getInstance(): WallpaperProxy {
    return WallpaperProxy.wallpaperProxy;
  }

  public setPartAodState(isPartAod: boolean): WallpaperProxy {
    this.isPartAod = isPartAod;
    return WallpaperProxy.wallpaperProxy;
  }

  public playAod2DesktopAnimation(isSupportAod: boolean, isPlayingAnimation: boolean = true,
    callback?: Function): void {
    this.playAnimation(DynamicWallPaperState.AOD,
      DynamicWallPaperState.DESKTOP,
      isSupportAod,
      isPlayingAnimation,
      callback);
  }

  public playAod2ScreenLockAnimation(isSupportAod: boolean, isPlayingAnimation: boolean = true): void {
    this.playAnimation(DynamicWallPaperState.AOD, DynamicWallPaperState.SCREENLOCK, isSupportAod, isPlayingAnimation);
  }

  public playScreenLock2AodAnimation(isSupportAod: boolean, isPlayingAnimation: boolean, callback?: Function): void {
    this.playAnimationWithNotify(DynamicWallPaperState.SCREENLOCK, DynamicWallPaperState.AOD,
      isSupportAod, isPlayingAnimation, callback);
  }

  public playDesktop2AodAnimation(isSupportAod: boolean, isPlayingAnimation: boolean, callback?: Function): void {
    this.playAnimationWithNotify(DynamicWallPaperState.DESKTOP, DynamicWallPaperState.AOD,
      isSupportAod, isPlayingAnimation, callback);
  }

  public playDesktop2SleepAnimation(isSupportAod: boolean, isPlayingAnimation: boolean, callback?: Function): void {
    let target = DynamicWallPaperState.DEFAULT;
    if (this.isPartAod) {
      target = DynamicWallPaperState.AOD;
    }
    this.playAnimationWithNotify(DynamicWallPaperState.DESKTOP, target, isSupportAod, isPlayingAnimation, callback);
  }

  public playScreenLock2SleepAnimation(isSupportAod: boolean, isPlayingAnimation: boolean, callback?: Function): void {
    let target = DynamicWallPaperState.DEFAULT;
    if (this.isPartAod) {
      target = DynamicWallPaperState.AOD;
    }
    this.playAnimationWithNotify(DynamicWallPaperState.SCREENLOCK, target, isSupportAod, isPlayingAnimation, callback);
  }

  public playScreenOff2ScreenLockAnimation(isSupportAod: boolean,
                                           isPlayingAnimation: boolean, callback?: Function): void {
    let target = DynamicWallPaperState.DEFAULT;
    if (this.isPartAod) {
      target = DynamicWallPaperState.AOD;
    }
    this.playAnimationWithNotify(target, DynamicWallPaperState.SCREENLOCK, isSupportAod, isPlayingAnimation, callback);
  }

  public playScreenOff2DesktopAnimation(isSupportAod: boolean, isPlayingAnimation: boolean, callback?: Function): void {
    let target = DynamicWallPaperState.DEFAULT;
    if (this.isPartAod) {
      target = DynamicWallPaperState.AOD;
    }
    this.playAnimationWithNotify(target, DynamicWallPaperState.DESKTOP, isSupportAod, isPlayingAnimation, callback);
  }

  public playAod2DefaultAnimation(isSupportAod: boolean, isPlayingAnimation: boolean, callback?: Function): void {
    let target = DynamicWallPaperState.DEFAULT;
    if (this.isPartAod) {
      target = DynamicWallPaperState.AOD;
    }
    this.playAnimationWithNotify(DynamicWallPaperState.AOD, target, isSupportAod, isPlayingAnimation, callback);
  }

  private playAnimationWithNotify(origin: DynamicWallPaperState, target: DynamicWallPaperState, isSupportAod: boolean,
                                  isPlayingAnimation: boolean, callback?: Function) {
    log.showInfo(`wallpaper animation with callback start: ${DynamicWallPaperState[origin]} -> ${DynamicWallPaperState[target]}`);
    themeWallpaperAniMgr.reqPlayWallpaperAnimation({
      curState: origin,
      tarState: target,
      isOffScreenSupportAod: isSupportAod,
      onFinish: () => {
        log.showInfo(`wallpaper animation with callback end: ${DynamicWallPaperState[origin]} -> ${DynamicWallPaperState[target]}`);
        if (!!callback) {
          callback();
        }
      },
      isPlayingAnimation: isPlayingAnimation
    });
  }

  private playAnimation(origin: DynamicWallPaperState, target: DynamicWallPaperState, isSupportAod: boolean,
                        isPlayingAnimation: boolean, callback?: Function) {
    log.showInfo(`wallpaper animation start: ${DynamicWallPaperState[origin]} -> ${DynamicWallPaperState[target]}`);
    themeWallpaperAniMgr.reqPlayWallpaperAnimation({
      curState: origin,
      tarState: target,
      isOffScreenSupportAod: isSupportAod,
      onFinish: () => {
        log.showInfo(`wallpaper animation end: ${DynamicWallPaperState[origin]} -> ${DynamicWallPaperState[target]}`);
        callback?.();
      },
      isPlayingAnimation: isPlayingAnimation
    });
  }

  public beginScreenOn(): void {
    log.showInfo('beginScreenOn');
    themeWallpaperAniMgr.reqPlayWallpaperAnimation({
      curState: WALLPAPER_SCREEN_ON_START,
      tarState: WALLPAPER_SCREEN_ON_END,
      isOffScreenSupportAod: false,
      onFinish: () => { },
      isPlayingAnimation: false
    });
  }


  public syncAodPosition2Wallpaper(aodPosition: AodElemPosition): void {
    themeWallpaperAniMgr.syncAodPosition(aodPosition);
  }
}
