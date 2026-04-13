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

export enum IntentType {
  GET_SETTING_SWITCH = 'GetSettingSwitch',
  SET_SETTING_SWITCH = 'SetSettingSwitch',
  LOAD_SETTING_CARD = 'LoadSettingCard',
  CHECK_SETTING_PAGE = 'CheckSettingPage',
  CHECK_SETTING_ITEM = 'CheckSettingItem',
}

export class IntentItemConstants {
  public static readonly PIP_SWITCH = 'PIP_SWITCH';
  public static readonly MULTI_DOCK_SWITCH = 'MULTI_DOCK_SWITCH';
  public static readonly FLASH_LIGHT_OPEN = 'OpenFlashlight';
  public static readonly FLASH_LIGHT_CLOSE = 'CloseFlashlight';
}

export class IntentCodeConstants {
  public static readonly DEFAULT_CODE_SUCCESS = 0; /* Execution succeeded. */
  public static readonly DEFAULT_CODE_FAILED = 10010001; /* Execution failed. */
  public static readonly DEFAULT_CODE_UNSUPPORTED = 10011003; /* Function not supported */
}

export const INTENT_CODE: Record<number, string> = {
  0: '执行成功',
  10010001: '执行失败',
  10011003: '设备不支持',
}