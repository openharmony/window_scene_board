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
import { HdsIconUtil } from './HdsIconUtil';
import { process, taskpool } from '@kit.ArkTS';
import { DrawableDescriptor } from '@kit.ArkUI';
import { SystemUICommonUtil } from './SystemUICommonUtil';

/**
 * 图标一致性处理工具使用taskpool
 */
export class HdsIconTaskUtil {
  public static async getHdsIcon(context: Context, bundleName: string,
    icon: DrawableDescriptor | image.PixelMap, workerTid?: number): Promise<image.PixelMap> {
    let pixelMap: image.PixelMap;
    if (process.tid === process.pid || process.tid === workerTid) {
      pixelMap = await taskpool.execute(doGetHdsIcon, context, bundleName, icon, workerTid) as image.PixelMap;
    } else {
      pixelMap = await doGetHdsIcon(context, bundleName, icon);
    }
    SystemUICommonUtil.setPixelMapName(pixelMap, `${bundleName}_pixelMap_hdsIcon`);
    return pixelMap;
  }

  public static async getHdsIconBatch(context: Context, iconInfos: Array<IconInfo>,
    workerTid?: number): Promise<Map<string, image.PixelMap>> {
    let iconMap: Map<string, image.PixelMap>;
    if (process.tid === process.pid || process.tid === workerTid) {
      iconMap = await taskpool.execute(doGetHdsIconBatch, context, iconInfos, workerTid) as Map<string, image.PixelMap>;
    } else {
      iconMap = await doGetHdsIconBatch(context, iconInfos);
    }
    iconMap.forEach((icon, key) => SystemUICommonUtil.setPixelMapName(icon, `${key}_pixelMap_hdsIcon`));
    return iconMap;
  }
}

async function doGetHdsIcon(context: Context, bundleName: string,
  icon: DrawableDescriptor | image.PixelMap): Promise<image.PixelMap> {
  'use concurrent';

  HdsIconUtil.context = context;
  return await HdsIconUtil.getHdsIcon(bundleName, icon);
}

async function doGetHdsIconBatch(context: Context, iconInfos: Array<IconInfo>): Promise<Map<string, image.PixelMap>> {
  'use concurrent';

  HdsIconUtil.context = context;
  const hdsIconInfos: Map<string, image.PixelMap> = new Map();
  for (const iconInfo of iconInfos) {
    hdsIconInfos.set(iconInfo.hashCode, await HdsIconUtil.getHdsIcon(iconInfo.hashCode, iconInfo.icon));
  }
  return hdsIconInfos;
}

export interface IconInfo {
  hashCode: string;
  icon: DrawableDescriptor | image.PixelMap;
}