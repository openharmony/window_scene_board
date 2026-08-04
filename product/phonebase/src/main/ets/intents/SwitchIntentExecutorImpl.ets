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

import data_preferences from '@ohos.data.preferences';
import InsightIntentExecutor from '@ohos.app.ability.InsightIntentExecutor';
import insightIntent from '@ohos.app.ability.insightIntent';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ContextModifyUtils } from '@ohos/frameworkwrapper';
import { BusinessError } from '@ohos.base';
import { ContextManager } from './ContextManager';
import { IntentCodeConstants, IntentNameConstants } from './IntentCodeConstant';
import { common, UIExtensionContentSession } from '@kit.AbilityKit';
import BaseIntentCardInfo from './beans/BaseIntentCardInfo';
import { IntentBeanFactory } from './utils/IntentBeanFactory';
import contextConstant from '@ohos.app.ability.contextConstant';

const TAG: string = 'Desktop-Setting-SwitchIntentExecutorImpl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCS, TAG);
const KEY_SEARCH_STATUS: string = 'hiSearchStatus';
const PREFERENCE_FILE_NAME: string = 'DesktopSetting';
const DEFAULT_INTENT_COMPONENT: string = 'intents/pages/DesktopSlideCardPage';
const WINDOW_BACKGROUND_COLOR: string = '#00000000';

interface UIExtensionStorage {
  uIExtensionSession: UIExtensionContentSession,
}

export default class SwitchIntentExecutorImpl extends InsightIntentExecutor {
  public onExecuteInUIExtensionAbility(name: string, param: Record<string, Object>,
    pageLoader: UIExtensionContentSession): insightIntent.ExecuteResult | Promise<insightIntent.ExecuteResult> {
    log.showInfo(`onExecuteInUIExtensionAbility: name = ${name}, param = ${param?.itemName}`);
    let itemName: string = String(param?.itemName);
    return new Promise(async (resolve, reject) => {
      try {
        let info: BaseIntentCardInfo = IntentBeanFactory.build(itemName);
        AppStorage.setOrCreate<BaseIntentCardInfo>('cardInfo', info);
        switch (itemName) {
          case IntentNameConstants.DESKTOP_SLIDE:
            resolve(this.getSearchCardIntent(pageLoader));
            break;
          default:
            log.showWarn(`onExecuteInUIExtensionAbility: nothing`);
            reject('unsupported itemName');
        }
      } catch (e) {
        log.showWarn(`onExecuteInUIExtensionAbility: e = ${e}`)
        reject(e);
      }
    });
  }

  private getSearchCardIntent(pageLoader: UIExtensionContentSession) {
    let localStorage: LocalStorage = new LocalStorage({
      uIExtensionSession: pageLoader
    } as UIExtensionStorage);
    pageLoader.loadContent(DEFAULT_INTENT_COMPONENT, localStorage);
    pageLoader.setWindowBackgroundColor(WINDOW_BACKGROUND_COLOR);
    let code: number = IntentCodeConstants.DEFAULT_CODE_SUCCESS;
    let result: insightIntent.ExecuteResult = {
      code: code,
      result: {
        'errMsg': 'success'
      }
    };
    log.showInfo(`getSearchCardIntent: result = ${result.code}`);
    return result;
  }

  onExecuteInUIAbilityBackgroundMode(intentName: string, intentParam: Record<string, Object>):
    insightIntent.ExecuteResult | Promise<insightIntent.ExecuteResult> {
    let itemName: string = String(intentParam?.itemName);
    log.info(`intentName is ${intentName}, itemName is ${itemName}`);

    return new Promise((resolve) => {
      switch (intentName) {
        case IntentNameConstants.CHECK_SETTING_ITEM:
          this.checkSettingSwitch(itemName).then((result) => {
            resolve(result);
          })
          break;
        case IntentNameConstants.GET_SETTING_SWITCH:
          this.getSettingSwitch(itemName).then((result) => {
            resolve(result);
          })
          break;
        case IntentNameConstants.SET_SETTING_SWITCH:
          let switchFlag: number = Number(intentParam.switchFlag);
          this.setSettingSwitch(itemName, switchFlag).then((result) => {
            resolve(result);
          })
          break;
        default:
          break;
      }
    });
  }

