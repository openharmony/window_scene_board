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
import { NAVIBarClickBackgroundData } from '../NAVIBarModel/NAVIBarClickBackgroundData';
import { SCBNaviBarConstants } from '../SCBNaviBarConstants'

@Component
export default struct NAVIBarClickBackground {
  @State mItemData: NAVIBarClickBackgroundData = NAVIBarClickBackgroundData.getInstance();

  build() {
    Column()
      .backgroundColor($r('sys.color.ohos_id_color_click_effect'))
      .opacity(this.mItemData.naviBarBackgroundOpacity)
      .width(this.mItemData.naviBarBackgroundWidth)
      .height(SCBNaviBarConstants.NAVI_BAR_BACKGROUND_DEFAULT_HEIGHT)
      .borderRadius(SCBNaviBarConstants.NAVI_BAR_BACKGROUND_DEFAULT_HEIGHT / 2)
      .margin({ bottom: this.mItemData.naviBarBackgroundBottomDistance })
  }
}