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

import { NumberConstants } from '@ohos/commonconstants';
import { StyleConstants } from '../TsIndex';

const TAG = 'AddIconComponent';

@Component
export struct AddIconComponent {
  @State appIconSize: number = NumberConstants.CONSTANT_NUMBER_ZERO;
  @Link isGeometryTransiting: boolean;
  private geometryId: string = '';

  build() {
    Column() {
      Column()
        .width('100%')
        .height('72%')
        .opacity(0.5)
        .borderRadius(10)
        .backgroundColor(Color.White)
        .id(`${TAG}_Column_lastAddIcon`)
    }
    .opacity(StyleConstants.DEFAULT_FOLDER_HIDDEN_VALUE)
    .transition(TransitionEffect.opacity(StyleConstants.DEFAULT_FOLDER_HIDDEN_VALUE))
    .geometryTransition(this.isGeometryTransiting ? this.geometryId : '')
    .alignItems(HorizontalAlign.Start)
    .width(this.appIconSize * 0.8)
    .height(this.appIconSize * 0.8 * StyleConstants.FOLDER_ICON_HEIGHT_FACTOR)
  }
}