/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

export class FormStackStyleConstants {
  public static readonly FORM_STACK_CARD_MIN_NUM = 2;

  public static readonly FORM_STACK_CARD_MAX_NUM = 10;

  public static readonly OUTER_FORM_STACK_CARD_MAX_NUM = 4;

  public static readonly BOTTOM_CARD_ZOOM_RATIO = 0.95;

  public static readonly CARD_BORDER_RADIUS_RATIO = 0.9;

  public static readonly CARD_BORDER_RADIUS_ADDED = 1;

  public static readonly BOTTOM_CARD_OFFSET = 6;

  public static readonly FORM_STACK_MASK_OFFSET = 3;

  // formstack wiper switch card speed threshold: px/s
  public static readonly SLIDE_NEXT_PAGE_VELOCITY_THRESHOLD = 1500;

  // formstack swiper switch card distance ratio
  public static readonly slideRatioMap = new Map<number, number>([
    [FormDimension.Dimension_1_2, 0.5],
    [FormDimension.Dimension_2_2, 0.25],
    [FormDimension.Dimension_2_4, 0.25],
    [FormDimension.Dimension_4_4, 0.15],
  ]);
}