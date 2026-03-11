/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use inputConfig file except in compliance with the License.
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

import screenLock from '@ohos.screenLock';
import display from '@ohos.display';
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { SingletonHelper } from '@ohos/basicutils';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import { GlobalContext } from '../../utils/GlobalContext';
import { SCBConstants } from '@ohos/commonconstants';
import { sOutSideWindowMgr, WallpaperManager, WallpaperType } from '../../TsIndex';

const TAG = 'SCBDesktopCacheManager';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * 壁纸变化场景事件，通过位运算形式判断当前是否还有未结束的壁纸动效
 */
export enum SCBWallPaperChangeEvent {
  LOCK = 1, // 锁屏
  WALLPAPER_CHANGE = 1 << 1, // 壁纸切换
  SCREEN_ROTATE = 1 << 2, // 屏幕旋转
  SCREEN_FOLD_OR_EXPAND = 1 << 3, // 屏幕折展
  WALLPAPER_SCRIPT = 1 << 4 // 动态壁纸动效
}

export class SCBDesktopCacheManager {
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private desktopCacheState: boolean = false;
  private wallpaperFreezeReady: boolean = false;
  private wallpaperFreezeState: boolean = false;
  private wallpaperScale: number = 1.0;
  private wallpaperType: string = '';
  private rotationMode: number = -1;
  private isWallpaperChanging: boolean = false;
  private static instance?: SCBDesktopCacheManager;
  private scbWallPaperStatus: number = 0;

  private constructor() {}

  public static getInstance(): SCBDesktopCacheManager {
    if (!SCBDesktopCacheManager.instance) {
      SCBDesktopCacheManager.instance = new SCBDesktopCacheManager();
    }
    return SCBDesktopCacheManager.instance;
  }

  /**
   * expandStatus: 用来替换 SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()，即从上层传入，接触反向依赖
   */
  public setDesktopCacheWithDfx(cacheFlag: boolean, reason: string, onlyValidateFolderExpand: boolean,
    expandStatus: boolean): void {
    if ((sOutSideWindowMgr.isShowGlobalSearch() || sOutSideWindowMgr.isShowNegative()) && expandStatus) {
      log.showWarn(`global search or negative showing, setDesktopCacheWithDfx return reason: ${reason}`);
      return;
    }
    if (cacheFlag && onlyValidateFolderExpand && !expandStatus) {
      log.showInfo(`setDesktopCacheWithDfx return cacheFlag:${cacheFlag} reason:${reason}`);
      return;
    }
    log.showInfo(`setDesktopCacheWithDfx Validate cacheFlag:${cacheFlag} reason:${reason}`);
    this.desktopContext?.eventHub.emit('swiperPageCache', cacheFlag);
  }

  public setNegativeScreenFreezeStateWithDfx(freezeState: boolean, reason: string, rotation: number = -1): void {
    log.showInfo(`setNegativeScreenFreezeStateWithDfx freezeState:${freezeState}, rotation:${rotation}, reason:${reason}`);
    this.desktopContext?.eventHub.emit(SCBConstants.IS_FREEZE_FOR_QUICKSWITCH, freezeState);
    if (!freezeState) {
      log.showInfo(`setNegativeScreenFreezeStateWithDfx return freezeState: false`);
      return;
    }
    if (this.wallpaperFreezeState !== freezeState) {
      this.setWallPaperFreezeState(freezeState, reason, rotation);
    }
  }

  /**
   * set desktop blur freeze state.
   *
   * @param freezeState freeze状态
   * @param reason dfx信息
   * @param onlyFolderOpen 是否仅在文件夹展开态生效
   * @param expandStatus 用来替换 SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()，即从上层传入，解除反向依赖
   */
  public setDesktopFreezeStateByWindowWithDfx(freezeState: boolean, reason: string, rotation: number = -1,
    expandStatus: boolean): void {
    if (freezeState && !expandStatus) {
      log.showInfo(`setDesktopFreezeStateByWindowWithDfx return freezeState:${freezeState}, rotation:${rotation}, reason:${reason}`);
      return;
    }
    if (!freezeState) {
      log.showInfo(`setDesktopFreezeStateByWindowWithDfx return freezeState: false`);
      return;
    }
    if (this.wallpaperFreezeState !== freezeState) {
      this.setWallPaperFreezeState(freezeState, reason, rotation);
    }
  }

  // rotationMode屏幕旋转类型 0-竖屏 1-横屏
  private getRotationMode(): number {
    let rotationMode: number;
    let isPortrait: boolean | undefined = AppStorage.get<boolean>('isPortrait');
    if (isPortrait === false) {
      rotationMode = 1;
    } else {
      rotationMode = 0;
    }
    return rotationMode;
  }

