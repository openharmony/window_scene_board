/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBScreenProperty, SCBSceneSessionManager, SystemSessionInfo,
  SCBSystemSceneSession,
  SCBScreenSessionManager,
  SCBPropertyChangeReason, } from '@ohos/windowscene';
import { LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';

import LockScreenAnimationController from '../screenlock/common/LockScreenAnimationController';
import { SCBDefaultZIndex } from '../scenemanager/SCBScreen';
import { BaseViewController } from '@ohos/frameworkcommon';
import {
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  WallpaperManager
} from '@ohos/frameworkwrapper';
import { CloneWallpaperModel, CloneWallpaperMgr } from './ViewModel/CloneWallpaperMgr';
import { SCBConstants } from '@ohos/commonconstants';
import { StyleConstants } from '@ohos/launchercommon';
import { image } from '@kit.ImageKit';
import fileUri from '@ohos.file.fileuri';
import { DEFAULT_DIAGONAL_LENGTH } from './SCBWallpaper';
import PcFileAccess from '../../common/controller/PcFileAccess';

const TAG = 'SCBCloneWallpaper';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const LAND_RESOURCE: string = 'land';
const BASE_RESOURCE: string = 'base';

@Component
export struct SCBCloneWallpaper {
  @Link screenProp: SCBScreenProperty;
  @State viewController: BaseViewController | undefined = undefined;
  persistentId: number = 0;
  @StorageLink('wallpaperZIndex') @Watch('wallpaperZIndexChanged') wallpaperZIndex: number = SCBDefaultZIndex.WALLPAPER;
  private isMainScreen = true;
  private cmdId: number = -1;
  @State wallpaperModel: CloneWallpaperModel = CloneWallpaperMgr.getInstance(this.screenProp.screenId)
    .getCloneWallpaperModel();
  @StorageLink('desktopWallpaperChange') @Watch('onDesktopWallpaperChange') wallPaper: image.PixelMap | null = null;
  @State themePath: string = '';
  @StorageLink('engineThemeStatic') engineThemeStatic: boolean = true;
  @State dtScale: number = 1;

  private systemSessionInfo: SystemSessionInfo = {
    systemType: sceneSessionManager.SessionType.TYPE_PANEL,
    sceneName: 'WALLPAPER_CLONE',
    sceneZIndex: SCBDefaultZIndex.SCREEN_LOCK_WALL_PAPER,
    isFocusable: false,
    isTouchable: false,
    isRotatable: false,
    privacyMode: false,
    hitTestMode: HitTestMode.Default,
    sceneType: sceneSessionManager.SceneType.SYSTEM_WINDOW_SCENE,
  };

  private wallPaperSession: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
    .requestSystemSceneSession(this.systemSessionInfo, undefined, false, this.screenProp.screenId);

  private wallpaperZIndexChanged(): void {
    log.showInfo(`wallpaperZIndexChanged:${this.wallpaperZIndex} ${this.isMainScreen}`);
    if (this.wallpaperZIndex === SCBDefaultZIndex.SCREEN_LOCK_WALL_PAPER && this.isMainScreen) {
      CloneWallpaperMgr.getInstance(this.screenProp.screenId).updateZIndex(this.wallpaperZIndex - 1);
      this.viewController?.hide();
    }
  }
  private onDesktopWallpaperChange(): void {
    try {
      let themePath = WallpaperManager.getInstance().themePath;
      this.themePath = fileUri.getUriFromPath(themePath);
    } catch (error) {
      this.themePath = '';
      log.showError(`onDesktopWallpaperChange get themePath error ${error.code} ${error.message}`);
    }
  }

  aboutToAppear() {
    this.isMainScreen = this.screenProp.screenId === SCBSceneSessionManager.getInstance().mainScreenId;
    log.showInfo(`aboutToAppear ${this.screenProp.screenId} isMainScreen ${this.isMainScreen}`);
    this.viewController = new BaseViewController(ViewType.WALLPAPER_SCREEN_LOCK, this.screenProp.screenId);
    viewMgrPolicy.registerViewController(ViewType.WALLPAPER_SCREEN_LOCK, this.viewController);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    this.viewController.updateId(this.persistentId);
    const wallpaperId: number = this.wallPaperSession?.session.persistentId;
    CloneWallpaperMgr.getInstance(this.screenProp.screenId).initViewController(this.viewController, wallpaperId);
    if (this.isMainScreen) {
      LockScreenAnimationController.getInstance().addInitCallback(
        LockScreenAnimationController.LOCK_SCREEN_WALLPAPER_CALLBACK, () => {
        this.cmdId = CloneWallpaperMgr.getInstance(this.screenProp.screenId).show(false);
        log.showInfo(`show cloneWallpaper ${this.cmdId}`);
      })
      LockScreenAnimationController.getInstance().registerCallback(
        LockScreenAnimationController.LOCK_SCREEN_WALLPAPER_CALLBACK, () => {
        TraceUtil.startTrace(TAG, 'screenLockWallpaper');
        log.showInfo(`hide cloneWallpaper ${this.cmdId}`);
        CloneWallpaperMgr.getInstance(this.screenProp.screenId).hide(this.cmdId);
      }, () => {
        log.showInfo('unlockFinishCallback');
        CloneWallpaperMgr.getInstance(this.screenProp.screenId).hideFinish(this.cmdId);
        TraceUtil.endTrace(TAG, 'screenLockWallpaper');
      });
    }
  }

  onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    this.viewController?.updateRectInPx({
      left: 0,
      top: 0,
      width: screenProperty.width,
      height: screenProperty.height
    })
  };

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear ${this.screenProp.screenId} isMainScreen ${this.isMainScreen}`);
    SCBSceneSessionManager.getInstance()
      .requestSystemSceneSessionDestruction(this.wallPaperSession, this.screenProp.screenId);
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange, this.screenProp.screenId);
    CloneWallpaperMgr.release(this.screenProp.screenId);
  }

  @Builder
  blurBuilder() {
    Stack()
      .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
      .backgroundEffect({
        policy: 1,
        radius: SCBConstants.APP_CENTER_BG_BLUR_RADIUS,
        saturation: 1.4,
        brightness: 1,
      })
    Stack()
      .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
      .backgroundColor(this.wallpaperModel.bcColor)
  }

  @Builder
  imageBuilder() {
    if (this.wallpaperModel.isBlur) {
      Image(this.themePath ?? this.wallPaper)
        .draggable(false)
        .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
        .objectFit(ImageFit.Cover)
        .scale({
          x: this.engineThemeStatic ? StyleConstants.DEFAULT_WALLPAPER_SCALE : this.dtScale,
          y: this.engineThemeStatic ? StyleConstants.DEFAULT_WALLPAPER_SCALE : this.dtScale
        })
      this.blurBuilder()
    } else {
      WindowScene(this.wallPaperSession?.session.persistentId)
        .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
        .focusable(false)
        .enabled(false)
    }
  }

  @Builder
  windowBuilder() {
    WindowScene(this.wallPaperSession?.session.persistentId)
      .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
      .focusable(false)
      .enabled(false)
    if (this.wallpaperModel.isBlur) {
      this.blurBuilder()
    }
  }

  build() {
    Stack() {
      this.windowBuilder()
    }
    .width('100%')
    .height('100%')
    .opacity(this.wallpaperModel.winOpacity)
  }
}
