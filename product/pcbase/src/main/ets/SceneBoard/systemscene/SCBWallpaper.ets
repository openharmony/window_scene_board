/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { DesktopWallpaper } from '@ohos/wallpapercomponent/src/main/ets/wallpaper/view/DesktopWallpaper';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex'
import { Log, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  viewMgrPolicy,
  ViewType,
  GlobalContext
} from '@ohos/frameworkwrapper';
import {
  sSCBOobeManager,
  SCBScreenProperty,
  SCBPropertyChangeReason,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
} from '@ohos/windowscene';
import { PowerStatus } from '@ohos/commonconstants';
import { AnimationType, themeWallpaperAniMgr, DynamicWallPaperState, } from '@ohos/themeservice';
import { BaseViewController } from '@ohos/frameworkcommon';
import image from '@ohos.multimedia.image';
import { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import PowerStatusChangeAnimationController from '../scenemanager/PowerStatusChangeAnimationController';
import LockScreenAnimationController from '../screenlock/common/LockScreenAnimationController';
import {SCBScreenPowerEventType,
  SCBScreenPowerEventStatus,
  SCBScreenPowerStatusChangeReason,
  SCBScreenPowerEvent,
  SCBDefaultZIndex
} from '../scenemanager/SCBScreen';
import { CloneWallpaperMgr } from './ViewModel/CloneWallpaperMgr';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { ThemeServiceHelper } from '@ohos/wallpapercomponent/src/main/ets/themeassistant/ThemeServiceHelper';
import { display } from '@kit.ArkUI';
import { FullScreenEvent } from '@ohos/pcsmartdock';
import ScreenLockService from '../screenlock/refactor/ScreenLockService';

const TAG = 'SCBWallpaper';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export const DEFAULT_DIAGONAL_LENGTH: number = 4120;
const DIVIDE_NUM: number = 2;
// Wallpaper Default Aspect Ratio
const DEFAULT_ASPECT_RATIO: number = 1.5;
const DEFAULT_PAPER_HEIGHT: number = 2080;

const THEME_FINISH_LOADING_EVENT = 'ThemeFinishLoading';
const WALLPAPER_FREEZE_TAG = 'WallpaperFreezeTag';

@Component
export struct SCBWallpaper {
  @Link screenProp: SCBScreenProperty;
  @State viewController: BaseViewController | undefined = undefined;
  persistentId: number = 0;
  @State scaleValue: number = LockScreenAnimationController.DESKTOP_WALLPAPER_SCALE_RATIO;
  @StorageLink('watermarkImage') watermarkImage: ResourceStr | image.PixelMap | DrawableDescriptor | null = null;
  @StorageLink('isLock') @Watch('onLock') isLock: boolean = true;
  // Used for shutdown animation
  @State wallpaperOpacity: number = PowerStatusChangeAnimationController.DEFAULT_OPACITY_RATIO;
  @StorageLink('powerStatus') @Watch('onPowerStatusChange') powerStatus: PowerStatus = PowerStatus.RUNNING;
  @StorageLink('clickLogout') @Watch('onClickLogout') clickLogout: boolean = false;
  @StorageLink('engineThemeStatic') engineThemeStatic: boolean = true;
  @StorageLink('screenPowerEvent') @Watch('updateScreenPowerAnimation') powerEvent:
    SCBScreenPowerEvent = new SCBScreenPowerEvent;
  @StorageLink('wallpaperZIndex') @Watch('wallpaperZIndexChanged') wallpaperZIndex: number = SCBDefaultZIndex.WALLPAPER;
  private mWallpaperSubscriber: commonEventManager.CommonEventSubscriber | null = null;
  private isWallpaperFinishLoadingFirstTime: boolean = false;
  private viewType = ViewType.WALLPAPER;
  private isMainScreen = true;
  private viewDiagonalLength: number = 0;
  private displaySourceMode: display.DisplaySourceMode = display.DisplaySourceMode.NONE;
  private onFullScreenEvent: (event: FullScreenEvent) => void = (event) => this.onFullScreenChange(event);

  private updateDisplaySourceMode(): void {
    if (!this.isMainScreen) {
      return;
    }
    let currentSourceMode: display.DisplaySourceMode = this.screenProp.screenId === this.screenProp.rsId ?
      display.DisplaySourceMode.MAIN : display.DisplaySourceMode.EXTEND;
    log.showInfo(TAG, `updateDisplaySourceMode, lastSourceMode: ${this.displaySourceMode},\
     currentSourceMode: ${currentSourceMode}`);
    if (currentSourceMode !== this.displaySourceMode) {
      this.displaySourceMode = currentSourceMode;
    }
  }

  private onFullScreenChange(event: FullScreenEvent): void {
    log.showInfo(`onFullScreenChange isFull:${event.isFullScreen}, screenId:${event.screenId}`);
    if (this.screenProp.screenId !== event.screenId) {
      log.showInfo(`screenId mismatch, no need to chage scene state`);
      return;
    }
  }

  private initWallpaperSubscriber(): void {
    // 5s未收到主题切换成功事件，自动解除锁定
    setTimeout(() => {
      if (!this.isWallpaperFinishLoadingFirstTime) {
        log.showInfo(`receive no publish event, force wallpaper finish loading`);
        this.isWallpaperFinishLoadingFirstTime = true;
      }
    }, 5000);

    try {
      let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
        events: [THEME_FINISH_LOADING_EVENT],
      };

      commonEventManager.createSubscriber(subscribeInfo).then((res) => {
        this.mWallpaperSubscriber = res;
        commonEventManager.subscribe(this.mWallpaperSubscriber, this.wallpaperEventCallback);
      });
    } catch (e) {
      log.showError(TAG, `FreezeTrack commonEventManager createSubscriber error ${e}`);
    }
  }

  private destroyWallpaperSubscriber(): void {
    if (this.mWallpaperSubscriber) {
      try {
        commonEventManager.unsubscribe(this.mWallpaperSubscriber);
        this.mWallpaperSubscriber = null;
      } catch (e) {
        log.showError(TAG, `FreezeTrack commonEventManager unsubscribe error ${e}`);
      }
    }
  }

  private wallpaperEventCallback = (err: BusinessError, eventData: commonEventManager.CommonEventData): void => {
    if (err) {
      log.showError(`wallpaperEventCallback failed, code:${err.code}, message:${err.message}`);
      return;
    }
    if (!eventData) {
      log.showError('wallpaperEventCallback failed, eventData is empty');
      return;
    }
    if (this.isWallpaperFinishLoadingFirstTime) {
      log.showError('first wallpaper finish loading event is processed');
      return;
    }
    log.showInfo(`wallpaperEventCallback event: ${eventData.event}`);
    if (eventData.event === THEME_FINISH_LOADING_EVENT) {
      // 壁纸第一次加载成功后，解除竖屏锁定
      this.isWallpaperFinishLoadingFirstTime = true;
    }
  };

  private wallpaperZIndexChanged(): void {
    log.showInfo(`wallpaperZIndexChanged:${this.wallpaperZIndex}`);
    if (this.isMainScreen) {
      this.viewController?.setZIndex(this.wallpaperZIndex);
    }
  }

  onClickLogout(): void {
    PowerStatusChangeAnimationController.getInstance().changePowerStatus(PowerStatus.LOGOUT);
    this.clickLogout = false;
  }

  onPowerStatusChange(): void {
    if (this.powerStatus === PowerStatus.RUNNING) {
      this.wallpaperOpacity = PowerStatusChangeAnimationController.DEFAULT_OPACITY_RATIO;
      this.scaleValue = PowerStatusChangeAnimationController.DEFAULT_SCALE_RATIO;
      return;
    }
    if (this.powerStatus === PowerStatus.LOGOUT || this.powerStatus === PowerStatus.CHANGE_MODE) {
      return;
    }
    PowerStatusChangeAnimationController.closeDeskTopWallpaper(() => {
      this.closeDeskTopWallpaperCallback();
    });
  }

  onLock() {
    // Do not handle when oobe is enabled
    if (sSCBOobeManager.isOobeActivated()) {
      return;
    }

    if (this.isLock && this.isMainScreen) {
      log.showInfo(`onLock - isLock: ${this.isLock}, isMainScreen: ${this.isMainScreen}`);
      this.viewController?.setZIndex(SCBDefaultZIndex.SCREEN_LOCK_WALL_PAPER);
      AppStorage.setOrCreate('wallpaperZIndex', SCBDefaultZIndex.SCREEN_LOCK_WALL_PAPER);
      this.lockDeskTopWallpaperCallback();
    }
  }

  private updateViewData(): void {
    this.isMainScreen = this.screenProp.screenId === SCBSceneSessionManager.getInstance().mainScreenId;
    this.viewType = this.isMainScreen ? ViewType.WALLPAPER : ViewType.WALLPAPER_EXT;
    log.showInfo(`updateViewData screenId: ${this.screenProp.screenId} width:${this.screenProp.width} ` +
      `height:${this.screenProp.height} isMainScreen: ${this.isMainScreen}, viewType: ${this.viewType}`);
  }

  private updateViewSize(): void {
    this.updateViewData();
    let viewWidth: number = this.screenProp.width;
    let viewHeight: number = this.screenProp.height;
    let offSetX: number = 0;
    let offSetY: number = 0;
    if (viewWidth <= 0 || viewHeight <= 0) {
      this.viewDiagonalLength = DEFAULT_DIAGONAL_LENGTH;
      viewWidth = DEFAULT_PAPER_HEIGHT * DEFAULT_ASPECT_RATIO;
      viewHeight = DEFAULT_PAPER_HEIGHT;
    } else {
      this.viewDiagonalLength = Math.ceil(Math.sqrt(viewWidth * viewWidth + viewHeight * viewHeight));
    }
    // 主屏放大到控件宽高都大于等于屏幕宽高，控件默认宽高比1.5
    if (this.isMainScreen) {
      let aspectRatio: number = viewWidth / viewHeight;
      if (aspectRatio < DEFAULT_ASPECT_RATIO) {
        offSetX = Math.round((viewWidth - viewHeight * DEFAULT_ASPECT_RATIO) / DIVIDE_NUM);
        offSetY = 0;
        viewWidth = viewHeight * DEFAULT_ASPECT_RATIO;
      } else {
        offSetX = 0;
        offSetY = Math.round((viewHeight - viewWidth / DEFAULT_ASPECT_RATIO) / DIVIDE_NUM);
        viewHeight = viewWidth / DEFAULT_ASPECT_RATIO;
      }
    }
    //适配hopper,hopper设备旋转不露黑角，所以需要壁纸控件比屏幕尺寸大
    viewWidth = viewWidth;
    viewHeight = viewHeight;
    offSetX = offSetX;
    offSetY = offSetY;
    this.viewController?.updateRectInPx({
      left:  offSetX,
      top:  offSetY,
      width: viewWidth,
      height: viewHeight
    })
    log.showInfo(`updateViewSize screenId: ${this.screenProp.screenId} ` +
      `viewWidth: ${viewWidth}, viewHeight: ${viewHeight} scaleValue:${this.scaleValue}`);
  }

  private screenPropertyChangeCallback: Function =
    (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (this.screenProp.screenId !== screenProperty.screenId) {
      log.showInfo(`screenId mismatch detected, updateRect operation skipped. ` +
          `currentScreenId: ${this.screenProp.screenId}, updateScreenId: ${screenProperty.screenId}`)
      return;
    }
    this.screenProp = screenProperty;
    log.showInfo(`screenPropertyChangeCallback viewWidth: ${screenProperty.width}, ` +
      `wallpaperHeight: ${screenProperty.height}`);
    this.updateDisplaySourceMode();
    this.updateViewSize();
  };

  private initWallpaperView(): void {
    this.isMainScreen = this.screenProp.screenId === SCBSceneSessionManager.getInstance().mainScreenId;
    this.viewType = this.isMainScreen ? ViewType.WALLPAPER : ViewType.WALLPAPER_EXT;
    this.displaySourceMode = this.screenProp.screenId === this.screenProp.rsId ?
      display.DisplaySourceMode.MAIN : display.DisplaySourceMode.EXTEND;
    this.viewController = new BaseViewController(this.viewType, this.screenProp.screenId);
    this.viewController.updateId(this.persistentId);
    log.showInfo(`aboutToAppear ${this.screenProp.screenId} isMainScreen ${this.isMainScreen}` +
      `viewType is ${this.viewType}`);
    this.updateViewSize();
  }

  private registerWallpaperCallbacks(): void {
    viewMgrPolicy.registerViewController(this.viewType, this.viewController);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback, this.screenProp.screenId);
    if (this.isMainScreen) {
      LockScreenAnimationController.getInstance().registerCallback(LockScreenAnimationController.WALLPAPER_CALLBACK,
        () => {
          this.scaleValue = LockScreenAnimationController.DESKTOP_WALLPAPER_SCALE_RATIO;
        });
    }
  }

  private unregisterWallpaperCallbacks(): void {
    viewMgrPolicy.unregisterViewController(this.viewType);
    SCBScreenSessionManager.getInstance()
      .unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCallback, this.screenProp.screenId);
    if (this.isMainScreen) {
      LockScreenAnimationController.getInstance().unregisterCallback(LockScreenAnimationController.WALLPAPER_CALLBACK);
    }
  }

  private closeDeskTopWallpaperCallback(): void {
    this.wallpaperOpacity = PowerStatusChangeAnimationController.OPACITY_RATIO;
    this.scaleValue = PowerStatusChangeAnimationController.DEFAULT_SCALE_RATIO;
  }

  private lockDeskTopWallpaperCallback(): void {
    if (!LockScreenAnimationController.getInstance().isPlayDefaultUnlockAnimation()) {
      return;
    }
    this.scaleValue = LockScreenAnimationController.SCREEN_LOCK_WALLPAPER_SCALE_RATIO;
  }

  private updateScreenPowerAnimation(): void {
    log.showInfo(`updateScreenPowerAnimation event: ${this.powerEvent.eventType}` +
      `, status: ${this.powerEvent.eventStatus}, reason: ${this.powerEvent.changeReason}`);
    if (ScreenLockService.isOobeEnableNoPwd()) {
      log.showError('oobe is enabled without pwd');
      return;
    }
    if (this.powerEvent.eventType == SCBScreenPowerEventType.DISPLAY_ON &&
      this.powerEvent.eventStatus == SCBScreenPowerEventStatus.END) {
    }
  }

  aboutToAppear() {
    this.initWallpaperView();
    this.registerWallpaperCallbacks();
    // 为主屏且非OOBE场景，壁纸改为锁屏时scale
    if (this.isMainScreen && !sSCBOobeManager.isOobeActivated()) {
      this.scaleValue = LockScreenAnimationController.SCREEN_LOCK_WALLPAPER_SCALE_RATIO;
    }
    CloneWallpaperMgr.getInstance(this.screenProp.screenId).initSrcWindow(this.persistentId);
    SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithId(this.persistentId, this.screenProp.screenId)?.setSystemSceneOcclusionAlpha(1);
    this.viewController?.show();
  }

  aboutToDisappear(): void {
    Log.showInfo(TAG,
      `aboutToDisappear ${this.screenProp.screenId} isMainScreen ${this.isMainScreen} viewType is ${this.viewType}`);
    this.unregisterWallpaperCallbacks();
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Column() {
        DesktopWallpaper({ screenProp: this.screenProp, persistentId: this.persistentId })
      }
      .width('100%')
      .height('100%')
      .scale({
        x: this.engineThemeStatic ? this.scaleValue : StyleConstants.DEFAULT_VIDEO_WALLPAPER_SCALE,
        y: this.engineThemeStatic ? this.scaleValue : StyleConstants.DEFAULT_VIDEO_WALLPAPER_SCALE
      })
      .opacity(this.wallpaperOpacity)

      if (this.watermarkImage) {
        Column() {
          Image(this.watermarkImage)
            .draggable(false)
            .width(px2vp(this.screenProp.width))
            .height(px2vp(this.screenProp.height))
            .objectFit(ImageFit.Fill)
        }
      }
    }
  }
}
