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
import { TARGET_SUB_SCREEN, TargetType, ThemeInfo, ThemeMixInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, TsLog } from '@ohos/themeservicebase';
import { TSPathUtils } from '../../../../../util/TSPathUtils';
import { ActivatedThemeUtil } from '../../../../../util/ActivatedThemeUtil';

const TAG: string = `AbsExtensionResInstaller`;

export abstract class AbsExtensionResInstaller {
  protected static readonly BASE_STYLE: string = 'style0';

  protected readonly themeInfo: ThemeInfo;

  protected readonly resType: string;

  constructor(resType: string, themeInfo: ThemeInfo) {
    this.resType = resType;
    this.themeInfo = themeInfo;
  }

  /**
   * 拷贝指定风格的资源到沙箱目录
   * @param style 风格
   * @returns 是否拷贝成功
   */
  abstract install(style: string): Promise<boolean>;

  /**
   * 获取原始主题包中不同风格资源的路径
   * @param style 需要的风格
   * @param enableSubScreen 是否外屏资源
   * @returns 原始主题包中不同风格资源的路径
   */
  protected getStyleResPath(style: string, enableSubScreen: boolean = false): Nullable<string> {
    let originPackPath: string | undefined = this.themeInfo.originThemePack?.srcPath;
    if (!originPackPath) {
      TsLog.warning(TAG, `the prest pack path not find, type = ${this.resType}, subscreen = ${enableSubScreen}`);
      return;
    }
    let subScreenPath: string = `${originPackPath}/${TARGET_SUB_SCREEN}`;
    let resPath: string =
      enableSubScreen ? `${subScreenPath}/${this.resType}` : `${originPackPath}/${this.resType}`;
    if (style === AbsExtensionResInstaller.BASE_STYLE) {
      if (!FileUtil.isFileExists(resPath)) {
        TsLog.warning(TAG, `base res path not find, type = ${this.resType}, subscreen = ${enableSubScreen}`);
        return;
      }
      return resPath;
    }

    resPath = enableSubScreen ? `${subScreenPath}/${this.resType}_extension/${style}` :
      `${originPackPath}/${this.resType}_extension/${style}`;
    if (!FileUtil.isFileExists(resPath)) {
      TsLog.warning(TAG, `${style} path not find, type = ${this.resType}, subscreen = ${enableSubScreen}`);
      return;
    }
    return resPath;
  }

  /**
   * 拷贝基础资源到沙箱目录,并且对应的description文件拷贝到沙箱目录
   * @param enableSubScreen 是否外屏资源
   * @returns 是否拷贝成功
   */
  protected async installBaseRes(enableSubScreen: boolean = false): Promise<boolean> {
    let baseResPath: Nullable<string> = this.getStyleResPath(AbsExtensionResInstaller.BASE_STYLE, enableSubScreen);
    if (!baseResPath) {
      TsLog.warning(TAG, `not find base res`);
      return false;
    }
    let ret: boolean =
      await FileUtil.copyDirAsync(enableSubScreen ? ActivatedThemeUtil.getActivateResPath(TARGET_SUB_SCREEN) :
        baseResPath, TSPathUtils.getTsPackagedPath());
    if (ret) {
      if (!this.themeInfo.originThemePack?.srcPath) {
        TsLog.warning(TAG, `not find the origin path`);
        return false;
      }
      const descriptionPath: string = `${this.themeInfo.originThemePack.srcPath}/description.json`;
      const copyDestPath: string = enableSubScreen ?
        `${TSPathUtils.getTsPackagedPath()}/${TARGET_SUB_SCREEN}/description.json` :
        `${TSPathUtils.getTsPackagedPath()}/${this.resType}/description.json`;
      ret = await FileUtil.copyFileAsync(descriptionPath, copyDestPath);
    }
    return ret;
  }

  /**
   * 当前资源是否被混搭
   * @returns
   */
  protected async isResMixed(): Promise<boolean> {
    let mixThemeInfos: Map<TargetType, ThemeMixInfo> | undefined = this.themeInfo.mixThemeInfos;
    if (!mixThemeInfos) {
      return false;
    }
    return mixThemeInfos.has(this.resType as TargetType);
  }
}