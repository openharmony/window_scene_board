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

import lazy taskpool from '@ohos.taskpool';
import lazy systemDateTime from '@ohos.systemDateTime';
import lazy fs from '@ohos.file.fs';
import lazy image from '@ohos.multimedia.image';
import lazy { RectAttr, StaticWallpaperAnimSize, StaticWallpaperManager } from './StaticWallpaperManager';
import lazy { WallpaperCropper } from './WallpaperCropper';
import lazy { StaticWallpaperRenderNode, WallpaperNodeController } from './WallpaperNodeController';
import { Constants, DeviceChangeStatus } from '../utils/Constants';
import { WallpaperConfig } from '../pages/WallpaperConfig';
import { WallpaperModifier } from './WallpaperModifier';
import { LayoutReloadListener } from '../reloadmanager/ReloadStrategy';
import { Log } from '../utils/Log';
import { DeviceUtil } from '../utils/DeviceUtil';
import { PathReloadStrategy, RootPathChangeListener } from '../utils/PathReloadStrategy';
import { pixelMapTransformation, PixelMapUtil } from '../utils/PixelMapUtil';
import { ThemeLoadPublisher } from '../datdamanager/ThemeLoadPublisher';
import { LayoutReloadStrategy } from '../reloadmanager/LayoutReloadStrategy';
import { FileUtil } from '../utils/FileUtil';

const TAG: string = 'TriFoldStaticWallpaperDataSource';

// Supported image conversion formats
const SUPPORT_FORMAT: string[] = ['jpg', 'png'];

const ALPHA_DURATION: number = 200;

const FOLD_EXPAND_ALPHA_DURATION: number = 250;

const FOLD_EXPAND_ALPHA_DELAY: number = 150;

const ALPHA_DELAY: number = 100;

const TIMEOUT_DURATION: number = 1000;

/**
 * Component definition for static wallpaper, which takes the image source as input to display given image.
 *
 * @since 2025-06-03
 */
@Component
export struct TriFoldStaticWallpaperDataSource {
  private bsodTag: string = Constants.PREFIX_BSOD + TAG;

  @Link @Watch('loadPixelMap') public imagePath: string;

  /**
   * 区域播放参数（父组件传递）
   */
  @Link @Watch('updateRectArr')
  public wallpaperConfig: WallpaperConfig | undefined;

  /**
   * 是否以新的资源读取方式加载
   */
  @Link @Watch('isChangeResoureLoad')
  public isNewResourceLoad: boolean;

  @State private imagePixelMap: image.PixelMap | null = null;

  @State private lastImage: image.PixelMap | null = null;

  @State public modifier: WallpaperModifier | null = null;

  @State private isChangingImage: boolean = false;

  @State private staticWallpaperAnimSize: StaticWallpaperAnimSize = new StaticWallpaperAnimSize();

  @State private transitOpacity: number = 1;

  private staticWallpaperManager: StaticWallpaperManager = new StaticWallpaperManager();

  @State
  public rectAttr: Nullable<RectAttr> = new RectAttr(new WallpaperConfig());

  @State private oldRectAttr: Nullable<RectAttr> = this.rectAttr;

  @Consume
  private resourceQualifier: number;

  @State private deviceChangeStatus: DeviceChangeStatus = DeviceChangeStatus.INVALID;

  private tmpPixelMap: image.PixelMap | null = null;

  private wallpaperCropper: WallpaperCropper = new WallpaperCropper();

  public sendCode: number = 0;

  private targetPath: string = '';

  // astc文件根目录
  private astcRoot: string = '';

  private targetDirectory: string = '';

  private recoverTask: number = -1;

  private isAlphaFinished: boolean = true;

  private isAlphaInterrupted: boolean = false;

  private lastResourceQualifier: number = AppStorage.get<number>('resourceQualifier') ?? 0;

  private controller: WallpaperNodeController = new WallpaperNodeController(new StaticWallpaperRenderNode());

  private lastPath: string = this.imagePath;

  private lastPixelMapPath: string = '';

  private isChangeResourceLoad: boolean = false;

  private isImageChanged: boolean = false;

  private isLoadFinished: boolean = false;

