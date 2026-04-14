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
import { TARGET_SKIN, ThemeInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, JsonUtils, TsLog } from '@ohos/themeservicebase';
import { ActivatedThemeUtil } from '../../../../../util/ActivatedThemeUtil';
import { TSPathUtils } from '../../../../../util/TSPathUtils';
import { AbsExtensionResInstaller } from './AbsExtensionResInstaller';

const TAG: string = 'SkinExtensionResInstaller';

const AUDIO_BUNDLE_NAME: string = 'com.ohos.audioaccessorymanager';

export class SkinExtensionResInstaller extends AbsExtensionResInstaller {
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
      await this.processAudioRes();
      return true;
    }

    // 获取到对应资源预置目录
    let resPath: Nullable<string> = this.getStyleResPath(style);
    if (!resPath) {
      TsLog.warning(TAG, `not find style res`);
      return false;
    }

    let ret: boolean = await this.copySkinRes(resPath);
    if (ret) {
      await this.processAudioRes();
    }
    return ret;
  }

  private async copySkinRes(skinResPath: string): Promise<boolean> {
    TsLog.info(TAG, `copySkinRes`);
    let fileNames: string[] = await FileUtil.listFileNames(skinResPath);
    let tsSkinPath: string = `${TSPathUtils.getTsPackagedPath()}/${TARGET_SKIN}`;

    let ret: boolean = false;
    for (let fileName of fileNames) {
      let filePath: string = `${tsSkinPath}${fileName}`;
      if (FileUtil.isFileExists(filePath)) {
        TsLog.info(TAG, `delete ${fileName}`);
        await FileUtil.deleteAsync(filePath);
      }

      let srcPath: string = `${skinResPath}/${fileName}`;
      let copyRet: boolean = false;
      if (FileUtil.isDir(srcPath)) {
        copyRet = await FileUtil.copyDirAsync(srcPath, tsSkinPath);
      } else {
        copyRet = await FileUtil.copyFileAsync(srcPath, tsSkinPath);
      }
      if (!copyRet) {
        TsLog.warning(TAG, `${fileName} copy fail`);
      }
      ret = ret || copyRet;
    }
    return ret;
  }

  private async writeAudioDescription(): Promise<void> {
    const tsSkinPath = `${TSPathUtils.getTsPackagedPath()}/${TARGET_SKIN}`;
    if (!FileUtil.isFileExists(`${tsSkinPath}/${AUDIO_BUNDLE_NAME}`)) {
      TsLog.info(TAG, `writeAudioDescription, AUDIO_BUNDLE_NAME not find`);
      return;
    }
    const descriptionPath = `${tsSkinPath}/${AUDIO_BUNDLE_NAME}/description.json`;
    try {
      let descriptionContent = '';
      if (!FileUtil.isFileExists(descriptionPath)) {
        descriptionContent = await FileUtil.readFileContent(`${tsSkinPath}/description.json`);
      } else {
        descriptionContent = await FileUtil.readFileContent(descriptionPath);
      }
      const description: object = JSON.parse(descriptionContent);
      description['applyTime'] = Date.now();
      FileUtil.writeFileSync(descriptionPath, JsonUtils.stringify(description));
    } catch (err) {
      TsLog.warning(TAG, `writeAudioDescription err: ${err}`);
    }
  }

  protected async isResMixed(): Promise<boolean> {
    const skinDescription: string = `${ActivatedThemeUtil.getActivateResPath(this.resType)}/description.json`;
    return this.isResMixedUseDescription(skinDescription);
  }

  private async isAudioResMixed(): Promise<boolean> {
    const audioDescription: string =
      `${ActivatedThemeUtil.getActivateResPath(this.resType)}/${AUDIO_BUNDLE_NAME}/description.json`;
    return this.isResMixedUseDescription(audioDescription);
  }

  private async isResMixedUseDescription(descriptionPath: string): Promise<boolean> {
    if (!FileUtil.isFileExists(descriptionPath)) {
      TsLog.info(TAG, `isResMixed, not find description`);
      return false;
    }
    let descriptionContent = await FileUtil.readFileContent(descriptionPath);
    const description: object = JSON.parse(descriptionContent);
    return String(description[`id`]) !== this.themeInfo.id;
  }

  private async processAudioRes(): Promise<void> {
    if (await this.isAudioResMixed()) {
      TsLog.info(TAG, `audio is mixed`);
      await this.copyActivateAudioRes();
    }
    await this.writeAudioDescription();
  }

  private async copyActivateAudioRes(): Promise<void> {
    const activateAudioPath: string = `${ActivatedThemeUtil.getActivateResPath(this.resType)}/${AUDIO_BUNDLE_NAME}`;
    if (FileUtil.isFileExists(activateAudioPath)) {
      const tsAudioPath: string = `${TSPathUtils.getTsPackagedPath()}/${TARGET_SKIN}/${AUDIO_BUNDLE_NAME}`;
      await FileUtil.deleteAsync(tsAudioPath);
      let ret: boolean =
        await FileUtil.copyDirAsync(activateAudioPath, `${TSPathUtils.getTsPackagedPath()}/${TARGET_SKIN}/`);
      TsLog.info(TAG, `copyActivateAudioRes, copy ret = ${ret}`);
    }
  }
}