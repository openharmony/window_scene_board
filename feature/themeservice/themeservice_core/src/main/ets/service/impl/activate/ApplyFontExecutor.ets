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
import {
  OriginType,
  TARGET_FONT,
  ThemeCode,
  ThemeInfo,
  ThemeOptions
} from '@ohos/themeservice_inner_api';
import { FileUtil, JsonUtils, StringUtils, TsLog } from '@ohos/themeservicebase/Index';
import { TSPathUtils } from '../../../util/TSPathUtils';
import { FontInfo } from '../../model/FontInfo';
import { ThemePackageInstaller } from './installer/ThemePackgeInstaller';
import { PresetThemeExtCache } from '../../../cache/PresetThemeCache';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = `ApplyFontExecutor`;

export class ApplyFontExecutor {
  private readonly themeInfo: ThemeInfo;

  constructor(themeInfo: ThemeInfo) {
    this.themeInfo = themeInfo;
  }

  /**
   * 应用字体，包括设置个性化字体应用与试用字体回退
   *
   * @param id 字体id
   * @param ttf 字体文件路径
   * @param origin 来源
   * @param ttfExt 字体ttf文件路径数组
   * @param multiWeight 是否可调节字重
   * @returns 应用结果
   */
  async applyFont(id: string, ttf: string, origin: OriginType, ttfExt?: string[],
    multiWeight?: boolean): Promise<number> {
    TsLog.info(TAG, `apply font`);
    const fontCustomRootPath: string = `${TSPathUtils.getThemeCustomPackagePath(this.themeInfo)}/${TARGET_FONT}`;
    await FileUtil.rmdirAsync(fontCustomRootPath);
    const fontInfo: FontInfo = await this.getFontInfo(id, ttf, origin, ttfExt, multiWeight);
    const manifestFile: string = `${fontCustomRootPath}/manifest.json`;
    const descriptionFile: string = `${fontCustomRootPath}/description.json`;
    if (FileUtil.isFileExists(ttf)) {
      const originalManifest: string = `${FileUtil.getParentPath(ttf)}/manifest.json`;
      const copyResult: boolean = await FileUtil.copyFileAsync(originalManifest, manifestFile);
      TsLog.info(TAG, `applyFont originalManifest copyResult:${copyResult}`);
    } else {
      TsLog.error(TAG, `applyFont ttf is invalid path`);
    }
    FileUtil.writeFileSync(manifestFile, JsonUtils.stringify(fontInfo));
    let emitArg: Record<string, OriginType | string> = {
      'id': id,
      'origin': origin
    }
    FileUtil.writeFileSync(descriptionFile, JsonUtils.stringify(emitArg));
    const fontCustomPath: string = `${fontCustomRootPath}/${FileUtil.getFileName(ttf)}`;
    const copyResult: boolean = await FileUtil.copyFileAsync(ttf, fontCustomPath);
    if (!copyResult) {
      TsLog.warning(TAG, `applyFont fail, copy ttf:${ttf} fail`);
      const error: BusinessError<string> =
        { name: `error`, message: `applyFont fail, copy ttf:${ttf} fail`, code: RemoteCode.ERR_COPY_FAILED };
      return Promise.reject(error);
    }
    if (!await this.copyTtfExtFile(fontCustomRootPath, ttfExt)) {
      TsLog.warning(TAG, `copyTtfExtFile failed`);
      const error: BusinessError<string> =
        { name: `error`, message: `copyTtfExtFile failed`, code: RemoteCode.ERR_COPY_FAILED };
      return Promise.reject(error);
    }
    const ret: number = await new ThemePackageInstaller(this.themeInfo)
      .activateThemeOpt(new ThemeOptions().enableFont());
    TsLog.info(TAG, `applyFont ret:${ret}`);
    if (ret !== RemoteCode.SUCCESS) {
      const error: BusinessError<string> = { name: `error`, message: `applyFont failed`, code: ret };
      return Promise.reject(error);
    }
    return ThemeCode.SUCCESS;
  }

  private async copyTtfExtFile(fontCustomRootPath: string, ttfExt?: string[]): Promise<boolean> {
    if (!ttfExt || ttfExt.length === 0) {
      return true;
    }
    let ttfExtCopyResult: boolean = true;
    for (let ttfPath of ttfExt) {
      const fileName: string = FileUtil.getFileName(ttfPath);
      if (fileName?.endsWith('.ttf')) {
        const fontFilePath: string = `${fontCustomRootPath}/${fileName}`;
        const copyResult: boolean = await FileUtil.copyFileAsync(ttfPath, fontFilePath);
        if (!copyResult) {
          TsLog.error(TAG, `copyTtfExt copy ${fileName} fail`);
          ttfExtCopyResult = false;
          return ttfExtCopyResult;
        }
      } else {
        TsLog.warning(TAG, `copyTtfExt invalid file name ${fileName}`);
      }
    }
    return ttfExtCopyResult;
  }

  private async getFontInfo(id: string, ttf: string, origin: OriginType, ttfExt?: string[],
    ttfMultiWeight: boolean = true): Promise<FontInfo> {
    const presetFonts: FontInfo[] = await PresetThemeExtCache.getInstance().getPresetFonts();
    const fontInfo: FontInfo = {
      id: id,
      origin: origin,
      src: FileUtil.getFileName(ttf),
      srcExt: TSPathUtils.getFontNameExt(ttf, ttfExt),
      ttfFileSrc: ttf,
      ttfFileSrcExt: ttfExt,
      multiWeight: ttfMultiWeight
    }
    for (let font of presetFonts) {
      if (StringUtils.equals(font?.id, id)) {
        return font;
      }
    }
    return fontInfo;
  }
}
