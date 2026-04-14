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

/**
 * 通知设置相关异常错误码 4700 - 4799
 */
export enum SettingExceptionCode {
  SET_NTF_SWITCH_FAIL = 4700,
  GET_NTF_SWITCH_FAIL = 4701,
  SUBSCRIBE_SLOT_CHANGE_FAIL = 4702,
  SET_PIN_TOP_STATE_FAIL = 4703,
  GET_DISTRIBUTION_STATE_FAIL = 4704,
  SET_DISTRIBUTION_STATE_FAIL = 4705,
  GET_LIVE_VIEW_DISTRIBUTION_STATE_FAIL = 4706,
  SET_LIVE_VIEW_DISTRIBUTION_STATE_FAIL = 4707,
  GET_FIRST_DISTRIBUTION_STATE_FAIL = 4708,
  SET_SILENCE_STATE_FAIL = 4709,
  GET_SILENCE_STATE_FAIL = 4710,
  GET_SEARCH_RESULT_FAIL = 4711,
}