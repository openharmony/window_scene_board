/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { FormBackboardVm } from '../viewmodel/FormItemRelativeVm';

const TAG = 'FormBackboard';

@Component
export default struct FormBackboard {
  private mFormBackWidth: number = 0;
  private mFormBackHeight: number = 0;

  @Prop mFormBorderRadius: number = 0;
  @Link mFormBackVm: FormBackboardVm;

  build() {
    Column() {
    }
    .id(`${TAG}_Column_backboard`)
    .alignRules({
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      top: { anchor: '__container__', align: VerticalAlign.Top },
    })
    .width(this.mFormBackWidth)
    .height(this.mFormBackHeight)
    .borderRadius(this.mFormBorderRadius + this.mFormBackVm.mFormBackboardRadius)
    .backgroundBlurStyle(BlurStyle.Thin, { policy: 1 }, { disableSystemAdaptation: true })
    .scale({ x: this.mFormBackVm.mFormBackboardScale, y: this.mFormBackVm.mFormBackboardScale })
  }
}