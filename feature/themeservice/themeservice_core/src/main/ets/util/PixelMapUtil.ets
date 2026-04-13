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
import effectKit from '@ohos.effectKit';
import image from '@ohos.multimedia.image';
import { FileUtil, TsLog } from '@ohos/themeservicebase';
import { BlurProxy } from '../service/impl/optimize/BlurProxy';

const TAG: string = 'PixelMapUtil';
const URI_PREFIX: string = 'file://';
const IMAGE_MAX_QUALITY: number = 100;

const IMAGE_SUFFIX_JPG: string = 'jpg';
const IMAGE_QUALITY_JPG: number = 95;
const IMAGE_TYPE_JPG: string = 'image/jpeg';

const IMAGE_SUFFIX_PNG: string = 'png';
const IMAGE_QUALITY_PNG: number = 100; // png 不支持设置图像质量，默认 100
const IMAGE_TYPE_PNG: string = 'image/png';

const IMAGE_SUFFIX_ASTC: string = 'ktx';
const IMAGE_QUALITY_ASTC: number = 20;
const IMAGE_TYPE_ASTC: string = 'image/astc/4*4';

/**
 * 默认最大限制宽度
 */
const DEFAULT_MAX_WIDTH: number = 0;

/**
 * 图像文件类型
 */
export enum ImageFileType {
  JPEG = 'JPEG',
  PNG = 'PNG',
  ASTC = 'ASTC',
};

/**
 * 位图读取选项
 */
export interface IPixelMapReadingOptions {
  // 最大限制宽度
  maximumWidth?: number;
};

/**
 * 位图写入选项
 */
export interface IPixelMapWritingOptions {
  // 写入图像文件的类型
  fileType: ImageFileType;

  // 先写入到临时路径，再移动到目标路径，默认为 false
  isAtomically?: boolean;

  // 写入质量
  quality?: number;
};

/**
 * 位图操作工具类
 * 提供图像文件的读取、写入能力。
 */
export default class PixelMapUtil {
  /**
   * 从图像文件路径创建位图对象
   * @param path 图像文件路径
   * @param options pixelMap错做
   * @returns 位图对象，如果读取失败，返回 undefined。
   * @description 创建出的位图对象需要手动管理其内存释放。
   */
  static async creatScalePixelMap(path: string, options: IPixelMapReadingOptions): Promise<image.PixelMap | undefined> {
    TsLog.info(TAG, `creatScalePixelMap start with: ${FileUtil.getFileName(path)}`);
    if (!FileUtil.isFileExists(path)) {
      TsLog.error(TAG, `file is not exist`);
      return;
    }
    const suffix: string = FileUtil.getFileSuffix(path);
    if (suffix !== IMAGE_SUFFIX_PNG && suffix !== IMAGE_SUFFIX_JPG) {
      TsLog.warning(TAG, `file: ${FileUtil.getFileName(path)} format ${suffix} not support`);
      return;
    }
    let imageSource: Nullable<image.ImageSource>;
    try {
      imageSource = await PixelMapUtil.getImageSourceByPath(path);
    } catch (err) {
      TsLog.error(TAG, `getImageSourceByPath failed.`, err);
      return undefined;
    }
    if (!imageSource) {
      TsLog.error(TAG, 'failed to get image source!');
      return undefined;
    }
    const decodeOptions: image.DecodingOptions = PixelMapUtil.getImageScaleDecodeOpts(imageSource,
      options?.maximumWidth ?? DEFAULT_MAX_WIDTH);
    const pixelMap: Nullable<image.PixelMap> =
      await PixelMapUtil.createPixelMapWithDecodeOpts(imageSource, decodeOptions);
    TsLog.info(TAG, `creatScalePixelMap end with: ${FileUtil.getFileName(path)}`);
    return pixelMap;
  }

