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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AiSuggestionEventReporter } from '../../donate/AiSuggestionEventReporter';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';

const TAG = 'HandleDialogClick';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

export class DialogClickInfo {
  public windowName: string = '';

  public formId: string = '';
}

/**
 * 语音助手建议对话框取消点击操作
 *
 * @since 2024-01-10
 */
export class HandleDialogClick implements IExecutor {
  async execute(extra?: object): Promise<string> {
    let clickInfo = extra as DialogClickInfo;
    log.showInfo('windowName:%{public}s, formId:%{public}s', clickInfo?.windowName, clickInfo?.formId);
    if (clickInfo?.windowName === 'REMOVE_WINDOW') {
      AiSuggestionEventReporter.getInstance().reportSuggestionFormDelete(clickInfo?.formId, true);
    }
    return Response.SUCCESS_OK;
  }
}