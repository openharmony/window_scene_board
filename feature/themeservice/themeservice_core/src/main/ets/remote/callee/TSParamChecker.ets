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

import { checkNonNull, checkNumber, checkPath } from '@ohos/themeservicebase/Index';
import { EditThemeArg } from '@ohos/themeservice_inner_api';
import { PathValidateUtil } from '../../validate/PathValidateUtil';

/**
 * 参数校验器
 */
export namespace TSParamChecker {
  /**
   * 路径校验
   * @throws Error.code:RemoteCode.ERR_PARAM
   */
  export const path: (path: string) => Promise<string> =
    async (path) => checkPath(await PathValidateUtil.getDefaultTrustPathList())(path);

  /**
   * 试用时长[0,15分钟]
   * @throws Error.code:RemoteCode.ERR_PARAM
   */
  export const trialDuration: (duration: number) => number =
    (duration) => checkNumber(0, 15 * 60 * 1000)(duration);

  /**
   * 限制免费时长[0,3个月]
   * @throws Error.code:RemoteCode.ERR_PARAM
   */
  export const limitedFreeDuration: (duration: number) => number =
    (duration) => checkNumber(0, 3 * 30 * 24 * 60 * 60 * 1000)(duration);

  /**
   * 编辑主题参数校验
   */
  export const editThemeArg: (editArgs: EditThemeArg) => Promise<EditThemeArg> = async (editArgs) => {
    checkNonNull(editArgs?.editorId);
    if (editArgs.customPath != undefined) {
      checkPath(await PathValidateUtil.getDefaultTrustPathList())(editArgs.customPath);
    }
    return editArgs;
  };
}
