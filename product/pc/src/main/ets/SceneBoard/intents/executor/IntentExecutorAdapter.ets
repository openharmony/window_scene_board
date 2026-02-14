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

import insightIntent from '@ohos.app.ability.insightIntent';
import InsightIntentExecutor from '@ohos.app.ability.InsightIntentExecutor';
import { UIExtensionContentSession } from '@kit.AbilityKit';
import IntentExecutorAdapterProxy from '@ohos/pcbase/src/main/ets/SceneBoard/intents/executor/IntentExecutorAdapterProxy';

/**
 * Intent Framework Executor Transfer Class
 *
 * @since 2024-10-26
 */
export default class IntentExecutorAdapter extends InsightIntentExecutor {
  onExecuteInUIExtensionAbility(name: string, param: Record<string, Object>, pageLoader: UIExtensionContentSession):
    Promise<insightIntent.ExecuteResult> {
    return IntentExecutorAdapterProxy.getInstance()
      .onExecuteInUIExtensionAbility(name, param, pageLoader, this.context);
  }

  onExecuteInUIAbilityBackgroundMode(name: string, param: Record<string, Object>):
    Promise<insightIntent.ExecuteResult> {
    return IntentExecutorAdapterProxy.getInstance().onExecuteInUIAbilityBackgroundMode(name, param);
  }
}