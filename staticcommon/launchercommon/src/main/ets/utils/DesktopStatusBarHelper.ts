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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { editModeManager } from '../editmode/model/EditModeManager';

const TAG = 'DesktopStatusBarHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 桌面状态栏显示兜底
 */
export class DesktopStatusBarHelper {
  /**
   * 桌面获焦时兜底恢复状态栏（多任务返回桌面等场景）
   *
   * @param reason 调用来源，便于日志追踪
   */
  public static ensureVisibleOnDesktop(reason: string): void {
    if (editModeManager.isInEditMode()) {
      log.showInfo(`skip ensureVisible, in edit mode, reason=${reason}`);
      return;
    }
    if (ViewManagerPolicy.getViewController(ViewType.KEYGUARD)?.isShowing()) {
      log.showInfo(`skip ensureVisible, keyguard showing, reason=${reason}`);
      return;
    }
    const isViewShowing: boolean = ViewManagerPolicy.isViewShowing(ViewType.STATUS_BAR);
    const isForceHidden: boolean = SCBSceneSessionManager.getInstance().isStatusBarForceHidden();
    if (isViewShowing && !isForceHidden) {
      return;
    }
    log.showWarn(`restore status bar on desktop, viewShowing=${isViewShowing}, forceHidden=${isForceHidden}, reason=${reason}`);
    if (!isViewShowing) {
      ViewManagerPolicy.showView(ViewType.STATUS_BAR);
    }
    SCBSceneSessionManager.getInstance().enterRecentTask(false, false);
  }
}
