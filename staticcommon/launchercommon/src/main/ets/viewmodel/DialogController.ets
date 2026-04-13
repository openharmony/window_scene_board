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

const TAG = 'DialogController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export abstract class DialogController {

  protected static dialogControllers: Map<DialogControllerType, DialogController> = new Map();

  public static initDialogController(type: DialogControllerType, dialogController: DialogController): void {
    if (DialogController.dialogControllers.get(type)) {
      log.showInfo('initDialogController, dialogController is not null, return');
      return;
    }
    DialogController.dialogControllers.set(type, dialogController);
  }

  public static getDialogController(type: DialogControllerType): DialogController | undefined {
    return DialogController.dialogControllers.get(type);
  }

  public static removeDialogController(type: DialogControllerType): boolean {
    return DialogController.dialogControllers.delete(type);
  }

  abstract init():void;

  abstract destroy(): void;

  abstract getDialogOffsetY(): number;

  abstract setDialogShowPage(value: number): void;
}

export enum DialogControllerType {
  UNKNOWN,
  DESKTOP_APP,
  DESKTOP_FILE_FOLDER,
  DESKTOP_FORM,
}