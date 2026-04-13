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

import lazy common from '@ohos.app.ability.common';
import lazy image from '@ohos.multimedia.image';
import lazy fs from '@ohos.file.fs';
import lazy taskpool from '@ohos.taskpool';
import lazy systemDateTime from '@ohos.systemDateTime';
import lazy hash from '@ohos.file.hash';
import lazy { WallpaperCropper } from './WallpaperCropper';
import { Constants } from '../utils/Constants';
import { WallpaperConfig, WallpaperQualifier } from '../pages/WallpaperConfig';
import { WallpaperModifier } from './WallpaperModifier';
import { RectAttr, StaticWallpaperManager } from './StaticWallpaperManager';
import { LayoutReloadListener } from '../reloadmanager/ReloadStrategy';
import { Log } from '../utils/Log';
import { PathReloadStrategy, RootPathChangeListener } from '../utils/PathReloadStrategy';
import { GlobalContext } from '../utils/GlobalContext';
import { DeviceUtil } from '../utils/DeviceUtil';
import { FileUtils } from '../utils/FileUtils';
import { ThemeLoadPublisher } from '../datdamanager/ThemeLoadPublisher';
import { FileUtil } from '../utils/FileUtil';
import { pixelMapTransformation } from '../utils/PixelMapUtil';
import { LayoutReloadStrategy } from '../reloadmanager/LayoutReloadStrategy';

const TAG: string = 'StaticWallpaperDataSource';

// Supported image conversion formats
const SUPPORT_FORMAT: string[] = ['jpg', 'png'];

const ALPHA_DURATION: number = 200;

const ALPHA_DELAY: number = 100;

const TIMEOUT_DURATION: number = 1000;

const DEFAULT_HOME_WALLPAPER: string = 'home_wallpaper_0.jpg';

/**
 * Component definition for static wallpaper, which takes the image source as input to display given image.
 *
 * @since 2024-02-27
 */
@Component
export struct StaticWallpaperDataSource {
  private bsodTag: string = Constants.PREFIX_BSOD + TAG;

  @Link @Watch('loadPixelMap') public imagePath: string;

  /**
   * 区域播放参数（父组件传递）
   */
  @Link @Watch('onWallpaperConfigUpdate')
  public wallpaperConfig: WallpaperConfig | undefined;

  /**
   * 是否以新的资源读取方式加载
   */
  @Link
  public isNewResourceLoad: boolean;

  @State @Watch('fadeInNewImage') private imagePixelMap: image.PixelMap | null = null;

  @State private mainImage: image.PixelMap | null = null;

  @State public modifier: WallpaperModifier | null = null;

  @State private isChangingImage: boolean = false;

  @State private transitOpacity: number = 1;

  private staticWallpaperManager: StaticWallpaperManager = new StaticWallpaperManager();

  @State
  private rectAttr: Nullable<RectAttr> = new RectAttr(new WallpaperConfig());

  @Consume
  private resourceQualifier: number;

  private tmpPixelMap: image.PixelMap | null = null;

  private wallpaperCropper: WallpaperCropper = new WallpaperCropper();

  public sendCode: number = 0;

  private isSame: boolean = false;

  private targetPath: string = '';

  // astc文件根目录
  private astcRoot: string = '';

  private targetDirectory: string = '';

  private recoverTask: number = -1;

  private isMainReleased: boolean = false;

  private isAlphaFinished: boolean = true;

  private isAlphaInterrupted: boolean = false;

  // 记录上层壁纸重新计算尺寸时使用的配置文件的qualifier
  private lastConfigQualifier: Nullable<WallpaperQualifier>;

  /**
   * loadPixelMap任务开始时更新并记录时间戳作为taskId，应用图片时对比记录的taskId和最新的taskId，一致时才更新显示的图片，
   * 以保证显示的是最新的任务加载的图片
   */
  private loadPixelMapTaskId?: number;

  private layoutReloadListener: LayoutReloadListener = {
    reloadLayout: async (screenWidth: number, screenHeight: number) => {
      Log.info(TAG, 'layoutReloadListener.');
      if (this.wallpaperConfig !== undefined) {
        Log.info(TAG, `layoutReloadListener, current qualifier = ${this.wallpaperConfig.rectData?.qualifier}`);
        this.rectAttr?.update(this.wallpaperConfig);
        this.lastConfigQualifier = this.wallpaperConfig.rectData?.qualifier;
      }
    }
  }

