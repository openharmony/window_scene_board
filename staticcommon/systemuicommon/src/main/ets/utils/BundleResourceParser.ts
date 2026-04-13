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

import { image } from '@kit.ImageKit';
import { Context } from '@kit.AbilityKit';
import resourceManager from '@ohos.resourceManager';
import { taskpool } from '@kit.ArkTS';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import application from '@ohos.app.ability.application';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { SystemUICommonUtil } from './SystemUICommonUtil';
import { hash } from '@kit.CoreFileKit';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'BundleResourceParser');

type RawImageResult = Array<image.PixelMap>;

interface MediaImageResult {
  light?: image.PixelMap;
  dark?: image.PixelMap;
}

type FdResult = Array<resourceManager.RawFileDescriptor | undefined>;

interface ResourceParseParams {
  isDark: boolean;
  bundleName: string;
  context: Context;
  rawfileImageList: string[][];
  rawfileFdList: string[][];
  mediaImageList: resourceManager.Resource[];
}

interface ResourceParseResult {
  rawfileImageList: RawImageResult[];
  rawfileFdList: FdResult[];
  mediaImageList: MediaImageResult[];
}

/**
 * 跨应用解析资源，在taskpool中处理，避免卡住当前线程
 */
export class BundleResourceParser {
  private rawfileImageMap: Map<string[], (result: RawImageResult) => void> = new Map();
  private rawfileFdMap: Map<string[], (result: FdResult) => void> = new Map();
  private mediaImageMap: Map<resourceManager.Resource, (result: MediaImageResult) => void> = new Map();
  private bundleName: string;
  private context: Context;
  private resPrefix: string;

  constructor(bundleName: string, context: Context, resPrefix: string) {
    this.bundleName = bundleName;
    this.context = context;
    this.resPrefix = resPrefix;
  }

  /**
   * 添加一个解析rawfile图片的处理器
   * @param rawfileList rawfile路径
   * @param callback 处理回调
   */
  public addRawfileImage(rawfileList: string[], callback: (result: RawImageResult) => void): void {
    this.rawfileImageMap.set(rawfileList, callback);
  }

  /**
   * 添加一个解析rawfile fd的处理器
   * @param rawfileList rawfile路径
   * @param callback 处理回调
   */
  public addRawfileFd(rawfileList: string[], callback: (result: FdResult) => void): void {
    this.rawfileFdMap.set(rawfileList, callback);
  }

  /**
   * 添加一个解析media图片的处理器
   * @param res 图片资源
   * @param callback 处理回调，回调结果中第一个为浅色模式图片，第二个为深色模式图片
   */
  public addMediaImage(res: resourceManager.Resource, callback: (result: MediaImageResult) => void): void {
    this.mediaImageMap.set(res, callback);
  }

  /**
   * 解析资源，结果通过前面add添加的回调通知
   */
  public async parse(): Promise<void> {
    if (!this.rawfileImageMap.size && !this.rawfileFdMap.size && !this.mediaImageMap.size) {
      return;
    }
    if (!this.bundleName) {
      log.showInfo('Invalid bundleName');
      return;
    }

    //resource.bundleName解析获取资源,避免代理场景无法获取资源;
    const bundleName = Array.from(this.mediaImageMap.keys())[0]?.bundleName ?? this.bundleName;
    log.showInfo(`Parse resource for ${this.resPrefix} begin`);
    try {
      const params: ResourceParseParams = {
        isDark: baseStateMgr.isDarkMode(),
        bundleName: bundleName,
        context: this.context,
        rawfileImageList: Array.from(this.rawfileImageMap.keys()),
        rawfileFdList: Array.from(this.rawfileFdMap.keys()),
        mediaImageList: Array.from(this.mediaImageMap.keys()),
      };
      const result = await taskpool.execute(parseResource, params) as ResourceParseResult;
      result.rawfileImageList.forEach((list, index) => {
        const keys = params.rawfileImageList[index];
        list.forEach((listItem, idx) => {
          SystemUICommonUtil.setPixelMapName(listItem, this.resPrefix + '_rawfile_' + keys[idx]);
        });
        this.rawfileImageMap.get(keys)?.(list);
      });
      result.rawfileFdList.forEach((list, index) => {
        const keys = params.rawfileFdList[index];
        this.rawfileFdMap.get(keys)?.(list);
      });
      result.mediaImageList.forEach((list, index) => {
        const keys = params.mediaImageList[index];
        const id = params.mediaImageList[index].id;
        SystemUICommonUtil.setPixelMapName(list.light, this.resPrefix + `_media_light_${id}`);
        SystemUICommonUtil.setPixelMapName(list.dark, this.resPrefix + `_media_dark_${id}`);
        this.mediaImageMap.get(keys)?.(list);
      });
      log.showInfo(`Parse resource for ${this.resPrefix} end`);
    } catch (e) {
      log.error(`Parse resource for ${this.resPrefix} error:`, e);
    }
  }
}

