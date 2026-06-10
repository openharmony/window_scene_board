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

import { image } from '@kit.ImageKit';
import { resourceManager } from '@kit.LocalizationKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ArrayUtils } from '@ohos/basicutils';
import Want from '@ohos.app.ability.Want';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'NotificationAppInfo');

export interface NotificationWantAgentInfo {
  want?: Want;
  operationType: number;
  bundleName: string;
}

export interface NotificationAppInfoParseParam {
  bundleName: string;
  liveImagesRes?: Record<string, string[]>;
  sound?: string;
}

export class NotificationAppInfo {
  resManager: resourceManager.ResourceManager;
  liveImages: Record<string, (image.PixelMap | string)[]> = {};
  soundDescriptor?: resourceManager.RawFileDescriptor;

  public static async parse(resManager: resourceManager.ResourceManager,
    param: NotificationAppInfoParseParam): Promise<NotificationAppInfo> {
    const appInfo = new NotificationAppInfo();
    try {
      log.info(`Parse notification app info for ${param.bundleName} begin`);
      appInfo.resManager = resManager;
      log.showInfo(`Create context for ${param.bundleName}`);
      appInfo.soundDescriptor = param.sound ? await appInfo.resManager.getRawFd(param.sound) : undefined;
      await appInfo.parseLiveImages(param.liveImagesRes);
      log.info(`Parse notification app info for ${param.bundleName} end`);
    } catch (e) {
      log.error(`Parse notification app info for ${param.bundleName} failed code:` + e?.code +
        ',message:' + e?.message);
    }
    return appInfo;
  }

  private async parseLiveImages(imageRes: Record<string, string[]>): Promise<void> {
    if (!imageRes) {
      return;
    }
    const parsePromise = [];
    for (let imageResKey in imageRes) {
      const res: string[] = imageRes[imageResKey];
      parsePromise.push(this.parseLiveImageList(imageResKey, res));
    }
    await Promise.all(parsePromise);
  }

  private async parseOneLiveImage(imageResKey: string, index: number, res: string): Promise<void> {
    if (!imageResKey || !res) {
      return;
    }
    let imageSource: image.ImageSource;
    let pic: image.PixelMap;
    try {
      const data: Uint8Array = await this.resManager.getRawFileContent(res);
      imageSource = image.createImageSource(data.buffer);
      pic = await imageSource?.createPixelMap();
      imageSource.release();
      this.liveImages[imageResKey][index] = pic;
    } catch (err) {
      imageSource?.release();
      pic?.release();
      this.liveImages[imageResKey][index] = undefined;
      log.error(`parseOneLiveImage failed: [${err?.code}]${err?.message}`);
    }
  }

  private async parseLiveImageList(imageResKey: string, resList: string[]): Promise<void> {
    if (!imageResKey || ArrayUtils.isEmpty(resList)) {
      return;
    }
    this.liveImages[imageResKey] = new Array(resList.length);
    const parsePromise = [];
    for (const [index, res] of resList.entries()) {
      // 图片列表要保持原有顺序，比如进度节点、导航方向
      parsePromise.push(this.parseOneLiveImage(imageResKey, index, res));
    }
    await Promise.all(parsePromise);
  }
}