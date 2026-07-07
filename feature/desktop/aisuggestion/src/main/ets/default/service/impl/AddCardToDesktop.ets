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

import { BundleConstants, FormCenterViewManager, IExecutor, LayoutViewModel } from '@ohos/launchercommon';
import { DeviceHelper, GlobalContext, sOutSideWindowMgr } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';

const TAG = 'AddCardToDesktop';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);
const INVALID_SCREEN_ID: number = -1;
const DELAY_OPEN_FORM_CENTER: number = 600;
const EVENT_INTELLIGENT_CLOSE_SCB: string = 'intelligent_close_SCBNegativeScreen';

/**
 * 语音助手建议加桌操作
 *
 * @since 2024-07-10
 */
export class AddCardToDesktop implements IExecutor {
  async execute(extra?: object): Promise<string> {
    log.showInfo('execute');
    // 桌面处于简易布局模式，禁止加桌
    if (LayoutViewModel.getInstance().isSimpleLauncherMode()) {
      log.showWarn('execute isSimpleLauncherMode');
      return Response.FAIL;
    }
    FormCenterViewManager.getInstance().closeFormManagerView();
    SCBSceneSessionManager.getInstance().minimizeAllScene(INVALID_SCREEN_ID);

    // 关闭搜索框，防止在桌面下拉搜索点击加桌按钮搜索框挡住卡片中心半模态
    sOutSideWindowMgr.hideGlobalSearch(false);
    // 退出负一屏，防止负一屏点击加桌按钮负一屏挡住卡片中心半模态
    GlobalContext.getContext()?.eventHub?.emit(EVENT_INTELLIGENT_CLOSE_SCB);
    setTimeout(() => {
      let param: FormCenterViewParam = new FormCenterViewParam();
      param.bundleName = BundleConstants.AI_SUGGESTION_BUNDLE;
      FormCenterViewManager.getInstance().openFormManagerView(param);
    }, DELAY_OPEN_FORM_CENTER);
    return Response.SUCCESS_OK;
  }
}