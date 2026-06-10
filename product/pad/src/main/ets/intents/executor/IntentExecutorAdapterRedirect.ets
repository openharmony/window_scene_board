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
import IntentExecutorAdapter from '@ohos/phonebase/src/main/ets/intents/executor/IntentExecutorAdapter';
import insightIntent from '@ohos.app.ability.insightIntent';
import { UIExtensionContentSession } from '@kit.AbilityKit';
import lazy IntentExecutorAdapterProxy from '@ohos/pcbase/src/main/ets/SceneBoard/intents/executor/IntentExecutorAdapterProxy';
import { DeviceHelper } from '@ohos/frameworkwrapper';

export default class IntentExecutorAdapterRedirect extends IntentExecutorAdapter {
  onExecuteInUIExtensionAbility(name: string, param: Record<string, Object>,
    pageLoader: UIExtensionContentSession): Promise<insightIntent.ExecuteResult> {
    if (DeviceHelper.is2In1DevicePcType()) {
      return IntentExecutorAdapterProxy.getInstance()
        .onExecuteInUIExtensionAbility(name, param, pageLoader, this.context);
    }
    return super.onExecuteInUIExtensionAbility(name, param, pageLoader);
  }

  onExecuteInUIAbilityBackgroundMode(name: string,
    param: Record<string, Object>): Promise<insightIntent.ExecuteResult> {
    if (DeviceHelper.is2In1DevicePcType()) {
      return IntentExecutorAdapterProxy.getInstance().onExecuteInUIAbilityBackgroundMode(name, param);
    }
    return super.onExecuteInUIAbilityBackgroundMode(name, param);
  }
}