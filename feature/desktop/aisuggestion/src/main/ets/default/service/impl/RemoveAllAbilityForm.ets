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

import type { IExecutor } from '@ohos/launchercommon';
import { FormModel } from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ExposeEventRecorder } from '../../donate/ExposeEventRecorder';
import { AiSuggestionFormManager } from '../../manager/AiSuggestionFormManager';
import { RemoveFormInfo } from '../entity/RemoveFormInfo';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';

const TAG = 'RemoveAllAbilityForm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 删除所有语音助手建议卡片
 *
 * @since 2025-2-21
 */
export class RemoveAllAbilityForm implements IExecutor {
  async execute(extra?: object): Promise<string> {
    const formInfos = extra as RemoveFormInfo[];
    if (CheckEmptyUtils.isEmptyArr(formInfos)) {
      log.showWarn('formInfos is empty');
      return Response.FAIL;
    }
    for (const formInfo of formInfos) {
      let formId: string | undefined = formInfo?.formId;
      if (!formId) {
        log.showWarn('formId is invalid');
        continue;
      }

      //  1、移除母卡片
      AiSuggestionFormManager.getInstance().deleteCardInfo(formId);

      // 2、结束卡片曝光：可以考虑在UI语音助手建议卡片组件卸载处统一调用该方法
      ExposeEventRecorder.getInstance().recordExposeEndByFormId(formId);

      // 3、删除数据库数据
      await FormModel.getInstance().deleteFormByIdAsync(formId, false, false);
    }
    return Response.SUCCESS_OK;
  }
}