  private isLayoutReload: boolean = false;

  /**
   * loadPixelMap任务开始时更新并记录时间戳作为taskId，应用图片时对比记录的taskId和最新的taskId，一致时才更新显示的图片，
   * 以保证显示的是最新的任务加载的图片
   */
  private loadPixelMapTaskId?: number;

  private layoutReloadListener: LayoutReloadListener = {
    reloadLayout: async (screenWidth: number, screenHeight: number, resourceQualifier: number) => {
      Log.info(TAG, `layoutReloadListener, isImageChanged: ${this.isImageChanged}, isLoadFinished: ${
      this.isLoadFinished}, isLayoutReload:${this.isLayoutReload}`);
      if (!this.isImageChanged && this.lastPixelMapPath !== this.imagePath) {
        // 图片没有改变表示上一次的pixelMap应该替换成当前pixelMap.
        const wasteImage: image.PixelMap | null = this.lastImage;
        this.lastPixelMapPath = this.imagePath;
        this.lastImage = this.imagePixelMap;
        wasteImage?.release(() => {
          Log.warn(this.bsodTag, 'layoutReloadListener, lastImage release.');
        });
      }

      if (this.isLoadFinished) {
        this.rectAttr = this.staticWallpaperManager.updateRectData(this.wallpaperConfig);
        this.staticWallpaperManager.lastOrientation = DeviceUtil.getOrientation();
        Log.info(TAG, 'layoutReloadListener lastOrientation: ', this.staticWallpaperManager.lastOrientation);
        this.lastPath = this.imagePath;
      } else if (!this.isImageChanged) {
        // 图片没有改变直接，触发动画
        this.processAnimation();
      } else {
        this.isLayoutReload = true;
      }
    }
  }

  private processAnimation(): void {
    Log.info(TAG, `processAnimation, lastQual: ${this.lastResourceQualifier}, curQual: ${this.resourceQualifier}`);
    this.deviceChangeStatus = this.staticWallpaperManager.getDeviceChangeStatus(this.lastResourceQualifier,
      this.resourceQualifier);
    this.lastResourceQualifier = this.resourceQualifier;
    this.oldRectAttr = this.rectAttr;
    this.doAnimator();
    if (!this.isImageChanged || this.isLayoutReload) {
      this.rectAttr = this.staticWallpaperManager.updateRectData(this.wallpaperConfig);
      this.staticWallpaperManager.lastOrientation = DeviceUtil.getOrientation();
      Log.info(TAG, 'processAnimation lastOrientation: ', this.staticWallpaperManager.lastOrientation);
      this.lastPath = this.imagePath;
    }
  }

  private alphaAnimation: AnimateParam = {
    curve: this.deviceChangeStatus === DeviceChangeStatus.ROTATE ? Curve.FastOutSlowIn : Curve.Linear,
    duration: this.deviceChangeStatus === DeviceChangeStatus.ROTATE ? ALPHA_DURATION : FOLD_EXPAND_ALPHA_DURATION,
    delay: this.deviceChangeStatus === DeviceChangeStatus.ROTATE ? ALPHA_DELAY : FOLD_EXPAND_ALPHA_DELAY,
    onFinish: () => {
      Log.info(TAG, `alphaAnimation onFinish`);
      this.isAlphaFinished = true;
      if (this.isAlphaInterrupted) {
        this.isAlphaInterrupted = false;
        return;
      }
      this.recoverTask = setTimeout(() => {
        Log.info(TAG, 'time up and recover');
        this.isChangingImage = false;
        if (this.recoverTask !== -1) {
          clearTimeout(this.recoverTask);
          this.recoverTask = -1;
        }
      }, TIMEOUT_DURATION);
      this.transitOpacity = 0;
    },
  };

