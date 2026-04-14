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
 * CardInfo Columns
 */
export default class CardInfoColumns {
  public static readonly ID: string = '_id';
  public static readonly BUNDLE_NAME: string = 'bundle_name';
  public static readonly APP_NAME: string = 'app_name';
  public static readonly APP_INDEX: string = 'app_index';
  public static readonly CARDS: string = 'cards';
  public static readonly STATUS: string = 'status';
}

export enum CardInfoEnums {
  ID = '_id',
  BUNDLE_NAME = 'bundle_name',
  APP_NAME = 'app_name',
  APP_INDEX = 'app_index',
  CARDS = 'cards',
  STATUS = 'status'
}