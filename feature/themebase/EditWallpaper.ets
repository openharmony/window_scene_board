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

import { Adapter } from '@hw-hmos/screenlockedit/Index';
import { AnyClock } from '@hw-hmos/screenlockedit/src/main/ets/edit/editsheet/models/AnyClock';
import { LockscreenFormConfig } from '@hw-hmos/screenlockedit/src/main/ets/TsIndex';
import { curves } from '@kit.ArkUI';
import { emitter } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import Curves from '@ohos.curves';
import { EventId } from 'common/src/main/ets/model/constant/EventId';
import { Constants } from '../utils/Contants';
import { DeviceHelper } from '../utils/DeviceHelper';
import { displayHelper } from 'common/src/main/ets/model/utils/DisplayHelper';
import { effectKit } from '@kit.ArkGraphics2D';
import { Log } from 'common/src/main/ets/utils/Log';
import PixelMapUtil from '../utils/PixelMapUtil';
import { ResourceManager } from 'common/src/main/ets/model/utils/ResourceManager';
import ShareTransitionUtil from '../utils/ShareTransitionUtil';
import { ScreenLockVisualUtil } from '../utils/ScreenLockVisualUtil';
import { WallpaperUtil } from '../utils/WallpaperUtil';
import { WallpaperQualifier } from '../utils/WallpaperWriter';
import { DesktopPreviewColorHelper } from './desktopreview/DesktopPreviewHelper';
import { AnyRect } from 'common/src/main/ets/model/utils/AnyRect';
import { WallpaperProp } from './model/WallpaperProp';
import QualifierManager from './QualifierManager';
import { GlbSwitch } from './editor/GlbSwitch';
import { EditWallpaperGestureModifier } from './EditWallpaperGestureModifier';

const TAG: string = 'EditWallpaper';
const RES_MSG: ResourceManager = ResourceManager.getInstance();
const IMAGE_MAX_SCALE = 8.0;
const IMAGE_MIN_SCALE = 0.7;
const ANIMATE_BLUR: number = 50;
const SCALE_DOWN_RATIO: number = 0.7;
const SCALE_UP_RATIO: number = 0.4;
const WIDTH_INDEX: number = 0;
const HEIGHT_INDEX: number = 1;
const ANIMATE_CURVE: ICurve = Curves.interpolatingSpring(0, 0, 228, 30);
const Z_INDEX_COVER: number = 1;
const Z_INDEX_WALLPAPER: number = 0;
const COVER_DURATION: number = 3000;
const COVER_ANIM_DURATION: number = 200;
const COVER_OPACITY: number = 0.8;

interface ImageEventInterface {
  width: number;
  height: number;
  componentWidth: number;
  componentHeight: number;
  loadingStatus: number;
  contentWidth: number;
  contentHeight: number;
  contentOffsetX: number;
  contentOffsetY: number;
}

