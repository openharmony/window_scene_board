/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import configPolicy from '@ohos.configPolicy';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { util } from '@kit.ArkTS';

const TAG = 'ConfigParseUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class ConfigParseUtil {

  public static async getConfig(configFile: string): Promise<string> {
    return new Promise<string>((resolve) => {
      try {
        configPolicy.getOneCfgFile(configFile).then(filePath => {
          log.showInfo(`loadCcmConfigs filePath=${filePath}`);
          resolve(filePath);
        });
      } catch (error) {
        log.error('getConfig error', error);
      }
    });
  }

  public static getConfigSync(configFile: string): string {
    let res = '';
    try {
      res = configPolicy.getOneCfgFileSync(configFile);
    } catch (error) {
      log.showError('getConfigSync error %{public}s', error.message);
    }
    return res;
  }

  /**
   * 获取所有配置文件
   *
   * @param configFile 文件的相对路径
   * @returns 从飞马路径下按照优先级从低到高返回符合条件的文件全路径信息（根路径+相关路径）
   */
  public static async getAllConfig(configFile: string): Promise<Array<string>> {
    return await configPolicy.getCfgFiles(configFile);
  }

  /**
   * 同步获取rawfile文件内容
   *
   * @param rawfile文件的名称
   * @returns 读取后的文件字符串
   */
  public static getRawFileContentSync(fileName: string): string | undefined {
    let rawFileContent: string | undefined;
    try {
      let uint8Array: Uint8Array = GlobalContext.getContext().resourceManager.getRawFileContentSync(fileName);
      rawFileContent = new util.TextDecoder().decodeWithStream(uint8Array);
    } catch (error) {
      log.showError('getRawFileContent failed, %{public}s', error.message);
    }
    return rawFileContent;
  }

  /**
   * 获取interface token
   *
   * @param serviceType 服务类型
   * @returns interface
   */
  public static getInterfaceToken(serviceType: number): string {
    const tokenContent: string | undefined = ConfigParseUtil.getRawFileContentSync('InterfaceToken.json');
    if (!tokenContent) {
      log.showError('getJsonFileContent is null');
      return '';
    }
    let res: Record<string, string> = {};
    try {
      res = JSON.parse(tokenContent) as Record<string, string>;
    } catch (error) {
      log.showError('get interface token json, parse json error, %{public}s', error.message);
      return '';
    }
    switch (serviceType) {
      case ServiceType.APP_FOUNDATION:
        return res.agInterfaceToken;
      default:
        return '';
    }
  }
}

export enum ServiceType {
  APP_FOUNDATION /** call ag service token **/
}