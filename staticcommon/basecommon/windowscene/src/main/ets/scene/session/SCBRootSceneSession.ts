/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { SCBSceneInfo, SCBSceneMode } from './SCBSceneInfo';
import { SCBSceneSessionManager } from './SCBSceneSessionManager';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import { CallToState } from '@ohos/commonconstants';
import { SCBConstants } from '@ohos/commonconstants';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ObjUtil } from '@ohos/basicutils';
import { SCBSceneSession } from './SCBSceneSession';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { FORM_ID_PARAM } from '../common/SCBSceneConstants';
import Want from '@ohos.app.ability.Want';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { SCBSceneMissionManager } from '../manager/SCBSceneMissionManager';
import { bundleManager } from '@kit.AbilityKit';
import { CommonResult } from '../../scene/utils/SCBSceneUtils';

const TAG = 'SCBRootSceneSession';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const INVALID_SCREEN_ID = -1;
const MID_SCENE_NOTIFICATION = 'midSceneNotification';
/**
 * Scene session of the root scene.
 */
export class SCBRootSceneSession {
  readonly session: sceneSessionManager.RootSceneSession;
  usrId: number = -1;

  constructor() {
    this.session = sceneSessionManager.getRootSceneSession();
    this.session.on('pendingSceneSessionActivation', (info) => {
      SCBSceneMissionManager.getInstance().setRequestId(info, info.requestId);
      let pendingActivationRet: CommonResult = this.onPendingSceneSessionActivation(info);
      SCBSceneMissionManager.getInstance().resetRequestId(info);
      return pendingActivationRet;
    });

    this.session.on('batchPendingSceneSessionsActivation', (info) => { // need add mode
      this.onBatchPendingSceneSessionsActivation(info);
    });
  }

  /**
   * Load the ui content of the root scene.
   *
   * @param { String } path
   * @param { ServiceExtensionContext } context
   * @param { LocalStorage } storage
   */
  public loadContent(path: string, context: ServiceExtensionContext, storage?: LocalStorage): void {
    this.session.loadContent(path, context, storage);
  }

  private isEmergencyCallToCallUI(toSceneInfo: SCBSceneInfo, fromSceneInfo: SCBSceneInfo): boolean {
    if (!toSceneInfo || !fromSceneInfo) {
      log.showError('toSceneInfo or fromSceneInfo is null');
      return false;
    }
    return toSceneInfo.bundleName === 'com.ohos.callui' && toSceneInfo.abilityName === 'com.ohos.callui.MainAbility' &&
      fromSceneInfo.bundleName === 'com.ohos.callui' && fromSceneInfo.abilityName === 'com.ohos.emergencyCall.EmergencyCallAbility';
  }

  private isFloatingOrMidSceneNotification(sceneInfo: sceneSessionManager.SceneInfo): boolean | Object {
    return sceneInfo.windowMode === SCBSceneMode.FLOATING ||
      (sceneInfo.want?.parameters && sceneInfo.want?.parameters[MID_SCENE_NOTIFICATION]);
  }

  private onBatchPendingSceneSessionsActivation(sceneInfoList: sceneSessionManager.SceneInfo[]): void {
    log.showInfo('SCBRootSceneSession call onBatchPendingSceneSessionsActivation');
    // 去除重复sceneInfo
    sceneInfoList = sceneInfoList.filter(
      (item, index, self) => {
        log.showInfo(`onBatchPendingSceneSessionsActivation originate sceneInfoList
          persistentId ${item.persistentId} bundleName ${item.bundleName} moduleName
          ${item.moduleName} abilityName ${item.abilityName} appIndex ${item.appIndex}`);
        let firstMatchIndex: number =
          self.findIndex((i) => (i.bundleName === item.bundleName && i.abilityName === item.abilityName));
        return index === firstMatchIndex;
      }
    );
    if (!sceneInfoList || sceneInfoList.length < 1 || sceneInfoList.length > 3) {
      log.showError(`onBatchPendingSceneSessionsActivation, sceneInfoList len ${sceneInfoList.length} is invalid`);
      return;
    }
    if (sceneInfoList.length === 1) {
      this.onPendingSceneSessionActivation(sceneInfoList[0]);
      return;
    }
    let toSceneInfoList: SCBSceneInfo[] = new Array(sceneInfoList.length);
    sceneInfoList.forEach((v, i) => {
      toSceneInfoList[i] = this.updateSceneInfo(v);
      SCBSceneMissionManager.getInstance().notifySessionPendingActivation(toSceneInfoList[i], undefined);
    });
    const managerInstance = SCBSceneSessionManager.getInstance();
    managerInstance.startSceneTransition(toSceneInfoList, undefined, false);
  }

