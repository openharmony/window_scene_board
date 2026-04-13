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

import fileUri from '@ohos.file.fileuri';
import { ArrayUtils, TsLog } from '@ohos/themeservicebase/Index';
import { StringUtils } from '@ohos/themeservicebase/src/main/ets/utils/StringUtils';
import { TSPathUtils } from '../util/TSPathUtils';

const TAG: string = 'PathValidateUtil';

export class ThemePathValidateUtil {
  /**
   * 校验路径，默认白名单机制校验
   * @param path 传入路径
   * @returns 是否符合默认支持白名单路径
   */
  public static async validatePath(path?: string): Promise<boolean> {
    if (!path || StringUtils.isEmpty(path)) {
      return false;
    }
    const formatPath: string = ThemePathValidateUtil.formatPath(path);
    const trustList: string[] = await ThemePathValidateUtil.getDefaultTrustPathList();
    let trustRet: boolean = false;
    for (let trust of trustList) {
      if (formatPath.startsWith(trust)) {
        trustRet = true;
        break;
      }
    }
    return trustRet;
  }

  /**
   * 路径规范化
   * @param path 原始路径
   * @returns 规范化路径
   */
  public static formatPath(path: string): string {
    try {
      const uriPath: string = fileUri.getUriFromPath(path);
      const normalizePath: string = new fileUri.FileUri(uriPath).normalize().path;
      return normalizePath;
    } catch (error) {
      TsLog.error(TAG, `format path error`, error);
    }
    return path;
  }

  /**
   * 获取默认可信路径列表
   * @returns 可信主题文件路劲列表
   */
  public static async getDefaultTrustPathList(): Promise<string[]> {
    const trustPathList: string[] =
      ['/data/storage/', '/data/themes/a/', '/data/themes/b/', '/data/themes/s/', '/system/fonts/', '/data/ecust/system/'];
    const sysProdPathList: string[] = await TSPathUtils.getTsPresetRootPath();
    if (ArrayUtils.isNull(sysProdPathList)) {
      return trustPathList;
    }
    for (const sysProdPath of sysProdPathList) {
      if (sysProdPath.endsWith('/')) {
        trustPathList.push(sysProdPath);
      } else {
        trustPathList.push(`${sysProdPath}/`);
      }
    }
    return trustPathList;
  }
}

