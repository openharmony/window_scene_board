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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { AppItemInfo, EventConstants, CardItemInfo } from '@ohos/launchercommon';
import { DialogController } from '@ohos/launchercommon/src/main/ets/viewmodel/DialogController';

const TAG = 'DialogController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const DIALOG_OFFSET_Y_B = -465;
const DIALOG_OFFSET_Y_C = 465;

export class AppDialogController extends DialogController {

  public init(): void {}

  public destroy(): void {}

  public notifyDialogOffsetChange(): void {
    animateTo({
      duration: 400,
      curve: Curve.Friction,
    }, () => {
      localEventManager.sendLocalEvent(EventConstants.EVENT_UPDATE_DIALOG_POSITION);
    })
  }

  public getDialogOffsetY(): number {
    return 0;
  }

  public setDialogShowPage(value: number): void {}
}

export class FileFolderDialogController extends DialogController {

  private isDefaultShowBSide: boolean = true;

  public init(): void {}

  public destroy(): void {}

  public setDialogOffsetY(offset: number, needAnimation: boolean = true): void {
    log.showInfo(`set fileFolder dialog offset ${offset}, ${needAnimation}`);
    if (!needAnimation) {
      AppStorage.setOrCreate('dialogOffsetY', offset);
      return;
    }
    animateTo({
      duration: 400,
      curve: Curve.Friction,
    }, () => {
      AppStorage.setOrCreate('dialogOffsetY', offset);
    })
  }

  public getDialogOffsetY(): number {
    return 0;
  }

  public setDialogShowPage(value: number): void {
    this.isDefaultShowBSide = value === 0;
    this.setDialogOffsetY(this.getDialogOffsetY(), false);
  }
}

export class FormDialogController extends DialogController {

  public init(): void {}

  public destroy(): void {}

  public notifyDialogOffsetChange(): void {
    animateTo({
      duration: 400,
      curve: Curve.Friction,
    }, () => {
      localEventManager.sendLocalEvent(EventConstants.EVENT_UPDATE_DIALOG_POSITION);
    })
  }

  public getDialogOffsetY(): number {
    return 0;
  }

  public setDialogShowPage(value: number): void {}
}