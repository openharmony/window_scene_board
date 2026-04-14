/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { nameAppearAnimate } from '@ohos/launchercommon/Index';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormNameVm } from './FormNameVm';

const TAG = 'FormNameEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FormNameEvent {
  private mFormNameVm: FormNameVm;

  constructor(formNameVm: FormNameVm) {
    this.mFormNameVm = formNameVm;
  }

  public setFormNameOpacity(nameOpacity: number): void {
    log.showWarn(`current setFormNameOpacity, nameOpacity:${nameOpacity}`);
    this.mFormNameVm.mNameOpacity = nameOpacity;
  }

  public nameDelayAnimateHandler(delayTime: number): void {
    this.setFormNameOpacity(0);
    setTimeout(() => {
      nameAppearAnimate(() => this.setFormNameOpacity(1));
    }, delayTime);
  }

  public nameAnimateHandler(): void {
    this.setFormNameOpacity(0);
    nameAppearAnimate(() => this.setFormNameOpacity(1));
  }

  public calculateColEnd(formItem?: CardItemInfo): number {
    if (formItem && formItem.area && formItem.column !== undefined && formItem.column >= 0) {
      return formItem.column + formItem.area[0] - 1;
    }
    log.showError(`calculateColEnd formItem invalid, column=${formItem?.column}, areaLength=${formItem?.area?.length}`);
    return 0;
  }

  public calculateRowEnd(formItem?: CardItemInfo): number {
    if (formItem && formItem.area && formItem.row !== undefined && formItem.row >= 0) {
      return formItem.row + formItem.area[1] - 1;
    }
    log.showError(`calculateRowEnd formItem invalid, row=${formItem?.row}, areaLength=${formItem?.area?.length}`);
    return 0;
  }
}