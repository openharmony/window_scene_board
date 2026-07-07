/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { AIBarClickBackgroundData } from '../AIBarModel/AIBarClickBackgroundData';
import { SCBAiBarConstants } from '../SCBAiBarConstants'

@Component
export default struct AIBarClickBackground {
  @State mItemData: AIBarClickBackgroundData = AIBarClickBackgroundData.getInstance();

  build() {
    Column()
      .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
      .opacity(this.mItemData.aiBarBackgroundOpacity)
      .width(this.mItemData.aiBarBackgroundWidth)
      .height(SCBAiBarConstants.AI_BAR_BACKGROUND_DEFAULT_HEIGHT)
      .borderRadius(SCBAiBarConstants.AI_BAR_BACKGROUND_DEFAULT_HEIGHT / 2)
      .margin({ bottom: this.mItemData.aiBarBackgroundBottomDistance })
  }
}