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
import { DrawableDescriptor, LayeredDrawableDescriptor } from '@kit.ArkUI';
//import { hdsDrawable } from '@kit.UIDesignKit';
import { Context } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SystemUICommonUtil } from './SystemUICommonUtil';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'HdsIconUtil');

/**
 * 图标一致性处理工具
 */
export class HdsIconUtil {
  private static ICON_SIZE: number = 64;
  private static maskImage?: image.PixelMap;

  public static context?: Context;

  private static getMaskImage(bundleName: string): image.PixelMap {
    if (HdsIconUtil.maskImage) {
      return HdsIconUtil.maskImage;
    }
    log.showInfo(`getMaskImage start`);
    try {
      const resManager = HdsIconUtil.context?.resourceManager;
      const layeredDrawableDescriptor =
        (resManager?.getDrawableDescriptor($r('app.media.drawable').id)) as LayeredDrawableDescriptor;
      HdsIconUtil.maskImage = layeredDrawableDescriptor?.getMask().getPixelMap();
      SystemUICommonUtil.setPixelMapName(HdsIconUtil.maskImage, `${bundleName}_maskImage`);
    } catch (err) {
      log.showError(`getMaskImage error: ${err}`);
    }
    log.showInfo(`getMaskImage end`);
    return HdsIconUtil.maskImage;
  }

  public static async getHdsIcon(bundleName: string,
    icon: DrawableDescriptor | image.PixelMap): Promise<image.PixelMap> {
    log.showInfo(`getHdsIcon start`);
    let result: image.PixelMap | undefined;
    let pixelMap: image.PixelMap | undefined;
    try {
      // if (icon instanceof LayeredDrawableDescriptor) {
      //   result = hdsDrawable.getHdsLayeredIcon(bundleName, icon, HdsIconUtil.ICON_SIZE, true);
      //   SystemUICommonUtil.setPixelMapName(result, `${bundleName}_layeredSmallIcon`);
      //   return result;
      // }
      if (icon instanceof DrawableDescriptor) {
        pixelMap = icon.getPixelMap();
      } else {
        pixelMap = icon;
      }
      // const iamgeInfo = await pixelMap.getImageInfo();
      // log.showInfo('Get hds icon running');
      // // 如果旧PixelMap的格式不是 image.PixelMapFormat.BGRA_8888需要重新创建一个BGRA_8888格式的PixelMap
      // if (iamgeInfo.pixelFormat !== image.PixelMapFormat.BGRA_8888) {
      //   log.showInfo('Pixelmap format start');
      //   const color = new ArrayBuffer(pixelMap.getPixelBytesNumber());
      //   await pixelMap.readPixelsToBuffer(color);
      //   if (icon instanceof DrawableDescriptor) {
      //     await pixelMap.release();
      //   }
      //   pixelMap = await image.createPixelMap(color, {
      //     pixelFormat: image.PixelMapFormat.BGRA_8888,
      //     size: iamgeInfo.size,
      //     srcPixelFormat: iamgeInfo.pixelFormat
      //   });
      //   log.showInfo('Pixelmap format end');
      // }
      // result = hdsDrawable.getHdsIcon(bundleName, pixelMap, HdsIconUtil.ICON_SIZE, this.getMaskImage(bundleName), true);
      log.showInfo('Get hds icon end');
      result = pixelMap;
    } catch (e) {
      log.showError(`Get hds icon for ${bundleName} error: ${e.message}`);
    } finally {
      //这里不能释放，犹如result指向了pixelMap，如果释放掉，会导致后续用到result的地方出问题，这里先屏蔽
      // await pixelMap?.release();
    }
    result?.setTransferDetached(true);
    SystemUICommonUtil.setPixelMapName(result, `${bundleName}_smallIcon`);
    return result as image.PixelMap;
  }
}