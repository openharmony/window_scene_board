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

import { LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBCustomDialogWrapper } from '../../../../common/SCBCustomDialogWrapper';
import { PowerOffConfirmBuilder } from '../../../userspanel/component/LogoutConfirmDialog/LogoutConfirm/LogoutConfirm';
import {
  LogoutConfirmVM
} from '../../../userspanel/component/LogoutConfirmDialog/LogoutConfirm/LogoutConfirmViewModel';
import PowerViewModel, { PowerMenuType } from '../../statusbar/PowerViewModel';
import { ResetPwdBtnVM } from './ResetPwdBtnVM';
import { ResetPwdBtnVD } from './ResetPwdBtnVD';
import PowerDialog from '../../statusbar/PowerDialog';
import mSystemPanelModel from '../../../systempanel/model/SystemPanelModel';
import LockScreenAnimationController from '../../common/LockScreenAnimationController';
import { CommonStyle } from '../../style/CommonStyle';

const TAG = 'ScreenLock-ResetPwdBtn';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

@Component
export default struct ResetPwdBtn {
  @StorageLink('isScreenLockWallpaperBrightOrDark') isBrightOrDark: boolean = true;
  @State isVirtualMachineUpdating: boolean = false;
  @State resetPwdBtnVD: ResetPwdBtnVD = new ResetPwdBtnVD();
  private resetPwdBtnVM: ResetPwdBtnVM = new ResetPwdBtnVM();

  aboutToAppear(): void {
    this.resetPwdBtnVM.init(this.resetPwdBtnVD);
  }

  aboutToDisappear(): void {
    this.singleDialogController.destroy();
    this.multiuserDialogController.destroy();
    this.resetPwdBtnVM.destroy();
  }

  private async openDialog(): Promise<void> {
    try {
      const isExistOtherLoginUser = await mSystemPanelModel.isExistOtherLoginUser();
      if (isExistOtherLoginUser) {
        this.rebootConfirmVM.updateUserList();
        this.multiuserDialogController.openDialog();
      } else {
        this.singleDialogController.openDialog();
      }
    } catch (err) {
      log.showError(TAG, `openDialog failed with error ${err?.code} ${err?.message}`);
    }
  }

  build() {
    Column() {
      Text($r('app.string.restart_to_reset_password'))
        .onTouch(event => {
          event.stopPropagation();
        })
        .onClick(() => {
          this.openDialog();
        })
        .fontColor(this.isBrightOrDark ? '#99000000' : '#FFFFFFFF')
        .foregroundBrightness(this.isBrightOrDark ? CommonStyle.toastDarkBrightness : CommonStyle.toastLightBrightness)
        .fontSize('18vp')
        .fontWeight(FontWeight.Bold)
        .fontFamily('HarmonyHeiTi')
    }
    .width('100%')
    .height(64)
    .justifyContent(FlexAlign.Start)
    .backgroundEffect({ radius: LockScreenAnimationController.DEFAULT_BLUR_RADIUS })
    .opacity(LockScreenAnimationController.DEFAULT_OPACITY_RATIO)
    .scale({
      x: LockScreenAnimationController.DEFAULT_SCALE_RATIO,
      y: LockScreenAnimationController.DEFAULT_SCALE_RATIO,
    })
    .visibility(this.resetPwdBtnVD.isVisible ? Visibility.Visible : Visibility.Hidden)
  }

  private async confirmEvent(): Promise<void> {
    await this.resetPwdBtnVM.setResetUserPinMark();
    PowerViewModel.handlePowerMenuClick(PowerMenuType.RESTART);
  }

  /*
   * @description 单用户重启弹窗
   * */
  private singleDialogExpandController: CustomDialogController = new CustomDialogController({
    builder: PowerDialog({
      positiveButton: $r('app.string.reboot_device'),
      dialogMessage: $r('app.string.restart_dialog_message'),
      onConfirm: async () => {
        await this.confirmEvent();
      },
      onCancel: () => {
        this.singleDialogController.closeDialog();
      },
      powerType: PowerMenuType.RESTART,
      isVirtualMachineUpdating: this.isVirtualMachineUpdating
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true,
  });
  private singleDialogController: SCBCustomDialogWrapper =
    new SCBCustomDialogWrapper(this.singleDialogExpandController, null);
  /*
   * @description 多用户重启弹窗
   * */
  private rebootConfirmVM: LogoutConfirmVM = new LogoutConfirmVM({
    title: $r('app.string.multiuser_dialog_reboot'),
    content: $r('app.string.multiuser_confirm_reboot_tip'),
    isLoginUserListVisible: true,
    cancelText: $r('app.string.common_cancel'),
    onCancel: () => {
      this.multiuserDialogController.closeDialog();
    },
    confirmText: $r('app.string.multiuser_dialog_reboot'),
    onConfirm: async () => {
      await this.confirmEvent();
    }
  });
  private multiuserDialogExpandController: CustomDialogController = new CustomDialogController({
    builder: PowerOffConfirmBuilder({
      vm: this.rebootConfirmVM
    }),
    autoCancel: false,
    alignment: DialogAlignment.Center,
    customStyle: true,
  });
  private multiuserDialogController: SCBCustomDialogWrapper =
    new SCBCustomDialogWrapper(this.multiuserDialogExpandController, null);
}