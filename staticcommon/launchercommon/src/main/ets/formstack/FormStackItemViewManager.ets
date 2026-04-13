/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GridLayoutItemInfo } from '../TsIndex';
import { FormStackItemBuildInterface, FormStackItemViewType } from './FormStackItemBuildInterface';

const TAG: string = 'FormStackItemViewManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

class FormStackItemViewManager {
  private static mInstance: FormStackItemViewManager;
  private mViewMap = new Map<FormStackItemViewType, FormStackItemBuildInterface>();

  public static getInstance(): FormStackItemViewManager {
    if (!FormStackItemViewManager.mInstance) {
      FormStackItemViewManager.mInstance = new FormStackItemViewManager();
    }

    return FormStackItemViewManager.mInstance;
  }

  public registerFormStackItemView(type: FormStackItemViewType, viewInterface: FormStackItemBuildInterface): void {
    if (type <= FormStackItemViewType.TYPE_MIN || type >= FormStackItemViewType.TYPE_MAX) {
      log.showError(`register type is invalid! type: {type}.`);
      return;
    }

    this.mViewMap.set(type, viewInterface);
  }

  public unregisterFormStackItemView(type: FormStackItemViewType): void {
    this.mViewMap.delete(type);
  }

  public getFormBuilderInterface(layout: GridLayoutItemInfo): FormStackItemBuildInterface | undefined {
    const iterator = this.mViewMap.values();
    for (let i = 0; i < this.mViewMap.size; i++) {
      const buildInterface: FormStackItemBuildInterface = iterator.next().value;
      if (buildInterface.isTypeMatch(layout)) {
        return buildInterface;
      }
    }

    log.showError(`get form build interface failed, layout cardId: ${layout.cardId}, typeId: ${layout.typeId}.`);
    return undefined;
  }

  private constructor() {
  }
}

export const formStackItemViewManager = FormStackItemViewManager.getInstance();