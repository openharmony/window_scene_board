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

import { common } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { effectKit } from '@kit.ArkGraphics2D';
import { LengthMetrics, promptAction } from '@kit.ArkUI';
import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import { FileUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { TSManager } from '@ohos/themeservicekit/Index';
import { WallPaper } from '@ohos/themeservicekit/src/main/ets/service/model/WallPaper'
import fileuri from '@ohos.file.fileuri';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { SCBScreenSessionManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import { RotationConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { SCBCustomDialogWrapper } from '@ohos/pcbase/src/main/ets/common/SCBCustomDialogWrapper';
import { PixelMapUtil } from '@ohos/pcbase/src/main/ets/SceneBoard/themeeditor/PixelMapUtil';

const TAG: string = 'WallpaperApplyPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const IMG_SUFFIX: string[] = ['.png', '.jpg', '.jpeg', '.webp', '.bmp', '.raw'];
const TEMP_FILE: string = '/data/storage/el2/base/haps/engineservice/files/temp';
const DIALOG_WIDTH: number = 480;
const DIALOG_RADIO: number = 20;
const OFFSET_X: number = 0;
const OFFSET_Y: number = -20;
const THUMBNAIL_RADIUS: number = 8;
const THUMBNAIL_WIDTH: number = 206;
const THUMBNAIL_IMAGE_WIDTH: number = 214;
const THUMBNAIL_TEXT_HEIGHT: number = 22;
const THUMBNAIL_SPACING: number = 8;
const THUMBNAIL_MARGIN: number = 12;
const TITLE_FONTSIZE: number = 20;
const TITLE_WIDTH: number = 312;
const TITLE_HEIGHT: number = 72;
const TITLE_CLOSE_RADIUS: number = 8;
const TITLE_CLOSE_SIZE: number = 40;
const TITLE_CLOSE_PADDING: number = 16;
const TITLE_CLOSE_X_SIZE: number = 24;
const CONTENT_MARGIN: number = 24;
const APPLY_BUTTON_WIDTH: number = 432;
const APPLY_BUTTON_HEIGHT: number = 40;
const APPLY_BUTTON_MARGIN: number = 16;
const APPLY_BUTTON_RADIUS: number = 8;
const WALLPAPER_CATEGORY: string = 'origin';
const WALLPAPER_FROM: string = 'photo';
const LIGHT_COLOR_DEGREE: number = 1;
const QUARTER: number = 4
const HPR_FOLD_ASPECT_RATIO: number = 0.75;

@Entry
@Component
struct WallpaperApplyPage {
  @State tempFileUri: string = '';
  @State url: string = '';
  @State realUrl: string = '';
  @State isLightWallpaper: boolean = false;
  @State previewPixelMap: image.PixelMap | null = null;
  @State previewAspectRatio: number = 1.5;
  private context: common.ServiceExtensionContext | undefined;
  private tempImagePath: string = '';
  /**
   * 展开态弹窗
   */
  private dialogExpandController: CustomDialogController = new CustomDialogController({
    builder: WallpaperApplyDialog({
      cancel: () => {
        this.closeDialog();
      },
      confirm: () => {
        this.initSetWallpaperCallback();
      },
      imageUrl: this.realUrl,
      isLightWallpaper: this.isLightWallpaper,
      previewPixelMap:this.previewPixelMap,
      previewAspectRatio:this.previewAspectRatio,
    }),
    cancel: () => {
      this.closeDialog();
    },
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: OFFSET_X, dy: OFFSET_Y },
    customStyle: false,
    showInSubWindow: true,
    cornerRadius: DIALOG_RADIO,
    width: DIALOG_WIDTH,
    backgroundColor: Color.Transparent,
    maskColor: $r('sys.color.ohos_id_color_mask_thin'),
  });
  /**
   * 折叠态弹窗
   */
  private dialogFoldController: CustomDialogController | null =
    DeviceHelper.isSuperFoldMachine() ? new CustomDialogController({
      builder: WallpaperApplyDialog({
        cancel: () => {
          this.closeDialog();
        },
        confirm: () => {
          this.initSetWallpaperCallback();
        },
        imageUrl: this.realUrl,
        isLightWallpaper: this.isLightWallpaper,
        previewPixelMap:this.previewPixelMap,
        previewAspectRatio:this.previewAspectRatio,
      }),
      cancel: () => {
        this.closeDialog();
      },
      autoCancel: true,
      alignment: DialogAlignment.Top,
      offset: { dx: OFFSET_X, dy: this.getDialogOffsetYInHalfFold() + OFFSET_Y },
      customStyle: false,
      showInSubWindow: true,
      cornerRadius: DIALOG_RADIO,
      width: DIALOG_WIDTH,
      backgroundColor: Color.Transparent,
      maskColor: $r('sys.color.ohos_id_color_mask_thin'),
    }) : null;
  private dialogController: SCBCustomDialogWrapper =
    new SCBCustomDialogWrapper(this.dialogExpandController, this.dialogFoldController);

  /*
   * 获取折叠PC悬停态dialog的偏移量
   */
  private getDialogOffsetYInHalfFold(): number {
    let offsetY = 0;
    const screenProp = SCBScreenSessionManager.getInstance().getMainScreenSession().scbScreenProperty;
    if (screenProp.rotation === RotationConstants.ROTATION_90 ||
      screenProp.rotation === RotationConstants.ROTATION_270) {
      offsetY = screenProp.width / QUARTER;
    } else {
      offsetY = screenProp.height / QUARTER;
    }
    this.calculateAspectRatio();
    const dialogHeight: number =
      TITLE_HEIGHT + THUMBNAIL_WIDTH / this.previewAspectRatio + THUMBNAIL_SPACING + THUMBNAIL_TEXT_HEIGHT +
        APPLY_BUTTON_MARGIN + APPLY_BUTTON_HEIGHT + CONTENT_MARGIN;
    offsetY = px2vp(offsetY) - dialogHeight / 2;
    log.showInfo(`getDialogOffsetYInHalfFold, offsetY:${offsetY}, rotation:${screenProp.rotation}`);
    return offsetY;
  }

  private calculateAspectRatio(): void {
    log.showInfo('calculateAspectRatio start');
    try {
      if (DeviceHelper.isSuperFoldMachine()) {
        this.previewAspectRatio = DeviceHelper.isLandscape() ? 1 / HPR_FOLD_ASPECT_RATIO : HPR_FOLD_ASPECT_RATIO;
      }
    } catch (err) {
      log.showError(`calculateAspectRatio failed. error: ${err?.code} ${err?.message}`);
    }
  }

  public async aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.context = AppStorage.get<common.ServiceExtensionContext>('wallPaperContext');
    this.url = AppStorage.get<string>('src') || '';
    await this.copyFileToTempUri(this.url);
    await this.getPreviewPixelMap();
    this.writePixelMapToTempPath();
    this.checkIsLightWallpaper();
    this.getImage(this.tempFileUri);
    this.calculateAspectRatio();
    this.dialogController.openDialog();
  }

  public aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.previewPixelMap?.release();
  }

  private initSetWallpaperCallback() {
    log.showInfo(`start set wallpaper`)
    try {
      if (this.tempFileUri.length === 0) {
        log.showWarn('tempFileUri is invalid');
        return;
      }
      let wallpaperPath: string = this.tempImagePath;
      let wallpaperModel: WallPaper = new WallPaper();
      let originWallpaper: WallPaper = new WallPaper();
      wallpaperModel.src = wallpaperPath;
      originWallpaper.src = wallpaperPath;
      originWallpaper.category = WALLPAPER_CATEGORY;
      wallpaperModel.applyFrom = WALLPAPER_FROM;
      originWallpaper.applyFrom = WALLPAPER_FROM;
      TSManager.getRemoteCaller(getContext() as common.UIAbilityContext)
        .applyWallpaper([{ wallPapers: [wallpaperModel, originWallpaper], wallPaperType: 'home' },
          { wallPapers: [wallpaperModel, originWallpaper], wallPaperType: 'lock' }])
        .then(async () => {
          this.deleteTempFile();
          log.showInfo('applyWallpaper success');
          this.dialogController.closeDialog();
          this.context?.terminateSelf();
        })
        .catch((error: BusinessError) => {
          log.showError(`applyWallpaper error = ${error?.message}`);
        });
    } catch (err) {
      log.showError('initSetWallpaperCallback error');
      this.deleteTempFile();
    }
  }

  /**
   * 复制图片到指定位置
   * @param uri 图片所在原始路径
   */
  private async copyFileToTempUri(uri: string): Promise<void> {
    const fileName: string = uri.substring(uri.lastIndexOf('/')).toLowerCase();
    log.showInfo(`copyFileToTempUri : ${fileName}`);
    for (const suffix of IMG_SUFFIX) {
      if (fileName.endsWith(suffix.toLowerCase())) {
        this.tempFileUri = TEMP_FILE + `${systemDateTime.getTime(true)}` + suffix;
        try {
          const tempUri: string = fileuri.getUriFromPath(this.tempFileUri);
          await fileIo.copy(uri, tempUri);
          log.showInfo(`copyFile success`);
        } catch (e) {
          log.showError(`copyFile error: ${e?.message}`);
          return;
        }
      }
    }
  }

  private async writePixelMapToTempPath(): Promise<void> {
    this.tempImagePath = TEMP_FILE + `${systemDateTime.getTime(true)}` + '.png';
    PixelMapUtil.writePixelMapToPath(this.previewPixelMap, this.tempImagePath)
  }

  /**
   * 沙箱路径不可以直接显示，需要做转换
   * @param uri 沙箱路径
   */
  private getImage(uri: string) {
    try {
      this.realUrl = fileuri.getUriFromPath(uri);
    } catch (err) {
      log.showError(`getImage error and err is ${err?.message}`);
    }
  }

  private deleteTempFile() {
    log.showInfo(`deleteTempFile`);
    FileUtils.deleteConfigFile(this.tempFileUri);
    FileUtils.deleteConfigFile(this.tempImagePath);
  }

  private closeDialog() {
    log.showInfo(`click remove`)
    try {
      this.dialogController.closeDialog();
      this.context?.terminateSelf();
    } catch (err) {
      log.showError(`closeDialog error and err is ${err?.message}`);
    }
  }

  private async getPreviewPixelMap(): Promise<boolean> {
    let imageSource: image.ImageSource | undefined = undefined;
    try {
      log.showInfo('getPreviewPixelMap start');
      imageSource = image.createImageSource(this.tempFileUri);
      const imageInfo: image.ImageInfo = await imageSource.getImageInfo();
      const decodingOptions: image.DecodingOptions = this.getNormalOptions(imageInfo);
      this.previewPixelMap = await imageSource.createPixelMap(decodingOptions);
      const angle: number = await PixelMapUtil.getImageRotateAngle(imageSource);
      this.previewPixelMap.rotateSync(angle);
      log.showInfo('getPreviewPixelMap end');
      imageSource?.release();
      return true;
    } catch (err) {
      log.showError(`getPreviewPixelMap err: ${err?.message}`);
      imageSource?.release();
      return false;
    }
  }

  private async checkIsLightWallpaper(): Promise<void> {
    if (!this.previewPixelMap) {
      log.showError(`previewPixelMap is null`);
      return;
    }
    try {
      log.showInfo('checkIsLightWallpaper start');
      let colorPicker = await effectKit.createColorPicker(this.previewPixelMap);
      let degree = colorPicker.discriminatePitureLightDegree();
      // MemoryUtils.removeNapiWrap(colorPicker, false);
      log.showInfo(`wallpaper type is ${degree}`);
      this.isLightWallpaper = degree === LIGHT_COLOR_DEGREE;
    } catch (err) {
      log.showError(`checkIsLightWallpaper err: ${err?.message}`);
    }
  }

  private getNormalOptions(imageInfo: image.ImageInfo): image.DecodingOptions {
    let decodingOptions: image.DecodingOptions = {
      editable: true,
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
    };
    if (!imageInfo) {
      log.showError(TAG, `getNormalOptions fail,imageInfo is undefined`);
      return decodingOptions;
    }
    const imageWidth: number = imageInfo.size.width;
    const imageHeight: number = imageInfo.size.height;
    const x: number = 0;
    const y: number = 0;
    decodingOptions = {
      editable: true,
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
      desiredRegion: {
        size: {
          height: imageHeight, width: imageWidth
        }, x: x, y: y
      }
    };
    return decodingOptions;
  }

  build() {

  }
}