  async setSettingSwitch(itemName: string, switchFlag: number): Promise<insightIntent.ExecuteResult> {
    log.info(`switchFlag : ${switchFlag}`);
    let defaultRsp: insightIntent.ExecuteResult = {
      code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
      result: {}
    }

    await this.setSwitchInternal(itemName, switchFlag);
    try {
      let rsp: Record<string, Object> = {
        'itemName': itemName,
        'switchFlag': switchFlag,
      }
      defaultRsp = {
        code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
        result: rsp,
      }
    } catch (e) {
      log.showError(`SetSettingSwitch occurs an error: ${e.toString()}`);
      defaultRsp = {
        code: IntentCodeConstants.DEFAULT_CODE_FAILED,
        result: {
          errMsg: 'execute failed.'
        }
      }
    }
    return defaultRsp;
  }

  async setSwitchInternal(itemName: string, switchFlag: number): Promise<void> {
    // 0-打开 1-关闭
    log.showInfo(`setSwitch .switchFlag = ${switchFlag}`);
    let newStatus: boolean = switchFlag === 0 ? true : false;
    let applicationContext = ContextManager.getContext()?.getApplicationContext();
    let callback = async (callbackContext: Context) => {
      try {
        let preference: data_preferences.Preferences = await data_preferences.getPreferences(
          callbackContext, PREFERENCE_FILE_NAME);
        let currentStatus = await preference.get(KEY_SEARCH_STATUS, true) as boolean;
        log.showInfo(`setSwitchInternal currentStatus:` + currentStatus);
        log.showInfo(`setSlideSwitch, old value is ${currentStatus}, new value is ${newStatus}}`);

        if (newStatus === currentStatus) {
          if (currentStatus) { // 已经打开
            log.info(`switch: ${itemName} has already turn on`);
          } else {
            log.info(`switch: ${itemName} has already turn off`);
          }
        } else {
          preference.putSync(KEY_SEARCH_STATUS, newStatus);
          await preference.flush();
          if (newStatus) {
            log.info(`switch: ${itemName} turn on success`);
          } else {
            log.info(`switch: ${itemName} turn off success`);
          }
        }

      } catch (e) {
        log.showInfo(`Preference Error, ${(e as BusinessError).message}`);
      }
    };
    await ContextModifyUtils.modifyTargetContextAsync(applicationContext, contextConstant.AreaMode.EL1, callback,
      `${TAG}-setSwitchInternal`);
  }

  async getSettingSwitch(itemName: string): Promise<insightIntent.ExecuteResult> {
    let getResult: insightIntent.ExecuteResult = {
      code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
      result: {}
    }
    log.showInfo(`getSettingSwitch start`);
    let switchFlag: number = await this.getSlideSwitch();
    log.showInfo(`Get switchFlag Value, ${switchFlag}`);
    let switchFlagResult: Record<string, Object> = {
      'itemName': itemName,
      'switchFlag': switchFlag,
    }
    getResult = {
      code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
      result: switchFlagResult
    }
    log.showInfo(`getSettingSwitch end`);
    return getResult;
  }

  async getSlideSwitch(): Promise<number> {
    let hiSearchStatus: boolean = false;
    let applicationContext = ContextManager.getContext()?.getApplicationContext();
    let callback = async (callbackContext: common.Context) => {
      try {
        let preference: data_preferences.Preferences = await data_preferences.getPreferences(
          callbackContext, PREFERENCE_FILE_NAME);
        let currentStatus: boolean = await preference.get(KEY_SEARCH_STATUS, true) as boolean;
        log.showInfo(`getSlideSwitch currentStatus:` + currentStatus);
        hiSearchStatus = await preference.get(KEY_SEARCH_STATUS, true) as boolean;
        log.showInfo(`Get ${KEY_SEARCH_STATUS} Value, ${hiSearchStatus}`);
      } catch (e) {
        log.showInfo(`Preference Error, ${(e as BusinessError).message}`);
      }
    };
    await ContextModifyUtils.modifyTargetContextAsync(applicationContext, contextConstant.AreaMode.EL1, callback,
      `${TAG}-getSlideSwitch`);
    let switchFlag: number = hiSearchStatus ? 0 : 1;
    return switchFlag;
  }

  async checkSettingSwitch(itemName: string): Promise<insightIntent.ExecuteResult> {
    let checkResult: insightIntent.ExecuteResult = {
      code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
      result: {}
    }

    try {
      let rsp: Record<string, Object> = {
        'itemName': itemName,
        'isSupport': true,
      }
      log.showInfo(`${itemName} isSupport:true `);
      checkResult = {
        code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
        result: rsp
      }
    } catch (e) {
      log.showInfo(`Preference Error, ${(e as BusinessError).message}`);
    }
    return checkResult;
  }
}