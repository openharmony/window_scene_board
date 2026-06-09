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

export class Constants {
  public static readonly TRANSFORM_SCENE_INDEX: number = 6000;
  public static readonly DEFAULT_DURATION: number = 300;
  public static readonly DEFAULT_DELAY: number = 3000;
  public static readonly LONG_DELAY: number = 5000;
  public static readonly SHORT_DURATION: number = 200;
  public static readonly LONG_DURATION: number = 500;
  public static readonly THOUSAND: number = 1000;
  public static readonly ULTRA_SHORT_DURATION: number = 50;
  public static readonly MINIMUM_PAN_DISTANCE = 5;
  public static readonly INVALID_ID: number = -1;
  public static readonly Z_INDEX_1: number = 1;
  public static readonly Z_INDEX_2: number = 2;
  public static readonly Z_INDEX_3: number = 3;
  public static readonly Z_INDEX_4: number = 4;
  public static readonly TWICE: number = 2;
  public static readonly MASK_COLOR: string = '#80000000';
  public static readonly SCENE_BORDER_RADIOS = 10;
}

export type BaseDataType = number | boolean | string | undefined | null;