  private doAnimator(): void {
    if (this.isChangeResourceLoad) {
      Log.warn(TAG, 'no animation for mix normalized and non-normalized scenes.');
      return;
    }
    if (this.deviceChangeStatus === DeviceChangeStatus.INVALID || this.isChangeResourceLoad ||
      (this.isNewResourceLoad && this.deviceChangeStatus === DeviceChangeStatus.ROTATE)) {
      this.transitOpacity = 0;
      return;
    }
    if (this.recoverTask !== -1) {
      Log.info(TAG, 'clear previous time out');
      clearTimeout(this.recoverTask);
      this.recoverTask = -1;
    }

    // the previous animation is interrupted
    if (!this.isAlphaFinished) {
      Log.info(TAG, 'AlphaAnimation is interrupted.');
      this.isAlphaInterrupted = true;
    }
    if (this.modifier?.visibility === Visibility.None) {
      this.isChangingImage = false;
      return;
    }
    this.isAlphaFinished = false;
    this.staticWallpaperAnimSize = this.staticWallpaperManager.setStaticWallpaperAnimSize(this.deviceChangeStatus,
      this.sendCode === Constants.STATIC_WALLPAPER_LOCK_CODE);
    this.transitOpacity = 1;
    this.updateNodeControl();
    this.isChangingImage = true;
    animateToImmediately(this.alphaAnimation, () => {
      Log.info(TAG, 'AlphaAnimation is finished.');
      this.transitOpacity = 0;
    });
  }

  private updateRectArr(): void {
    Log.info(TAG, 'updateRectArr');
    this.isImageChanged = false;
    this.isLoadFinished = false;
    this.isLayoutReload = false;
  }

  private isChangeResoureLoad(): void {
    Log.info(TAG, `isChangeResoureLoad, isNewResourceLoad: ${this.isNewResourceLoad}`);
    this.isChangeResourceLoad = true;
  }

  /**
   * 主题目录切换监听，监听到主题目录变化时，删除astc文件，防止正常切换主题时，使用到同名的旧主题的astc
   */
  private rootPathListener: RootPathChangeListener = {
    onRootPathChange: async () => {
      Log.info(TAG, 'Root path Changed, delete astc image.');
      this.deleteAstcImage();
    }
  };

  private imageProcessImpl: (pixelMap: object, taskIdRecord: number) => void =
    (pixelMap: object, taskIdRecord: number) => {
    if (taskIdRecord !== this.loadPixelMapTaskId) {
      Log.warn(TAG, `loadPixelMapTaskId has changed, skip switching wallpaper, imageProcessImpl return. taskIdRecord: `,
        `${taskIdRecord}, loadPixelMapTaskId:  ${this.loadPixelMapTaskId}`);
      return;
    }
    if (this.isRefreshAstcImage(pixelMap)) {
      Log.info(TAG, 'Substitute current pixel map instance with ASTC.');
      this.tmpPixelMap = this.imagePixelMap;
      this.imagePixelMap = pixelMap as image.PixelMap;
      Log.info(TAG, `transforms astc pixelMap width: ${this.imagePixelMap.getImageInfoSync().size.width}` +
        ` height:${this.imagePixelMap.getImageInfoSync().size.height}`);
      this.imagePixelMap.scaleSync(
        this.wallpaperCropper.getHorizontalScale(), this.wallpaperCropper.getVerticalScale());
      this.tmpPixelMap?.release();
      this.initMainPixelMap();
      Log.warn(this.bsodTag, 'in static wallpaper imageProcessImpl release tmpPixelMap.');
    }
  };

  private updateNodeControl() {
    if (!this.staticWallpaperManager.isFeatherStatus(this.deviceChangeStatus)) {
      return;
    }
    this.controller.updatePath(this.lastPath, this.deviceChangeStatus);
    if (this.isNewResourceLoad) {
      this.controller.updateRectArr(this.oldRectAttr);
    }
    this.controller.refresh();
  }

  private isRefreshAstcImage(pixelMap: object): boolean {
    return pixelMap !== null && (pixelMap as image.PixelMap).getImageInfoSync().size.width ===
     this.imagePixelMap?.getImageInfoSync().size.width &&
       (pixelMap as image.PixelMap).getImageInfoSync().size.height ===
         this.imagePixelMap?.getImageInfoSync().size.height;
  }