  private alphaAnimation: AnimateParam = {
    curve: Curve.FastOutSlowIn,
    duration: ALPHA_DURATION,
    delay: ALPHA_DELAY,
    onFinish: () => {
      this.isAlphaFinished = true;
      if (this.isAlphaInterrupted) {
        this.isAlphaInterrupted = false;
        return;
      }
      this.recoverTask = setTimeout(() => {
        if (this.isMainReleased) {
          Log.info(TAG, 'time up and recover');
          this.isChangingImage = false;
        }
        if (this.recoverTask !== -1) {
          clearTimeout(this.recoverTask);
          this.recoverTask = -1;
        }
      }, TIMEOUT_DURATION);
      this.swapImage();
      this.transitOpacity = 0;
    },
  };

  private swapImage(): void {
    if (this.isMainReleased) {
      Log.warn(TAG, 'Intercepting possible double free.');
      return;
    }
    this.isMainReleased = true;
    const wasteImage: image.PixelMap | null = this.mainImage;
    this.mainImage = this.imagePixelMap;
    wasteImage?.release(() => {
      Log.warn(this.bsodTag, 'in static wallpaper swapImage() Releasing previous wallpaper.');
    });
  }

  private fadeInNewImage(): void {
    if (this.isNewResourceLoad) {
      Log.info(TAG, 'Avoid affecting new resource reads.');
      return;
    }

    // Picture loading scenarios other than rotation.
    if (!(GlobalContext.getContext().getObject(Constants.IS_ROTATED) as boolean)) {
      Log.info(TAG, 'Avoid affecting scenes other than rotation');
      this.isMainReleased = false;
      this.swapImage();
      this.transitOpacity = 0;
      return;
    }

    if (this.recoverTask !== -1) {
      Log.info(TAG, 'clear previous time out');
      clearTimeout(this.recoverTask);
      this.recoverTask = -1;
    }
    this.transitOpacity = 0;
    this.isMainReleased = false;

    // continuous rotation, the previous animation is interrupted
    if (!this.isAlphaFinished) {
      Log.info(TAG, 'AlphaAnimation is interrupted.');
      this.isAlphaInterrupted = true;
      this.swapImage();
    }
    if (!this.isSame) {
      this.isChangingImage = true;
    }
    this.isAlphaFinished = false;
    animateToImmediately(this.alphaAnimation, () => {
      Log.info(TAG, 'AlphaAnimation is finished.');
      this.transitOpacity = 1;
    })
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

  private onWallpaperConfigUpdate(): void {
    if (!this.lastConfigQualifier || !this.wallpaperConfig?.rectData?.qualifier){
      return;
    }
    if (this.isFoldStatusChanged(this.lastConfigQualifier, this.wallpaperConfig.rectData.qualifier)) {
      Log.info(TAG, 'Fold status changed, update rectAttr.');
      this.rectAttr?.update(this.wallpaperConfig);
      this.lastConfigQualifier = this.wallpaperConfig.rectData.qualifier;
    }
  }

  /**
   * 对比最新配置和上次更新时的限定符，判断中间是否发生了折展状态的变化
   *
   * @param lastQualifier 上次更新时的限定符
   * @param currentQualifier 此次更新的限定符
   * @returns true: 折展状态变化了; false: 折展状态未变化
   */
  private isFoldStatusChanged(lastQualifier: WallpaperQualifier, currentQualifier: WallpaperQualifier): boolean {
    Log.info(TAG, `Last wallpaper qualifier ${lastQualifier}, current wallpaper qualifier ${currentQualifier}.`);
    if (lastQualifier === currentQualifier) {
      return false;
    }
    return this.getFoldStatus(lastQualifier) !== this.getFoldStatus(currentQualifier);
  }

  private getFoldStatus(qualifier: WallpaperQualifier): WallpaperQualifier {
    switch (qualifier) {
      case WallpaperQualifier.UNFOLDED2:
      case WallpaperQualifier.UNFOLDED2_LAND:
        return WallpaperQualifier.UNFOLDED2;
      case WallpaperQualifier.UNFOLDED:
      case WallpaperQualifier.UNFOLDED_LAND:
        return WallpaperQualifier.UNFOLDED;
      default: return WallpaperQualifier.BASE;
    }
  }

  private async compareStaticWallpaper(): Promise<void> {
    const sandBox: string = `${GlobalContext.getContext().getObject(Constants.SANDBOX) as string}/home`;
    const defaultDir: string = `resources/${DEFAULT_HOME_WALLPAPER}`;
    if (DeviceUtil.isPortraitPhone()) {
      return;
    }
    try {
      if (DeviceUtil.isPad()) {
        const baseUrl = `${sandBox}/base/${defaultDir}`;
        const landUrl = `${sandBox}/land/${defaultDir}`;
        if (await this.compareHash(baseUrl, landUrl)) {
          this.isSame = true;
        }
        return;
      }
      if (DeviceUtil.isFold()) {
        const unfoldUrl = `${sandBox}/unfolded/${defaultDir}`;
        const unfoldLandUrl = `${sandBox}/unfolded-land/${defaultDir}`;
        if (await this.compareHash(unfoldUrl, unfoldLandUrl)) {
          this.isSame = true;
        }
      }
    } catch {
      this.isSame = false;
      Log.info(TAG, 'target file is not exist');
    }
  }

  private async compareHash(a: string, b: string): Promise<boolean> {
    return await hash.hash(a, 'md5') === await hash.hash(b, 'md5');
  }

  private imageProcessImpl: (pixelMap: object, taskIdRecord: number) => void =
    (pixelMap: object, taskIdRecord: number) => {
    if (taskIdRecord !== this.loadPixelMapTaskId) {
      Log.warn(TAG, 'loadPixelMapTaskId has changed, skip switching wallpaper.');
      return;
    }
    (pixelMap as image.PixelMap).scaleSync(
      this.wallpaperCropper.getHorizontalScale(), this.wallpaperCropper.getVerticalScale());
    if (this.isRefreshAstcImage(pixelMap)) {
      Log.info(TAG, 'Substitute current pixel map instance with ASTC.');
      this.tmpPixelMap = this.imagePixelMap;
      this.imagePixelMap = pixelMap as image.PixelMap;
      Log.info(TAG, `transforms astc pixelMap width: ${this.imagePixelMap.getImageInfoSync().size.width}` +
        ` height:${this.imagePixelMap.getImageInfoSync().size.height}`);
      this.tmpPixelMap?.release();
      Log.warn(this.bsodTag, 'in static wallpaper imageProcessImpl release tmpPixelMap.');
    }
  };

  private isRefreshAstcImage(pixelMap: object): boolean {
    return pixelMap !== null && (pixelMap as image.PixelMap).getImageInfoSync().size.width ===
      this.imagePixelMap?.getImageInfoSync().size.width &&
        (pixelMap as image.PixelMap).getImageInfoSync().size.height ===
          this.imagePixelMap?.getImageInfoSync().size.height;
  }

  private async loadPixelMap(): Promise<void> {
    const wasteImage: image.PixelMap | null = this.imagePixelMap;

    // 更新并记录任务开始时的时间戳
    this.loadPixelMapTaskId = systemDateTime.getTime();
    const taskIdRecord: number = this.loadPixelMapTaskId;
    Log.info(TAG, `loadPixelMap loadPixelMapTaskId is ${this.loadPixelMapTaskId}`);

    this.createTargetPath();
    let isAstcCacheAvailable: boolean = false;
    try {
      isAstcCacheAvailable = fs.accessSync(this.targetPath);
    } catch (e) {
      Log.error(TAG, `Error on checking astc cache status ${e?.code}`);
    }
    if (isAstcCacheAvailable) {
      try {
        await FileUtils.deleteAsync(this.targetPath);
        Log.info(TAG, 'delete astc success');
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
        Log.warn(TAG, 'loadPixelMapTaskId has changed, skip switching wallpaper.');
      } else {
        Log.info(TAG, `Load resource success.`);
        if (croppedDecodingOptions) {
          pixelMap.cropSync(croppedDecodingOptions.desiredRegion);
        }
        await pixelMap.scale(this.wallpaperCropper.getHorizontalScale(), this.wallpaperCropper.getVerticalScale());
        this.imagePixelMap = pixelMap;
        wasteImage?.release();
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
    this.lastConfigQualifier = this.wallpaperConfig?.rectData?.qualifier;
    await this.loadPixelMap();
    await this.compareStaticWallpaper();
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
  oldWallpaperImage(){
    Row() {
      if (!this.isChangingImage) {
        Image(this.mainImage)
          .draggable(false)
          .width('100%')
          .height('100%')
          .objectFit(ImageFit.Cover)
          .hoverEffect(HoverEffect.None)
          .interpolation(ImageInterpolation.Low)
          .syncLoad(true)
      } else {
        Stack() {
          Image(this.mainImage)
            .draggable(false)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover)
            .hoverEffect(HoverEffect.None)
            .interpolation(ImageInterpolation.Low)
            .syncLoad(true)
          Image(this.imagePixelMap)
            .draggable(false)
            .width('100%')
            .height('100%')
            .objectFit(ImageFit.Cover)
            .hoverEffect(HoverEffect.None)
            .interpolation(ImageInterpolation.Low)
            .syncLoad(true)
            .opacity(this.transitOpacity)
        }
      }
    }
    .attributeModifier(this.modifier)
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
    }
    .draggable(false)
    .constraintSize({
      minWidth: '100%',
      minHeight: '100%',
    })
    .size({
      width: '100%',
      height: '100%',
    })
    .attributeModifier(this.modifier)
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
}