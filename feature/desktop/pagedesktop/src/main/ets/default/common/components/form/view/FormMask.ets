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

import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG = 'FormMask';

@Component
export default struct FormMask {
  mFormMaskWidth: number = 0;
  mFormMaskHeight: number = 0;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext()?.config?.colorMode as number ?? 0;
  @Prop mFormBorderRadius: number = 0;
  @Prop mDropAnimateScale: number = 1;
  @Prop mDropAnimateTranslateY: number = 0;
  @Prop mFormMaskOpacity: number = 1;

  build() {
    Column() {
    }
    .id(`${TAG}_Column_formMask`)
    .alignRules({
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      top: { anchor: '__container__', align: VerticalAlign.Top },
    })
    .width(this.mFormMaskWidth)
    .height(this.mFormMaskHeight)
    .borderRadius(this.mFormBorderRadius)
    .opacity(this.mFormMaskOpacity)
    .scale({ x: this.mDropAnimateScale, y: this.mDropAnimateScale })
    .translate({ y: this.mDropAnimateTranslateY })
    .backgroundColor(this.currColorMode === 0 ? '#e67e7f80' : '#FFD7D8D9')
  }
}