@CustomDialog
struct WallpaperApplyDialog {
  controller?: CustomDialogController
  cancel: () => void = () => {
  };
  confirm: () => void = () => {
  };
  @Link imageUrl: string;
  @Link isLightWallpaper: boolean;
  @Link previewPixelMap: image.PixelMap | null;
  @Link previewAspectRatio: number;
  @State isHover: boolean = false;

  async aboutToAppear(): Promise<void> {
    log.showInfo(`WallpaperApplyDialog aboutToAppear,imageUrl: ${this.imageUrl}`)
    if (!this.previewPixelMap) {
      this.showToast();
    }
  }

  private showToast() {
    try {
      log.showInfo(`show image error toast start`);
      promptAction.showToast({
        message: $r('app.string.image_decoding_failure'),
      });
      this.cancel();
    } catch (e) {
      log.showError('show toast error');
    }
  }

  onHoverChanged = (isHover?: boolean) => {
    if (isHover === undefined) {
      return;
    }
    this.isHover = isHover;
  }

  private getIconBackgroundColor(): ResourceColor {
    if (this.isHover) {
      return $r('sys.color.ohos_id_color_hover');
    } else {
      return Color.Transparent;
    }
  }

  build() {
    Column() {
      Flex({
        direction: FlexDirection.Row, alignItems: ItemAlign.Center,
        justifyContent: FlexAlign.SpaceBetween
      }) {
        Row() {
          Text($r('app.string.apply_wallpaper_to'))
            .draggable(false)
            .fontSize(TITLE_FONTSIZE)
            .textAlign(TextAlign.Start)
            .align(Alignment.Start)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .fontWeight(FontWeight.Bold)
            .lineHeight(TITLE_FONTSIZE)
            .flexGrow(1)
            .fontFamily('HarmonyHeiTi')
        }
        .justifyContent(FlexAlign.Center)
        .width(TITLE_WIDTH)
        .height(TITLE_HEIGHT)

        Column() {
          SymbolGlyph($r('sys.symbol.xmark'))
            .draggable(false)
            .fontColor([$r('sys.color.icon_primary')])
            .fontSize(TITLE_CLOSE_X_SIZE)
        }
        .onClick(() => {
          this.cancel();
        })
        .borderRadius(TITLE_CLOSE_RADIUS)
        .width(TITLE_CLOSE_SIZE)
        .height(TITLE_CLOSE_SIZE)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.getIconBackgroundColor())
        .onHover(this.onHoverChanged)
      }
      .padding({
        start: LengthMetrics.vp(CONTENT_MARGIN),
        end: LengthMetrics.vp(TITLE_CLOSE_PADDING),
      })
      .width('100%')
      .height(TITLE_HEIGHT)

      Row() {
        Column({ space: THUMBNAIL_SPACING }) {
          Stack() {
            Image(this.previewPixelMap)
              .draggable(false)
              .borderRadius(THUMBNAIL_RADIUS)
            Image(this.isLightWallpaper ? $r('app.media.mock_clock_dark') : $r('app.media.mock_clock_light'))
              .draggable(false)
              .borderRadius(THUMBNAIL_RADIUS)
          }
          .width(THUMBNAIL_WIDTH)
          .aspectRatio(this.previewAspectRatio)

          Text($r('app.string.apply_screen_lock'))
            .textAlign(TextAlign.Center)
            .height(THUMBNAIL_TEXT_HEIGHT)
        }
        .width(THUMBNAIL_IMAGE_WIDTH)
        .margin({
          end: LengthMetrics.vp(THUMBNAIL_MARGIN)
        })

        Column({ space: THUMBNAIL_SPACING }) {
          Stack() {
            Image(this.previewPixelMap)
              .draggable(false)
              .width(THUMBNAIL_WIDTH)
              .aspectRatio(this.previewAspectRatio)
              .borderRadius(THUMBNAIL_RADIUS)
          }

          Text($r('app.string.apply_desktop'))
            .textAlign(TextAlign.Center)
            .height(THUMBNAIL_TEXT_HEIGHT)
        }
        .width(THUMBNAIL_IMAGE_WIDTH)
      }
      .margin({
        left: CONTENT_MARGIN,
        right: CONTENT_MARGIN
      })

      Button($r('app.string.apply_wallpaper'), { type: ButtonType.Normal, stateEffect: true })
        .onClick(() => {
          log.showInfo('apply button is clicked')
          this.confirm();
        })
        .borderRadius(APPLY_BUTTON_RADIUS)
        .margin({
          left: CONTENT_MARGIN,
          right: CONTENT_MARGIN,
          top: APPLY_BUTTON_MARGIN,
          bottom: CONTENT_MARGIN
        })
        .width(APPLY_BUTTON_WIDTH)
        .height(APPLY_BUTTON_HEIGHT)
    }
  }
}