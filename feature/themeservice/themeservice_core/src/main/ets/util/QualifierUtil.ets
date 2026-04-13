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
import fs from '@ohos.file.fs';
import { FileUtil, StringUtils, TsLog } from '@ohos/themeservicebase';
import { Constants, Qualifier, QualifierContent } from '@ohos/themeservice_inner_api';

const TAG: string = 'QualifierUtil';

export namespace QualifierUtil {
  export async function getQualifierNameByPath(dir: string): Promise<string[]> {
    if (!FileUtil.isDir(dir)) {
      return [];
    }
    let fileNames: string[] = [];
    try {
      fileNames = await fs.listFile(dir, { recursion: false });
    } catch (error) {
      TsLog.error(TAG, 'getQualifierNameByPath', error);
    }
    return fileNames.filter(fileName => FileUtil.isDir(`${dir}/${fileName}`));
  }

  export async function getQualifierFile(dir: string, cfgName: string): Promise<QualifierContent<string>> {
    TsLog.info(TAG, 'getQualifierFile');
    let qualifier: QualifierContent<string> = new Map<Qualifier, string>();
    let qualifierNames: string[] = await getQualifierNameByPath(dir);
    for (const qualifierName of qualifierNames) {
      let path: string = StringUtils.join(Constants.FILE_SEPARATOR, [dir, qualifierName, cfgName]);
      let value: string = await FileUtil.readFileContent(path);
      if (!StringUtils.isEmpty(value)) {
        qualifier.set(qualifierName, value);
      }
    }
    return qualifier;
  }
}