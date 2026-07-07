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

import DateTime from '../../common/utils/DateTime';
import { GlassStatusBarStyle } from './GlassStatusBarStyle';

/**
 * Time
 */
@Component
export default struct TimeIcon {
  @State mDateTime: DateTime = new DateTime();
  @Consume contentColor: string;

  aboutToAppear(): void {
    this.mDateTime.init(getContext(this));
  }

  aboutToDisappear(): void {
    this.mDateTime.release();
  }

  build() {
    Text(this.mDateTime.clockTime)
      .fontSize(GlassStatusBarStyle.FONT_SIZE_24)
      .fontWeight(FontWeight.Bold)
      .fontColor(this.contentColor)
      .fontFamily('OpenHarmony Sans SC')
  }
}