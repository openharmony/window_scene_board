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

import { CardResourceInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/CardResourceInfo';

/**
 * 语音助手建议卡片分身chip组件
 *
 * @since 2024-06-21
 */

@Component
export struct ChipItem {
  @Prop private cardResourceInfo: CardResourceInfo;
  @Prop private title: string = '';
  @Prop private isOuterDesktop: boolean = false;
  chipsClick?: () => void;

  build() {
    Button(this.title)
      .type(ButtonType.Capsule)
      .buttonStyle(ButtonStyleMode.NORMAL)
      .controlSize(ControlSize.SMALL)
      .backgroundColor(this.cardResourceInfo?.chipBgStartClr)
      .fontColor(this.cardResourceInfo?.chipTextClr)
      .fontWeight(FontWeight.Regular)
      .height(this.isOuterDesktop ? 18 : 28)
      .fontSize('12vp')
      .hitTestBehavior(HitTestMode.Block)
      .onClick(this.chipsClick);
  }
}