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
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { UserSwitchService } from '@ohos/screenlockcommon';
import { LauncherCardInfo } from '../../bean/LauncherCardInfo';
import { ExposeEventRecorder } from '../../donate/ExposeEventRecorder';
import { AiSuggestionFormManager } from '../../manager/AiSuggestionFormManager';

import { BaseCommand } from '../BaseCommand';
import { CommandConsumer } from '../CommandConsumer';

const TAG = 'UpdateFormsCommand';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 更新卡片
 *
 * @since 2024-02-04
 */
export class UpdateFormsCommand extends BaseCommand {
  constructor(commandId: string) {
    super();
    this.commandId = commandId;
    this.commandType = AiSuggestionUpdateConstants.CommandType.UPDATE_CARD;
  }

  execute(): void {
    if (!UserSwitchService.getInstance().isCurrentUserActive) {
      log.showWarn('currentUserId is not ForegroundUserId');
      return;
    }
    if (!this.data) {
      log.showWarn('data is undefined');
      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType, this.operateCardId);
      return;
    }
    let launcherCardInfo: LauncherCardInfo = this.data as LauncherCardInfo;
    log.showError('commandId: %{public}s, cardId: %{public}s is execute', this.commandId, this.operateCardId);
    if (LauncherCardInfo.isCardInfoInValid(LauncherCardInfo.getDisplayCardInfo(launcherCardInfo),
      launcherCardInfo.portfolioInfo?.agentInfo)) {
      CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType, this.operateCardId);
      log.showError(`update card cardId=${this.operateCardId} occur error, launcherCardInfo data is invalid`);
      return;
    }

    // need to change one input param
    AiSuggestionFormManager.getInstance().updateCardInfo(launcherCardInfo.operateFormId, launcherCardInfo);
    ExposeEventRecorder.getInstance().recordExposeOnRefresh(launcherCardInfo.operateFormId);
    CommandConsumer.getInstance().finishCommand(this.commandId, this.commandType, this.operateCardId);
  }
}