  private onPendingSceneSessionActivation(sceneInfo: sceneSessionManager.SceneInfo): CommonResult {
    log.showInfo('onPendingSceneSessionActivation sceneInfo.persistentId:' + sceneInfo.persistentId +
      ' callState: ' + sceneInfo.callState + ' callerPersistentId: ' + sceneInfo.callerPersistentId +
      ' windowMode: ' + sceneInfo.windowMode + ' appIndex: ' + sceneInfo.appIndex +
      ' needClearInNotShowRecent: ' + sceneInfo.needClearInNotShowRecent +
      'deviceTypes: ' + sceneInfo.atomicServiceInfo?.deviceTypes +
      ' resizable: ' + sceneInfo.atomicServiceInfo?.resizable +
      ' supportWindowMode: ' + sceneInfo.atomicServiceInfo?.supportWindowMode);
    let info = this.updateSceneInfo(sceneInfo);
    SCBSceneMissionManager.getInstance().notifySessionPendingActivation(info);
    this.fixScreenId(info);
    if (sceneInfo.windowMode === AbilityConstant.WindowMode.WINDOW_MODE_FULLSCREEN) {
      info.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    } else if (sceneInfo.windowMode === AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_PRIMARY) {
      info.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
    } else if (sceneInfo.windowMode === AbilityConstant.WindowMode.WINDOW_MODE_SPLIT_SECONDARY) {
      info.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
    } else if (this.isFloatingOrMidSceneNotification(sceneInfo)) {
      return this.startFloatingFromNotification(info, sceneInfo);
    }
    const screenName: string = SCBScreenSessionManager.getInstance().getScreenSession(info.screenId)?.session.name;
    log.showInfo('onPendingSceneSessionActivation sceneInfo.screenName:' + (screenName || ''));
    if (this.isCastVirtualDisplay(screenName) || screenName === 'DevEcoViewer' || screenName === 'VoiceView') {
      return SCBSceneSessionManager.getInstance().startSceneInVirtual(info);
    }
    if (screenName === 'SubScreen' && DeviceHelper.isSmallFoldProduct()) {
      return SCBSceneSessionManager.getInstance().startSceneInVirtual(info);
    }
    let startResult: CommonResult = CommonResult.SUCCESS;
    if (sceneInfo.callState !== CallToState.UNKNOWN) {
      startResult = SCBSceneSessionManager.getInstance().startSceneByCall(info, null);
    } else {
      const isPcOrPcMode = SCBSceneSessionManager.getInstance().isPcOrPcMode();
      const isHiddenStart = sceneInfo.processOptions?.startupVisibility ===
      sceneSessionManager.StartupVisibility.STARTUP_HIDE;
      if (isPcOrPcMode && isHiddenStart) {
        info.isHide = true;
        return SCBSceneSessionManager.getInstance().hiddenStartSceneFromOther(info);
      }

      let callerSession = SCBSceneSessionManager.getInstance().getSessionById(sceneInfo.callerPersistentId);
      let callerContainer =
        SCBSceneSessionManager.getInstance().getFloatingSessionList().findByPersistentId(sceneInfo.callerPersistentId);
      if (callerSession instanceof SCBSceneSession &&
        !this.isEmergencyCallToCallUI(info, callerSession.sceneInfo) && !callerContainer?.isFloat) {
        startResult = SCBSceneSessionManager.getInstance().startSceneTransition(info, callerSession.sceneInfo);
      } else {
        startResult = this.startSceneFromOther(sceneInfo, info);
      }
    }
    this.bindAttribute(sceneInfo, info);
    return startResult;
  }

