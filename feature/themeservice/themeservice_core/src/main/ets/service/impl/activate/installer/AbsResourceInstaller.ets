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

import type common from '@ohos.app.ability.common';
import contextConstant from '@ohos.app.ability.contextConstant';
import { ThemeInfo } from '@ohos/themeservice_inner_api';
import { ContextUtil, FileUtil, NullableType, StringUtils, TsLog } from '@ohos/themeservicebase';
import { TSPathUtils } from '../../../../util/TSPathUtils';
import { ActivatedThemeUtil } from '../../../../util/ActivatedThemeUtil';
import { APP_THEME_TYPE_LIST } from '@ohos/themeservice_inner_api/src/main/ets/constant/TSTypes';

const TAG: string = `AbsResourceInstaller`;

export abstract class AbsResourceInstaller {
  private readonly themeType: string;

  private readonly themeInfo: ThemeInfo;

  constructor(themeType: string, themeInfo: ThemeInfo) {
    this.themeType = themeType;
    this.themeInfo = themeInfo;
  }

  abstract install(): Promise<boolean>;

  /**
   * 是否是资源增量覆盖模式，默认是
   *
   * @returns 增量覆盖模式
   */
  protected overlayMode(): boolean {
    return true;
  }

  /**
   * 是否需要保留套系化管理数据
   *
   * @returns 默认true
   */
  protected keepCustom(): boolean {
    return true;
  }

  protected async prepareCommonResource(): Promise<boolean> {
    let copySrcRet: boolean = false;
    if (this.overlayMode()) {
      copySrcRet = await this.copyThemeOriginalResource();
    }
    const copyCustomRet: boolean = await this.copyCustomResource();
    return copySrcRet || copyCustomRet;
  }

  /**
   * 拷贝主题原始包资源
   *
   * @returns 是否拷贝
   */
  private async copyThemeOriginalResource(): Promise<boolean> {
    let tPackagePath: NullableType<string> = this.themeInfo?.originThemePack?.srcPath;
    if (!tPackagePath || !FileUtil.isFileExists(tPackagePath)) {
      TsLog.warning(TAG, `unexpected path:not find theme origin resource id:${this.themeInfo.id},path:` + tPackagePath);
      return false;
    }
    if (ActivatedThemeUtil.isActivatedPath(tPackagePath)) {
      TsLog.info(TAG, `original theme pack from activated dir,${this.themeType}`);
      if (APP_THEME_TYPE_LIST.includes(this.themeType)) {
        tPackagePath = `${FileUtil.getParentPath(tPackagePath)}/app`
      }
    }
    let subThemePath: string = `${tPackagePath}${'/'}${this.themeType}`;
    if (FileUtil.isFileExists(subThemePath)) {
      return FileUtil.copyDirAsync(subThemePath, TSPathUtils.getTsPackagedPath());
    }
    if (ActivatedThemeUtil.isActivatedPath(tPackagePath) && this.themeType === 'skin') {
      subThemePath = `${FileUtil.getParentPath(tPackagePath)}/${this.themeType}`;
      if (FileUtil.isFileExists(subThemePath)) {
        return FileUtil.copyDirAsync(subThemePath, TSPathUtils.getTsPackagedPath());
      }
    }
    return false;
  }

  private async copyCustomResource(): Promise<boolean> {
    let copyRet: boolean = false;
    if (this.getThemeTypeCustomPath()) {
      if (this.keepCustom()) {
        copyRet = await FileUtil.copyDirAsync(`${this.getThemeTypeCustomPath()}`, TSPathUtils.getTsPackagedPath());
      } else {
        copyRet = await FileUtil.renameAsync(`${this.getThemeTypeCustomPath()}`,
          `${TSPathUtils.getTsPackagedPath()}/${this.themeType}`);
      }
      TsLog.info(TAG, `${'prepare custom resource:'}${copyRet}${' type-'}${this.getThemeType()}`);
    }
    return copyRet;
  }

  protected getThemeInfo(): ThemeInfo {
    return this.themeInfo;
  }

  public getThemeType(): string {
    return this.themeType;
  }

  /**
   * 获取资源安装的路径
   *
   * @returns 资源安装路径
   */
  protected getThemeTypePackagedPath(): string {
    let context: common.ApplicationContext = ContextUtil.getTsApplicationContext();
    context.area = contextConstant.AreaMode.EL1;
    let themeTmpPath: string = TSPathUtils.getTsPackagedPath();
    if (!StringUtils.isEmpty(this.themeType)) {
      themeTmpPath = `${themeTmpPath}${'/'}${this.themeType}`
    }
    return themeTmpPath;
  }

  /**
   * 获取当前主题资源类型的自定义资源
   *
   * @returns 自定义主题类型路径
   */
  protected getThemeTypeCustomPath(): NullableType<string> {
    let customThemeTypePath: NullableType<string> = undefined;
    const customPath: string = `${TSPathUtils.getThemeCustomPackagePath(this.getThemeInfo())}${'/'}${this.themeType}`;
    if (customPath && FileUtil.isFileExists(customPath)) {
      customThemeTypePath = customPath;
    }
    return customThemeTypePath;
  }
}