@Component
export default struct EditWallpaper {
  clockWidgetAdapter?: Adapter;
  private qualifierManager: QualifierManager = QualifierManager.getInstance();
  clockWidgetEditDefault: boolean = false;
  @Consume @Watch('handleWallpaperEdit') isEditWallpaper: boolean;
  @State wallpaperScale: number = Constants.LOCK_SCALE;
  @Consume @Watch('autoScrollToTargetRect') isExpandHasFinish: boolean;
  @Link isDesktopReady: boolean;
  @Link isZoomed: boolean;
  @Link @Watch('desktopChange') isShowDesktop: boolean;
  @Link isClockEditable: boolean;
  @Link imagePixelMap: PixelMap;
  @ObjectLink @Watch('autoScrollToTargetRect') targetRect: AnyRect;
  @ObjectLink @Watch('autoScrollToTargetRect') unfoldTargetRect: AnyRect;
  @ObjectLink @Watch('autoScrollToTargetRect') landTargetRect: AnyRect;
  @Link isImageLoaded: boolean;
  @Link isUnfoldImageLoaded: boolean;
  @Link isLandImageLoaded: boolean;
  @State videoState: string = '';
  @State videoOpacity: number = 1;
  @State videoBlur: number = 0;
  @State imageOpacity: number = 1;
  @State imageBlur: number = 0;
  @State isVideoAnimateFinish: boolean = true;
  @State bgColor: Color = Color.Transparent;
  @State baseWallpaperProp: WallpaperProp = this.qualifierManager.baseWallpaperProp;
  @State unfoldWallpaperProp: WallpaperProp = this.qualifierManager.unfoldedWallpaperProp;
  @State landWallpaperProp: WallpaperProp = this.qualifierManager.landWallpaperProp;
  @State imageWidth: number = 0.0;
  @State imageHeight: number = 0.0;
  @State private wallpaperVisibility: Visibility = Visibility.Hidden;
  @Consume isPad: boolean; // 是否平板
  @Consume isLand: boolean; // 是否横屏
  @Prop isUnlockVisualEffectEnabled: boolean = false;
  @Prop isDesktopVisualEffectEnabled: boolean = false;
  @Prop blurRadius: number;
  @Prop isShowEffect: boolean = false;
  @Prop isUnfoldShowEffect: boolean = false;
  @Consume clockObject: AnyClock;
  @Consume unfoldClockObject: AnyClock;
  @Consume landClockObject: AnyClock;
  @Consume formConfig: LockscreenFormConfig[];
  @Consume isResPrepared: boolean; // 图片是否加载完成
  @Consume @Watch('handleQualifierChange') currentQualifier: WallpaperQualifier; // 当前物理状态对应的限定符
  @Consume @Watch('handleQualifierChange') tabQualifier: WallpaperQualifier;
  @State currentWallpaperProp: WallpaperProp = this.qualifierManager.getWallpaperProp(this.tabQualifier);
  @State isWallpaperClipped: boolean = true;
  @Link physicalScale: number;
  @State coverOpacity: number = COVER_OPACITY;
  @Prop isSlowMomentSuccess: boolean = false;
  @Consume isChangeWallpaper: boolean;
  @Link rgbaPixelMap: image.PixelMap;
  @State enableGestures: boolean = true; // 由锁屏编辑进入，暂不支持壁纸编辑，屏蔽拖动及捏合手势
  isScreenLockSCBSource: boolean = false; // 是否为锁屏编辑
  wallpaperOpacityAniEnable: boolean = false; // 是否使能透明度动画：主要用于大桌面锁屏拉起锁屏编辑时，壁纸需要做透明度动画，防止跳变
  @State wallpaperImageOpacity: number = 0;
  @Watch('wallpaperScaleEnableChange') @Prop wallpaperScaleEnable: boolean = true; // 是否使能壁纸缩放
  private editWallpaperGestureModifier: EditWallpaperGestureModifier = new EditWallpaperGestureModifier();
  private coverTimerId: number = 0;
  private originImageCompleteCallback?: () => void;
  isFromSheetWallpaperPicker: boolean = false;

  aboutToAppear(): void {
    Log.info(TAG, 'aboutToAppear');
    // instrument ignore else
    if (this.isShowEffect) {
      this.wallpaperVisibility = Visibility.Visible;
    }
    if (this.isFromSheetWallpaperPicker) {
      if (ShareTransitionUtil.animationFinished) {
        this.wallpaperVisibility = Visibility.Visible;
      } else {
        emitter.on(EventId.WALLPAPER_PICKER_SHARE_TRANSITION_FINISH, () => {
          this.wallpaperVisibility = Visibility.Visible;
          this.bgColor = Color.Black;
        });
      }
    } else {
      if (DeviceHelper.isTripleFold() && GlbSwitch.turnOn) {
        this.wallpaperVisibility = Visibility.Visible;
      }
    }

    if (!this.wallpaperScaleEnable) {
      this.wallpaperScale = 1.0;
    }
  }

