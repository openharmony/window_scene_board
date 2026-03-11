/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { ActiveReason, SCBSceneSession} from './SCBSceneSession';
import { ScbNumber, SCBSessionRect } from './SCBSessionRect';
import { SceneParam, SCBDividerParam, isLargeFoldProductInExpand } from './SCBDividerParam';
import { SCBAppIconParam } from './SCBAppIconParam';
import { SCBScreenProperty, SCBScreenSession } from './../../screen/session/SCBScreenSession';
import { SCBSceneMode } from './SCBSceneInfo';
import { SCBRecentSessionHelper, SCBRecentSessionInfo } from './SCBRecentSessionInfo';
import { SCBSceneOrientation } from './SCBSceneOrientation';
import { SCBSceneOrientationUtils } from '../utils/SCBSceneOrientationUtils';
import type { SCBSceneInfo } from './SCBSceneInfo';
import { RectInfo } from '@ohos/basicutils';
import { SplitType, OneStepSplitType, SCBConstants, RotationConstants,
  DividerStyleConstants,
  CommonConstants} from '@ohos/commonconstants';
import { CommonUtils, CompanionIconInfo } from '@ohos/basicutils';
import { SCBDeviceScreenConfig } from '../../config/SCBDeviceScreenConfig';
import { SCBPropertyChangeReason } from '../../screen/session/SCBScreenSessionManager';
import {
  SCBFollowDesktopOrientationPolicy,
  SCBDefaultOrientationPolicy
} from './SCBSceneOrientationPolicy';
import type { SCBSystemSceneSession } from './SCBSystemSceneSession';
import type { SCBTransitionController } from '../../animation/SCBTransitionController';
import { SCBSceneSessionManager, PreferMultiWindowOrientation, SCBSpecificSceneSessionList } from './SCBSceneSessionManager';
import { SCBTransitionManager } from '../../animation/SCBTransitionManager';
import { SCBDesktopCacheManager, SCBUltraScreenState } from '@ohos/frameworkwrapper';
import lazy { SCBTriFoldManager } from '@ohos/frameworkwrapper/src/main/ets/utils/SCBTriFoldManager';
import { StartType } from '@ohos/basicutils';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import sceneSessionManager from '@ohos.sceneSessionManager';
import display from '@ohos.display';
import { SCBSplitParam, SplitLifeCycle, SplitRatioEnum } from './SCBSplitParam';
import { SCBMidSceneParam } from './SCBMidSceneParam';
import { LogDomain, LogHelper, DomainName } from '@ohos/basicutils';
import { FSM } from '../../recent/Fsm';
import { OverlayCardTransition } from '../../bean/OverlayCardData';
import { SCBFloatingParam, FloatingScenePadLayoutStyle } from './SCBFloatingParam';
import { SCBExpandGuideParam } from './SCBExpandGuideParam';
import { image } from '@kit.ImageKit';
import { AttributeUpdater, CommonModifier, Position } from '@kit.ArkUI';
import { StartAppConfig } from '../../config/StartAppConfig';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import transactionManager from '@ohos.transactionManager';
import { AnimateToScheduleUtils } from '@ohos/basicutils';
import { IntelligentCache } from '@ohos/frameworkwrapper';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { IconResourceManager } from '@ohos/frameworkwrapper';
import { SCBSpecificSession } from './SCBSpecificSession';
import { SCBWindowRotateController } from '../manager/SCBWindowRotateController';
import { SCBSideEdgeManagerParam } from './SCBSideEdgeManagerParam';
import lazy { MidSceneConfig } from '../midScene/MidSceneConfig';
import { ViewManagerPolicy, ViewType } from '@ohos/frameworkwrapper';
import { IContainerSessionData } from '../framework/containerdata/IContainerSessionData';
import { ContainerDataCategory, ContainerStateCategory, SceneDataCategory, BackgroundReason } from '../common/SCBSceneEnums';
import { ContainerDataOfBasic } from '../framework/containerdata/ContainerDataOfBasic';
import { ContainerSessionFilter, SCBRotationConfig, SCBSceneMissionManager } from '../../TsIndex';
import { ContainerSessionInitializer } from '../framework/strategy/containerstrategy/initstrategy/ContainerSessionInitializer';
import { MissionManagementTraceUtil, SCBSceneUtils } from '../utils/SCBSceneUtils';
import lazy {  SCBSplitUtils } from '../utils/SCBSplitUtils';
import { TraceUtil } from '@ohos/basicutils';
import { IContainerSessionState } from '../framework/containerstate/IContainerSessionState';
import { ContainerStateOfBasic } from '../framework/containerstate/ContainerStateOfBasic';
import { ContainerStateOfMissionManagement } from '../framework/containerstate/ContainerStateOfMissionManagement';
import { ContainerDataOfMissionManagement } from '../framework/containerdata/ContainerDataOfMissionManagement';
import { WinLog, WinLogDomain } from '../../utils/WinLog';

const TAG = 'SCBSCS';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const WINDOW_SCALE: number = 0.2;
const HALF = 2;

const BIT_MASK = 0xffff;
const DEFAULT_SCALE: number = 0.035;
const SESSION_ZERO: number = 0;
const SESSION_ONE: number = 1;
const SESSION_TWO: number = 2;
const SESSION_THREE: number = 3;

export class SCBNavBarStyle {
  // screen rotation
  static readonly DEFAULT_NAV_BAR_HORIZONTAL_W = '25%';
  static readonly DEFAULT_NAV_BAR_HORIZONTAL_H = '30%';
  static readonly DEFAULT_NAV_BAR_VERTICAL_W = '35%';
  static readonly DEFAULT_NAV_BAR_VERTICAL_H = '25%';
  static readonly DEFAULT_NAV_BAR_VERTICAL_POS_H = '97%';
  static readonly DEFAULT_NAV_BAR_HORIZONTAL_POS_H = '92%';
}

export enum SCBContainerRotationReason {
  SCREEN_ROTATION = 0, // rotate from screen
  START_SCENE,
  EXIT_SCENE,
  SPLIT_SCENE,
  LANDSCAPE_ONE_STEP_SCENE, // rotate when enter one step split
  CRASH_SCENE,
  PANEL_ROTATION, // rotate from scene panel
  EXPAND_ROTATION,
  ENTER_FREEFORM_SCENE_MODE, // enter free scene mode
  QUIT_FREEFORM_SCENE_MODE, // quit free scene mode
  EXIT_RECENT,
  MID_SCENE,
  LANDSCAPE_ONE_STEP_FLOAT_SCENE,
  SINGLE_HAND_STATUS_CHANGE
}

export enum PreBuildStage {
  NOT_PRE_BUILD = 0,
  PRE_BUILD_TITLE = 1,
  PRE_BUILD_SCENE = 2,
  PRE_BUILD_SCENE2 = 3,
  PRE_BUILD_DONE = 4,
}

export enum SingleStartFrom {
  START_FROM_FOLD = 0,
  START_FROM_EXPAND = 1,
}

export enum SplitState {
  UNDEFINED = 0,
  ONESTEP,
  EXIT_ONESTEP_TO_SPLIT,
  SPLIT,
  EXIT_SPLIT
}

export enum SCBSceneContainerState {
  /* unknow */
  UNDEFINED = -1,
  HIDDEN = 0,
  /* display single full-screen app */
  FULL_SCREEN,
  /* display double app in split */
  SPLIT,
  /* display single app for one-step */
  ONE_STEP,
  /* in float state */
  FLOAT,
  /* in mini float */
  MINI_FLOAT,
  /* in recent */
  RECENT,
  MID_SCENE
}

/**
 * Split divider background is visible or not
 * split style for expand mode
 * -1 in fold mode
 * 0 for left and right split
 * 1 for up and down split
 */
export enum SplitStyle {
  UNDEFINED = -1,
  LEFT_AND_RIGHT_POS = 0,
  UP_AND_DOWN_POS = 1
}

export interface CloseContainerParam {
  bundleName: string,
  appIndex: number
}

export class SCBCloseContainerArray extends Array<CloseContainerParam> {
  /**
   * Adds a scene container session to the array
   *
   * @param { CloseContainerParam } closeContainerParam
   * @return { Boolean } If the adding is successful, true is returned. Otherwise, false is returned.
   */
  public add(closeContainerParam: CloseContainerParam): boolean {
    if (!closeContainerParam) {
      log.showError('closeContainerParam is null.');
      return false;
    }
    let index = this.findIndexForCloseList(closeContainerParam);
    if (index === -1) {
      this.push(closeContainerParam);
      return true;
    }
    log.showWarn(`add failed. ${closeContainerParam.bundleName} already existed in array`);
    return false;
  }

  /**
   * Find the index of an element in an array based on the param
   *
   * @param { CloseContainerParam } closeContainerParam
   * @returns { Number } Returns the index of the found element in the array, or -1 if not found
   */
  private findIndexForCloseList(closeContainerParam: CloseContainerParam): number {
    return this.findIndex((item) => {
      return (item.bundleName === closeContainerParam.bundleName && item.appIndex === closeContainerParam.appIndex);
    });
  }

  /**
   * Find the index of an element in an array based on the param
   *
   * @param { CloseContainerParam } closeContainerParam
   * @returns { void }
   */
  public deleteContainer(closeContainerParam: CloseContainerParam): void {
    let index = this.findIndexForCloseList(closeContainerParam);
    if (index === -1) {
      log.showError(`delete container faild, not exist, ${closeContainerParam.bundleName}`);
      return;
    }
    let ret = this.splice(index, 1);
    if (ret.length > 0) {
      log.info(`delete container: ${closeContainerParam.bundleName}`);
    }
  }

  /**
   * Find the index of an element in an array based on SCBSceneSession
   *
   * @param { SCBSceneSession } session
   * @returns { Number } Returns the index of the found element in the array, or -1 if not found
   */
  public findSessionIndexForCloseList(session: SCBSceneSession): number {
    return this.findIndex((item) => {
      return (item.bundleName === session.sceneInfo.bundleName && item.appIndex === session.sceneInfo.appIndex);
    });
  }
}
@Observed
export class SCBSceneSessionArray extends Array<SCBSceneSession> {
}

@Observed
export class SCBSceneContainerSessionArray extends Array<SCBSceneContainerSession> {
  /**
   * Check if the list is empty
   *
   * @returns { boolean } If the list is empty, true is returned. Otherwise, false is returned.
   */
  public isEmpty(): boolean {
    return (this.length === 0);
  }

  /**
   * Check if the index is in range of list
   *
   */
  public isInRange(index: number): boolean {
    if (index >= 0 && index < this.length) {
      return true;
    }
    return false;
  }

  /**
   * Clear the list
   */
  public clear(): void {
    if (this.isEmpty()) {
      return;
    }
    this.splice(0, this.length);
  }

  /**
   * Find the index of an element in an array based on the container ID
   *
   * @param { Number } containerId
   * @returns { Number } Returns the index of the found element in the array, or -1 if not found
   */
  public findIndexByContainerId(containerId: number): number {
    return this.findIndex((item) => {
      return (item.containerId === containerId);
    });
  }

  /**
   * Query the SCBSceneContainerSession object based on the container ID.
   *
   * @param { Number } containerId
   * @returns { SCBSceneContainerSession | null }
   */
  public findByContainerId(containerId: number): SCBSceneContainerSession | null {
    let found = this.find((item) => {
      return item.containerId === containerId;
    });
    if (found) {
      return found;
    }
    return null;
  }

  /**
   * Search for the corresponding scenario container session based on the persistence ID.
   *
   * @param { Number } persistentId
   * @returns { SCBSceneContainerSession | null } Returns the scene container session found, or null if not found
   */
  public findByPersistentId(persistentId: number, needFoundSubSession: boolean = false): SCBSceneContainerSession | null {
    let found = this.find((item) => {
      if (item.midSceneMap.has(persistentId)) {
        return true;
      }
      let isFound = (item.primarySession?.session.persistentId === persistentId) ||
        (item.secondarySession?.session.persistentId === persistentId);
      if (isFound) {
        return true;
      }

      if (!needFoundSubSession) {
        return false;
      }

      isFound = this.findFromSubList(item.primarySession, persistentId);
      if (!isFound) {
        isFound = this.findFromSubList(item.secondarySession, persistentId);
      }
      return isFound;
    });
    if (found) {
      return found;
    }
    return null;
  }

  // 递归深度优先搜索
  private findFromSubList(sceneSession: SCBSceneSession | SCBSpecificSession, persistentId: number): boolean {
    if (!sceneSession) {
      return false;
    }
    let found = sceneSession?.subSessionList.find((item) => {
      // 当前子窗为目标窗口
      if (item.session.persistentId === persistentId) {
        return true;
      }

      let isFound = this.findFromSubList(item, persistentId);
      return isFound;
    });
    return found !== undefined;
  }

  private findSubSession(sceneSession: SCBSceneSession | SCBSpecificSession, screenId: number): boolean {
    if (!sceneSession) {
      return false;
    }
    let subsession = sceneSession?.subSessionList.find((item) => {
      // 当前子窗为目标窗口
      if (item.screenId === screenId) {
        return true;
      }

      return this.findSubSession(item, screenId);
    });
    return subsession !== undefined;
  }

  /**
   * Check is all session or subsession of container in current screen by containerId
   * @param containerId
   * @returns Returns find result.
   */
  public isContainerInScreenHasSession(containerId: number, screenId: number): boolean {
    let container = this.find((item) => {
      if (containerId !== item.containerId) {
        return false;
      }
      if (item.primarySession?.sceneInfo.screenId === screenId ||
        item.secondarySession?.sceneInfo.screenId === screenId) {
        return true;
      }
      let isFound = this.findSubSession(item.primarySession, screenId);
      if (isFound) {
        return true;
      }
      return this.findSubSession(item.secondarySession, screenId);
    });
    return container !== undefined;
  }

  /**
   * Querying an Index Based on a Persistence ID
   *
   * @param { Number } persistentId
   * @return { Number } Returns the index found, or -1 if not found
   */
  public findIndexByPersistentId(persistentId: number): number {
    return this.findIndex((item) => {
      return (item.primarySession?.session.persistentId === persistentId) ||
        (item.secondarySession?.session.persistentId === persistentId);
    });
  }

  /**
   * Querying an Index Based on a SceneInfo
   *
   * @param { SCBSceneInfo } sceneInfo
   * @return { Number } Returns the index found, or -1 if not found
   */
  public findIndexBySceneInfo(sceneInfo: SCBSceneInfo): number {
    return this.findIndex((item) => {
      return item.primarySession?.sceneInfo?.equalTo(sceneInfo) ||
        item.secondarySession?.sceneInfo?.equalTo(sceneInfo);
    });
  }

  /**
   * Adds a scene container session to the array
   *
   * @param { SCBSceneContainerSession } sceneContainerSession
   * @return { Boolean } If the adding is successful, true is returned. Otherwise, false is returned.
   */
  public add(sceneContainerSession: SCBSceneContainerSession): boolean {
    if (!sceneContainerSession) {
      return false;
    }
    let index = this.findIndexByContainerId(sceneContainerSession.containerId);
    if (index === -1) {
      this.push(sceneContainerSession);
      return true;
    }
    WinLog.showWarn(WinLogDomain.WMS_MAIN, `add failed. ${sceneContainerSession.getName()} already existed in array`);
    return false;
  }

  /**
   * Inserts a scene container session at the specified index
   *
   * @param { Number } index
   * @param { SCBSceneContainerSession } sceneContainerSession
   * @return { Boolean } If the insertion is successful, true is returned. Otherwise, false is returned.
   */
  public insert(index: number, sceneContainerSession: SCBSceneContainerSession): boolean {
    if (!sceneContainerSession) {
      return false;
    }
    if (index >= this.length) {
      return false;
    }
    let foundIndex = this.findIndexByContainerId(sceneContainerSession.containerId);
    if (foundIndex === -1) {
      this.splice(index, 0, sceneContainerSession);
      return true;
    }
    WinLog.showWarn(WinLogDomain.WMS_MAIN, `insert failed. ${sceneContainerSession.getName()} already existed in array`);
    return false;
  }

  /**
   * Get the session at the top of the stack
   *
   * @returns { SCBSceneContainerSession | null } The session at the top of the stack or null
   */
  public getTopSession(): SCBSceneContainerSession | null {
    if (this.isEmpty()) {
      return null;
    }
    return this[this.length - 1];
  }

  /**
   * Get Top Active Sessions
   *
   * @returns { SCBSceneContainerSession | null } Returns the topmost active session, or null if there is no active
   *    session.
   */
  public getTopActiveSession(isEnableMainWindowTopmost: boolean = false): SCBSceneContainerSession | null {
    if (this.isEmpty()) {
      return null;
    }
    let len = this.length;
    for (let i = len - 1; i >= 0; i--) {
      if (this[i].isActive) {
        if (this[i].isTopmost() || (this[i].isMainWindowTopmost() && isEnableMainWindowTopmost)) {
          // ignore topmost container session
          continue;
        }
        return this[i];
      }
    }
    return null;
  }

  /**
   * Get spilt Sessions
   *
   * @returns { SCBSceneContainerSession | null } Returns the  active split session, or null if there is no split
   *    session.
   */
  public getSplitSession(): SCBSceneContainerSession | null {
    if (this.isEmpty()) {
      return null;
    }
    let len = this.length;
    for (let i = len - 1; i >= 0; i--) {
      if (this[i].isSplit) {
        return this[i];
      }
    }
    return null;
  }

  /**
   * Get Top Active Sessions Exclude Floating
   *
   * @returns { SCBSceneContainerSession | null } Returns the topmost active session, or null if there is no active
   *    session.
   */
  public getTopActiveFullSession(): SCBSceneContainerSession | null {
    if (this.isEmpty()) {
      return null;
    }
    let len = this.length;
    for (let i = len - 1; i >= 0; i--) {
      if (this[i].isActive) {
        if (this[i].isTopmost() || this[i].isFloat) {
          // ignore topmost container session
          continue;
        }
        return this[i];
      }
    }
    return null;
  }

  /**
   * Get Top Active Sessions Index
   *
   * @returns { number } Returns the top active session index, or -1 if there is no active session.
   */
  public getTopActiveSessionIndex(): number {
    if (this.isEmpty()) {
      return -1;
    }
    for (let i = this.length - 1; i >= 0; i--) {
      if (this[i].isActive) {
        if (this[i].isTopmost()) {
          // ignore topmost container session
          continue;
        }
        return i;
      }
    }
    return -1;
  }

  /**
   * Get the list of midScene container session
   *
   * @returns{ Array<SCBSceneContainerSession> } Returns the list of in midScene containers
   */
  public getMidSceneSessionList(): Array<SCBSceneContainerSession> {
    if (this.isEmpty()) {
      return [];
    }
    return this.filter(session => session && session.isMidScene);
  }

  public getActiveSessionList(): Array<SCBSceneContainerSession> {
    if (this.isEmpty()) {
      return [];
    }
    return this.filter(session => session.isActive);
  }

  /**
   * Get the list of inactive scene container session
   *
   * @returns { Array<SCBSceneContainerSession> } Returns the list of inactive scene containers
   */
  public getInactiveSessionList(): Array<SCBSceneContainerSession> {
    if (this.isEmpty()) {
      return [];
    }
    return this.filter(session => !session.isActive);
  }

  /**
   * Get the number of currently active scene container sessions
   *
   * @returns { Number } Returns the number of active scene containers
   */
  public getActiveSceneContainerSessionCount(): number {
    let count = 0;
    this.forEach((item) => {
      if (item.isActive) {
        count++;
      }
    });
    return count;
  }

  /**
   * Obtain a scenario session tuple according to scenario information
   *
   * @param { SCBSceneInfo } sceneInfo
   * @param { boolean } filterPendingRemove
   * @return { [SCBSceneSession, SCBSceneContainerSession] | null } Matched scenario session, or null if no matching scenario session is found.
   */
  public getSceneSessionTupleBySceneInfo(sceneInfo: SCBSceneInfo, filterPendingRemove: boolean): [SCBSceneSession, SCBSceneContainerSession] | null {
    for (let i = this.length - 1; i >= 0; --i) {
      if (filterPendingRemove && this[i].pendingRemove) {
        WinLog.showWarn(WinLogDomain.WMS_MAIN, `getSceneSessionTupleBySceneInfo container id: ${this[i].containerId} pendingRemove, continue`);
        continue;
      }
      let primarySession = this[i].primarySession;
      if (primarySession && primarySession.sceneInfo.equalTo(sceneInfo)) {
        WinLog.showInfo(WinLogDomain.WMS_MAIN, `getSceneSessionTupleBySceneInfo primary name: ${primarySession.getName()}`);
        if (!primarySession.isAvailable) {
          WinLog.showError(WinLogDomain.WMS_MAIN, `getSceneSessionTupleBySceneInfo, but sceneSession unavailable.`);
          return [null, this[i]];
        }
        return [primarySession, this[i]];
      }
      let secondarySession = this[i].secondarySession;
      if (secondarySession && secondarySession.sceneInfo.equalTo(sceneInfo)) {
        WinLog.showInfo(WinLogDomain.WMS_MAIN, `getSceneSessionTupleBySceneInfo secondary name: ${secondarySession.getName()}`);
        if (!secondarySession.isAvailable) {
          WinLog.showError(WinLogDomain.WMS_MAIN, `getSceneSessionTupleBySceneInfo, but sceneSession unavailable.`);
          return [null, this[i]];
        }
        return [secondarySession, this[i]];
      }
      if (this[i].isMidScene) {
        let tuple = this.getSceneSessionFromMidScene(this[i], sceneInfo);
        if (tuple) {
          return tuple;
        }
      }
    }
    return null;
  }

  private getSceneSessionFromMidScene(container: SCBSceneContainerSession, sceneInfo: SCBSceneInfo):
    [SCBSceneSession, SCBSceneContainerSession] | null {
    for (let item of container.midSceneMap) {
      if (item[1].sceneInfo.equalTo(sceneInfo)) {
        return [container.midSceneMap.get(item[0]), container];
      }
    }
    return null;
  }

  /**
   * Obtaining a Scenario Session Based on a Persistence ID
   *
   * @param { Number } persistentId
   * @param { boolean } forActivation whether use cached SCBSceneSession for activation, avoid to use invalid instance.
   * @return { SCBSceneSession | null } Matched scenario session, or null if no matching scenario session is found.
   */
  public getSceneSessionByPersistentId(persistentId: number, forActivation: boolean = false): SCBSceneSession | null {
    let len = this.length;
    for (let i = 0; i < len; ++i) {
      let primarySession = this[i].primarySession;
      if (primarySession && primarySession.session.persistentId === persistentId) {
        if (forActivation && !primarySession.isAvailable) {
          log.showError(`getSceneSessionByPersistentId, but sceneSession unavailable.`);
          return null;
        }
        return primarySession;
      }
      let secondarySession = this[i].secondarySession;
      if (secondarySession && secondarySession.session.persistentId === persistentId) {
        if (forActivation && !secondarySession.isAvailable) {
          log.showError(`getSceneSessionByPersistentId, but sceneSession unavailable.`);
          return null;
        }
        return secondarySession;
      }
      if (this[i].isMidScene && this[i].midSceneMap.has(persistentId)) {
        let midSceneSession = this[i].midSceneMap.get(persistentId);
        if (midSceneSession && !midSceneSession.isAvailable) {
          log.showError(`getSceneSessionByPersistentId, but sceneSession unavailable.`);
          return null;
        }
        return midSceneSession;
      }
    }
    return null;
  }

  public getSceneSessionWithoutAbilityName(sceneInfo: SCBSceneInfo): SCBSceneSessionArray {
    let sceneSessionArray: SCBSceneSessionArray = new SCBSceneSessionArray();
    for (let i = 0; i < this.length; ++i) {
      if (this[i].primarySession?.isMatchWithoutAbilityName(sceneInfo)) {
        sceneSessionArray.push(this[i].primarySession);
      }
      if (this[i].secondarySession?.isMatchWithoutAbilityName(sceneInfo)) {
        sceneSessionArray.push(this[i].secondarySession);
      }
    }
    return sceneSessionArray;
  }

  /**
   * get main session and sub session from current containerSessionList by persistentId
   * @param persistentId
   * @returns
   */
  public getSessionByPersistentId(persistentId: number): SCBSceneSession | SCBSpecificSession | null {
    for (let i = 0; i < this.length; i++) {
      let primarySession = this[i].primarySession;
      if (primarySession && primarySession.sceneInfo.persistentId === persistentId) {
        return primarySession;
      }

      let secondarySession = this[i].secondarySession;
      if (secondarySession && secondarySession.sceneInfo.persistentId === persistentId) {
        return secondarySession;
      }

      let subSession = this.getSubSessionByPersistentId(primarySession, persistentId);
      if (subSession) {
        return subSession;
      }

      subSession = this.getSubSessionByPersistentId(secondarySession, persistentId);
      if (subSession) {
        return subSession;
      }
    }
    return null;
  }

  private getSubSessionByPersistentId(
    session: SCBSceneSession | SCBSpecificSession, persistentId: number): SCBSpecificSession | null {
    if (!session || !session.subSessionList) {
      log.showWarn(`getSubSessionByPersistentId get persistentId:${persistentId} failed. ` +
        `session is null or subSessionList not exist.`);
      return null;
    }

    for (let subSession of session.subSessionList) {
      if (subSession.session.persistentId === persistentId) {
        return subSession;
      }
      let session = this.getSubSessionByPersistentId(subSession, persistentId);
      if (session) {
        return session;
      }
    }
    return null;
  }

  /**
   * Obtains the number of sessions in a scenario based on bundleName.
   *
   * @param { String } bundleName
   * @returns { Number } Returns the number of sessions in the scenario corresponding to bundleName.
   */
  public getSceneSessionCountsByBundleName(bundleName: string): number {
    let count: number = 0;
    this.forEach((item) => {
      let primarySession = item.primarySession;
      if (primarySession && primarySession.sceneInfo.bundleName === bundleName) {
        count++;
      }
      let secondarySession = item.secondarySession;
      if (secondarySession && secondarySession.sceneInfo.bundleName === bundleName) {
        count++;
      }
    });
    return count;
  }

  /**
   * Obtains container sessions in a scenario based on bundleName.
   *
   * @param { String } bundleName
   * @returns { SCBSceneContainerSession } Returns the container sessions in the scenario corresponding to bundleName.
   */
  public getContainerSessionByBundleName(bundleName: string): SCBSceneContainerSession | null {
    let found = this.find((item) => {
      if (!item.isMidScene) {
        return (
          item.primarySession?.session?.bundleName === bundleName ||
            item.secondarySession?.session?.bundleName === bundleName
        );
      }
      return Array.from(item.midSceneMap.values()).some(
        (sceneSession: SCBSceneSession) => {
          return sceneSession?.session?.bundleName === bundleName;
        }
      );
    });
    return found || null;
  }

  /**
   * Deletes a scenario container session based on the container ID.
   *
   * @param { Number } containerId
   * @returns { SCBSceneContainerSession|null }
   */
  public deleteByContainerId(containerId: number): SCBSceneContainerSession | null {
    let index = this.findIndexByContainerId(containerId);
    if (index === -1) {
      return null;
    }
    let ret = this.splice(index, 1);
    if (ret.length !== 1) {
      return null;
    }
    return ret[0];
  }

  /**
   * sort the list to move the topmost containerSessions to the end
   */
  public sortByTopmost(): void {
    let mainWindowTopmostContainerSessionList = this.removeIf((containerSession) => {
      return containerSession.isActive && containerSession.isMainWindowTopmost();
    });
    for (let containerSession of mainWindowTopmostContainerSessionList) {
      this.push(containerSession);
    }

    let topmostContainerSessionList = this.removeIf((containerSession) => {
      return containerSession.isActive && containerSession.isTopmost();
    });
    for (let containerSession of topmostContainerSessionList) {
      this.push(containerSession);
    }
  }

  private compareModalType(primarySession: SCBSceneSession | null, secondarySession: SCBSceneSession | null): number {
    if (CommonUtils.isInvalid(primarySession) || CommonUtils.isInvalid(secondarySession)) {
      return 0;
    }
    if (!CommonUtils.isInvalid(secondarySession.sceneInfo) &&
        primarySession.sceneInfo?.isSameBundleWithMultiApp(secondarySession.sceneInfo)) {
      if (!primarySession.isModal && secondarySession.isModal) {
        return -1;
      }
      if (primarySession.isModal && !secondarySession.isModal) {
        return 1;
      }
    }
    return 0;
  }

  /**
   * sort the list to move the topmost containerSessions to the end
   */
  public sortByModalType(): void {
    this.sort((containerSessionA: SCBSceneContainerSession, containerSessionB: SCBSceneContainerSession) => {
      let ret: number = this.compareModalType(containerSessionA.primarySession, containerSessionB.primarySession);
      if (ret !== 0) {
        return ret;
      }
      ret = this.compareModalType(containerSessionA.primarySession, containerSessionB.secondarySession);
      if (ret !== 0) {
        return ret;
      }
      ret = this.compareModalType(containerSessionA.secondarySession, containerSessionB.primarySession);
      if (ret !== 0) {
        return ret;
      }
      return this.compareModalType(containerSessionA.secondarySession, containerSessionB.secondarySession);
    });
  }

  /**
   * remove containerSessions on condition
   * @param filter condition
   * @returns removed containerSession list
   */
  public removeIf(filterFunc: Function): SCBSceneContainerSession[] {
    let removedList: Array<SCBSceneContainerSession> = [];
    if (!filterFunc) {
      return removedList;
    }
    const tempArr = [...this];
    tempArr.forEach((val, index) => {
      if (filterFunc(val)) {
        removedList.push(val);
        this.splice(this.lastIndexOf(val), 1);
      }
    });
    return removedList;
  }

  /**
   * Deletes the element with the specified index.
   *
   * @param index
   * @returns If the deletion is successful, true is returned. Otherwise, false is returned.
   */
  public deleteWithTransitionInactive(index: number): boolean {
    if (index >= this.length) {
      return false;
    }
    this[index].transitionController?.onInactive(TAG, 'deleteWithTransitionInactive');
    this.splice(index, 1);
    return true;
  }

  /**
   * Clone current array
   *
   * @returns { SCBSceneContainerSessionArray } A new SCBSceneContainerSessionArray object is returned.
   */
  public clone(): SCBSceneContainerSessionArray {
    let newArray = new SCBSceneContainerSessionArray();
    this.forEach((item) => {
      newArray.push(item);
    });
    return newArray;
  }

  /**
   * Filter clone current array
   *
   * @returns { SCBSceneContainerSessionArray } A new SCBSceneContainerSessionArray object is returned.
   */
  public filterClone(): SCBSceneContainerSessionArray {
    return ContainerSessionFilter.getInstance().doFilter(DeviceHelper.getFoldProductType(), this);
  }

  public getTargetSessionCountAndFirstContainer(filterFunction: Function): [number, SCBSceneContainerSession | null] {
    let firstContainerSession: SCBSceneContainerSession | null = null;
    let containerSessionCount = 0;
    for (let item of this) {
      if (item.primarySession && filterFunction(item.primarySession)) {
        ++containerSessionCount;
        if (!firstContainerSession) {
          firstContainerSession = item;
        }
      }
      if (item.secondarySession && filterFunction(item.secondarySession)) {
        ++containerSessionCount;
        if (!firstContainerSession) {
          firstContainerSession = item;
        }
      }
    }
    return [containerSessionCount, firstContainerSession];
  }

  public filterIsNotDeletingSceneSessions(): SCBSceneContainerSession[] {
    return this.filter((container) => {
      let lastUsedPosition = container?.getData(ContainerDataCategory.BASIC)?.lastUsedPosition;
      return (!!container && !container.pendingRemove && (!lastUsedPosition ||
        lastUsedPosition === DeviceHelper.getCurrentDeviceScene()));
    });
  }

  /**
   * 移除正在删除（即pendingRemove为true）的sessionContainer
   */
  public removeDeletingSceneSessions(): void {
    for (let index = this.length - 1; index >= 0; index--) {
      let container = this[index];
      if (container?.pendingRemove) {
        this.splice(index, 1);
      }
    }
  }

  public forceRemoveSceneSession(session: SCBSceneSession): void {
    let container = this.findByPersistentId(session.session?.persistentId);
    container?.removeSceneSessionInContainer(session);
  }

  /**
   * get reverse sessionArray
   * @returns SCBSceneContainerSessionArray
   */
  public getReverseSessionArray(): SCBSceneContainerSessionArray {
    let newArray = new SCBSceneContainerSessionArray();
    for (let index = this.length - 1; index >= 0; index--) {
      newArray.push(this[index]);
    }
    return newArray;
  }

  /**
   * find SCBSceneContainerSession by info.
   * @description only support to match info of primary or secondary session in container.
   * @param info SCBSceneInfo
   * @returns SCBSceneContainerSession or null
   */
  public findItemBySceneInfo(info: SCBSceneInfo): SCBSceneContainerSession | null {
    if (!info) {
      return null;
    }
    return this.find((item) => {
      return item.primarySession?.sceneInfo?.equalTo(info) || item.secondarySession?.sceneInfo?.equalTo(info);
    }) ?? null;
  }

  public findItemByBundleInfo(abilityName:string,bundleName:string,moduleName?:string ): SCBSceneContainerSession | null {
    return this.find((item) => {
      return item.primarySession?.sceneInfo?.equal(abilityName,bundleName,moduleName)
        || item.secondarySession?.sceneInfo?.equal(abilityName,bundleName,moduleName);
    }) ?? null;
  }

  public findItemByPersistentId(persistentId: number): SCBSceneContainerSession | null {
    if (!persistentId) {
      return null;
    }
    return this.find((item) => {
      return item.primarySession?.sceneInfo?.persistentId === persistentId ||
        item.secondarySession?.sceneInfo?.persistentId === persistentId;
    }) ?? null;
  }
}

@Observed
export class SCBDividerParamArray extends Array<SCBDividerParam> {
}


@Observed
export class NeedRenderTranslate {
  private _translateX: number = 0;
  private _translateY: number = 0;

  /**
   * Get the X-axis offset of an element
   *
   * @returns { number } Returns the X-axis offset
   */
  public get translateX(): number {
    return this._translateX;
  }