  private async loadPixelMap(): Promise<void> {
    this.isImageChanged = true;

    // 更新并记录任务开始时的时间戳
    this.loadPixelMapTaskId = systemDateTime.getTime();
    const taskIdRecord: number = this.loadPixelMapTaskId;
    this.createTargetPath();
    let isAstcCacheAvailable: boolean = false;
    try {
      isAstcCacheAvailable = fs.accessSync(this.targetPath);
    } catch (e) {
      Log.error(TAG, `Error on checking astc cache status ${e?.code}`);
    }
    if (isAstcCacheAvailable) {
      try {
        let astcPixelMap: image.PixelMap | null = await PixelMapUtil.getPixelMap(this.targetPath);

        // 保证当前获取到的astc图片不为空，且和当前设备分辨率保持一致，避免时序问题导致加载错误图片
        if (astcPixelMap !== null) {
          if (taskIdRecord !== this.loadPixelMapTaskId) {
            Log.warn(TAG, `loadPixelMapTaskId has changed, skip switching wallpaper, astc return. taskIdRecord: `,
              `${taskIdRecord}, loadPixelMapTaskId:  ${this.loadPixelMapTaskId}`);
            return;
          }
          this.updatePixelMap(astcPixelMap);
          Log.info(TAG, `Current static wallpaper has its corresponding ASTC file and has been loaded and pixelMap` +
            ` size width:${this.imagePixelMap?.getImageInfoSync().size.width}` +
            ` height:${this.imagePixelMap?.getImageInfoSync().size.height}`);
          this.initMainPixelMap();
          ThemeLoadPublisher.getInstance().reportThemeLoad();
          return;
        }
      } catch (e) {
        Log.error(TAG, `Load astc image error: ${e?.message}.`)
        this.deleteAstcImage();
      }
    }

    let imageSrc: image.ImageSource = image.createImageSource(this.imagePath);
    let imageInfo: image.ImageInfo = await imageSrc.getImageInfo();
    let croppedDecodingOptions: image.DecodingOptions | undefined = this.isNewResourceLoad ? undefined :
      await this.wallpaperCropper.getCropDecodingOption(imageInfo);
    await imageSrc.createPixelMap(croppedDecodingOptions).then(async (pixelMap: image.PixelMap) => {
      if (!pixelMap) {
        Log.error(TAG, `Failed to create pixel map, wallpaper display may not work properly.`);
      } else if (taskIdRecord !== this.loadPixelMapTaskId) {
        Log.warn(TAG, `loadPixelMapTaskId has changed, skip switching wallpaper, createPixelMap return. taskIdRecord: `,
          `${taskIdRecord}, loadPixelMapTaskId:  ${this.loadPixelMapTaskId}`);
      } else {
        Log.info(TAG, `Load resource success.`);
        await pixelMap.scale(this.wallpaperCropper.getHorizontalScale(), this.wallpaperCropper.getVerticalScale());
        this.updatePixelMap(pixelMap);
        ThemeLoadPublisher.getInstance().reportThemeLoad();
      }
    });
    imageSrc.release();
    Log.warn(this.bsodTag, 'in static wallpaper Releasing image source instance after use.');

    this.tmpPixelMap = this.imagePixelMap;
    taskpool.execute(pixelMapTransformation, this.imagePath, this.targetDirectory, this.targetPath, croppedDecodingOptions)
      .then((pixelMap: object) => {
        this.imageProcessImpl(pixelMap, taskIdRecord);
      });
  }

  private updatePixelMap(pixelMap: image.PixelMap): void {
    if (pixelMap === null) {
      Log.error(TAG, 'pixelMap is null.')
      return;
    }

    // 图片发生改变后，记录上一次pixelMap用于横竖屏旋转和折展动画
    const wasteImage: image.PixelMap | null = this.lastImage;
    this.lastPixelMapPath = this.lastPath;
    this.lastImage = this.imagePixelMap;
    this.imagePixelMap = pixelMap;
    Log.info(TAG, `updatePixelMap. isImageChanged: ${this.isImageChanged}, isLoadFinished: ${
    this.isLoadFinished}, isLayoutReload:${this.isLayoutReload}`);

    // 图片加载完成，触发动画
    this.processAnimation();
    this.isLoadFinished = true;
    wasteImage?.release(() => {
      Log.warn(this.bsodTag, 'updatePixelMap, lastImage release.');
    });
  }

