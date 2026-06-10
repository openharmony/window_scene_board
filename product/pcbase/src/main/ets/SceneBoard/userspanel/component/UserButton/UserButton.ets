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
import { UserTextBuilder } from '../UserText/UserText';
import { UserButtonStyle, UserButtonVM } from './UserButtonViewModel';

const TAG = 'UserPanel-UserButton';

/**
 * 自定义 Button 组件
 * @since 2024-07-25
 */
@Component
export struct UserButton {
  @ObjectLink vm: UserButtonVM;

  @Builder
  TextBuilder() {
    Text(this.vm.text)
      .font(this.vm.textStyle)
      .fontColor(this.vm.textStyle?.color)
  }

  build() {
    if (this.vm) {
      Button() {
        UserTextBuilder(this.vm.text, this.vm.textStyle)
      }
      .userButtonStyle(this.vm.style)
      .id(this.vm.id)
      .type(this.vm.type)
      .enabled(this.vm.enabled)
      .focusable(this.vm.focusAble)
      .defaultFocus(this.vm.defaultFocus)
      .onClick((event: ClickEvent) => {
        this.vm.onClick?.(event);
      })
    }
  }
}

@Extend(Button)
function userButtonStyle(style: UserButtonStyle) {
  .hitTestBehavior(HitTestMode.Block)
  .type(ButtonType.Normal)
  .size(style.size)
  .constraintSize(style.constraintSize)
  .padding(style.padding)
  .borderRadius(style.borderRadius)
  .backgroundColor(style.backgroundColor)
}

export * from './UserButtonViewModel';