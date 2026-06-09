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
 * Badge Columns
 */
export class BadgeColumns {
  static readonly ID: string = '_id';
  static readonly USER_ID: string = 'user_id';
  static readonly BUNDLE_NAME: string = 'bundle_name';
  static readonly BADGE_NUMBER: string = 'badge_number';
  static readonly IS_SHOW: string = 'is_show';
  static readonly APP_INDEX: string = 'app_index';
  static readonly FIXED: string = 'fixed';
}

export enum BadgeEnums {
  ID = '_id',
  USER_ID = 'user_id',
  BUNDLE_NAME = 'bundle_name',
  BADGE_NUMBER = 'badge_number',
  IS_SHOW = 'is_show',
  APP_INDEX = 'app_index',
  FIXED = 'fixed'
}