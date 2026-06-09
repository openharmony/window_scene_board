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

import type { SCBSceneContainerSession } from '../session/SCBSceneContainerSession';
import { SCBBackgroundBlurSession, SCBScenePanelSession } from './SCBScenePanelSession';
import type { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import {
  SCBSceneContainerSessionArray,
  SCBCloseContainerArray,
  CloseContainerParam
} from '../session/SCBSceneContainerSession';
import { CommonUtils } from '@ohos/basicutils';
import { SCBSceneSessionManager } from '../session/SCBSceneSessionManager';
import { SCBConstants } from '@ohos/commonconstants';
import { ArrayUtils } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RecentViewParam } from '../../recent/RecentViewParam';
import { SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBSceneInfo, SCBSceneSession, SCBSpecificSession, SCBSceneMissionManager } from '../../TsIndex';
import { INVALID_PERSISTENT_ID } from '../session/SCBSceneSession';

const TAG = 'SCBSPM';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);


type RaiseSceneTopListener = (containerSession: SCBSceneContainerSession) => void;
export interface SCBPanelParam {
  onRaiseSceneToTop?: RaiseSceneTopListener;
}

/**
 * SCBScenePanel status Manager
 */
export class SCBScenePanelManager {
  private screenProperty: SCBScreenProperty;
  private viewParam: RecentViewParam;
  private containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  private containerListForTheView: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  private containerSessionListNotShowRecent: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  private closeContainerList : SCBCloseContainerArray = new SCBCloseContainerArray();
  private floatingSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  private panelSession = new SCBScenePanelSession();
  private backgroundBlurSession = new SCBBackgroundBlurSession();
  private panelParam?: SCBPanelParam;
  private blurComponentTransitionCount: number = 0;
  private isForegroundBlurActive: boolean = false;

  /**
   * Obtains a single instance of SCBScenePanelManager.
   *
   * @param { SCBScreenProperty } screenProperty
   * @returns { SCBScenePanelManager } Returns a singleton instance of SCBScenePanelManager
   */
  public static getInstance(screenProperty?: SCBScreenProperty): SCBScenePanelManager {
    let scenePanelManager: SCBScenePanelManager = SingletonHelper.getInstance(SCBScenePanelManager, TAG);
    // 保持单例模式，成员变量不能重复初始化
    if (screenProperty && !scenePanelManager.screenProperty) {
      scenePanelManager.screenProperty = screenProperty;
      scenePanelManager.viewParam = new RecentViewParam(screenProperty);
    }
    return scenePanelManager;
  }

  /**
   * Initialization method
   *
   * @param { SCBPanelParam } panelParam
   */
  public init(panelParam?: SCBPanelParam): void {
    this.panelParam = panelParam;
  }

  public getSceneContainerSessionAndSceneSessionByPersistentId(persistentId: number):
    [SCBSceneContainerSession | null, SCBSceneSession | null] {
    let containerSession: SCBSceneContainerSession | null =
      this.getTotalSessionListIncludeNotShowRecent().findByPersistentId(persistentId);
    let sceneSession: SCBSceneSession | null = null;
    if (containerSession?.primarySession?.session.persistentId === persistentId) {
      sceneSession = containerSession.primarySession;
    } else if (containerSession?.secondarySession?.session.persistentId === persistentId) {
      sceneSession = containerSession.secondarySession;
    }
    return [containerSession, sceneSession];
  }

  /**
   * obtaining screen attributes
   *
   * @returns { SCBScreenProperty } Returns the screen properties object
   */
  public getScreenProperty(): SCBScreenProperty {
    return this.screenProperty;
  }

  /**
   * Obtaining the Latest View Parameters
   *
   * @returns { RecentViewParam } Returns the latest recent view parameter
   */
  public getViewParam(): RecentViewParam {
    return this.viewParam;
  }

  /**
   * Method to get a panel session
   *
   * @returns { SCBScenePanelSession } Return to the current panel session
   */
  public getPanelSession(): SCBScenePanelSession {
    return this.panelSession;
  }

  public getBackgroundBlurSession(): SCBBackgroundBlurSession {
    return this.backgroundBlurSession;
  }
  /**
   * Obtaining the Scenario Container Session List
   *
   * @returns { SCBSceneContainerSessionArray } Scenario Container Session List
   */
  public getSceneContainerSessionList(): SCBSceneContainerSessionArray {
    return this.containerSessionList;
  }

  /**
   * Obtaining the Close Container Session List for clearAll
   *
   * @returns { SCBCloseContainerArray } Close Container Session List
   */
  public getCloseContainerSessionList(): SCBCloseContainerArray {
    return this.closeContainerList;
  }

