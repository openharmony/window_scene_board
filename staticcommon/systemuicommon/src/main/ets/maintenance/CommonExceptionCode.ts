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
 * 通用错误码 4000 - 4199
 */
export enum CommonExceptionCode {
  INIT_TABLE_FAIL = 4000,
  GET_PIN_TOP_FAIL = 4001,
  SET_PIN_TOP_FAIL = 4002,
  GET_HIDDEN_BANNER_FAIL = 4003,
  SET_HIDDEN_BANNER_FAIL = 4004,
  PUBLIC_CONFIG_CHANGE_FAIL = 4005,
  TRIGGER_CHANGE_FAIL = 4006,
  SUBSCRIBE_COMMON_FAIL = 4007,
  PARSE_JSON_FAIL = 4008,
  ACCESS_SEND_FAIL = 4009,
  ACCESS_SEND_RESOURCE = 4010,
  REQUEST_FOCUS_FAIL = 4011,
  CREATE_DATA_SHARE_FAIL = 4012,
  SET_WEAK_FAIL = 4013,
  INIT_APP_PROTECTED_FAIL = 4014,
  BACK_UP_FAIL = 4015,
  GET_HAPTIC_FAIL = 4016,
  START_PUSH_AGENT_FAIL = 4017,
  SET_SILENCE_FAIL = 4018,
  GET_SILENCE_FAIL = 4019
}