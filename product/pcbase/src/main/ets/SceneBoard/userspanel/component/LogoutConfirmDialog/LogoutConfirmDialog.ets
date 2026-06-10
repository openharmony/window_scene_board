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
import { ILogoutConfirmConfig, logoutConfirmBuilder } from './LogoutConfirm/LogoutConfirm';
import promptAction from '@ohos.promptAction';

const TAG = 'UserPanel-LogoutConfirmDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

class LogoutConfirmDialog {
  private dialogMap: Map<string, number> = new Map<string, number>();

  public async open(context: Object, dialogKey: string, config: ILogoutConfirmConfig): Promise<number | null> {
    log.showInfo(`open invoked. dialog ${dialogKey}`);
    if (this.dialogMap.has(dialogKey)) {
      log.showInfo(`dialog ${dialogKey} aleardy exists`);
      this.close(dialogKey);
    }
    try {
      const dialogId: number = await promptAction.openCustomDialog({
        // builder 必须和一个组件的 context 绑定
        builder: logoutConfirmBuilder.bind(context, config),
        alignment: DialogAlignment.Center,
        autoCancel: false,
        onWillDismiss: (dismissDialogAction: DismissDialogAction) => {
          log.showInfo(`onWillDismiss invoked. dialog ${dialogKey}`);
          dismissDialogAction.dismiss();
          this.dialogMap.delete(dialogKey);
        },
        showInSubWindow: true
      });
      this.dialogMap.set(dialogKey, dialogId);
      return dialogId;
    } catch (err) {
      log.showInfo(`open dialog ${dialogKey} failed with error ${err?.code} ${err?.message}`);
      return null;
    }
  }

  public close(dialogKey: string): void {
    log.showInfo(`close invoked. dialog ${dialogKey}`);
    if (!this.dialogMap.has(dialogKey)) {
      return;
    }
    const dialogId: number = this.dialogMap.get(dialogKey) as number;
    try {
      promptAction.closeCustomDialog(dialogId);
    } catch (err) {
      log.showInfo(`close dialog ${dialogKey} failed with error ${err?.code} ${err?.message}`);
    }
  }
}

export const logoutConfirmDialog: LogoutConfirmDialog = new LogoutConfirmDialog();