  /**
   * Get the list of midScene container session
   *
   * @returns{ Array<SCBSceneContainerSession> } Returns the list of in midScene containers
   */
  public getMidSceneContainerSessionList(): Array<SCBSceneContainerSession> {
    return this.containerSessionList.getMidSceneSessionList();
  }

  /**
   * get the Scenario Container Session List for view
   *
   * @returns { SCBSceneContainerSessionArray } Scenario Container Session List
   */
  public getSceneContainerSessionListForView(): SCBSceneContainerSessionArray {
      return this.containerSessionList;
  }

  /**
   * set the Scenario Container Session List for view
   *
   * @returns { SCBSceneContainerSessionArray } Scenario Container Session List
   */
  public setSceneContainerSessionListForView(list: SCBSceneContainerSessionArray): void {
      return;
  }

  /**
   * Obtaining the Scenario Floating Session List for view
   *
   * @returns { SCBSceneContainerSessionArray } Scenario Floating Session List
   */
  public getFloatingSessionListForView(): SCBSceneContainerSessionArray {
      return this.floatingSessionList;
  }

  public getFloatingSessionList(): SCBSceneContainerSessionArray {
    return this.floatingSessionList;
  }

  /**
   * Get an array of scene container sessions that do not show in the recent list
   *
   * @returns { SCBSceneContainerSessionArray } An array of scene container sessions that do not show in the recent list
   */
  public getNotShowRecentList(): SCBSceneContainerSessionArray {
    return this.containerSessionListNotShowRecent;
  }
  
  public getTotalSessionListIncludeNotShowRecent(): SCBSceneContainerSessionArray {
    return new SCBSceneContainerSessionArray(...this.containerSessionList, ...this.floatingSessionList,
      ...this.containerSessionListNotShowRecent);
  }

  public getTotalSessionList(): SCBSceneContainerSessionArray {
    let containerList = this.getSceneContainerSessionList();
    return new SCBSceneContainerSessionArray(...containerList, ...this.floatingSessionList);
  }

  /**
   * Clear the scenario container session list.
   */
  public clearSceneContainerSessionList(): void {
    ArrayUtils.clearArr(this.containerSessionList);
  }

