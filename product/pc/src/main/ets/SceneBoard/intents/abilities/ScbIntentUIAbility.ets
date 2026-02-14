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

import UIAbility from '@ohos.app.ability.UIAbility';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import ScbIntentUIAbilityProxy from '@ohos/pcbase/src/main/ets/SceneBoard/intents/abilities/ScbIntentUIAbilityProxy';

/**
 * ScbIntentUIAbility
 *
 * @since 2024-10-26
 */
export default class ScbIntentUIAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    ScbIntentUIAbilityProxy.getInstance().onCreate(want, launchParam, this.context);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    ScbIntentUIAbilityProxy.getInstance().onNewWant(want, launchParam);
  }

  onDestroy(): void | Promise<void> {
    return ScbIntentUIAbilityProxy.getInstance().onDestroy();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    ScbIntentUIAbilityProxy.getInstance().onWindowStageCreate(windowStage);
  }

  onForeground(): void {
    ScbIntentUIAbilityProxy.getInstance().onForeground();
  }

  onBackground(): void {
    ScbIntentUIAbilityProxy.getInstance().onBackground();
  }
}