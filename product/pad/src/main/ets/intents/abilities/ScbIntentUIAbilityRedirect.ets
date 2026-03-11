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
import ScbIntentUIAbility from '@ohos/phonebase/src/main/ets/intents/abilities/ScbIntentUIAbility';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import lazy ScbIntentUIAbilityProxy from '@ohos/pcbase/src/main/ets/SceneBoard/intents/abilities/ScbIntentUIAbilityProxy';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { window } from '@kit.ArkUI';

export default class ScbIntentUIAbilityRedirect extends ScbIntentUIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    if (DeviceHelper.is2In1DevicePcType()) {
      ScbIntentUIAbilityProxy.getInstance().onCreate(want, launchParam, this.context);
      return;
    }
    super.onCreate(want, launchParam);
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    if (DeviceHelper.is2In1DevicePcType()) {
      ScbIntentUIAbilityProxy.getInstance().onNewWant(want, launchParam);
      return;
    }
    super.onNewWant(want, launchParam);
  }

  onDestroy(): void | Promise<void> {
    if (DeviceHelper.is2In1DevicePcType()) {
      ScbIntentUIAbilityProxy.getInstance().onDestroy();
      return;
    }
    super.onDestroy();
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    if (DeviceHelper.is2In1DevicePcType()) {
      ScbIntentUIAbilityProxy.getInstance().onWindowStageCreate(windowStage);
      return;
    }
    super.onWindowStageCreate(windowStage);
  }

  onForeground(): void {
    if (DeviceHelper.is2In1DevicePcType()) {
      ScbIntentUIAbilityProxy.getInstance().onForeground();
      return;
    }
    super.onForeground();
  }

  onBackground(): void {
    if (DeviceHelper.is2In1DevicePcType()) {
      ScbIntentUIAbilityProxy.getInstance().onBackground();
      return;
    }
    super.onBackground();
  }
}