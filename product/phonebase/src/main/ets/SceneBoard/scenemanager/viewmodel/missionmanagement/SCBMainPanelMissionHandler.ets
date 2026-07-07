/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { LogHelper, LogDomain, CheckEmptyUtils } from '@ohos/basicutils';
import {
  CommonResult,
  FocusChangeReason,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBScenePanelMissionHandler,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSpecificSession,
  SCBTransferSceneOpts,
  SCBStartSceneOpts,
  ContainerDataCategory
} from '@ohos/windowscene';
import { SCBScenePanelViewModel } from '../SCBScenePanelViewModel';
import { SCBVassistantMissionHandler } from './SCBVassistantMissionHandler';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = '[SCBMission]SCBMainPanelMissionHandler';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * scene mission handler on main scene panel.
 */
export class SCBMainPanelMissionHandler extends SCBScenePanelMissionHandler {
  private panelViewModel: SCBScenePanelViewModel | null = null;

  constructor(screenProperty: SCBScreenProperty) {
    super(screenProperty);
  }

  protected preSetSessionLists(): void {
    log.showInfo(this.logTag + 'preSet empty list.');
    const panelMgr = SCBScenePanelManager.getInstance(this.screenProperty);
    this.registerContainerSessionList('total', panelMgr.getSceneContainerSessionList());
    this.registerContainerSessionList('notShowRecent', panelMgr.getNotShowRecentList());
    this.registerContainerSessionList('floating', panelMgr.getFloatingSessionList());
  }

  protected preSetMissionTemplates(): void {
    log.showInfo(this.logTag + 'preSet empty templates.');
  }

  public setViewModel(vm: SCBScenePanelViewModel | null): void {
    this.panelViewModel = vm;
    SCBVassistantMissionHandler.getInstance().setStartSceneFromOther((info: SCBSceneInfo) => {
      this.panelViewModel?.onStartSceneFromOther(info);
    });
    SCBVassistantMissionHandler.getInstance().setBackExitOneStepToFull((currContainerSession: SCBSceneContainerSession,
      persistentId: number) => {
      this.panelViewModel?.backExitOneStepToFullCallback(currContainerSession, persistentId);
    });
  }

  onPopSceneOut(persistentId: number, sceneInfo: SCBSceneInfo, opts: SCBTransferSceneOpts): SCBSceneSession | null {
    const needHookFinishCallback = (opts.transferFinishedCallback != null);
    log.showInfo(`onPopSceneOut persistentId: ${persistentId}, sceneInfo: ${sceneInfo?.getName()}, ` +
      `hookFinish: ${needHookFinishCallback}`);
    let targetSession: SCBSceneSession | null = null;
    if (needHookFinishCallback) {
      let newOpts: SCBTransferSceneOpts = {
        needBackground: opts.needBackground,
        needUpdateScreenId: opts.needUpdateScreenId,
        params: opts.params,
        transferFinishedCallback: (session: SCBSceneSession): void => {
          if (!session) {
            log.showError('null session when popSceneSession finished');
            return;
          }
          log.showInfo('onPopSceneOut hook finished');
          this.postProcessAfterPopTargetSession(opts);
          opts.transferFinishedCallback?.(session);
        }
      }
      targetSession = this.panelViewModel?.popSceneSession(persistentId, sceneInfo, newOpts) ?? null;
    } else {
      targetSession = this.panelViewModel?.popSceneSession(persistentId, sceneInfo, opts) ?? null;
    }
    if (!targetSession) {
      log.showError(`onPopSceneOut not find`);
      return null;
    }
    this.panelViewModel?.updateCallerSessionIdAndToSessionId(targetSession, 0);
    if (opts?.needBackground || opts?.needRefreshFocus) {
      SCBSceneSessionManager.getInstance().requestUnfocus(targetSession.persistentId, FocusChangeReason.BACKGROUND);
    }
    if (!needHookFinishCallback) {
      this.postProcessAfterPopTargetSession(opts);
    }
    return targetSession;
  }

  private postProcessAfterPopTargetSession(opts?: SCBTransferSceneOpts): void {
  }

  onPushSceneIn(session: SCBSceneSession, opts: SCBTransferSceneOpts): CommonResult {
    if (!session) {
      log.showWarn('onPushSceneIn, invalid session.');
      return CommonResult.FAIL;
    }
    log.showInfo(`onPushSceneIn of ${session.sceneInfo?.persistentId}, will background: ${opts.needBackground}`);

    session.sceneInfo.screenId = this.screenId;
    SCBSceneSessionManager.getInstance().updateSessionDisplayId(session.persistentId, this.screenId);
    const scbSceneSession = new SCBSceneSession(session.session, session.sceneInfo);
    scbSceneSession.isAutoStartPiP = session.isAutoStartPiP;
    scbSceneSession.restorePiPStatus = session.restorePiPStatus;
    session.sessionData?.systemBarProperty?.forEach((property) => {
      scbSceneSession.systemBarProperty.set(property.type, property.clone());
      if (property.type === sceneSessionManager.SessionType.TYPE_STATUS_BAR) {
        scbSceneSession.setIsSetStatusBarColor(session.sessionData.isSetStatusBarColor);
        scbSceneSession.setStatusBarEnable(session.sessionData.isSetStatusBarEnable);
        scbSceneSession.setIsFollowAppColorMode(session.sessionData.isFollowAppColorMode);
      }
    });
    session.subSessionList.forEach((item: SCBSpecificSession) => {
      if (CheckEmptyUtils.isEmpty(item)) {
        log.showWarn('[SCBMain] item of subSessionList is empty');
        return;
      }
      SCBSceneSessionManager.getInstance().updateSessionDisplayId(item.session.persistentId,
        this.screenProperty.screenId);
      scbSceneSession.subSessionList.push(item);
    });

    let containerSession = new SCBSceneContainerSession(scbSceneSession, this.screenProperty);
    containerSession.getData(ContainerDataCategory.BASIC)?.setLastUsedPosition(DeviceHelper.getCurrentDeviceScene());
    // start scene
    if (opts?.needBackground) {
      containerSession.requestBackground();
      this.panelViewModel?.getPanelManager().addSceneContainerSessionByList([containerSession]);
    } else {
      // add to notShow before start
      if (opts && opts.params && opts.params['floatingSceneToFull'] === true) {
        log.showInfo('set isFloatingSceneToFullForCast: true')
        containerSession.isFloatingSceneToFullForCast = true;
      }
      this.panelViewModel?.getContainerSessionListNotShowRecent().add(containerSession);
      this.panelViewModel?.onStartSceneFromOther(session.sceneInfo, undefined, opts);
    }
    return CommonResult.SUCCESS;
  }
}