  public addFloatContainerSession(session: SCBSceneContainerSession): void {
    let success = this.floatingSessionList.add(session);
    if (success) {
      log.showInfo('Add float container session, id: ' + session.containerId);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
  }

  /**
   * Add Scene Container Session
   *
   * @param { SCBSceneContainerSession } session - Scene Container Session
   */
  public addSceneContainerSession(session: SCBSceneContainerSession): void {
    let success = this.containerSessionList.add(session);
    if (success) {
      log.showInfo('Add scene container session, id: ' + session.containerId);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
  }

  /**
   * Add Scene Container Session and remove from notShow list
   *
   * @param { SCBSceneContainerSession } session - Scene Container Session
   */
  public addSceneContainerSessionAndRemoveNotShow(session: SCBSceneContainerSession): void {
    this.removeNotShowRecentSession(session);
    this.addSceneContainerSession(session);
    SCBSceneMissionManager.getInstance().notifySessionRequestActivation(session);
  }

  /**
   * Adds a scene container session at the specified index location
   *
   * @param { Number } index
   * @param { SCBSceneContainerSession } session
   */
  public addSceneContainerSessionByIndex(index: number, session: SCBSceneContainerSession): void {
    let success = this.containerSessionList.splice(index, 0, session);
    if (success) {
      log.showInfo('[SCBMain]Add scene container session, id: ' + session?.containerId);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
  }

  /**
   * Add Scene Container Session from List
   *
   * @param { Array<SCBSceneContainerSession> } list
   */
  public addSceneContainerSessionByList(list: Array<SCBSceneContainerSession>): void {
    if (list.length === 0) {
      log.showInfo('The list is empty.');
      return;
    }
    const isTopActive = this.containerSessionList.getTopActiveSession();
    if (isTopActive) {
      this.batchAddSceneContainerSessionByIndex(list, this.containerSessionList.length - 1);
    } else {
      this.batchAddSceneContainerSessionToLast(list);
    }
  }

  /**
   * Batch adds scene container session List at the specified index location
   *
   * @param list  scene container session List
   * @param index  location
   */
  private batchAddSceneContainerSessionByIndex(list: Array<SCBSceneContainerSession>, index: number): void {
    for (let item of list) {
      log.showInfo('[SCBMain]Add scene container session list by index, itemId: ' + item?.containerId);
      let success = this.containerSessionList.splice(index++, 0, item);
      if (!success) {
        log.showWarn(`[SCBMain]Add scene container session list by index failed, itemId: ${item?.containerId}`);
      }
    }
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  private batchAddSceneContainerSessionToLast(list: Array<SCBSceneContainerSession>): void {
    for (let item of list) {
      log.showInfo('[SCBMain]Add scene container session list to last, itemId: ' + item?.containerId);
      this.containerSessionList.push(item);
    }
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  /**
   * Remove Scene Container Session
   *
   * @param { SCBSceneContainerSession } session
   */
  public removeSceneContainerSession(session: SCBSceneContainerSession): void {
    if (CommonUtils.isInvalid(session)) {
      log.showWarn('[SCBMain]remove sceneContainerSession failed, session is invalid');
      return;
    }
    this.removeNotShowRecentSession(session);
    const index = this.containerSessionList.findIndex((item) => {
      return item.containerId === session.containerId;
    });
    if (index === -1) {
      log.showInfo(`[SCBMain]Remove scene container session faild, not exist, id=${session.containerId}`);
      return;
    }
    log.showInfo(`[SCBMain]Remove scene container session, id=${session.containerId}`);
    this.removeContainerSessionByIndex(index);
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  public removeFloatSceneContainerSession(session: SCBSceneContainerSession): void {
    if (CommonUtils.isInvalid(session)) {
      return;
    }
    const index = this.floatingSessionList.findIndex((item) => {
      return item.containerId === session.containerId;
    });
    if (index !== -1) {
      log.showInfo(`Remove scene container session for float, id=${session.containerId}`);
      this.removeFloatContainerSessionByIndex(index);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    }
  }

  /**
   * Remove container session by index
   *
   * @param { Number } index
   */
  public removeContainerSessionByIndex(index: number): void {
    this.containerSessionList[index]?.transitionController?.onInactive(TAG, 'removeContainerSessionByIndex');
    const list = this.containerSessionList.splice(index, 1);
    if (list.length) {
      log.showInfo(`[SCBMain]Remove scene container session by index=${index}, id=${list[0].getPersistentId()}`);
    } else {
      log.showInfo(`[SCBMain]Remove scene container session fail by index=${index}`);
    }
  }

  public removeFloatContainerSessionByIndex(index: number): void {
    this.floatingSessionList[index]?.transitionController?.onInactive(TAG, 'removeFloatContainerSessionByIndex');
    const list = this.floatingSessionList.splice(index, 1);
    if (list.length) {
      log.showInfo(`[SCBMain]Remove scene container session for float by index=${index}, id=${list[0].getPersistentId()}`);
    } else {
      log.showInfo(`[SCBMain]Remove scene container session for float fail by index=${index}`);
    }
  }

  public removeFloatContainerSession(session: SCBSceneContainerSession): void {
    if (CommonUtils.isInvalid(session)) {
      log.showWarn('[SCBMain]remove float containerSession failed, session is invalid');
      return;
    }
    const index = this.floatingSessionList.findIndex((item) => {
      return item.containerId === session.containerId;
    });
    if (index !== -1) {
      log.showInfo(`Remove scene container session for float, id=${session.containerId}`);
      this.removeFloatContainerSessionByIndex(index);
    }
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  /**
   * Adds the specified scene container session to the Do not show recent sessions list
   *
   * @param { SCBSceneContainerSession } session
   */
  public addNotShowRecentSession(session: SCBSceneContainerSession): void {
    log.showInfo('[SCBMain]Add scene container session in not show list, name: ' + session?.getName());
    this.containerSessionListNotShowRecent.add(session);
  }

  /**
   * Removes the specified session from the Never Show Recent Sessions list
   *
   * @param { SCBSceneContainerSession } session
   */
  public removeNotShowRecentSession(session: SCBSceneContainerSession): void {
    if (CommonUtils.isInvalid(session)) {
      log.showWarn('[SCBMain]remove not show recent sceneContainer failed, session is invalid');
      return;
    }
    let ret = this.containerSessionListNotShowRecent.deleteByContainerId(session.containerId);
    if (ret) {
      log.showInfo('[SCBMain]Remove scene container session in not show list success, name: ' + session.getName());
    }
  }

  public popNotShowRecentSession(persistentId: number | undefined, sceneInfo: SCBSceneInfo | undefined):
    SCBSceneSession | undefined {
    let containerSession: SCBSceneContainerSession | undefined;
    if (persistentId && persistentId > INVALID_PERSISTENT_ID) {
      containerSession = this.containerSessionListNotShowRecent.find((containerSession: SCBSceneContainerSession) => {
        return containerSession.primarySession?.session?.persistentId === persistentId;
      });
    } else if (sceneInfo) {
      containerSession = this.containerSessionListNotShowRecent.find((containerSession: SCBSceneContainerSession) => {
        return containerSession.primarySession?.sceneInfo?.equalTo(sceneInfo);
      });
    }
    if (CommonUtils.isInvalid(containerSession)) {
      log.showWarn('[SCBMain]remove not show recent sceneContainer failed, not find');
      return undefined;
    }
    this.removeNotShowRecentSession(containerSession);
    return containerSession.primarySession;
  }

  /**
   * Raises the specified scene container to the topmost layer.
   *
   * @param { SCBSceneContainerSession } containerSession
   */
  public raiseSceneToTop(containerSession: SCBSceneContainerSession,
    needNotifyRecentAndGestureDock: boolean = true): void {
    containerSession.updateLastUsedTimestamp(Date.now());
    const index = this.containerSessionList.findIndex(item => {
      return item.containerId === containerSession.containerId;
    });
    if (index !== -1) {
      log.showInfo(`Remove container id: ${containerSession.containerId}, ` +
        `${containerSession.primarySession?.persistentId}`);
      if (index !== this.containerSessionList.length - 1) {
        this.removeContainerSessionByIndex(index);
        this.containerSessionList.push(containerSession);
      }
      // 抬升监听回调
      this.panelParam?.onRaiseSceneToTop?.(containerSession);
      SCBSceneSessionManager.getInstance().refreshZOrder();
    } else {
      log.showError('raiseSceneToTop failed since cannot find sceneContainerSession, id: ' +
        containerSession.containerId);
    }
    this.raiseFloatingSceneToTop(containerSession, needNotifyRecentAndGestureDock);
  }

  public raiseFloatingSceneToTop(containerSession: SCBSceneContainerSession,
    needNotifyRecentAndGestureDock: boolean = true): void {
    if (CommonUtils.isInvalid(containerSession) || !containerSession.isFloat) {
      return;
    }
    if (containerSession.isFloat) {
      const floatIndex = this.floatingSessionList.findIndex(item => {
        return item.containerId === containerSession.containerId;
      });
      if (floatIndex === -1) {
        return;
      }
      if (floatIndex !== this.floatingSessionList.length - 1) {
        log.showInfo('Remove scene container session for float, id: ' + containerSession.containerId);
        this.removeFloatContainerSessionByIndex(floatIndex);
        this.floatingSessionList.push(containerSession);
      }
    }
    // 抬升监听回调
    if (needNotifyRecentAndGestureDock) {
      this.panelParam?.onRaiseSceneToTop?.(containerSession);
    }
  }

  public getActiveFloatContainerList(needSort?: boolean): Array<SCBSceneContainerSession> {
    let list = new Array<SCBSceneContainerSession>();
    this.floatingSessionList.forEach(item => {
      if (item && item.isActive && !item.floatingParam.isMinimized && !item.floatingParam.isClosed) {
        list.push(item);
      }
    });
    if (needSort) {
      list.sort((itemOne, itemOther) => {
        return itemOther.needRenderPos.posX - itemOne.needRenderPos.posX;
      });
    }
    return list;
  }

  public getTopActiveSceneSessionArray(): Array<SCBSceneContainerSession> | null {
    log.showInfo(`getTopActiveSceneSessionArray  length:${this.floatingSessionList.length}`);
    if (this.floatingSessionList.length === 0) {
      return null;
    }
    let activeSceneSessionArray = new Array<SCBSceneContainerSession>();
    for (let i = this.floatingSessionList.length - 1; i >= 0; i--) {
      let isMinimizedOrClosed = this.floatingSessionList[i].floatingParam.isMinimized ||
        this.floatingSessionList[i].floatingParam.isFloatingSceneClosed();
      if (this.floatingSessionList[i] && this.floatingSessionList[i].isActive && !isMinimizedOrClosed) {
        activeSceneSessionArray.push(this.floatingSessionList[i]);
      }
    }
    if (activeSceneSessionArray.length > 0) {
      return activeSceneSessionArray;
    }
    log.showError('no active session');
    return null;
  }

  /**
   * Sets the blur and color of the background when the focus state ends.
   *
   * @param { Number } blurScale
   */
  public onBlurTransitionActive(blurScale: number = SCBConstants.START_SCENE_BG_BLUR_SCALE, source: string = ''): void {
    log.showInfo(`onBlurTransitionActive blurScale:${blurScale} source:${source} isForegroundBlurActive:${this.isForegroundBlurActive}`);
    if (!this.isForegroundBlurActive) {
      this.backgroundBlurSession.setBgBlurScale(blurScale, source);
      this.backgroundBlurSession.setBgBlurColor(SCBConstants.START_SCENE_BG_COLOR);
    }
  }

  public setForegroundBlurActive(isActive: boolean): void {
    this.isForegroundBlurActive = isActive;
  }

  /**
   * Activates some effects when the focus moves out of focus
   *
   * @param source caller Function Name
   */
  public onBlurTransitionInactive(source: string = 'onBlurTransitionInactive'): void {
    log.showInfo('onBlurTransitionInactive out of focus');
    this.backgroundBlurSession.setBgBlurScale(0, source);
    this.backgroundBlurSession.setBgBlurColor(SCBConstants.DEFAULT_SCENE_BG_COLOR);
  }

  /**
   * Increments the fuzzy component transition count and returns the new count value
   *
   * @returns { number } Returns the incremented fuzzy component transition count
   */
  public addBlurTransitionCountAndReturnValue(): number {
    return ++this.blurComponentTransitionCount;
  }

  /**
   * Increase fuzzy component transition count
   */
  public addBlurTransitionCount(): void {
    this.blurComponentTransitionCount++;
  }

  public getBlurTransitionCount(): number {
    return this.blurComponentTransitionCount;
  }

  /**
   * Processing function when the focus shift is complete
   *
   * @param { Number } transitionCount
   */
  public onBlurTransitionFinish(transitionCount: number): void {
    log.showInfo('onBlurTransitionFinish %{public}d blurComponentTransitionCount:%{public}d', transitionCount,
      this.blurComponentTransitionCount);
    if (transitionCount === this.blurComponentTransitionCount) {
      this.blurComponentTransitionCount = 0;
      this.disableBlurComponent('onBlurTransitionFinish');
    }
  }

  /**
   * Disable Blur Components
   *
   * @param { callerFunctionName } caller Function Name
   */
  public disableBlurComponent(callerFunctionName: string): void {
    this.panelSession.setBgBlurEnable(false, callerFunctionName);
  }

  /**
   * Enable Blur Component
   *
   * @param { callerFunctionName } caller Function Name
   */
  public enableBlurComponent(callerFunctionName: string): void {
    this.addBlurTransitionCount();
    this.panelSession.setBgBlurEnable(true, callerFunctionName);
  }

  /**
   * Sets the Z-axis index of the panel
   *
   * @param { Number } zIndex
   */
  public setPanelZIndex(zIndex: number): void {
    this.panelSession.setPanelZIndex(zIndex);
  }

  /**
   * restore container from notShowRecentList to ContainerList
   *
   * @param { SCBSceneContainerSession | null } containerSession
   */
  public restoreNotshowToContainerList(containerSession: SCBSceneContainerSession | null): void {
    if (!containerSession) {
      return;
    }
    let index = this.containerSessionListNotShowRecent.findIndexByContainerId(containerSession.containerId);
    if (index !== -1) {
      this.containerSessionListNotShowRecent.splice(index, 1);
      this.containerSessionList.add(containerSession);
      log.info(`add to containerList by id ${containerSession.getPersistentId()}`);
    }
  }

  public setScreenPropertyToViewParam(): void {
    if (this.viewParam.recentH === this.screenProperty.height && this.viewParam.recentW === this.screenProperty.width) {
      return;
    }
    this.viewParam.recentH = this.screenProperty.height;
    this.viewParam.recentW = this.screenProperty.width;
    log.info(`set viewParam recentW:${this.viewParam.recentW} recentH:${this.viewParam.recentH}`);
  }

  /**
   * get parentSession with specificSession and screenId
   * @param { parentId } parentId
   * @param { screenId } screenId
   * @returns { SCBSceneSession | null } parentSession or null
   */
  public getParentSessionWithScreenId(parentId: number, screenId: number): SCBSceneSession | null {
    if (parentId < 0) {
      return null;
    }
    let totalSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList(screenId).clone();
    let floatContainerSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
    totalSessionList.push(...floatContainerSessionList);
    let parentSession = totalSessionList.getSceneSessionByPersistentId(parentId);
    if (CommonUtils.isInvalid(parentSession)) {
      log.showWarn(`getParentSession: fail to find containerSession with persistentId: ${parentId}`);
      return null;
    }
    return parentSession;
  }

  /**
   * Remove close Container Session
   *
   * @param { CloseContainerParam } closeContainerParam
   */
  public removeCloseContainer(closeContainerParam: CloseContainerParam): void {
    if (CommonUtils.isInvalid(closeContainerParam)) {
      log.showWarn('[SCBMain]remove closeContainerParam failed, session is invalid');
      return;
    }
    this.closeContainerList.deleteContainer(closeContainerParam);
  }
}