  aboutToDisappear(): void {
    displayHelper.deleteDisplayChangeCB(TAG);
    clearTimeout(this.coverTimerId);
    if (this.isFromSheetWallpaperPicker) {
      emitter.off(EventId.WALLPAPER_PICKER_SHARE_TRANSITION_FINISH);
    }
  }

  private desktopChange(): void {
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 128, 23),
    }, () => {
      if (this.isShowDesktop) {
        this.wallpaperScale = 1.0;
      } else {
        this.wallpaperScale = Constants.LOCK_SCALE;
      }
    });
  }

  private autoScrollToTargetRect(property: string = 'targetRect'): void {
    Log.info(TAG, `autoScrollToTargetRect ${property}`);
    let qualifier: WallpaperQualifier = this.tabQualifier;
    if (property === 'targetRect') {
      qualifier = WallpaperQualifier.BASE;
    }
    if (property === 'unfoldTargetRect') {
      qualifier = WallpaperQualifier.UNFOLDED;
    }
    if (property === 'landTargetRect') {
      qualifier = WallpaperQualifier.LAND;
    }
    this.updateCurrentProp(qualifier);
  }

  // 根据rect更新prop
  private updateCurrentProp(qualifier: WallpaperQualifier): void {
    Log.info(TAG, `updateCurrentProp qualifier: ${qualifier}`);
    let rect: AnyRect = this.qualifierManager.getAnyRect(qualifier);
    if (rect.width === 0) {
      Log.info(TAG, 'Pandora or AesHandler scene, use old rect');
      rect = this.getAnyRect(qualifier);
    }
    Log.info(TAG, `updateCurrentProp rect: ${rect.toString()}`);
    let displayWidth: number = this.qualifierManager.getDeviceSize(qualifier)[WIDTH_INDEX];
    let displayHeight: number = this.qualifierManager.getDeviceSize(qualifier)[HEIGHT_INDEX];
    let currentProp: WallpaperProp = this.qualifierManager.getWallpaperProp(qualifier);
    if (rect.width > 0 && rect.height > 0 && currentProp.minRatio > 0) {
      const wallpaperPropNew: WallpaperProp = WallpaperUtil.getDisplayPropForAES(rect, currentProp,
        displayHeight, displayWidth);
      currentProp.contentOffsetX = wallpaperPropNew.contentOffsetX;
      currentProp.contentOffsetY = wallpaperPropNew.contentOffsetY;
      currentProp.contentScale = wallpaperPropNew.contentScale;
    }
  }

  private resetCanvas(qualifier: WallpaperQualifier): void {
    // instrument ignore if
    if (this.checkSizeInvalid(qualifier)) {
      Log.warn(TAG, ` ${qualifier} size Invalid`);
      return;
    }
    this.calcInitialOffset(qualifier);
  }

  // instrument ignore next
  private getAnyRect(qualifier: WallpaperQualifier): AnyRect {
    if (qualifier === WallpaperQualifier.UNFOLDED) {
      return this.unfoldTargetRect;
    }
    if (qualifier === WallpaperQualifier.LAND || qualifier === WallpaperQualifier.UNFOLDED_LAND) {
      return this.landTargetRect;
    }
    return this.targetRect;
  }

  private checkSizeInvalid(qualifier: WallpaperQualifier): boolean {
    // instrument ignore if
  return this.qualifierManager.getDeviceSize(qualifier)[WIDTH_INDEX] < 1 ||
      this.qualifierManager.getDeviceSize(qualifier)[HEIGHT_INDEX] < 1 ||
      this.imageWidth < 1 || this.imageHeight < 1;
  }

  private calcInitialOffset(qualifier: WallpaperQualifier) {
    let wallpaperProp: WallpaperProp = this.qualifierManager.getWallpaperProp(qualifier);
    let deviceSize: number[] = this.qualifierManager.getDeviceSize(qualifier);
    const imageUnfoldCenterX = wallpaperProp.imageShowWidth / 2.0;
    const imageUnfoldCenterY = wallpaperProp.imageShowHeight / 2.0;
    wallpaperProp.contentOffsetX = -(imageUnfoldCenterX - deviceSize[WIDTH_INDEX] / 2.0);
    wallpaperProp.contentOffsetY = -(imageUnfoldCenterY - deviceSize[HEIGHT_INDEX] / 2.0);
    wallpaperProp.contentScale = 1.0;
  }

  private async doDesktopPreviewColorCalc(): Promise<void> {
    // instrument ignore else
    if (DeviceHelper.isPad() || DeviceHelper.isFoldButNotSmallFoldProduct()) {
      // 暂时屏蔽平板和大折叠
      Log.info(TAG, 'this device is not support now');
      return;
    }
    const rect: AnyRect = WallpaperUtil.getDisplayInImageArea(this.baseWallpaperProp,
      this.qualifierManager.baseDisplayHeight, this.qualifierManager.baseDisplayWidth);
    const wallpaperPixelClone: PixelMap | undefined = await PixelMapUtil.clonePixelMap(this.rgbaPixelMap);
    if (!wallpaperPixelClone) {
      Log.error(TAG, 'get pixel clone error');
      return;
    }
    if (await DesktopPreviewColorHelper.doDesktopPreviewColorCalc(rect, wallpaperPixelClone,
      this.clockObject.clockFontFamily ?? 'HARMONY_CLOCK_01',
      this.clockObject?.colorStyle)) {
      this.isDesktopReady = true;
      wallpaperPixelClone.release();
    }
  }

  private getTransitionEffect(): TransitionEffect | undefined {
    return TransitionEffect.opacity(0.99).animation({ curve: ANIMATE_CURVE });
  }

  private handleScreenLockClockVisual(): void {
    if (!this.clockWidgetAdapter || !ScreenLockVisualUtil.isScreenLockBrightOrSolidDisabled()) {
      return;
    }
    this.clockWidgetAdapter?.getVisualHelper().registerCurrentWallpaper(this.imagePixelMap,
      this.qualifierManager.getDisplayRect(this.currentQualifier));
  }

  @Styles
  imageCommonAttr() {
    .draggable(false)
    .constraintSize({
      minWidth: '100%',
      minHeight: '100%',
    })
    .size({
      width: this.currentWallpaperProp.imageShowWidth,
      height: this.currentWallpaperProp.imageShowHeight,
    })
    .position({
      x: this.currentWallpaperProp.contentOffsetX,
      y: this.currentWallpaperProp.contentOffsetY,
    })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }

  build() {
    Row() {
      Column() {
        Stack() { // 限制物理显示区域
          Column() { // 控制桌面锁屏转换
            Row() {
              this.wallpaperImage();
            }
            .size({
              width: '100%',
              height: '100%',
            })
            .scale({
              x: this.currentWallpaperProp.contentScale,
              y: this.currentWallpaperProp.contentScale,
              centerX: this.currentWallpaperProp.pinchCenterX,
              centerY: this.currentWallpaperProp.pinchCenterY,
            });
          }
          .size({
            width: '100%',
            height: '100%',
          })
          .id('WallpaperImage')
          .scale({ x: this.wallpaperScale * this.physicalScale, y: this.wallpaperScale * this.physicalScale });
        }
        .zIndex(Z_INDEX_WALLPAPER)
        .visibility(this.wallpaperVisibility)
        .width('100%')
        .height('100%')
        .backgroundColor(this.bgColor)
        .clip(this.isWallpaperClipped)
        .gestureModifier(this.editWallpaperGestureModifier)
      }
      .height('100%');
    }
    .width('100%')
  }

  @Builder
  wallpaperImage() {
    Image(GlbSwitch.turnOn ?
      this.currentWallpaperProp.pixelMap : this.getPixelMap(this.imagePixelMap))
      .autoResize(false)
      .fitOriginalSize(true)
      .copyOption(CopyOptions.None)
      .backgroundColor(this.bgColor)
      .imageCommonAttr()
      .blur(this.isWallpaperBlur() ? this.blurRadius : 0, undefined, { disableSystemAdaptation: true })
      .transition(this.getTransitionEffect())
      .onComplete((event?) => {
        this.handleImageComplete(event);
      })
  }

  private getPixelMap(pixelMap: PixelMap | undefined): PixelMap | undefined {
    // 8g lite产品采用静态模糊
    if (!pixelMap) {
      Log.error(TAG, 'pixelMap is invalid in getPixelMap');
      return undefined;
    }
    if (DeviceHelper.isLiteProduct() && this.isShowDesktop && this.isDesktopVisualEffectEnabled) {
      try {
        let filter: effectKit.Filter = effectKit.createEffect(pixelMap);
        if (!filter) {
          Log.error(TAG, 'filter is invalid in createEffect');
          return pixelMap;
        }
        filter.blur(this.blurRadius);
        let pixel: PixelMap = filter.getPixelMap();
        if (!pixel) {
          Log.error(TAG, 'pixel is invalid in getPixelMap');
          return pixelMap;
        }
        return pixel;
      } catch (err) {
        Log.error(TAG, `getPixelMap error occurred. Code: ${err?.code}, message: ${err?.message}`);
        return pixelMap;
      }
    }
    return pixelMap;
  }

  private handleImageComplete(event?: ImageEventInterface): void {
    if (event && event.loadingStatus === 1 && this.originImageCompleteCallback) {
      this.originImageCompleteCallback();
      if (this.isFromSheetWallpaperPicker) {
        this.bgColor = Color.Black;
      }
    }
    if (event && !this.isImageLoaded) {
      Log.info(TAG, `wallpaperImage onComplete`);
      this.isImageLoaded = true;
      this.imageWidth = px2vp(event!.width);
      this.imageHeight = px2vp(event!.height);
      this.currentWallpaperProp.pixelMap = this.imagePixelMap;
      this.currentWallpaperProp.imageWidth = this.imageWidth;
      this.currentWallpaperProp.imageHeight = this.imageHeight;
      let deviceSize: number[] = this.qualifierManager.getDeviceSize(this.currentQualifier);
      this.currentWallpaperProp.imageRatio =
          this.getPreviewImageRatioByQualifier(this.currentQualifier, deviceSize[WIDTH_INDEX]);
      this.currentWallpaperProp.minRatio =
        Math.min(this.imageWidth / deviceSize[WIDTH_INDEX],
          this.imageHeight / deviceSize[HEIGHT_INDEX]);
      this.currentWallpaperProp.imageShowWidth = this.imageWidth / this.currentWallpaperProp.minRatio;
      this.currentWallpaperProp.imageShowHeight = this.imageHeight / this.currentWallpaperProp.minRatio;
      this.qualifierManager.allQualifiers.forEach((qualifier) => {
        this.syncCurrentProp(qualifier); // 图片属性同步到其他限定符
        this.resetCanvas(qualifier); // 根据图片属性调整为默认居中显示
        this.updateWallpaperProp(qualifier);
      });
      this.updateCurrentProp(this.currentQualifier); // 历史壁纸、推荐照片拉起时附带位置信息，在此生效
      if (!this.isFromSheetWallpaperPicker) {
        this.wallpaperVisibility = Visibility.Visible;
      }
      this.doDesktopPreviewColorCalc();
      this.handleScreenLockClockVisual();
    }
  }

  private updateQualifiers(qualifier: WallpaperQualifier): WallpaperQualifier[] {
    let qualifiers: WallpaperQualifier[] = [];
    if (this.isChangeWallpaper && DeviceHelper.isTripleFold()) {
      if (qualifier === WallpaperQualifier.UNFOLDED || qualifier === WallpaperQualifier.UNFOLDED_LAND) {
        qualifiers.push(WallpaperQualifier.UNFOLDED, WallpaperQualifier.UNFOLDED_LAND);
      } else if (qualifier === WallpaperQualifier.UNFOLDED2 ||
        qualifier === WallpaperQualifier.UNFOLDED2_LAND) {
        qualifiers.push(WallpaperQualifier.UNFOLDED2, WallpaperQualifier.UNFOLDED2_LAND);
      } else {
        qualifiers.push(WallpaperQualifier.BASE);
      }
    } else {
      qualifiers = this.qualifierManager.allQualifiers;
    }
    return qualifiers;
  }

  private handleQualifierChange(property: string): void {
    Log.info(TAG, `handleQualifierChange ${property}, cur=${this.currentQualifier}, tab=${this.tabQualifier}`);
    if (DeviceHelper.isTripleFold() && GlbSwitch.turnOn) {
      this.wallpaperVisibility = Visibility.Visible;
    }
    this.currentWallpaperProp = this.qualifierManager.getWallpaperProp(this.tabQualifier);
    Log.info(TAG, `handleQualifierChange currentWallpaperProp=${this.currentWallpaperProp.toString()}`);
    this.isWallpaperClipped = true;
    this.isZoomed = true;
  }

  // instrument ignore next
  private syncCurrentProp(qualifier: WallpaperQualifier): void {
    if (qualifier === this.currentQualifier) {
      return;
    }
    let prop: WallpaperProp = this.qualifierManager.getWallpaperProp(qualifier);
    Log.info(TAG, `isScreenLockSCBSource = ${this.isScreenLockSCBSource}, isTripleFold = ${DeviceHelper.isTripleFold()}, turnOn = ${GlbSwitch.turnOn}, pixelMap = ${prop.pixelMap}`)
    // 三折的锁屏编辑异壁纸场景下，若prop有数据，则不能将当前的pixelMap数据覆盖其他状态数据
    if (this.isScreenLockSCBSource && DeviceHelper.isTripleFold() && GlbSwitch.turnOn && prop.pixelMap) {
      let imageInfo: image.ImageInfo | undefined = prop.pixelMap?.getImageInfoSync();
      prop.imageWidth = px2vp(imageInfo!.size.width);
      prop.imageHeight = px2vp(imageInfo!.size.height);
    } else {
      prop.pixelMap = this.currentWallpaperProp.pixelMap;
      prop.imageWidth = this.currentWallpaperProp.imageWidth;
      prop.imageHeight = this.currentWallpaperProp.imageHeight;
    }
    let deviceSize: number[] = this.qualifierManager.getDeviceSize(qualifier);
    prop.imageRatio = this.getPreviewImageRatioByQualifier(qualifier, deviceSize[WIDTH_INDEX]);
    prop.minRatio = Math.min(prop.imageWidth / deviceSize[WIDTH_INDEX],
      prop.imageHeight / deviceSize[HEIGHT_INDEX]);
    prop.imageShowWidth = prop.imageWidth / prop.minRatio;
    prop.imageShowHeight = prop.imageHeight / prop.minRatio;
    Log.info(TAG, `syncCurrentPropToOthers ${qualifier}, prop=${prop.toString()}`);
  }


  updateWallpaperProp(qualifier: WallpaperQualifier): void {
    let rect: AnyRect = this.qualifierManager.getAnyRect(qualifier);
    let prop: WallpaperProp = this.qualifierManager.getWallpaperProp(qualifier);

    let displayWidth: number = this.qualifierManager.getDeviceSize(qualifier)[WIDTH_INDEX];
    let displayHeight: number = this.qualifierManager.getDeviceSize(qualifier)[HEIGHT_INDEX];
    if (rect.width > 0 && rect.height > 0 && prop.minRatio > 0) {
      const wallpaperPropNew: WallpaperProp = WallpaperUtil.getDisplayPropForAES(rect, prop,
        displayHeight, displayWidth);
      prop.contentOffsetX = wallpaperPropNew.contentOffsetX;
      prop.contentOffsetY = wallpaperPropNew.contentOffsetY;
      prop.contentScale = wallpaperPropNew.contentScale;
    }
  }

  // instrument ignore next
  private getPreviewImageRatioByQualifier(qualifier: WallpaperQualifier, deviceWidth: number): number {
    if (qualifier === WallpaperQualifier.UNFOLDED) {
      return RES_MSG.getNumberByResource($r('app.float.wallpapereditor_fold_preview_image_width')) / deviceWidth
    } else if (qualifier === WallpaperQualifier.UNFOLDED_LAND) {
      return RES_MSG.getNumberByResource($r('app.float.wallpapereditor_fold_land_preview_image_width')) / deviceWidth
    } else if (qualifier === WallpaperQualifier.LAND) {
      return RES_MSG.getNumberByResource($r('app.float.wallpapereditor_pad_preview_land_width')) / deviceWidth
    } else if (qualifier === WallpaperQualifier.UNFOLDED2) {
      return RES_MSG.getNumberByResource($r('app.float.wallpapereditor_preview_image_width_pad')) / deviceWidth
    } else if (qualifier === WallpaperQualifier.UNFOLDED2_LAND) {
      return RES_MSG.getNumberByResource($r('app.float.wallpapereditor_pad_preview_land_width')) / deviceWidth
    } else { // 不同设备的BASE态要取不同资源
      if (DeviceHelper.isPad()) {
        return RES_MSG.getNumberByResource($r('app.float.wallpapereditor_preview_image_width_pad')) / deviceWidth;
      }
      return RES_MSG.getNumberByResource($r('app.float.wallpapereditor_preview_image_width')) / deviceWidth;
    }
  }

  private getSuperFoldPreviewImageRatio(qualifier: WallpaperQualifier, deviceSize: number[]): number {
    const deviceWidth: number = deviceSize[WIDTH_INDEX];
    const deviceHeight: number = deviceSize[HEIGHT_INDEX];
    if (qualifier === WallpaperQualifier.UNFOLDED) {
      return deviceHeight === 0 ? 1 : RES_MSG.getNumberByResource($r('app.float.wallpapereditor_fold_preview_base_height')) / deviceHeight
    } else if (qualifier === WallpaperQualifier.UNFOLDED_LAND) {
      return deviceWidth === 0 ? 1 : RES_MSG.getNumberByResource($r('app.float.wallpapereditor_fold_land_preview_image_width')) / deviceWidth
    } else { // 不同设备的BASE态要取不同资源
      return deviceHeight === 0 ? 1 : RES_MSG.getNumberByResource($r('app.float.wallpapereditor_fold_preview_base_height')) / deviceHeight;
    }
  }

  // instrument ignore next
  private isWallpaperBlur(): boolean {
    // 8g lite产品采用静态模糊
    if (DeviceHelper.isLiteProduct()) {
      return false;
    }
    return this.isShowDesktop ? this.isDesktopVisualEffectEnabled : this.isUnlockVisualEffectEnabled;
  }

  private handleWallpaperEdit(property: string): void {
    clearTimeout(this.coverTimerId);
    if (this.isEditWallpaper) { // 拖动壁纸进行编辑，启动蒙层出现动画
      this.isWallpaperClipped = false;
      animateTo({
        curve: Curves.cubicBezierCurve(0.4, 0, 0.4, 1), // 平滑曲线
        duration: COVER_ANIM_DURATION,
      }, () => {
        this.coverOpacity = COVER_OPACITY;
      })
    } else { // 壁纸拖动结束，3s后蒙层消失，消失时启动消失动画
      this.coverTimerId = setTimeout(() => {
        animateTo({
          curve: Curves.cubicBezierCurve(0.4, 0, 0.4, 1), // 平滑曲线
          duration: COVER_ANIM_DURATION,
          onFinish: () => {
            this.isWallpaperClipped = true;
          }
        }, () => {
          this.coverOpacity = 1;
        })
      }, COVER_DURATION)
    }
  }

  private wallpaperScaleEnableChange(): void {
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 128, 23),
    }, () => {
      Log.info(TAG, `wallpaperScaleEnableChange wallpaperScaleEnable = ${this.wallpaperScaleEnable}`);
      this.wallpaperScale = this.wallpaperScaleEnable ? Constants.LOCK_SCALE : 1.0;
    });
  }
}