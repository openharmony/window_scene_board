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
import { LogDomain, LogHelper, SingletonHelper, Trace } from '@ohos/basicutils';
import { EvtBus, GlobalContext, localEventManager, StartSceneFromOtherEvent } from '@ohos/frameworkwrapper';
import {
  SCBSceneSessionManager,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneSession,
  SCBSessionRect,
  SCBSessionEventId
} from '@ohos/windowscene';
import { CommonConstants, EventConstants, StyleConstants } from '@ohos/launchercommon';
import sceneSessionManager from '@ohos.sceneSessionManager';
import BundleManager from '@ohos.bundle.bundleManager';
import { sceneAnimationManager } from '../instance/SceneAnimationManager';
import { curves } from '@kit.ArkUI';

const TAG = 'SCBPcModeUtil';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class Pointer2D {
  public x: number;
  public y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

/*
 * @deprecated 后续不再使用此类，工具函数拆分到各模块中
 */
export class SCBPcModeUtil{

  // 隐藏App中心
  public hideAppCenter(): void {
    if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
      log.showInfo('hideAppCenter.');
      let hideAppCenterWithAnimation = (GlobalContext.getInstance()
        .getObject('hideAppCenterWithAnimation')) as Function;
      hideAppCenterWithAnimation();
    }
  }

  public closeMenuAndPopup(): void {
    ContextMenu.close();
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_DOCK_CLOSE_POPUP);
    AppStorage.setOrCreate('isRecentPopupShow', false);
    AppStorage.setOrCreate('openFolderStatus', 0);
    AppStorage.setOrCreate('showUninstallDialog', false);
    AppStorage.setOrCreate('isPopupMenuShow', false);
  }

  public getTransitionsContext(sceneInfo: SCBSceneInfo): string[] {
    if (sceneInfo.bundleName !== CommonConstants.FILE_MANAGER_BUNDLE) {
      return [sceneInfo.bundleName, sceneInfo.abilityName];
    }
    const params = sceneInfo.want?.parameters;
    if (!params || !params['fileManagerMode'] || typeof params['fileManagerMode'] !== 'string' ||
      params['fileManagerMode'] !== 'RecycleBin') {
      return [sceneInfo.bundleName, sceneInfo.abilityName];
    }
    return [CommonConstants.LAUNCHER_BUNDLE, CommonConstants.RECYCLE_BIN_ABILITY];
  }

  /**
   * post StartSceneFromOtherEvent
   *
   * @param sceneInfo, start scene info
   */
  public postStartSceneFromOtherEvent(sceneInfo: SCBSceneInfo) {
    if (!sceneInfo) {
      log.showWarn(`sceneInfo is null`);
      return;
    }
    const bundleName = sceneInfo.bundleName;
    const abilityName = sceneInfo.abilityName;
    let event = StartSceneFromOtherEvent.getInstance(bundleName, abilityName);
    log.showInfo(`postStartSceneFromOtherEvent: ${bundleName} + ${abilityName}`);
    EvtBus.post(StartSceneFromOtherEvent, event);
  }
}

// singleton for SCBFreeformSceneUtils
export const sPcModeUtils = SingletonHelper.getInstance(SCBPcModeUtil, TAG);