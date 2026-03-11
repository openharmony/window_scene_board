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

@Entry
@Component
struct SceneBoard_2_4_Card {
  /*
   * The width percentage setting.
   */
  readonly FULL_WIDTH_PERCENT: string = '100%';
  /*
   * The height percentage setting.
   */
  readonly FULL_HEIGHT_PERCENT: string = '100%';

  build() {
    Row() {
      Column() {
        Image($r('app.media.default_form_card'))
          .width($r('app.float.desktop_default_card_image_size'))
          .height($r('app.float.desktop_default_card_image_size'))
      }.alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .width(this.FULL_WIDTH_PERCENT)
    }.height(this.FULL_HEIGHT_PERCENT)
  }
}