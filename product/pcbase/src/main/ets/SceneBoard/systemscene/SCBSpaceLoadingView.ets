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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG: string = 'SCBSpaceLoadingView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

@Component
export struct SCBSpaceLoadingView {
  @Prop isVisible: boolean = true;

  @Builder
  IconBuilder() {
    Stack() {
      Image($r('app.media.person_bg'))
        .draggable(false)
        .syncLoad(true)
        .size({ width: 160, height: 160 })

      SymbolGlyph($r('sys.symbol.person'))
        .draggable(false)
        .fontColor([$r('sys.color.background_emphasize')])
        .fontSize('56vp') // 不跟随字体缩放
        .backgroundColor(Color.Transparent)
    }
    .size({ width: 112, height: 112 })
    .borderRadius(56)
    .alignContent(Alignment.Center)
  }

  @Builder
  ContentBuilder() {
    Flex({
      direction: FlexDirection.Column,
      justifyContent: FlexAlign.Center,
      alignItems: ItemAlign.Center
    }) {
      this.IconBuilder()

      Text($r('app.string.personal_space'))
        .fontColor($r('sys.color.font_primary'))
        .fontSize($r('sys.float.Subtitle_M'))
        .fontWeight(FontWeight.Medium)
        .lineHeight(27)
        .margin({ top: 24 })

      Text($r('app.string.loading'))
        .fontColor($r('sys.color.font_secondary'))
        .fontSize($r('sys.float.Body_L'))
        .fontWeight(FontWeight.Regular)
        .lineHeight(21)
        .margin({ top: 8 })
    }
    .size({ width: '100%', height: '100%' })
  }

  build() {
    Stack() {
      Image($r('app.media.oobe_bg_img'))
        .draggable(false)
        .syncLoad(true)
        .size({ width: '100%', height: '100%' })

      Stack() {
        this.ContentBuilder()
      }
      .size({ width: 680, height: 864 })
      .align(Alignment.Center)
      .borderColor('#80FFFFFF')
      .borderRadius(16)
      .borderWidth(1)
      .borderStyle(BorderStyle.Solid)
      .backdropBlur(500)
      .shadow(ShadowStyle.OUTER_FLOATING_SM)
      .backgroundColor('#4DFFFFFF')
    }
    .size({ width: '100%', height: '100%' })
    .align(Alignment.Center)
    .visibility(this.isVisible ? Visibility.Visible : Visibility.None)
  }

  aboutToAppear(): void {
    log.info('aboutToAppear');
  }

  aboutToDisappear(): void {
    log.info('aboutToDisappear');
  }
}