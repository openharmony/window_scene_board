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
import SwitchIntentCardInfo from '../beans/SwitchIntentCardInfo';
import BaseIntentCard from './BaseIntentCard';

const TAG: string = 'SwitchIntentCard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export default struct SwitchIntentCard {
  private cardInfo?: SwitchIntentCardInfo = undefined;

  aboutToAppear(): void {
    log.showInfo(`cardInfo = ${JSON.stringify(this.cardInfo)}`);
  }

  build() {
    BaseIntentCard({ cardInfo: this.cardInfo }) {
      this.contentBuilder();
    }
  }

  @Builder
  contentBuilder() {
    Row() {
      Text(this.cardInfo?.switchTitle)
        .fontWeight(FontWeight.Medium)
        .fontSize($r('sys.float.ohos_id_text_size_body1'))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .width('85%');
      Row() {
        Toggle({
          type: this.cardInfo?.switchType,
          isOn: this.cardInfo?.isOn
        })
        .switchStyle({
          unselectedColor: $r('sys.color.ohos_id_color_component_normal')
        })
        .width(36)
        .height(20)
        .onChange(this.cardInfo?.onChange)
      }
      .width(48)
      .height(48)
      .justifyContent(FlexAlign.Center)
    }
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .margin({top: 12})
    .padding({ left: 12, right: 12 })
    .justifyContent(FlexAlign.SpaceBetween)
  }
}