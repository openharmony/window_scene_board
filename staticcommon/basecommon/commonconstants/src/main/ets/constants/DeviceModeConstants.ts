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
 * Current device mode, including base mode, EMC mode, thermal safe mode and thermal-EMC overlay mode.
 * State enumeration corresponds to the state class one by one.
 * About Extensible, more device modes are supported, the state class needs to be added synchronously.
 * THER_EMC_OVERLAY_MODE is a pseudo state for processing the overlapped state and downstream dependent module does not need to pay attention to it.
 */
export enum DeviceModeEnum {
  BASE_MODE = 0,
  EMERGENCY_MODE = 1,
  THERMAL_SAFE_MODE = 2,
  THER_EMC_OVERLAY_MODE = -1
};
