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

import { ThemeInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, TsLog } from '@ohos/themeservicebase';
import { TSPathUtils } from '../../../../util/TSPathUtils';
import { AbsResourceInstaller } from './AbsResourceInstaller';

const TAG: string = 'ExtResourceInstaller';

export class ExtResourceInstaller extends AbsResourceInstaller {
  constructor(resourceType: string, themeInfo: ThemeInfo) {
    super(resourceType, themeInfo);
  }

  async install(): Promise<boolean> {
    const activatedTheme: ThemeInfo = this.getThemeInfo();
    const extThemeType: string = this.getThemeType();
    const extSrcThemeTypePath: string = `${activatedTheme.originThemePack?.srcPath}/${extThemeType}`;
    let copyRet: boolean = false;
    if (FileUtil.isDir(extSrcThemeTypePath)) {
      copyRet = await super.prepareCommonResource();
    } else {
      const copyTarget: string = `${TSPathUtils.getTsPackagedPath()}${'/'}${extThemeType}`;
      if (this.getThemeTypeCustomPath()) {
        copyRet = FileUtil.copyFileSync(`${this.getThemeTypeCustomPath()}`, copyTarget);
      } else {
        copyRet = FileUtil.copyFileSync(extSrcThemeTypePath, copyTarget);
      }
    }
    if (copyRet) {
      TsLog.info(TAG, `install: ${extThemeType}`);
    }
    return copyRet;
  }
}

