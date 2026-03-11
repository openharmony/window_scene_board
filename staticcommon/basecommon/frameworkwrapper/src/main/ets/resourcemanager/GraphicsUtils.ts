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
import image from '@ohos.multimedia.image';
import util from '@ohos.util';
import {
  CheckEmptyUtils,
  LogDomain,
  Logger,
  PixelMapUtil,
  Trace
} from '@ohos/basicutils';
import taskpool from '@ohos.taskpool';
import { DrawableDescriptor, LayeredDrawableDescriptor } from '@kit.ArkUI';
import { BusinessError } from '@ohos.base';
import { Constants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { IconExtendParam } from './IconExtendParam';
import { iconBorderCropper } from './TransparentBorderIconCropper';

const TAG: string = 'GraphicUtils';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

export class GraphicUtils {
  /**
   * 获取压缩后的融合图标
   *
   * @param bundleName 包名
   * @param iconSizeOfGrid 要裁剪的图标大小
   * @param imageDescriptor 原始图标资源
   * @param maskImage 蒙层
   * @param params 图标参数
   *
   * @returns
   */
  public static async getCombinePixelMap(bundleName: string, iconSizeOfGrid: number,
    imageDescriptor: DrawableDescriptor, maskImage?: image.PixelMap,
    params?: IconExtendParam): Promise<image.PixelMap> {
    if (CheckEmptyUtils.isEmpty(bundleName) || CheckEmptyUtils.isEmpty(imageDescriptor)) {
      log.showWarn(TAG, `bundleName: ${bundleName}, imageDescriptor is empty: ${imageDescriptor == null}`);
      return undefined;
    }
    if (imageDescriptor instanceof LayeredDrawableDescriptor) {
      log.showWarn(TAG, `getHdsLayeredIcon bundleName: ${bundleName}`);
      return GraphicUtils.getHdsLayeredIcon(bundleName, iconSizeOfGrid, imageDescriptor, params?.hasBorder);
    }
    let imagePixelMap = imageDescriptor.getPixelMap();
    if (!imagePixelMap) {
      log.showWarn(TAG, `bundleName: ${bundleName}, getPixelMap is empty: ${imagePixelMap == null}`);
      return imagePixelMap;
    }
    if (params?.isTransparentBorder) {
      await iconBorderCropper.cropByValidRegion(imagePixelMap, bundleName);
    }
    log.showWarn(TAG, `getHdsIcon bundleName: ${bundleName}`);
    return GraphicUtils.getHdsIcon(bundleName, iconSizeOfGrid, imagePixelMap, maskImage, params?.hasBorder);
  }

  /**
   * 获取分层图标的前背景base64
   * @param layerImageDescriptor
   * @returns
   */
  public static async getForeGroundBackGroundBase64(bundleName: string, size: number,
    layerImageDescriptor: LayeredDrawableDescriptor, maskImage?: image.PixelMap): Promise<string[]> {
    if (CheckEmptyUtils.isEmpty(layerImageDescriptor)) {
      return [];
    }
    let background = layerImageDescriptor.getBackground().getPixelMap();
    let foreground = layerImageDescriptor.getForeground().getPixelMap();
    if (background !== null && foreground !== null) {
      if (size !== px2vp(Constants.APP_ICON_STANDARD_WIDTH)) {
        if (foreground.getImageInfoSync().size.width === Constants.APP_ICON_FULL_SIZE) {
          foreground.cropSync({
            x: Constants.APP_ICON_FULL_OFFSET,
            y: Constants.APP_ICON_FULL_OFFSET,
            size: { width: Constants.APP_ICON_STANDARD_WIDTH, height: Constants.APP_ICON_STANDARD_WIDTH }
          });
        }
        let back = await GraphicUtils.changePixelToBase64(background);
        let fore = await GraphicUtils.changePixelToBase64(foreground);
        await background.release();
        await foreground.release();
        return [back, fore];
      }
      let back = await GraphicUtils.changePixelToBase64(background);
      let fore = await GraphicUtils.changePixelToBase64(foreground);
      await background.release();
      await foreground.release();
      return [back, fore];
    }
    return [];
  }

  /**
   * 获取分层应用的融合图标
   *
   * @param bundleName 包名
   * @param iconSizeOfGrid 要裁剪的图标大小
   * @param imageDescriptor 原始图标资源
   * @param hasBorder 是否带描边
   *
   * @returns
   */
  public static getHdsLayeredIcon(bundleName: string, iconSizeOfGrid: number,
    imageDescriptor: LayeredDrawableDescriptor, hasBorder: boolean = false): image.PixelMap {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName) || CheckEmptyUtils.isEmpty(imageDescriptor)) {
      log.showWarn(TAG, `bundleName: ${bundleName}, imageDescriptor is empty: ${imageDescriptor == null}`);
      return undefined;
    }
    this.printLayeredImageSize(bundleName, imageDescriptor);
    Trace.start(`getHdsLayeredIcon, bundleName:${bundleName}`);
    let imagePixelMap: image.PixelMap;
    Trace.end(`getHdsLayeredIcon, bundleName:${bundleName}`);
    log.showWarn(TAG, `combinePic from HdsLayeredIcon, bundleName: ${bundleName}, iconSizeOfGrid: ${iconSizeOfGrid}, hasBorder: ${hasBorder}`);
    PixelMapUtil.addName(imagePixelMap, 'getHdsLayeredIcon_' + bundleName);
    return imagePixelMap;
  }

  /**
   * 获取单层应用的融合图标
   *
   * @param bundleName 包名
   * @param iconSizeOfGrid 要裁剪的图标大小
   * @param pixelMap 待处理的图标
   * @param mask 蒙层
   * @param hasBorder 是否带描边
   *
   * @returns hds处理后的图片
   */
  public static getHdsIcon(bundleName: string, iconSizeOfGrid: number, pixelMap: image.PixelMap,
    mask: image.PixelMap, hasBorder: boolean = false): image.PixelMap {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName) || CheckEmptyUtils.isEmpty(pixelMap) || CheckEmptyUtils.isEmpty(mask)) {
      log.showWarn(TAG, `bundleName: ${bundleName}, pixelMap empty: ${pixelMap == null}, mask empty: ${mask == null}`);
      return undefined;
    }
    this.printPixelMapSize(pixelMap, `${bundleName} - getHdsIcon`);
    Trace.start(`getHdsIcon, bundleName:${bundleName}`);
    let imagePixelMap: image.PixelMap;
    try {
      imagePixelMap = pixelMap;
      PixelMapUtil.addName(imagePixelMap, 'getHdsIcon_' + bundleName);
      // pixelMap.release();
    } catch (err) {
      log.showError(TAG, `getHdsIcon bundleName: ${bundleName} err: ${(err as BusinessError).message}`);
    }
    Trace.end(`getHdsIcon, bundleName:${bundleName}`);
    log.showWarn(TAG, `combinePic from HdsIcon, bundleName: ${bundleName}, iconSizeOfGrid: ${iconSizeOfGrid}, hasBorder: ${hasBorder}`);
    return imagePixelMap;
  }

  public static async changePixelToBase64Child(pixMap: image.PixelMap): Promise<string> {
    try {
      Trace.start('changePixelToBase64Child');
      let result = await taskpool.execute(changePixelToBase64Child, pixMap) as string;
      Trace.end('changePixelToBase64Child');
      return result;
    } catch (error) {
      Trace.end('changePixelToBase64Child');
      log.showError(TAG, `changePixelToBase64Child error ${error}`);
    }
    return undefined;
  }

  public static async changeBase64ToPixelChild(pixelStr: string): Promise<image.PixelMap> {
    try {
      Trace.start('changeBase64ToPixelChild');
      let result = await taskpool.execute(changeBase64ToPixelChild, pixelStr) as image.PixelMap;
      Trace.end('changeBase64ToPixelChild');
      return result;
    } catch (error) {
      Trace.end('changeBase64ToPixelChild');
      log.showError(TAG, `changeBase64ToPixelChild error ${error}`);
    }
    return undefined;
  }

  public static async changePixelToBase64(pixMap: image.PixelMap): Promise<string> {
    if (pixMap === undefined) {
      log.showWarn(TAG, 'getAppIconPixelMap pixMap error');
      return undefined;
    }
    let imagePacker = image.createImagePacker();
    let bufferArray;
    try {
      bufferArray = await imagePacker.packing(pixMap, {
        format: 'image/png',
        quality: 100
      });
    } catch (err) {
      log.showError(TAG, `packing failed: ${err}`);
      return undefined;
    } finally {
      imagePacker.release();
    }
    let base64Helper = new util.Base64Helper();
    let array = new Uint8Array(bufferArray);
    try {
      let result = base64Helper.encodeToStringSync(array);
      return `data:image/png;base64,${result}`;
    } catch (error) {
      log.showError(TAG, 'changePixelToBase64 encodeToStringSync try error', error);
      return undefined;
    }
  }

  public static async changeBase64ToPixel(pixelStr: string, decodingOptions?: image.DecodingOptions): Promise<image.PixelMap> {
    if (CheckEmptyUtils.isEmpty(pixelStr)) {
      log.showWarn(TAG, 'changeBase64ToPixel pixelStr error');
      return undefined;
    }
    let imageSource = image.createImageSource(pixelStr);
    let pixelMap: image.PixelMap;
    if (decodingOptions) {
      pixelMap = await imageSource.createPixelMap(decodingOptions);
    } else {
      pixelMap = await imageSource.createPixelMap();
    }
    imageSource.release();
    return pixelMap;
  }

  public static changeBase64ToPixelSync(pixelStr: string, decodingOptions?: image.DecodingOptions): image.PixelMap {
    if (CheckEmptyUtils.isEmpty(pixelStr)) {
      log.showWarn(TAG, 'changeBase64ToPixelSync pixelStr error');
      return undefined;
    }
    let imageSource = image.createImageSource(pixelStr);
    let pixelMap: image.PixelMap;
    try {
      if (decodingOptions) {
        pixelMap = imageSource.createPixelMapSync(decodingOptions);
      } else {
        pixelMap = imageSource.createPixelMapSync();
      }
    } catch (err) {
      log.showError(TAG, `changeBase64ToPixelSync error, code: ${err?.code}, message:${err?.message}`);
      return undefined;
    } finally {
      imageSource.release();
    }
    return pixelMap;
  }

  /**
   * 打印pixelMap维测日志 判断中心点是否透明
   *
   * @param pixMap 需要打印的pixelMap
   * @param tag 维测TAG
   * @returns true 透明  false 不透明
   */
  public static checkPixelMapCenterInfo(pixelMap: image.PixelMap, tag?: string): boolean {
    if (!pixelMap) {
      log.showWarn(TAG, `${tag}, printImageSize pixMap error`);
      return true;
    }
    let imageInfo = pixelMap.getImageInfoSync();
    let isAlpha = this.isSupportAlphaImage(imageInfo);
    if (!isAlpha) {
      log.showWarn(TAG, `${tag}, PixelMap size: (${imageInfo.size.width}, ${imageInfo.size.height}), not support alpha`);
      return false;
    }

    const centerArea: image.PositionArea = {
      pixels: new ArrayBuffer(4), // 像素buffer大小为4的倍数,对应四通道,取值为:height * width * 4, 单个像素即为4
      offset: 0,
      stride: 4,
      region: { size: { height: 1, width: 1 }, x: imageInfo.size.width / 2, y: imageInfo.size.height / 2 }
    };
    pixelMap.readPixelsSync(centerArea);
    const centerPixel = new Uint8Array(centerArea.pixels);
    log.showWarn(TAG, `${tag}, size: (${imageInfo.size.width}, ${imageInfo.size.height}), ` +
      `pixelFormat: ${imageInfo.pixelFormat}, centerPixel is transparent: ${centerPixel[3] === 0}, ` +
      `${centerPixel[0]}-${centerPixel[1]}-${centerPixel[2]}-${centerPixel[3]}`);

    return centerPixel[3] === 0;
  }

  /**
   * 打印pixelMap维测日志 宽高+左上角元素是否透明
   *
   * @param pixMap 需要打印的pixelMap
   * @param tag 维测TAG
   * @returns
   */
  private static async printPixelMapSize(pixelMap: image.PixelMap, tag?: string): Promise<void> {
    if (!pixelMap) {
      log.showWarn(TAG, `${tag}, printImageSize pixMap error`);
      return;
    }
    let imageInfo = pixelMap.getImageInfoSync();
    let isAlpha = this.isSupportAlphaImage(imageInfo);
    if (!isAlpha) {
      log.showWarn(TAG, `${tag}, PixelMap size: (${imageInfo.size.width}, ${imageInfo.size.height}), not support alpha`);
      return;
    }
    const leftTopArea: image.PositionArea = {
      pixels: new ArrayBuffer(4), // 像素buffer大小为4的倍数,对应四通道,取值为:height * width * 4, 单个像素即为4
      offset: 0,
      stride: 4,
      region: { size: { height: 1, width: 1 }, x: 0, y: 0 }
    };
    pixelMap.readPixelsSync(leftTopArea);
    const leftTopPixel = new Uint8Array(leftTopArea.pixels);

    // BGRA四通道(当前图片编码格式), 第4通道alpha为不透明度, 为0代表此像素透明
    log.showWarn(TAG, `${tag}, size: (${imageInfo.size.width}, ${imageInfo.size.height}), ` +
      `pixelFormat: ${imageInfo.pixelFormat}, leftTopPixel is transparent: ${leftTopPixel[3] === 0}, ` +
      `${leftTopPixel[0]}-${leftTopPixel[1]}-${leftTopPixel[2]}-${leftTopPixel[3]}`);
  }

  private static async printLayeredImageSize(bundleName: string, imageDescriptor: LayeredDrawableDescriptor): Promise<void> {
    if (imageDescriptor === undefined) {
      log.showWarn(TAG, 'printLayeredImageSize imageDescriptor error');
      return;
    }
    this.printPixelMapSize(imageDescriptor.getBackground().getPixelMap(), `${bundleName} Layered background Image`);
    this.printPixelMapSize(imageDescriptor.getForeground().getPixelMap(), `${bundleName} Layered foreground Image`);
  }

  private static isSupportAlphaImage(imageInfo: image.ImageInfo): boolean {
    let pixelFormat = imageInfo.pixelFormat;
    return pixelFormat === image.PixelMapFormat.RGBA_8888 ||
      pixelFormat === image.PixelMapFormat.BGRA_8888 ||
      pixelFormat === image.PixelMapFormat.RGBA_F16;
  }
}