  /**
   * Get the Y-axis offset of an element
   *
   * @returns { number } Returns the Y-axis offset
   */
  public get translateY(): number {
    return this._translateY;
  }

  /**
   * Sets the translation value of the X axis and records logs.
   *
   * @param { Number } translateX
   * @param { String } module
   * @param { String } reason
   * @param { String } extra
   */
  public setTranslateXWithDfx(translateX: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._translateX, translateX)) {
      return;
    }
    log.showWarn(`[${module}] translateX from ${this._translateX} to ${translateX}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._translateX = translateX;
  }

  /**
   * Set the translation value of the Y axis and record logs.
   *
   * @param { Number } translateY
   * @param { String } module
   * @param { String } reason
   * @param { String } extra
   */
  public setTranslateYWithDfx(translateY: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._translateY, translateY)) {
      return;
    }
    log.showWarn(`[${module}] translateY from ${this._translateY} to ${translateY}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._translateY = translateY;
  }

  /**
   * set Translate X
   *
   * @param translateX
   */
  public setTranslateX(translateX: number): void {
    if (CommonUtils.equals(this._translateX, translateX)) {
      return;
    }
    this._translateX = translateX;
  }

  /**
   * set Translate Y
   *
   * @param translateY
   */
  public setTranslateY(translateY: number): void {
    if (CommonUtils.equals(this._translateY, translateY)) {
      return;
    }
    this._translateY = translateY;
  }
}

@Observed
export class NeedRenderSwiperTranslate {
  private _translateX: number = 0;
  private _translateY: number = 0;

  /**
   * 获取swiper组件的x偏移
   *
   * @returns { number } x偏移
   */
  public get translateX(): number {
    return this._translateX;
  }

  /**
   * 获取swiper组件的y偏移
   *
   * @returns { number } y偏移
   */
  public get translateY(): number {
    return this._translateY;
  }

  /**
   * 设置swiper组件的x偏移
   *
   * @param { Number } translateX 偏移量
   * @param { String } module 调用的模块名
   * @param { String } reason 修改的原因
   * @param { String } extra 额外参数
   */
  public setTranslateXWithDfx(translateX: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._translateX, translateX)) {
      return;
    }
    log.showWarn(`[${module}]set translateX from ${this._translateX} to ${translateX}. ` +
      `reason: ${reason}, extra info: ${extra}`);
    this._translateX = translateX;
  }

  /**
   * 设置swiper组件的y偏移
   *
   * @param { Number } translateY 偏移量
   * @param { String } module 调用的模块名
   * @param { String } reason 修改的原因
   * @param { String } extra 额外参数
   */
  public setTranslateYWithDfx(translateY: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._translateY, translateY)) {
      return;
    }
    log.showWarn(`[${module}]set translateY from ${this._translateY} to ${translateY}. ` +
      `reason: ${reason}, extra info: ${extra}`);
    this._translateY = translateY;
  }

  /**
   * 设置swiper组件的y偏移
   *
   * @param translateY 偏移量
   */
  public setTranslateY(translateY: number): void {
    if (CommonUtils.equals(this._translateY, translateY)) {
      return;
    }
    this._translateY = translateY;
  }
}

@Observed
export class NeedRenderTranslateIcon {
  private _translateIconX: number = 0;
  private _translateIconY: number = 0;
  private _translateOobeIconX: number = 0;
  private _translateOobeIconY: number = 0;

  public get translateIconX(): number {
    return this._translateIconX;
  }

  public get translateIconY(): number {
    return this._translateIconY;
  }

  public get translateOobeIconY(): number {
    return this._translateOobeIconY;
  }

  public get translateOobeIconX(): number {
    return this._translateOobeIconX;
  }

  /**
   * set Translate IconX
   *
   * @param translateIconX
   */
  public set translateIconX(translateIconX: number) {
    if (CommonUtils.equals(this._translateIconX, translateIconX)) {
      return;
    }
    this._translateIconX = translateIconX;
  }

  /**
   *
   * @param translateIconY 图标偏移
   * @param module 模块名
   * @param reason 设置理由
   * @param extra 额外字段
   */
  public setTranslateIconYWithDfx(translateIconY: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._translateIconY, translateIconY)) {
      return;
    }
    log.showWarn(`[${module}] translateIconY from ${this._translateIconY} to ${translateIconY}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._translateIconY = translateIconY;
  }

  /**
   * set TranslateIcon Y
   *
   * @param translateIconY
   */
  public set translateIconY(translateIconY: number) {
    if (CommonUtils.equals(this._translateIconY, translateIconY)) {
      return;
    }
    this._translateIconY = translateIconY;
  }

  /**
   * set Translate IconX
   *
   * @param translateIconX
   */
  public set translateOobeIconX(translateOobeIconX: number) {
    if (CommonUtils.equals(this._translateOobeIconX, translateOobeIconX)) {
      return;
    }
    this._translateOobeIconX = translateOobeIconX;
  }

  /**
   * set TranslateIcon Y
   *
   * @param translateIconY
   */
  public set translateOobeIconY(translateOobeIconY: number) {
    if (CommonUtils.equals(this._translateOobeIconY, translateOobeIconY)) {
      return;
    }
    this._translateOobeIconY = translateOobeIconY;
  }
}

@Observed
export class NeedRenderVisibility {
  private _visibility: boolean = true;

  /**
   * Get the visibility of an element
   *
   * @returns { boolean } Returns the visibility of an element
   */
  public get visibility(): boolean {
    return this._visibility;
  }

  /**
   * Sets whether the visibility of the rendering is required
   *
   * @param { Boolean } visibility
   * @param { String } module
   * @param { String } reason
   * @param { String } extra
   */
  public setVisibilityWithDfx(visibility: boolean, module: string, reason: string, extra?: string): void {
    if (this._visibility === visibility) {
      return;
    }
    log.showInfo(`[${module}] visibility from ${this._visibility} to ${visibility}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._visibility = visibility;
  }

  /**
   * set Visibility
   *
   * @param visibility
   */
  public setVisibility(visibility: boolean): void {
    if (this._visibility === visibility) {
      return;
    }
    this._visibility = visibility;
  }
}

@Observed
export class NeedRenderBlurRadius {
  private _blurRadius: number = -1;

  /**
   * Gets the blurRadius value of the scene
   *
   * @returns { number } Returns the blurRadius value of the scene
   */
  public get blurRadius(): number {
    return this._blurRadius;
  }

  public set blurRadius(blurRadius: number) {
    this._blurRadius = blurRadius;
  }

  /**
   * Sets the blurRadius value to be rendered.
   *
   * @param { Number } blurRadius
   * @param { String } module
   * @param { String } reason
   * @param { String } extra
   */
  public setBlurRadiusWithDfx(blurRadius: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._blurRadius, blurRadius)) {
      return;
    }
    log.showInfo(`[${module}] blurRadius from ${this._blurRadius} to ${blurRadius}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._blurRadius = blurRadius;
  }

  /**
   * reset Need Render blurRadius
   */
  public reset(): void {
    if (CommonUtils.equals(this._blurRadius, -1)) {
      return;
    }
    log.showInfo(`reset blurRadius from ${this._blurRadius} to -1.`);
    this._blurRadius = -1;
  }
}

@Observed
export class NeedRenderAlpha {
  private _sceneAlpha: number = 0;

  /**
   * Gets the transparency value of the scene
   *
   * @returns { number } Returns the transparency value of the scene
   */
  public get sceneAlpha(): number {
    return this._sceneAlpha;
  }

  /**
   * Sets the alpha value to be rendered.
   *
   * @param { Number } sceneAlpha
   * @param { String } module
   * @param { String } reason
   * @param { String } extra
   */
  public setNeedRenderAlphaWithDfx(sceneAlpha: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._sceneAlpha, sceneAlpha)) {
      return;
    }
    log.showWarn(`[${module}] sceneAlpha from ${this._sceneAlpha} to ${sceneAlpha}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._sceneAlpha = sceneAlpha;
  }

  /**
   * set Need Render Alpha
   *
   * @param sceneAlpha
   */
  public setNeedRenderAlpha(sceneAlpha: number): void {
    if (CommonUtils.equals(this._sceneAlpha, sceneAlpha)) {
      return;
    }
    this._sceneAlpha = sceneAlpha;
  }
}

@Observed
export class NeedRenderBorderRadius {
  private _topLeft: number = 0;
  private _topRight: number = 0;
  private _bottomLeft: number = 0;
  private _bottomRight: number = 0;

  /**
   * Get the value on the left of the top
   *
   * @returns { number }
   */
  public get topLeft(): number {
    return this._topLeft;
  }

  /**
   * Get the value of the upper right corner
   *
   * @returns { number }
   */
  public get topRight(): number {
    return this._topRight;
  }

  /**
   * Get the value on the left of the bottom
   *
   * @returns { number }
   */
  public get bottomLeft(): number {
    return this._bottomLeft;
  }

  /**
   * Get the value on the right of the bottom
   *
   * @returns { number }
   */
  public get bottomRight(): number {
    return this._bottomRight;
  }

  /**
   * Set the radius of each corner
   *
   * @param { Number } radius Radius value
   * @param { String } module
   * @param { String } reason
   * @param { String } extra
   */
  public setBorderRadiusWithDfx(radius: number, module: string, reason: string, extra?: string): void {
    let isChanged: boolean = false;
    let topLeftTemp: number = this._topLeft;
    let topRightTemp: number = this._topRight;
    let bottomLeftTemp: number = this._bottomLeft;
    let bottomRightTemp: number = this._bottomRight;
    if (!CommonUtils.equals(this._topLeft, radius)) {
      this._topLeft = radius;
      isChanged = true;
    }
    if (!CommonUtils.equals(this._topRight, radius)) {
      this._topRight = radius;
      isChanged = true;
    }
    if (!CommonUtils.equals(this._bottomLeft, radius)) {
      this._bottomLeft = radius;
      isChanged = true;
    }
    if (!CommonUtils.equals(this._bottomRight, radius)) {
      this._bottomRight = radius;
      isChanged = true;
    }
    if (isChanged) {
      log.showWarn(`[${module}] border radius from topLeft: ${topLeftTemp}, topRight: ${topRightTemp}, ` +
        `bottomLeft: ${bottomLeftTemp}, bottomRight: ${bottomRightTemp} to ${radius}. ` +
        `reason: ${reason}, extra: ${extra}`);
    }
  }

  /**
   * set Border Radius
   *
   * @param radius
   */
  public setBorderRadius(radius: number): void {
    if (!CommonUtils.equals(this._topLeft, radius)) {
      this._topLeft = radius;
    }
    if (!CommonUtils.equals(this._topRight, radius)) {
      this._topRight = radius;
    }
    if (!CommonUtils.equals(this._bottomLeft, radius)) {
      this._bottomLeft = radius;
    }
    if (!CommonUtils.equals(this._bottomRight, radius)) {
      this._bottomRight = radius;
    }
  }

  /**
   * 设置不同位置的圆角
   *
   * @param radius 圆角
   */
  public setDiffBorderRadiusWithDfx(topLeft: number, topRight: number, bottomLeft: number, bottomRight?: number): void {
    this._topLeft = topLeft ?? 0;
    this._topRight = topRight ?? 0;
    this._bottomLeft = bottomLeft ?? 0;
    this._bottomRight = bottomRight ?? 0;
  }

  /**
   * set Diff Border Radius
   *
   * @param topLeft
   * @param topRight
   * @param bottomLeft
   * @param bottomRight
   */
  public setDiffBorderRadius(topLeft: number, topRight: number, bottomLeft: number, bottomRight?: number): void {
    this._topLeft = topLeft ?? 0;
    this._topRight = topRight ?? 0;
    this._bottomLeft = bottomLeft ?? 0;
    this._bottomRight = bottomRight ?? 0;
  }

  /**
   * Gets the default border radius.
   *
   * @returns { Number }
   */
  public getDefaultBorderRadius(): number {
    return this._topLeft;
  }

  /**
   * Check if any border radius is set
   *
   * @returns { boolean }
   */
  public hasBorderRadius(): boolean {
    return this._topLeft > 0 || this._topRight > 0 || this._bottomLeft > 0 || this._bottomRight > 0;
  }

  /**
   * Override the toString method to return a string representation of the four corners.
   *
   * @returns { String }
   */
  public toString(): string {
    return `[topLeft:${this._topLeft}, topRight:${this._topRight}, bottomLeft:${this._bottomLeft},
      bottomRight:${this._bottomRight}]`;
  }
}

@Observed
export class NeedRenderPos {
  private _posX: number = 0;
  private _posY: number = 0;

  /**
   * 获取x轴位置的getter方法
   *
   * @returns { number } 返回x轴位置的值
   */
  public get posX(): number {
    return this._posX;
  }

  /**
   * 获取当前对象的Y坐标
   *
   * @returns { number } 返回当前对象的Y坐标
   */
  public get posY(): number {
    return this._posY;
  }

  /**
   * Set X-Axis Position
   *
   * @param { Number } posX
   * @param { String } module
   * @param { String } reason
   * @param { String } extra
   */
  public setPosXWithDfx(posX: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._posX, posX)) {
      return;
    }
    log.showWarn(`[${module}] posX from ${this._posX} to ${posX}. reason: ${reason}, extra: ${extra}`);
    this._posX = posX;
  }

  /**
   * Sets the Y-axis position.
   *
   * @param { Number } posY
   * @param { String } module
   * @param { String } reason
   * @param { String } extra
   */
  public setPosYWithDfx(posY: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._posY, posY)) {
      return;
    }
    log.showWarn(`[${module}] posY from ${this._posY} to ${posY}. reason: ${reason}, extra: ${extra}`);
    this._posY = posY;
  }

  /**
   * set Position X
   *
   * @param posX
   */
  public setPosX(posX: number): void {
    if (CommonUtils.equals(this._posX, posX)) {
      return;
    }
    this._posX = posX;
  }

  /**
   * set Position Y
   *
   * @param posY
   * @param posY
   */
  public setPosY(posY: number): void {
    if (CommonUtils.equals(this._posY, posY)) {
      return;
    }
    this._posY = posY;
  }

}

@Observed
export class NeedRenderZIndex {
  private _zIndex: number = 1;
  public get zIndex(): number {
    return this._zIndex;
  }

  public setZIndex(zIndex: number): void {
    if (this._zIndex === zIndex) {
      return;
    }
    log.showInfo(`set zIndex from ${this._zIndex} to ${zIndex}`);
    this._zIndex = zIndex;
  }

  /**
   * reset ZIndex
   */
  public resetZIndex(): void {
    if (this._zIndex !== 1) {
      this._zIndex = 1;
      log.showInfo(`reset zIndex: ${this._zIndex}`);
    }
  }
}

@Observed
export class NeedRenderRotate {
  private _angle: number = 0;
  private _rotateX: number = 1;
  private _centerX: number | string = '50%';
  private _centerY: number | string = '50%';

  public get angle(): number {
    return this._angle;
  }

  public get rotateX(): number {
    return this._rotateX;
  }

  public get centerX(): number | string {
    return this._centerX;
  }

  public get centerY(): number | string {
    return this._centerY;
  }

  public setAngleWithDfx(angle: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._angle, angle)) {
      return;
    }
    log.showInfo(`[${module}] rotate from ${this._angle} to ${angle}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._angle = angle;
  }

  public setAngle(angle: number): void {
    if (CommonUtils.equals(this._angle, angle)) {
      return;
    }
    this._angle = angle;
  }

  public setCenterX(centerX: number | string): void {
    if (CommonUtils.equals(this._centerX, centerX)) {
      return;
    }
    log.showInfo(`set centerX from ${this._centerX} to ${centerX}.`);
    this._centerX = centerX;
  }

  public setCenterY(centerY: number | string): void {
    if (CommonUtils.equals(this._centerY, centerY)) {
      return;
    }
    log.showInfo(`set centerY from ${this._centerY} to ${centerY}.`);
    this._centerY = centerY;
  }
}

@Observed
export class NeedRenderClip {
  private _clipHeight: ScbNumber = new ScbNumber();
  private _clipWidth: ScbNumber = new ScbNumber();

  public get clipHeight(): ScbNumber {
    return this._clipHeight;
  }

  public get clipWidth(): ScbNumber {
    return this._clipWidth;
  }

  public setClipHeight(clipHeight: number | ScbNumber): void {
    if (CommonUtils.equals(this._clipHeight.getPx(),
      (typeof clipHeight === 'number' ? clipHeight : clipHeight.getPx()))) {
      return;
    }
    if (typeof clipHeight === 'number') {
      log.showInfo(`set NeedRenderClip clipHeight type of number from ` + this._clipHeight.getPx() + ` to ` + clipHeight);
      this._clipHeight = new ScbNumber(clipHeight);
    } else {
      log.showInfo(`set NeedRenderClip clipHeight from ` + this._clipHeight.getPx() + ` to ` + clipHeight.getPx());
      this._clipHeight = clipHeight;
    }
  }

  public setClipWidth(clipWidth: number | ScbNumber): void {
    if (CommonUtils.equals(this._clipWidth.getPx(), (typeof clipWidth === 'number' ? clipWidth : clipWidth.getPx()))) {
      return;
    }
    if (typeof clipWidth === 'number') {
      log.showInfo(`set NeedRenderClip clipWidth type of number from ` + this._clipWidth.getPx() + ` to ` + clipWidth);
      this._clipWidth = new ScbNumber(clipWidth);
    } else {
      log.showInfo(`set NeedRenderClip clipWidth from ` + this._clipWidth.getPx() + ` to ` + clipWidth.getPx());
      this._clipWidth = clipWidth;
    }
  }
}

@Observed
export class NeedRenderLockIconOpacity {
  private _lockIconOpacity: number = 0;

  /**
   * Obtains the Opacity of the lock icon.
   *
   * @returns { number } Returns the Opacity of the lock icon
   */
  public get lockIconOpacity(): number {
    return this._lockIconOpacity;
  }

  /**
   * set lock icon Opacity
   *
   * @param lockIconOpacity
   */
  public setLockIconOpacity(lockIconOpacity: number): void {
    if (CommonUtils.equals(this._lockIconOpacity, lockIconOpacity)) {
      return;
    }
    this._lockIconOpacity = lockIconOpacity;
  }
}

@Observed
export class NeedRenderLockIconScale {
  private _lockIconScale: number = 0;
  private _lockIconCenter: number | string = '50%';

  /**
   * Obtains the center of the lock icon.
   *
   * @returns { number } Returns the center of the lock icon
   */
  public get lockIconCenter(): number | string {
    return this._lockIconCenter;
  }

  /**
   * Obtains the scale of the lock icon.
   *
   * @returns { number } Returns the scale of the lock icon
   */
  public get lockIconScale(): number {
    return this._lockIconScale;
  }

  /**
   * set lock icon center
   *
   * @param lockIconCenter
   */
  public setLockIconCenter(lockIconCenter: number): void {
    if (CommonUtils.equals(this._lockIconCenter, lockIconCenter)) {
      return;
    }
    this._lockIconCenter = lockIconCenter;
  }

  /**
   * set lock icon scale
   *
   * @param lockIconScale
   */
  public setLockIconScale(lockIconScale: number): void {
    if (CommonUtils.equals(this._lockIconScale, lockIconScale)) {
      return;
    }
    this._lockIconScale = lockIconScale;
  }
}

@Observed
export class NeedRenderLockIconTranslate {
  private _lockIconTranslateX: number = 0;
  private _lockIconTranslateY: number = 0;

  /**
   * Obtains the translate of the lock icon.
   *
   * @returns { number } Returns the translate of the X axis
   */
  public get lockIconTranslateX(): number {
    return this._lockIconTranslateX;
  }

  /**
   * Obtains the translate of the lock icon.
   *
   * @returns { number } Returns the translate of the Y axis
   */
  public get lockIconTranslateY(): number {
    return this._lockIconTranslateY;
  }

  /**
   * set translate X
   *
   * @param lockIconTranslateX
   */
  public setLockIconTranslateX(lockIconTranslateX: number): void {
    if (CommonUtils.equals(this._lockIconTranslateX, lockIconTranslateX)) {
      return;
    }
    this._lockIconTranslateX = lockIconTranslateX;
  }

  /**
   * set translate Y
   *
   * @param lockIconTranslateY
   */
  public setLockIconTranslateY(lockIconTranslateY: number): void {
    if (CommonUtils.equals(this._lockIconTranslateY, lockIconTranslateY)) {
      return;
    }
    this._lockIconTranslateY = lockIconTranslateY;
  }
}

@Observed
export class NeedRenderTitleViewScale {
  private _titleViewScale: number = 1;

  /**
   * Obtains the Scale of the titleView.
   *
   * @returns { number } Returns the Scale of the titleView
   */
  public get titleViewScale(): number {
    return this._titleViewScale;
  }

  /**
   * set titleView Scale
   *
   * @param titleViewScale
   */
  public setTitleViewScale(titleViewScale: number): void {
    if (CommonUtils.equals(this._titleViewScale, titleViewScale)) {
      return;
    }
    this._titleViewScale = titleViewScale;
  }
}

@Observed
export class NeedRenderScale {
  private _scaleX: number = 1;
  private _scaleY: number = 1;
  private _centerX: number | string = '50%';
  private _centerY: number | string = '50%';

  /**
   * Obtains the scaling ratio of the X axis.
   *
   * @returns { number } Returns the scaling of the X axis
   */
  public get scaleX(): number {
    return this._scaleX;
  }

  /**
   * Obtains the scaling ratio of the Y axis.
   *
   * @returns { number } Returns the scaling of the Y axis
   */
  public get scaleY(): number {
    return this._scaleY;
  }

  public get centerX(): number | string {
    return this._centerX;
  }

  public get centerY(): number | string {
    return this._centerY;
  }

  /**
   * Sets the scaling of the X axis
   *
   * @param { Number } scaleX
   * @param { String } module
   * @param { String } reason
   * @param { String } extra
   */
  public setScaleXWithDfx(scaleX: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._scaleX, scaleX)) {
      return;
    }
    log.showInfo(`[${module}] scaleX from ${this._scaleX} to ${scaleX}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._scaleX = scaleX;
  }

  /**
   * Sets the scaling of the Y axis
   *
   * @param { Number } scaleY
   * @param { String } module
   * @param { String } reason
   * @param { String } extra
   */
  public setScaleYWithDfx(scaleY: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._scaleY, scaleY)) {
      return;
    }
    log.showInfo(`[${module}] scaleY from ${this._scaleY} to ${scaleY}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._scaleY = scaleY;
  }

  /**
   * set Scale X
   *
   * @param scaleX
   */
  public setScaleX(scaleX: number): void {
    if (CommonUtils.equals(this._scaleX, scaleX)) {
      return;
    }
    this._scaleX = scaleX;
  }

  /**
   * set Scale Y
   *
   * @param scaleY
   */
  public setScaleY(scaleY: number): void {
    if (CommonUtils.equals(this._scaleY, scaleY)) {
      return;
    }
    this._scaleY = scaleY;
  }

  public set centerX(centerX: number | string) {
    if (CommonUtils.equals(this._centerX, centerX)) {
      return;
    }
    this._centerX = centerX;
  }

  public set centerY(centerY: number | string) {
    if (CommonUtils.equals(this._centerY, centerY)) {
      return;
    }
    this._centerY = centerY;
  }
}

@Observed
export class NeedRenderBackgroundAlpha {
  public backgroundAlpha: number = 1.0;
}

@Observed
export class NeedPreBuild {
  private _preBuildStage: PreBuildStage = PreBuildStage.NOT_PRE_BUILD;

  public get preBuildStage(): PreBuildStage {
    return this._preBuildStage;
  }

  public setPreBuildStageWithDfx(preBuildStage: PreBuildStage): void {
    if (this._preBuildStage === preBuildStage) {
      return;
    }
    log.showInfo(`NeedPreBuild set preBuildStage from ${this._preBuildStage} to ${preBuildStage}.`);
    this._preBuildStage = preBuildStage;
  }

  public setPreBuildStage(preBuildStage: PreBuildStage): void {
    if (this._preBuildStage === preBuildStage) {
      return;
    }
    this._preBuildStage = preBuildStage;
  }
}

@Observed
export class NeedRenderShowInRecent {
  private _showInRecent: boolean = false;

  public setShowInRecentWithDfx(showInRecent: boolean, module: string, reason: string, extra?: string): void {
    if (this._showInRecent === showInRecent) {
      return;
    }
    log.showWarn(`[${module}] showInRecent from ${this._showInRecent} to ${showInRecent}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._showInRecent = showInRecent;
  }

  public get showInRecent(): boolean {
    return this._showInRecent;
  }
}

@Observed
export class NeedRenderSubSceneShow {
  public static readonly subSceneShow: number = 0b0011;
  // 和主窗在同一屏的子窗
  public static readonly curScreenSubSceneShow: number = 0b0001;
  public static readonly curScreenSubSceneHide: number = 0b1110;
  // 和主窗不在同一屏的子窗
  public static readonly anotherScreenSubSceneShow: number = 0b0010;
  public static readonly anotherScreenSubSceneHide: number = 0b1101;

  private showNum: number = NeedRenderSubSceneShow.subSceneShow;

  public isShowSubScene(showNum: number): boolean {
    return (this.showNum & showNum) === showNum;
  }

  public showSubScene(showNum: number): void {
    this.showNum |= showNum;
  }

  public hideSubScene(hideNum: number): void {
    this.showNum &= hideNum;
  }

  public showWithDfx(showNum: number, module: string, reason: string, extra?: string): void {
    if (this.showNum === showNum) {
      return;
    }
    log.showInfo(`[${module}] show NeedRenderSubSceneShow from ${this.showNum} to ${this.showNum | showNum}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this.showSubScene(showNum);
  }

  public hideWithDfx(showNum: number, module: string, reason: string, extra?: string): void {
    if (this.showNum === showNum) {
      return;
    }
    log.showInfo(`[${module}] hide NeedRenderSubSceneShow from ${this.showNum} to ${this.showNum & showNum}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this.hideSubScene(showNum);
  }
}

@Observed
export class NeedRenderRecentMinBackgroundShow {
  private _primarySessionShow: boolean = false;
  private _secondSessionShow: boolean = false;

  public get primarySessionShow(): boolean {
    return this._primarySessionShow;
  }

  public set primarySessionShow(primarySessionShow: boolean) {
    this._primarySessionShow = primarySessionShow;
  }

  public setPrimarySessionShowWithDfx(primarySessionShow: boolean, module: string, reason: string, extra?: string): void {
    if (this._primarySessionShow === primarySessionShow) {
      return;
    }
    log.showInfo(`[${module}] NeedRenderRecentMinBackgroundShow from ${this._primarySessionShow} to ${primarySessionShow}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._primarySessionShow = primarySessionShow;
  }

  public get secondSessionShow(): boolean {
    return this._secondSessionShow;
  }

  public set secondSessionShow(secondSessionShow: boolean) {
    if (this._secondSessionShow === secondSessionShow) {
      return;
    }
    this._secondSessionShow = secondSessionShow;
  }
}

@Observed
export class NeedRenderTitleViewAlpha {
  private _titleViewAlpha: number = 0;

  /**
   * Set the transparency of the title view
   *
   * @param { Number } titleViewAlpha
   */
  public setTitleViewAlpha(titleViewAlpha: number): void {
    if (CommonUtils.equals(this._titleViewAlpha, titleViewAlpha)) {
      return;
    }
    this._titleViewAlpha = titleViewAlpha;
  }

  /**
   * Gets the transparency of the title view
   *
   * @returns { number } Returns the transparency of the title view
   */
  public get titleViewAlpha(): number {
    return this._titleViewAlpha;
  }
}

@Observed
export class NeedRenderRecentHoverState {
  private _hoverState: boolean = false;

  /**
   * Sets whether card in Recent is hovered.
   *
   * @param { Boolean } showRecentTitle
   */
  public set hoverState(value: boolean) {
    this._hoverState = value;
  }

  public get hoverState(): boolean {
    return this._hoverState;
  }

}

@Observed
export class NeedRenderShowRecentTitle {
  private _showRecentTitle: boolean = false;

  /**
   * Sets whether to display the latest title.
   *
   * @param { Boolean } showRecentTitle
   */
  public setShowRecentTitle(showRecentTitle: boolean): void {
    if (this._showRecentTitle === showRecentTitle) {
      return;
    }
    log.showInfo(`set current showRecentTitle from ${this._showRecentTitle} to ${showRecentTitle}`);
    this._showRecentTitle = showRecentTitle;
  }

  /**
   * Gets the status of whether the most recent title is displayed
   *
   * @returns { boolean } Returns the status of whether the most recent title is displayed
   */
  public get showRecentTitle(): boolean {
    return this._showRecentTitle;
  }
}
@Observed
export class MidSceneMap<K, V> extends Map<K, V> {
  set(key: K, value: V): this {
    if (value instanceof SCBSceneSession) {
      try {
        value.session.setIsMidScene(true);
        SCBSceneMissionManager.getInstance().notifyAddToMidScene(value.session.persistentId);
      } catch (e) {
        log.error(`[SCBMidScene]: setIsMidScene Error`);
      }
    }
    return super.set(key, value);
  }

  delete(key: K): boolean {
    let value: V = super.get(key);
    if (value instanceof SCBSceneSession) {
      try {
        value.session.setIsMidScene(false);
      } catch (e) {
        log.error(`[SCBMidScene]: setIsMidScene Error`);
      }
    }
    return super.delete(key);
  }
}

@Observed
export class MidAppIconParamMap<K, V> extends Map<K, V> {
}

@Observed
export class NeedRenderRecentSceneBorderRadius {
  public borderRadius: number = 0;
}

@Observed
export class NeedRenderRecentDeleteScale {
  public scaleX: number = 1;
  public scaleY: number = 1;
  public centerX: number | string = '50%';
  public centerY: number | string = '50%';
}

@Observed
export class NeedRenderRecentDeleteTranslate {
  public translateX: number = 0;
  public translateY: number = 0;
}

@Observed
export class NeedRenderRecentCoverScale {
  public scaleX: number = 1;
  public scaleY: number = 1;
  public secondaryScaleY: number = 1;
}

@Observed
export class NeedRenderRecentMinBackgroundAlpha {
  private alpha_: number = 0;

  public get alpha(): number {
    return this.alpha_;
  }

  public setAlpha(value: number): void {
    this.alpha_ = value;
  }

  public setAlphaWithDfx(value: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this.alpha_, value)) {
      return;
    }
    log.showInfo(`[${module}] NeedRenderRecentMinBackgroundAlpha from ${this.alpha_} to ${value}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this.alpha_ = value;
  }
}

@Observed
export class NeedRenderRecentMinBackgroundSize {
  private width_: number = 0;
  private height_: number = 0

  public get width(): number {
    return this.width_;
  }

  public get height(): number {
    return this.height_;
  }

  public setWidth(value: number): void {
    this.width_ = value;
  }

  public setHeight(value: number): void {
    this.height_ = value;
  }

  public setWidthWithDfx(value: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this.width_, value)) {
      return;
    }
    log.showInfo(`[${module}] NeedRenderRecentMinBackgroundSize width from ${this.width_} to ${value}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this.width_ = value;
  }

  public setHeightWithDfx(value: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this.height_, value)) {
      return;
    }
    log.showInfo(`[${module}] NeedRenderRecentMinBackgroundSize height from ${this.height_} to ${value}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this.height_ = value;
  }
}

@Observed
export class NeedRenderBackgroundForMinScale {
  private _scaleX: number = 1;
  private _scaleY: number = 1;

  public get scaleX(): number {
    return this._scaleX;
  }

  public get scaleY(): number {
    return this._scaleY;
  }

  public setScaleX(value: number): void {
    this._scaleX = value;
  }

  public setScaleY(value: number): void {
    this._scaleY = value;
  }