  /**
   * 将位图对象写入到指定路径
   * @param pixelMap 位图对象
   * @param targetPath 目标图像路径
   * @param options 写入选项
   * @returns 是否写入成功
   */
  static async writePixelMapToPath(
    pixelMap: Nullable<image.PixelMap>, targetPath: string, options?: IPixelMapWritingOptions): Promise<boolean> {
    TsLog.info(TAG, `writePixelMapToPath begin with: ${FileUtil.getFileName(targetPath)}`);
    let result: boolean = false;
    if (!pixelMap) {
      TsLog.error(TAG, `pixelMap is undefined`);
      return result;
    }
    let tempPath: string = targetPath;
    if (options?.isAtomically) {
      tempPath = FileUtil.appendPathExtension(targetPath, 'atomic');
    }
    let imagePacker: Nullable<image.ImagePacker>;
    // pixelMap转码为其它格式文件保存
    try {
      imagePacker = image.createImagePacker();
      let imageBuffer: ArrayBuffer = await imagePacker.packing(pixelMap,
        PixelMapUtil.getPackingOption(targetPath, options));
      result = FileUtil.writeFileSync(tempPath, imageBuffer);
    } catch (e) {
      TsLog.error(TAG, `writePixelMapToPath failed pack the image:`, e);
    } finally {
      await PixelMapUtil.releaseImagePacker(imagePacker);
      await PixelMapUtil.releasePixelMap(pixelMap);
    }
    // 临时文件写入完毕，重命名为目标文件
    if (result && options?.isAtomically && tempPath !== targetPath) {
      result = await FileUtil.renameAsync(tempPath, targetPath);
    }
    TsLog.info(TAG, `writePixelMapToPath end with: ${FileUtil.getFileName(targetPath)}, result: ${result}`);
    return result;
  }

  private static async releaseImagePacker(imagePacker: Nullable<image.ImagePacker>): Promise<void> {
    try {
      await imagePacker?.release();
    } catch (e) {
      TsLog.error(TAG, 'releaseImagePacker error:', e);
    }
  }

  static async releasePixelMap(pixelMap: Nullable<image.PixelMap>): Promise<void> {
    try {
      await pixelMap?.release();
    } catch (e) {
      TsLog.error(TAG, 'releasePixelMap error:', e);
    }
  }

  private static async createPixelMapWithDecodeOpts(imageSource: image.ImageSource,
    decodeOptions: image.DecodingOptions): Promise<image.PixelMap | undefined> {
    let pixelMap: image.PixelMap | undefined;
    try {
      pixelMap = await imageSource?.createPixelMap(decodeOptions);
    } catch (e) {
      TsLog.error(TAG, 'createPixelMapWithDecodeOpts failed to create the pixel map:', e);
    }

    try {
      await imageSource?.release();
    } catch (e) {
      TsLog.error(TAG, 'createPixelMapWithDecodeOpts failed to release the image source:', e);
    }
    return pixelMap;
  }

  public static async getImageSourceByPath(path: string): Promise<Nullable<image.ImageSource>> {
    if (!(path.startsWith(URI_PREFIX) || path.startsWith('/'))) {
      TsLog.error(TAG, `getImageSourceByPath invalid path!`);
      return undefined;
    }
    TsLog.debug(TAG, `getImageSourceByPath begin with: ${FileUtil.getFileName(path)}`);
    let uri: string = path.startsWith(URI_PREFIX) ? path : URI_PREFIX + path;
    let imageSource: Nullable<image.ImageSource>;
    try {
      imageSource = image.createImageSource(uri);
    } catch (err) {
      TsLog.error(TAG, `createImageSource failed: `, err);
    }
    TsLog.debug(TAG, `getImageSourceByPath end with:${FileUtil.getFileName(path)}`);
    return imageSource;
  }

  /**
   * 获取图像解码选项
   * @param imageSource 图像源
   * @returns 解码选项
   */
  private static getImageScaleDecodeOpts(
    imageSource: image.ImageSource, desiredWidth: number): image.DecodingOptions {
    let decodeOpts: image.DecodingOptions = {
      index: 0,
      rotate: 0,
      editable: false,
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
      resolutionQuality: image.ResolutionQuality.HIGH,
    };
    let imageInfo: Nullable<image.ImageInfo>;
    try {
      imageInfo = imageSource.getImageInfoSync();
    } catch (err) {
      TsLog.error(TAG, `getImageInfo failed: `, err);
    }
    // 根据目标宽度等比缩放原图，获取缩放后的尺寸
    if (imageInfo) {
      const size: image.Size = imageInfo.size;
      const limitSize: image.Size = PixelMapUtil.getUniformScalingImageSize(size, desiredWidth);
      decodeOpts.desiredSize = limitSize;
    }
    TsLog.info(TAG, `width: ${decodeOpts?.desiredSize?.width}, height: ${decodeOpts?.desiredSize?.height}`);
    return decodeOpts;
  }

  /**
   * 计算等比缩放后的图片尺寸
   * @param size 原始图像尺寸
   * @param desiredWidth 图片目标宽度，按照宽度计算缩放比例，等比缩放
   * @returns 受限图像尺寸
   */
  private static getUniformScalingImageSize(size: image.Size, desiredWidth: number): image.Size {
    if (desiredWidth > 0 && size.width > 0) {
      let width: number = desiredWidth > size.width ? size.width : desiredWidth;
      const scale: number = width / size.width;
      size.width = Math.round(size.width * scale);
      size.height = Math.round(size.height * scale);
    }
    return size;
  }

