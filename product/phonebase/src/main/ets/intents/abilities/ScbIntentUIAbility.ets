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

import UIAbility from '@ohos.app.ability.UIAbility';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import window from '@ohos.window';
import { ContextManager } from '../ContextManager';

const TAG: string = 'ScbIntentUIAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * ScbIntentUIAbility
 *
 * @since 2024-05-23
 */
export default class ScbIntentUIAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    log.showInfo('onCreate is called');
    AppStorage.setOrCreate<Context>('intentPageContext', this.context);
    ContextManager.setContext(this.context);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    log.showInfo(`onNewWant is called`);
  }

  onDestroy(): void | Promise<void> {
    log.showInfo('onDestroy is called');
    AppStorage.delete('intentPageContext');
    ContextManager.setContext(undefined);
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    log.showInfo('onWindowStageCreate is called');
  }

  onForeground(): void {
    log.showInfo('onForeground is called');
  }

  onBackground(): void {
    log.showInfo('onBackground is called');
  }
}