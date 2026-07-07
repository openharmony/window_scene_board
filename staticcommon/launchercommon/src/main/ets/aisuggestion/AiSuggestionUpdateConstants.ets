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
 * 语音助手建议卡片刷新相关的场景
 *
 * @since 2024-02-27
 */
declare namespace AiSuggestionUpdateConstants {
  /**
   * 卡片分组刷新类型
   *
   * @since 2024-02-06
   */
  export const enum GroupType {
    /** 更新卡片 */
    REFRESH_FORMS = 0,

    /** 操作堆叠组 */
    OPERATE_STACKS = 1,

    /** 创建堆叠组 */
    CREATE_STACKS = 2,
  }

  /**
   * 卡片类型
   *
   * @since 2024-02-20
   */
  export const enum CardType {
    /** 常驻卡(常规卡、独立卡:有场景ID)，需要用户主动删除 */
    DEFAULT = 0,

    /** 暂态卡，场景退场后可自动删除 */
    TEMP = 1,
  }

  /**
   * 卡片刷新类型
   *
   * @since 2024-02-06
   */
  export const enum OptType {
    /** 更新卡片 */
    UPDATE_CARD = 0,

    /** 添加卡片 */
    ADD_CARD = 1,

    /** 删除卡片 */
    DELETE_CARD = 2,

    /** 更新且轮转 */
    UPDATE_AND_SWITCH = 3,

    /** 添加且轮转 */
    ADD_AND_SWITCH = 4,

    /** 轮转卡片 */
    SWITCH_CARD = 5,
  }

  /**
   * 命令类型
   *
   * @since 2024-02-06
   */
  export const enum CommandType {
    /** 更新卡片 */
    UPDATE_CARD = 0,

    /** 创建堆叠 */
    CREATE_FORM_STACK = 1,

    /** 添加卡片到堆叠 */
    ADD_CARD_TO_STACK = 2,

    /** 删除堆叠中的卡片中 */
    DELETE_CARD_FROM_STACK = 3,

    /** 轮转置顶卡片 */
    SWITCH_CARD_TO_TOP = 4,

    /** 创建堆叠后轮转卡片 */
    SWITCH_CARD_TO_TOP_AFTER_CREATE_STACK = 5,

    /** 添加卡片到堆叠后,触发卡片轮转 */
    SWITCH_CARD_TO_TOP_AFTER_ADD_CARD_TO_STACK = 6,
  }
}

export default AiSuggestionUpdateConstants;