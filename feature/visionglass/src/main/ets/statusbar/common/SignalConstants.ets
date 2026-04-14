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

export enum SignalCardSituation {
  SINGLE_SIM_0 = 0,
  SINGLE_SIM_1 = 1,
  DOUBLE_SIM_1 = 2,
  NONE_SIM = 3,
  SKY_TONE_U_SINGLE_SIM_0 = 4,
  SKY_TONE_U_SINGLE_SIM_1 = 5,
  SKY_TONE_U_NONE_SIM = 6,
  SKY_TONE_U_DOUBLE_SIM_1 = 7,
}

export enum SimID {
  SINGLE_SIM_0 = 0,
  SINGLE_SIM_1 = 1,
  SKY_TONE = 2
}