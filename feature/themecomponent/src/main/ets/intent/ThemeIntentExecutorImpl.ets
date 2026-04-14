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
import { window } from '@kit.ArkUI';
import { common, Want } from '@kit.AbilityKit';
import { Log } from '../aigcServiceAbility/IdlService/Log';

const TAG: string = 'ThemeIntentExecutorImpl';
const UNDERLINE: string = '_';
const RESULT_SUCC: insightIntent.ExecuteResult = {
  code: 10150001,
  result: {
    message: 'intent execute success',
  }
};
const RESULT_FAIL: insightIntent.ExecuteResult = {
  code: 10151000,
  result: {
    message: 'intent execute fail',
  }
};

export default class ThemeIntentExecutorImpl extends InsightIntentExecutor {
  private static readonly FOREGROUND_SET_THEME: string = 'SetTheme';

  onExecuteInUIAbilityForegroundMode(name: string, param: Record<string, Object>, pageLoader: window.WindowStage)
    : insightIntent.ExecuteResult | Promise<insightIntent.ExecuteResult> {
    Log.info(TAG, `name ${name}`);
    switch (name) {
      case ThemeIntentExecutorImpl.FOREGROUND_SET_THEME:
        Log.info(TAG, `ForegroundUiAbility intent`);
        return this.jumpSettingsTheme(param, insightIntent.ExecuteMode.UI_ABILITY_FOREGROUND, pageLoader);
      default:
        break;
    }
    Log.info(TAG, `onExecuteInUIAbilityForegroundMode, invalid intent`);
    return RESULT_FAIL;
  }

  private async jumpSettingsTheme(intentParam: Record<string, Object>, executeMode: insightIntent.ExecuteMode,
                                  pageLoader: window.WindowStage): Promise<insightIntent.ExecuteResult> {
    Log.info(TAG, `jumpSettingsTheme, themeName ${intentParam?.themeName}, executeMode ${executeMode}`);

    let themeName: string = new Date().getTime().toString();
    if (intentParam && typeof intentParam.themeName === 'string') {
      themeName = intentParam.themeName + UNDERLINE + themeName; // 使用时间戳区分是否为同一次唤醒
    }
    try {
      let want: Want = {
        bundleName: 'com.ohos.settings',
        abilityName: 'com.ohos.settings.MainAbility',
        moduleName: 'phone_settings',
        uri: 'theme_settings',
        parameters: {
          'themeName': themeName, // 非空串
        }
      };
      (getContext() as common.UIAbilityContext)?.startAbility(want);
    } catch (err) {
      Log.info(TAG, `startAbility error = ${err.code}`);
      return RESULT_FAIL;
    }
    return RESULT_SUCC;
  }
}