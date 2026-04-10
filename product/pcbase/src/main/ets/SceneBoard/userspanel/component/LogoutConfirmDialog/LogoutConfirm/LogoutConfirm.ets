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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { Constants } from '../../../common/Constants';
import { UserButton } from '../../UserButton/UserButton';
import { UserList } from '../../UserList/UserList';
import { LogoutConfirmVM } from './LogoutConfirmViewModel';

const TAG = 'UserPanel-LogoutConfirm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@CustomDialog
@Component
export struct ConfirmBuilder {
  controller?:CustomDialogController;
  @Link dlgHeight: number;
  @Link vm: LogoutConfirmVM;

  aboutToAppear(): void {
    log.showInfo('ConfirmBuilder aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo('ConfirmBuilder aboutToDisappear');
  }

  build() {
    LogoutConfirm({
      vm: this.vm,
      dlgHeight: this.dlgHeight
    })
  }
}

@Component
export struct LogoutConfirm {
  @Prop vm: LogoutConfirmVM;
  @Link dlgHeight: number;

  aboutToAppear(): void {
    log.showInfo('LogoutConfirm aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo('LogoutConfirm aboutToDisappear');
  }

  @Builder
  TitleBuilder() {
    Row() {
      Text(this.vm.title)
        .textStyle()
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .lineHeight(27)
    }
    .justifyContent(FlexAlign.Center)
    .size({ width: '100%' })
    .padding({
      top: 0,
      bottom: 16,
    })
  }

  @Builder
  ContentBuilder() {
    Row() {
      Text(this.vm.content)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .lineHeight(21)
        .constraintSize({ maxWidth: 352 })
        .textAlign(TextAlign.JUSTIFY)
    }
    .justifyContent(this.vm.contentAlignment)
    .size({ width: '100%' })
    .padding({
      top: 8,
      bottom: 8,
    })
  }

  @Builder
  UserListBuilder() {
    UserList({ list: this.vm.userList })
  }

  @Builder
  ButtonGroupBuilder() {
    Row() {
      UserButton({ vm: this.vm.cancelBtn })
      UserButton({ vm: this.vm.confirmBtn })
      .visibility(this.vm.isVirtualMachineUpdating ? Visibility.Hidden : Visibility.Visible)
    }
    .size({ width: 368 })
    .padding({ top: 16 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Column() {
      this.TitleBuilder()
      this.ContentBuilder()
      this.UserListBuilder()
      this.ButtonGroupBuilder()
    }
    .size({ width: 400 })
    .borderRadius(16)
    .padding({
      top: 16,
      right: 24,
      bottom: 16,
      left: 24,
    })
    .backgroundColor($r('sys.color.mask_fourth'))
    .backgroundBlurStyle(BlurStyle.COMPONENT_ULTRA_THICK)
    .onAreaChange((oldValue: Area, newValue: Area) => {
      let newHeight = newValue.height as number;
      if (this.dlgHeight !== newHeight) {
        log.showInfo(`dlgHeight: ${this.dlgHeight}, newValue: ${newHeight}`);
        this.dlgHeight = newHeight;
      }
    })
  }
}

@Extend(Text)
function textStyle() {
  .draggable(false)
  .fontColor($r('sys.color.font_primary'))
}

@CustomDialog
@Component
export struct PowerOffConfirmBuilder {
  @Prop vm: LogoutConfirmVM;
  controller?:CustomDialogController
  @State dlgHeight: number = Constants.DIALOG_MAX_HEIGHT;
  build() {
    LogoutConfirm({vm: this.vm, dlgHeight: this.dlgHeight})
  }
}

export * from './LogoutConfirmViewModel';