  /**
   * 设置当前壁纸动效事件状态
   *
   * @limit 只有持续一段时间的动效可以设置事件，需要有设置有取消
   * @param event 壁纸变化场景事件，通过位运算形式判断当前是否还有未结束的壁纸动效
   */
  public setWallPaperEvent(event: SCBWallPaperChangeEvent): void {
    if (this.scbWallPaperStatus & event) {
      return;
    }
    log.showWarn(`FreezeTrack setWallPaperEvent add ${event}`);
    this.scbWallPaperStatus = this.scbWallPaperStatus | event;
    this.resetFreezeStateOnly(`setWallPaperEvent_${this.scbWallPaperStatus}`);
  }

  /**
   * 取消当前壁纸动效事件状态
   *
   * @limit 只有持续一段时间的动效可以设置事件，需要有设置有取消
   * @param event 壁纸变化场景事件，通过位运算形式判断当前是否还有未结束的壁纸动效
   */
  public removeWallPaperEvent(event: SCBWallPaperChangeEvent): void {
    if (this.scbWallPaperStatus & event) {
      log.showWarn(`FreezeTrack removeWallPaperEvent event ${event}`);
      this.scbWallPaperStatus = this.scbWallPaperStatus ^ event;
    }
  }

  public setWallPaperFreezeState(freezeState: boolean, reason: string, rotation: number = -1): void {
    if (this.wallpaperFreezeState === freezeState) {
      log.showWarn(`FreezeTrack return old:${this.wallpaperFreezeState}, new:${freezeState}, ` +
        `ready:${this.wallpaperFreezeReady}, scale:${this.wallpaperScale}, reason:${reason}`);
      return;
    }
    let rotationMode: number = this.getRotationMode();
    log.showWarn('FreezeTrack SetFreeze old:%{public}s, new:%{public}s, reason:%{public}s,' +
      'ready:%{public}s isWallpaperChanging:%{public}s , scbWallPaperStatus:%{public}d',
      this.wallpaperFreezeState, freezeState, reason, this.wallpaperFreezeReady, this.isWallpaperChanging,
      this.scbWallPaperStatus);
    if (freezeState) {
      // 静态壁纸或壁纸动效已完成
      if (this.wallpaperFreezeReady && this.wallpaperScale === 1 && !this.isWallpaperChanging) {
        this.rotationMode = rotationMode;
        this.wallpaperFreezeState = true;
        this.desktopContext?.eventHub.emit(SCBConstants.DESKTOP_IS_FREEZE, true);
      }
    } else {
      // unFreeze场景
      this.wallpaperFreezeReady = false;
      this.wallpaperFreezeState = false;
      this.rotationMode = -1;
      this.desktopContext?.eventHub.emit(SCBConstants.DESKTOP_IS_FREEZE, false);
    }
  }

  /**
   * 解锁一镜到底动效结束后通知桌面设置wallpaperReady
   * 如果是动态壁纸则设置成壁纸动效状态(解锁后会做壁纸动效动效，此时壁纸未ready)
   * 如果不是动态壁纸则尝试设置ready
   *
   * @limit: 只有解锁一镜到底动效结束可调用，提前调用会提前ready，可能会导致模糊过早freeze，背板显示异常
   *
   */
  public screenUnlockAnimationFinish(): void {
    log.showInfo(`screenUnlockAnimationFinish wallpaperType:${this.wallpaperType}`);
    if (this.wallpaperType !== 'script') {
      this.setWallPaperFreezeReady(true, 'UnLockAnimation');
    } else {
      this.setWallPaperEvent(SCBWallPaperChangeEvent.WALLPAPER_SCRIPT);
    }
  }

  public setWallPaperFreezeReady(freezeReady: boolean, reason: string): void {
    if (this.wallpaperFreezeReady === freezeReady) {
      return;
    }
    log.showWarn('FreezeTrack setWallPaperFreezeReady old:%{public}s, new:%{public}s, reason:%{public}s,' +
      ' isWallpaperChanging:%{public}s , scbWallPaperStatus:%{public}d', this.wallpaperFreezeReady, freezeReady,
      reason, this.isWallpaperChanging, this.scbWallPaperStatus);
    if (!freezeReady) {
      this.wallpaperFreezeReady = freezeReady;
    } else if (this.isWallpaperChanging || this.scbWallPaperStatus !== 0) {
      log.showWarn(`FreezeTrack setWallPaperFreezeReady not support, cause wallpaperChanging`);
      return;
    } else {
      let lockStatus = true;
      try {
        lockStatus = screenLock.isLocked();
        log.showWarn(`FreezeTrack get lockStatus: ${lockStatus}`);
      } catch (err) {
        log.showError(`FreezeTrack get lockStatus error, code:${err?.code}, message:${err?.message}`);
        return;
      }
      if (!lockStatus) {
        // 只能在解锁情况下，设置freezeReady为true，且要先unFreeze
        this.resetFreezeStateOnly(reason + '_forSetFreezeReadyTrue');
        this.wallpaperFreezeReady = freezeReady;
      }
    }
  }

