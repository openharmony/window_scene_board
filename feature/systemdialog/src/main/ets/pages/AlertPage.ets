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
import { AlertDialog } from '@ohos.arkui.advanced.Dialog';
import { LogDomain, Logger } from '@ohos/basicutils';
import { AlertViewModel } from '../vm/AlertViewModel';

const TAG = 'AlertPage';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const storage = LocalStorage.getShared();

@Component
export struct AlertPage {
  private alertViewModel: AlertViewModel = storage?.get<AlertViewModel>('alertViewModel') as AlertViewModel;
  private title: string = '';
  private content: string = '';
  private btn: string = '';

  private alertDialogController?: CustomDialogController | null = new CustomDialogController({
    builder: AlertDialog({
      primaryTitle: this.title,
      content: this.content,
      primaryButton: {
        value: this.btn,
        action: () => this.onAlertDialogCancel()
      },
    }),
    cancel: () => this.onAlertDialogCancel(),
    alignment: DialogAlignment.Center,
    autoCancel: false,
    customStyle: false
  });

  private onAlertDialogCancel(): void {
    log.showInfo(TAG, 'onAlertDialogCancel');
    this.alertDialogController?.close();
    this.alertViewModel?.terminateSession();
  }

  aboutToAppear() {
    log.showInfo(TAG, 'aboutToAppear');
    this.title = this.alertViewModel?.getDialogTitle();
    this.content = this.alertViewModel?.getDialogContent();
    this.btn = this.alertViewModel?.getBtnValue();
    if (this.title && this.content && this.btn) {
      this.alertDialogController?.open();
    } else {
      log.showInfo(TAG, 'missing title, content, btn');
      this.onAlertDialogCancel();
    }
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisappear');
    this.alertDialogController = null;
  }

  build() {
    Row() {
    }
  }
}
