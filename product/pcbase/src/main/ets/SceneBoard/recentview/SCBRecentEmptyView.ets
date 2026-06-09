/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { SCBRecentStyleConstants } from './SCBRecentStyleConstants';
import { StyleConstants } from '@ohos/launchercommon';

@Component
export struct SCBRecentEmptyView {
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text($r('app.string.No_running_apps_recently'))
        .fontColor(SCBRecentStyleConstants.DEFAULT_FONT_COLOR)
        .fontSize(SCBRecentStyleConstants.DEFAULT_FONT_SIZE)
    }
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
  }
}

@Component
export struct SCBSplitRecentEmptyView {
  @StorageLink('systemLanguage') @Watch('onLanguageChange') language: string = '';
  @State text: Resource = $r('app.string.No_available_window');

  private onLanguageChange(): void {
    this.updateText();
  }

  private updateText(): void {
    this.text = $r('app.string.No_available_window');
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text(this.text)
        .fontColor(SCBRecentStyleConstants.DEFAULT_FONT_COLOR)
        .fontSize(SCBRecentStyleConstants.DEFAULT_FONT_SIZE)
    }
    .width(StyleConstants.PERCENTAGE_100)
    .height(StyleConstants.PERCENTAGE_100)
  }
}