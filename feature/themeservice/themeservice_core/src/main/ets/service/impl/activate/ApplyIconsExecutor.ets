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

import { ORIGIN_PRESET, ThemeInfo, ThemeOptions } from '@ohos/themeservice_inner_api';
import { FileUtil, JsonUtils, TsLog } from '@ohos/themeservicebase';
import { TSPathUtils } from '../../../util/TSPathUtils';
import { ThemePackageInstaller } from './installer/ThemePackgeInstaller';
import { BusinessError } from '@kit.BasicServicesKit';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';

const TAG: string = 'ApplyIconsExecutor';

export class ApplyIconsExecutor {
  private readonly themeInfo: ThemeInfo;

  constructor(themeInfo: ThemeInfo) {
    this.themeInfo = themeInfo;
  }

  async applyIcons(iconResource: string): Promise<boolean> {
    TsLog.info(TAG, `Apply icon`);
    let iconCustomPath: string = `${TSPathUtils.getThemeCustomPackagePath(this.themeInfo)}/icons`;
    await FileUtil.rmdirAsync(iconCustomPath);
    if (!await FileUtil.copyDirAsync(`${iconResource}/icons/` ?? '', iconCustomPath)) {
      TsLog.warning(TAG, `Apply icon copy fail:${iconResource}`);
      const error: BusinessError<string> = { name: `error`, message: `apply icon copy failed`, code: RemoteCode.ERR_COPY_FAILED };
      return Promise.reject(error);
    }
    await FileUtil.copyFileAsync(`${iconResource}/manifest.json`, `${iconCustomPath}/manifest.json`);
    let iconId: string = '';
    try {
      const descriptionFile: string = `${iconCustomPath}/description.json`;
      await FileUtil.deleteAsync(descriptionFile);
      const manifestContent: string = await FileUtil.readFileContent(`${iconResource}/manifest.json`);
      const manifest: object = JSON.parse(manifestContent);
      iconId = manifest['id'];
      let emitArg: Record<string, string> = {
        'id': iconId,
        'origin': ORIGIN_PRESET
      }
      FileUtil.writeFileSync(descriptionFile, JsonUtils.stringify(emitArg));
    } catch (err) {
      TsLog.warning(TAG, 'read icon manifest fail', err);
    }
    const ret: number = await new ThemePackageInstaller(this.themeInfo)
      .activateThemeOpt(new ThemeOptions().enableIcons());
    TsLog.info(TAG, `Apply icon ret:${ret}`);
    if (ret !== RemoteCode.SUCCESS) {
      TsLog.error(TAG, `apply icons failed`);
      const error: BusinessError<string> = { name: `error`, message: `apply icons failed`, code: ret };
      return Promise.reject(error);
    }
    return true;
  }
}