  private initMainPixelMap(): void {
    if (this.deviceChangeStatus === DeviceChangeStatus.INVALID && this.lastImage === null) {
      Log.info(TAG, 'initMainPixelMap');
      this.lastPath = this.imagePath;
      this.lastPixelMapPath = this.imagePath;
      this.lastImage = this.imagePixelMap;
    }
  }

  private createTargetPath(): void {
    this.targetPath = this.imagePath.replace(new RegExp(Constants.THEME_ROOT_REGEX, 'g'), '');
    const urls: string[] = this.targetPath.split(Constants.FILE_SEPARATOR);
    if (urls.length === 0) {
      return;
    }
    const imageNames: string[] = urls[urls.length - 1].split('.');
    if (imageNames.length === 0) {
      return;
    }

    const prefix: string = FileUtil.getThemePathId();
    urls[1] = prefix + urls[1];
    this.astcRoot = Constants.SANDBOX_PATH_SHARE + urls[1];
    this.targetPath = Constants.SANDBOX_PATH_SHARE + urls.join(Constants.FILE_SEPARATOR);
    this.targetPath = this.targetPath.replace(urls[urls.length - 1], '');

    const imageSuffix: string = imageNames[imageNames.length - 1];
    if (SUPPORT_FORMAT.indexOf(imageSuffix) !== -1) { // -1: The format is not supported
      const astcImage: string = prefix + '_' + imageNames[0] + Constants.ASTC_SUFFIX;
      this.targetDirectory = this.targetPath;
      Log.info(TAG, `creating cache directory ${this.targetDirectory}`);
      this.createDirectory();
      this.targetPath += astcImage;
    }
  }

  private createDirectory(): void {
    try {
      if (fs.accessSync(this.targetDirectory)) {
        Log.info(TAG, 'current directory has been created');
        return;
      }
      fs.mkdirSync(this.targetDirectory, true);
    } catch (e) {
      Log.error(TAG, `fail create directory error: ${e?.message}`);
    }
  }

  /**
   * 删除astc图片
   */
  private deleteAstcImage(): void {
    Log.info(TAG, `deletePath = ${this.astcRoot}`);
    try {
      fs.rmdirSync(this.astcRoot);
    } catch (e) {
      Log.error(TAG, `fail delete directory error: ${e?.message}`);
    }
  }

  /**
   * On loading, load the image's pixel map instance. When load is finished, send common event to notify load finish
   */
  public async aboutToAppear(): Promise<void> {
    Log.info(TAG, `On loading static wallpaper resource. isNewResourceLoad = ${this.isNewResourceLoad}`);
    this.rectAttr = this.staticWallpaperManager.updateRectData(this.wallpaperConfig);
    await this.loadPixelMap();
    PathReloadStrategy.getInstance().addUpdateRootPathListener(this.rootPathListener);
    LayoutReloadStrategy.getInstance().addReloadListener(this.layoutReloadListener);
  }


  /**
   * On exiting, release the pixel map instance to prevent memory leak
   */
  public aboutToDisappear(): void {
    Log.warn(this.bsodTag, `in aboutToDisappear() Releasing static wallpaper resource after use.`);
    this.deleteAstcImage();
    this.imagePixelMap?.release();
    this.lastImage?.release();
    this.controller.releaseImage();
    PathReloadStrategy.getInstance().removeUpdateRootPathListener(this.rootPathListener);
    LayoutReloadStrategy.getInstance().removeReloadListener(this.layoutReloadListener);
  }

  public onPageHide(): void {
    Log.warn(this.bsodTag, `in static wallpaper onPageHide().`);
  }

  public build(): void {
    if (this.isNewResourceLoad) {
      this.newWallpaperImage();
    } else {
      this.oldWallpaperImage();
    }
  }

  @Builder
  oldWallpaperImage() {
    if (!this.isChangingImage) {
      Image(this.imagePixelMap)
        .draggable(false)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .hoverEffect(HoverEffect.None)
        .interpolation(ImageInterpolation.Low)
        .syncLoad(true)
        .attributeModifier(this.modifier)
    } else {
      this.noneNormalizedAnimator();
    }
  }

