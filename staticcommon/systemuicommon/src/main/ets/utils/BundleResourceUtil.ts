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
import { bundleManager, Context } from '@kit.AbilityKit';
import { LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils';
import { process, taskpool } from '@kit.ArkTS';
import { HdsIconUtil } from './HdsIconUtil';

export interface BundleResource {
  icon: string;
  label: string;
}

export class BundleResourceUtil {
  public static getBundleResource(context: Context, bundleName: string, bundleType: bundleManager.BundleType,
    parseIcon: boolean): Promise<BundleResource> {
    if (process.tid === process.pid) {
      return taskpool.execute(doGetBundleResource, context, bundleName, bundleType, parseIcon) as Promise<BundleResource>;
    }
    return doGetBundleResource(context, bundleName, bundleType, parseIcon);
  }
}

async function doGetBundleResource(context: Context, bundleName: string, bundleType: bundleManager.BundleType,
  parseIcon: boolean):
  Promise<BundleResource> {
  'use concurrent';

  const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'BundleResourceUtil');
  const resource: BundleResource = { label: '', icon: '' };
  let pixelMap: image.PixelMap | undefined;

  try {
    HdsIconUtil.context = context;
    const bundleResourceManager = (await import('@ohos.bundle.bundleResourceManager')).default;
    const resourceFlag = parseIcon ? (bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL |
    bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_DRAWABLE_DESCRIPTOR)
      : bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL;
    const bundleRes = bundleResourceManager.getBundleResourceInfo(bundleName, resourceFlag);
    resource.label = bundleRes.label;
    // 非兜底场景的非元服务图标通过三缓桌面获取图标以及语言切换场景不切换图标
    if (!parseIcon) {
      return resource;
    }
    const hdsBundleName = bundleName;
    // 元服务图标为透明图标，不能调用hds处理
    pixelMap =
      bundleType === bundleManager.BundleType.ATOMIC_SERVICE ?
      bundleRes.drawableDescriptor?.getPixelMap() :
        await HdsIconUtil.getHdsIcon(hdsBundleName, bundleRes.drawableDescriptor);
    if (!pixelMap || pixelMap?.getPixelBytesNumber() === 0) {
      log.showWarn(`PixelMap of ${bundleName} bytes: ${pixelMap?.getPixelBytesNumber()}`);
    }
    if (pixelMap) {
      PixelMapUtil.addName(pixelMap, 'BundleRes_doGetBundleResource');
      const imagePacker = image.createImagePacker();
      const bufferArray = await imagePacker.packing(pixelMap, {
        format: 'image/png',
        quality: 100
      });
      await imagePacker.release();
      const util = (await import('@ohos.util')).default;
      const base64Helper = new util.Base64Helper();
      let array = new Uint8Array(bufferArray);
      let result = base64Helper.encodeToStringSync(array);
      resource.icon = `data:image/png;base64,${result}`;
    }
    if (resource.icon.length === 0) {
      log.showWarn(`Get resource for ${bundleName} end, icon length: 0`);
    }
  } catch (e) {
    log.error(`Get resouce for ${bundleName} error:`, e);
  } finally {
    await pixelMap?.release();
  }

  return resource;
}