async function changePixelToBase64Child(pixMap: image.PixelMap): Promise<string> {
  'use concurrent';
  if (pixMap === undefined) {
    return undefined;
  }
  let imagePacker = image.createImagePacker();
  let bufferArray;
  try {
    bufferArray = await imagePacker.packing(pixMap, {
      format: 'image/png',
      quality: 100
    });
  } catch (err) {
    return undefined;
  } finally {
    imagePacker.release();
  }
  let base64Helper = new util.Base64Helper();
  let array = new Uint8Array(bufferArray);
  try {
    let result = base64Helper.encodeToStringSync(array);
    return `data:image/png;base64,${result}`;
  } catch (err) {
    return undefined;
  }
}

async function changeBase64ToPixelChild(pixelStr: string): Promise<image.PixelMap> {
  'use concurrent';
  const TAG: string = 'GraphicUtils-changeBase64ToPixelChild';
  const log: Logger = Logger.getLogHelper(LogDomain.SCB);

  if (CheckEmptyUtils.isEmpty(pixelStr)) {
    log.showWarn(TAG, 'change base64 to pixel failed. pixelStr is empty.');
    return undefined;
  }
  let imageSource = image.createImageSource(pixelStr);
  if (!imageSource) {
    log.showWarn(TAG, 'change base64 to pixel failed. imageSource is empty.');
    return undefined;
  }
  let pixelMap = await imageSource.createPixelMap();
  imageSource.release();
  pixelMap.setTransferDetached(true);
  return pixelMap;
}