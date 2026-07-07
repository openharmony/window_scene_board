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
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { ExposeEventRecorder } from '../../donate/ExposeEventRecorder';
import { AiSuggestionFormManager } from '../../manager/AiSuggestionFormManager';
import type { LauncherCardInfo } from '../../bean/LauncherCardInfo';
import { CommandConsumer } from '../../command/CommandConsumer';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';

const TAG: string = 'ResetAiSuggestionForms';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 重置母卡片
 *
 * 1、桌面监听应用清除数据（清除语音助手建议数据时调用） TODO
 * 2、语音助手建议主动停止服务（语音助手建议调用）
 *
 * @since 2023-08-11
 */
export class ResetAiSuggestionForms implements IExecutor {
  async execute(extra?: object): Promise<string> {
    log.showInfo('execute');
    CommandConsumer.getInstance().clearCacheCommands();

    // 找所有母卡进行重置操作
    let formsInfo: Map<string, LauncherCardInfo> = AiSuggestionFormManager.getInstance().getAllCardInfoCache();
    if (!formsInfo || formsInfo.size === 0) {
      log.showWarn('no cache voice cards info');
      return Response.FAIL;
    }

    // 1、清空内容，展示引导卡片
    // 2、结束卡片曝光
    formsInfo.forEach((value: LauncherCardInfo, cardId: string) => {
      AiSuggestionFormManager.getInstance().resetCard(cardId);
      ExposeEventRecorder.getInstance().recordExposeEndByFormId(cardId);
    });
    return Response.SUCCESS_OK;
  }
}