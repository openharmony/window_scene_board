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

import { FormModel, RdbStoreManager } from '@ohos/launchercommon';
import AiSuggestionUpdateConstants from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUpdateConstants';
import { UserSwitchService } from '@ohos/screenlockcommon';

/**
 * 命令的有效期 5s
 */
const EXPIRATION_DATE: number = 5000;
/**
 * 刷新命令
 *
 * @since 2024-02-04
 */
export abstract class BaseCommand {
  /**
   * 取值范围： 操作堆叠组时 = stackId， 操作卡片时 = 卡片id， 创建堆叠时 = 卡片id
   */
  public commandId: string = '';

  public commandType: number = 0;

  public operateCardId: string = '';

  public data?: object;

  public delayTime: number = 0;

  public executeTime: number = 0;

  abstract execute(): void;

  public isOperateFormStack(): boolean {
    return this.commandType === AiSuggestionUpdateConstants.CommandType.CREATE_FORM_STACK ||
      this.commandType === AiSuggestionUpdateConstants.CommandType.ADD_CARD_TO_STACK ||
      this.commandType === AiSuggestionUpdateConstants.CommandType.DELETE_CARD_FROM_STACK ||
      this.commandType === AiSuggestionUpdateConstants.CommandType.SWITCH_CARD_TO_TOP;
  }

  public isExpired(): boolean {
    if (this.executeTime === 0) {
      return false;
    }
    return Math.abs(Date.now() - this.executeTime) >= EXPIRATION_DATE;
  }

  toString(): string {
    return `[id: ${this.commandId}, type: ${this.commandType}, cardId: ${this.operateCardId}]`;
  };

  toStringWithExecuteTime(): string {
    return `[id: ${this.commandId}, type: ${this.commandType}, cardId: ${this.operateCardId}, executeTime: ${this.executeTime}]`;
  };

  protected canExecute(cardId: string, cardIds: string[]): boolean {
    // 超出桌面卡片限制
    if (FormModel.getInstance().checkIfCardExceedLimit()) {
      return false;
    }

    if (!UserSwitchService.getInstance().isCurrentUserActive) {
      return false;
    }
    if (RdbStoreManager.getInstance().isDisableInsert()) {
      // 系统迁移，桌面数据库正在升级过程中，不能往数据库插入数据
      return false;
    }

    return true;
  }
}