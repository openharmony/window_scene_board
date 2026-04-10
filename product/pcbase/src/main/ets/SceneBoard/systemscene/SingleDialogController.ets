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

const TAG = 'SingleDialogController';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 单实例弹窗控制器，控制只能存在一个该弹窗实例
 */
export class SingleDialogController {
  private dialogName: string = '';
  private dialogController: CustomDialogController;
  private isDialogOpen: boolean = false;

  constructor(dialogName: string, dialogController: CustomDialogController) {
    this.dialogName = dialogName;
    this.dialogController = dialogController;
  }

  public open(): void {
    if (this.isDialogOpen) {
      log.showInfo(`${this.dialogName} dialog is open`);
      return;
    }
    this.dialogController.open();
    this.isDialogOpen = true;
  }

  public close(): void {
    this.dialogController.close();
    this.isDialogOpen = false;
  }

  public isOpen(): boolean {
    return this.isDialogOpen;
  }
}