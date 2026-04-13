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

import { UpgradeApi, VersionInfo } from '@ohos/themeservice_inner_api/Index';
import { JsonUtils, StringUtils, TsLog } from '@ohos/themeservicebase/Index';
import { TsConfig } from '../../cache/TsConfig';
import { deviceInfo } from '@kit.BasicServicesKit';

const TAG: string = 'UpgradeApiImpl';

/**
 * app version upgrade service
 */
export class UpgradeApiImpl implements UpgradeApi {
  async init(doUpgrade: (from: number, to: number) => Promise<void>): Promise<void> {
    const lastVersion: number = await TsConfig.get().getLastVersion();
    const currentVersion: number = TsConfig.TS_DATA_VER;
    TsLog.info(TAG, `init lastVersion:${lastVersion}, currentVersion:${currentVersion}`);
    if (lastVersion === currentVersion) {
      TsLog.info(TAG, 'no version code change, do nothing');
      return Promise.resolve();
    }
    try {
      await doUpgrade(lastVersion, currentVersion);
    } catch (err) {
      TsLog.error(TAG, `init catch exception. code:${err.code}, message:${err.message}`)
    }
    return TsConfig.get().setLastVersion(currentVersion);
  }

  async initOS(doUpgrade: (from?: VersionInfo, to?: VersionInfo) => Promise<void>): Promise<void> {
    const lastOSVersion: string = await TsConfig.get().getLastOSVersion();
    let lastVerInfo: VersionInfo | undefined = undefined;
    if (!StringUtils.isEmpty(lastOSVersion)) {
      lastVerInfo = JsonUtils.parse(lastOSVersion);
    }
    let majorVersion: number = deviceInfo.majorVersion;
    let seniorVersion: number = deviceInfo.seniorVersion;
    let featureVersion: number = deviceInfo.featureVersion;
    let buildVersion: number = deviceInfo.buildVersion;
    const newInfo = new VersionInfo(majorVersion, seniorVersion, featureVersion, buildVersion);

    try {
      await doUpgrade(lastVerInfo, newInfo);
    } catch (err) {
      TsLog.error(TAG, `init catch exception. code:${err.code}, message:${err.message}`)
    }
    if (newInfo.equals(lastVerInfo)) {
      TsLog.info(TAG, 'no version code change');
      return Promise.resolve();
    }
    const currentOSVersion = JsonUtils.stringify(newInfo);
    if (currentOSVersion) {
      return TsConfig.get().setLastOSVersion(currentOSVersion);
    }
    TsLog.warning(TAG, 'newInfo is undefined');
    return Promise.resolve();
  }
}