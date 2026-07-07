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

import InsightIntentExecutor from '@ohos.app.ability.InsightIntentExecutor';
import {
  LogDomain,
  Logger
} from '@ohos/basicutils';
import { window } from '@kit.ArkUI';
import insightIntent from '@ohos.app.ability.insightIntent';
import lazy {
  SCBSceneWindowAiSplitSwitchUtils
} from '@ohos/windowscene/src/main/ets/scene/utils/SCBSceneWindowAiSplitSwitchUtils';

const TAG: string = 'IntentExecutorAdaptor';
const log: Logger = Logger.getLogHelper(LogDomain.WINDOW);

/**
 * AI多窗分屏意图执行类
 *
 * @since 2025-06-03
 */
export default class SplitIntentExecutorAdapter extends InsightIntentExecutor {

  // 拉起分屏意图
  private static readonly VIEW_SPLIT_SCREEN = 'ViewSplitScreen';

  /**
   * 执行后台UIAbility意图
   *
   * @param name 意图名称
   * @param param 意图参数
   * @return 意图调用结果
   */
  onExecuteInUIAbilityBackgroundMode(name: string, param: Record<string, Object>):
    Promise<insightIntent.ExecuteResult> {
    log.showInfo(TAG, `[ExecuteIntent] start execute SplitIntent`);
    if (name === SplitIntentExecutorAdapter.VIEW_SPLIT_SCREEN) {
      return this.viewSplitScreen(param);
    }
    return Promise.resolve({
      code: -1,
      result: {
        message: 'unknown intent'
      }
    } as insightIntent.ExecuteResult);
  }

  /**
   * 实现拉起分屏能力
   *
   * @param param 意图参数
   * @return 分屏意图执行结果
   */
  private viewSplitScreen(param: Record<string, Object>): Promise<insightIntent.ExecuteResult> {
    log.showInfo(TAG, '[ExecuteIntent] start intent: view split screen');
    SCBSceneWindowAiSplitSwitchUtils.getInstance().notifyListenerToSplitScreen();
    return Promise.resolve({
      code: 0,
      result: {
        message: 'view split intent'
      }
    } as insightIntent.ExecuteResult);
  }
}