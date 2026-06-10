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

import { SingleContext } from '@ohos/basicutils';
import { StyleConstants } from '@ohos/launchercommon';
import { RemoveDialogConfig } from '@ohos/launchercommon/Index';
import { BatchUnInstallAppComponent } from '../BatchUnInstallAppComponent';

@CustomDialog
export struct BatchRemoveDialog {
  @Link @Watch('onRemoveDialogVisibilityChanged') isShowRemoveDialog: boolean;
  @State isAnimationEnd: boolean = false;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @Prop singleContext?: SingleContext;
  isUninstallApp: boolean = false;
  controller?: CustomDialogController;
  cancel?: Function;
  confirm?: Function;
  jump2Uninstall?: Function;
  @Link dialogConfig: RemoveDialogConfig;
  upArrowCenterX: number = 0;
  offsetY: number = 0;

  onRemoveDialogVisibilityChanged(): void {
    this.isAnimationEnd = this.isShowRemoveDialog;
  }

  build() {
    if (this.dialogConfig) {
      BatchUnInstallAppComponent({
        dialogConfig: this.dialogConfig,
        isUninstallApp: this.isUninstallApp,
        upArrowCenterX: this.upArrowCenterX,
        offsetY: this.offsetY,
        dropX: 0,
        dropY: 0,
        cancel: this.cancel,
        confirm: this.confirm,
        jump2Uninstall: this.jump2Uninstall,
        controller: this.controller,
        isUsedForAnimation: false,
        isShowRemoveDialog: this.isShowRemoveDialog,
        singleContext: this.singleContext
      })
        .width(StyleConstants.PERCENTAGE_100)
    }
  }
}