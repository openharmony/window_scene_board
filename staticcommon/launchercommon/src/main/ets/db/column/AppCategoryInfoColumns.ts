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
 * AppCategoryInfo Columns
 */
export default class AppCategoryInfoColumns {
  public static readonly ID: string = '_id';
  public static readonly BUNDLE_NAME: string = 'bundle_name';
  public static readonly SECONDARY_CATEGORY_ID: string = 'secondary_category_id';
}

export enum AppCategoryInfoEnums {
  ID = '_id',
  BUNDLE_NAME = 'bundle_name',
  SECONDARY_CATEGORY_ID = 'secondary_category_id'
}