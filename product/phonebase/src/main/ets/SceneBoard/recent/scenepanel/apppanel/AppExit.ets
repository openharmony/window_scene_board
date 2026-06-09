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
import curves from '@ohos.curves';
import systemParameter from '@ohos.systemParameterEnhance';
import { AnimateExArgsType, AnimateExManager } from '@ohos/windowscene/Index';
import {
  AnimateToScheduleUtils,
  LogDomain,
  LogHelper,
  DomainName,
  TraceUtil
} from '@ohos/basicutils';
import { SCBSceneContainerSession, SCBScenePanelManager, SCBTransitionManager, } from '@ohos/windowscene';
import { ApsUtils, localEventManager } from '@ohos/frameworkwrapper';
import { CommonConstants } from '@ohos/launchercommon';
import { PageDesktopModel, StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { performanceMonitor } from '@kit.ArkUI';
import { QuitAppRectViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/QuitAppRectViewModel';

const TAG = 'AppExit';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class AppExit {
  private readonly panelManager: SCBScenePanelManager;
  private isNewStyle: boolean = false;
  public animateManager: AnimateExManager = new AnimateExManager('AppExit');

  constructor(panelManager: SCBScenePanelManager) {
    this.panelManager = panelManager;
    this.isNewStyle = (systemParameter.getSync('sceneboard.isNewStyle', 'true') === 'true');
    this.createAnimations();
  }

  private createAnimations(): void {
    this.createSceneSessionTransitionOutAnimation();
  }

  private createSceneSessionTransitionOutAnimation(): void {
    this.animateManager.new('sceneSessionTransitionOutAnimation',
      { curve: curves.springMotion((this.isNewStyle ? 0.55 : 0.42), 1, 0) },
      /* event = */(...args: AnimateExArgsType[]) => {
        let sceneContainerSession = args[0] as SCBSceneContainerSession;
        let appExitInfo = QuitAppRectViewModel.getInstance().buildAppExitInfo(sceneContainerSession);
        let iconRect = appExitInfo?.iconRect;
        sceneContainerSession.onTransitionActiveToRect(iconRect);
        if (!iconRect) { // 中心退出动画，窗口透明度曲线和缩放曲线保持一致
          sceneContainerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0.0, TAG,
            'sceneSessionTransitionOutAnimation', sceneContainerSession.getName());
        } else {
          this.panelManager.onBlurTransitionInactive();
        }
      },
      /*onFinish = */(...args: AnimateExArgsType[]) => {
        let sceneContainerSession = args[0] as SCBSceneContainerSession;
        let appExitInfo = QuitAppRectViewModel.getInstance().buildAppExitInfo(sceneContainerSession);

        SCBTransitionManager.getInstance().reduceStartExitAnimationCount();

        AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
        //ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_DESKTOP, StyleConstants.DEFAULT_0);
        this.recordExitAppAnimationEndLogs();
        let companionIconInfo = sceneContainerSession.companionIconInfo;
        let event = `${CommonConstants.EVENTHUB_APP_LAUNCH_STATE}${companionIconInfo?.bundleName}` +
          `${companionIconInfo?.abilityName}${companionIconInfo?.moduleName}`;
        localEventManager.sendLocalEventSticky(event, false);
        SCBTransitionManager.getInstance().runAppExitToFolderEndCallback(appExitInfo?.appInFolderInfo?.folderId,
          appExitInfo?.appInFolderInfo?.index);
      }, true /* immediately */)
  }

  private recordExitAppAnimationEndLogs(): void {
    performanceMonitor.end('LAUNCHER_APP_SWIPE_TO_HOME');
    performanceMonitor.end('LAUNCHER_APP_BACK_TO_HOME');
    TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_EXIT_APP_ANIMATION);
    log.showInfo('%{public}s end.', TraceUtil.CORE_METHOD_EXIT_APP_ANIMATION);
  }
}