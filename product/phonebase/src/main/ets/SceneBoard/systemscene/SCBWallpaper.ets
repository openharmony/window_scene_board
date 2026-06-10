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
  SCBUnlockTransitionController,
  SCBTransitionManager,
  SCBScreenSessionManager,
  SCBScreenProperty,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBTransitionController,
} from '@ohos/windowscene';
import {
  viewMgrPolicy,
  ViewType,
  sOutSideWindowMgr,
  WallpaperManager,
  WallpaperData,
  SCBDesktopCacheManager,
  DeviceHelper,
  ViewCallback,
  TrimLevel,
} from '@ohos/frameworkwrapper';
import { CommonUtils, LogHelper, LogDomain } from '@ohos/basicutils';
import { BaseViewController, } from '@ohos/frameworkcommon';
import { DesktopWallpaper } from '@ohos/wallpapercomponent/src/main/ets/wallpaper/view/DesktopWallpaper';
import lazy { SCBKGBackWallpaper } from '@ohos/screenlockcomponent/src/main/ets/wallpaper/SCBKGBackWallpaper';
import DesktopUtils from '@ohos/pagedesktop/src/main/ets/default/common/DesktopUtils';
import curves from '@ohos.curves';
import image from '@ohos.multimedia.image';
import { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import {
  ScreenLockState,
  ScreenLockStateListener,
  screenLockStateManager,
} from '@ohos/screenlockcommon';
import EditModeWallpaper from '@ohos/desktopedit/src/main/ets/default/view/EditModeWallpaper';
import { dtWallpaperStateMgr } from '@ohos/wallpapercomponent/src/main/ets/wallpaper/model/DesktopWallpaperModel';
import { AdaptiveIconManager } from '@ohos/launchercommon';

const TAG = 'SCBWallpaper'
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct SCBWallpaper {
  @Link screenProp: SCBScreenProperty;
  @State wallpaperData: WallpaperData = WallpaperManager.getInstance().wallpaperData;
  @State viewController: BaseViewController = new BaseViewController(ViewType.WALLPAPER);
  @StorageLink('watermarkImage') watermarkImage: ResourceStr | image.PixelMap | DrawableDescriptor | null = null;
  @StorageLink('editorTranslate') editorTranslate: number = 0;
  @StorageLink('wallPaperOpacity') wallPaperOpacity: number = 1;
  @StorageLink('wallPaperBlurRadius') wallPaperBlurRadius: number = 0;
  @StorageProp('isFoldFullDisplay') @Watch('onFoldFullDisplayChange') isFoldFullDisplay: boolean = false;
  persistentId: number = 0;
  private unLockTransitionController: SCBUnlockTransitionController | undefined = undefined;
  private globalTransitionController: SCBTransitionController = {
    appData: {
      bundleName: '',
      abilityName: '',
      appIconId: `${TAG}Global`,
      appIconNumber: 0,
      iconRadius: 0,
    },
    onActive: (): void => this.onActive(),
    onInactive: (): void => this.onInactive(),
    onActiveWithNoAnim: (): void => this.onActiveWithNoAnim(),
    onInactiveWithNoAnim: (): void => this.onInactive(false)
  }

  @State isInScreenLockState: boolean = false;
  private screenLockStateListener: ScreenLockStateListener = {
    onEnterHost: () => {
      this.isInScreenLockState = true;
    },
    onExitKeyguard: () => {
      this.isInScreenLockState = false;
    }
  };
  private memoryCallback: ViewCallback = {
    onTrimMemory: (level: TrimLevel): void => this.onTrimMemory(level),
  };

  private onTrimMemory(level: TrimLevel): void {
    log.showInfo(`onTrimMemory start with level ${level}`);
    switch (level) {
      case TrimLevel.CRITICAL:
        WallpaperManager.getInstance().releaseWallpaperCacheMap(false);
        AdaptiveIconManager.getInstance().clearIconResources('release wallpaper memory');
        break;
    }
  }

  private onFoldFullDisplayChange() :void {
  }

  private screenPropertyChangeCallback: Function =
    (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void => {
      if (reason === SCBPropertyChangeReason.CHANGE_MODE || reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION ||
        reason === SCBPropertyChangeReason.PAGE_ROTATION ||
        reason === SCBPropertyChangeReason.FOLD_TO_EXPAND || reason == SCBPropertyChangeReason.EXPAND_TO_FOLD ||
        reason === SCBPropertyChangeReason.FOLD_LANDSCAPE_START) {
        this.viewController.updateRect({
          left: 0,
          top: 0,
          width: px2vp(screenProperty.width),
          height: px2vp(screenProperty.height)
        });
      }
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    viewMgrPolicy.registerViewController(ViewType.WALLPAPER, this.viewController);
    this.viewController.registerCallback(this.memoryCallback);
    this.viewController.updateId(this.persistentId);
    this.viewController.show();
    SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId)?.setSystemSceneOcclusionAlpha(1);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback, undefined, false, this.persistentId);

    SCBTransitionManager.getInstance().registerGlobalTransitionController(this.globalTransitionController);
    this.registerUnlockTransitionController()
    screenLockStateManager.registerScreenLockState(this.screenLockStateListener);
  }

  aboutToDisappear(): void {
    this.viewController.unRegisterCallback(this.memoryCallback);
    SCBTransitionManager.getInstance().unRegisterUnlockTransitionController(this.unLockTransitionController, true);
    screenLockStateManager.unregisterScreenLockState(this.screenLockStateListener);
    viewMgrPolicy.unregisterViewController(ViewType.WALLPAPER);
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback, undefined, false, this.persistentId);
    SCBTransitionManager.getInstance().unRegisterGlobalTransitionController(this.globalTransitionController);
  }

  private registerUnlockTransitionController(): void {
    this.unLockTransitionController = {
      name: TAG,
      onLock: (): void => this.onLockReceived(),
      onUnlock: (): void => this.onUnLockReceived()
    }
    SCBTransitionManager.getInstance().registerUnlockTransitionController(this.unLockTransitionController, true);
  }

  private needZoomIn(): boolean {
    if (sOutSideWindowMgr.isShowGlobalSearch()) {
      log.showDebug('global search showing. return');
      return false;
    }
    if (sOutSideWindowMgr.isShowNegative()) {
      log.showDebug('negative showing. return');
      return false;
    }
    if (AppStorage.get<string>('openFolderId') !== '-1') {
      log.showDebug('folder is open. return');
      return false;
    }
    if (screenLockStateManager.currentState !== ScreenLockState.EXIT_KEYGUARD) {
      log.showDebug('in screenLock. return');
      return false;
    }
    return true;
  }

  onActive() {
    if (!this.needZoomIn()) {
      return;
    }
    animateTo({
      delay: 50,
      curve: curves.springMotion(0.26, 1.157, 0),
      onFinish: () => {
        SCBDesktopCacheManager.getInstance().setWallPaperScale(1.1, 'onActive');
      },
    }, () => {
      log.showDebug('onActive wallpaperScale %{public}d', this.wallpaperData.wallpaperScale);
      this.wallpaperData.wallpaperScale = 1.1;
    })
  }

  onActiveWithNoAnim() {
    if (!this.needZoomIn()) {
      return;
    }
    log.showDebug('onActiveWithNoAnim wallpaperScale %{public}d', this.wallpaperData.wallpaperScale);
    this.wallpaperData.wallpaperScale = 1.1;
    SCBDesktopCacheManager.getInstance().setWallPaperScale(1.1, 'onActiveWithNoAnim');
  }

  onInactive(isAnim: boolean = true) {
    if (sOutSideWindowMgr.isShowGlobalSearch()) {
      log.showDebug('global search showing. return');
      return;
    }
    if (sOutSideWindowMgr.isShowNegative()) {
      log.showDebug('negative showing. return');
      return;
    }
    if (CommonUtils.equals(this.wallpaperData.wallpaperScale, 1.0)) {
      log.showDebug('wallpaperScale not change. return');
      SCBDesktopCacheManager.getInstance().setWallPaperScale(1.0, 'onInactive');
      return;
    }
    if (!isAnim) {
      log.showDebug('onInactive. isAnim %{public}s, wallpaperScale %{public}d',
        isAnim, this.wallpaperData.wallpaperScale);
      this.wallpaperData.wallpaperScale = 1;
      SCBDesktopCacheManager.getInstance().setWallPaperScale(1.0, 'onInactive');
      return;
    }
    animateTo({
      curve: curves.springMotion(0.45, 0.825, 0),
      onFinish: () => {
        SCBDesktopCacheManager.getInstance().setWallPaperScale(1.0, 'onInactive');
      },
    }, () => {
      log.showDebug('onInactive wallpaperScale %{public}d', this.wallpaperData.wallpaperScale);
      this.wallpaperData.wallpaperScale = 1;
    })
  }

  private onUnLockReceived(): void {
    log.showInfo(`remote window animaion onScreenUnlock`);
    if (!DesktopUtils.isSupportLockAnimation()) {
      return;
    }

    // If ThemeEngine is enabled, do not play scaling animation here.
    if (!dtWallpaperStateMgr.getDtWallpaperState().isShowDefaultsWallpaper()) {
      return;
    }
    animateTo({
      duration: 1000,
      curve: curves.cubicBezier(0.3, 0.0, 0.3, 1.0),
      onFinish: () => {
        SCBDesktopCacheManager.getInstance().setWallPaperScale(1.0, 'onUnLockReceived');
      },
    }, () => {
      this.wallpaperData.wallpaperScale = 1.0;
    })
  }

  private onLockReceived(): void {
    log.showDebug(`remote window animaion onScreenlock`);
    if (!DesktopUtils.isSupportLockAnimation()) {
      return;
    }
    AppStorage.setOrCreate('isAppIconShow', true);

    // If ThemeEngine is enabled, do not play scaling animation here.
    if (!dtWallpaperStateMgr.getDtWallpaperState().isShowDefaultsWallpaper()) {
      return;
    }
    animateTo({
      duration: 200,
      curve: Curve.Linear,
      onFinish: () => {
        SCBDesktopCacheManager.getInstance().setWallPaperScale(1.05, 'onLockReceived');
      },
    }, () => {
      this.wallpaperData.wallpaperScale = 1.05;
    })
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      if (this.wallpaperData.showBackWallpaper) {
        SCBKGBackWallpaper()
      }
      Column() {
        DesktopWallpaper({ screenProp: this.screenProp})
      }
      .opacity(this.wallPaperOpacity)
      .borderRadius(this.wallpaperData.wallpaperScale < 1 ? $r('app.float.wallpaper_outline_radius') : 0)
      .clip(true)
      .width('100%')
      .height('100%')
      .scale({
        x: this.wallpaperData.wallpaperScale,
        y: this.wallpaperData.wallpaperScale
      })
      .translate({ y: -this.editorTranslate })

      if (this.isInScreenLockState) {
        Row()
          .alignRules({
            top: {
              anchor: '__container__', align: VerticalAlign.Top
            }
          })
          .border({
            width: this.wallpaperData.wallpaperScale < 1 ? $r('app.float.wallpaper_outline_width') : 0,
            color: $r('app.color.wallpaper_outline_color'),
            radius: this.wallpaperData.wallpaperScale < 1 ? $r('app.float.wallpaper_outline_radius') : 0,
            style: BorderStyle.Solid
          })
          .shadow(ShadowStyle.OUTER_DEFAULT_MD)
          .width('100%')
          .height('100%')
          .scale({
            x: this.wallpaperData.wallpaperScale,
            y: this.wallpaperData.wallpaperScale
          })
          .translate({ y: -this.editorTranslate })
          .opacity(this.wallPaperOpacity)
      }
      if (this.watermarkImage) {
        Column() {
          Image(this.watermarkImage)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Fill)
            .draggable(false)
            .id('SCBWallpaper_MaskImage')
            .onAppear(() => {
              log.showInfo(`SCBWallPaper_MaskImage is on appear`);
            })
        }
      }
      EditModeWallpaper()
    }
  }
}
