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

import { PRESET_RES_AOD, PRESET_RES_ICON, ThemePackInfo } from '@ohos/themeservice_inner_api/Index';
import { getThemePackParser } from '../../../../main/ets/preset/ThemePackParser';
import { TSPathUtils } from '../../../../main/ets/util/TSPathUtils';
import fs from '@ohos.file.fs';
import { ArrayUtils } from '@ohos/themeservicebase/Index';

export interface LockHomeManifest {
  type: string;
  image: Image;
}

export interface Image {
  src: string;
}

export namespace ThemePresetDataGetter {
  export async function getDefaultThemePath(): Promise<string> {
    let packInfo: ThemePackInfo = await getThemePackParser().parseDefault();
    return packInfo.srcPath;
  }

  export async function getDefaultLockWallPaper(): Promise<string> {
    let packInfo: ThemePackInfo = await getThemePackParser().parseDefault();
    let manifest: LockHomeManifest = JSON.parse(packInfo.lockManifest);
    return `${packInfo.srcPath}/lock/base/resources/${manifest.image.src}`;
  }

  export async function getDefaultHomeWallPaper(): Promise<string> {
    let packInfo: ThemePackInfo = await getThemePackParser().parseDefault();
    let manifest: LockHomeManifest = JSON.parse(packInfo.homeManifest);
    return `${packInfo.srcPath}/home/base/resources/${manifest.image.src}`;
  }

  export async function getIcons(): Promise<string[]> {
    const iconPathList: Array<string> = await TSPathUtils.getTsPresetRootPath(PRESET_RES_ICON);
    const icons: string[] = [];
    for (const iconPath of iconPathList) {
      let iconsPath: string[] = fs.listFileSync(iconPath);
      ArrayUtils.map(iconsPath, (path: string) => iconPath + '/' + path).forEach((value: string) => {
        icons.push(value);
      });
    }
    return icons;
  }

  export async function getAod(): Promise<string[]> {
    const aodPathList: Array<string> = await TSPathUtils.getTsPresetRootPath(PRESET_RES_AOD);
    const aodResources: string[] = [];
    for (const aodPath of aodPathList) {
      let iconsPath: string[] = fs.listFileSync(aodPath);
      ArrayUtils.map(iconsPath, (path: string) => aodPath + '/' + path).forEach((value: string) => {
        aodResources.push(value);
      });
    }
    return aodResources;
  }
}
