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
import image from '@ohos.multimedia.image';
import { LiveViewCommonConstants } from '../../common/LiveConstants';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { CommonConstants } from '@ohos/commonconstants';
import type ctx from '@ohos.app.ability.common';
import type res from '@ohos.resourceManager';
import { LiveButtonArray } from '../../data/extend/LiveButtonData';
import { display } from '@kit.ArkUI';

const TAG = CommonConstants.NTF_LOG_PREFIX + 'TransResToPicHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 将图片资源路径转换为图片的转换器
 */
class TransResToPicHelper {
  /**
   * 记录当前开启转换器的通知请求的包名，并且以非空来作为转换器开启的标志
   */
  private bundleName?: string;

  /**
   * 匹配bundleName的资源管理器
   */
  private resourceManager?: res.ResourceManager;

  private timerId?: number;

  /**
   * 开启解析某一条通知数据时，设置bundleName,转换器设置为开启状态
   *
   * @param creatorBundleName
   */
  start(creatorBundleName: string): void {
    if (CommonUtils.isInvalid(creatorBundleName)) {
      log.showInfo('Start fail, creatorBundleName is invalid');
      return;
    }
    if (this.bundleName === creatorBundleName) {
      log.showDebug('Start with cache');
      if (this.timerId !== undefined) {
        clearTimeout(this.timerId);
        this.timerId = undefined;
      }
      return;
    }
    log.showInfo(`Start with ${creatorBundleName}`);
    this.reset();
    this.bundleName = creatorBundleName;
  }

  /**
   * 本条数据解析完毕，删除bundleName,转换器设置为关闭状态
   */
  end(): void {
    // 延迟释放resourceManager，解决来通知后多次重复创建resourceManager的问题
    this.timerId = setTimeout(() => {
      this.reset();
    }, 100);
  }

  private reset(): void {
    if (!this.resourceManager) {
      return;
    }
    log.showInfo(`Reset resource manager with ${this.bundleName}`);
    this.bundleName = undefined;
    this.resourceManager = undefined;
    if (this.timerId !== undefined) {
      clearTimeout(this.timerId);
      this.timerId = undefined;
    }
  }

  private async createResourceManager(): Promise<void> {
    if (this.resourceManager) {
      return;
    }
    log.showInfo(`Create resource manager for ${this.bundleName} begin`);
    let context = (GlobalContext.getInstance().getObject(LiveViewCommonConstants.CONTEXT) as ctx.ServiceExtensionContext);
    try {
      const bundleContext = context?.createBundleContext(this.bundleName);
      this.resourceManager = bundleContext?.resourceManager;
      log.showInfo(`Create resource manager for ${this.bundleName} end`);
    } catch (error) {
      log.error(`Create resource manager for ${this.bundleName} fail:`, error);
    }
  }

  // 获取折叠屏物理尺寸
  private async getDisplayAllResolution(): Promise<Map<number, number[]>> {
    let resolutionArray: display.DisplayPhysicalResolution[];
    try {
      resolutionArray = await display.getAllDisplayPhysicalResolution();
    } catch (err) {
      log.showError(`setDisplayAllResolutions fail, ${err.code}`);
      return undefined;
    }
    if (ArrayUtils.isEmpty(resolutionArray)) {
      log.showWarn('resolutionArray empty');
      return undefined;
    }
    let resolutionMap: Map<number, number[]> = new Map();
    resolutionArray.forEach((value) => {
      // 展开态KEY为1、折叠态KEY为2、平板&手机KEY为0，取折叠屏最大尺寸
      resolutionMap.set(value.foldDisplayMode, [value.physicalWidth, value.physicalHeight]);
    });
    return resolutionMap;
  }

