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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { BusinessError } from '@ohos.base';
import { IntentItemManager } from '../manager/IntentItemManager';
import { IntentItemConfig } from '../models/IntentItemConfig';
import { IntentCodeConstants, INTENT_CODE, IntentType } from '../utils/IntentConstants';
import BaseIntentCardInfo from '../beans/BaseIntentCardInfo';
import { IntentBeanFactory } from '../utils/IntentBeanFactory';
import { IntentCheckAdaptor } from '../adpaters/IntentCheckAdaptor';
import { IntentSwitchAdaptor } from '../adpaters/IntentSwitchAdapter';
import FlashlightConstants from '@ohos/flashlightcomponent/src/main/ets/com/ohos/common/Constants';

const TAG: string = 'ScbIntentExecutorImpl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

const WINDOW_BACKGROUND_COLOR: string = '#00ffffff';
const DEFAULT_INTENT_COMPONENT: string = 'intents/pages/SwitchIntentCardPage';

interface UIExtensionStorage {
  uiExtensionSession: UIExtensionContentSession,
}

/**
 * Intent Framework Executor Implementation Class
 *
 * @since 2024-05-23
 */
export default class ScbIntentExecutorImpl extends InsightIntentExecutor {
  /**
   * Intention framework UIExtensionAbility callback
   */
  onExecuteInUIExtensionAbility(name: string, param: Record<string, Object>, pageLoader: UIExtensionContentSession):
    insightIntent.ExecuteResult | Promise<insightIntent.ExecuteResult> {
    log.showInfo(`extension: intentName is ${name}`);
    let itemName: string = String(param.itemName);
    return new Promise((resolve, reject) => {
      try {
        let info: BaseIntentCardInfo = IntentBeanFactory.build(itemName);
        AppStorage.setOrCreate<BaseIntentCardInfo>('cardInfo', info);
        log.showInfo(`page is ${DEFAULT_INTENT_COMPONENT}, info is ${JSON.stringify(info)}`);
        let localStorage: LocalStorage = new LocalStorage({
          uiExtensionSession: pageLoader
        } as UIExtensionStorage);
        pageLoader.loadContent(DEFAULT_INTENT_COMPONENT, localStorage);
        pageLoader.setWindowBackgroundColor(WINDOW_BACKGROUND_COLOR);
        let defaultRsp: insightIntent.ExecuteResult = {
          code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
          result: {
            'errMsg': 'success'
          }
        }
        resolve(defaultRsp);
      } catch (error) {
        log.showError(`extension: error is ${error}`);
        reject(error);
      }
    });
  }

  /**
   * Intention Framework Startup Background Ability Callback
   */
  async onExecuteInUIAbilityBackgroundMode(intentName: string, intentParam: Record<string, Object>):
    Promise<insightIntent.ExecuteResult> {
    log.showInfo(`background: intentName is ${intentName}`);
    // 手电筒
    if (FlashlightConstants.intentNameSet.has(intentName)) {
      return IntentSwitchAdaptor.setFlashlight(intentName);
    }

    if (intentName === IntentType.CHECK_SETTING_PAGE) {
      return IntentCheckAdaptor.checkSettingPage(intentParam);
    }

    let rsp: insightIntent.ExecuteResult = {
      code: IntentCodeConstants.DEFAULT_CODE_UNSUPPORTED,
      result: {
        'errMsg': INTENT_CODE[IntentCodeConstants.DEFAULT_CODE_UNSUPPORTED],
      }
    };

    try {
      let itemName: string = String(intentParam.itemName);
      let item: IntentItemConfig | null = null;
      try {
        item = await IntentItemManager.getItem(itemName);
      } catch (error) {
        log.error(`backgroundMode unsupport intent itemName: ${itemName}`);
        return rsp;
      }
      rsp = await this.executeBackgroundIntent(item, intentName, itemName, intentParam);
    } catch (error) {
      log.error(`execute intent failed, err: ${(error as BusinessError).message}`);
    }
    return rsp;
  }

  private async executeBackgroundIntent(item: IntentItemConfig, intentName: string, itemName: string,
    intentParam: Record<string, Object>) : Promise<insightIntent.ExecuteResult> {
    let rsp: insightIntent.ExecuteResult = {
      code: IntentCodeConstants.DEFAULT_CODE_UNSUPPORTED,
      result: {
        'errMsg': INTENT_CODE[IntentCodeConstants.DEFAULT_CODE_UNSUPPORTED],
      }
    };
    AppStorage.setOrCreate<IntentItemConfig>('intentItem', item);
    let appBundleName: string = this.getAppBundleName(intentParam);
    switch (intentName) {
      case IntentType.GET_SETTING_SWITCH:
        rsp = IntentSwitchAdaptor.getSettingSwitch(itemName, appBundleName);
        break;
      case IntentType.SET_SETTING_SWITCH:
        let switchFlag: number = Number(intentParam.switchFlag);
        rsp = IntentSwitchAdaptor.setSettingSwitch(itemName, appBundleName, switchFlag);
        break;
      case IntentType.CHECK_SETTING_ITEM:
        rsp = await IntentCheckAdaptor.checkSettingItem(itemName, appBundleName);
        break;
      default:
        log.showError(`unsupport intent`);
        break;
    }
    return rsp;
  }

  private getAppBundleName(intentParam: Record<string, Object>) {
    let appBundleName: string = String(intentParam.appBundleName);
    if (appBundleName === 'undefined' || appBundleName == null || appBundleName === '') {
      AppStorage.setOrCreate('appBundleName', null);
    } else {
      AppStorage.setOrCreate('appBundleName', appBundleName);
    }
    return appBundleName;
  }
}