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

/**
 * 语音助手建议事件名称
 *
 * @since 2025-05-27
 */
export class AiSuggestionEventName {
  public static UPDATE_CARD: string = 'UPDATE_CARD';
  public static DELETE_CARD: string = 'DELETE_CARD';
  public static RESET_CARD: string = 'RESET_CARD';

  /**
   * 更新卡片事件名称
   *
   * @param cardId 卡片id
   * @returns 更新卡片事件名称
   */
  static getUpdateCardEventName(cardId: string): string {
    return `${AiSuggestionEventName.UPDATE_CARD}_${cardId}`;
  }

  /**
   * 删除卡片事件名称
   *
   * @param cardId 卡片id
   * @returns 更新卡片事件名称
   */
  static getDeleteCardEventName(cardId: string): string {
    return `${AiSuggestionEventName.DELETE_CARD}_${cardId}`;
  }

  /**
   * 重置卡片事件名称
   *
   * @param cardId 卡片id
   * @returns 更新卡片事件名称
   */
  static getResetCardEventName(cardId: string): string {
    return `${AiSuggestionEventName.RESET_CARD}_${cardId}`;
  }
}