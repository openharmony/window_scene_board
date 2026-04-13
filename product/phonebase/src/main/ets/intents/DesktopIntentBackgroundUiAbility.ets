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

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import UIAbility from '@ohos.app.ability.UIAbility';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ContextManager } from './ContextManager';

const TAG: string = 'DesktopIntentBackgroundUiAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCS, TAG);

export default class DesktopIntentBackgroundUiAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    log.showInfo(`onCreate is called`);
    if (this.context == undefined) {
      log.showInfo(`this.context = ${undefined}`);
    }
    ContextManager.setContext(this.context);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    log.showInfo(`onNewWant is called`);
  }

  onDestroy(): void {
    log.showInfo(`onDestroy is called`);
    ContextManager.setContext(undefined);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    log.showInfo(`onWindowStageCreate is called`);
  }
}
