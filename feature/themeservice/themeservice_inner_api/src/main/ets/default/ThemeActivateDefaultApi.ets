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

import { TsLog } from '@ohos/themeservicebase';

import { ThemeActivateApi } from '../api/ThemeActivateApi';
import { ThemeCode } from '../constant/ThemeCode';
import { OriginType } from '../constant/TSTypes';
import { TConfigArg } from '../model/TConfigArg';
import { ThemeOptions } from '../model/ThemeOptions';
import { WallPaperInfo } from '../model/WallPaper';
import { EditThemeArg } from '../model/EditThemeArg';

const TAG: string = 'ThemeActivateDefaultApi';

export class ThemeActivateDefaultApi implements ThemeActivateApi {
  activateEditedTheme(editorId: string, option?: ThemeOptions | undefined): Promise<boolean> {
    TsLog.warning(TAG, 'Method[activateEditedTheme] not implemented.');
    return Promise.resolve(false);
  }

  activateThemeCustom(path: string, customThemePkgPath?: string | undefined,
    option?: ThemeOptions | undefined): Promise<boolean> {
    TsLog.warning(TAG, 'Method[activateThemeCustom] not implemented.');
    return Promise.resolve(false);
  }

  saveThemeCustom(path: string, custom?: string, isUsable: boolean = true): Promise<string> {
    TsLog.warning(TAG, 'Method[saveThemeCustom] not implemented.');
    return Promise.resolve('');
  }

  editTheme(editArg: EditThemeArg): Promise<boolean> {
    TsLog.warning(TAG, 'Method[activateThemeCustom] not implemented.');
    return Promise.resolve(false);
  }

  setWallPaper(wallPapers: WallPaperInfo[]): Promise<boolean> {
    TsLog.warning(TAG, 'Method[setWallPaper] not implemented.');
    return Promise.resolve(false);
  }

  applyIcons(path: string): Promise<boolean> {
    TsLog.warning(TAG, 'Method[applyIcons] not implemented.');
    return Promise.resolve(false);
  }

  applyFont(id: string, ttf: string, originType: OriginType, ttfExt?: string[],
    multiWeight?: boolean): Promise<number> {
    TsLog.warning(TAG, 'Method[applyFont] not implemented.');
    return Promise.resolve(ThemeCode.ERROR_UNSUPPORT_SERVICE);
  }

  setSkin(skinPath: string, pkgNames: string[]): Promise<boolean> {
    TsLog.warning(TAG, 'Method[skinPath] not implemented.');
    return Promise.resolve(false);
  }

  applyCustomConfig(tConfigArgs: TConfigArg[], activated?: boolean | undefined): Promise<boolean> {
    TsLog.warning(TAG, 'Method not implemented.');
    return Promise.resolve(false);
  }

  activateTheme(path: string, option?: ThemeOptions | undefined): Promise<boolean> {
    TsLog.warning(TAG, 'Method[activateTheme] not implemented.');
    return Promise.resolve(false);
  }

  activateDefaultTheme(): Promise<boolean> {
    TsLog.warning(TAG, 'Method[activateDefaultTheme] not implemented.');
    return Promise.resolve(false);
  }

  activateDefaultFont(): Promise<boolean> {
    TsLog.warning(TAG, 'Method[activateDefaultFont] not implemented.');
    return Promise.resolve(false);
  }

  activateThemeStyle(contentType: string[], style: string): Promise<boolean> {
    TsLog.warning(TAG, 'Method[activateThemeStyle] not implemented.');
    return Promise.resolve(false);
  }
}