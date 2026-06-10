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

import { FileUtil, TsLog } from '@ohos/themeservicebase';
import { Constants } from '@ohos/themeservice_inner_api';

const TAG: string = 'SubThemeUtil';

const checkFileNames: string[] = [
  'description.json',
  'lock/manifest.json',
  'home/manifest.json',
  'aod/manifest.json',
  'long_take/manifest.json',
  'i18n/base.json',
  'personalize/params.json',
  'preview/base/cover.jpg'
];

const checkDirNames: string[] = ['lock', 'home', 'aod', 'long_take', 'i18n', 'personalize', 'preview'];

export class SubThemeUtil {
  /**
   * 检查主题包
   * @param path  主题包路径
   */
  static async checkThemePackage(editorId: string, path: string): Promise<void> {
    try {
      if (path === '' || !FileUtil.isFileExists(path)) {
        TsLog.warning(TAG, `file path is null.`);
        return;
      }
      for (let checkFileName of checkFileNames) {
        let isExists = FileUtil.isFileExists(path + '/' + checkFileName);
        TsLog.info(TAG, `${checkFileName} of ${editorId} exists result: ${isExists}`);
      }
      if (FileUtil.isFileExists(path + '/description.json')) {
        let description: object = JSON.parse(FileUtil.getStringByFile(path + '/description.json'));
        TsLog.info(TAG, `originId of ${editorId} result: ${description[Constants.ID_PREFIX]}`);
      }
      for (let checkDirName of checkDirNames) {
        if (!FileUtil.isFileExists(path + '/' + checkDirName)) {
          TsLog.info(TAG, `file count in ${checkDirName} of ${editorId} not exists`);
          continue;
        }
        let files: string[] = await FileUtil.listFileNames(path + '/' + checkDirName, true);
        TsLog.info(TAG, `file count in ${checkDirName} of ${editorId} result: ${files.length}`);
      }
    } catch (e) {
      TsLog.error(TAG, `check theme package of ${editorId} failed.`);
    }
  }
}