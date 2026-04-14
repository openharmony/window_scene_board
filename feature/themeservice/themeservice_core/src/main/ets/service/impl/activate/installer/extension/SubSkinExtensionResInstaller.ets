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
import { TARGET_SKIN, TARGET_SUB_SCREEN, ThemeInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, JsonUtils, TsLog } from '@ohos/themeservicebase';
import { TSPathUtils } from '../../../../../util/TSPathUtils';
import { AbsExtensionResInstaller } from './AbsExtensionResInstaller';
import { ActivatedThemeUtil } from '../../../../../util/ActivatedThemeUtil';

const TAG: string = 'SubSkinExtensionResInstaller';

export class SubSkinExtensionResInstaller extends AbsExtensionResInstaller {
  constructor(resType: string, themeInfo: ThemeInfo) {
    super(resType, themeInfo);
  }

  async install(style: string): Promise<boolean> {
    TsLog.info(TAG, `install, subscreen style = ${style}, type = ${this.resType}`);
    if (await this.isResMixed()) {
      TsLog.info(TAG, `subScreen res has mixed, no need install`);
      return false;
    }

    // 拷贝基础资源到使能路径
    if (!await this.installBaseRes(true)) {
      TsLog.warning(TAG, `subScreen base res copy failed, type = ${this.resType}`);
      return false;
    }

    // 获取到对应资源预置目录
    let resPath: Nullable<string> = this.getStyleResPath(style, true);
    if (!resPath) {
      TsLog.warning(TAG, `not find subScreen style res`);
      return false;
    }

    return await this.copySubSkinRes(resPath);
  }

  private async copySubSkinRes(skinResPath: string): Promise<boolean> {
    TsLog.info(TAG, `copy subScreen skin res`);
    let fileNames: string[] = await FileUtil.listFileNames(skinResPath);
    let tsSkinPath: string = `${TSPathUtils.getTsPackagedPath()}/${TARGET_SUB_SCREEN}/${TARGET_SKIN}`;
    let ret: boolean = true;
    for (let fileName of fileNames) {
      let srcPath: string = `${skinResPath}/${fileName}`;
      let copyRet: boolean = false;
      if (FileUtil.isDir(srcPath)) {
        copyRet = await FileUtil.copyDirAsync(srcPath, tsSkinPath);
      } else {
        copyRet = await FileUtil.copyFileAsync(srcPath, `${tsSkinPath}/${fileName}`);
      }
      if (!copyRet) {
        TsLog.warning(TAG, `${fileName} copy fail`);
      }
      ret = ret && copyRet;
    }
    return ret;
  }

  protected async isResMixed(): Promise<boolean> {
    const subScreenDescription: string = `${ActivatedThemeUtil.getActivateResPath(TARGET_SUB_SCREEN)}/description.json`;
    return this.isResMixedUseDescription(subScreenDescription);
  }

  private async isResMixedUseDescription(descriptionPath: string): Promise<boolean> {
    if (!FileUtil.isFileExists(descriptionPath)) {
      TsLog.warning(TAG, `isResMixed, not find description`);
      return false;
    }
    try {
      let descriptionContent: string = await FileUtil.readFileContent(descriptionPath);
      const description: object = JSON.parse(descriptionContent);
      const id: string = description['id'];
      return id !== this.themeInfo.id;
    } catch (error) {
      TsLog.error(TAG, 'parse description id fail', error);
    }
    return false;
  }
}
