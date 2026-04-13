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
 * emergency thermal scene
 */
export class HiSysEventNameData {
  // emergency enter
  public static readonly EMERGENCY_ENTER: string = 'EMERGENCY_ENTER';

  // emergency exit
  public static readonly EMERGENCY_EXIT: string = 'EMERGENCY_EXIT';

  // emergency save app
  public static readonly EMERGENCY_SAVE: string = 'EMERGENCY_SAVE';

  // emergency exit manual
  public static readonly EMERGENCY_EXIT_MANUAL: string = 'EMERGENCY_EXIT_MANUAL';

  // emergency click add
  public static readonly EMERGENCY_CLICK_ADD: string = 'EMERGENCY_CLICK_ADD';

  // emergency click app
  public static readonly EMERGENCY_CLICK_APP: string = 'EMERGENCY_CLICK_APP';

  // thermal enter
  public static readonly THERMAL_ENTER: string = 'THERMAL_ENTER';

  // thermal exit
  public static readonly THERMAL_EXIT: string = 'THERMAL_EXIT';

  // thermal click app
  public static readonly THERMAL_CLICK_APP: string = 'THERMAL_CLICK_APP';
}

export class HiSysDomain {
  // emergency
  public static readonly EMERGENCY_UE: string = 'EMERGENCY_UE';
  // thermal
  public static readonly THERMAL_UE: string = 'THERMAL_UE';
}