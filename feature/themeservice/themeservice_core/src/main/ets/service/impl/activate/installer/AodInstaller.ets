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
import { FileUtil, NullableType, TsLog } from '@ohos/themeservicebase/Index';
import { AodExtensionResInstaller } from './extension/AodExtensionResInstaller';
import { ResourceBasicInstaller } from './ResourceBasicInstaller';

const TAG: string = `AodInstaller`;

export class AodInstaller extends ResourceBasicInstaller {
  constructor(themeInfo: ThemeInfo) {
    super('aod', themeInfo);
  }

  async install(): Promise<boolean> {
    const copyRet: boolean = await super.install();
    this.addExtendResource();
    return copyRet;
  }

  public overlayMode(): boolean {
    return !this.hasCustomAod();
  }

  private hasCustomAod(): boolean {
    let customAodPath: NullableType<string> = this.getThemeTypeCustomPath();
    if (!customAodPath) {
      return false;
    }
    return FileUtil.isFileExists(`${customAodPath}/manifest.json`);
  }

  public async installExtension(style: string): Promise<boolean> {
    if (!this.hasExtensionRes()) {
      TsLog.info(TAG, `${this.getThemeType()} not has extension`);
      return false;
    }
    let extensionInstaller: AodExtensionResInstaller = new AodExtensionResInstaller('aod', this.getThemeInfo());
    return extensionInstaller.install(style);
  }
}