async function parseResource(params: ResourceParseParams): Promise<ResourceParseResult> {
  'use concurrent';
  const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'BundleResourceParser');
  const result: ResourceParseResult = {
    rawfileImageList: params.rawfileImageList.map((list) => new Array(list.length)),
    rawfileFdList: params.rawfileFdList.map((list) => new Array(list.length)),
    mediaImageList: new Array(params.mediaImageList.length),
  };
  const resMgr = (await application.createBundleContext(params.context, params.bundleName) as Context).resourceManager;
  let otherResMgr: resourceManager.ResourceManager | undefined;
  const parseRawfileImage = async (rawfile: string): Promise<image.PixelMap | undefined> => {
    let imageSource: image.ImageSource | undefined;
    try {
      const data = await resMgr.getRawFileContent(rawfile);
      imageSource = image.createImageSource(data.buffer);
      const pixelMap = await imageSource?.createPixelMap();
      pixelMap.setTransferDetached(true);
      SystemUICommonUtil.setPixelMapName(pixelMap, `${params.bundleName}_rawfile_${rawfile}`);
      return pixelMap;
    } catch (e) {
      log.error(`Parse rawfile image of ${rawfile} error:`, e);
    } finally {
      imageSource?.release();
    }
    return undefined;
  };
  const parseRawfileFd = async (rawfile: string): Promise<resourceManager.RawFileDescriptor | undefined> => {
    try {
      return await resMgr.getRawFd(rawfile);
    } catch (e) {
      log.error(`Parse rawfile descriptor of ${rawfile} error:`, e);
    }
    return undefined;
  };
  const parseMediaImage = async (resMgr: resourceManager.ResourceManager, resId: number): Promise<image.PixelMap | undefined> => {
    let imageSource: image.ImageSource | undefined;
    let pixelMap: image.PixelMap;
    try {
      const data = await resMgr.getMediaContent(resId);
      imageSource = image.createImageSource(data.buffer);
      const size = (await imageSource.getImageInfo()).size;
      const decodingOptions: image.DecodingOptions = {
        desiredSize: {
          // width: vp2px(size.width),
          width: (size.width),
          // height: vp2px(size.height)
          height: (size.height)
        }
      };
      pixelMap = await imageSource?.createPixelMap(decodingOptions);
      pixelMap.setTransferDetached(true);
      SystemUICommonUtil.setPixelMapName(pixelMap, `${params.bundleName}_media_${resId}`);
      return pixelMap;
    } catch (e) {
      log.error(`Parse media image of ${resId} error:`, e);
    } finally {
      imageSource?.release();
    }
    return undefined;
  };
  const promiseList = [
    ...params.rawfileImageList.flatMap((list, outerIndex) =>
      list.map((item, innerIndex) => parseRawfileImage(item).then((content) => {
        result.rawfileImageList[outerIndex][innerIndex] = content;
      }))
    ),
    ...params.rawfileFdList.flatMap((list, outerIndex) =>
      list.map((item, innerIndex) => parseRawfileFd(item).then((content) => {
        result.rawfileFdList[outerIndex][innerIndex] = content;
      }))
    )
  ];

  if (params.mediaImageList.length) {
    const resConfig = resMgr.getOverrideConfiguration();
    resConfig.colorMode = params.isDark ? resourceManager.ColorMode.LIGHT : resourceManager.ColorMode.DARK;
    otherResMgr = resMgr.getOverrideResourceManager(resConfig);
    const lightResMgr = params.isDark ? otherResMgr : resMgr;
    const darkResMgr = params.isDark ? resMgr : otherResMgr;

    promiseList.push(
      ...params.mediaImageList.flatMap((res: resourceManager.Resource, index) => parseMediaImage(lightResMgr, res.id)
        .then((content) => {
          if (!result.mediaImageList[index]) {
            result.mediaImageList[index] = {};
          }
          result.mediaImageList[index].light = content;
        })),
      ...params.mediaImageList.flatMap((res: resourceManager.Resource, index) => parseMediaImage(darkResMgr, res.id)
        .then((content) => {
          if (!result.mediaImageList[index]) {
            result.mediaImageList[index] = {};
          }
          result.mediaImageList[index].dark = content;
        })),
    );
  }

  await Promise.all(promiseList);

  return result;
}