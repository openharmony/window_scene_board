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
 * 实况相关错误码 4800 - 4899
 */
export enum LiveExceptionCode {
  UNLOCK_FAIL = 4800,
  DATA_MANNER_LIVE_ERROR = 4801,
  CAPSULE_LIST_LIVE_ERROR = 4802,
  LOCAL_LIVE_STACK_INFO = 4803,
  ROTATE_BLOCK = 4804,
  WEATHER_TEMPERATURE_RANGE_INVALID = 4805, //天气温度范围取值非法
  WEATHER_HIGH_TEMPERATURE_LOWER_THAN_LOW_TEMPERATURE_INVALID = 4806, //天气高温低于低温非法
  WEATHER_TYPE_INVALID = 4807, //天气类型非法
}