  @Builder
  noneNormalizedAnimator() {
    Stack() {
      Image(this.imagePixelMap)
        .draggable(false)
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .hoverEffect(HoverEffect.None)
        .interpolation(ImageInterpolation.Low)
        .syncLoad(true)
        .attributeModifier(this.modifier)
        .onComplete((event) => {
          if (event) {
            Log.info(TAG, `noneNormalized onComplete, sendCode:${this.sendCode}, w:${event.width}, h:${event.height}`);
          }
        })
        .onError((error: ImageError) => {
          Log.info(TAG, `noneNormalized onError, sendCode:${this.sendCode}, error message:${error.message}`);
        })
      Stack() {
        if (this.staticWallpaperManager.isFeatherStatus(this.deviceChangeStatus)) {
          NodeContainer(this.controller)
            .width('100%').height('100%')
        } else {
          Image(this.lastImage)
            .draggable(false)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover)
            .hoverEffect(HoverEffect.None)
            .interpolation(ImageInterpolation.Low)
            .syncLoad(true)
        }
      }
      .width(this.staticWallpaperAnimSize.width)
      .height(this.staticWallpaperAnimSize.height)
      .position({ x: this.staticWallpaperAnimSize.posX, y: this.staticWallpaperAnimSize.posY })
      .opacity(this.transitOpacity)
      .attributeModifier(this.modifier)
    }
  }

  @Builder
  newWallpaperImage() {
    Stack() {
      Image(this.imagePixelMap)
        .objectFit(ImageFit.Cover)
        .interpolation(ImageInterpolation.Low)
        .hoverEffect(HoverEffect.None)
        .wallpaperContentStyle()
        .syncLoad(true)
        .blur(this.wallpaperConfig?.blurRadius ?? 0)
        .onComplete((event) => {
          if (event) {
            Log.info(TAG, `normalize onComplete, sendCode:${this.sendCode}, w:${event.width}, h:${event.height}`);
          }
        })
        .onError((error: ImageError) => {
          Log.info(TAG, `normalize onError, sendCode:${this.sendCode}, error message: ${error.message}`);
        })
      if (this.isChangingImage) {
        this.normalizedAnimator()
      }
    }
    .draggable(false)
    .attributeModifier(this.modifier)
    .constraintSize({
      minWidth: '100%',
      minHeight: '100%',
    })
    .size({
      width: '100%',
      height: '100%',
    })
  }

  @Builder
  normalizedAnimator() {
    Stack() {
      if (this.staticWallpaperManager.isFeatherStatus(this.deviceChangeStatus)) {
        NodeContainer(this.controller)
          .wallpaperOldContentStyle()
      } else {
        Image(this.lastImage)
          .objectFit(ImageFit.Cover)
          .interpolation(ImageInterpolation.Low)
          .hoverEffect(HoverEffect.None)
          .syncLoad(true)
          .wallpaperOldContentStyle()
          .blur(this.wallpaperConfig?.blurRadius ?? 0)
      }
    }
    .width(this.staticWallpaperAnimSize.width)
    .height(this.staticWallpaperAnimSize.height)
    .position({ x: this.staticWallpaperAnimSize.posX, y: this.staticWallpaperAnimSize.posY })
    .opacity(this.transitOpacity)
    .clip(true)
  }

  /**
   * 设置展示区域
   */
  @Styles
  wallpaperContentStyle() {
    .draggable(false)
    .size({
      width: `${this.rectAttr?.contentShowWidth}px`, // 展示尺寸
      height: `${this.rectAttr?.contentShowHeight}px`,
    })
    .position({
      x: `${this.rectAttr?.contentOffsetX}px`, // 左上角坐标
      y: `${this.rectAttr?.contentOffsetY}px`,
    });
  }

  @Styles
  wallpaperOldContentStyle() {
    .draggable(false)
    .size({
      width: `${this.oldRectAttr?.contentShowWidth}px`,
      height: `${this.oldRectAttr?.contentShowHeight}px`,
    })
    .position({
      x: `${this.oldRectAttr?.contentOffsetX}px`,
      y: `${this.oldRectAttr?.contentOffsetY}px`,
    });
  }
}
