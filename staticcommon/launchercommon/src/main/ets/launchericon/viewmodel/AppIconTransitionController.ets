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
import { AppData, SCBTransitionController, SCBTransitionManager } from '@ohos/windowscene';

const TAG = 'AppIconTransitionController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

type ActiveChangeHandler = (module: string, caller: string, extra?: string) => void;

export class AppIconTransitionController {
  private transitionController?: SCBTransitionController;

  public registerController(appData: AppData, onActive: ActiveChangeHandler, onInactive: ActiveChangeHandler): void {
    if (!appData || !onActive || !onInactive) {
      log.showError('registerController failed, appData is invalid!');
      return;
    }

    this.transitionController = {
      appData: appData,
      onActive: (module: string, caller: string, extra?: string): void => onActive(module, caller, extra),
      onInactive: (module: string, caller: string, extra?: string): void => onInactive(module, caller, extra),
    };

    SCBTransitionManager.getInstance().registerTransitionController(this.transitionController);
  }

  public unregisterController(): void {
    SCBTransitionManager.getInstance().unRegisterTransitionController(this.transitionController);
  }

  public updateIconRadius(iconRadius: number): void {
    if (CheckEmptyUtils.isEmpty(iconRadius)) {
      log.showError('updated iconRadius is invalid!');
      return;
    }

    if (this.transitionController && this.transitionController.appData) {
      this.transitionController.appData.iconRadius = iconRadius;
    }
  }
}