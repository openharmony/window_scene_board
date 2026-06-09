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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { util } from '@kit.ArkTS';
import { resourceManager } from '@kit.LocalizationKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'FileUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * file util class.
 *
 * @since 2024-05-23
 */
export default class FileUtil {
  private static readonly UNICODE = 'utf-8';

  /**
   * Asynchronously obtaining content by raw file name
   */
  public static getStringByFileAsync(resourceManager: resourceManager.ResourceManager | undefined, fileName: string):
    Promise<string> {
    return new Promise((resolve, reject) => {
      log.showInfo(`getFileContent. fileName: ${fileName}`);
      if (!resourceManager || !fileName) {
        log.showError(`getFileContent failed. resourceManager or fileName is null. fileName:${fileName}`);
        reject();
        return;
      }
      try {
        resourceManager.getRawFileContent(fileName).then((value) => {
          let content = util.TextDecoder.create(FileUtil.UNICODE).decodeWithStream(value);
          resolve(content);
        }).catch((err: BusinessError) => {
          log.showError(`getFileContent of ${fileName} failed. ${err?.code} ${err?.message}`);
          reject(err);
        });
      } catch (error) {
        log.showError(`JSON file read error:${error?.code} ${error?.message}`);
        reject();
      }
    });
  }
}