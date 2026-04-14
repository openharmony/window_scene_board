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
import { IntentItemManager } from '../manager/IntentItemManager';
import ScbIntentExecutorImpl from './ScbIntentExecutorImpl';
import SwitchIntentExecutorImpl from '../SwitchIntentExecutorImpl';
import FlashlightConstants from '@ohos/flashlightcomponent/src/main/ets/com/ohos/common/Constants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper'
import { IntentType } from '../utils/IntentConstants';

const TAG: string = 'IntentExecutorAdaptor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * Intent Framework Executor Transfer Class
 *
 * @since 2024-05-23
 */
export default class IntentExecutorAdapter extends InsightIntentExecutor {
  onExecuteInUIExtensionAbility(name: string, param: Record<string, Object>, pageLoader: UIExtensionContentSession):
    Promise<insightIntent.ExecuteResult> {
    return new Promise((resolve) => {
      let itemName: string = String(param.itemName);
      IntentItemManager.getItem(itemName).then(() => {
        let impl = new ScbIntentExecutorImpl();
        impl.context = this.context;
        resolve(impl.onExecuteInUIExtensionAbility(name, param, pageLoader));
      }).catch(() => {
        let impl = new SwitchIntentExecutorImpl();
        impl.context = this.context;
        resolve(impl.onExecuteInUIExtensionAbility(name, param, pageLoader));
      });
      log.showInfo(`IntentExecutorAdapter onExecuteInUIExtensionAbility`);
    });
  }

  onExecuteInUIAbilityBackgroundMode(name: string, param: Record<string, Object>):
    Promise<insightIntent.ExecuteResult> {
    return new Promise((resolve) => {
      // 如果是手电筒,CheckSettingPage和CheckSettingItem
      if (FlashlightConstants.intentNameSet.has(name) ||
        name === IntentType.CHECK_SETTING_PAGE ||
        name === IntentType.CHECK_SETTING_ITEM) {
        let impl = new ScbIntentExecutorImpl();
        impl.context = this.context;
        resolve(impl.onExecuteInUIAbilityBackgroundMode(name, param));
      }

      let itemName: string = String(param.itemName);
      IntentItemManager.getItem(itemName).then(() => {
        let impl = new ScbIntentExecutorImpl();
        impl.context = this.context;
        resolve(impl.onExecuteInUIAbilityBackgroundMode(name, param));
      }).catch(() => {
        let impl = new SwitchIntentExecutorImpl();
        impl.context = this.context;
        resolve(impl.onExecuteInUIAbilityBackgroundMode(name, param));
      });
      log.showInfo(`IntentExecutorAdapter onExecuteInUIAbilityBackgroundMode`);
    });
  }

  private initContext() {
    if (!GlobalContext.getInstance().getObject('ablitycontext')) {
      GlobalContext.getInstance().setObject('ablitycontext', this.context);
    }
  }
}