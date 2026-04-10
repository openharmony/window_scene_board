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

import { LengthMetrics } from '@ohos.arkui.node';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { Avatar } from '../Avatar/Avatar';
import { UserButton } from '../UserButton/UserButton';
import { UserTextBuilder } from '../UserText/UserText';
import { UserItemModifier, UserItemVM } from './UserListViewModel';

const TAG = 'UserPanel-UserList';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 用户列表组件
 * @since 2024-07-25
 */
@Component
export struct UserList {
  @Prop list: UserItemVM[];

  build() {
    Row() {
      Column() {
        ForEach(this.list, (item: UserItemVM) => {
          UserItem({ vm: item })
        }, (item: UserItemVM) => item.account.localId.toString())
      }
      .width('100%')
    }
    .width('100%')
  }
}

/**
 * 用户单元组件
 * @since 2024-07-24
 */
@Component
struct UserItem {
  tag: string = 'UserItem:';
  @ObjectLink vm: UserItemVM;
  @State modifier: UserItemModifier = new UserItemModifier();

  handleClick(): void {
    this.vm.onClick?.(this.vm);
  }

  handleHover(isHover: boolean): void {
    this.vm.onHover?.(isHover, this.vm);
  }

  aboutToDisappear(): void {
    this.vm.onClick = () => {};
  }

  @Builder
  avatarBuilder() {
    Column() {
      Avatar({ vm: this.vm.avatar })
    }
    .padding({ start: LengthMetrics.vp(4), end: LengthMetrics.vp(12) })
  }

  @Builder
  infoBuilder() {
    Column() {
      UserTextBuilder(this.vm.text, this.vm.textStyle)
      Blank(2)
      UserTextBuilder(this.vm.subText, this.vm.subTextStyle)
    }
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Center)
    .flexBasis('auto')
    .flexGrow(1)
    .flexShrink(1)
  }

  @Builder
  buttonBuilder() {
    UserButton({ vm: this.vm.button })
  }

  build() {
    Row() {
      this.avatarBuilder()
      this.infoBuilder()
      this.buttonBuilder()
    }
    .attributeModifier(this.modifier)
    .width('100%')
    .constraintSize({ minHeight: this.vm.style?.height})
    .padding(this.vm.style?.padding)
    .margin(this.vm.style?.margin)
    .borderRadius(8)
    .alignItems(VerticalAlign.Center)
    .focusBox({
      margin: LengthMetrics.vp(-1)
    })
    .onClick((ev: ClickEvent) => {
      this.handleClick();
    })
    .onHover((isHover: boolean, ev: HoverEvent) => {
      if (this.vm.enableHoverEffect) {
        this.modifier.isHover = isHover;
      }
      this.handleHover(isHover);
    })
  }
}

export * from './UserListViewModel';