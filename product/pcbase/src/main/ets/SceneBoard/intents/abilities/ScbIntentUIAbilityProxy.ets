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

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import window from '@ohos.window';
import { ContextManager } from '../ContextManager';
import { common } from '@kit.AbilityKit';

const TAG: string = 'ScbIntentUIAbilityProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * ScbIntentUIAbilityProxy
 *
 * @since 2025-5-15
 */
export default class ScbIntentUIAbilityProxy {
  private static mInstance: ScbIntentUIAbilityProxy;

  public static getInstance(): ScbIntentUIAbilityProxy {
    if (!ScbIntentUIAbilityProxy.mInstance) {
      ScbIntentUIAbilityProxy.mInstance = new ScbIntentUIAbilityProxy();
    }
    return ScbIntentUIAbilityProxy.mInstance;
  }

  public onCreate(want: Want, launchParam: AbilityConstant.LaunchParam, context: common.UIAbilityContext): void {
    log.showInfo('onCreate is called');
    AppStorage.setOrCreate<Context>('intentPageContext', context);
    ContextManager.setContext(context);
  }

  public onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    log.showInfo(`onNewWant is called`);
  }

  public onDestroy(): void | Promise<void> {
    log.showInfo('onDestroy is called');
    AppStorage.delete('intentPageContext');
    ContextManager.setContext(undefined);
  }

  public onWindowStageCreate(windowStage: window.WindowStage): void {
    log.showInfo('onWindowStageCreate is called');
  }

  public onForeground(): void {
    log.showInfo('onForeground is called');
  }

  public onBackground(): void {
    log.showInfo('onBackground is called');
  }
}