  /**
   * 获取图片转码参数
   * @param targetPath 文件资源路径
   * @param options 位图写入参数
   * @returns image.PackingOption 图片转码参数
   */
  private static getPackingOption(targetPath: string, options?: IPixelMapWritingOptions): image.PackingOption {
    let imageType: ImageFileType = PixelMapUtil.getImageType(targetPath, options);
    let defaultPackingOption: image.PackingOption = {
      format: IMAGE_TYPE_JPG,
      quality: IMAGE_QUALITY_JPG,
    };
    // 根据文件类型确定转码参数
    const fileTypeOptions: Map<ImageFileType, image.PackingOption> = new Map();
    fileTypeOptions.set(ImageFileType.JPEG, {
      format: IMAGE_TYPE_JPG,
      quality: IMAGE_QUALITY_JPG,
    });
    fileTypeOptions.set(ImageFileType.PNG, {
      format: IMAGE_TYPE_PNG,
      quality: IMAGE_QUALITY_PNG,
    });
    fileTypeOptions.set(ImageFileType.ASTC, {
      format: IMAGE_TYPE_ASTC,
      quality: IMAGE_QUALITY_ASTC,
    });
    let packingOption: image.PackingOption = fileTypeOptions.get(imageType) ?? defaultPackingOption;

    if (options?.quality && imageType !== ImageFileType.PNG) {
      packingOption.quality = Math.min(Math.max(options.quality, 0), IMAGE_MAX_QUALITY);
    }
    return packingOption;
  }

  /**
   * 获取图片资源类型
   * @param path 文件资源路径
   * @param options 位图写入参数
   * @returns ImageFileType 文件类型
   */
  private static getImageType(path: string, options?: IPixelMapWritingOptions): ImageFileType {
    let defaultType: ImageFileType = ImageFileType.JPEG;
    const imageTypeOptions: Map<string, ImageFileType> = new Map();
    imageTypeOptions.set(IMAGE_SUFFIX_JPG, ImageFileType.JPEG);
    imageTypeOptions.set(IMAGE_SUFFIX_PNG, ImageFileType.PNG);
    imageTypeOptions.set(IMAGE_SUFFIX_ASTC, ImageFileType.ASTC);
    let imageType: ImageFileType;
    if (options?.fileType) {
      // 从选项读取目标图像文件类型
      imageType = options!.fileType;
    } else {
      // 从路径扩展名识别目标图像文件类型
      const givenPathExt: string = FileUtil.getFileSuffix(path);
      imageType = imageTypeOptions.get(givenPathExt) ?? defaultType;
    }
    return imageType;
  }

  public static async getBlurPixelMap(pixelMap: Nullable<image.PixelMap>,
    radius: number): Promise<Nullable<image.PixelMap>> {
    TsLog.debug(TAG, `getBlurPixelMap begin`);
    if (!pixelMap) {
      TsLog.error(TAG, `pixelMap is undefined`);
      return undefined;
    }
    let blurPixelMap: Nullable<image.PixelMap>;
    try {
      let headFilter = effectKit.createEffect(pixelMap);
      if (headFilter != null) {
        headFilter = BlurProxy.blur(headFilter, radius);
      }
      blurPixelMap = await BlurProxy.getEffectPixelMap(headFilter);
    } catch (err) {
      TsLog.error(TAG, `effect blur failed: `, err);
    } finally {
      await PixelMapUtil.releasePixelMap(pixelMap);
    }
    TsLog.info(TAG, `getBlurPixelMap end`);
    return blurPixelMap;
  }

  public static async creatDefaultPixelMap(path: string): Promise<image.PixelMap | undefined> {
    if (!FileUtil.isFileExists(path)) {
      TsLog.error(TAG, `file is not exist`);
      return;
    }
    let pixelMap: Nullable<image.PixelMap>;
    let imageSource: Nullable<image.ImageSource>;
    try {
      imageSource = await PixelMapUtil.getImageSourceByPath(path);
      pixelMap = await imageSource?.createPixelMap();
    } catch (err) {
      TsLog.error(TAG, `getImageSourceByPath failed.`, err);
    } finally {
      await PixelMapUtil.release(imageSource);
    }
    return pixelMap;
  }

  /**
   * 释放 imageSource
   * @param imageSource image.ImageSource
   * @returns Promise<void>
   */
  public static async release(imageSource: Nullable<image.ImageSource>): Promise<void> {
    try {
      await imageSource?.release();
    } catch (err) {
      TsLog.error(TAG, 'release failed to release the image source:', err);
    }
  }
}
