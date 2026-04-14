/**
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

export default class IntelligentDiscoveryInfoColumns {
  public static readonly PARENT_ID: string = 'parent_id';
  public static readonly SERVICE_ID: string = 'service_id';
  public static readonly SERVICE_NAME: string = 'service_name';
  public static readonly ICON_URL: string = 'icon_url';
  public static readonly ABILITY_JUMP_URL: string = 'ability_jump_url';
  public static readonly CANDIDATE_JUMP_URL: string = 'candidate_jump_url';
  public static readonly PRIORITY: string = 'priority';
  public static readonly SUBTITLE_NAME: string = 'subtitle_name';
  public static readonly SUBTITLE_START_TIME: string = 'subtitle_start_time';
  public static readonly SUBTITLE_END_TIME: string = 'subtitle_end_time';
  public static readonly SHOW_TOAST: string = 'show_toast';
  public static readonly TOAST_INFO: string = 'toast_info';
}

export enum IntelligentDiscoveryInfoEnums {
  PARENT_ID = 'parent_id',
  SERVICE_ID = 'service_id',
  SERVICE_NAME = 'service_name',
  ICON_URL = 'icon_url',
  ABILITY_JUMP_URL = 'ability_jump_url',
  CANDIDATE_JUMP_URL = 'candidate_jump_url',
  PRIORITY = 'priority',
  SUBTITLE_NAME = 'subtitle_name',
  SUBTITLE_START_TIME = 'subtitle_start_time',
  SUBTITLE_END_TIME = 'subtitle_end_time',
  SHOW_TOAST = 'show_toast',
  TOAST_INFO = 'toast_info'
}