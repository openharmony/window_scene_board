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

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { ViewCallback, ViewController, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import {
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBPropertyChangeReason,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import image from '@ohos.multimedia.image';
import { BusinessError } from '@kit.BasicServicesKit';
import { SCBDefaultZIndex } from '../scenemanager/SCBScreen';
import { FourFingerSwipeController } from './FourFingerSwipeController';
import { DesktopSwitchController } from './DesktopSwitchController';
import { PromptAction } from '@kit.ArkUI';

const TAG = '[DesktopWorld]SCBExtendMultiDesktopSwitcher';
const BACKGROUND_BLUR: number = 99;
const BACKGROUND_MARGIN: number = 10;
const BACKGROUND_BRIGHTNESS: number = 0.6;

const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct SCBExtendMultiDesktopSwitcher {
  public persistentId: number = 0;
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  @State screenWidth: number = 0;
  @State screenHeight: number = 0;
  @Link screenProp: SCBScreenProperty;
  @State viewController: BaseViewController = new BaseViewController(ViewType.DESKTOP_SWITCHER_EXT_SCREEN,
    this.screenProp?.screenId);
  @State isSwitching: boolean = false;
  @State showPrefabrication: boolean = true;
  @State memoryReleaseShow: boolean = false;
  @State motionPrefabrication: image.PixelMap | null = null;
  @State vmSnapshot: image.PixelMap | null = null;
  @State vmSnapshotX: number = this.screenWidth;
  @State vmSnapshotScale: number = 0.8;
  @State vmSnapshotRotate: number = -15;
  @State vmSnapshotOpacity: number = 1;
  @State vmSnapshotRadius: number = 15;
  @State vmSnapshotBlurScale: number = 0;
  @State showBackground: boolean = true;

  private viewCallback: ViewCallback = {
    onShow: () => {
      log.showInfo('SCBExtendMultiDesktopSwitcher show');
      if (this.showPrefabrication) {
        log.showInfo('need to show Prefabrication, load and set Image');
        this.motionPrefabrication = DesktopSwitchController.getInstance().getMotionPrefabrication();
      }
      this.setWallpaperIndexToHideDesktop();
    },
    onHide: () => {
      log.showInfo('SCBExtendMultiDesktopSwitcher hide');
      this.motionPrefabrication = null;
      this.setWallpaperIndexToShowDesktop();
    }
  };

  aboutToAppear() {
    log.showInfo(`aboutToAppear start, persistentId: ` + this.persistentId + ', screenProp: ' + this.screenProp);
    viewMgrPolicy.registerViewController(ViewType.DESKTOP_SWITCHER_EXT_SCREEN, this.viewController);
    FourFingerSwipeController.getInstance().registerSwipeCallback(this);
    this.viewController.updateId(this.persistentId);
    SCBScreenSessionManager.getInstance()
      .registerScreenPropertyChangeCallbacks(this.screenStatusChange, this.screenProp?.screenId);
    this.viewController.registerCallback(this.viewCallback)
    this.screenWidth = px2vp(this.screenProp?.width);
    this.screenHeight = px2vp(this.screenProp?.height);
    this.registerTransparentDetection();
  }

  private registerTransparentDetection(): void {
    const session = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(this.persistentId);
    session?.registerContextTransparentCallback(() => {
      log.showError('window is transparency!!');
    })
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear start, persistentId: ` + this.persistentId + ', screenProp: ' + this.screenProp);
    FourFingerSwipeController.getInstance().recoverMotionOnMainScreen();
    FourFingerSwipeController.getInstance().unRegisterSwipeCallback(this);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenStatusChange);
    viewMgrPolicy.unregisterViewController(ViewType.DESKTOP_SWITCHER_EXT_SCREEN);
    this.viewController.unRegisterCallback(this.viewCallback)
  }

  private screenStatusChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`receive screenStatusChange, new screen width: ${screenProperty?.width}` +
      `, screen height: ${screenProperty?.height}, screenId: ${screenProperty?.screenId}` +
      `, rsId: ${screenProperty?.rsId}, reason: ${reason}`);
    this.screenProp = screenProperty;
    this.screenWidth = screenProperty ? px2vp(screenProperty?.width) : this.screenWidth;
    this.screenHeight = screenProperty ? px2vp(screenProperty?.height) : this.screenHeight;
    this.viewController?.updateRect({
      left: 0,
      top: 0,
      width: this.screenWidth,
      height: this.screenHeight
    })
  };

  public sendToast(): void {
    log.showInfo('send toast');
    try {
      this.promptAction.showToast({
        message: '为了更流畅的使用体验，请打开后盖后使用虚拟机',
        duration: 2000,
      });
    } catch (error) {
      log.showError(`showToast failed, code: ${error?.code}, msg: ${error?.message}`);
    }
  }

  public setMotionRect(width: number, height: number): void {
    log.showInfo(`setMotionRect, width: ${width}, height: ${height}`);
    this.screenWidth = px2vp(width);
    this.screenHeight = px2vp(height);
    this.viewController?.updateRect({
      left: 0,
      top: 0,
      width: px2vp(width),
      height: px2vp(height)
    })
  }

  private setWallpaperIndexToHideDesktop(): void {
    let controller: ViewController | undefined  = viewMgrPolicy.getViewController(ViewType.WALLPAPER_EXT);
    controller?.setZIndex(SCBDefaultZIndex.DESKTOP_SWITCHER - 1);
    log.showInfo('setWallpaperIndexToHideDesktop');
  }

  private setWallpaperIndexToShowDesktop(): void {
    let controller: ViewController | undefined  = viewMgrPolicy.getViewController(ViewType.WALLPAPER_EXT);
    if (FourFingerSwipeController.getInstance().isLock) {
      log.showInfo(`isLock, WallpaperIndex return to ${SCBDefaultZIndex.SCREEN_LOCK_WALL_PAPER}`);
      controller?.setZIndex(SCBDefaultZIndex.SCREEN_LOCK_WALL_PAPER);
    } else {
      log.showInfo(`WallpaperIndex return to ${SCBDefaultZIndex.WALLPAPER}`);
      controller?.setZIndex(SCBDefaultZIndex.WALLPAPER);
    }
  }

  public getScreenWidth(screenWidth: number): void {
    this.screenWidth = screenWidth;
  }

  public updateVmSnapshot(vmSnapshot: image.PixelMap): void {
    if (this.vmSnapshot) {
      log.showInfo(`release last vm snapshot`);
      this.vmSnapshot.release((err: BusinessError) => {
        if (err) {
          log.showError(`releasePixelMap error: ${err.message}`);
        } else {
          log.showInfo('Succeeded in releasing old vmSnapshot, update to new vmSnapshot');
        }
        this.vmSnapshot = vmSnapshot;
      });
    } else {
      this.vmSnapshot = vmSnapshot;
    }
  }

  public releaseVmSnapshot(): void {
    log.showInfo('releaseVmSnapshot');
    this.vmSnapshot?.release((err: BusinessError) => {
      if (err) {
        log.showError(`releasePixelMap error: ${err.message}`);
      } else {
        log.showInfo('Succeeded in releasing vmSnapshot');
        this.vmSnapshot = null;
      }
    });
  }

  public getMotionScreenId(): number {
    return this.screenProp?.screenId;
  }

  public updateSwitching(isSwitching: boolean): void {
    this.isSwitching = isSwitching;
  }

  public updateShowPrefabrication(show: boolean): void {
    this.showPrefabrication = show;
  }

  public updateShowMemoryRelease(show: boolean): void {
    this.memoryReleaseShow = show;
  }

  public updateVmSnapshotX(vmSnapshotX: number): void {
    this.vmSnapshotX = vmSnapshotX;
  }

  public updateVmSnapshotScale(vmSnapshotScale: number): void {
    this.vmSnapshotScale = vmSnapshotScale;
  }

  public updateVmSnapshotRotate(vmSnapshotRotate: number): void {
    this.vmSnapshotRotate = vmSnapshotRotate;
  }

  public updateVmSnapshotOpacity(vmSnapshotOpacity: number): void {
    this.vmSnapshotOpacity = vmSnapshotOpacity;
  }

  public updateVmSnapshotRadius(vmSnapshotRadius: number): void {
    this.vmSnapshotRadius = vmSnapshotRadius;
  }

  public updateVmSnapshotBlurScale(vmSnapshotBlurScale: number): void {
    this.vmSnapshotBlurScale = vmSnapshotBlurScale;
  }

  public updateWallpaperIndexToShowDesktop(): void {
    this.setWallpaperIndexToShowDesktop();
  }

  public updateShowBackground(showBackground: boolean): void {
    this.showBackground = showBackground;
  }

  @Builder
  buildBackground() {
    Column()
      .width(this.screenWidth)
      .height(this.screenHeight)
      .blur(BACKGROUND_BLUR)
      .margin(BACKGROUND_MARGIN)
      .draggable(false)
      .brightness(BACKGROUND_BRIGHTNESS)
      .visibility(this.showBackground ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  buildMotionPrefabrication() {
    Image(this.motionPrefabrication)
      .syncLoad(true)
      .width(this.screenWidth * this.vmSnapshotScale)
      .height(this.screenHeight * this.vmSnapshotScale)
      .translate({ x: this.vmSnapshotX })
      .rotate({
        x: 0,
        y: -1,
        z: 0,
        angle: this.vmSnapshotRotate,
        centerX: '50%',
        centerY: '50%'
      })
      .borderRadius(this.vmSnapshotRadius)
      .opacity(this.vmSnapshotOpacity)
      .interpolation(ImageInterpolation.Low)
      .autoResize(false)
      .draggable(false)
  }

  @Builder
  buildMemoryRelease() {
    Column() {
      Text('正在恢复虚拟机，请稍候…')
        .fontSize(30)
        .fontColor(Color.White)

      LoadingProgress()
        .width(50)
        .height(50)
        .color(Color.White)
    }
    .width(this.screenWidth * this.vmSnapshotScale)
    .height(this.screenHeight * this.vmSnapshotScale)
    .translate({ x: this.vmSnapshotX })
    .rotate({
      x: 0,
      y: -1,
      z: 0,
      angle: this.vmSnapshotRotate,
      centerX: '50%',
      centerY: '50%'
    })
    .borderRadius(this.vmSnapshotRadius)
    .opacity(this.vmSnapshotOpacity)
    .draggable(false)
    .backgroundColor('rgba(0,0,0, 0.5)') // 半透明黑色背景
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  buildWindowsDesktop() {
    Image(this.vmSnapshot)
      .syncLoad(true)
      .width(this.screenWidth)
      .height(this.screenHeight)
      .scale({ x: this.vmSnapshotScale, y: this.vmSnapshotScale })
      .translate({ x: this.vmSnapshotX })
      .rotate({
        x: 0,
        y: -1,
        z: 0,
        angle: this.vmSnapshotRotate,
        centerX: '50%',
        centerY: '50%'
      })
      .borderRadius(this.vmSnapshotRadius)
      .opacity(this.vmSnapshotOpacity)
      .interpolation(ImageInterpolation.Low)
      .autoResize(false)
      .draggable(false)
      .blur(this.vmSnapshotBlurScale)
      .objectFit(ImageFit.Fill)
  }

  build() {
    if (this.isSwitching) {
      Stack() {
        this.buildBackground();
        this.buildWindowsDesktop();
        if (this.memoryReleaseShow) {
          this.buildMemoryRelease();
        }
        if (this.showPrefabrication) {
          this.buildMotionPrefabrication();
        }
      }
    }
  }
}