  public setScaleXWithDfx(value: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._scaleX, value)) {
      return;
    }
    log.showInfo(`[${module}] NeedRenderBackgroundForMinScaleX from ${this._scaleX} to ${value}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._scaleX = value;
  }

  public setScaleYWithDfx(value: number, module: string, reason: string, extra?: string): void {
    if (CommonUtils.equals(this._scaleY, value)) {
      return;
    }
    log.showInfo(`[${module}] NeedRenderBackgroundForMinScaleY from ${this._scaleY} to ${value}. ` +
      `reason: ${reason}, extra: ${extra}`);
    this._scaleY = value;
  }
}

@Observed
export class NeedRenderRecentCoverTranslate {
  public translateX: number = 0;
  public translateY: number = 0;
  public secondaryTranslateX: number = 0;
  public secondaryTranslateY: number = 0;
}

@Observed
export class NeedRenderRecentTitleTranslate {
  public translateX: number = 0;
  public translateY: number = 0;
  public secondaryTranslateX: number = 0;
  public secondaryTranslateY: number = 0;
}

@Observed
export class NeedRenderRecentTitleWidth {
  public width: number = 0;
  public primaryWidth: number = 0;
  public secondaryWidth: number = 0;
}

@Observed
export class NeedRenderRecentClosingAnimating {
  public isClosingAnimating: boolean = false;
}

@Observed
export class NeedRenderSplitBackgroundColor {
  public backgroundColor: ResourceColor = Color.Transparent;
}

@Observed
export class NeedTrackSplitState {
  private _state: SplitState = SplitState.UNDEFINED;

  public get state(): SplitState {
    return this._state;
  }

  public setState(state: SplitState): void {
    this._state = state;
  }
}

class SCBSceneContainerSessionData {
  requestOrientation: SCBSceneOrientation = SCBSceneOrientation.UNSPECIFIED;
  sdkVersion: number = 0;
  transitionAnimationCount: number = 0;
  isRequestLandscape: boolean = false;
  preferSplitBackToFull: boolean = true;
  midSceneFSM: FSM | null = null;
  iconRectInfo: RectInfo = new RectInfo();
  recentSessionInfo: SCBRecentSessionInfo = new SCBRecentSessionInfo();
  needAnimationForSwitchPcMode: boolean = false;
  needActiveForSwitchFWMode: boolean = false;
  isPendingResizeInPcMode: boolean = false;
  attributeModifierMap: Map<number, AttributeUpdater<CommonModifier>> = new Map();
  attributeChanged: boolean = false;

  private missionManagementData: ContainerDataOfMissionManagement;

  get pendingRemove() : boolean {
    return this.missionManagementData.pendingRemove;
  }

  set pendingRemove(pendingRemove: boolean) {
    this.missionManagementData.pendingRemove = pendingRemove;
  }

  /**
   * 初始化容器数据
   * @param dataMap
   */
  public initContainerData(dataMap: Map<ContainerDataCategory, IContainerSessionData>): void {
    this.missionManagementData =
      dataMap.get(ContainerDataCategory.MISSION_MANAGEMENT) as ContainerDataOfMissionManagement;
  }
}

class SCBSceneContainerSessionDataInner {
  // cardBaseScale : scale session icon to cover max screen
  cardBaseScale: number = 1;
  // Cannot change unless the screen property is changed.
  state = SCBSceneContainerState.HIDDEN;
  lastUsedTimestamp: number = Date.now();
  skipRotation: boolean = false;
  refCount: number = 0;
}


// used for PC Clear screen/restore dynamic effect
class SCBSceneSessionTransformData {
  translateX: number = 0;
  translateY: number = 0;
  scale: number = 1;
}

class SCBSceneSessionInvisible {
  value: boolean = false;
}

@Observed
export class NeedRenderMotionBlur {
  private _motionBlurRadius: number = 0;

  /**
   * set motion blur radius.
   *
   * @param { number } blurRadius
   */
  public setMotionBlurRadius(blurRadius: number, caller?: string): void {
    if (CommonUtils.equals(this._motionBlurRadius, blurRadius)) {
      return;
    }
    log.showInfo(`setMotionBlurRadius: ${blurRadius}, caller: ${caller}`);
    this._motionBlurRadius = blurRadius;
  }

  /**
   * get motion blur radius.
   *
   * @returns { number } motionBlurRadius
   */
  public get motionBlurRadius(): number {
    return this._motionBlurRadius;
  }
}

@Observed
export class NeedRenderDragHotAreaAnimConfig {
  public maskPosX: number = 0;
  public maskPosY: number = 0;
  public maskWidth: number = 0;
  public maskHeight: number = 0;
  public animMaskAlpha: number = 0;
  public animMaskBlur: number = 0;
  public animMaskSaturation: number = 1;
  public animMaskColor: string = '#00000000';
  public isWindowDragHotArea: boolean = false;
}

/**
 * Session of a scene.
 */
@Observed
export class SCBSceneContainerSession {
  /**
   * public data of a session,which should not trigger ui flush
   */
  sessionData: SCBSceneContainerSessionData = new SCBSceneContainerSessionData();
  /**
   * private data of a session,which should not exposed to widgets
   */
  private sessionDataInner: SCBSceneContainerSessionDataInner = new SCBSceneContainerSessionDataInner();
  /*
   get function provide to sessionData only. forbid ui flush
   */
  get requestOrientation(): SCBSceneOrientation {
    return this.sessionData.requestOrientation;
  }

  get pendingRemove(): boolean {
    return this.sessionData.pendingRemove;
  }
  /*
   get function provide to sessionData only. forbid ui flush
   */
  get sdkVersion(): number {
    return this.sessionData.sdkVersion;
  }

  get isRequestLandscape(): boolean {
    return this.sessionData.isRequestLandscape;
  }

  get needAnimationForSwitchPcMode(): boolean {
    return this.sessionData.needAnimationForSwitchPcMode;
  }

  get needActiveForSwitchFWMode(): boolean {
    return this.sessionData.needActiveForSwitchFWMode;
  }

  get isPendingResizeInPcMode(): boolean {
    return this.sessionData.isPendingResizeInPcMode;
  }

  readonly containerId: number;
  primarySession: SCBSceneSession | null = null;
  secondarySession: SCBSceneSession | null = null;
  secondarySceneW = '100%';
  secondarySceneH = '100%';
  private primarySessionList: SCBSceneSessionArray = new SCBSceneSessionArray();
  private secondarySessionList: SCBSceneSessionArray = new SCBSceneSessionArray();
  dividerParamList: SCBDividerParamArray = new SCBDividerParamArray();
  screenProperty: SCBScreenProperty = new SCBScreenProperty();
  lastRecentStartBeforeRect: SCBSessionRect = new SCBSessionRect();
  lastRecentStartBeforeRotation: number = -1;

  dividerParam: SCBDividerParam;
  floatingParam: SCBFloatingParam = new SCBFloatingParam();
  dividerSession: SCBSystemSceneSession | null = null;
  dividerButtonSession: SCBSystemSceneSession | null = null;
  compatibleImmersiveTitleSession: SCBSystemSceneSession | null = null;
  midSceneMap: MidSceneMap<number, SCBSceneSession> = new MidSceneMap();
  midAppIconParamMap: MidAppIconParamMap<number, SCBAppIconParam> = new MidAppIconParamMap();
  midFocusSessionList: SCBSceneSessionArray = new SCBSceneSessionArray();
  isMidScene: boolean = false;
  isInMidSceneRecordForPad: boolean = false;
  isStartFromRecentForPad: boolean = false;
  isShowIconInMidScene: boolean = false;
  isSplitStyleConversion: boolean = false;
  isSplit: boolean = false;
  private _isFloat: boolean = false;
  isAutoPiPOneShot: boolean = false;
  isStartPiPInterrupt: boolean = false;
  isFrameLayoutFinish: boolean = true;
  // as float view on full container in recent
  isFloatView: boolean = false;
  isShowOuter: boolean = true;
  isMidExitSplit: boolean = false;
  splitParam: SCBSplitParam = new SCBSplitParam();
  midSceneParam: SCBMidSceneParam = new SCBMidSceneParam();
  toggleHomeState: boolean = false;
  isKeyboardEnableShow: boolean = false;
  showInRecent: boolean = false;
  isShowBackgroundForMinWidth: boolean = true;
  // It can only be used when entering split mode.
  isNotSupportSplit: boolean = false;
  // used for PC Clear screen/restore dynamic effect
  transformData: SCBSceneSessionTransformData = new SCBSceneSessionTransformData();
  // Used by the PC to calculate the multi-window occlusion relationship.
  invisible: SCBSceneSessionInvisible = new SCBSceneSessionInvisible();

  needRenderLockIconOpacity: NeedRenderLockIconOpacity = new NeedRenderLockIconOpacity();
  needRenderLockIconScale: NeedRenderLockIconScale = new NeedRenderLockIconScale();
  needRenderLockIconTranslate: NeedRenderLockIconTranslate = new NeedRenderLockIconTranslate();
  needRenderTitleViewScale: NeedRenderTitleViewScale = new NeedRenderTitleViewScale();
  needPreBuild: NeedPreBuild = new NeedPreBuild();
  needRenderShowInRecent: NeedRenderShowInRecent = new NeedRenderShowInRecent();
  needRenderTranslate: NeedRenderTranslate = new NeedRenderTranslate();
  needRenderSwiperTranslate: NeedRenderSwiperTranslate = new NeedRenderSwiperTranslate();
  needRenderAlpha: NeedRenderAlpha = new NeedRenderAlpha();
  needRenderBorderRadius: NeedRenderBorderRadius = new NeedRenderBorderRadius();
  needRenderPos: NeedRenderPos = new NeedRenderPos();
  needRenderScale: NeedRenderScale = new NeedRenderScale();
  needRenderBlurRadius: NeedRenderBlurRadius = new NeedRenderBlurRadius();
  needRenderVisibility : NeedRenderVisibility = new NeedRenderVisibility();
  needRenderZIndex: NeedRenderZIndex = new NeedRenderZIndex();
  needRenderRotate: NeedRenderRotate = new NeedRenderRotate();
  needRenderClip: NeedRenderClip = new NeedRenderClip();
  needRenderTranslateIcon: NeedRenderTranslateIcon = new NeedRenderTranslateIcon();
  iconAlpha: number = 1;
  isScreenLockIconShow: boolean = true;
  badgeAlpha: number = 1;
  badgeVisibility: boolean = true;
  isPrimarySelected: boolean = true;
  isPairSplitAnimating: boolean = false;
  // cardScale : scale session icon to match desktop icon
  cardScale: number = 1;
  intelligentScene: number = 1;
  companionIconInfo: CompanionIconInfo = null;
  transitionController: SCBTransitionController;
  needRenderRecentMinBackgroundShow: NeedRenderRecentMinBackgroundShow = new NeedRenderRecentMinBackgroundShow();
  needRenderBackgroundForMinScale: NeedRenderBackgroundForMinScale = new NeedRenderBackgroundForMinScale();
  needRenderRecentMinBackgroundSize: NeedRenderRecentMinBackgroundSize = new NeedRenderRecentMinBackgroundSize();
  needRenderRecentMinBackgroundAlpha: NeedRenderRecentMinBackgroundAlpha = new NeedRenderRecentMinBackgroundAlpha();

  needRenderSubSceneShow: NeedRenderSubSceneShow = new NeedRenderSubSceneShow();
  // recent title view alpha, only used in pc currently
  needRenderTitleViewAlpha: NeedRenderTitleViewAlpha = new NeedRenderTitleViewAlpha();
  // window hover state in recent, only used in pc currently
  needRenderRecentHoverState: NeedRenderRecentHoverState = new NeedRenderRecentHoverState();
  // window is selected by the tab key in recent, only used in pc currently
  tabSelected: boolean = false;
  // whether show title view in recent
  needRenderShowRecentTitle: NeedRenderShowRecentTitle = new NeedRenderShowRecentTitle();
  // background's opacity ,only used in deleting pc recent task
  needRenderBackgroundAlpha: NeedRenderBackgroundAlpha = new NeedRenderBackgroundAlpha();
  // scene border radius, only used in pc recent task currently
  needRenderRecentSceneBorderRadius: NeedRenderRecentSceneBorderRadius = new NeedRenderRecentSceneBorderRadius();
  // scale when deleted in pc recent task
  needRenderRecentDeleteScale: NeedRenderRecentDeleteScale = new NeedRenderRecentDeleteScale();
  // translate when deleted in pc recent task
  needRenderRecentDeleteTranslate: NeedRenderRecentDeleteTranslate = new NeedRenderRecentDeleteTranslate();
  // cover scale in pc recent task
  needRenderRecentCoverScale: NeedRenderRecentCoverScale = new NeedRenderRecentCoverScale();
  // cover translate in pc recent task
  needRenderRecentCoverTranslate: NeedRenderRecentCoverTranslate = new NeedRenderRecentCoverTranslate();
  // recent title translate in pc recent task
  needRenderRecentTitleTranslate: NeedRenderRecentTitleTranslate = new NeedRenderRecentTitleTranslate();
  // recent title width in pc recent task
  needRenderRecentTitleWidth: NeedRenderRecentTitleWidth = new NeedRenderRecentTitleWidth();
  // is animating in pc recent task
  needRenderRecentClosingAnimating: NeedRenderRecentClosingAnimating = new NeedRenderRecentClosingAnimating();
  // window background color, only used in pc currently
  needRenderSplitBackgroundColor: NeedRenderSplitBackgroundColor = new NeedRenderSplitBackgroundColor();
  // trace the status of the split screen, only used in pc currently
  needTrackSplitState: NeedTrackSplitState = new NeedTrackSplitState();

  // pc drag hot area animation config
  needRenderDragHotAreaAnimConfigMap: Map<number, NeedRenderDragHotAreaAnimConfig> = new Map();

  _currentRotation: number = 0; // means container Rotation for screen rotate
  tempRotation: number = 0;
  private readonly sessionRotateBackTimeout: number = 1000;
  resetSessionRotationTimeout: number = CommonConstants.INVALID_VALUE;

  needRenderMotionBlur: NeedRenderMotionBlur = new NeedRenderMotionBlur();

  splitSnapshotResource: image.PixelMap | null = null;
  isShowSplitSnapshot: boolean = false;
  // used in scbSceneContainer
  containerSnapshotResource: image.PixelMap | undefined | null = null;
  isShowContainerSnapshot: boolean = false;

  splitSnapshotAlpha: number = 0;
  containerBlurScale: number = 0;
  // 应用加锁禁止删除标记
  isAppLockedForbidDelete: boolean = false;
  /**
   * 卡片点击启动动效场景，动效overlay卡片配置及动效信息
   */
  overlayCardTransition: OverlayCardTransition | null = null;

  /**
   * PC应用G态蒙版参数
   */
  expandGuideParam: SCBExpandGuideParam = new SCBExpandGuideParam();

  /**
   * 应用单独投屏场景，悬浮窗最大化标识
   */
  isFloatingSceneToFullForCast: boolean = false;

  // 窗口最大化拖拽还原自由窗口
  isDragMoveRecover: boolean = false;

  pcWidth : number = 0;
  pcHeight : number = 0;
  pcTop : number = 0;
  pcLeft : number = 0;

  private _isActive: boolean = false;
  private containerRotationChangeCallback: Function;
  private containerActiveModeChangeCallback: Function;
  private containerRefreshSplitSceneCallback: Function;
  private containerFoldChangeCallback: Function;
  private containerFoldChangeForUltraScreenCallback: Function;
  private subSessionStateChangeCallbacks: Map<number, Function> = new Map();
  private updateSubWindowBindingCallbacks: Map<number, Function> = new Map();
  private isSaveSnapshotForMidSceneCallback: Function;

  private interruptedCallbackMap: Map<string, (string)=>void> = new Map();
  private animationReason: string = "";
  public setAnimatingReason(reason: string) {
    this.animationReason = reason;
  }

  public getAnimatingReason(): string {
    return this.animationReason;
  }

  public addInterruptedCallback(type: string, callback: (string)=>void): void {
    this.interruptedCallbackMap.set(type, callback);
  }

  /**
   * 删除对应的打断回调，可以代表该动画已完成
   */
  public eraseInterruptedCallback(type: string): void {
    this.interruptedCallbackMap.delete(type);
  }

  /**
   * 执行该容器其他正在执行的其他动画的打断回调
   */
  public executeInterruptedCallback(type: string): void {
    if (this.interruptedCallbackMap.size > 0) {
      log.showInfo(`[SCBAnimation] execute type: ${type}, map size ${this.interruptedCallbackMap.size},
      container id ${this.containerId}`)
    }
    this.interruptedCallbackMap.forEach((callback)=>{
      callback(type);
    })
  }

  /**
   * 是否正在做动画
   */
  public isAnimating(): boolean {
    return this.interruptedCallbackMap.size > 0;
  }

  /**
   * 此containerSession正在做什么动画
   */
  public GetAllAnimatingType(): Set<string> {
    let types: Set<string> = new Set<string>();
    this.interruptedCallbackMap.forEach((_,key)=> {
      types.add(key);
    })
    return types;
  }

  private static gContainerId: number = 0;
  private stateChangeCallbacks: Array<(previousState: SCBSceneContainerState,
      curState: SCBSceneContainerState) => void> = [];
  /**
   * notification when the interaction status changes. true indicates can interact with containers.
   */
  private interactiveStateChangeCallback: (state: boolean) => void;

  public getOverlaySessionCallback: Array<() => SCBSystemSceneSession[]> = [];

  private updateTitleViewCallback: Function;

  public sideEdgeManagerParam: SCBSideEdgeManagerParam = new SCBSideEdgeManagerParam();
  private screenPropertyByFold: SCBScreenProperty = null;
  private orientationInFold: SCBSceneOrientation = null;
  private _midSceneBlankColor:string = '#00ffffff';
  private _isNeedMidSceneBlank: boolean = false;

  set currentRotation(currentRotation: number) {
    this._currentRotation = currentRotation;
    this.primarySession?.setCurrentRotation(this._currentRotation);
    this.secondarySession?.setCurrentRotation(this._currentRotation);
  }

  get currentRotation(): number {
    return this._currentRotation;
  }

  set midSceneBlankColor(midSceneBlankColor: string) {
    log.showInfo(`set midSceneBlankColor:${midSceneBlankColor}.`);
    this._midSceneBlankColor = midSceneBlankColor;
  }

  get midSceneBlankColor(): string {
    return this._midSceneBlankColor;
  }
  set isNeedMidSceneBlank(isNeedMidSceneBlank: boolean) {
    log.showInfo(`set isNeedMidSceneBlank:${isNeedMidSceneBlank}.`);
    this._isNeedMidSceneBlank = isNeedMidSceneBlank;
  }

  get isNeedMidSceneBlank(): boolean {
    return this._isNeedMidSceneBlank;
  }

  private dataMap: Map<ContainerDataCategory, IContainerSessionData> = new Map();
  private stateMap: Map<ContainerStateCategory, IContainerSessionState> = new Map();
  public registerData(containerData: IContainerSessionData): void {
    log.showInfo(`registerData category:${containerData.category}.`);
    this.dataMap.set(containerData.category, containerData);
  }

  public registerState(containerState: IContainerSessionState): void {
    log.showInfo(`registerState category:${containerState.category}.`);
    this.stateMap.set(containerState.category, containerState);
  }

  public getData(category: ContainerDataCategory.BASIC): ContainerDataOfBasic | null;
  public getData(category: ContainerDataCategory.MISSION_MANAGEMENT): ContainerDataOfMissionManagement | null;
  public getData(category: ContainerDataCategory): IContainerSessionData | null {
    const data = this.dataMap.get(category);
    // 运行时类型检查
    switch (category) {
      case ContainerDataCategory.BASIC:
        return data as ContainerDataOfBasic;
      case ContainerDataCategory.MISSION_MANAGEMENT:
        return data as ContainerDataOfMissionManagement;
      default:
        return null;
    }
  }

  public getContainerState(category: ContainerStateCategory.BASIC): ContainerStateOfBasic | null;
  public getContainerState(category: ContainerStateCategory.MISSION_MANAGEMENT): ContainerStateOfMissionManagement | null;
  public getContainerState(category: ContainerStateCategory): IContainerSessionState | null {
    const state = this.stateMap.get(category);
    // 运行时类型检查
    switch (category) {
      case ContainerStateCategory.BASIC:
        return state as ContainerStateOfBasic;
      case ContainerStateCategory.MISSION_MANAGEMENT:
        return state as ContainerStateOfMissionManagement;
      default:
        return null;
    }
  }

  public get width(): ScbNumber {
    return this.getContainerState(ContainerStateCategory.BASIC).width;
  }

  public get height(): ScbNumber {
    return this.getContainerState(ContainerStateCategory.BASIC).height;
  }

  public set width(w: ScbNumber) {
    this.getContainerState(ContainerStateCategory.BASIC).width = w;
  }

  public set height(h: ScbNumber) {
    this.getContainerState(ContainerStateCategory.BASIC).height = h;
  }

  public get isDisappearing() : boolean {
    return this.getContainerState(ContainerStateCategory.MISSION_MANAGEMENT).isDisappearing;
  }

  public set isDisappearing(isDisappearing: boolean) {
    this.getContainerState(ContainerStateCategory.MISSION_MANAGEMENT).isDisappearing = isDisappearing;
  }

  public get isTerminating() : boolean {
    return this.getData(ContainerDataCategory.MISSION_MANAGEMENT).isTerminating;
  }

  public set isTerminating(isTerminating: boolean) {
    this.getData(ContainerDataCategory.MISSION_MANAGEMENT).isTerminating = isTerminating;
  }

  public get isFloat() : boolean {
    return this._isFloat;
  }

  public set isFloat(isFloat: boolean) {
    if (isFloat){
      this.primarySession?.setSkipEventAndShowOnVirtualScreen(true);
    } else {
      this.primarySession?.setSkipEventAndShowOnVirtualScreen(false);
  }
    log.showInfo(`isFloat ${this._isFloat} to ${isFloat}`);
    this._isFloat = isFloat;
  }

  /**
   * Constructor.
   */
  constructor(primarySession: SCBSceneSession, screenProperty: SCBScreenProperty) {
    this.containerId = ++SCBSceneContainerSession.gContainerId;
    this.primarySession = primarySession;
    if (primarySession) {
      this.primarySessionList.push(primarySession);
    }
    // 根据不同产品初始化数据和状态变量
    ContainerSessionInitializer.getInstance().init(this);
    this.sessionData.initContainerData(this.dataMap);
    this.secondarySession = null;
    this.updateScreenProperty(screenProperty);
    this.needRenderClip.setClipWidth(this.width);
    this.needRenderClip.setClipHeight(this.height);
    this.sessionData.requestOrientation = this.primarySession.requestOrientation;
    let bundleName = this.primarySession?.sceneInfo.bundleName;
    log.showInfo(`bundleName: ${bundleName}, persistentId: ${primarySession?.session.persistentId}`);
    this.sessionData.sdkVersion = this.primarySession.sdkVersion;
    this.dividerParamList.push(new SCBDividerParam());
    this.dividerParam = this.dividerParamList[0];
  }

  /**
   * update screenProperty related property with newScreenProperty
   * @param newScreenProperty
   */
  public updateScreenProperty(newScreenProperty: SCBScreenProperty): void {
    // cannot use reference from scene panel, since recent should use own property, not current screen property
    if (!newScreenProperty) {
      log.showWarn(`updateScreenProperty failed. newScreenProperty is null`);
      return;
    }
    this.screenProperty.copy(newScreenProperty);
    this.width = new ScbNumber(newScreenProperty.width);
    this.height = new ScbNumber(newScreenProperty.height);
    this.currentRotation = newScreenProperty.rotation ?? 0;
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);

    if (screenSession && screenSession.isRotateScreenPolicy()) {
      this.currentRotation = screenSession.scbScreenProperty?.rotation;
    }
  }

  public setPrimarySelectedWithMutex(isPrimarySelected: boolean): void {
    if (this.primarySession) {
      this.primarySession.isSelected = isPrimarySelected;
    }
    if (this.secondarySession) {
      this.secondarySession.isSelected = !isPrimarySelected;
    }
  }

  public resetSessionSelectedStatus(): void {
    if (this.primarySession) {
      this.primarySession.isSelected = false;
    }
    if (this.secondarySession) {
      this.secondarySession.isSelected = false;
    }
  }

  /**
   * Get focused session
   *
   * @returns { SCBSceneSession|null }
   */
  getFocusedSession(): SCBSceneSession | null {
    const focusedSession = SCBSceneSessionManager.getInstance().getFocusedSession(this.screenProperty.screenId);
    if (this.isMidScene) {
      for (let item of this.midSceneMap.values()) {
        if (focusedSession === item || focusedSession?.session.parentId === item.session.persistentId) {
          return item;
        }
      }
      return null;
    }
    return focusedSession === this.secondarySession ?
      this.secondarySession : this.primarySession;
  }

  /**
   * init transition animation count
   */
  initTransitionAnimationCount(): void {
    this.sessionData.transitionAnimationCount = SCBTransitionManager.getInstance().getTransitionCount(this.containerId.toString());
  }

  /**
   * return primary session list
   *
   * @returns { SCBSceneSessionArray }
   */
  public getPrimarySessionList(): SCBSceneSessionArray {
    return this.primarySessionList;
  }

  /**
   * return divider param list
   *
   * @returns {SCBDividerParamArray}
   */
  public getDividerParamList(): SCBDividerParamArray {
    return this.dividerParamList;
  }

  /**
   * remove divider param list
   *
   * @param {SCBDividerParam}
   */
  public removeDivierParam(firstSceneParam: SceneParam, secondSceneParam: SceneParam): void {
    const index = this.getDividerParamList().findIndex((item) => {
      return item.primary === firstSceneParam && item.secondary === secondSceneParam;
    });

    if (index !== -1) {
      this.getDividerParamList().splice(index, 1);
    }
  }

  /**
   * return divider param
   *
   * @returns {SCBDividerParam}
   */
  public getDividerParam(primaryId: number): SCBDividerParam {
    for (let dividerParam of this.dividerParamList) {
      if (dividerParam.primary?.persistentId === primaryId) {
        return dividerParam;
      }
    }
    return this.dividerParam;
  }

  // 所有scene都放里面
  public getMidScenes(): MidSceneMap<number, SCBSceneSession> {
    return this.midSceneMap;
  }

  public getSceneParams(): Array<SceneParam> {
    let sceneParam = [];
    this.midSceneMap.forEach((value) => {
      sceneParam.push(value.sceneParam);
    });
    sceneParam.sort((paramA: SceneParam, paramB: SceneParam) => {
      return parseFloat(paramA.posX) - parseFloat(paramB.posX);
    });
    return sceneParam;
  }

  /**
   * return secondary session list
   *
   * @returns { SCBSceneSessionArray }
   */
  public getSecondarySessionList(): SCBSceneSessionArray {
    return this.secondarySessionList;
  }

  /**
   * Get whether is shown when locked
   *
   * @returns { Boolean }
   */
  public isShowWhenLocked(): boolean {
    return !this.isMidScene && !this.isSplit && this.primarySession &&
      (this.primarySession.isShowWhenLocked || this.primarySession.isTemporarilyShowWhenLocked);
  }

  /**
   * containerSession is topmost if topmost flag is true and primarySession is floating window
   * @returns true if topmost
   */
  public isTopmost(): boolean {
    return this.primarySession?.isTopmost && this.primarySession?.sceneInfo.windowMode === SCBSceneMode.FLOATING;
  }

  /**
   * containerSession is topmost if main window topmost flag is true and primarySession is floating window
   * @returns true if topmost
   */
  public isMainWindowTopmost(): boolean {
    if (!this.primarySession?.isMainWindowTopmost) {
      return false;
    }
    if (this.primarySession?.sceneInfo.windowMode !== SCBSceneMode.FLOATING &&
        this.primarySession?.sceneInfo.windowMode !== SCBSceneMode.FULLSCREEN) {
      return false;
    }
    return true;
  }

  /**
   * containerSession is modal if main window isModal flag is true
   * @returns true if main window is modal
   */
  public isModalMainWindow(): boolean {
    return this.primarySession?.isModal;
  }

  /**
   * Initialize Icon Information
   *
   * @param { SCBSceneInfo } sceneInfo
   * @param { SCBTransitionController } transitionController
   */
  public initCompanionIconInfo(sceneInfo: SCBSceneInfo, transitionController: SCBTransitionController): void {
    if (sceneInfo === undefined || sceneInfo === null) {
      log.showError(`initCompanionIconInfo ${sceneInfo},sceneInfo is null`);
    }
    if (transitionController === undefined || transitionController === null) {
      log.showError(`initCompanionIconInfo ${sceneInfo?.bundleName},${sceneInfo?.abilityName} without transitionController`);
      if (this.companionIconInfo) {
        this.companionIconInfo.isSameLocation = false;
        this.companionIconInfo.smallFolderId = undefined;
        log.showWarn('initCompanionIconInfo controller is null and companionIconInfo is initialized, return');
        return;
      }
    }
    this.companionIconInfo = {
      bundleName: sceneInfo?.bundleName,
      abilityName: sceneInfo?.abilityName,
      moduleName: sceneInfo?.moduleName,
      iconId: transitionController?.appData?.appIconId,
      iconNumber: transitionController?.appData?.appIconNumber,
      iconRadius: transitionController?.appData?.iconRadius,
      startAppType: transitionController?.appData?.startAppType,
      cardId: transitionController?.appData?.cardId,
      extraId: transitionController?.appData?.extraId,
      appIndex: sceneInfo?.appIndex ?? 0,
      shortcutId: transitionController?.appData?.shortcutId,
      isSameLocation: false,
      smallFolderId: undefined
    };
    let iconAnimCount = SCBTransitionManager.getInstance().getTransitionCount(this.containerId.toString());
    this.sessionData.transitionAnimationCount = iconAnimCount;
    log.showInfo(`initCompanionIconInfo transitionAnimationCount:${this.sessionData.transitionAnimationCount}, iconAnimCount:${iconAnimCount}`);
    this.transitionController = transitionController;

    log.showWarn('initCompanionIconInfo companionIconInfo: %{public}s, %{public}s, %{public}s, iconId: %{public}s; persistentId: %{public}d',
      this.companionIconInfo.bundleName, this.companionIconInfo.abilityName, this.companionIconInfo.moduleName, this.companionIconInfo.iconId,
      sceneInfo?.persistentId);
  }

  /**
   * Update icon information
   *
   * @param { SCBTransitionController } transitionController
   */
  public updateCompanionIconInfo(transitionController: SCBTransitionController): void {
    if (transitionController?.appData === undefined || transitionController?.appData === null) {
      log.showError('updateCompanionIconInfo without transitionController');
      return;
    }
    this.companionIconInfo.iconId = transitionController.appData.appIconId;
    this.companionIconInfo.iconNumber = transitionController.appData.appIconNumber;
    this.companionIconInfo.iconRadius = transitionController.appData.iconRadius;
  }

  /**
   * Add scene session to this container.
   *
   * @param { SCBSceneSession|null } sceneSession
   */
  public addSceneSession(sceneSession?: SCBSceneSession | null): void {
    if (!sceneSession) {
      log.showError('Add scene session failed as scene session is null!');
      return;
    }
    if (!!this.primarySession && !!this.secondarySession) {
      log.showError('Add scene session failed! primary & second not null.');
      return;
    }
    if (this.primarySession === sceneSession || this.secondarySession === sceneSession) {
      log.showError('Add scene session failed as scene session is already existed!');
      return;
    }
    if (!this.primarySession) {
      this.primarySession = sceneSession;
      this.primarySession.sceneParam = sceneSession.sceneParam;
      this.primarySessionList.push(sceneSession);
      this.sessionData.requestOrientation = this.getContainerRequestOrientation();
      return;
    }
    log.showInfo('Add secondary scene session succ.');
    if (sceneSession?.subSessionList){
      for (let subSession of sceneSession.subSessionList) {
        let callback = this.subSessionStateChangeCallbacks.get(subSession.screenId);
        if (callback) {
          subSession.updateSessionStateChangeFunc(callback);
        }
      }
    }
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    if (uiType === SCBConstants.UITYPE_PHONE) {
      this.dividerParam.needCutOut = true;
    }
    this.secondarySession = sceneSession;
    this.secondarySession.sceneParam = sceneSession.sceneParam;
    this.secondarySessionList.push(sceneSession);
    this.sessionData.requestOrientation = this.getContainerRequestOrientation();
    SCBSceneMissionManager.getInstance().notifyAddSceneSession(this);
  }

  /**
   * Remove scene session from this container.
   *
   * @param { SCBSceneSession } sceneSession
   */
  public removeSceneSession(sceneSession: SCBSceneSession): void {
    if (!this.primarySession || !this.secondarySession) {
      log.showError('Remove scene session failed as primary or second session is null! primarySession is null? ' +
        (!this.primarySession));
      return;
    }
    this.removeSceneSessionInContainer(sceneSession);
  }

  public removeSceneSessionInContainer(sceneSession: SCBSceneSession): void {
    if (!sceneSession) {
      log.showError('Remove scene session failed as scene session is null!');
      return;
    }
    log.showInfo(`remove sceneSession: ${sceneSession?.getName()}`);

    if (this.primarySession === sceneSession) {
      this.removeSceneSessionFromList(sceneSession, this.primarySessionList);
      this.primarySession = this.secondarySession;
      this.primarySessionList.push(this.secondarySession);
      this.removeSceneSessionFromList(this.secondarySession, this.secondarySessionList);
      this.secondarySession = null;
    } else if (this.secondarySession === sceneSession) {
      this.removeSceneSessionFromList(sceneSession, this.secondarySessionList);
      this.secondarySession = null;
    } else {
      log.showWarn('Remove scene session failed as the scene session is not in this container!');
    }
    this.sessionData.requestOrientation = this.getContainerRequestOrientation();
  }

  public removeSceneSessionFromMidScene(sceneSession: SCBSceneSession | null, removeFromSplit: boolean = false): void {
    if (sceneSession === null) {
      log.showError('removeSceneSessionFromMidScene failed, scene session is null!');
      return;
    }
    log.showInfo(`removeSceneSessionFromMidScene sceneSession=${sceneSession.session.persistentId}, ` +
      `removeFromSplit=${removeFromSplit}`);
    if (removeFromSplit) {
      if (this.primarySession === sceneSession) {
        this.removeSceneSessionFromList(sceneSession, this.primarySessionList);
        if (this.midAppIconParamMap.has(sceneSession.session.persistentId)) {
          this.midAppIconParamMap.delete(sceneSession.session.persistentId);
        }
        this.primarySession = null;
      } else if (this.secondarySession === sceneSession) {
        this.removeSceneSessionFromList(sceneSession, this.secondarySessionList);
        if (this.midAppIconParamMap.has(sceneSession.session.persistentId)) {
          this.midAppIconParamMap.delete(sceneSession.session.persistentId);
        }
        this.secondarySession = null;
      } else {
        log.showWarn('removeSceneSessionFromMidScene failed, scene session is not in this container!');
        return;
      }
      log.showInfo(`removeSceneSessionFromMidScene sucess, ` +
        `primarySession=${this.primarySession?.session.persistentId}, ` +
        `secondarySession=${this.secondarySession?.session.persistentId}`);
      return;
    }

    if (this.midSceneMap.has(sceneSession.session.persistentId)) {
      this.midSceneMap.delete(sceneSession.session.persistentId);
    }
    if (this.midAppIconParamMap.has(sceneSession.session.persistentId)) {
      this.midAppIconParamMap.delete(sceneSession.session.persistentId);
    }
    log.showInfo(`removeSceneSessionFromMidScene sucess, midSceneMap.size=${this.midSceneMap.size}`);
  }

  /**
   * clean sessionList only, keep session unchanged.
   * In mid scene mostly only session list session update, but session
   *
   * @param { sceneSession } SCBSceneSession | null
   * @returns void
   */
  public removeSessionListFromMidScene(sceneSession: SCBSceneSession | null): void {
    if (sceneSession === null) {
      log.showError('removeSessionListFromMidScene failed, scene session is null!');
      return;
    }
    if (this.primarySessionList[0] === sceneSession) {
      this.removeSceneSessionFromList(sceneSession, this.primarySessionList);
      if (this.midAppIconParamMap.has(sceneSession.session.persistentId)) {
        this.midAppIconParamMap.delete(sceneSession.session.persistentId);
      }
    } else if (this.secondarySessionList[0] === sceneSession) {
      this.removeSceneSessionFromList(sceneSession, this.secondarySessionList);
      if (this.midAppIconParamMap.has(sceneSession.session.persistentId)) {
        this.midAppIconParamMap.delete(sceneSession.session.persistentId);
      }
    } else {
      log.showWarn('removeSessionListFromMidScene failed, scene session is not in list!');
      return;
    }
    log.showInfo(`removeSessionListFromMidScene sucess, ` +
      `primarySession=${this.primarySessionList[0]?.session.persistentId}, ` +
      `secondarySession=${this.secondarySessionList[0]?.session.persistentId}`);
    return;
  }

  /**
   * Removes the specified scene session from the scene session list
   *
   * @param { SCBSceneSession } exitSceneSession
   * @param { SCBSceneSessionArray } sceneSessionList
   */
  public removeSceneSessionFromList(exitSceneSession: SCBSceneSession, sceneSessionList: SCBSceneSessionArray): void {
    const index = sceneSessionList.findIndex((item) => {
      return item.sceneInfo.persistentId === exitSceneSession.sceneInfo.persistentId;
    });
    if (index !== -1) {
      log.showInfo(`removeSceneSessionFromList: session id: ${exitSceneSession.sceneInfo.persistentId}`);
      sceneSessionList.splice(index, 1);
    }
  }

  /**
   * Replace the scene session
   *
   * @param { SCBSceneSession } replacedSession
   * @param { SCBSceneSession } newSceneSession
   */
  public replaceSceneSession(replacedSession: SCBSceneSession, newSceneSession: SCBSceneSession): void {
    if (replacedSession == null || newSceneSession == null) {
      log.showError('replace scene session failed as scene session is null!');
      return;
    }
    log.showInfo(`replacedSession: ${replacedSession.getName()}, newSceneSession: ${newSceneSession.getName()}`);
    if (replacedSession === this.primarySession) {
      this.removeSceneSessionFromList(replacedSession, this.primarySessionList);
      this.primarySession = newSceneSession;
      this.primarySessionList.push(this.primarySession);
    } else if (replacedSession === this.secondarySession) {
      this.removeSceneSessionFromList(replacedSession, this.secondarySessionList);
      this.secondarySession = newSceneSession;
      this.secondarySessionList.push(this.secondarySession);
    } else {
      log.showWarn('replace scene session failed because the scene session is not found!');
    }
    this.sessionData.requestOrientation = this.getContainerRequestOrientation();
  }

  /**
   * Request activation
   *
   * @param { Boolean } isNewActive
   * @param { ActiveReason } reason is reason of requestActivation
   * @param { Boolean } isPersist
   * @param { fromPersistentId } active request session persistent id
   */
  public requestActivation(isNewActive?: boolean, reason?: ActiveReason, isPersist: boolean = true,
    fromPersistentId?: number): void {
    this.updateTerminateStatus(false);
    this._isActive = true;
    this.requestActivationWithPersist(isNewActive, isPersist, reason, fromPersistentId);
  }

  /**
   * request Activation ByCall to startAbilityByCall
   *
   * @param { Boolean } isToForeground is to Foreground or BACKGROUND
   */
  public requestActivationByCall(isToForeground: boolean): void {
    TraceUtil.startTrace(DomainName.WINDOW, MissionManagementTraceUtil.ACTIVE_SCENE_BY_CALL);
    try {
      this.updateLastUsedTimestamp(Date.now());
      this._isActive = isToForeground;
      SCBSceneMissionManager.getInstance().notifySessionRequestActivation(this);
      this.primarySession && this.primarySession.requestSessionActivationByCall(true, isToForeground);
      this.secondarySession && this.secondarySession.requestSessionActivationByCall(false, isToForeground);
    } catch (err) {
      WinLog.showError(WinLogDomain.WMS_LIFE, 'requestActivationByCall failed, with reason ' + JSON.stringify(err));
    } finally {
      TraceUtil.endTrace(DomainName.WINDOW, MissionManagementTraceUtil.ACTIVE_SCENE_BY_CALL);
    }
  }

  /**
   * request session active and update Persist map
   *
   * @param { Boolean } isNewActive is new active
   * @param { Boolean } isPersist is update persist map or not
   * @param { ActiveReason } reason is reason of requestActivation
   * @param { fromPersistentId } active request session persistent id
   */
  public requestActivationWithPersist(isNewActive?: boolean, isPersist?: boolean, reason?: ActiveReason,
    fromPersistentId?: number): void {
    this.updateLastUsedTimestamp(Date.now());
    WinLog.showWarn(WinLogDomain.WMS_LIFE, `Request scene container session activation, name: ${this.getName()} ` +
      `isNewActive: ${isNewActive}, isPersist: ${isPersist}, reason: ${reason}`);
    this.updateTerminateStatus(false);
    this.isDisappearing = false;
    this.sessionData.pendingRemove = false;
    this.notifyInteractiveStateChange(true);
    SCBSceneMissionManager.getInstance().notifySessionRequestActivation(this);
    if (!this.isMidScene) {
      // if it is not a request source and is active, set isNewActive to false
      const priNewActive =  isNewActive && (fromPersistentId === undefined ||
        fromPersistentId === this.primarySession.sceneInfo.persistentId ||
        !(this.isSplit && this.primarySession.isActive));
      this.primarySession?.requestSessionActivation(priNewActive, isPersist, reason, this.currentRotation,
        this.getData(ContainerDataCategory.BASIC)?.lastUsedPosition);
      if (this.isSplit && this.secondarySession) {
        const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
        const isPc: boolean = uiType === SCBConstants.UITYPE_PC;
        const secNewActive =  isNewActive && (fromPersistentId === this.secondarySession.sceneInfo.persistentId ||
          !(isPc && this.secondarySession.isActive));
        this.secondarySession && this.secondarySession.requestSessionActivation(secNewActive,
          isPersist, reason, this.currentRotation, this.getData(ContainerDataCategory.BASIC)?.lastUsedPosition);
      }
    } else {
      for (let ele of this.midSceneMap) {
        ele[1].requestSessionActivation(isNewActive, isPersist, reason, this.currentRotation,
          this.getData(ContainerDataCategory.BASIC)?.lastUsedPosition);
      }
    }
  }

  /**
   * update all session isNewWant
   *
   * @param { Boolean } isNewWant is new active
   * @param { string } updateFrom from where to update
   */
  public updateSessionIsNewWant(isNewWant: boolean, updateFrom: string): void {
    WinLog.showInfo(WinLogDomain.WMS_LIFE, `update session isNewWant: ${isNewWant}, updatefrom: ${updateFrom}`);
    if (this.primarySession) {
      this.primarySession.sessionData.isNewWant = isNewWant;
    }
    if (this.secondarySession) {
      this.secondarySession.sessionData.isNewWant = isNewWant;
    }
    for (let ele of this.midSceneMap) {
      ele[1].sessionData.isNewWant = isNewWant;
    }
  }

  /**
   * Request to put the scene in the background.
   *
   * @param { Boolean } isDelegator
   * @param { Boolean } isToDeskTop
   * @param { Boolean } isSaveSnapshot
   * @param { Boolean } isPersist
   */
  public requestBackground(isDelegator?: boolean, isToDeskTop?: boolean, isSaveSnapshot?: boolean,
    isPersist: boolean = true, backgroundReason: BackgroundReason = BackgroundReason.DEFAULT): void {
    if (!this._isActive) {
      WinLog.showInfo(WinLogDomain.WMS_LIFE, 'requestBackground The scene is already background');
      return;
    }
    this.requestSceneBackground(isDelegator, isToDeskTop, isSaveSnapshot, isPersist, backgroundReason);
  }

  /**
   * Request to put the scene in the background.
   *
   * @param { Boolean } isDelegator
   * @param { Boolean } isToDeskTop
   * @param { Boolean } isSaveSnapshot
   * @param { Boolean } isPersist
   */
  public requestSceneBackground(isDelegator?: boolean, isToDeskTop?: boolean, isSaveSnapshot?: boolean,
    isPersist: boolean = true, backgroundReason: BackgroundReason = BackgroundReason.DEFAULT): void {
    this.notifyInteractiveStateChange(false);
    WinLog.showWarn(WinLogDomain.WMS_LIFE, 'requestSceneBackground, name: ' + this.getName() +
      ' isToDeskTop:' + isToDeskTop + ' isDelegator:' + isDelegator + ' isSaveSnapshot:' + isSaveSnapshot);
    if (isPersist) {
      SCBSceneSessionManager.getInstance().getScenePersistent().modifyPersistentMap(
        this.primarySession.session.persistentId & BIT_MASK, this.primarySession.sceneInfo, this.currentRotation,
        this.getData(ContainerDataCategory.BASIC)?.lastUsedPosition);
    }
    this._isActive = false;
    this.updatePipStartStatusWhenBackground();
    if (this.isMidScene) {
      for (let ele of this.midSceneMap.entries()) {
        ele[1].requestSessionBackground(isDelegator, isToDeskTop,
          !this.isSaveSnapshotForMidScene(this, ele[0]) ? isSaveSnapshot : false);
      }
    } else {
      this.primarySession && this.primarySession.requestSessionBackground(isDelegator, isToDeskTop, isSaveSnapshot,
        backgroundReason);
      this.secondarySession && this.secondarySession.requestSessionBackground(isDelegator, isToDeskTop, isSaveSnapshot,
        backgroundReason);
    }
  }

  /**
   * split or midScene focused session start pip when backGround
   */
  private updatePipStartStatusWhenBackground(): void {
    if (this.isMidScene) {
      this.updateMidPipStartStatus();
    } else {
      this.updateSplitPipStartStatus();
    }
  }

  // update midScene start pip status
  private updateMidPipStartStatus(): void {
    let focusSessionList: SCBSceneSessionArray = this.midFocusSessionList;
    focusSessionList = focusSessionList.filter(item => item.isAutoStartPiP);
    log.showInfo(`focusSessionlist length: ${focusSessionList.length}`);
    if (focusSessionList.length === SESSION_TWO) {
      this.updatePipStatusForTwoSessions(focusSessionList);
    } else if (focusSessionList.length === SESSION_THREE) {
      this.updatePipStatusForThreeSessions(focusSessionList);
    } else {
      log.showInfo(`focusSessionList has 0 or more than three session cannot background`);
    }
  }

  // midScene has two sessions
  private updatePipStatusForTwoSessions(focusSessionList: SCBSceneSessionArray): void {
    const [firstSession, secondSession]: SCBSceneSessionArray = focusSessionList;
    if (firstSession.pipTypePriority === secondSession.pipTypePriority) {
      firstSession.isNeedStartPiP = false;
    } else {
      firstSession.isNeedStartPiP = secondSession.pipTypePriority < firstSession.pipTypePriority;
      secondSession.isNeedStartPiP = firstSession.pipTypePriority < secondSession.pipTypePriority;
    }
  }

  // midScene has three sessions
  private updatePipStatusForThreeSessions(focusSessionList: SCBSceneSessionArray): void {
    const highPrioritySessionCount = focusSessionList.filter(session => session.pipTypePriority === 1).length;
    switch (highPrioritySessionCount) {
      case SESSION_ZERO:
      case SESSION_THREE:
        focusSessionList.slice(SESSION_ZERO, SESSION_TWO).forEach(session => session.isNeedStartPiP = false);
        log.showInfo(`autostart pip the finally session id: ${focusSessionList[SESSION_TWO].sceneInfo.persistentId}`);
        break;
      case SESSION_ONE:
        focusSessionList.forEach((session, index) => {
          session.isNeedStartPiP = index === focusSessionList.findIndex(sess => sess.pipTypePriority === 1);
        });
        break;
      case SESSION_TWO:
        if (focusSessionList[SESSION_TWO].pipTypePriority === 1) {
          focusSessionList.slice(SESSION_ZERO, SESSION_TWO).forEach(session => session.isNeedStartPiP = false);
          focusSessionList[SESSION_TWO].isNeedStartPiP = true;
          log.showInfo(`autostart pip the finally session id: ${focusSessionList[SESSION_TWO].sceneInfo.persistentId}`);
          return;
        }
        if (focusSessionList[SESSION_TWO].pipTypePriority === 0) {
          focusSessionList[SESSION_ZERO].isNeedStartPiP = false;
          focusSessionList[SESSION_TWO].isNeedStartPiP = false;
          focusSessionList[SESSION_ONE].isNeedStartPiP = true;
          log.showInfo(`autostart pip the finally session id: ${focusSessionList[SESSION_ONE].sceneInfo.persistentId}`);
        }
        break;
      default:
        break;
    }
  }

  // update split start pip status
  public updateSplitPipStartStatus(): void {
    if (!this.isSplit || !this.primarySession || !this.secondarySession) {
      log.showWarn(`current is not split or primarySession is null or secondarySession is null`);
      return;
    }
    if (this.primarySession.isAutoStartPiP && this.secondarySession.isAutoStartPiP) {
      const focusSessionList: SCBSceneSessionArray = SCBSceneSessionManager.getInstance().splitFocusSessionList;
      const hasExactTwoSessionsWithSamePriority: boolean = focusSessionList.length === SESSION_TWO &&
        focusSessionList[SESSION_ZERO].pipTypePriority === focusSessionList[SESSION_ONE].pipTypePriority;
      const hasExactTwoSessionsWithDifferentPriority: boolean = focusSessionList.length === SESSION_TWO &&
        focusSessionList[SESSION_ZERO].pipTypePriority !== focusSessionList[SESSION_ONE].pipTypePriority;

      // two split session priority same
      if (hasExactTwoSessionsWithSamePriority) {
        log.showInfo(`two session all support autoStart pip and have the same priority of start pip, previousSession ` +
          `persistentId: ${focusSessionList[SESSION_ZERO].sceneInfo.persistentId} + finallySession ` +
          `persistentId: ${focusSessionList[SESSION_ONE].sceneInfo.persistentId}`);
        const primarySessionIsFinally: boolean = this.primarySession === focusSessionList[SESSION_ONE];
        const secondarySessionIsFinally: boolean = this.secondarySession === focusSessionList[SESSION_ONE];

        // start the finally focus session pip when background
        if (primarySessionIsFinally) {
          this.secondarySession.isNeedStartPiP = false;
        } else if (secondarySessionIsFinally) {
          this.primarySession.isNeedStartPiP = false;
        }
        return;
      }

      // two split session priority different, start hight priority session pip when background
      if (hasExactTwoSessionsWithDifferentPriority) {
        focusSessionList[SESSION_ONE].isNeedStartPiP = focusSessionList[SESSION_ZERO].pipTypePriority <
          focusSessionList[SESSION_ONE].pipTypePriority;
        focusSessionList[SESSION_ZERO].isNeedStartPiP = focusSessionList[SESSION_ONE].pipTypePriority <
          focusSessionList[SESSION_ZERO].pipTypePriority;
      }
    }
  }

  /**
   * Notify the foreground of the interaction status
   *
   * @param interactive
   */
  public notifyForegroundInteractiveStatus(interactive: boolean): void {
    if (!this._isActive) {
      log.showInfo('The scene already background, containerId: ' + this.containerId);
      return;
    }
    this.notifyInteractiveStateChange(interactive);
    this.primarySession?.notifyForegroundInteractiveStatus(interactive);
    if (this.isSplit) {
      this.secondarySession?.notifyForegroundInteractiveStatus(interactive);
    }
    for (let ele of this.midSceneMap) {
      ele[1].notifyForegroundInteractiveStatus(interactive);
    }
  }

  /**
   * reset Transition Controller
   */
  public resetTransitionController(): void {
    if (this.transitionController) {
      this.transitionController.onInactive(TAG, 'resetTransitionController');
      this.transitionController = null;
    }
  }

  /**
   * update Transition Controller
   */
  public updateTransitionController(controller: SCBTransitionController): void {
    this.resetTransitionController();
    this.transitionController = controller;
  }

  /**
   * reset CompanionIconInfo
   */
  public resetCompanionIconInfo(): void {
    this.companionIconInfo = null;
  }

  /**
   * Obtains the ID of the scenario container component
   *
   * @returns { string }
   */
  public getSceneContainerComponentId(): string {
    return `SCBSceneContainer_${this.containerId}`;
  }

  /**
   * Method to request a background with a transition effect
   *
   * @param { Boolean } isBackToIcon
   * @param { Boolean } isToDeskTop
   */
  public requestBackgroundWithTransitionOut(isBackToIcon: boolean = true, isToDeskTop?: boolean): void {
    this.requestBackground(false, isToDeskTop);
    this.isDisappearing = true;
    if (this._isActive && !isBackToIcon) {
      this.resetTransitionController();
    }
  }

  /**
   * transition Out Finish
   */
  public transitionOutFinish(isHomeSwiper: boolean = false): void {
    log.showWarn(`transitionOutFinish, id: ${this.containerId}`);
    this.isDisappearing = false;
    this.clearTransitionCount(isHomeSwiper);
    SCBTransitionManager.getInstance().cleanTransition(this.transitionController);
    if (!this.isFloat) {
      this.init();
    }
  }

  // if this is the last animation, need call transitionOutFinish
  public transitionOutFinishIfNeed(animationNum: number, isNeedSetDesktopCache: boolean = true,
                                   isNeedtransitionOutFinish: boolean = true): boolean {
    let isLastAnimation = (animationNum === this.getTransitionCount());
    if (isLastAnimation) {
      // 确保所有的启动/退出动效结束后再取消节点组标记
      if (SCBTransitionManager.getInstance().getStartExitAnimationCount() === 0 && isNeedSetDesktopCache) {
        let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
        SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'transitionOutFinishIfNeed', true, expandStatus);
      }
      if (SCBTransitionManager.getInstance().getStartExitAnimationCount() === 0) {
        GlobalContext.getContext()?.eventHub.emit(SCBConstants.SCENE_CONTAINER_TRANSITION_OUT_END);
      }
      if (isNeedtransitionOutFinish) {
        this.transitionOutFinish();
      }
    }
    return isLastAnimation;
  }

  /**
   * transition in finish
   */
  public transitionInFinish(isMoveStarting: boolean = false): void {
    this.needRenderBorderRadius.setBorderRadiusWithDfx(SCBConstants.DEFAULT_WINDOWS_RADIUS_0, TAG,
      'transitionInFinish', this.getName());
    this.clearTransitionCount();
    if (isMoveStarting) {
      this.transitionController?.onInactiveWithMoveStarting(TAG, 'transitionInFinish');
    } else {
      this.transitionController?.onInactive(TAG, 'transitionInFinish');
    }
  }

  /**
   * Transition animation in Finish
   *
   * @param { Number } animationNum
   * @return { Boolean }
   */
  public transitionInFinishIfNeed(animationNum: number, isMoveStarting: boolean = false): boolean {
    let isLastAnimation = (animationNum === this.getTransitionCount());
    if (isLastAnimation) {
      if (SCBTransitionManager.getInstance().getStartExitAnimationCount() === 0) {
        let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
        SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'transitionInFinishIfNeed', true, expandStatus);
      }
      this.transitionInFinish(isMoveStarting);
    }
    return isLastAnimation;
  }

  /**
   * Clear Container Session Data
   */
  public clearContainerSessionData(): void {
    if (this.primarySession) {
      this.primarySession.sessionData.requestOrientation = this.primarySession.defaultRequestOrientation;
      this.primarySession.syncDefaultRequestedOrientation(this.primarySession.defaultRequestOrientation);
    }
    if (this.secondarySession) {
      this.secondarySession.sessionData.requestOrientation = this.secondarySession.defaultRequestOrientation;
      this.secondarySession.syncDefaultRequestedOrientation(this.secondarySession.defaultRequestOrientation);
    }
    this.sessionData.requestOrientation = this.getContainerRequestOrientation();
    log.showInfo('clearContainerSessionData');
  }

  /**
   * get first sceneSession while in split mode
   *
   * @returns { SCBSceneSession }
   */
  public getFirstSceneSession(): SCBSceneSession {
    return this.dividerParam.splitOrderIsNotReverse ? this.primarySession : this.secondarySession;
  }

  /**
   * get second sceneSession while in split mode
   *
   * @returns { SCBSceneSession }
   */
  public getSecondSceneSession(): SCBSceneSession {
    return this.dividerParam.splitOrderIsNotReverse ? this.secondarySession : this.primarySession;
  }

  /**
   * Request to destroy a scenario container session.
   *
   * @param { Boolean } isDeletePersistentMap
   * @param { Boolean } needClearData
   * @param { Boolean } isSaveSnapshot
   * @param { Boolean } isForceClean
   * @param { Boolean } isUserRequestedExit
   */
  public requestDestruction(isDeletePersistentMap: boolean, needClearData: boolean = false,
                            isSaveSnapshot?: boolean, isForceClean?: boolean, isUserRequestedExit?: boolean): void {
    WinLog.showWarn(WinLogDomain.WMS_LIFE, `Request scene container session destruction, name: ${this.getName()} ` +
      `delete: ${isDeletePersistentMap} needClearData: ${needClearData} isSaveSnapshot: ${isSaveSnapshot} ` +
      `isForceClean: ${isForceClean}`);
    this._isActive = false;
    if (needClearData) {
      this.clearContainerSessionData();
    }
    this.primarySession && this.primarySession.requestSessionDestruction(isDeletePersistentMap,
      isSaveSnapshot,
      !this.primarySession.sessionData.isForceCleanWhenClearAll ?
      this.primarySession.sessionData.isForceCleanWhenClearAll :
        isForceClean, isUserRequestedExit);
    this.secondarySession && this.secondarySession.requestSessionDestruction(isDeletePersistentMap,
      isSaveSnapshot,
      !this.secondarySession.sessionData.isForceCleanWhenClearAll ?
      this.secondarySession.sessionData.isForceCleanWhenClearAll :
        isForceClean, isUserRequestedExit);
    for (let ele of this.midSceneMap.values()) {
      ele.requestSessionDestruction(isDeletePersistentMap, isSaveSnapshot,
        ele.sessionData.isForceCleanWhenClearAll ? ele.sessionData.isForceCleanWhenClearAll : isForceClean,
        isUserRequestedExit);
    }
  }

  /**
   * Request to destroy the scene container session with transition out effect
   *
   * @param { Boolean } isDeletePersistentMap
   * @param { Boolean } isBackToIcon
   * @param { Boolean } needClearData
   * @param { Boolean } fromDelete
   * @param { Boolean } isUserRequestedExit
   */
  public requestDestructionWithTransitionOut(isDeletePersistentMap: boolean, isBackToIcon: boolean = true,
                                             needClearData: boolean = false, fromDelete: boolean = false,
                                             isUserRequestedExit: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_LIFE, 'Request scene container session destruction with transition out, id: ' + this.getName() +
      ' isActive ' + this._isActive + ' delete ' + isDeletePersistentMap +
      ' isBackToIcon ' + isBackToIcon + ' needClearData ' + needClearData);
    if (isDeletePersistentMap) {
      this.sessionData.pendingRemove = true;
    }
    this.isDisappearing = true;
    if (!isBackToIcon && this._isActive) {
      this.resetTransitionController();
    }
    this.requestDestruction(isDeletePersistentMap, needClearData, true, fromDelete, isUserRequestedExit);
  }

  /**
   * Set whether to clear sessions.
   *
   * @param { Boolean } isClearSession
   */
  public setIsClearSession(isClearSession: boolean): void {
    if (this.primarySession) {
      this.primarySession.setIsClearSession(isClearSession);
    }
    if (this.secondarySession) {
      this.primarySession.setIsClearSession(isClearSession);
    }
  }

  /**
   *  Update the terminate status.
   *
   * @param { Boolean } isTerminating
   */
  public updateTerminateStatus(isTerminating: boolean): void {
    this.isTerminating = isTerminating;
  }

  /**
   * initializer
   */
  public init(needClearShowInRecent: boolean = true): void {
    let extra: string = this.getName();
    this.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'init', extra);
    this.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'init', extra);
    this.needRenderScale.setScaleXWithDfx(1, TAG, 'init', extra);
    this.needRenderScale.setScaleYWithDfx(1, TAG, 'init', extra);
    this.needRenderRecentMinBackgroundShow.primarySessionShow = false;
    this.needRenderRecentMinBackgroundShow.secondSessionShow = false;
    this.needRenderSubSceneShow.showSubScene(NeedRenderSubSceneShow.subSceneShow);
    this.needRenderBackgroundForMinScale.setScaleXWithDfx(1, TAG, 'init', extra);
    this.needRenderBackgroundForMinScale.setScaleYWithDfx(1, TAG, 'init', extra);
    this.needRenderScale.centerX = '50%';
    this.needRenderScale.centerY = '50%';
    this.width = new ScbNumber(this.screenProperty.width);
    this.height = new ScbNumber(this.screenProperty.height);
    this.needRenderBorderRadius.setBorderRadiusWithDfx(DeviceHelper.getDeviceRadius(SCBScreenSessionManager.getInstance()
      .isFoldablePhoneExpandStatus()), TAG, 'init', extra);
    if (needClearShowInRecent) {
      this.needRenderShowInRecent.setShowInRecentWithDfx(false, TAG, 'init', extra);
    }
    this.needRenderPos.setPosXWithDfx(0, TAG, 'init', extra);
    this.needRenderPos.setPosYWithDfx(0, TAG, 'init', extra);
    this.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'init', extra);
    this.iconAlpha = 0;
    this.isDisappearing = false;
    this.needRenderBlurRadius.setBlurRadiusWithDfx(-1, TAG, 'init', extra);
    this.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'init', extra);
    this.needRenderClip.setClipHeight(this.screenProperty.height);
    this.needRenderClip.setClipWidth(this.screenProperty.width);
    this.needRenderTranslateIcon.translateIconX = 0;
    this.needRenderTranslateIcon.translateIconY = 0;
    this.intelligentScene = 1;
    this.needRenderRotate.setAngleWithDfx(0, TAG, 'init', extra);
    this.needPreBuild.setPreBuildStageWithDfx(PreBuildStage.NOT_PRE_BUILD);
    this.onTransitionSwiper(0, 'init');
    SCBRecentSessionHelper.init(this);
    log.showDebug(`id:${this.containerId}, initWidth:${this.width.getPx()}, initHeight:${this.height.getPx()}`);
  }

  /**
   * Initialize all parameters.
   */
  public initAll(): void {
    this.init();
    if (this.isMidScene) {
      // if it's in midscene, init it
      for (let sceneSession of this.getMidScenes()) {
        let dividerParam = this.getDividerParam(sceneSession[0]);
        dividerParam.initInMid();
      }
      this.midSceneParam.init();
      return;
    }

    this.dividerParam.init();
  }

  /**
   * one step split in landscape
   * set position to the end of gesture after container rotation
   *
   * @param { Number } rotation
   */
  public resetPositionInLandscape(rotation: number): void {
    let translateX = this.needRenderTranslate.translateX;
    let translateY = this.needRenderTranslate.translateY;
    if (rotation === RotationConstants.ROTATION_270 ) {
      this.needRenderTranslate.setTranslateXWithDfx(-translateY, TAG, 'resetPositionInLandscape', this.getName());
      this.needRenderTranslate.setTranslateYWithDfx(translateX, TAG, 'resetPositionInLandscape', this.getName());
    } else {
      this.needRenderTranslate.setTranslateXWithDfx(translateY, TAG, 'resetPositionInLandscape', this.getName());
      this.needRenderTranslate.setTranslateYWithDfx(-translateX, TAG, 'resetPositionInLandscape', this.getName());
    }
    this.needRenderPos.setPosXWithDfx(0, TAG, 'resetPositionInLandscape', this.getName());
    this.needRenderPos.setPosYWithDfx(0, TAG, 'resetPositionInLandscape', this.getName());
  }

  public getContainerWindowMode(): SCBSceneMode {
    if (this.primarySession && this.secondarySession) {
      return SCBSceneMode.FULLSCREEN;
    } else if (this.primarySession) {
      return this.primarySession.sceneInfo.windowMode;
    } else if (this.secondarySession) {
      return this.secondarySession.sceneInfo.windowMode;
    }
    return SCBSceneMode.UNDEFINED;
  }

  /**
   * Determine whether to display
   *
   * @returns { boolean }
   */
  public enableShow(): boolean {
    if (DeviceHelper.isPC()) {
      log.showInfo(`isActivate: ${this._isActive} isDisappearing: ${this.isDisappearing}`);
    }
    return this._isActive || this.isDisappearing;
  }

  /**
   * Setting the Display of Recent Conversations
   */
  public setShowRecent(): void {
    this.primarySession?.session.setShowRecent();
    this.secondarySession?.session.setShowRecent();
    this.midSceneMap.forEach((sceneSession: SCBSceneSession) => {
      sceneSession?.session.setShowRecent();
    });
    this.notifyInteractiveStateChange(false);
    log.showInfo(`setShowRecent: ${this.getName()}`);
  }

  /**
   * Reset the Display of Recent Conversations
   */
  public resetShowRecent(): void {
    this.primarySession?.session.setShowRecent(false);
    this.secondarySession?.session.setShowRecent(false);
    log.showInfo(`resetShowRecent: ${this.getName()}`);
  }

  /**
   * reset session rotate back to before transitionOut
   */
  public resetSessionRotation(): void {
    if (this.resetSessionRotationTimeout === CommonConstants.INVALID_VALUE) {
      return;
    }
    log.showWarn(`resetSessionRotation currentRotation:${this.currentRotation}-tempRotation:${this.tempRotation}`);
    clearTimeout(this.resetSessionRotationTimeout);
    this.currentRotation = this.tempRotation;
    this.resetSessionRotationTimeout = CommonConstants.INVALID_VALUE;
  }

  /**
   * Convert the icon position information based on the screen rotation angle.
   *
   * @param { RectInfo } iconRectInfo
   * @returns { RectInfo }
   */
  public covertWithRotation(iconRectInfo: RectInfo, isTransitionOut: boolean = false): RectInfo {
    let newRect = new RectInfo();
    let screenW = px2vp(this.screenProperty.width); // screenW which is after rotated
    let screenH = px2vp(this.screenProperty.height); // screenH which is after rotated
    newRect.left = iconRectInfo.left;
    newRect.top = iconRectInfo.top;
    newRect.right = iconRectInfo.right;
    newRect.bottom = iconRectInfo.bottom;
    let relativeRotation = this.currentRotation;
    if (StartAppConfig.isNeedIconRotate()) {
      if (SCBWindowRotateController.getInstance().isFullScreenRotatePolicy()) {
        if (!SCBWindowRotateController.getInstance().isLandscapeStartInterrupt()) {
          relativeRotation = RotationConstants.ROTATION_0;
        } else {
          // ensure target rotation > current rotation
          relativeRotation = (SCBWindowRotateController.getInstance().getLandscapeStartRotation() -
            SCBWindowRotateController.getInstance().getLandscapeStartDesktopRotation() +
            RotationConstants.ROTATION_360) % RotationConstants.ROTATION_360;
        }
      } else {
        relativeRotation = this.screenProperty.rotation;
      }
    }
    let screenRotation = SCBScreenSessionManager.getInstance().getScreenRotation();
    log.showWarn(`covertWithRotation screenRotation:${screenRotation} relativeRotation:${relativeRotation}`
      + ` currentRotation:${this.currentRotation} isTransitionOut:${isTransitionOut}`);
    if (isTransitionOut && screenRotation !== this.currentRotation) {
      relativeRotation = (screenRotation) % RotationConstants.ROTATION_360;
      this.tempRotation = this.currentRotation;
      this.currentRotation = relativeRotation;
      this.resetSessionRotationTimeout = setTimeout(() => {
        this.resetSessionRotation();
      }, this.sessionRotateBackTimeout);
    }
    switch (relativeRotation) {
      case RotationConstants.ROTATION_90: {
        newRect.left = screenW - iconRectInfo.bottom;
        newRect.top = iconRectInfo.left;
        newRect.right = screenW - iconRectInfo.top;
        newRect.bottom = iconRectInfo.right;
        break;
      }
      case RotationConstants.ROTATION_180: {
        newRect.left = screenW - iconRectInfo.right;
        newRect.top = screenH - iconRectInfo.bottom;
        newRect.right = screenW - iconRectInfo.left;
        newRect.bottom = screenH - iconRectInfo.top;
        break;
      }
      case RotationConstants.ROTATION_270: {
        newRect.left = iconRectInfo.top;
        newRect.top = screenH - iconRectInfo.right;
        newRect.right = iconRectInfo.bottom;
        newRect.bottom = screenH - iconRectInfo.left;
        break;
      }
      default:
        break;
    }
    return newRect;
  }

  //sceneSession rotation different from desktop rotation
  private isNeedRotateIcon(): boolean {
    if (SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()) {
      return false;
    }
    if (DeviceHelper.isPad()) {
      return this.screenProperty.rotation !== RotationConstants.ROTATION_0 &&
        this.screenProperty.rotation !== RotationConstants.ROTATION_180;
    }
    return this.screenProperty.rotation !== RotationConstants.ROTATION_0;
  }

  public onTransitionActiveToRectForSplit(iconRectInfo: RectInfo): void {
    if (!this.companionIconInfo?.iconId || !iconRectInfo) {
      this.startOtherForSplit();
      return;
    }

    const startType = this.companionIconInfo?.startAppType;
    if (startType === StartType.CARD) {
      this.startCardForSplit(iconRectInfo);
      return;
    }
    this.startAppForSplit(iconRectInfo);
  }

  /**
   * exit to small Folder
   */
  private exitToSmallFolder(rectInfo: RectInfo): void {
    let newRectInfo: RectInfo = this.covertWithRotation(rectInfo);
    let folderCenterX: number = (newRectInfo.left + newRectInfo.right) / HALF;
    let folderCenterY: number = (newRectInfo.top + newRectInfo.bottom) / HALF;
    if (folderCenterX <= 0 || folderCenterY <= 0) {
      log.showInfo('The width or height of folder is zero');
      this.startOther();
      return;
    }
    let centerX: number = px2vp(this.screenProperty.width / HALF);
    let centerY: number = px2vp(this.screenProperty.height / HALF);
    this.needRenderScale.setScaleXWithDfx(DEFAULT_SCALE, TAG, 'startSmallFolder', this.getName());
    this.needRenderScale.setScaleYWithDfx(DEFAULT_SCALE, TAG, 'startSmallFolder', this.getName());
    this.needRenderTranslate.setTranslateXWithDfx(folderCenterX - centerX, TAG, 'startSmallFolder', this.getName());
    this.needRenderTranslate.setTranslateYWithDfx(folderCenterY - centerY, TAG, 'startSmallFolder', this.getName());
    this.needRenderTranslateIcon.translateIconX = 0;
    this.needRenderTranslateIcon.translateIconY = 0;
    this.needRenderClip.setClipHeight(this.screenProperty.height);
    this.needRenderBorderRadius.setBorderRadiusWithDfx(DeviceHelper.getDeviceRadius(SCBScreenSessionManager.getInstance()
      .isFoldablePhoneExpandStatus()), TAG, 'startSmallFolder', this.getName());
  }

  public hasCustomStartAnimation() : boolean {
    if (this.primarySession) {
      let hasAnimation = this.primarySession.sessionData.
        transitionAnimationConfig.has(sceneSessionManager.WindowTransitionType.START);
      return hasAnimation;
    } else {
      log.showError(`[SCBAnimation] scb do not has primary session`);
      return false;
    }
  }

  /**
   * Transition animation Start Event
   *
   * @param { RectInfo } iconRectInfo
   */
  public onTransitionActiveToRect(iconRectInfo: RectInfo, isTransitionToSmallFolder: boolean = false,
    isTransitionOut: boolean = false): void {
    log.showDebug(`onTransitionActiveToRect iconRectInfo:${JSON.stringify(iconRectInfo)}`);
    this.sessionData.iconRectInfo = iconRectInfo;
    const startType = this.companionIconInfo?.startAppType;
    if (isTransitionToSmallFolder && iconRectInfo) {
      this.exitToSmallFolder(iconRectInfo);
      return;
    }
    if (this.companionIconInfo?.iconId && iconRectInfo) {
      if (startType === StartType.CARD) {
        this.startCard(iconRectInfo, isTransitionOut);
        return;
      }
      let isAdaptiveIcon = IconResourceManager.getInstance().isAdaptiveIcon(this.companionIconInfo);
      log.showWarn(`onTransitionActiveToRect, bundleName:${this.companionIconInfo?.bundleName}, ` +
        `isAdaptive:${isAdaptiveIcon}`);
      if (!isAdaptiveIcon) {
        this.startCard(iconRectInfo, isTransitionOut);
        return;
      }
      this.startApp(iconRectInfo, isTransitionOut);
      return;
    }
    this.startOther();
  }

  public onTransitionSwiper(offsetX: number, reason: string) : void {
    this.needRenderSwiperTranslate.setTranslateXWithDfx(offsetX, TAG, reason);
  }

  public saveSecondarySceneSize() : void {
    this.secondarySceneW = this.dividerParam.secondary.width;
    this.secondarySceneH = this.dividerParam.secondary.height;
  }

  private startCardForSplit(cardRectInfo: RectInfo): void {
    let newRectInfo: RectInfo = this.covertWithRotation(cardRectInfo);
    let cardWidth = Math.abs(newRectInfo.right - newRectInfo.left);
    let cardHeight = Math.abs(newRectInfo.bottom - newRectInfo.top);
    let windowWidth = px2vp(this.screenProperty.width);
    let windowHeight = px2vp(this.screenProperty.height);
    let secondaryTop = px2vp(parseFloat(this.dividerParam.secondary.posY) / 100 * this.screenProperty.height);
    if (cardWidth === 0 || windowWidth === 0) {
      log.showError('Division by Zero Error');
      this.startOtherForSplit();
    }
    log.showWarn('newCardRectInfo: {left:%{public}d, top:%{public}d, cardWidth:%{public}d, cardHeight:%{public}d}, ' +
      '{windowWidth:%{public}d, windowHeight:%{public}d}',
      newRectInfo.left, newRectInfo.top, cardWidth, cardHeight, windowWidth, windowHeight);
    let sceneScale: number = cardWidth / windowWidth;
    this.saveSecondarySceneSize();
    let secClipHeight: ScbNumber = new ScbNumber(vp2px(cardHeight * windowWidth / cardWidth));
    let translateX: number = newRectInfo.left + cardWidth / HALF - windowWidth / HALF;
    this.needRenderTranslateIcon.translateIconX = 0;
    if (!this.dividerParam.isUpDownSplit()) {
      sceneScale = cardWidth / (windowWidth / HALF);
      secClipHeight = new ScbNumber(vp2px(cardHeight * (windowWidth / HALF) / cardWidth));
      translateX = newRectInfo.left + cardWidth / HALF - windowWidth * 3 / 4;
      this.needRenderTranslateIcon.translateIconX = - windowWidth / 4;
    }
    this.dividerParam.secondary.height = secClipHeight.getPxSizeStr();
    this.dividerParam.setSecondaryTrans(translateX, newRectInfo.top + cardHeight / HALF - secClipHeight.getVp() / HALF -
      secondaryTop);
    this.dividerParam.setSecondaryScaleCenter('50%', '50%');
    this.dividerParam.setSecondaryScale(sceneScale, sceneScale);
    this.dividerParam.secondary.setBorderRadius({
      topLeft: this.companionIconInfo?.iconRadius / sceneScale,
      topRight: this.companionIconInfo?.iconRadius / sceneScale,
      bottomLeft: this.companionIconInfo?.iconRadius / sceneScale,
      bottomRight: this.companionIconInfo?.iconRadius / sceneScale
    }, 'startCardForSplit');

    this.sessionDataInner.cardBaseScale = windowHeight / cardHeight;
    this.cardScale = 1 / this.sessionDataInner.cardBaseScale / sceneScale;
    this.needRenderTranslateIcon.setTranslateIconYWithDfx(secClipHeight.getVp() / HALF - windowHeight / HALF, TAG,
      'startCardForSplit');
  }

  private startCard(cardRectInfo: RectInfo,isTransitionOut: boolean): void {
    let newRectInfo: RectInfo = this.covertWithRotation(cardRectInfo, isTransitionOut);
    let cardWidth = Math.abs(newRectInfo.right - newRectInfo.left);
    let cardHeight = Math.abs(newRectInfo.bottom - newRectInfo.top);
    let windowWidth = px2vp(this.screenProperty.width);
    let windowHeight = px2vp(this.screenProperty.height);
    if (cardHeight === 0 || cardWidth === 0) {
      log.showError('The width or height of card is zero');
      return;
    }
    let isRelativeVerticalScreen: boolean = windowHeight / cardHeight >= windowWidth / cardWidth;
    //是否是平板1*2或者2*4卡片(横屏状态)
    let isPad1m2Or2m4: boolean = false;
    if (DeviceHelper.isPad() && cardWidth / cardHeight >= 2) {
      if ((windowHeight / cardHeight) / (windowWidth / cardWidth) < 2) {
        isRelativeVerticalScreen = false;
        isPad1m2Or2m4 = true;
      }
    }
    log.showWarn(`newCardRectInfo: {left:${newRectInfo.left}, top:${newRectInfo.top}, right:${newRectInfo.right}, ` +
      `bottom:${newRectInfo.bottom}, windowWidth:${windowWidth}, windowHeight:${windowHeight}, ` +
      `isRelativeVerticalScreen:${isRelativeVerticalScreen}}`);
    let sceneScale: number = cardWidth / windowWidth;
    let bundleName = this.primarySession?.sceneInfo.bundleName;
    let isOobeBundleName = SCBTransitionManager.getInstance().isOobeBundleName(bundleName);
    let isPcAppExit = this.isPcAppExit();
    if (isPcAppExit || ((!isRelativeVerticalScreen || this.isNeedRotateIcon()) && !isPad1m2Or2m4)) {
      sceneScale = cardHeight / windowHeight;
      if (isPcAppExit) {
        // pc应用非G态退出保持G态退出
        this.sessionDataInner.cardBaseScale = windowHeight / cardHeight;
        this.cardScale = cardHeight / windowHeight / sceneScale;
      } else {
        this.sessionDataInner.cardBaseScale = windowWidth / cardWidth;
        this.cardScale = cardWidth / windowWidth / sceneScale;
      }
      this.needRenderClip.setClipWidth(vp2px(cardWidth * windowHeight / cardHeight));
      this.needRenderTranslate.setTranslateXWithDfx((newRectInfo.right + newRectInfo.left) / HALF - this.needRenderClip.clipWidth.getVp() / HALF, TAG, 'startCard', this.getName());
      this.needRenderTranslate.setTranslateYWithDfx(newRectInfo.top + cardHeight / HALF - windowHeight / HALF, TAG, 'startCard', this.getName());
      this.needRenderTranslateIcon.translateIconX =
        isOobeBundleName ? 0 : this.needRenderClip.clipWidth.getVp() / HALF - windowWidth / HALF;
      this.needRenderTranslateIcon.translateIconY = 0;

      this.needRenderTranslateIcon.translateOobeIconX =
        isOobeBundleName ? this.needRenderClip.clipWidth.getVp() / HALF - windowWidth / HALF : 0;
      this.needRenderTranslateIcon.translateOobeIconY = 0;
    } else {
      this.sessionDataInner.cardBaseScale = windowHeight / cardHeight;
      this.cardScale = cardHeight / windowHeight / sceneScale;
      if (isPad1m2Or2m4) {
        this.cardScale = 1.0;
      }
      this.needRenderClip.setClipHeight(vp2px(cardHeight * windowWidth / cardWidth));
      this.needRenderTranslate.setTranslateXWithDfx((newRectInfo.right + newRectInfo.left) / HALF - windowWidth / HALF, TAG, 'startCard', this.getName());
      this.needRenderTranslate.setTranslateYWithDfx(newRectInfo.top + cardHeight / HALF - this.needRenderClip.clipHeight.getVp() / HALF, TAG, 'startCard', this.getName());
      this.needRenderTranslateIcon.translateIconX = 0;
      const translateIconY: number = isOobeBundleName ? 0 : this.needRenderClip.clipHeight.getVp() / HALF - windowHeight / HALF;
      this.needRenderTranslateIcon.setTranslateIconYWithDfx(translateIconY, TAG, 'startCard');
      this.needRenderTranslateIcon.translateOobeIconX = 0;
      this.needRenderTranslateIcon.translateOobeIconY =
        isOobeBundleName ? this.needRenderClip.clipHeight.getVp() / HALF - windowHeight / HALF : 0;
    }
    this.needRenderScale.setScaleXWithDfx(sceneScale, TAG, 'startCard', this.getName());
    this.needRenderScale.setScaleYWithDfx(sceneScale, TAG, 'startCard', this.getName());

    this.needRenderBorderRadius.setBorderRadiusWithDfx(this.companionIconInfo?.iconRadius / sceneScale, TAG,
      'startCard', this.getName());
  }

  public isPcAppExit(): boolean {
    // 超大屏PC应用需要再G态折叠时退后台
    return this.primarySession?.isPcAppInPad && DeviceHelper.isUltraScreenProduct() &&
      SCBTriFoldManager.getInstance().getCurTriFoldState() !== SCBUltraScreenState.G &&
      SCBTriFoldManager.getInstance().getPrevTriFoldState() === SCBUltraScreenState.G;
  }

  public setByRectInfo(iconRectInfo: RectInfo, param: SceneParam): void {
    // 启动前参数设置为icon的rect，为了动效，反推translate等数据
    let newRectInfo = this.covertWithRotation(iconRectInfo);
    let iconSize = newRectInfo.right - newRectInfo.left;
    let shortPxSize: number;
    let shortWidth: number;
    let posX: number;
    let posY: number;
    if (this.dividerParam.isUpDownSplit()) {
      shortPxSize = Math.min(this.screenProperty.width, this.screenProperty.height / HALF);
      shortWidth = px2vp(shortPxSize);
      posX = newRectInfo.left + iconSize / HALF - shortWidth / HALF;
      posY = newRectInfo.top + iconSize / HALF - shortWidth / HALF;
    } else {
      shortPxSize = Math.min(this.screenProperty.width / HALF, this.screenProperty.height);
      shortWidth = px2vp(shortPxSize);
      posX = newRectInfo.left + iconSize / HALF - shortWidth / HALF;
      posY = newRectInfo.top + iconSize / HALF - shortWidth / HALF;
    }
    let secClipHeight: ScbNumber = new ScbNumber(shortPxSize);
    param.height = secClipHeight.getPxSizeStr();
    param.width = secClipHeight.getPxSizeStr();
    param.scaleCenterX = '50%';
    param.scaleCenterY = '50%';
    param.scaleX = iconSize / shortWidth;
    param.scaleY = iconSize / shortWidth;
    let radius = this.companionIconInfo?.iconRadius / (iconSize / shortWidth);
    param.setBorderRadius({
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius
    }, 'setByRectInfo');
    param.posX = `${posX / this.screenProperty.width * 100}%`;
    param.posY = `${posY / this.screenProperty.height * 100}%`;
  }

  private startAppForSplit(iconRectInfo: RectInfo): void {
    let shortPxSize = Math.min(this.screenProperty.width, this.screenProperty.height / HALF);
    let shortWidth = px2vp(shortPxSize);
    let secondaryTop = px2vp(parseFloat(this.dividerParam.secondary.posY) / 100 * this.screenProperty.height);
    let secondaryLeft = px2vp(parseFloat(this.dividerParam.secondary.posX) / 100 * this.screenProperty.width);
    let newRectInfo = this.covertWithRotation(iconRectInfo);
    let iconSize = newRectInfo.right - newRectInfo.left;
    let translateX = newRectInfo.left + iconSize / HALF - shortWidth / HALF;
    let translateY = newRectInfo.top + iconSize / HALF - shortWidth / HALF - secondaryTop;
    if (!this.dividerParam.isUpDownSplit()) {
      shortPxSize = Math.min(this.screenProperty.width / HALF, this.screenProperty.height);
      shortWidth = px2vp(shortPxSize);
      translateX = newRectInfo.left + iconSize / HALF - shortWidth / HALF - secondaryLeft;
      translateY = newRectInfo.top + iconSize / HALF - shortWidth / HALF;
    }
    if (shortPxSize === 0) {
      log.showError('Division by Zero Error');
      this.startOtherForSplit();
    }
    this.saveSecondarySceneSize();
    let secClipHeight: ScbNumber = new ScbNumber(shortPxSize);
    this.dividerParam.secondary.height = secClipHeight.getPxSizeStr();
    this.dividerParam.secondary.width = secClipHeight.getPxSizeStr();
    this.dividerParam.setSecondaryScaleCenter('50%', '50%');
    this.dividerParam.setSecondaryScale(iconSize / shortWidth, iconSize / shortWidth);
    let radius = this.companionIconInfo?.iconRadius / (iconSize / shortWidth);
    this.dividerParam.secondary.setBorderRadius({
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius
    }, 'startAppForSplit');
    this.dividerParam.setSecondaryTrans(translateX, translateY);
    log.showWarn(`newIconRectInfo:{left:${iconRectInfo.left}, top:${iconRectInfo.top}, iconSize:${iconSize}}`);
  }

  private startApp(iconRectInfo: RectInfo, isTransitionOut: boolean): void {
    let shortPxSize = Math.min(this.screenProperty.width, this.screenProperty.height);
    let shortWidth = px2vp(shortPxSize);
    this.needRenderClip.setClipHeight(shortPxSize);
    let width = this.needRenderClip.clipHeight.copy();
    this.needRenderClip.setClipWidth(width);
    let newRectInfo = this.covertWithRotation(iconRectInfo, isTransitionOut);
    let iconSize = iconRectInfo.right - iconRectInfo.left;
    this.needRenderScale.setScaleXWithDfx(iconSize / shortWidth, TAG, 'startApp', this.getName());
    this.needRenderScale.setScaleYWithDfx(iconSize / shortWidth, TAG, 'startApp', this.getName());
    let radius = (iconRectInfo.radius ?? this.companionIconInfo?.iconRadius) / (iconSize / shortWidth);
    this.needRenderBorderRadius.setBorderRadiusWithDfx(radius, TAG, 'startApp', this.getName());
    this.needRenderTranslate.setTranslateXWithDfx(newRectInfo.left + (iconSize - shortWidth) / HALF, TAG, 'startApp', this.getName());
    // 2: width divider
    this.needRenderTranslate.setTranslateYWithDfx(newRectInfo.top + (iconSize - shortWidth) / HALF, TAG, 'startApp', this.getName());
    if (IntelligentCache.isIntelligentMyPage(this.companionIconInfo?.iconId)) {
      this.intelligentScene = 0;
    }
    log.showWarn('newIconRectInfo: %{public}s preIconRectInfo: %{public}s rotation: %{public}d scale: %{public}d ' +
      'translateX: %{public}d translateY: %{public}d radius: %{public}d clipHeight: %{public}d',
      JSON.stringify(newRectInfo), JSON.stringify(iconRectInfo), this.currentRotation, this.needRenderScale.scaleX,
      this.needRenderTranslate.translateX, this.needRenderTranslate.translateY, radius,
      this.needRenderClip.clipWidth.getPx());
  }

  public startOtherForSplit(): void {
    this.saveSecondarySceneSize();
    let secClipHeight = new ScbNumber(this.screenProperty.height / HALF);
    let secondaryTop = px2vp(parseFloat(this.dividerParam.secondary.posY) / 100 * this.screenProperty.height);
    let secondaryLeft = px2vp(parseFloat(this.dividerParam.secondary.posX) / 100 * this.screenProperty.width);
    let translateX: number = 0;
    let translateY: number = - secondaryTop / HALF;
    if (!this.dividerParam.isUpDownSplit()) {
      secClipHeight = new ScbNumber(this.screenProperty.height);
      translateX = - secondaryLeft / HALF;
      translateY = 0;
    }
    this.dividerParam.setSecondaryScaleCenter('50%', '50%');
    this.dividerParam.setSecondaryScale(0.035, 0.035);
    this.dividerParam.secondary.height = secClipHeight.getPxSizeStr();
    this.dividerParam.setSecondaryTrans(translateX, translateY - px2vp(this.screenProperty.height * WINDOW_SCALE));
    let radius = DeviceHelper.getDeviceRadius(SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus());
    this.dividerParam.secondary.setBorderRadius({
      topLeft: radius,
      topRight: radius,
      bottomLeft: radius,
      bottomRight: radius
    }, 'startOtherForSplit');
    this.needRenderTranslateIcon.translateIconX = 0;
    this.needRenderTranslateIcon.translateIconY = 0;
  }

  public startOtherForQuickAccessMenu(quickAccessMenuHeight: number, quickAccessMenuWidth: number,
    quickAccessMenuTopOffset: number, isXKey: boolean = false): void {
    this.needRenderTranslateIcon.translateIconX = 0;
    this.needRenderTranslateIcon.translateIconY = 0;
    let borderRadius: number = DeviceHelper.getDeviceRadius(SCBScreenSessionManager.getInstance()
      .isFoldablePhoneExpandStatus());
    if (isXKey) {
      borderRadius = vp2px(quickAccessMenuWidth / 2);
    }
    this.needRenderBorderRadius.setBorderRadiusWithDfx(borderRadius, TAG, 'startOtherForQuickAccessMenu',
      this.getName());
    let sourceHeight = quickAccessMenuHeight;

    if (!this.isVertical(this.screenProperty.rotation) && !isXKey) {
      quickAccessMenuWidth = quickAccessMenuHeight;
      quickAccessMenuHeight = SCBConstants.DEFAULT_QUICK_ACCESS_MENU_WIDTH;
    }

    let currentRotation = this.currentRotation;

    this.needRenderClip.setClipWidth(vp2px(quickAccessMenuWidth));
    this.needRenderClip.setClipHeight(vp2px(quickAccessMenuHeight));

    log.showInfo(`currentRotation is ${currentRotation}`)
    if (isXKey) {
      this.setTranslateForXKey(currentRotation, quickAccessMenuHeight, quickAccessMenuWidth, quickAccessMenuTopOffset);
      return;
    }
    this.setTranslateForSmartKey(currentRotation, quickAccessMenuHeight, quickAccessMenuWidth,
      quickAccessMenuTopOffset);
  }

  private setTranslateForXKey(currentRotation: number, quickAccessMenuHeight: number, quickAccessMenuWidth: number,
    quickAccessMenuTopOffset: number): void {
    let translateX: number = 0;
    let translateY: number = 0;
    switch (currentRotation) {
      case RotationConstants.ROTATION_90: {
        translateX = px2vp(this.screenProperty.width) - quickAccessMenuTopOffset - quickAccessMenuHeight / 2;
        translateY = SCBConstants.QUICK_ACCESS_MENU_LEFT_OFFSET;
        break;
      }
      case RotationConstants.ROTATION_180: {
        translateX =
          px2vp(this.screenProperty.width) - SCBConstants.QUICK_ACCESS_MENU_LEFT_OFFSET - quickAccessMenuWidth;
        translateY = px2vp(this.screenProperty.height) - quickAccessMenuTopOffset - quickAccessMenuHeight / 2;
        break;
      }
      case RotationConstants.ROTATION_270: {
        translateX = quickAccessMenuTopOffset - quickAccessMenuHeight / 2;
        translateY =
          px2vp(this.screenProperty.height) - SCBConstants.QUICK_ACCESS_MENU_LEFT_OFFSET - quickAccessMenuWidth;
        break;
      }
      default: {
        translateX = SCBConstants.QUICK_ACCESS_MENU_LEFT_OFFSET;
        translateY = quickAccessMenuTopOffset - quickAccessMenuHeight / 2;
        break;
      }
    }
    this.needRenderTranslate.setTranslateXWithDfx(translateX, TAG, 'startOtherForQuickAccessMenuXKey', this.getName());
    this.needRenderTranslate.setTranslateYWithDfx(translateY, TAG, 'startOtherForQuickAccessMenuXKey', this.getName());
  }

  private setTranslateForSmartKey(currentRotation: number, quickAccessMenuHeight: number, quickAccessMenuWidth: number,
    quickAccessMenuTopOffset: number): void {
    let translateX: number = 0;
    let translateY: number = 0;
    switch (currentRotation) {
      case RotationConstants.ROTATION_90: {
        translateX = px2vp(this.screenProperty.width) - quickAccessMenuTopOffset - quickAccessMenuWidth / 2;
        translateY =
          px2vp(this.screenProperty.height) - SCBConstants.QUICK_ACCESS_MENU_RIGHT_OFFSET - quickAccessMenuHeight;
        break;
      }
      case RotationConstants.ROTATION_180: {
        translateX = SCBConstants.QUICK_ACCESS_MENU_RIGHT_OFFSET;
        translateY = px2vp(this.screenProperty.height) - quickAccessMenuTopOffset - quickAccessMenuHeight / 2;
        break;
      }
      case RotationConstants.ROTATION_270: {
        translateX = quickAccessMenuTopOffset - quickAccessMenuWidth / 2;
        translateY = SCBConstants.QUICK_ACCESS_MENU_RIGHT_OFFSET;
        break;
      }
      default: {
        translateX =
          px2vp(this.screenProperty.width) - SCBConstants.QUICK_ACCESS_MENU_RIGHT_OFFSET - quickAccessMenuWidth / 2;
        translateY = quickAccessMenuTopOffset - quickAccessMenuHeight / 2;
        break;
      }
    }
    this.needRenderTranslate.setTranslateXWithDfx(translateX, TAG, 'startOtherForQuickAccessMenu', this.getName());
    this.needRenderTranslate.setTranslateYWithDfx(translateY, TAG, 'startOtherForQuickAccessMenu', this.getName());
  }

  public startCustom(): void {
    // only has opacity animation now
    this.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'startCustom', this.getName());
    this.needRenderScale.setScaleXWithDfx(1, TAG, 'startCustom', this.getName());
    this.needRenderScale.setScaleYWithDfx(1, TAG, 'startCustom', this.getName());
  }

  public endCustom(): void {
    this.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'endCustom', this.getName());
  }
  /**
   * Start other
   */
  public startOther(): void {
    this.needRenderScale.setScaleXWithDfx(DEFAULT_SCALE, TAG, 'startOther', this.getName());
    this.needRenderScale.setScaleYWithDfx(DEFAULT_SCALE, TAG, 'startOther', this.getName());
    this.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'startOther', this.getName());
    this.needRenderTranslate.setTranslateYWithDfx(-px2vp(this.screenProperty.height * WINDOW_SCALE), TAG, 'startOther', this.getName());
    this.needRenderTranslateIcon.translateIconX = 0;
    this.needRenderTranslateIcon.translateIconY = 0;
    this.needRenderClip.setClipHeight(this.screenProperty.height);
    this.needRenderBorderRadius.setBorderRadiusWithDfx(DeviceHelper.getDeviceRadius(SCBScreenSessionManager.getInstance()
      .isFoldablePhoneExpandStatus()), TAG, 'startOther', this.getName());
  }

  public onTransitionInactiveForSplit(): void {
    this.dividerParam.setSecondaryScale(1.0, 1.0);
    this.dividerParam.secondary.width = this.secondarySceneW;
    this.dividerParam.secondary.height = this.secondarySceneH;
    this.dividerParam.setBorderRadius();
    this.dividerParam.setSecondaryTrans(0, 0);
    this.cardScale = 1.0;
    this.needRenderTranslateIcon.translateIconX = 0;
    this.needRenderTranslateIcon.translateIconY = 0;
  }

  /**
   * What to do when a component becomes inactive
   */
  public onTransitionInactive(): void {
    this.needRenderScale.setScaleXWithDfx(1.0, TAG, 'onTransitionInactive', this.getName());
    this.needRenderScale.setScaleYWithDfx(1.0, TAG, 'onTransitionInactive', this.getName());
    this.cardScale = 1.0;
    this.needRenderClip.setClipHeight(this.screenProperty.height);
    this.needRenderClip.setClipWidth(this.screenProperty.width);
    this.needRenderBorderRadius.setBorderRadiusWithDfx(DeviceHelper.getDeviceRadius(SCBScreenSessionManager.getInstance()
      .isFoldablePhoneExpandStatus()), TAG, 'onTransitionInactive', this.getName());
    this.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'onTransitionInactive', this.getName());
    this.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'onTransitionInactive', this.getName());
    this.needRenderTranslateIcon.translateIconX = 0;
    this.needRenderTranslateIcon.translateIconY = 0;
    if (IntelligentCache.isIntelligentMyPage(this.companionIconInfo?.iconId)) {
      this.intelligentScene = 1.0;
    }
  }

  /**
   * 重置退出的变量
   * @param deviceRadius 设备半径
   * @param reason
   */
  public resetTransitionOutData(deviceRadius: number, reason: string): void {
    this.cardScale = 1.0;
    this.iconAlpha = 0;
    this.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, reason, this.getName());
    this.needRenderBorderRadius.setBorderRadiusWithDfx(deviceRadius, TAG, reason, this.getName());
  }

  /**
   * Get persistentId
   */
  public getPersistentId(): number {
    return this.primarySession ?
      this.primarySession.session?.persistentId : this.secondarySession?.session?.persistentId;
  }

  /**
   * Gets the number of transition animations
   *
   * @returns { number }
   */
  public getTransitionCount(): number {
    log.showWarn(`getTransitionCount from session ${this.containerId}, ${this.sessionData.transitionAnimationCount}`);
    return SCBTransitionManager.getInstance().getTransitionCount(this.containerId.toString());
  }

  /**
   * Increase transition count
   *
   * @param isNeedCountToMap 是否需要计数到Map缓存
   */
  public addTransitionCount(isNeedCountToMap: boolean = false): void {
    log.showWarn(`Add count ${this.containerId}, ${this.sessionData.transitionAnimationCount}`);
    this.sessionData.transitionAnimationCount++;
    SCBTransitionManager.getInstance().addTransitionCount(this.containerId.toString());
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(0);
  }

  /**
   * @param persistentId
   * @returns SCBSceneSession with given persistentId
   */
  public findSceneSessionByPersistentId(persistentId: number): SCBSceneSession | null {
    if (this.primarySession?.sceneInfo.persistentId === persistentId) {
      return this.primarySession;
    }
    return this.secondarySession?.sceneInfo.persistentId === persistentId ? this.secondarySession : null;
  }

  /**
   * @param sceneInfo
   * @returns SCBSceneSession with given sceneInfo
   */
  public findSceneSessionBySceneInfo(sceneInfo: SCBSceneInfo): SCBSceneSession | null {
    if (this.primarySession?.sceneInfo?.equalTo(sceneInfo)) {
      return this.primarySession;
    }
    return this.secondarySession?.sceneInfo?.equalTo(sceneInfo) ? this.secondarySession : null;
  }

  public recordScreenPropertyBeforeFold(scbScreenProperty: SCBScreenProperty) {
    log.showInfo('recordScreenPropertyBeforeFold scbScreenProperty.rotation = ' + scbScreenProperty.rotation);
    this.screenPropertyByFold = scbScreenProperty;
  }

  public setOrientationInFold(orientationInFold: SCBSceneOrientation) {
    log.showInfo('setOrientationInFold orientationInFold = ' + orientationInFold);
    this.orientationInFold = orientationInFold;
  }

  public getScreenPropertyInFold(): SCBScreenProperty {
    return this.screenPropertyByFold;
  }

  public getOrientationInFold(): SCBSceneOrientation {
    return this.orientationInFold;
  }

  public getTargetRotationWithScreenLocked(sensorScreenProperty: SCBScreenProperty): number {
    let foldPersistentId = SCBSceneSessionManager.getInstance().getScreenLockWithFoldPersistentId();
    log.showInfo(`getTargetRotationWithScreenLocked start foldPersistentId: ${foldPersistentId},`+
      ` this.primarySession.requestOrientation: ${this.primarySession.requestOrientation}`);
    let tempRotation = this.screenPropertyByFold?.rotation ?? RotationConstants.ROTATION_INVALIDED;
    if (this.isNeedRecoverRotation(foldPersistentId, tempRotation)) {
      log.showInfo(`getTargetRotationWithSingleFoldDevice recover rotation: ${this.screenPropertyByFold.rotation}`);
      let tempRotation = this.screenPropertyByFold.rotation;
      this.screenPropertyByFold = null;
      this.orientationInFold = null;
      return tempRotation;
    }
    return this.getDefaultTargetRotation(sensorScreenProperty);
  }

  private isNeedRecoverRotation(foldPersistentId: number, tempRotation: number): boolean {
    let isPreviewPersistentId = this.getPersistentId() === foldPersistentId;
    let isPreviewOrientation = this.primarySession.requestOrientation === this.orientationInFold;
    return this.screenPropertyByFold && isPreviewPersistentId && isPreviewOrientation &&
      this.isTargetRotationValid(tempRotation);
  }

  public isTargetRotationValid(targetRotation: number): boolean{
    log.showInfo(`isTargetRotationValid: ${this.primarySession?.sceneInfo.bundleName},` +
      ` requestOrientation: ${this.requestOrientation}, targetRotation: ${targetRotation},` +
      ` orientationInFold: ${this.orientationInFold}}`);
    if (targetRotation === RotationConstants.ROTATION_INVALIDED) {
      log.showInfo(`isTargetRotationValid targetRotation is invalid`);
      return false;
    }
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (this.isFixedRotation(screenSession)) {
      return false;
    }
    // check targetRotation by orientation cached when fold phone
    if (this.checkTargetRotationByOriginOrientation(targetRotation)) {
      log.showInfo(`isTargetRotationValid checkTargetRotationByOriginOrientation return true`);
      return true;
    }
    // check targetRotation by rotation policy
    return this.checkTargetRotationByRotationPolicy(targetRotation);
  }

  private isFixedRotation(screenSession: SCBScreenSession): boolean {
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      if (SCBRotationConfig.getInstance().getDeviceFixedRotation(screenSession) !== -1) {
        log.showInfo(`isTargetRotationValid use rotateScreenPolicy return false`);
        return true;
      }
    }
    return false;
  }

  private checkTargetRotationByOriginOrientation(targetRotation: number): boolean {
    return SCBSceneOrientationUtils.isAllowPortrait(targetRotation, this.orientationInFold) ||
      SCBSceneOrientationUtils.isAllowLandscape(targetRotation, this.orientationInFold) ||
      SCBSceneOrientationUtils.isAllowLandscapeInverted(targetRotation, this.orientationInFold) ||
      SCBSceneOrientationUtils.isAllowPortraitInverted(targetRotation, this.orientationInFold);
  }

  private checkTargetRotationByRotationPolicy(targetRotation: number): boolean {
    let rotationPolicyMap: Map<number, boolean> = this.getRotationPolicyMap();
    let rotationPolicy: boolean = rotationPolicyMap?.get(targetRotation) ?? false;
    log.showInfo(`checkTargetRotationByRotationPolicy return rotationPolicy: ${rotationPolicy}`);
    return rotationPolicy;
  }

  private getRotationPolicyMap(): Map<number, boolean> {
    if (this.requestOrientation === SCBSceneOrientation.UNSPECIFIED) {
      return SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap();
    } else if (this.requestOrientation === SCBSceneOrientation.FOLLOW_DESKTOP) {
      return SCBFollowDesktopOrientationPolicy.getInstance().getRotationPolicyMap();
    } else if (this.isRelatedToRotationPolicy()) {
      return SCBDeviceScreenConfig.getInstance().getRotationPolicyMap();
    }
    log.showInfo(`getRotationPolicyMap fail, return null`);
    return null;
  }

  private getDefaultTargetRotation(sensorScreenProperty: SCBScreenProperty): number {
    let targetRotation = RotationConstants.ROTATION_INVALIDED;
    if (this.isDefaultVerticalRotationOrientation(this.requestOrientation)) {
      targetRotation = this.getVerticalRotation();
    } else if (this.isDefaultHorizontalRotationOrientation(this.requestOrientation)) {
      targetRotation = this.getHorizontalRotation();
    } else if (this.isDefaultReverseHorizontalRotationOrientation(this.requestOrientation)) {
      targetRotation = this.getReverseHorizontalRotation();
    } else if (this.isDefaultReverseVerticalRotationOrientation(this.requestOrientation)) {
      targetRotation = this.getReverseVerticalRotation();
    } else if (this.requestOrientation === SCBSceneOrientation.SENSOR) {
      targetRotation = sensorScreenProperty.rotation;
    } else if (this.requestOrientation === SCBSceneOrientation.SENSOR_VERTICAL) {
      targetRotation = this.getSensorVerticalRotation(RotationConstants.ROTATION_0, sensorScreenProperty.rotation);
    } else if (this.requestOrientation === SCBSceneOrientation.SENSOR_HORIZONTAL) {
      targetRotation = this.getSensorHorizontalRotation(RotationConstants.ROTATION_270, sensorScreenProperty.rotation);
    } else {
      log.showInfo(`getTargetRotationWithScreenLocked error, illegal requestOrientation: ${this.requestOrientation}`);
    }
    // reset screenPropertyByFold and orientationInFold
    this.screenPropertyByFold = null;
    this.orientationInFold = null;
    return targetRotation;
  }

  private isDefaultVerticalRotationOrientation(orientation: SCBSceneOrientation): boolean {
    if (orientation === SCBSceneOrientation.UNSPECIFIED || orientation === SCBSceneOrientation.VERTICAL ||
      orientation === SCBSceneOrientation.AUTO_ROTATION_RESTRICTED || orientation === SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED ||
      orientation === SCBSceneOrientation.LOCKED || orientation === SCBSceneOrientation.AUTO_ROTATION_UNSPECIFIED ||
      orientation === SCBSceneOrientation.USER_ROTATION_PORTRAIT || orientation === SCBSceneOrientation.FOLLOW_DESKTOP ||
      orientation === SCBSceneOrientation.FOLLOW_RECENT) {
      return true;
    }
    return false;
  }

  private isDefaultHorizontalRotationOrientation(orientation: SCBSceneOrientation): boolean {
    if (orientation === SCBSceneOrientation.HORIZONTAL || orientation === SCBSceneOrientation.USER_ROTATION_LANDSCAPE ||
      orientation === SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED) {
      return true;
    }
    return false;
  }

  private isDefaultReverseHorizontalRotationOrientation(orientation: SCBSceneOrientation): boolean {
    if (orientation === SCBSceneOrientation.REVERSE_HORIZONTAL || orientation === SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED) {
      return true;
    }
    return false;
  }

  private isDefaultReverseVerticalRotationOrientation(orientation: SCBSceneOrientation): boolean {
    if (orientation === SCBSceneOrientation.REVERSE_VERTICAL || orientation === SCBSceneOrientation.USER_ROTATION_PORTRAIT_INVERTED) {
      return true;
    }
    return false;
  }

  /**
   * Clear Transition Count
   */
  public clearTransitionCount(isHomeSwiper: boolean = false): void {
    // 桌面上滑的时候，此时有窗口动效的话，不可以clear
    if (isHomeSwiper && SCBTransitionManager.getInstance().getTransitionCount(this.containerId.toString()) > 0) {
      return;
    }
    log.showWarn(`clearTransitionCount ${this.containerId}, ${this.sessionData.transitionAnimationCount}`);
    this.sessionData.transitionAnimationCount = 0;
    SCBTransitionManager.getInstance().clearTransitionCount(this.containerId.toString());
    AnimateToScheduleUtils.raiseAnimateToCPUPriority(1);
  }

  /**
   * Determine if the device is in a vertical orientation
   *
   * @param { Number } rotation
   * @return { Boolean }
   */
  public isVertical(rotation: number): boolean {
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
      if (screenSession) {
        let verticalRotation: number = SCBRotationConfig.getInstance().getVerticalRotation(screenSession);
        let reverseVerticalRotation: number = SCBRotationConfig.getInstance().getReverseVerticalRotation(screenSession);
        rotation = rotation % RotationConstants.ROTATION_360;
        log.showInfo(`containerSession isVertical verticalRotation: ${verticalRotation}` +
          `, reverseVerticalRotation: ${reverseVerticalRotation}, rotation: ${rotation}`);
        return rotation === verticalRotation || rotation === reverseVerticalRotation;
      }
    }
    if (this.screenProperty.defaultScreenOrientation === 0) {
      if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
        return (rotation % RotationConstants.ROTATION_360 === RotationConstants.ROTATION_90 ||
          rotation % RotationConstants.ROTATION_360 === RotationConstants.ROTATION_270);
      }
      return (rotation % RotationConstants.ROTATION_360 === RotationConstants.ROTATION_0 ||
        rotation % RotationConstants.ROTATION_360 === RotationConstants.ROTATION_180);
    } else {
      return (rotation % RotationConstants.ROTATION_360 === RotationConstants.ROTATION_90 ||
        rotation % RotationConstants.ROTATION_360 === RotationConstants.ROTATION_270);
    }
  }

  /**
   * Update Container Session
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBContainerRotationReason } reason
   */
  public updateContainerSessionWithRotation(screenProperty: SCBScreenProperty,
    reason: SCBContainerRotationReason, isPageRotation: boolean = false): void {
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateContainerSessionWithRotation] Update containerSession: ' +
      this.containerId + ' name: ' + this.primarySession?.sceneInfo.bundleName + ' clipWidth: ' +
      this.needRenderClip.clipWidth.getPx() + ' clipHeight: ' + this.needRenderClip.clipHeight.getPx() +
      'currentRotation: ' + this.currentRotation);
    // cannot change property when background, or may not correct in recent
    if (reason === SCBContainerRotationReason.EXIT_SCENE &&
      !ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD_BOUNCER)) {
      return;
    }
    if (this.isFloat || this.isFloatView) {
      this.notifySceneContainerRotationChange(this.currentRotation, screenProperty, reason);
      return;
    }
    let sizeReason: sceneSessionManager.SessionSizeChangeReason = sceneSessionManager.SessionSizeChangeReason.UNDEFINED;
    if (reason === SCBContainerRotationReason.SCREEN_ROTATION || reason === SCBContainerRotationReason.PANEL_ROTATION ||
      reason === SCBContainerRotationReason.LANDSCAPE_ONE_STEP_SCENE) {
      sizeReason = sceneSessionManager.SessionSizeChangeReason.ROTATION;
    }
    if (isPageRotation) {
      sizeReason = sceneSessionManager.SessionSizeChangeReason.PAGE_ROTATION;
    }
    if (this.isVertical(this.currentRotation) !== this.isVertical(screenProperty.rotation)) {
      let width = this.needRenderClip.clipHeight.copy();
      let height = this.needRenderClip.clipWidth.copy();
      this.needRenderClip.setClipWidth(width);
      this.needRenderClip.setClipHeight(height);
      this.updateContainerSessionWithRotationInner(screenProperty, sizeReason);
    } else if (isPageRotation) {
      this.updateContainerSessionWithRotationInner(screenProperty, sizeReason);
    } else if (this.isSplit) {
      this.rotateSplit(screenProperty, reason, sizeReason);
    } else {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateContainerSessionWithRotation] no need rotate to: ' + this.screenProperty.rotation);
    }
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateContainerSessionWithRotation] Update containerSession: ' + this.containerId +
      ' name: ' + this.primarySession?.sceneInfo.bundleName + ' clipWidth: ' +
      this.needRenderClip.clipWidth.getPx() + ' clipHeight: ' + this.needRenderClip.clipHeight.getPx() +
      ' screenProperty: ' + JSON.stringify(screenProperty));
    this.notifySceneContainerRotationChange(this.currentRotation, screenProperty, reason);
    this.screenProperty.copy(screenProperty);
    this.currentRotation = this.screenProperty.rotation;
    this.width = new ScbNumber(this.screenProperty.width);
    this.height = new ScbNumber(this.screenProperty.height);
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateContainerSessionWithRotation] Update containerSession: ' + this.containerId + 
                 'currentProperty: ' + JSON.stringify(this.screenProperty));
  }

  private rotateSplit(screenProperty: SCBScreenProperty, reason: SCBContainerRotationReason,
    sizeReason: sceneSessionManager.SessionSizeChangeReason): void {
    this.rotateSplitInFoldIfNeeded(screenProperty);
    if (reason === SCBContainerRotationReason.LANDSCAPE_ONE_STEP_SCENE) {
      transactionManager.openSyncTransaction(screenProperty.screenId);
      this.updateSessionRectForSplit(screenProperty, true, sizeReason);
      transactionManager.closeSyncTransaction(screenProperty.screenId);
    } else {
      this.updateSessionRectForSplit(screenProperty, true, sizeReason);
    }
  }

  private updateContainerSessionWithRotationInner(screenProperty: SCBScreenProperty,
                                                  sizeReason: sceneSessionManager.SessionSizeChangeReason): void {
    const primaryRect: SCBSessionRect | null = this.primarySession?.currRect.copy();
    const secondaryRect: SCBSessionRect | null = this.secondarySession?.currRect.copy();
    if (this.isSplit) {
      this.rotateSplitInFoldIfNeeded(screenProperty);
      this.updateSessionRectForSplit(screenProperty, true, sizeReason);
    } else {
      this.updateSessionRectWithRotation(screenProperty, sizeReason);
    }
    this.primarySession?.calcSessionRectAfterRotation(screenProperty);
    this.secondarySession?.calcSessionRectAfterRotation(screenProperty);
  }

  private updateSessionRect(session: SCBSceneSession | null, screenProperty: SCBScreenProperty,
    sizeReason: sceneSessionManager.SessionSizeChangeReason): void {
	if (session == null) {
		return;
	}
	let sessionRect: SCBSessionRect = session.currRect;
    if (this.isVertical(this.currentRotation) !== this.isVertical(screenProperty.rotation)) {
      WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[updateSessionRectWithRotation] the session rects need to be changed');
      let tmpValue: ScbNumber = sessionRect.width;
      sessionRect.width = sessionRect.height;
      sessionRect.height = tmpValue;
	}
    session.updateRect(sessionRect.left, sessionRect.top,
      sessionRect.width, sessionRect.height, sizeReason);
  }

  private updateSessionRectWithRotation(screenProperty: SCBScreenProperty,
    sizeReason: sceneSessionManager.SessionSizeChangeReason): void {
	this.updateSessionRect(this.primarySession, screenProperty, sizeReason);
	this.updateSessionRect(this.secondarySession, screenProperty, sizeReason);
  }

  /**
   * registerIsSaveSnapshotForMidSceneCallback
   * @param callback
   */
  public registerIsSaveSnapshotForMidSceneCallback(callback: (container: SCBSceneContainerSession,
    persistentId: number) => boolean): void {
    this.isSaveSnapshotForMidSceneCallback = callback;
  }

  /**
   * unRegisterIsSaveSnapshotForMidSceneCallback
   */
  public unRegisterIsSaveSnapshotForMidSceneCallback(): void {
    this.isSaveSnapshotForMidSceneCallback = undefined;
  }

  private isSaveSnapshotForMidScene(container: SCBSceneContainerSession, persistentId: number): boolean {
    if (this.isSaveSnapshotForMidSceneCallback) {
      return this.isSaveSnapshotForMidSceneCallback(container, persistentId);
    }
    return false;
  }

  public registerSubSessionStateChangeCallback(screenId: number, callback: Function): void {
    if (callback && screenId !== null && screenId !== undefined) {
      this.subSessionStateChangeCallbacks.set(screenId, callback);
    }
  }

  public unRegisterSubSessionStateChangeCallback(screenId: number): void {
    if (screenId !== null && screenId !== undefined && this.subSessionStateChangeCallbacks.has(screenId)) {
      this.subSessionStateChangeCallbacks.delete(screenId);
    }
  }

  public registerUpdateSubWindowBindingCallback(screenId: number, callback: Function): void {
    if (callback && screenId !== null && screenId !== undefined) {
      this.updateSubWindowBindingCallbacks.set(screenId, callback);
    }
  }

  public unRegisterUpdateSubWindowBindingCallback(screenId: number): void {
    if (screenId !== null && screenId !== undefined && this.updateSubWindowBindingCallbacks.has(screenId)) {
      this.updateSubWindowBindingCallbacks.delete(screenId);
    }
  }

  public updateSubWindowBinding(screenId: number): void {
    const callback = this.updateSubWindowBindingCallbacks.get(screenId);
    if (callback) {
      callback();
    }
  }

  /**
   * Updating a Container Session with Active Mode
   *
   * @param { SCBScreenProperty } oldScreenProperty
   * @param { SCBScreenProperty } newScreenProperty
   */
  public updateContainerSessionWithActiveMode(oldScreenProperty : SCBScreenProperty, newScreenProperty: SCBScreenProperty): void {
    log.showInfo('before updateContainerSessionWithActiveMode Update containerSession: ' +
      this.containerId + ' name: ' + this.primarySession?.sceneInfo.bundleName + ' clipWidth: ' +
      this.needRenderClip.clipWidth.getPx() + ' clipHeight: ' + this.needRenderClip.clipHeight.getPx());
    this.needRenderClip.setClipWidth(this.needRenderClip.clipWidth.getPx() * newScreenProperty.width / oldScreenProperty.width);
    this.needRenderClip.setClipHeight(this.needRenderClip.clipHeight.getPx() * newScreenProperty.height / oldScreenProperty.height);

    // calculate scene rect(float mode)
    if (this.primarySession) {
      let left = this.primarySession.currRect.left.getPx() * newScreenProperty.width / oldScreenProperty.width;
      let top = this.primarySession.currRect.top.getPx() * newScreenProperty.height / oldScreenProperty.height;
      let width = this.primarySession.currRect.width.getPx() * newScreenProperty.width / oldScreenProperty.width;
      let height = this.primarySession.currRect.height.getPx() * newScreenProperty.height / oldScreenProperty.height;
      this.primarySession.currRect.setRectNum(left, top, width, height);
      this.primarySession.calcSessionRectAfterActiveModeChange(oldScreenProperty, newScreenProperty);
    }
    if (this.secondarySession) {
      let left = this.secondarySession.currRect.left.getPx() * newScreenProperty.width / oldScreenProperty.width;
      let top = this.secondarySession.currRect.top.getPx() * newScreenProperty.height / oldScreenProperty.height;
      let width = this.secondarySession.currRect.width.getPx() * newScreenProperty.width / oldScreenProperty.width;
      let height = this.secondarySession.currRect.height.getPx() * newScreenProperty.height / oldScreenProperty.height;
      this.secondarySession.currRect.setRectNum(left, top, width, height);
      this.secondarySession.calcSessionRectAfterActiveModeChange(oldScreenProperty, newScreenProperty);
    }
    log.showInfo('updateContainerSessionWithActiveMode: ' + this.containerId +
      ' name: ' + this.primarySession?.sceneInfo.bundleName + ' clipWidth: ' +
      this.needRenderClip.clipWidth.getPx() + ' clipHeight: ' + this.needRenderClip.clipHeight.getPx() +
      ' screenProperty: ' + JSON.stringify(newScreenProperty));
    this.notifySceneContainerActiveModeChange(oldScreenProperty, newScreenProperty);
    this.screenProperty.copy(newScreenProperty);
    this.width = new ScbNumber(this.screenProperty.width);
    this.height = new ScbNumber(this.screenProperty.height);
    log.showInfo('updateContainerSessionWithActiveMode: ' + this.containerId + 'currentProperty: ' +
      JSON.stringify(this.screenProperty));
  }

  /**
   * Update recent info (clipWidth, clipHeight, currentRotation) and container session with fold
   * @param { SCBScreenProperty } targetScreenProperty
   * @param { SCBPropertyChangeReason } reason
   * @param { number } targetRotation
   */
  public updateRecentAndContainerInfoWithFold(targetScreenProperty : SCBScreenProperty,
                                              reason: SCBPropertyChangeReason,
                                              targetRotation: number): void {
    this.updateRecentInfoWithFold(targetScreenProperty, reason, targetRotation);
    this.updateContainerSessionInfoWithFold(targetScreenProperty, reason);
  }

  private updateRecentInfoWithFold(screenProperty : SCBScreenProperty, reason: SCBPropertyChangeReason,
    screenRotation: number): void {
    switch (reason) {
      case SCBPropertyChangeReason.FOLD_SCREEN_ROTATION:
      case SCBPropertyChangeReason.FOLD_LANDSCAPE_START:
      case SCBPropertyChangeReason.PAGE_ROTATION: {
        this.needRenderClip.setClipWidth(screenProperty.width);
        this.needRenderClip.setClipHeight(screenProperty.height);
        this.currentRotation = screenRotation;
        break;
      }
      case SCBPropertyChangeReason.FOLD_TO_EXPAND:
      case SCBPropertyChangeReason.EXPAND_TO_FOLD: {
        this.needRenderClip.setClipWidth(screenProperty.width);
        this.needRenderClip.setClipHeight(screenProperty.height);
        if (this._isActive) {
          this.currentRotation = screenRotation;
        } else {
          if (this.isVertical(this.currentRotation) !== this.isVertical(screenRotation)) {
            let width = this.needRenderClip.clipHeight.copy();
            let height = this.needRenderClip.clipWidth.copy();
            this.needRenderClip.setClipWidth(width);
            this.needRenderClip.setClipHeight(height);
          }
        }
        break;
      }
      default:
        log.showError('updateRecentInfoWithFold unknown reason type:' + reason);
        return;
    }
    log.showInfo('updateRecentInfoWithFold:' + this.containerId + ' reason:' + reason +
      ' clipWidth:' + this.needRenderClip.clipWidth.getPx() + ' clipHeight:' + this.needRenderClip.clipHeight.getPx() +
      ' currentRotation:' + this.currentRotation + ' isActive:' + this._isActive + ' screenProperty:' +
      JSON.stringify(screenProperty) + ' screenRotation:' + screenRotation);
  }

  /**
   * Update container session with fold
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   */
  public updateContainerSessionWithFold(screenProperty : SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    let screenRotation: number = screenProperty.rotation;
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
    if (!screenSession) {
      log.showError('updateContainerSessionWithFold screenSession is null');
      return;
    }
    if (this.isActive && this.isPcAppExit()) {
      log.showInfo(`updateContainerSessionWithFold return for pc app and copy screenProperty to containerSession`);
      // pc应用折叠时保持windowScene大小
      this.screenProperty.copy(screenProperty);
      let sizeReason: sceneSessionManager.SessionSizeChangeReason =
        sceneSessionManager.SessionSizeChangeReason.UNDEFINED;
      this.primarySession?.updateRect(new ScbNumber(screenProperty.left), new ScbNumber(screenProperty.top),
        new ScbNumber(screenProperty.width), new ScbNumber(screenProperty.height), sizeReason);
      this.primarySession?.calcSessionRectAfterFoldChange(screenProperty);
      return;
    }
    if (this.isFloat || this.isFloatView) {
      log.showInfo(`updateContainerSessionWithFold return and copy screenProperty to containerSession`);
      this.screenProperty.copy(screenProperty);
      return;
    }
    if (screenSession.isRotateScreenPolicy()) {
      screenRotation = screenSession.scbScreenProperty.rotation;
    }
    this.updateRecentInfoWithFold(screenProperty, reason, screenRotation);
    switch (reason) {
      case SCBPropertyChangeReason.FOLD_SCREEN_ROTATION:
      case SCBPropertyChangeReason.FOLD_LANDSCAPE_START:
      case SCBPropertyChangeReason.PAGE_ROTATION: {
        this.updateContainerSessionInfoWithFold(screenProperty, reason);
        break;
      }
      case SCBPropertyChangeReason.FOLD_TO_EXPAND:
      case SCBPropertyChangeReason.EXPAND_TO_FOLD: {
        if (this._isActive) {
          this.updateContainerSessionInfoWithFold(screenProperty, reason);
        } else {
          let tmpProperty = new SCBScreenProperty();
          tmpProperty.copy(screenProperty);
          if (this.isVertical(this.currentRotation) !== this.isVertical(screenRotation)) {
            [tmpProperty.width, tmpProperty.height] = [tmpProperty.height, tmpProperty.width];
          }
          if (!screenSession.isRotateScreenPolicy()) {
            tmpProperty.rotation = this.currentRotation;
          }
          this.updateContainerSessionInfoWithFold(tmpProperty, reason);
        }
        break;
      }
      default:
        log.showError('updateRecentInfoWithFold unknown reason type:' + reason);
        return;
    }
    log.showInfo('updateContainerSessionWithFold:' + this.containerId + ' currentProperty:' +
      JSON.stringify(this.screenProperty) + ' reason:' + reason + ' screenProperty:' + JSON.stringify(screenProperty) +
      ' screenRotation:' + screenRotation);
  }

  private updateContainerSessionInfoWithFold(screenProperty : SCBScreenProperty, reason: SCBPropertyChangeReason): void {
    let sizeReason: sceneSessionManager.SessionSizeChangeReason = sceneSessionManager.SessionSizeChangeReason.UNDEFINED;
    if (reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION) {
      sizeReason = sceneSessionManager.SessionSizeChangeReason.ROTATION;
    } else if (reason === SCBPropertyChangeReason.PAGE_ROTATION) {
      sizeReason = sceneSessionManager.SessionSizeChangeReason.PAGE_ROTATION;
    }
    if (this.isSplit && this.splitParam.getLifeCycle() !== SplitLifeCycle.EXIT_SPLIT_TO_FULLSCREEN &&
      !this.isMidScene) {
      if (this.getState() === SCBSceneContainerState.ONE_STEP) {
        this.dividerParam.needCutOut = false;
      } else {
        this.updateSplitStyleWithFold(reason, screenProperty);
      }
      this.updateSessionRectForSplit(screenProperty, true, sizeReason);
      SCBSceneSessionManager.getInstance().notifySystemSceneToSetRotation(screenProperty);
    } else if (!this.isMidScene) {
      this.primarySession?.updateRect(new ScbNumber(screenProperty.left), new ScbNumber(screenProperty.top),
        new ScbNumber(screenProperty.width), new ScbNumber(screenProperty.height), sizeReason);
      this.secondarySession?.updateRect(new ScbNumber(screenProperty.left), new ScbNumber(screenProperty.top),
        new ScbNumber(screenProperty.width), new ScbNumber(screenProperty.height), sizeReason);
    }
    this.primarySession?.calcSessionRectAfterFoldChange(screenProperty);
    this.secondarySession?.calcSessionRectAfterFoldChange(screenProperty);
    let oldScreenProperty = new SCBScreenProperty();
    oldScreenProperty.copy(this.screenProperty);
    this.notifySceneContainerFoldChange(oldScreenProperty, screenProperty, reason);
    this.screenProperty.copy(screenProperty);
    this.width = new ScbNumber(this.screenProperty.width);
    this.height = new ScbNumber(this.screenProperty.height);
  }

  /**
   * Update container session with single Hand
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   */
  public updateContainerSessionWithSingleHand(screenProperty : SCBScreenProperty,
                                              reason: SCBPropertyChangeReason): void {
    let screenRotation: number = screenProperty.rotation;
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
    if (!screenSession) {
      log.showError('updateContainerSessionWithSingleHand screenSession is null');
      return;
    }
    if (this.isFloat || this.isFloatView) {
      log.showInfo(`updateContainerSessionWithSingleHand return and copy screenProperty to containerSession`);
      return;
    }
    log.showInfo('updateContainerSessionWithSingleHand:' + this.containerId + ' currentScreenProperty:' +
      JSON.stringify(this.screenProperty) + ' reason:' + reason + ' newScreenProperty:' +
      JSON.stringify(screenProperty) + ' screenRotation:' + screenRotation);
  }

  private updateSplitStyleWithFold(reason: SCBPropertyChangeReason, screenProperty: SCBScreenProperty): void {
    if (this.primarySession && this.secondarySession) {
      log.showInfo('updateSplitStyleWithFold');
      switch (reason) {
        case SCBPropertyChangeReason.FOLD_LANDSCAPE_START:
        case SCBPropertyChangeReason.FOLD_SCREEN_ROTATION: {
          // Pad需要根据横竖屏状态决定是上下分屏还是左右分屏
          const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
          if (uiType === SCBConstants.UITYPE_PAD) {
            const isVertical = (screenProperty.width < screenProperty.height);
            this.dividerParam.setIsVertical(isVertical);
          }
          if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
            const isVertical: boolean = this.isVertical(this.currentRotation);
            this.dividerParam.setIsVertical(isVertical);
            this.dividerParam.needCutOut = true;
            this.dividerParam.setSplitStyle(isVertical ? SplitStyle.UP_AND_DOWN_POS : SplitStyle.LEFT_AND_RIGHT_POS);
          }
          let splitRatio = (uiType === SCBConstants.UITYPE_PAD) ? this.splitParam.getSplitRatioCacheForPad() :
          this.splitParam.getGModeSplitRatioCache();
          this.dividerParam.updateDividerParamWithRatio(screenProperty, splitRatio);
          break;
        }
        case SCBPropertyChangeReason.EXPAND_TO_FOLD: {
          this.dividerParam.needCutOut = true;
          this.updateSplitStyleWithFoldInner(screenProperty);
          this.splitParam.clearPrevSplitRatio();
          if (DeviceHelper.isUltraScreenProduct()) {
            this.dividerParam.setSplitStyle(SplitStyle.UNDEFINED);
          }
          break;
        }
        case SCBPropertyChangeReason.FOLD_TO_EXPAND: {
          let targetSplitStyle = this.getSplitStyleWhenFoldToExpand(screenProperty);
          this.dividerParam.needCutOut = targetSplitStyle === SplitStyle.LEFT_AND_RIGHT_POS ? false : true;
          this.dividerParam.setSplitStyle(targetSplitStyle);
          this.updateSplitStyleWithFoldInner(screenProperty);
          break;
        }
        default:
          break;
      }
    }
    log.showInfo(`[SCBSplit] updateSplitStyleWithFold reason: ${reason}` +
      `, targetStyle: ${this.dividerParam.isUpDownSplit()}`);
  }

  private getSplitStyleWhenFoldToExpand(screenProperty: SCBScreenProperty): SplitStyle {
    let targetSplitStyle = this.dividerParam.getSplitStyle();
    if (this._isActive && SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      const screenSession: SCBScreenSession =
        SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
      targetSplitStyle = this.isVertical(screenSession.scbScreenProperty.rotation) ? SplitStyle.UP_AND_DOWN_POS :
        SplitStyle.LEFT_AND_RIGHT_POS;
    }
    if (SCBTriFoldManager.getInstance().isCurMState() && DeviceHelper.isUltraScreenProduct()) {
      if (SCBSplitUtils.hasFixedSplitRatioScene(this)) {
        targetSplitStyle = SplitStyle.LEFT_AND_RIGHT_POS;
      }
    }
    if (targetSplitStyle === SplitStyle.UNDEFINED) {
      targetSplitStyle = SplitStyle.LEFT_AND_RIGHT_POS;
    } else {
      this.splitParam.clearPrevSplitRatio();
    }
    return targetSplitStyle;
  }

  private updateRecentInfoWithPhonePortraitApp(screenProperty: SCBScreenProperty,
                                               reason: SCBPropertyChangeReason,
                                               screenRotation: number): void {
    this.needRenderClip.clipWidth.setNumber(screenProperty.width);
    this.needRenderClip.clipHeight.setNumber(screenProperty.height);
    this.currentRotation = screenRotation;
    log.showInfo('updateRecentInfoWithPhonePortraitApp: ' + this.containerId + ' reason:' + reason + ' clipWidth: ' +
    this.needRenderClip.clipWidth.getPx() + ' clipHeight: ' + this.needRenderClip.clipHeight.getPx() +
      ' currentRotation:' + this.currentRotation);
  }

  /**
   * Update container session with fold
   *
   * @param { SCBScreenProperty } screenProperty
   * @param { SCBPropertyChangeReason } reason
   */
  public updateContainerSessionWithPhonePortraitApp(screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason,
                                                      ): void {
    let screenRotation: number = screenProperty.rotation;
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
    if (!screenSession) {
      log.showError('updateContainerSessionWithPhonePortraitApp screenSession is null');
      return;
    }
    if (this.isFloat || this.isFloatView) {
      log.showInfo(`updateContainerSessionWithPhonePortraitApp return and copy screenProperty to containerSession`);
      this.screenProperty.copy(screenProperty);
      return;
    }
    if (screenSession.isRotateScreenPolicy()) {
      screenRotation = screenSession.scbScreenProperty.rotation;
    }
    if (SCBPropertyChangeReason.FOLD_LANDSCAPE_START === reason ||
      SCBPropertyChangeReason.FOLD_SCREEN_ROTATION === reason ||
      reason === SCBPropertyChangeReason.PAGE_ROTATION ||
      SCBPropertyChangeReason.FOLD_TO_EXPAND === reason) {
      this.updateRecentInfoWithPhonePortraitApp(screenProperty, reason, screenRotation);
      this.updateContainerSessionInfoWithPhonePortraitApp(screenProperty, reason);
    }
    log.showInfo('updateContainerSessionWithPhonePortraitApp: ' + this.containerId + 'currentProperty: ' +
      this.screenProperty.getLogString() + ' reason:' + reason);
  }

  private updateContainerSessionInfoWithPhonePortraitApp(screenProperty: SCBScreenProperty,
                                                         reason: SCBPropertyChangeReason,): void {
    let sizeReason: sceneSessionManager.SessionSizeChangeReason = sceneSessionManager.SessionSizeChangeReason.UNDEFINED;
    if (reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION) {
      sizeReason = sceneSessionManager.SessionSizeChangeReason.ROTATION;
    }
    let scaleScreenHeight = screenProperty.height;
    let scaleScreenWidth: number = scaleScreenHeight * 0.5;
    let left = (screenProperty.width - scaleScreenWidth) / 2;
    this.primarySession?.updateRect(new ScbNumber(left), new ScbNumber(0),
      new ScbNumber(scaleScreenWidth), new ScbNumber(scaleScreenHeight), sizeReason);
    this.primarySession?.setPosNum(px2vp(left), 0);
    this.primarySession?.calcSessionRectAfterFoldChange(screenProperty);
    this.secondarySession?.calcSessionRectAfterFoldChange(screenProperty);
    let oldScreenProperty = new SCBScreenProperty();
    oldScreenProperty.copy(this.screenProperty);
    this.updateFullScreenSpecificSessionRect(oldScreenProperty, screenProperty, reason);
    this.screenProperty.copy(screenProperty);
    this.width = new ScbNumber(this.screenProperty.width);
    this.height = new ScbNumber(this.screenProperty.height);
  }

  private updateSplitStyleWithFoldInner(screenProperty: SCBScreenProperty): void {
    log.showInfo('updateSplitStyleWithFoldInner');
    let isVertical = this.isVertical(screenProperty.rotation);
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (screenSession && screenSession.isRotateScreenPolicy()) {
      isVertical = this.isVertical(screenSession.scbScreenProperty.rotation);
    }
    this.dividerParam.setIsVertical(isVertical);
    this.dividerParam.updateDividerParamWithRatio(screenProperty, this.splitParam.getGModeSplitRatioCache());
  }

  /**
   * Get container request orientation
   *
   * @returns { SCBSceneOrientation }
   */
  public getContainerRequestOrientation() : SCBSceneOrientation {
    if (!this.primarySession && !this.secondarySession) {
      return SCBSceneOrientation.UNSPECIFIED;
    }
    // midScene G-state rotate policy
    if (this.isMidScene && SCBTriFoldManager.getInstance().isCurGState()) {
      return SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED;
    }
    // split rotate policy
    if (this.primarySession && this.secondarySession) {
      return SCBSceneOrientation.AUTO_ROTATION_RESTRICTED;
    }
    let actualSession = this.primarySession ? this.primarySession : this.secondarySession;
    return actualSession.requestOrientation;
  }

  /**
   * update container requestOrientation according to container state
   */
  public updateRequestOrientation(orientation: SCBSceneOrientation = this.getContainerRequestOrientation()): void {
    this.sessionData.requestOrientation = orientation;
  }

  private isHorizontalConfigurable(): boolean {
    let isRightPowerButton = SCBDeviceScreenConfig.getInstance().getRightPowerButton();
    log.showInfo('isHorizontalConfigurable rightPowerButton: ' + isRightPowerButton +
      ', sdkVersion: ' + this.sdkVersion);
    const uiType = SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType;
    // Pad横屏方向一直是正常的，直接返回true。
    if (uiType === SCBConstants.UITYPE_PAD) {
      return true;
    }
    if (this.sdkVersion >= 12 && isRightPowerButton) {
      return true;
    }
    return false;
  }

  private processOrientationRelatedToSensor(
    sensorRotation: number, isScreenLocked: boolean, orientation: number = this.requestOrientation) : number {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      WinLog.showError(WinLogDomain.WMS_ROTATION, '[processOrientationRelatedToSensor] notifyRotation screenSession is null');
      return RotationConstants.ROTATION_0;
    }
    let currentScreenRotation = SCBScreenSessionManager.getInstance().getScreenRotation(this.screenProperty.screenId);
    let isPlacedRotateFriendlyDevicePlaced: boolean = screenSession.isPlacedRotateFriendlyDevicePlaced();
    WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[processOrientationRelatedToSensor] requestOrientation: ' + this.requestOrientation +
      ' sensorRotation: ' + sensorRotation + ' isScreenLocked: ' + isScreenLocked + ' currentScreenRotation: ' +
      currentScreenRotation + ' targetOrientation: ' + orientation + ' isPlacedRotateFriendlyDevicePlaced: ' +
      isPlacedRotateFriendlyDevicePlaced);
    switch (orientation) {
      // relate to system
      case SCBSceneOrientation.AUTO_ROTATION_RESTRICTED: {
        if (isScreenLocked) {
          if (SCBWindowRotateController.getInstance().isDesktopRotatable()) {
            return currentScreenRotation;
          } else {
            return RotationConstants.ROTATION_0;
          }
        } else {
          if (isPlacedRotateFriendlyDevicePlaced) {
            return currentScreenRotation;
          }
        }
        return sensorRotation;
      }
      case SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED: { // horizontal
        return this.getHorizontalRotationToSensor(isScreenLocked, currentScreenRotation, sensorRotation,
          isPlacedRotateFriendlyDevicePlaced);
      }
      case SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED: { // vertical
        return this.getVerticalRotationToSensor(isScreenLocked, currentScreenRotation, sensorRotation,
          isPlacedRotateFriendlyDevicePlaced);
      }
      // relate to sensor
      case SCBSceneOrientation.SENSOR: {
        WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[processOrientationRelatedToSensor] SENSOR requestOrientation: ' +
          this.requestOrientation + ' sensorRotation: ' + sensorRotation + ' isScreenLocked: ' + isScreenLocked);
        if (isPlacedRotateFriendlyDevicePlaced) {
          WinLog.showInfo(WinLogDomain.WMS_ROTATION, '[processOrientationRelatedToSensor] SENSOR when the device is placed');
          return currentScreenRotation;
        }
        return sensorRotation;
      }
      case SCBSceneOrientation.SENSOR_HORIZONTAL: {
        return this.getSensorHorizontalRotation(currentScreenRotation, sensorRotation,
          isPlacedRotateFriendlyDevicePlaced);
      }
      case SCBSceneOrientation.SENSOR_VERTICAL: {
        return this.getSensorVerticalRotation(currentScreenRotation, sensorRotation,
          isPlacedRotateFriendlyDevicePlaced);
      }
      default: {
        return currentScreenRotation;
      }
    }
  }

  private getCurrentScreenRotation(
    currentScreenRotation: number, screenSession: SCBScreenSession) : void {
    let isExpandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    currentScreenRotation = isExpandStatus ? screenSession?.resumeFoldablePhoneRotation(screenSession.scbScreenProperty.rotation) :
    screenSession?.scbScreenProperty.rotation;
  }

  private getHorizontalRotationToSensor(isScreenLocked: boolean, currentScreenRotation: number, sensorRotation: number,
    isPlacedRotateFriendlyDevicePlaced: boolean = false): number {
    if (isScreenLocked) {
      let tmpRotation: number = this.getHorizontalRotation();
      let resultRotation: number = this.isVertical(currentScreenRotation) ? tmpRotation :
        currentScreenRotation;
      log.showInfo('processOrientationRelatedToSensor AUTO_ROTATION_LANDSCAPE_RESTRICTED currentScreenRotation: ' +
        currentScreenRotation + ' resultRotation: ' + resultRotation + ' isScreenLocked: ' + isScreenLocked);
      return resultRotation;
    }
    if (isPlacedRotateFriendlyDevicePlaced) {
      if (!this.isVertical(currentScreenRotation)) {
        return currentScreenRotation;
      }
      if (!this.isVertical(sensorRotation)) {
        return sensorRotation;
      }
      return this.getHorizontalRotation();
    } else {
      if (!this.isVertical(sensorRotation)) {
        return sensorRotation;
      }
      // when screen rotation is portrait, return landscape
      if (this.isVertical(currentScreenRotation)) {
        return this.getHorizontalRotation();
      }
      return currentScreenRotation;
    }
  }

  private getVerticalRotationToSensor(isScreenLocked: boolean, currentScreenRotation: number, sensorRotation: number,
    isPlacedRotateFriendlyDevicePlaced: boolean = false): number {
    if (isScreenLocked) {
      if (!this.isVertical(currentScreenRotation)) {
        return this.getVerticalRotation();
      }
      return currentScreenRotation;
    }
    if (isPlacedRotateFriendlyDevicePlaced) {
      if (this.isVertical(currentScreenRotation)) {
        return currentScreenRotation;
      }
      if (this.isVertical(sensorRotation)) {
        return sensorRotation;
      }
      return this.getVerticalRotation();
    } else {
      if (this.isVertical(sensorRotation)) {
        return sensorRotation;
      }
      // when screen rotation is landscape, return portrait
      if (!this.isVertical(currentScreenRotation)) {
        return this.getVerticalRotation();
      }
      return currentScreenRotation;
    }
  }

  private getSensorHorizontalRotation(currentScreenRotation: number, sensorRotation: number,
    isPlacedRotateFriendlyDevicePlaced: boolean = false): number {
    if (isPlacedRotateFriendlyDevicePlaced) {
      if (!this.isVertical(currentScreenRotation)) {
        return currentScreenRotation;
      }
      if (!this.isVertical(sensorRotation)) {
        return sensorRotation;
      }
      return this.getHorizontalRotation();
    } else {
      if (!this.isVertical(sensorRotation)) {
        return sensorRotation;
      }
      // when screen rotation is portrait, return landscape
      if (this.isVertical(currentScreenRotation)) {
        return this.getHorizontalRotation();
      }
      return currentScreenRotation;
    }
  }

  private getSensorVerticalRotation(currentScreenRotation: number, sensorRotation: number,
    isPlacedRotateFriendlyDevicePlaced: boolean = false): number {
    if (isPlacedRotateFriendlyDevicePlaced) {
      if (this.isVertical(currentScreenRotation)) {
        return currentScreenRotation;
      }
      if (this.isVertical(sensorRotation)) {
        return sensorRotation;
      }
      return this.getVerticalRotation();
    } else {
      if (this.isVertical(sensorRotation)) {
        return sensorRotation;
      }
      // when screen rotation is landscape, return portrait
      if (!this.isVertical(currentScreenRotation)) {
        return this.getVerticalRotation();
      }
      return currentScreenRotation;
    }
  }

  private getVerticalRotation(): number {
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
      if (screenSession) {
        return SCBRotationConfig.getInstance().getVerticalRotation(screenSession);
      }
    }

    if (this.screenProperty.defaultScreenOrientation === 0) {
      if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
        return RotationConstants.ROTATION_90;
      }
      return RotationConstants.ROTATION_0;
    } else {
      return RotationConstants.ROTATION_90;
    }
  }

  private getHorizontalRotation(): number {
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
      if (screenSession && this.sdkVersion >= 12) {
        return SCBRotationConfig.getInstance().getHorizontalRotation(screenSession);
      }
    }

    if (this.screenProperty.defaultScreenOrientation === 0) {
      if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
        return RotationConstants.ROTATION_0;
      }
      return this.isHorizontalConfigurable() ? RotationConstants.ROTATION_270 :
        RotationConstants.ROTATION_90;
    } else {
      return RotationConstants.ROTATION_0;
    }
  }

  private getReverseVerticalRotation(): number {
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
      if (screenSession) {
        return SCBRotationConfig.getInstance().getReverseVerticalRotation(screenSession);
      }
    }

    if (this.screenProperty.defaultScreenOrientation === 0) {
      if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
        return RotationConstants.ROTATION_270;
      }
      return RotationConstants.ROTATION_180;
    } else {
      return RotationConstants.ROTATION_270;
    }
  }

  private getReverseHorizontalRotation(): number {
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
      if (screenSession && this.sdkVersion >= 12) {
        return SCBRotationConfig.getInstance().getReverseHorizontalRotation(screenSession);
      }
    }

    if (this.screenProperty.defaultScreenOrientation === 0) {
      if (SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
        return RotationConstants.ROTATION_180;
      }
      return this.isHorizontalConfigurable() ? RotationConstants.ROTATION_90 :
        RotationConstants.ROTATION_270;
    } else {
      return RotationConstants.ROTATION_180;
    }
  }

  private processOrientationUnrelatedToSensor(orientation: number = this.requestOrientation): number {
    log.showInfo('processOrientationUnrelatedToSensor requestOrientation: ' + this.requestOrientation + ' targetOrientation ' + orientation);
    switch (orientation) {
      case SCBSceneOrientation.HORIZONTAL: {
        return this.getHorizontalRotation();
      }
      case SCBSceneOrientation.VERTICAL: {
        if (this.isNeedBackToMidSceneForPad()) {
          return this.getHorizontalRotation();
        } else {
          return this.getVerticalRotation();
        }
      }
      case SCBSceneOrientation.REVERSE_HORIZONTAL: {
        return this.getReverseHorizontalRotation();
      }
      case SCBSceneOrientation.REVERSE_VERTICAL: {
        return this.getReverseVerticalRotation();
      }
      case SCBSceneOrientation.FOLLOW_RECENT:
      case SCBSceneOrientation.LOCKED: {
        let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
        if (!screenSession) {
          log.showError('notifyRotation screenSession is null');
          return this.screenProperty.rotation;
        }
        // return current screen rotation
        return screenSession.scbScreenProperty.rotation;
      }
      default: {
        return this.screenProperty.rotation;
      }
    }
  }

  private isNeedBackToMidSceneForPad(): boolean {
    if (MidSceneConfig.isSupportPadDifference() && this.isInMidSceneRecordForPad && !this.isStartFromRecentForPad) {
      return true;
    }
    // avoid startfrom recent oneStep back to midscene
    setTimeout(() => {
      if (MidSceneConfig.isSupportPadDifference() && this.isInMidSceneRecordForPad && this.isStartFromRecentForPad) {
        this.isStartFromRecentForPad = false;
      }
    }, 800);
    return false;
  }

  /**
   * process orientation related to split
   * fold phone
   *  oneStep only 0
   *  split can not 180
   * @param { Number } sensorRotation
   * @returns { Number|undefined }
   */
  public processOrientationRelatedToSplit(sensorRotation: number): number | undefined {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      log.showError('processOrientationRelatedToSplit screenSession is null');
      return undefined;
    }
    const uiType: string = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType;
    let isLock = SCBScreenSessionManager.getInstance().getScreenOrientationLocked(this.screenProperty.screenId);
    let screenRotation = screenSession.scbScreenProperty.rotation;
    log.showInfo(`processOrientationRelatedToSplit sensorRotation ${sensorRotation} isLock ${isLock}`);
    if ((this.isOneStepSplit() || this.isMidScene) && !SCBSceneUtils.isStartFromVirtual(this.primarySession)) {
      let isGState = SCBTriFoldManager.getInstance().isCurGState();
      if (uiType === SCBConstants.UITYPE_PHONE && !isLargeFoldProductInExpand() && !isGState) {
        return RotationConstants.ROTATION_0;
      }
      // G-state MidScene only supports horizontal use
      if (this.isMidScene && isGState) {
        return this.processMidSceneGStateOrientation(screenRotation, sensorRotation, isLock);
      }
      if (MidSceneConfig.isSupportPadDifference() && this.isMidScene) {
        return this.processMidScenePadOrientation(screenRotation, sensorRotation, isLock);
      }
      if (isLock) {
        return screenRotation;
      }
      return sensorRotation;
    } else {
      return this.processOrientationForSplit(sensorRotation, screenRotation, uiType, isLock);
    }
  }

  private processOrientationForSplit(sensorRotation: number, screenRotation: number,
    uiType: string, isLock: boolean): number | undefined {
    if (DeviceHelper.isGState() && DeviceHelper.isUltraScreenProduct()) {
      if (SCBSplitUtils.hasFixedSplitRatioScene(this)) {
        return this.processMidSceneGStateOrientation(screenRotation, sensorRotation, isLock);
      }
    }
    if (uiType === SCBConstants.UITYPE_PHONE && !isLargeFoldProductInExpand() &&
      sensorRotation === RotationConstants.ROTATION_180) {
      return screenRotation;
    }
    if (SCBSceneUtils.isStartFromVirtual(this.primarySession, this.secondarySession)) {
      return RotationConstants.ROTATION_0;
    }
    return this.processOrientationRelatedToSensor(sensorRotation, isLock);
  }

  /**
   * Pad MidScene only supports horizontal use
   * @param screenRotation current screen rotation
   * @param sensorRotation current sensor rotation
   * @param isLock orientation locked state
   */
  private processMidScenePadOrientation(screenRotation: number, sensorRotation: number, isLock: boolean): number {
    let rotation = screenRotation;
    // pad horizontal judgment
    let isHorizontal = (rotation: number) => {
      return rotation === RotationConstants.ROTATION_270 || rotation === RotationConstants.ROTATION_90;
    };
    if (!isLock && isHorizontal(sensorRotation)) {
      rotation = sensorRotation;
    } else {
      rotation = isHorizontal(screenRotation) ? rotation : RotationConstants.ROTATION_270;
    }
    log.showInfo(`[SCBMidScene] container in midscene: ${this.containerId}, targetRotation: ${rotation} ${isLock}`);
    return rotation;
  }

  /**
   * G-state MidScene only supports horizontal use
   * @param screenRotation current screen rotation
   * @param sensorRotation current sensor rotation
   * @param isLock orientation locked state
   */
  private processMidSceneGStateOrientation(screenRotation: number, sensorRotation: number, isLock: boolean) {
    let rotation = screenRotation;
    // G-state horizontal judgment
    let isHorizontal = (rotation: number) => {
      return rotation === RotationConstants.ROTATION_180 || rotation === RotationConstants.ROTATION_0;
    };
    if (!isLock && isHorizontal(sensorRotation)) {
      rotation = sensorRotation;
    } else {
      rotation = isHorizontal(screenRotation) ? rotation : RotationConstants.ROTATION_0;
    }
    log.showInfo(`[SCBMidScene] container: ${this.containerId}, targetRotation: ${rotation}`);
    return rotation;
  }

  private processNotFromUserRotationPolicy(sensorRotation: number, currentScreenRotation: number,
    isScreenLocked: boolean, rotationPolicyMap: Map<number, boolean>,
    isPlacedRotateFriendlyDevicePlaced: boolean): number {
    if (isScreenLocked) {
      if (this.requestOrientation === SCBSceneOrientation.AUTO_ROTATION_UNSPECIFIED &&
        !rotationPolicyMap.get(RotationConstants.ROTATION_180)) {
        return RotationConstants.ROTATION_0;
      }
    } else {
      if (isPlacedRotateFriendlyDevicePlaced && rotationPolicyMap.get(currentScreenRotation)) {
        return currentScreenRotation;
      }
      if (rotationPolicyMap.get(sensorRotation)) {
        return sensorRotation;
      }
    }
    if (rotationPolicyMap.get(currentScreenRotation)) {
      return currentScreenRotation;
    }
    if (this.screenProperty.defaultScreenOrientation === 0) {
      return RotationConstants.ROTATION_0;
    } else {
      return RotationConstants.ROTATION_90;
    }
  }

  private processFromUserOthersRotationPolicy(currentScreenRotation: number,
    rotationPolicyMap: Map<number, boolean>, orientation: number = this.requestOrientation) : number {
    if (this.screenProperty.defaultScreenOrientation !== 0) {
      return this.processUserOtherScreenOrientation(currentScreenRotation, rotationPolicyMap);
    }
    switch (orientation) {
      case SCBSceneOrientation.USER_ROTATION_PORTRAIT: {
        return this.getVerticalRotation();
      }
      case SCBSceneOrientation.USER_ROTATION_LANDSCAPE: {
        let horizontalRotation = this.getHorizontalRotation();
        if (rotationPolicyMap.get(horizontalRotation)) {
          return horizontalRotation;
        }
        return RotationConstants.ROTATION_0;
      }
      case SCBSceneOrientation.USER_ROTATION_PORTRAIT_INVERTED: {
        let reverVerticalRotation = this.getReverseVerticalRotation();
        if (rotationPolicyMap.get(reverVerticalRotation)) {
          return reverVerticalRotation;
        }
        return RotationConstants.ROTATION_0;
      }
      case SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED: {
        let reverseHorizontalRotation = this.getReverseHorizontalRotation();
        if (rotationPolicyMap.get(reverseHorizontalRotation)) {
          return reverseHorizontalRotation;
        }
        return RotationConstants.ROTATION_0;
      }
      default:
        return currentScreenRotation;
    }
  }

  private processUserOtherScreenOrientation(currentScreenRotation: number,
    rotationPolicyMap: Map<number, boolean>) : number {
    switch (this.requestOrientation) {
      case SCBSceneOrientation.USER_ROTATION_PORTRAIT: {
        return RotationConstants.ROTATION_90;
      }
      case SCBSceneOrientation.USER_ROTATION_LANDSCAPE: {
        if (rotationPolicyMap.get(RotationConstants.ROTATION_0)) {
          return RotationConstants.ROTATION_0;
        }
        return RotationConstants.ROTATION_90;
      }
      case SCBSceneOrientation.USER_ROTATION_PORTRAIT_INVERTED: {
        if (rotationPolicyMap.get(RotationConstants.ROTATION_270)) {
          return RotationConstants.ROTATION_270;
        }
        return RotationConstants.ROTATION_90;
      }
      case SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED: {
        if (rotationPolicyMap.get(RotationConstants.ROTATION_180)) {
          return RotationConstants.ROTATION_180;
        }
        return RotationConstants.ROTATION_90;
      }
      default:
        return currentScreenRotation;
    }
  }

  private processFromUserAutoRotationUnspecified(sensorRotation: number, currentScreenRotation: number,
    isScreenLocked: boolean, rotationPolicyMap: Map<number, boolean>) : number {
    if (isScreenLocked) {
      if (!rotationPolicyMap.get(RotationConstants.ROTATION_180)) {
          return RotationConstants.ROTATION_0;
      }
      if (rotationPolicyMap.get(currentScreenRotation)) {
        return currentScreenRotation;
      }
    } else {
      if (rotationPolicyMap.get(sensorRotation)) {
        return sensorRotation;
      }
    }
    if (this.screenProperty.defaultScreenOrientation === 0) {
      return RotationConstants.ROTATION_0;
    } else {
      return RotationConstants.ROTATION_90;
    }
  }

  private processRotationPolicyOrientation(
    sensorRotation: number, isScreenLocked: boolean, fromUser: boolean = false, orientation: number = this.requestOrientation) : number {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!screenSession) {
      log.showError('processRotationPolicyOrientation screenSession is null');
      return RotationConstants.ROTATION_0;
    }
    let currentScreenRotation: number = screenSession.scbScreenProperty.rotation;
    let isPlacedRotateFriendlyDevicePlaced: boolean = screenSession.isPlacedRotateFriendlyDevicePlaced();
    log.showInfo('processRotationPolicyOrientation requestOrientation: ' + this.requestOrientation +
      ' sensorRotation: ' + sensorRotation + ' isScreenLocked: ' + isScreenLocked + ' fromUser: ' + fromUser +
      ' currentScreenRotation: ' + currentScreenRotation + ' targetOrientation ' + orientation +
      ' isPlacedRotateFriendlyDevicePlaced: ' + isPlacedRotateFriendlyDevicePlaced);
    if (orientation  === SCBSceneOrientation.FOLLOW_DESKTOP) {
      return SCBFollowDesktopOrientationPolicy.getInstance().getTargetRotation(
        sensorRotation, currentScreenRotation, isScreenLocked, false, isPlacedRotateFriendlyDevicePlaced);
    }
    let rotationPolicyMap = SCBDeviceScreenConfig.getInstance().getRotationPolicyMap();
    if (!fromUser) {
      return this.processNotFromUserRotationPolicy(sensorRotation, currentScreenRotation,
        isScreenLocked, rotationPolicyMap, isPlacedRotateFriendlyDevicePlaced);
    }
    if (orientation  === SCBSceneOrientation.AUTO_ROTATION_UNSPECIFIED) {
      return this.processFromUserAutoRotationUnspecified(sensorRotation, currentScreenRotation,
        isScreenLocked, rotationPolicyMap);
    }
    return this.processFromUserOthersRotationPolicy(currentScreenRotation, rotationPolicyMap, orientation);
  }

  /**
   * Get whether is orientation unrelated to sensor
   *
   * @returns { Boolean }
   */
  public isOrientationUnrelatedToSensor(orientation: number = this.requestOrientation): boolean {
    if ((orientation > SCBSceneOrientation.UNSPECIFIED &&
      orientation <= SCBSceneOrientation.REVERSE_HORIZONTAL) ||
      orientation === SCBSceneOrientation.LOCKED ||
      orientation === SCBSceneOrientation.FOLLOW_RECENT) {
      return true;
    }
    return false;
  }

  /**
   * Get whether is orientation related to sensor and scape
   *
   * @returns { Boolean }
   */
  public isOrientationRelatedToSensorLandscape(): boolean {
    if (this.requestOrientation === SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED ||
      this.requestOrientation === SCBSceneOrientation.SENSOR_HORIZONTAL) {
      return true;
    }
    return false;
  }

  /**
   * Get whether is orientation related to sensor portrait
   *
   * @returns { Boolean }
   */
  public isOrientationRelatedToSensorPortrait(): boolean {
    if (this.requestOrientation === SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED ||
      this.requestOrientation === SCBSceneOrientation.SENSOR_VERTICAL) {
      return true;
    }
    return false;
  }

  /**
   * Get whether orientation related to sensor restricted
   *
   * @returns { boolean }
   */
  public isOrientationRelatedToSensorRestricted(): boolean {
    if (this.requestOrientation === SCBSceneOrientation.AUTO_ROTATION_RESTRICTED) {
      return true;
    }
    return false;
  }

  /**
   * Get whether requestOrientation is FOLLOW_DESKTOP
   *
   * @returns { boolean }
   */
  public isOrientationFollowDesktop(): boolean {
    if (this.requestOrientation === SCBSceneOrientation.FOLLOW_DESKTOP) {
      return true;
    }
    return false;
  }

  private isRelatedToRotationPolicy(orientation: number = this.requestOrientation): boolean {
    if (orientation >= SCBSceneOrientation.AUTO_ROTATION_UNSPECIFIED &&
      orientation <= SCBSceneOrientation.FOLLOW_DESKTOP) {
      return true;
    }
    return false;
  }

  public isRelatedToUserRotationPolicy(): boolean {
    if (this.requestOrientation >= SCBSceneOrientation.USER_ROTATION_PORTRAIT &&
      this.requestOrientation <= SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED) {
      return true;
    }
    return false;
  }

  /**
   * Get target rotation
   *
   * @param { Number } sensorRotation
   * @param { boolean } fromUser
   * @returns { Number }
   */
  public getTargetRotation(sensorRotation: number, fromUser: boolean = false): number {
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    let isScreenLocked = SCBScreenSessionManager.getInstance().getScreenOrientationLocked(this.screenProperty.screenId);
    let currentScreenRotation = SCBScreenSessionManager.getInstance().getScreenRotation(this.screenProperty.screenId);
    let isPlacedRotateFriendlyDevicePlaced: boolean = screenSession.isPlacedRotateFriendlyDevicePlaced();
    let fixedRotation: number = this.getFixedRotation(screenSession, currentScreenRotation);
    WinLog.showWarn(WinLogDomain.WMS_ROTATION, '[getTargetRotation] bundleName:' + this.primarySession?.sceneInfo.bundleName + 
                 ' requestOrientation:' + this.requestOrientation + ' isScreenLocked:' + isScreenLocked + 
                 ' isPlacedRotateFriendlyDevicePlaced:' + isPlacedRotateFriendlyDevicePlaced + 
                 ' fixedRotation: ' + fixedRotation);

    if (fixedRotation !== -1) {
      return fixedRotation;
    }

    if (this.primarySession?.isPcAppInPad && DeviceHelper.isUltraScreenProduct()) {
      log.showInfo(`getTargetRotation handle in pc in largeScreen.`);
      return RotationConstants.ROTATION_0;
    }

    if (this.isSplit || this.isMidScene) {
      return this.processOrientationRelatedToSplit(sensorRotation);
    }
    if (this.requestOrientation === SCBSceneOrientation.UNSPECIFIED) {
      return SCBDefaultOrientationPolicy.getInstance().getTargetRotation(sensorRotation, currentScreenRotation,
        isScreenLocked, fromUser, isPlacedRotateFriendlyDevicePlaced);
    }
    if (this.isOrientationUnrelatedToSensor()) {
      return this.processOrientationUnrelatedToSensor();
    }
    if (this.isRelatedToRotationPolicy()) {
      return this.processRotationPolicyOrientation(sensorRotation, isScreenLocked, fromUser);
    }
    return this.processOrientationRelatedToSensor(sensorRotation, isScreenLocked);
  }

  private getFixedRotation(screenSession: SCBScreenSession, currentScreenRotation: number): number{
    if (SCBRotationConfig.getInstance().isDeviceRotationOptimizationSwitchOn()) {
      return SCBRotationConfig.getInstance().getDeviceFixedRotation(screenSession);
    }
    return -1;
  }

  public getTargetPageRotation(sensorRotation: number, targetOrientation: number, fromUser: boolean = false): number | null {
    log.showInfo('getTargetPageRotation: ' + this.primarySession?.sceneInfo.bundleName +
      ' targetOrientation: ' + targetOrientation);
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (screenSession === null) {
      log.showError(`getTargetPageRotation fail: reason:screenSession is null`);
      return null;
    }
    let isScreenLocked = SCBScreenSessionManager.getInstance().getScreenOrientationLocked(this.screenProperty.screenId);
    let currentScreenRotation = SCBScreenSessionManager.getInstance().getScreenRotation(this.screenProperty.screenId);
    let fixedRotation: number = this.getFixedRotation(screenSession, currentScreenRotation);
    if (fixedRotation !== -1) {
      return fixedRotation;
    }
    if (targetOrientation === SCBSceneOrientation.UNSPECIFIED) {
      return SCBDefaultOrientationPolicy.getInstance().getTargetRotation(sensorRotation, currentScreenRotation,
        isScreenLocked, fromUser);
    }
    if (this.isOrientationUnrelatedToSensor(targetOrientation)) {
      return this.processOrientationUnrelatedToSensor(targetOrientation);
    }
    if (this.isRelatedToRotationPolicy(targetOrientation)) {
      return this.processRotationPolicyOrientation(sensorRotation, isScreenLocked, fromUser, targetOrientation);
    }
    return this.processOrientationRelatedToSensor(sensorRotation, isScreenLocked, targetOrientation);
  }

  /**
   * register container rotation change callback
   *
   * @param { Function } callback
   */
  public registerContainerRotationChangeCallback(callback: Function): void {
    this.containerRotationChangeCallback = callback;
  }

  private notifySceneContainerRotationChange(lastRotation: number, screenProperty: SCBScreenProperty,
    reason: SCBContainerRotationReason): void {
    this.containerRotationChangeCallback && this.containerRotationChangeCallback(lastRotation, screenProperty, reason);
  }

  /**
   * register container active mode change callback
   *
   * @param { Function } callback
   */
  public registerContainerActiveModeChangeCallback(callback: Function): void {
    this.containerActiveModeChangeCallback = callback;
  }

  private notifySceneContainerActiveModeChange(oldScreenProperty : SCBScreenProperty, newScreenProperty: SCBScreenProperty): void {
    this.containerActiveModeChangeCallback && this.containerActiveModeChangeCallback(oldScreenProperty, newScreenProperty);
  }

  /**
   * register container refresh split scene callback
   *
   * @param { Function } callback
   */
  public registerRefreshSplitSceneCallback(callback: Function): void {
    this.containerRefreshSplitSceneCallback = callback;
  }

  /**
   * unregister container refresh split scene callback
   */
  public unregisterRefreshSplitSceneCallback(): void {
    this.containerRefreshSplitSceneCallback = undefined;
  }

  /**
   * refresh the width and height of the split-screen window
   */
  public notifyRefreshSplitScene(): void {
    if (this.containerRefreshSplitSceneCallback) {
      this.containerRefreshSplitSceneCallback();
    }
  }

  /**
   * register container fold change callback
   *
   * @param { Function } callback
   */
  public registerContainerFoldChangeCallback(callback: Function): void {
    this.containerFoldChangeCallback = callback;
  }

  /**
   * register container fold change callback for ultrascreen
   *
   * @param { Function } callback
   */
  public registerContainerFoldChangeForUltraScreenCallback(callback: Function): void {
    this.containerFoldChangeForUltraScreenCallback = callback;
  }

  public registerGetOverlaySessionCallback(callback: () => SCBSystemSceneSession[]): void {
    if (CommonUtils.isInvalid(callback) || this.getOverlaySessionCallback.indexOf(callback) !== -1) {
      return;
    }
    this.getOverlaySessionCallback.push(callback);
  }

  public unregisterGetOverlaySessionCallback(callback: () => SCBSystemSceneSession[]): void {
    let index = this.getOverlaySessionCallback.indexOf(callback);
    if (index !== -1) {
      this.getOverlaySessionCallback.splice(index, 1);
    }
  }

  public notifySceneContainerFoldChangeForUltraScreen(): void {
    if (this.containerFoldChangeForUltraScreenCallback) {
      log.showWarn(`notifySceneContainer foldstatus change`)
      this.containerFoldChangeForUltraScreenCallback();
    }
  }

  private isFullScene(currRect: SCBSessionRect, screenProperty: SCBScreenProperty): boolean {
    let screenRect = new SCBSessionRect(screenProperty.left, screenProperty.top,
      screenProperty.width, screenProperty.height);
    if (currRect.equals(screenRect)) {
      return true;
    }
    return false;
  }

  public getOverlaySessionList(): SCBSystemSceneSession[] {
    return this.getOverlaySessionCallback.map(value => value()).reduce((pre, cur) => pre.concat(cur), []);
  }

  private isUpdateFullScreenSpecificSessionRect(item: SCBSpecificSession, sessionRect: SCBSessionRect,
    oldScreenProperty: SCBScreenProperty, screenProperty: SCBScreenProperty): boolean {
    return this.isFullScene(item.currRect, oldScreenProperty) ||
      (this.isFullScene(sessionRect, screenProperty) && item.isFollowParentRect);
  }

  public updateFullScreenSpecificSessionRect(oldScreenProperty: SCBScreenProperty, screenProperty: SCBScreenProperty,
    reason: SCBPropertyChangeReason) {
    let sizeReason: sceneSessionManager.SessionSizeChangeReason = sceneSessionManager.SessionSizeChangeReason.UNDEFINED;
    if (reason === SCBPropertyChangeReason.FOLD_SCREEN_ROTATION) {
      sizeReason = sceneSessionManager.SessionSizeChangeReason.ROTATION;
    }
    if (reason === SCBPropertyChangeReason.PAGE_ROTATION) {
      sizeReason = sceneSessionManager.SessionSizeChangeReason.PAGE_ROTATION;
    }
    log.showInfo(`update full screen specific session rect, reason: ${reason}, ` +
      `oldScreenProperty: [${oldScreenProperty.getLogString()}], screenProperty: [${screenProperty.getLogString()}]`)
    if (this.isSplit) {
      log.showInfo('is split, do not handle');
      return;
    }
    let priSubList: SCBSpecificSceneSessionList | undefined =
      this.primarySession?.subSessionList;
    let secSubList: SCBSpecificSceneSessionList | undefined =
      this.secondarySession?.subSessionList;
    let priDialogList: SCBSpecificSceneSessionList | undefined =
      this.primarySession?.dialogSessionList;
    let secDialogList: SCBSpecificSceneSessionList | undefined =
      this.secondarySession?.dialogSessionList;
    priSubList?.forEach((item: SCBSpecificSession) => {
      if (this.isUpdateFullScreenSpecificSessionRect(item, this.primarySession?.currRect, oldScreenProperty,
        screenProperty)) {
        item.updateRect(new ScbNumber(screenProperty.left), new ScbNumber(screenProperty.top),
          new ScbNumber(screenProperty.width), new ScbNumber(screenProperty.height), sizeReason);
      }
    });
    secSubList?.forEach((item: SCBSpecificSession) => {
      if (this.isUpdateFullScreenSpecificSessionRect(item, this.secondarySession?.currRect, oldScreenProperty,
        screenProperty)) {
        item.updateRect(new ScbNumber(screenProperty.left), new ScbNumber(screenProperty.top),
          new ScbNumber(screenProperty.width), new ScbNumber(screenProperty.height), sizeReason);
      }
    });
    priDialogList?.forEach((item) => {
      if (this.isUpdateFullScreenSpecificSessionRect(item, this.primarySession?.currRect, oldScreenProperty,
        screenProperty)) {
        item.updateRect(new ScbNumber(screenProperty.left), new ScbNumber(screenProperty.top),
          new ScbNumber(screenProperty.width), new ScbNumber(screenProperty.height), sizeReason);
      }
    });
    secDialogList?.forEach((item) => {
      if (this.isUpdateFullScreenSpecificSessionRect(item, this.secondarySession?.currRect, oldScreenProperty,
        screenProperty)) {
        item.updateRect(new ScbNumber(screenProperty.left), new ScbNumber(screenProperty.top),
          new ScbNumber(screenProperty.width), new ScbNumber(screenProperty.height), sizeReason);
      }
    });
  }

  private notifySceneContainerFoldChange(oldScreenProperty : SCBScreenProperty, screenProperty : SCBScreenProperty,
                                         reason: SCBPropertyChangeReason): void {
    // If there is a callback, use the callback. If there is no callback, use the function directly.
    if (this.containerFoldChangeCallback) {
      this.containerFoldChangeCallback(oldScreenProperty, screenProperty, reason);
    } else {
      this.updateFullScreenSpecificSessionRect(oldScreenProperty, screenProperty, reason);
    }
  }

  /**
   * whether is split primary mode
   *
   * @param { SCBSceneSession } session
   * @return { Boolean }
   */
  public isSplitPrimaryMode(): boolean {
    return this.primarySession?.sceneInfo?.windowMode === SCBSceneMode.PRIMARY;
  }

  public isSplitSecondaryMode(): boolean {
    return this.primarySession?.sceneInfo?.windowMode === SCBSceneMode.SECONDARY;
  }

  /**
   * where is one step split
   *
   * @returns true if current in one step split or not
   */
  public isOneStepSplit(): boolean {
    return this.isSplit && this.primarySession && this.secondarySession === null;
  }

  /**
   * whether is split view
   *
   * @returns { Boolean }
   */
  public isSplitView(): boolean {
    return this.isSplit && this.primarySession !== null && this.secondarySession !== null;
  }

  public isPreSplitSession(): boolean {
    return this.isSplit && this.secondarySession === null;
  }

  /**
   * multi-window get split type
   *
   * @returns SplitType
   */
  public getSplitType(): SplitType {
    if (!this.isSplit) {
      return SplitType.FULL_SCREEN;
    }
    if (DeviceHelper.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
      if (this.dividerParam.splitStyle === SplitStyle.LEFT_AND_RIGHT_POS) {
        return SplitType.LEFT_RIGHT_SPLIT;
      } else {
        return SplitType.UP_DOWN_SPLIT;
      }
    }
    if (this.dividerParam.getIsVertical()) {
      return SplitType.UP_DOWN_SPLIT;
    } else {
      return SplitType.LEFT_RIGHT_SPLIT;
    }
  }

  /**
   * multi-window get one step split type
   *
   * @returns OneStepSplitType
   */
  public getOneStepSplitType(): OneStepSplitType {
    if (!this.isOneStepSplit()) {
      return OneStepSplitType.UNKNOWN;
    }
    if (DeviceHelper.getFoldDisplayMode() === display.FoldDisplayMode.FOLD_DISPLAY_MODE_FULL) {
      if (this.dividerParam.splitStyle === SplitStyle.LEFT_AND_RIGHT_POS) {
        return OneStepSplitType.LEFT_POS;
      }
    }
    return OneStepSplitType.UP_POS;
  }

  /**
   * Get session name
   *
   * @returns { String }
   */
  public getName(): string {
    let name: string = '';
    if (this.primarySession) {
      name += this.primarySession.getName();
    }
    if (this.secondarySession) {
      name += ' | ';
      name += this.secondarySession.getName();
    }
    if (this.midSceneMap.size > 0) {
      name = '';
    }
    for (let ele of this.midSceneMap.values()) {
      name += ' | [mid]';
      name += ele.getName();
    }
    name += `(containerId: ${this.containerId})`;
    return name;
  }

  /**
   * Get session bundleName
   */
  public getBundleName(): string {
    let bundleName = '';
    if (this.primarySession) {
      bundleName += this.primarySession.sceneInfo.bundleName;
    }
    if (this.secondarySession) {
      bundleName += ',' + this.secondarySession.sceneInfo.bundleName;
    }
    return bundleName;
  }

  /**
   * update size change reason
   *
   * @param reason
   * @param persistentId
   */
  public updateSizeChangeReason(reason: sceneSessionManager.SessionSizeChangeReason, persistentId?: number): void {
    if (!persistentId && !this.isSplit) {
      // use primarySession as default session
      this.primarySession?.updateSizeChangeReason(reason);
      return;
    }
    let session = this.midSceneMap.get(persistentId)?.session;
    if (session) {
      session.updateSizeChangeReason(reason);
      return;
    }
    let sceneSession: sceneSessionManager.SceneSession = undefined;
    sceneSession = this.primarySession?.session.persistentId === persistentId ? this.primarySession?.session :
      this.secondarySession?.session;
    sceneSession.updateSizeChangeReason(reason);
  }

  /**
   * update SessionRect when back split to one step in landScape in fold
   *
   * @param screenProperty
   * @param currentRotation
   * @param isPrimaryToOneStep
   * @param reason
   */
  public updateSessionRectForSplitOnBack(screenProperty: SCBScreenProperty, currentRotation: number,
                                         isPrimaryToOneStep: boolean,
                                         reason?: sceneSessionManager.SessionSizeChangeReason): void {
    if (!this.primarySession || !this.secondarySession) {
      return;
    }
    let changeReason = reason ? reason : sceneSessionManager.SessionSizeChangeReason.RESIZE;
    this.dividerParam.updateDividerParam(screenProperty);
    let width = new ScbNumber(screenProperty.width);
    let primaryPosX = new ScbNumber(this.dividerParam.getPriPosXPct() * screenProperty.width);
    let primaryPosY = new ScbNumber(this.dividerParam.getPriPosYPct() * screenProperty.height);
    let secondaryPosX = new ScbNumber(this.dividerParam.getSecPosXPct() * screenProperty.width);
    let secondaryPosY = new ScbNumber(this.dividerParam.getSecPosYPct() * screenProperty.height);
    this.dividerParam.setBorderRadius(true);
    if (isPrimaryToOneStep) {
      let secondaryWidth = new ScbNumber(this.dividerParam.secSizePct * screenProperty.height);
      this.secondarySession?.updateRect(secondaryPosX, secondaryPosY, secondaryWidth, width, changeReason);
      this.dividerParam.secondary.rotateX = 0;
      this.dividerParam.secondary.rotateY = 0;
      this.dividerParam.secondary.rotateZ = 1;
      this.dividerParam.secondary.rotateAngle = -currentRotation;
    } else {
      let primaryWidth = new ScbNumber(this.dividerParam.primSizePct * screenProperty.height);
      this.primarySession?.updateRect(primaryPosX, primaryPosY, primaryWidth, width, changeReason);
      this.dividerParam.primary.rotateX = 0;
      this.dividerParam.primary.rotateY = 0;
      this.dividerParam.primary.rotateZ = 1;
      this.dividerParam.primary.rotateAngle = -currentRotation;
    }
  }

  /**
   * update session rect for split
   *
   * @param screenProperty
   * @param updateDividerParam
   * @param reason
   */
  public updateSessionRectForSplit(
        screenProperty: SCBScreenProperty,
        updateDividerParam: boolean = true,
        reason?: sceneSessionManager.SessionSizeChangeReason,
        subReason?: sceneSessionManager.SessionSizeChangeReason): void {
    if (!this.isSplit) {
      return;
    }
    let changeReason = reason ? reason : sceneSessionManager.SessionSizeChangeReason.RESIZE;
    let subChangeReason = subReason ? subReason : changeReason;
    log.showInfo(`updateSessionRectForSplit raw reason: ${reason} subReason: ${subReason} correction: ${changeReason}`);
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(this.screenProperty.screenId);
    if (!this.isActive && SCBScreenSessionManager.getInstance().isSecondaryFoldablePhoneExpandStatus()) {
      this.dividerParam.setIsVertical(this.isVertical(this.currentRotation));
    } else if (screenSession && screenSession.isRotateScreenPolicy()) {
      this.dividerParam.setIsVertical(screenSession.scbScreenProperty.isScreenVertical());
    } else {
      this.dividerParam.setIsVertical(this.isVertical(screenProperty.rotation));
    }
    if (updateDividerParam) {
        this.dividerParam.updateDividerParam(screenProperty);
    }
    if (this.isOneStepSplit() || this.splitParam.getLifeCycle() === SplitLifeCycle.EXIT_SPLIT_TO_ONESTEP) {
      let oneStepTrans: number = this.dividerParam.calOneStepDefaultTrans(screenProperty); // in vp
      this.dividerParam.setOneStepDefaultPos(oneStepTrans, screenProperty);
      if (this.dividerParam.isUpDownSplit()) {
        this.primarySession?.updateCurRectForOneStepSplit(screenProperty, true, vp2px(oneStepTrans));
      } else {
        this.primarySession?.updateCurRectForOneStepSplit(screenProperty, false, vp2px(oneStepTrans));
      }
      return;
    }

    let primaryRect = this.primarySession?.currRect.copy();
    let secondaryRect = this.secondarySession?.currRect.copy();
    this.updateRectForSplit(screenProperty, changeReason);
  }

  /**
   * update session rect only with out change the stack size out of the session
   * @param screenProperty
   * @param primRect
   * @param secRect
   */
  public updateSessionRectForSplitDirectly(
    screenProperty: SCBScreenProperty,
    primRect: SCBSessionRect, secRect: SCBSessionRect): void {
    let changeReason = sceneSessionManager.SessionSizeChangeReason.RESIZE;
    let primaryRect = this.primarySession?.currRect.copy();
    let secondaryRect = this.secondarySession?.currRect.copy();
    this.fixSecRectMinError(secRect, screenProperty);
    this.primarySession?.updateRect(primRect.left, primRect.top, primRect.width, primRect.height, changeReason);
    this.secondarySession?.updateRect(secRect.left, secRect.top, secRect.width, secRect.height, changeReason);
    this.updateSubSessionRectForSplit(screenProperty, primaryRect, secondaryRect, changeReason);
  }

  private updateRectForSplit(screenProperty: SCBScreenProperty,
    changeReason?: sceneSessionManager.SessionSizeChangeReason): void {
    let primRect = new SCBSessionRect();
    let secRect = new SCBSessionRect();
    let primaryPosX = this.dividerParam.getPriPosXPct() * screenProperty.width +
      vp2px(this.dividerParam.primary.translateX);
    let primaryPosY = this.dividerParam.getPriPosYPct() * screenProperty.height +
      vp2px(this.dividerParam.primary.translateY);
    let secondaryPosX = this.dividerParam.getSecPosXPct() * screenProperty.width +
      vp2px(this.dividerParam.secondary.translateX);
    let secondaryPosY = this.dividerParam.getSecPosYPct() * screenProperty.height +
      vp2px(this.dividerParam.secondary.translateY);
    log.showInfo(`updateSessionRectForSplit primary: [${primaryPosX}, ${primaryPosY}]` +
      `size: ${this.dividerParam.primSizePct}, secondary: [${secondaryPosX}, ${secondaryPosY}]` +
      `size: ${this.dividerParam.secSizePct}, rotation:${screenProperty.rotation}`);
    if (this.dividerParam.isUpDownSplit()) {
      let primaryHeight = this.dividerParam.primSizePct * screenProperty.height;
      let secondaryHeight = this.dividerParam.secSizePct * screenProperty.height;
      primRect.setRectNum(primaryPosX, primaryPosY, screenProperty.width, primaryHeight);
      secRect.setRectNum(secondaryPosX, secondaryPosY, screenProperty.width, secondaryHeight);
      let rect = this.dividerParam.splitOrderIsNotReverse ? secRect : primRect;
      this.fixSecRectMinError(rect, screenProperty);
    } else {
      let primaryWidth = this.dividerParam.primSizePct * screenProperty.width;
      let secondaryWidth = this.dividerParam.secSizePct * screenProperty.width;
      let height = screenProperty.height * parseFloat(this.dividerParam.primary.height) / DividerStyleConstants.PERCENT;
      primRect.setRectNum(primaryPosX, primaryPosY, primaryWidth, height);
      secRect.setRectNum(secondaryPosX, secondaryPosY, secondaryWidth, height);
    }
    this.primarySession?.updateRect(primRect.left, primRect.top, primRect.width, primRect.height, changeReason, true);
    this.secondarySession?.updateRect(secRect.left, secRect.top, secRect.width, secRect.height, changeReason, true);
  }

  private fixSecRectMinError(secRect: SCBSessionRect, screenProperty: SCBScreenProperty): void {
    secRect.height.setNumber(Math.round(secRect.height.getPx()));
    if (Math.abs(secRect.height.getPx() + secRect.top.getPx() - screenProperty.height) <= 1) {
      secRect.top.setNumber(screenProperty.height - secRect.height.getPx());
    }
  }

  /**
   * update subsession and dialog rect according to the main window rect
   */
  private updateSubSessionRectForSplit(screenProperty: SCBScreenProperty,
    primaryRect: SCBSessionRect, secondaryRect: SCBSessionRect,
    reason?: sceneSessionManager.SessionSizeChangeReason): void {
    this.primarySession?.subSessionList.forEach((item) => {
      if (item.currRect.equalsOfSize(primaryRect)) {
        item.setRequestedRect(this.primarySession?.currRect);
      }
      item.updateSubRectForSplit(screenProperty, this.primarySession.currRect, reason);
    });
    this.primarySession?.dialogSessionList.forEach((item) => {
      if (item.currRect.equalsOfSize(primaryRect)) {
        item.setRequestedRect(this.primarySession?.currRect);
      }
      item.updateSubRectForSplit(screenProperty, this.primarySession.currRect, reason);
    });
    this.secondarySession?.subSessionList.forEach((item) => {
      if (item.currRect.equalsOfSize(secondaryRect)) {
        item.setRequestedRect(this.secondarySession?.currRect);
      }
      item.updateSubRectForSplit(screenProperty, this.secondarySession.currRect, reason);
    });
    this.secondarySession?.dialogSessionList.forEach((item) => {
      if (item.currRect.equalsOfSize(secondaryRect)) {
        item.setRequestedRect(this.secondarySession?.currRect);
      }
      item.updateSubRectForSplit(screenProperty, this.secondarySession.currRect, reason);
    });
  }

  /**
   * update subsession and dialog rect according to the main window rect
   */
  public updateSubSessionRectForFloat(rect: SCBSessionRect): void {
    this.primarySession?.subSessionList.forEach((item) => {
      if (item.currRect.equalsOfSize(rect)) {
        item.setRequestedRect(this.primarySession?.currRect);
      }
      item.updateSubRectForFloat(this.screenProperty, this.primarySession.currRect);
    });
    this.primarySession?.dialogSessionList.forEach((item) => {
      if (item.currRect.equalsOfSize(rect)) {
        item.setRequestedRect(this.primarySession?.currRect);
      }
      item.updateSubRectForFloat(this.screenProperty, this.primarySession.currRect);
    });
  }

  /**
   *
   * @param container
   * @param rect px
   * @param reason
   */
  public updateRectForFloat(
    rect: SCBSessionRect,
    reason?: sceneSessionManager.SessionSizeChangeReason): void {
    let correctR = reason ? reason : sceneSessionManager.SessionSizeChangeReason.RESIZE;
    this.needRenderPos.setPosXWithDfx(rect.left.getVp(), TAG, 'updateContainerRect');
    this.needRenderPos.setPosYWithDfx(rect.top.getVp(), TAG, 'updateContainerRect');
    this.width = rect.width;
    this.height = rect.height;
    this.needRenderClip.setClipWidth(rect.width);
    this.needRenderClip.setClipHeight(rect.height);
    let session = this.mainSession;
    let primaryRect = session?.currRect.copy();
    session.updateRect(rect.left, rect.top, rect.width, rect.height, correctR);
    this.updateSubSessionRectForFloat(primaryRect);
  }

  /**
   *
   * @param container
   * @param scale
   * @param updateWindowScale
   */
  public updateScaleForFloat(scale: number, updateWindowScale: boolean = true): void {
    this.floatingParam.setScale(scale);
    let session = this.mainSession;
    session.updateFloatingScale(scale, updateWindowScale);
  }

  /**
   * Set whether need sync session rect
   * @param needSync
   */
  public setNeedSyncSessionRect(isNeed: boolean): void {
    if (this.primarySession) {
      this.primarySession.setNeedSyncSessionRect(isNeed);
    }

    if (this.secondarySession) {
      this.secondarySession.setNeedSyncSessionRect(isNeed);
    }
  }

  /**
   * Obtains sessions in full-screen or primary mode.
   *
   * @returns Session in primary or full-screen mode or primarySession
   */
  public get mainSession(): SCBSceneSession {
    if (!!this.primarySession && this.primarySession.isInSceneMode(SCBSceneMode.FULLSCREEN, SCBSceneMode.PRIMARY)) {
      return this.primarySession;
    } else if (!!this.secondarySession && this.secondarySession.isInSceneMode(SCBSceneMode.FULLSCREEN, SCBSceneMode.PRIMARY)) {
      return this.secondarySession;
    }
    return this.primarySession;
  }

  /**
   * Obtains active sessions in full-screen or primary mode.
   *
   * @returns active Session in primary or full-screen mode or primarySession
   */
  public get mainSessionActive(): SCBSceneSession {
    if (!!this.primarySession && this.primarySession.isInSceneMode(SCBSceneMode.FULLSCREEN, SCBSceneMode.PRIMARY) &&
    this.primarySession.isActive) {
      return this.primarySession;
    } else if (!!this.secondarySession && this.secondarySession.isActive &&
    this.secondarySession.isInSceneMode(SCBSceneMode.FULLSCREEN, SCBSceneMode.PRIMARY)) {
      return this.secondarySession;
    }
    return this.primarySession;
  }

  /**
   * Check whether any session is activated.
   *
   * @returns true if one of the sessions is active
   */
  public haveActiveSession(): boolean {
    for (let ele of this.midSceneMap.values()) {
      if (ele.isActive) {
        return true;
      }
    }
    if (!!this.primarySession && this.primarySession?.isActive) {
      return true;
    }
    if (!!this.secondarySession && this.secondarySession?.isActive) {
      return true;
    }
    return false;
  }

  /**
   * register interactive state change callback
   *
   * @param { Function } callback
   */
  public registerInteractiveStateChangeCallback(callback: (state: boolean) => void): void {
    this.interactiveStateChangeCallback = callback;
  }

  /**
   * unregister interactive state change callback
   */
  public unregisterInteractiveStateChangeCallback(): void {
    this.interactiveStateChangeCallback = undefined;
  }

  /**
   * notify interactive state change
   *
   * @param { Boolean } state
   */
  public notifyInteractiveStateChange(state: boolean): void {
    if (!!this.interactiveStateChangeCallback) {
      this.interactiveStateChangeCallback(state);
    }
    if (!!this.primarySession) {
      this.primarySession.notifyInteractiveStateChange(state);
    }
    if (!!this.secondarySession) {
      this.secondarySession.notifyInteractiveStateChange(state);
    }
    for (let ele of this.midSceneMap) {
      ele[1].notifyInteractiveStateChange(state);
    }
  }

  /**
   * change state
   *
   * @param { SCBSceneContainerState } state
   */
  public changeState(state: SCBSceneContainerState): void {
    log.showInfo(`changeState ${this.getName()} from: ${this.sessionDataInner.state}, to: ${state}`);
    let previousState: SCBSceneContainerState = this.sessionDataInner.state;
    this.sessionDataInner.state = state;
    this.notifyContainerStateChange(state, previousState);
  }

  /**
   * get state
   *
   * @returns { SCBSceneContainerState }
   */
  public getState(): SCBSceneContainerState {
    return this.sessionDataInner.state;
  }

  /**
   * get skipRotation
   *
   * @returns { boolean }
   */
  public getSkipRotation(): boolean {
    return this.sessionDataInner.skipRotation;
  }


  /**
   * set skipRotation
   *
   */
  public setSkipRotation(isSkipRotation: boolean): void {
    this.sessionDataInner.skipRotation = isSkipRotation;
  }

  /**
   * register container state change callback
   *
   * @param { Function } callback
   */
  public registerContainerStateChangeCallback(callback:
        (previousState: SCBSceneContainerState, curState: SCBSceneContainerState) => void): void {
    if (!callback) {
      return;
    }
    this.stateChangeCallbacks.push(callback);
  }

  /**
   * unregister container state change callback
   *
   * @param { Function } callback
   */
  public unregisterContainerStateChangeCallback(callback:
        (previousState: SCBSceneContainerState, curState: SCBSceneContainerState) => void): void {
    let index = this.stateChangeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.stateChangeCallbacks.splice(index, 1);
    }
  }

  private notifyContainerStateChange(curState: SCBSceneContainerState,
        previousState: SCBSceneContainerState = SCBSceneContainerState.UNDEFINED): void {
    for (let callback of this.stateChangeCallbacks) {
      if (callback) {
        callback(previousState, curState);
      }
    }
  }

  public setUpdateTitleViewCallback(callback: Function): void {
    this.updateTitleViewCallback = callback;
  }

  public updateRecentTitleView(): void {
    if (this.updateTitleViewCallback) {
      this.updateTitleViewCallback();
    }
  }

  /**
   * add ref count
   */
  public addRefCount(): void {
    this.sessionDataInner.refCount++;
  }

  /**
   * decrease ref count
   */
  public decRefCount(): void {
    this.sessionDataInner.refCount--;
  }

  /**
   * get ref count
   */
  public getRefCount(): number {
    return this.sessionDataInner.refCount;
  }

  /**
   * unregister all callbacks
   */
  public unRegisterAll(): void {
    if (this.getRefCount() !== 0) {
      log.showWarn(`unRegisterAll abort, id:${this.primarySession?.session?.persistentId}, refCount: ${this.getRefCount()}`);
      return;
    }
    this.containerRotationChangeCallback = null;
    this.containerActiveModeChangeCallback = null;
    this.containerFoldChangeCallback = null;
    this.interactiveStateChangeCallback = undefined;
    this.containerFoldChangeForUltraScreenCallback = null;
  }

  public getSceneSessionByPersistentId(persistentId: number): SCBSceneSession | undefined {
    return this.midSceneMap.get(persistentId);
  }

  /**
   * whether has session with persistent id
   *
   * @param { Number } persistentId
   * @return { Boolean }
   */
  public haveSessionWithPersistentId(persistentId: number, checkPrimarySession: boolean = true,
                                                          checkSecondarySession: boolean = true): boolean {
    if (this.midSceneMap.has(persistentId)) {
      return true;
    }

    if ((checkPrimarySession && this.primarySession?.session.persistentId === persistentId) ||
      (checkSecondarySession && this.secondarySession?.session.persistentId === persistentId)) {
      log.showInfo('[SCBKeyboard] scene session, persistentId: ' + persistentId);
      return true;
    }

    if (checkPrimarySession && this.primarySession &&
      this.isSessionContainedInList(persistentId, this.primarySession.subSessionList)) {
      WinLog.showInfo(WinLogDomain.WMS_KEYBOARD, 'primary dialog session, persistentId: ' + persistentId);
      return true;
    }

    if (checkPrimarySession && this.primarySession &&
      this.isSessionContainedInList(persistentId, this.primarySession.dialogSessionList)) {
      WinLog.showInfo(WinLogDomain.WMS_KEYBOARD, 'primary sub session, persistentId: ' + persistentId);
      return true;
    }

    if (checkSecondarySession && this.secondarySession &&
      this.isSessionContainedInList(persistentId, this.secondarySession.subSessionList)) {
      WinLog.showInfo(WinLogDomain.WMS_KEYBOARD, 'secondary sub session, persistentId: ' + persistentId);
      return true;
    }

    if (checkSecondarySession && this.secondarySession &&
      this.isSessionContainedInList(persistentId, this.secondarySession.dialogSessionList)) {
      WinLog.showInfo(WinLogDomain.WMS_KEYBOARD, 'secondary dialog session, persistentId: ' + persistentId);
      return true;
    }

    return this.isMidSceneMap(persistentId);
  }

  private isMidSceneMap(persistentId: number): boolean {
    for (let sceneSession of this.midSceneMap.values()) {
      if (sceneSession && this.isSessionContainedInList(persistentId, sceneSession.subSessionList)) {
        WinLog.showInfo(WinLogDomain.WMS_KEYBOARD, 'midSceneMap sub session, persistentId: ' + persistentId);
        return true;
      }

      if (sceneSession && this.isSessionContainedInList(persistentId, sceneSession.dialogSessionList)) {
        WinLog.showInfo(WinLogDomain.WMS_KEYBOARD, 'midSceneMap dialog session, persistentId: ' + persistentId);
        return true;
      }
    }
    return false;
  }

  private isSessionContainedInList(persistentId: number, subSessionList: SCBSpecificSceneSessionList): boolean {
    for (let item of subSessionList) {
      if (item.session && item.session.persistentId === persistentId) {
        return true;
      }
      if (this.isSessionContainedInList(persistentId, item.subSessionList)) {
        return true;
      }
    }
    return false;
  }

  /**
   * change split view layout in fold
   *
   * @param { SCBScreenProperty } screenProperty
   */
  public rotateSplitInFoldIfNeeded(screenProperty: SCBScreenProperty): void {
    if (!this.primarySession || !this.secondarySession) {
      return;
    }
    let originStyle = this.dividerParam.getIsVertical();
    let newStyle = this.isVertical(screenProperty.rotation);
    this.dividerParam.setIsVertical(newStyle);
    log.showInfo(`[SCBSplit] rotate split in fold, style change ori: ${originStyle} target: ${newStyle}`);
    this.dividerParam.updateDividerParamWithRatio(screenProperty);
  }

  /**
   * Has fixed multi window orientation session or not
   *
   * @return { Boolean }
   */
  public hasFixedMultiWindowOrientationSession(): boolean {
    return SCBSceneUtils.isFixedMultiWindowOrientation(this.primarySession) ||
      SCBSceneUtils.isFixedMultiWindowOrientation(this.secondarySession);
  }

  /**
   * get need max sceneSession when expand to fold and this is has game session
   *
   * @return { SCBSceneSession }
   */
  public getNeedMaxSceneSession(): SCBSceneSession {
    if (this.secondarySession.getFocused()) {
      return this.secondarySession;
    } else if (this.primarySession.getFocused()) {
      return this.primarySession;
    } else if (this.dividerParam?.splitOrderIsNotReverse) {
      return this.primarySession;
    } else {
      return this.secondarySession;
    }
  }

  /**
   * get need exit sceneSession when expand to fold and this is has game session
   *
   * @return { SCBSceneSession }
   */
  public getNeedExitSceneSession(): SCBSceneSession {
    if (this.secondarySession.getFocused()) {
      return this.primarySession;
    } else if (this.primarySession.getFocused()) {
      return this.secondarySession;
    } else if (this.dividerParam?.splitOrderIsNotReverse) {
      return this.secondarySession;
    } else {
      return this.primarySession;
    }
  }

  /**
   * this is has Landscape game session or not
   *
   * @return { Boolean }
   */
  public hasLandscapeGameSession(): boolean {
    for (let ele of this.midSceneMap.values()) {
      if (ele.preferMultiWindowOrientation === PreferMultiWindowOrientation.LANDSCAPE) {
        return true;
      }
    }
    if (this.primarySession !== null && this.primarySession !== undefined &&
      this.primarySession.preferMultiWindowOrientation === PreferMultiWindowOrientation.LANDSCAPE) {
      return true;
    }
    if (this.secondarySession !== null && this.secondarySession !== undefined &&
      this.secondarySession.preferMultiWindowOrientation === PreferMultiWindowOrientation.LANDSCAPE) {
      return true;
    }
    return false;
  }

  /**
   * Get last recently used timestamp
   *
   * @returns { number } timestamp
   */
  public getLastUsedTimestamp(): number {
    return this.sessionDataInner.lastUsedTimestamp;
  }

  /**
   * Update last recently used timestamp
   *
   * @param { number } timestamp
   */
  public updateLastUsedTimestamp(timestamp: number): void {
    log.showDebug('updateLastUsedTimestamp primarySession id:%{public}d, secondarySession id:%{public}d',
      this.primarySession?.session?.persistentId, this.secondarySession?.session?.persistentId);
    this.sessionDataInner.lastUsedTimestamp = timestamp;
  }

  /**
   * get _isActive
   *
   * @returns { Boolean } _isActive
   */
  public get isActive(): boolean {
    return this._isActive;
  }

  public isForeground(): boolean {
    return this._isActive && !this.primarySession?.isMinimizing;
  }

  public isBackground(): boolean {
    return !this.isForeground();
  }

  /**
   * Obtains all persistentId arrays of a container.
   * The common container uses the
   * main session + sub-session + diglog session + main session
   * + sub-session + diglog session,
   * The split-screen  container uses the
   * main session + main session + diver session +
   * + sub-session + diglog session + sub-session + diglog session
   *
   * @returns persistentIds
   */
  public getSceneSessionIdList(): number[] {
    if (this.isSplit) {
      return this.BuildSplitScreenContainerIDList();
    }
    return this.BuildContainerIDListNotSplitScreen();
  }

  private BuildSplitScreenContainerIDList(): number[] {
    const persistentIds = new Array<number>();
    const higherSession = this.dividerParam.isPrimaryRaise ? this.primarySession : this.secondarySession;
    const lowerSession = this.dividerParam.isPrimaryRaise ? this.secondarySession : this.primarySession;

    if (lowerSession) {
      persistentIds.push(lowerSession.sceneInfo.persistentId);
    }
    if (higherSession) {
      persistentIds.push(higherSession.sceneInfo.persistentId);
    }
    if (this.dividerSession) {
      persistentIds.push(this.dividerSession.session.persistentId);
    }
    if (this.dividerButtonSession) {
      persistentIds.push(this.dividerButtonSession.session.persistentId);
    }

    this.pushSessionId(persistentIds, lowerSession);
    if (lowerSession?.useControlSession) {
      persistentIds.push(lowerSession.useControlSession.session.persistentId);
    }
    this.pushSessionId(persistentIds, higherSession);
    if (higherSession?.useControlSession) {
      persistentIds.push(higherSession.useControlSession.session.persistentId);
    }
    return persistentIds;
  }

  private BuildContainerIDListNotSplitScreen(): number[] {
    let persistentIds = new Array<number>();
    if (this.primarySession) {
      persistentIds.push(this.primarySession.sceneInfo.persistentId);
      this.pushSessionId(persistentIds, this.primarySession);
      if (this.primarySession.useControlSession) {
        persistentIds.push(this.primarySession.useControlSession.session.persistentId);
      }
    }
    if (this.secondarySession) {
      persistentIds.push(this.secondarySession.sceneInfo.persistentId);
      this.pushSessionId(persistentIds, this.secondarySession);
      if (this.secondarySession.useControlSession) {
        persistentIds.push(this.secondarySession.useControlSession.session.persistentId);
      }
    }
    return persistentIds;
  }

  private pushSessionId(persistentIds: number[], session: SCBSceneSession): void {
    if (session) {
      if (session?.subSessionList) {
        this.pushSubSessionId(persistentIds, session?.subSessionList);
      }
      if (session?.dialogSessionList) {
        this.pushDiglogSessionId(persistentIds, session);
      }
    }
  }

  private pushSubSessionId(array: number[], subSessionList: SCBSpecificSceneSessionList): void {
    if (subSessionList === null) {
      return;
    }
    for (let i = 0; i < subSessionList.length; i++) {
      let session = subSessionList[i];
      array.push(session.session.persistentId);
      if (session?.subSessionList) {
        let subSessionList = session?.subSessionList;
        subSessionList.forEach((subSession) => {
          array.push(subSession.session.persistentId);
          this.pushSubSessionId(array, subSession.subSessionList);
        });
      } else {
        log.showInfo(session.session.persistentId + 'subSessionList is null');
      }
    }
  }

  private pushDiglogSessionId(persistentIds: number[], session: SCBSceneSession): void {
    let dialogSessionList = session?.dialogSessionList;
    dialogSessionList.forEach((dialogSession) => {
      persistentIds.push(dialogSession.session.persistentId);
      this.pushSubSessionId(persistentIds, dialogSession.subSessionList);
    });
  }

  public resetNeedRenderPosByTranslate(): void {
    this.needRenderTranslate.setTranslateXWithDfx(this.needRenderTranslate.translateX + this.needRenderPos.posX, TAG,
      'resetNeedRenderPosByTranslate');
    this.needRenderPos.setPosXWithDfx(0, TAG, 'resetNeedRenderPosByTranslate');
    this.needRenderTranslate.setTranslateYWithDfx(this.needRenderTranslate.translateY + this.needRenderPos.posY, TAG,
      'resetNeedRenderPosByTranslate');
    this.needRenderPos.setPosYWithDfx(0, TAG, 'resetNeedRenderPosByTranslate');
  }

  public getSceneContainerWidth(): number {
    if (this.primarySession === null) {
      return 0;
    }
    let sceneWidth: number = this.primarySession.currRect.width.getVp() as number;
    if (this.isSplit && this.secondarySession !== null && !this.dividerParam.isExpandUpDownSplit()) {
      sceneWidth += SCBConstants.DIVIDER_WIDTH;
      sceneWidth += this.secondarySession.currRect.width.getVp() as number;
    }
    return sceneWidth;
  }

  public getSceneContainerHeight(): number {
    if (this.primarySession === null) {
      return 0;
    }
    let sceneHeight: number = this.primarySession.currRect.height.getVp();
    if (this.isSplit && this.secondarySession !== null && this.dividerParam.isExpandUpDownSplit()) {
      sceneHeight += DividerStyleConstants.DIVIDER_WIDTH_FOLD_SCENE;
      sceneHeight += this.secondarySession.currRect.height.getVp();
    }
    return sceneHeight;
  }

  public getSceneContainerPosition(): Position {
    let sceneSession = this.getMainSceneSession();
    if (sceneSession) {
      return {
        x: sceneSession.currRect.left.getVp(),
        y: sceneSession.currRect.top.getVp()
      }
    }
    return {
      x: 0,
      y: 0
    }
  }

  public getSceneContainerCenterX(): number {
    let sceneLeft: number = 0;
    let sceneSession = this.getMainSceneSession();
    if (sceneSession) {
      sceneLeft = sceneSession.currRect.left.getVp() as number;
    }
    const sceneWidth: number = this.getSceneContainerWidth();
    return sceneLeft + sceneWidth / 2;
  }

  public getSceneContainerCenterY(): number {
    const sceneLeft: number = this.getFirstSceneSession().currRect.top.getVp() as number;
    const sceneHeight: number = this.getSceneContainerHeight();
    return sceneLeft + sceneHeight / 2;
  }

  public getMainSceneSession(): SCBSceneSession | null {
    let sceneSession = this.primarySession;
    if (this.isSplit && this.secondarySession !== null &&
      this.secondarySession.sceneInfo.windowMode === SCBSceneMode.PRIMARY) {
      sceneSession = this.secondarySession;
    }
    return sceneSession;
  }

  public getPrimaryHeight(): number {
    if ((this.isSplitPrimaryMode() || !this.isSplit) && this.primarySession) {
      return this.primarySession.currRect.height.getVp();
    }
    if (this.isSplit && this.secondarySession) {
      return this.secondarySession.currRect.height.getVp();
    }
    return this.height.getVp();
  }

  public getNeedRenderDragHotAreaAnimConfig(screenId: number): NeedRenderDragHotAreaAnimConfig {
    let dragHotAreaAnimConfig = this.needRenderDragHotAreaAnimConfigMap.get(screenId);
    if (!dragHotAreaAnimConfig) {
      dragHotAreaAnimConfig = new NeedRenderDragHotAreaAnimConfig();
      this.needRenderDragHotAreaAnimConfigMap.set(screenId, dragHotAreaAnimConfig);
    }
    return dragHotAreaAnimConfig;
  }

  public isWindowEquals(): boolean {
    if (!this.lastRecentStartBeforeRect || !this.primarySession?.currRect) {
      return false;
    }
    return this.currentRotation === this.lastRecentStartBeforeRotation &&
      this.primarySession?.currRect.width === this.lastRecentStartBeforeRect?.width &&
      this.primarySession?.currRect.height === this.lastRecentStartBeforeRect?.height &&
      this.getContainerWindowMode() === SCBSceneMode.FULLSCREEN;
  }

  /**
   * get scene session by id
   * @param id
   * @returns SCBSceneSession
   */
  public getSceneSessionById(id: number): SCBSceneSession | null {
    const primaryItem = this.primarySessionList.find((item) => item.session.persistentId === id);
    if (primaryItem) {
      return primaryItem;
    }
    const secondaryItem = this.secondarySessionList.find((item) => item.session.persistentId === id);
    if (secondaryItem) {
      return secondaryItem;
    }
    WinLog.showWarn(WinLogDomain.WMS_LIFE, 'not find any SceneSession match id to be got');
    return this.midSceneMap.get(id) ?? null;
  }

  /**
   * get session item by info
   * @param info SCBSceneInfo
   * @returns SCBSceneSession
   */
  public getSceneSessionByInfo(info: SCBSceneInfo): SCBSceneSession | null {
    if (info == null) {
      WinLog.showWarn(WinLogDomain.WMS_LIFE, `getSceneSessionByInfo invalid info`);
      return null;
    }
    const primaryItem = this.primarySessionList.find((item) => item.sceneInfo?.equalTo(info));
    if (primaryItem) {
      return primaryItem;
    }
    const secondaryItem = this.secondarySessionList.find((item) => item.sceneInfo?.equalTo(info));
    if (secondaryItem) {
      return secondaryItem;
    }
    WinLog.showError(WinLogDomain.WMS_LIFE, 'error items in container session.');
    return null;
  }
}

export { CompanionIconInfo };
