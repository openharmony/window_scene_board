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
import { InsightIntentContext, UIExtensionContentSession } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';


const TAG: string = 'ScbIntentExecutorImplProxy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Intent Framework Executor Transfer Class
 *
 * @since 2025-5-15
 */
export default class IntentExecutorAdapterProxy {
  private static mInstance: IntentExecutorAdapterProxy;

  public static getInstance(): IntentExecutorAdapterProxy {
    if (!IntentExecutorAdapterProxy.mInstance) {
      IntentExecutorAdapterProxy.mInstance = new IntentExecutorAdapterProxy();
    }
    return IntentExecutorAdapterProxy.mInstance;
  }

  public onExecuteInUIExtensionAbility(name: string, param: Record<string, Object>,
    pageLoader: UIExtensionContentSession, context: InsightIntentContext):
    Promise<insightIntent.ExecuteResult> {
    return new Promise((resolve) => {
      let itemName: string = String(param.itemName);
      log.showInfo(`IntentExecutorAdapter onExecuteInUIExtensionAbility`);
    });
  }

  public onExecuteInUIAbilityBackgroundMode(name: string, param: Record<string, Object>):
    Promise<insightIntent.ExecuteResult> {
    return new Promise((resolve) => {
      let itemName: string = String(param.itemName);
      log.showInfo(`IntentExecutorAdapter onExecuteInUIAbilityBackgroundMode`);
    });
  }

  private initContext(context: InsightIntentContext) {
    if (!GlobalContext.getInstance().getObject('ablitycontext')) {
      GlobalContext.getInstance().setObject('ablitycontext', context);
    }
  }

}