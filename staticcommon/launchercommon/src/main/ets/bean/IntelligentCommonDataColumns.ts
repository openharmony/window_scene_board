/**
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

export default class IntelligentCommonDataColumns {
  public static readonly MODULE_NAME: string = 'module_name';
  public static readonly KEY_NAME: string = 'key_name';
  public static readonly VALUE: string = 'value';
  // 预留拓展字段
  public static readonly EXTRA_DATA: string = 'extra_data';
}

export enum IntelligentCommonDataEnums {
  MODULE_NAME = 'module_name',
  KEY_NAME = 'key_name',
  VALUE = 'value',
  // 预留拓展字段
  EXTRA_DATA = 'extra_data'
}