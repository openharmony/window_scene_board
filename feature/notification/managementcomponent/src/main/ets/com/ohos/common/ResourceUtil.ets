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

import { LogDomain, LogHelper } from './BasicCommon';
import { ContextManager } from '../manager/ContextManager';

const TAG = 'ResourceUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class ResourceUtil {
  /**
   * 获取资源文本，依赖GlobalContext.getContext()的上下文，使用此方法时需要确认GlobalContext已经初始化
   *
   * @param res 资源
   * @param param 参数
   * @returns 资源文本或undefined
   */
  public static getStringSync(res: ResourceStr, ...param: (number | string) []): string | undefined {
    if (typeof res === 'string') {
      return res;
    }

    const rsMgr = ContextManager.getContext()?.resourceManager;
    if (rsMgr) {
      try {
        return rsMgr.getStringSync(res.id, ...param);
      } catch (err) {
        log.error(`GetStringSync error, param is : ${param}`, err);
        return undefined;
      }
    } else {
      log.showWarn('rsMgr is none.');
      return undefined;
    }
  }
}