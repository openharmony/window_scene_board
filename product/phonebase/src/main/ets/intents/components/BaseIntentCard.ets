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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import BaseIntentCardInfo from '../beans/BaseIntentCardInfo';
import { common, ConfigurationConstant } from '@kit.AbilityKit';

const TAG: string = 'BaseIntentCard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export default struct BaseIntentCard {
  private cardInfo?: BaseIntentCardInfo = undefined;
  @BuilderParam cardContent: () => void = this.cardContentBuilder;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear, cardInfo = ${JSON.stringify(this)}');
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Column() {
      this.cardTitleBuilder();
      this.cardContent();
    }
    .width('100%')
    .height('100%')
    .alignItems(HorizontalAlign.Start)
    .backgroundColor(Color.Transparent)
  }

  @Builder
  cardTitleBuilder() {
    Row() {
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .margin({ top: 10 })
    .padding({ left: 12, right: 12 })
  }

  @Builder
  cardContentBuilder() {}
}