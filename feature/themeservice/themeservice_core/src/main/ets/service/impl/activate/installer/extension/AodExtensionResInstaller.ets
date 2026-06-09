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
import { ThemeInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, JsonUtils, TsLog } from '@ohos/themeservicebase';
import { TSPathUtils } from '../../../../../util/TSPathUtils';
import { AbsExtensionResInstaller } from './AbsExtensionResInstaller';

const TAG: string = 'AodExtensionResInstaller';

export class AodExtensionResInstaller extends AbsExtensionResInstaller {
  constructor(resType: string, themeInfo: ThemeInfo) {
    super(resType, themeInfo);
  }

  async install(style: string): Promise<boolean> {
    TsLog.info(TAG, `install, style = ${style}, type = ${this.resType}`);
    if (await this.isResMixed()) {
      TsLog.info(TAG, `res has mixed, no need install`);
      return false;
    }

    // 拷贝基础资源到使能路径
    if (!await this.installBaseRes()) {
      TsLog.warning(TAG, `base res copy failed, type = ${this.resType}`);
      return false;
    }

    // 如果是style0,已经拷贝了基础资源了，不需要再执行下面拷贝，否则是重复拷贝了
    if (style === AbsExtensionResInstaller.BASE_STYLE) {
      await this.writeAodManifestId();
      return true;
    }

    // 获取到对应资源预置目录
    let resPath: Nullable<string> = this.getStyleResPath(style);
    if (!resPath) {
      TsLog.warning(TAG, `not find style res`);
      return false;
    }
    return await this.copyAodRes(resPath);
  }

  private async copyAodRes(aodResPath: string): Promise<boolean> {
    TsLog.info(TAG, `copyAodRes`);
    let tsPackagedPath: string = TSPathUtils.getTsPackagedPath();
    let tsAodPath: string = `${tsPackagedPath}/${this.resType}`;
    let fileNames: string[] = await FileUtil.listFileNames(aodResPath, true);

    for (let fileName of fileNames) {
      let tsFilePath: string = `${tsAodPath}${fileName}`;
      let filePath: string = `${aodResPath}${fileName}`;
      if (FileUtil.isFileExists(tsFilePath)) {
        await FileUtil.deleteAsync(tsFilePath);
      }
      if (!await FileUtil.copyFileAsync(`${filePath}`, `${tsFilePath}`)) {
        TsLog.warning(TAG, `${fileNames} copy fail`);
        return false;
      }
    }
    await this.writeAodManifestId();
    return true;
  }

  private async writeAodManifestId(): Promise<void> {
    try {
      const manifestPath: string = `${TSPathUtils.getTsPackagedPath()}/${this.resType}/manifest.json`;
      const aodManifestContent: string = await FileUtil.readFileContent(manifestPath);
      const manifest: object = JSON.parse(aodManifestContent);
      manifest['id'] = this.themeInfo.id;
      FileUtil.writeFileSync(manifestPath, JsonUtils.stringify(manifest));
    } catch (error) {
      TsLog.error(TAG, 'write manifest id error', error);
    }
  }
}