  private async getDisplaySize(): Promise<Map<number, number>> {
    let defaultDisPlayInfo: Map<number, number> = new Map();
    if (display.isFoldable()) { // 折叠屏
      let physicalArr: number[];
      try {
        physicalArr = (await this.getDisplayAllResolution())?.get(1);
      } catch {
        log.showError('get Display error');
        return undefined;
      }
      if (!physicalArr || physicalArr.length < 2) {
        log.showWarn('physicalArr empty or length insufficient.');
        return undefined;
      }
      return defaultDisPlayInfo.set(physicalArr[0], physicalArr[1]);
    } else { // 其他非折叠设备
      let displayInfo: display.Display;
      try {
        displayInfo = display.getDefaultDisplaySync();
      } catch {
        log.showError('get Display error');
        return undefined;
      }
      if (!CommonUtils.isInvalid(displayInfo)) {
        return defaultDisPlayInfo.set(displayInfo.width, displayInfo.height);
      }
    }
    return undefined;
  }

  private getPicSize(resPath): image.ImageInfo {
    let imageSrc: image.ImageSource;
    let imageInfo: image.ImageInfo;
    try {
      imageSrc = image.createImageSource(resPath);
      if (CommonUtils.isInvalid(imageSrc)) {
        log.showWarn('imageSrc is invalid');
        return undefined;
      }
      imageInfo = imageSrc.getImageInfoSync();
    } catch (err) {
      log.showError(`get image info error, code ${err.code}`);
      return undefined;
    }
    imageSrc.release();
    return imageInfo;
  }

  /**
   * 图片解码前通过图片头信息，限制图片大小
   *
   * @param resPath 图片资源路径
   * @returns 检测结果
   */
  private async isValidPicSize(resPath: string): Promise<boolean> {
    if (CommonUtils.isInvalid(this.getPicSize(resPath)) || CommonUtils.isInvalid(this.getDisplaySize())) {
      log.showWarn('imageInfo is invalid');
      return false;
    }
    let picSizeInfo = this.getPicSize(resPath).size;
    let picWidth = picSizeInfo?.width;
    let picHeight = picSizeInfo?.height;
    let displaySizeInfo = await this.getDisplaySize();
    let displayWidth = displaySizeInfo?.get(0);
    let displayHeight = displaySizeInfo.get(1);
    if (picHeight <= displayHeight && picWidth <= displayWidth) {
      return true;
    }
    log.showInfo(`picWidth: ${picWidth}, picHeight: ${picHeight}, displayWidth: ${displayWidth},
      displayHeight: ${displayHeight}`);
    return false;
  }

  /**
   * 将图片资源路径转换为图片
   *
   * @param resPath 图片资源路径
   */
  async getPicFromRes(resPath: string): Promise<image.PixelMap | undefined> {
    if (CommonUtils.isEmpty(resPath)) {
      log.showWarn('getPicFromRes, iconRes empty');
      return undefined;
    }

    if (!this.isValidPicSize(resPath)) {
      return undefined;
    }

    log.showInfo(`getPicFromRes, bundle:${this.bundleName}`);
    let imgSrc: image.ImageSource;
    let pic: image.PixelMap;
    try {
      await this.createResourceManager();
      const data = await this.resourceManager?.getRawFileContent(resPath);
      const buffer = data.buffer;
      imgSrc = image.createImageSource(buffer);
      const imgInfo = await imgSrc.getImageInfo();
      // 转换pixel时，需要指定宽高，防止图片失真
      const option: image.DecodingOptions = {
        desiredSize: {
          height: vp2px(imgInfo.size.height),
          width: vp2px(imgInfo.size.width),
        },
      };
      pic = await imgSrc.createPixelMap(option);
      imgSrc.release();
      return pic;
    } catch (err) {
      log.error('getPicFromRes failed:', err);
      imgSrc?.release();
      pic?.release();
      return undefined;
    }
  }

  needParsePic(iconUpdateKey: Array<string>, key: string): boolean {
    return iconUpdateKey === undefined ||
      (Array.isArray(iconUpdateKey) && iconUpdateKey.includes(key));
  }
}

let transResToPicHelper = SingletonHelper.getInstance(TransResToPicHelper, TAG);

export default transResToPicHelper as TransResToPicHelper;