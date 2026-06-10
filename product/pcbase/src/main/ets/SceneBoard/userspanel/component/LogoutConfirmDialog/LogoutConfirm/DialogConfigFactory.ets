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
import { HiSysEventUtil, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { settingsDataManager } from '@ohos/frameworkwrapper';
import { MenuType } from '../../../../systempanel/common/Constants';
import { pcShutdownDialogVMP } from '@ohos/shutdownview/src/main/ets/pages/PcShutdownDialogVMP';
import { Constants } from '../../../common/Constants';
import { ILogoutConfirmConfig, LogoutConfirmVM } from './LogoutConfirmViewModel';


const TAG = 'ConfirmVMFactory';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class ConfirmVMFactory {

  private static instance: ConfirmVMFactory;

  private constructor() {
  }

  public static getInstance() {
    if (!ConfirmVMFactory.instance) {
      ConfirmVMFactory.instance = new ConfirmVMFactory();
    }
    return ConfirmVMFactory.instance;
  }

  public getConfirmVMByName(dialogName: string): LogoutConfirmVM {
    if (dialogName === Constants.REBOOT || dialogName === Constants.SHUTDOWN) {
      return new LogoutConfirmVM(this.getRebootOrShutDownConfirmConfig(dialogName));
    } else {
      let isVirtualMachineUpdating: boolean = this.checkVmUpdate();
      if (isVirtualMachineUpdating) {
        return new LogoutConfirmVM(this.getVmUpdateConfirmConfig(dialogName));
      } else {
        return new LogoutConfirmVM(this.getLogoutConfirmConfig(dialogName));
      }
    }
  }

  private getLogoutConfirmConfig(dialogName: string): ILogoutConfirmConfig {
    return {
      title: $r('app.string.confirm_logout_dialog_title'),
      content: $r('app.string.confirm_logout_dialog_content'),
      contentAlignment: FlexAlign.Center,
      cancelText: $r('app.string.cancel'),
      onCancel: () => {
        log.showInfo(`logoutConfirmDialog: ${dialogName} onCancel`);
        viewMgrPolicy.hideView(ViewType.DIALOG_VIEW);
      },
      confirmText: $r('app.string.confirm_logout_button'),
      onConfirm: () => {
        log.showInfo(`logoutConfirmDialog: ${dialogName} onConfirm`);
        AppStorage.setOrCreate('clickLogout', true);
        viewMgrPolicy.hideView(ViewType.DIALOG_VIEW);
      }
    };
  }

  private getRebootOrShutDownConfirmConfig(dialogName: string): ILogoutConfirmConfig {
    let isReboot = dialogName === Constants.REBOOT;
    return {
      title: $r(isReboot ? 'app.string.multiuser_dialog_reboot' : 'app.string.shutdown_device'),
      content: $r(isReboot ? 'app.string.multiuser_confirm_reboot_tip' :
        'app.string.multiuser_confirm_shutdown_tip'),
      isLoginUserListVisible: true,
      cancelText: $r('app.string.common_cancel'),
      onCancel: () => {
        log.showInfo(`logoutConfirmDialog: ${dialogName} onCancel`);
        viewMgrPolicy.hideView(ViewType.DIALOG_VIEW);
      },
      confirmText: $r(isReboot ? 'app.string.multiuser_dialog_reboot' : 'app.string.shutdown_device'),
      onConfirm: () => {
        try {
          log.showInfo(`logoutConfirmDialog: ${dialogName} onConfirm`);
          viewMgrPolicy.hideView(ViewType.DIALOG_VIEW);
          HiSysEventUtil.hiSysWriteStorage(isReboot ? MenuType.REBOOT_MENU : MenuType.SHUTDOWN_MENU,
            HiSysEventUtil.TOUCH_EVENT, () => {
              pcShutdownDialogVMP.showPcShutdownView();
            });
        } catch (e) {
          log.showError(`showPcShutdownView error, code: ${e?.code}, message: ${e?.message}`);
        }
      }
    };
  }

  private checkVmUpdate(): boolean {
    let virtualMachineVal: string = settingsDataManager.getValue(null, Constants.VIRTUAL_MACHINE_KEY, 'true');
    log.showInfo(`virtualMachineVal: ${virtualMachineVal}`);
    let isVirtualMachineUpdating: boolean = virtualMachineVal === 'false' ? true : false;
    return isVirtualMachineUpdating;
  }

  // 虚拟机定制弹窗
  private getVmUpdateConfirmConfig(dialogName: string): ILogoutConfirmConfig {
    return {
      title: $r('app.string.virtual_machine_updating'),
      content: $r('app.string.logout_warning_when_kiddo_update'),
      contentAlignment: FlexAlign.Center,
      cancelText: $r('app.string.got_it'),
      onCancel: () => {
        log.showInfo(`logoutConfirmDialog: ${dialogName} onCancel`);
        viewMgrPolicy.hideView(ViewType.DIALOG_VIEW);
      },
      isVirtualMachineUpdating: true
    };
  }
}