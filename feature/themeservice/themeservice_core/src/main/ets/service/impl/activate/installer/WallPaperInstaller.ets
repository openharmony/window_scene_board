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
import fileIo from '@ohos.file.fs';
import { ThemeInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, NullableType, TsLog } from '@ohos/themeservicebase';
import { TSPathUtils } from '../../../../util/TSPathUtils';
import { ResourceBasicInstaller } from './ResourceBasicInstaller';

const TAG: string = `WallPaperInstaller`;

export class WallPaperInstaller extends ResourceBasicInstaller {
  constructor(resourceType: string, themeInfo: ThemeInfo) {
    super(resourceType, themeInfo);
  }

  async install(): Promise<boolean> {
    const commonInstallRet: boolean = await super.install();
    if (!commonInstallRet) {
      return false;
    }
    this.addExtendResource();
    try {
      await this.deleteDarkWallpaper();
    } catch (error) {
      TsLog.warning(TAG, 'deleteDarkWallpaper error' + error);
    }
    return true;
  }

  private async deleteDarkWallpaper(): Promise<void> {
    let resourceCustomPath: NullableType<string> = this.getThemeTypeCustomPath();
    if (!resourceCustomPath) {
      return;
    }
    let manifestPath: string = `${resourceCustomPath}/manifest.json`
    if (!FileUtil.isFileExists(manifestPath)) {
      return;
    }
    let resourcePackagedPath: string = `${TSPathUtils.getTsPackagedPath()}/${this.getThemeType()}`;
    let existDark: boolean = false;
    let fileNames: string[] = await fileIo.listFile(resourcePackagedPath);
    for (let fileName of fileNames) {
      if (fileName && fileName.includes(`dark`)) {
        existDark = true;
      }
    }

    if (existDark) {
      let srcFileNames: string[] = await fileIo.listFile(resourcePackagedPath);
      for (let fileName of srcFileNames) {
        if (fileName && fileName.includes(`dark`)) {
          TsLog.info(TAG, `rm wallpaper ` + fileName);
          await fileIo.rmdir(`${resourcePackagedPath}/${fileName}`);
        }
      }
    }
  }
}