  public setWallPaperScale(scale: number, reason: string): void {
    log.showInfo(`FreezeTrack setWallPaperScale old:${this.wallpaperScale}, new:${scale}, reason:${reason}`);
    this.wallpaperScale = scale;
  }

  public resetFreezeStateAndReady(reason: string): void {
    log.showWarn(`FreezeTrack resetFreezeStateAndReady old:${this.wallpaperFreezeState}, reason:${reason}`);
    this.wallpaperFreezeReady = false;
    this.resetFreezeStateOnly('resetFreezeStateAndReady');
  }

  /**
   * 壁纸修改中，用来单独隔离壁纸修改中状态，保证壁纸修改中不被设置freeze
   * @param: isStart 是否壁纸修改开始
   */
  public wallpaperChanging(isStart: boolean): void {
    if (this.isWallpaperChanging === isStart) {
      return;
    }
    log.showWarn(`FreezeTrack wallpaperChanging old:${this.isWallpaperChanging}, isStart:${isStart}`);
    this.isWallpaperChanging = isStart;
    if (isStart) {
      this.setWallPaperEvent(SCBWallPaperChangeEvent.WALLPAPER_CHANGE);
      this.resetFreezeStateAndReady('wallPaperChange');
      return;
    }
    this.removeWallPaperEvent(SCBWallPaperChangeEvent.WALLPAPER_CHANGE);
    if (this.getWallPaperType() !== 'script') {
      this.setWallPaperFreezeReady(true, 'ThemeFinishLoading');
    } else {
      this.setWallPaperEvent(SCBWallPaperChangeEvent.WALLPAPER_SCRIPT);
    }
  }

  /**
   *
   * @param changeResult 仅作为判断，上层调用时传入比较的结果作为判断的条件解耦反向依赖
   * reason === SCBPropertyChangeReason.EXPAND_TO_FOLD || reason === SCBPropertyChangeReason.FOLD_TO_EXPAND
   */
  public resetFreezeStateByScreenChange(changeResult: boolean): void {
    log.showWarn(`FreezeTrack resetFreezeStateByScreenChange old:${this.wallpaperFreezeState}, changeResult:${changeResult}`);
    // 屏幕开合场景需要unFreeze，但是没有unFreezeReady，动效中启动可能出现freeze的壁纸对不齐
    if (!this.wallpaperFreezeState) {
      return;
    }
    if (changeResult) {
      this.wallpaperFreezeState = false;
      this.desktopContext?.eventHub.emit(SCBConstants.DESKTOP_IS_FREEZE, false);
    }
  }

  /**
   * 重置桌面Freeze状态为false
   *
   * @param reason 重置原因
   */
  public resetFreezeStateOnly(reason: string): void {
    log.showWarn(`FreezeTrack resetFreezeStateOnly old:${this.wallpaperFreezeState}, reason:${reason}`);
    if (this.wallpaperFreezeState) {
      this.wallpaperFreezeState = false;
      this.desktopContext?.eventHub.emit(SCBConstants.DESKTOP_IS_FREEZE, false);
    }
  }

  public getWallpaperFreezeState(): boolean {
    return this.wallpaperFreezeState;
  }

  public checkRotation(): void {
    let rotationMode: number = this.getRotationMode();
    log.showWarn(`FreezeTrack checkRotation rotationMode old:${this.rotationMode}, now:${rotationMode}`);
    if (rotationMode !== this.rotationMode && this.wallpaperFreezeState) {
      this.rotationMode = -1;
      this.resetFreezeStateOnly('checkRotation');
    }
  }

  /**
   * set desktop cache state.
   *
   * @param isUseCache
   * @param reason judge source
   */
  public setDesktopCacheState(isUseCache: boolean, reason: string): void {
    if (this.desktopCacheState !== isUseCache) {
      log.showInfo(`setDesktopCacheStateWithDfx isUseCache:${isUseCache} reason:${reason}`);
      this.desktopContext?.eventHub.emit(SCBConstants.THEME_EDIT, isUseCache);
      this.desktopCacheState = isUseCache;
    }
  }

  public updateWallPaperType(): void {
    let type: string = WallpaperManager.getInstance().getType(WallpaperType.DESKTOP);
    this.wallpaperType = type;
    log.showInfo(`updateWallPaperType: ${type}`);
  }

  public getWallPaperType(): string {
    return this.wallpaperType;
  }
}