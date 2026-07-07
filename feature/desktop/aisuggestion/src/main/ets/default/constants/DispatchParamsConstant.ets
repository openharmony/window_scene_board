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
 * 发送消息固定常量
 *
 * @since 2023-08-11
 */
export const enum DispatchParamsConstant {
  /** 消息会话-消息名称 */
  MESSAGE_NAME = 'NotifyUserActionByLauncher',

  /** 消息会话-发送模块名称 */
  SENDER_NAME = 'com.ohos.sceneboard',

  /** 消息会话-接收模块名称 */
  SERVICE_NAME = 'AiDispatch',

  /** 消息会话-消息版本号 */
  MESSAGE_VERSION = '1.0.0',

  /** 消息头-命名空间 */
  NAME_SPACE = 'Event',

  /** 载荷-卡片ID */
  FORM_ID = 'formId',

  /** 载荷-服务ID */
  SERVICE_ID = 'serviceId',

  /** 载荷-推荐ID */
  REC_ID = 'recId',

  /** 载荷-推荐子ID */
  SUB_REC_ID = 'subRecId',

  /** 载荷-母卡片尺寸 */
  CARD_DIMENSION = 'cardDimension',

  /** 载荷-场景ID */
  PORTFOLIO_ID = 'portfolioId',

  /** 载荷-场景名称 */
  PORTFOLIO_NAME = 'portfolioName',

  /** 载荷-堆叠ID */
  STACK_ID = 'stackId',

  /** 小折叠外屏 */
  SCREEN_TYPE = 'screenType',
}

/**
 * 不感兴趣菜单选项
 *
 * @since 2025-01-11
 */
export const enum DislikeOption {
  ADD_BLACKLIST = 0,

  LOWER_FREQUENCY = 1,
}