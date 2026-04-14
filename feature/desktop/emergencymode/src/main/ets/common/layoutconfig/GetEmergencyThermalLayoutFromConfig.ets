/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  FileUtils
} from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import util from '@ohos.util';
import type ctx from '@ohos.app.ability.common';
import { ConfigParseUtil } from '@ohos/launchercommon/src/main/ets/TsIndex';
import DefaultEmergencyThermalLayoutInfo from '../bean/DefaultEmergencyThermalLayoutInfo';

const TAG = 'GetEmergencyThermalLayoutFromConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Load the configuration file to obtain the layout data.
 */
export class GetEmergencyThermalLayoutFromConfig {
  private static mInstance: GetEmergencyThermalLayoutFromConfig;

  static getInstance(): GetEmergencyThermalLayoutFromConfig {
    if (GetEmergencyThermalLayoutFromConfig.mInstance == null) {
      GetEmergencyThermalLayoutFromConfig.mInstance = new GetEmergencyThermalLayoutFromConfig();
    }
    return GetEmergencyThermalLayoutFromConfig.mInstance;
  }

  private constructor() {
  }

  /**
   * Obtaining Layout Information from the Configuration File
   *
   * @returns Layout Information
   */
  public async getLayoutFromConfigFile(fileUrl: string, defaultFileName: string):
    Promise<DefaultEmergencyThermalLayoutInfo> {
    log.info('initLayoutFromConfigFile -> start.' + fileUrl);
    let cfgFile: string = '';
    let cfgJson: DefaultEmergencyThermalLayoutInfo;
    try {
      cfgFile = await ConfigParseUtil.getConfig(fileUrl);
    } catch (error) {
      log.error('configPolicy.getCfgFiles error', error);
    }
    if (CheckEmptyUtils.isEmpty(cfgFile)) {
      log.showWarn('getAllLayoutConfigFile -> cfgFiles is empty.');
      cfgJson = await this.getLayoutJsonByDefaultFile(defaultFileName);
    } else {
      log.showInfo('Succeeded in obtaining the CCM layout configuration file.');
      cfgJson = FileUtils.readJsonFile(cfgFile);
    }
    log.showInfo('init:' + JSON.stringify(cfgJson));
    return cfgJson;
  }

  private async getLayoutJsonByDefaultFile(fileName: string): Promise<DefaultEmergencyThermalLayoutInfo> {
    let defaultConfigJson: DefaultEmergencyThermalLayoutInfo = { appsInfo: [] };
    try {
      await (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).resourceManager
        .getRawFileContent(fileName).then(value => {
          let textDecoder = new util.TextDecoder('utf-8', { ignoreBOM: true });
          const configFromFile = textDecoder.decodeWithStream(value, { stream: false });
          if (!CheckEmptyUtils.isEmpty(configFromFile)) {
            defaultConfigJson = JSON.parse(configFromFile);
          } else {
            log.showInfo(`get defaultFile null`);
          }
          return defaultConfigJson;
        }).catch((error: Error) => {
          log.showError('getRawFileContent promise error is ' + error);
        });
    } catch (error) {
      log.showError(`promise getRawFileContent failed, error code: ${error.code}, message: ${error.message}.`);
    }
    return defaultConfigJson;
  }
}