  private isCastVirtualDisplay(screenName: string): boolean {
    return screenName === 'CastEngine' || screenName === 'PadWithCar';
  }

  private updateSceneInfo(sceneInfo: sceneSessionManager.SceneInfo): SCBSceneInfo {
    let info = new SCBSceneInfo(sceneInfo.bundleName, sceneInfo.moduleName, sceneInfo.abilityName, sceneInfo.appIndex);
    info.persistentId = sceneInfo.persistentId;
    info.callState = sceneInfo.callState;
    info.callerPersistentId = sceneInfo.callerPersistentId;
    info.callerBundleName = sceneInfo.callerBundleName;
    info.callerAbilityName = sceneInfo.callerAbilityName;
    info.screenId = sceneInfo.screenId;
    info.windowWidth = sceneInfo.windowWidth;
    info.windowHeight = sceneInfo.windowHeight;
    info.windowLeft = sceneInfo.windowLeft;
    info.windowTop = sceneInfo.windowTop;
    info.withAnimation = sceneInfo.withAnimation;
    info.focusedOnShow = sceneInfo.focusedOnShow;
    info.isAtomicService = sceneInfo.isAtomicService;
    info.isStartupInstallFree = sceneInfo.isStartupInstallFree;
    info.needClearInNotShowRecent = sceneInfo.needClearInNotShowRecent;
    info.isFromIcon = sceneInfo.isFromIcon;
    info.want = sceneInfo.want;
    info.requestId = sceneInfo.requestId;
    // The priority of system is higher than public, and only one of them can exist.
    if (!!sceneInfo.startAnimationSystemOptions) {
      info.startAnimationSystemOptions = sceneInfo.startAnimationSystemOptions;
    } else if (!!sceneInfo.startAnimationOptions) {
      info.startAnimationOptions = sceneInfo.startAnimationOptions;
    }
    info.atomicServiceInfo = sceneInfo.atomicServiceInfo;
    info.specifiedFlag = sceneInfo.specifiedFlag;
    return info;
  }

  private fixScreenId(info: SCBSceneInfo): void {
    info.screenId = info.screenId !== INVALID_SCREEN_ID ?
      info.screenId : SCBSceneSessionManager.getInstance().mainScreenId;
  }

  private startFloatingFromNotification(info: SCBSceneInfo,
    sceneInfo: sceneSessionManager.SceneInfo): CommonResult {
    log.showInfo('try to start %{public}s floating window from notification', info.bundleName);
    info.updateWindowModeAndSync(sceneInfo.windowMode);
    const want: Want = {
      parameters: { 'floatingDisplayMode': sceneInfo.floatingDisplayMode }
    };
    info.want = want;
    return SCBSceneSessionManager.getInstance().startSceneFromNotification(info);
  }

  private bindAttribute(sceneInfo: sceneSessionManager.SceneInfo, info: SCBSceneInfo): void {
    let isCalledRightlyByCallerId = sceneInfo.isCalledRightlyByCallerId;
    if (isCalledRightlyByCallerId !== undefined && isCalledRightlyByCallerId !== null) {
      info.isCalledRightlyByCallerId = sceneInfo.isCalledRightlyByCallerId;
    }
  }

  private startSceneFromOther(sceneInfo: sceneSessionManager.SceneInfo, info: SCBSceneInfo): CommonResult {
    log.showInfo(`fileManagerMode: ${sceneInfo.fileManagerMode}, extraFormIdentity: ${sceneInfo.extraFormIdentity}`);

    const cardIdFromOtherStartAbility: string | undefined =
      sceneInfo.want?.parameters['ohos.ability.params.cardId'] as string;
    if (cardIdFromOtherStartAbility) {
      ObjUtil.setNested(info, ['want', 'parameters', FORM_ID_PARAM], cardIdFromOtherStartAbility);
    } else {
      ObjUtil.setNested(info, ['want', 'parameters', FORM_ID_PARAM], sceneInfo.extraFormIdentity ?? '');
    }

    return SCBSceneSessionManager.getInstance().startSceneFromOther(info);
  }
}
