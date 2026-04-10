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

const TAG = 'SCBCustomDialogWrapper';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class SCBCustomDialogWrapper {
  private defaultController: CustomDialogController | null;
  private foldController?: CustomDialogController | null;
  private ctrlOpenStatus: boolean = false;

  constructor(defaultController: CustomDialogController, foldController?: CustomDialogController | null) {
    this.defaultController = defaultController;
    this.foldController = foldController;
  }

  public openDialog(): void {
    this.openDefaultCustomDialog();
  }

  private openFoldCustomDialog(): void {
    log.showInfo(`openFoldCustomDialog, openStatus: ${this.ctrlOpenStatus}`);
    if (this.ctrlOpenStatus) {
      this.defaultController?.close();
    }
    this.foldController?.open();
    this.ctrlOpenStatus = true;
  }

  private openDefaultCustomDialog(): void {
    log.showInfo(`openDefaultCustomDialog, openStatus: ${this.ctrlOpenStatus}`);
    if (this.ctrlOpenStatus) {
      this.foldController?.close();
    }
    this.defaultController?.open();
    this.ctrlOpenStatus = true;
  }

  public closeDialog(): void {
    this.defaultController?.close();
    this.foldController?.close();
    this.ctrlOpenStatus = false;
  }

  public destroy(): void {
    this.defaultController?.close();
    this.foldController?.close();
    this.ctrlOpenStatus = false;
    this.defaultController = null;
    this.foldController = null;
    log.showInfo(`SCBCustomDialog destroy` +
      `${this.defaultController}, ${this.foldController}, ${this.ctrlOpenStatus}`);
  }
}