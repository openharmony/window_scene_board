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
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { HiSysEventUtil, SCBWindowSceneConfig, viewMgrPolicy, ViewType, } from '@ohos/frameworkwrapper';
import {
  ScbNumber,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneMode,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBScreenSession,
  SCBScreenSessionManager,
  SCBSessionRect,
  SCBSpecificSession,
  SessionDisplayChangeReason,
  SystemBarType
} from '@ohos/windowscene';
import { LayoutViewModel, StyleConstants } from '@ohos/launchercommon';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSpecificSceneSessionList,
  SessionChangeInfo,
  SessionRectChangeInfo,
} from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import { SwipeGestureDirection } from '../constants/SwipeGestureDirection';
import { systemDateTime } from '@kit.BasicServicesKit';
import { SCBSessionListManager } from './SCBSessionListManager';
import { ViewModelConstant } from '../constants/BaseConstants';
import { DividerStyle } from '../constants/DividerStyleConstants';
import { SCBSplitLayoutHelper } from '../utils/SCBSplitLayoutHelper';
import { SCBSceneHelper } from '../utils/SCBSceneHelper';
import { SCBFreeWindowsViewModelManager } from '../SCBFreeWindowsViewModelManager';
import { LayoutPolicy } from '../layout/LayoutPolicy';
import { Pointer2D } from '../utils/SCBPcModeUtils';
import { LayoutPolicyHelper } from '../layout/LayoutPolicyHelper';
import { display } from '@kit.ArkUI';
import { SCBConstants } from '@ohos/commonconstants';
import { SCBSystemSceneUtils } from '../utils/SCBSystemSceneUtils';

const TAG = 'SCBPcScenePanelManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const INVALID_SCREENID = -1;

export type SpecificSessionAddFunc = (session: SCBSpecificSession) => void;

export interface SpecificSessionController {
  addSession: SpecificSessionAddFunc;
  removeSession: (persistentId: number) => boolean;
  searchSession: (persistentId: number) => SCBSpecificSession | undefined ;
}

export class SCBPcScenePanelManager {
  private static instance: SCBPcScenePanelManager;
  // controllerMap to control SCBSpecificScenePanel --> Map<screenId, Map<zorder, SpecificSessionController>>
  private specificControllerMap: Map<number, Map<number, SpecificSessionController>> = new Map();
  // cache session if SCBScenePanel not exist --> Map<screenId, Map<zorder, SpecificSessionController>>
  private specificCacheList: Map<number, Map<number, SCBSpecificSession[]>> = new Map();
  private getIsPairSplitCallbackMap: Map<number, Function> = new Map();
  // callbackMap to add containerSessionListNotShowRecent by screenId
  private addListNotShowRecentCallbackMap: Map<number, Function> = new Map();
  // callbackMap to remove containerSessionListNotShowRecent by screenId
  private removeListNotShowRecentCallbackMap: Map<number, Function> = new Map();
  // callbackMap to sceneHiddenModeVisChange by screenId
  private sceneHiddenModeVisChangeCallbackMap: Map<number, Function> = new Map();

  private isWindowRectAutoSaveMap: Map<string, boolean> = new Map();

  private contextMap: Map<number, UIContext> = new Map()

  private isEnableSpecifiedRectAutoSaveMap: Map<string, boolean> = new Map();

  private screenDensityMap: Map<number, number> = new Map();

  private displayChangeCallbackMap: Map<number, Function> = new Map();

  private constructor() {
    SCBSceneSessionManager.getInstance().registerSessionDisplayChangeCallback(this.onSessionDisplayChange);
    SCBSceneSessionManager.getInstance().registerSetWindowRectAutoSaveCallback((sceneInfo: SCBSceneInfo,
      enable: boolean, isEnableSpecified: boolean) => {
      let abilityKey: string = sceneInfo.bundleName + sceneInfo.moduleName + sceneInfo.abilityName;
      this.setIsEnableSpecifiedRectAutoSaveMap(abilityKey, isEnableSpecified);
      let key: string = this.createIsWindowRectAutoSaveKey(sceneInfo);
      this.isWindowRectAutoSaveMap.set(key, enable);
      SCBSceneSessionManager.getInstance().setIsWindowRectAutoSave(key, enable, abilityKey, isEnableSpecified);
      log.showInfo(`isWindowRectAutoSaveMap set suceess key: ${key}, enable:${this.isWindowRectAutoSaveMap.get(key)},` +
        ` isEnableSpecified:${isEnableSpecified}`);
    });
    this.initListener();
  }

  public getIsWindowRectAutoSaveMap(key: string): boolean | undefined {
    return this.isWindowRectAutoSaveMap.get(key);
  }

  public setIsWindowRectAutoSaveMap(key: string, enabled: boolean): void {
    this.isWindowRectAutoSaveMap.set(key, enabled);
  }

  public getIsEnableSpecifiedRectAutoSaveMap(key: string): boolean | undefined {
    return this.isEnableSpecifiedRectAutoSaveMap.get(key);
  }

  public setIsEnableSpecifiedRectAutoSaveMap(key: string, enable: boolean) {
    this.isEnableSpecifiedRectAutoSaveMap.set(key, enable);
    log.showInfo(`setIsEnableSpecifiedRectAutoSaveMap ${enable}`)
  }

  public createIsWindowRectAutoSaveKey(sceneInfo: SCBSceneInfo): string {
    let key: string = sceneInfo.bundleName + sceneInfo.moduleName + sceneInfo.abilityName;
    if (this.getIsEnableSpecifiedRectAutoSaveMap(key) && sceneInfo.specifiedFlag) {
      key = key + sceneInfo.specifiedFlag;
    }
    return key;
  }

  public static getInstance(): SCBPcScenePanelManager {
    if (!SCBPcScenePanelManager.instance) {
      SCBPcScenePanelManager.instance = new SCBPcScenePanelManager();
    }
    return SCBPcScenePanelManager.instance;
  }

  /**
   * 加入主屏之前修改扩展屏的ContainerSession
   *
   * @param extendContainerSession
   * @param newScreenProperty
   */
  public updateExtendContainerSession(extendContainerSession: SCBSceneContainerSession,
    newScreenProperty: SCBScreenProperty): void {
    log.showInfo(`updateExtendContainerSession`);
    if (!extendContainerSession) {
      return;
    }
    let oldScreenProperty = new SCBScreenProperty();
    oldScreenProperty.copy(extendContainerSession.screenProperty);
    this.updateContainerSessionDisplayInfo(extendContainerSession, newScreenProperty);
    const screenId = newScreenProperty.screenId;
    if (extendContainerSession.primarySession) {
      log.showInfo(`updateExtendContainerSession primarySession ` +
        `persistentId: ${extendContainerSession.primarySession.sceneInfo.persistentId},` +
        `bundleName: ${extendContainerSession.primarySession.sceneInfo.bundleName}`);
      extendContainerSession.primarySession.updateDisplayId(screenId);
      const oldMainRect: SCBSessionRect = extendContainerSession.primarySession.currRect.copy();
      this.doUpdateFreeAndFullSession(extendContainerSession, oldScreenProperty, newScreenProperty);
      log.showInfo(`updateExtendContainerSession: sceneSession: ${extendContainerSession.primarySession.getName()}, ` +
        `rect from ${oldMainRect.printPx()} change to ${extendContainerSession.primarySession.currRect.printPx()}`);
      this.updateSubSession(extendContainerSession.primarySession, oldScreenProperty, newScreenProperty, oldMainRect,
        oldScreenProperty.screenId);
    }
    if (extendContainerSession.isSplit && extendContainerSession.secondarySession) {
      extendContainerSession.secondarySession.updateDisplayId(screenId);
      const oldMainRect: SCBSessionRect = extendContainerSession.secondarySession.currRect.copy();
      this.updateExtendSplitSession(extendContainerSession, oldScreenProperty, newScreenProperty);
      if (extendContainerSession.primarySession) {
        LayoutPolicyHelper.getInstance().handleFreeWindowRect(extendContainerSession.primarySession.lastRect,
          oldScreenProperty, newScreenProperty, extendContainerSession.primarySession);
      }
      LayoutPolicyHelper.getInstance().handleFreeWindowRect(extendContainerSession.secondarySession.lastRect,
        oldScreenProperty, newScreenProperty, extendContainerSession.secondarySession);
      this.updateSubSession(extendContainerSession.secondarySession, oldScreenProperty, newScreenProperty, oldMainRect,
        oldScreenProperty.screenId);
    }
  }

  /**
   * 合并拖拽到扩展屏上的子窗到主屏
   *
   * @param containerSession
   * @param newScreenProperty
   * @param extendScreenId
   */
  public updateExtendSubSession(containerSession: SCBSceneContainerSession,
    newScreenProperty: SCBScreenProperty, extendScreenId: number): void {
    log.showInfo(`updateExtendSubSession`);
    let oldScreenProperty = new SCBScreenProperty();
    let screenSession = SCBScreenSessionManager.getInstance().getScreenSession(extendScreenId);
    if (!screenSession) {
      log.showError(`updateExtendSubSession get screenSession is null`);
      return;
    }
    oldScreenProperty.copy(screenSession.scbScreenProperty);
    if (containerSession.primarySession) {
      const oldMainRect: SCBSessionRect = containerSession.primarySession.currRect.copy();
      this.updateSubSession(containerSession.primarySession, oldScreenProperty, newScreenProperty, oldMainRect,
        containerSession.screenProperty.screenId);
    }
    if (containerSession.secondarySession) {
      const oldMainRect: SCBSessionRect = containerSession.secondarySession.currRect.copy();
      this.updateSubSession(containerSession.secondarySession, oldScreenProperty, newScreenProperty, oldMainRect,
        containerSession.screenProperty.screenId);
    }
    let screenProperty = new SCBScreenProperty();
    screenProperty.screenId = extendScreenId;
    let extendContainerSessionList = SCBSessionListManager.getNormalContainerArray(screenProperty);
    let index = extendContainerSessionList.indexOf(containerSession);
    if (index !== -1) {
      extendContainerSessionList.splice(index, 1);
    }
  }

  /**
   * update subsession when change mode or screen disconnect recursively
   *
   * @param sceneSession main session or subsession
   * @param oldScreenProperty old screen's screen property
   * @param newScreenProperty new screen's screen property
   * @param oldMainRect main session or subsession rect before change
   * @param containerSessionScreenId main session or subsession screen id
   */
  public updateSubSession(sceneSession: SCBSceneSession | SCBSpecificSession, oldScreenProperty: SCBScreenProperty,
    newScreenProperty: SCBScreenProperty, oldMainRect: SCBSessionRect, containerSessionScreenId: number,
    targetDensity?: number): void {
    if (sceneSession.subSessionList) {
      const logName: string = `updateSubSession bundleName: ${sceneSession.getName()}, ` +
        (sceneSession instanceof SCBSceneSession ? `persistentId: ${sceneSession.sceneInfo.persistentId}, ` : ``) +
        `from screenId: ${oldScreenProperty.screenId}, to screenId: ${newScreenProperty.screenId}`;
      log.showInfo(logName);
      let subList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
      SCBSceneHelper.traverseSubList(sceneSession.subSessionList, subList);
      for (let subSession of subList) {
        if (subSession.screenId !== oldScreenProperty.screenId) {
          continue;
        }
        if (oldScreenProperty.screenId !== newScreenProperty.screenId) {
          subSession.updateDisplayId(newScreenProperty.screenId);
        }
        const oldSubMainRect: SCBSessionRect = subSession.currRect.copy();
        LayoutPolicyHelper.getInstance().updateSingleSubSessionRect(oldMainRect, sceneSession.currRect.copy(),
          subSession, oldScreenProperty, newScreenProperty, containerSessionScreenId === oldScreenProperty.screenId,
          targetDensity);
        log.showInfo(`updateSubSession: subSession: ${subSession.getName()}, ` +
          `rect from ${oldSubMainRect.printPx()} change to ${subSession.currRect.printPx()}`);
      }
    }
  }

  private springBackIfNeeded(sceneSession: SCBSceneSession, newScreenProperty: SCBScreenProperty): void {
    // top area
    let topThreshold = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(newScreenProperty.screenId);
    if (sceneSession.currRect.top.getPx() < topThreshold) {
      sceneSession.currRect.setPosNum(sceneSession.currRect.left.getPx(), topThreshold);
    }

    let titleHeight = StyleConstants.DEFAULT_CONTAINER_TITLE_HEIGHT;
    try {
      const customDecorHeight: ESObject = sceneSessionManager.getCustomDecorHeight(sceneSession.session.persistentId);
      if (customDecorHeight !== 0 && customDecorHeight !== titleHeight) {
        titleHeight = customDecorHeight;
      }
    } catch (error) {
      log.showError(`get customDecorHeight failed, error: ${error}`);
    }
    // bottom area
    let titleHeightPx = 0;
    let dockHeight = 0;
    let density: number | undefined = this.screenDensityMap.get(newScreenProperty.screenId);
    if (density !== undefined) {
      titleHeightPx = density / ViewModelConstant.BASE_DENSITY * titleHeight;
    } else {
      let uiContext: UIContext | undefined = this.contextMap.get(newScreenProperty.screenId);
      titleHeightPx = SCBSystemSceneUtils.getInstance().vp2px(uiContext, titleHeight);
    }
    let dock = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemBarType(SystemBarType.SMART_DOCK, newScreenProperty.screenId);
    if (dock) {
      dockHeight = dock.currRect.height.getPx();
    }
    let bottomThreshold = newScreenProperty.height - titleHeightPx - dockHeight;
    if (sceneSession.currRect.top.getPx() > bottomThreshold) {
      sceneSession.currRect.setPosNum(sceneSession.currRect.left.getPx(), bottomThreshold);
    }
  }

  private updateExtendSplitSession(extendContainerSession: SCBSceneContainerSession,
    oldScreenProperty: SCBScreenProperty, newScreenProperty: SCBScreenProperty): void {
    if (!extendContainerSession.isActive && extendContainerSession.primarySession) {
      extendContainerSession.dividerParam.positionX =
        `${extendContainerSession.isSplitPrimaryMode() ? extendContainerSession.primarySession.currRect.width.getVp() :
        extendContainerSession.secondarySession?.currRect.width.getVp()}`;
      extendContainerSession.dividerParam.positionY = `${extendContainerSession.primarySession.currRect.top.getVp()}`;
      extendContainerSession.dividerParam.dividerWidth = DividerStyle.DIVIDER_WIDTH;
      extendContainerSession.dividerParam.dividerHeight = extendContainerSession.primarySession.currRect.height.getVp();
      return;
    }
    this.doUpdateSplitSession(extendContainerSession, newScreenProperty);
  }

  private getTopThreshold(screenId: number): number {
    let topThreshold = 0;
    if (!AppStorage.get<boolean>('isDockAutoHide')) {
      topThreshold = SCBSystemSceneUtils.getInstance().getStatusBarHeightPx(screenId);
    }
    return topThreshold;
  }

  private getBottomThreshold(newScreenProperty: SCBScreenProperty): number {
    let bottomThreshold = newScreenProperty.height;
    if (!AppStorage.get<boolean>('isDockAutoHide')) {
      bottomThreshold = bottomThreshold - SCBSystemSceneUtils.getInstance().getDockHeightPx(newScreenProperty.screenId);
    }
    return bottomThreshold;
  }

  private onSessionDisplayChange = (reason: SessionDisplayChangeReason, sessionChangeInfo: SessionChangeInfo): void => {
    if (!sessionChangeInfo) {
      log.showWarn(`onSessionDisplayChange sessionChangeInfo is null. reason:${reason}`);
      return;
    }
    switch (reason) {
      case SessionDisplayChangeReason.MOVE_TO_TARGET_DISPLAY:
        this.moveMainSessionToTargetScreen(sessionChangeInfo);
        break;
      case SessionDisplayChangeReason.MOVE_SUB_WINDOW_TO_TARGET_DISPLAY:
        this.moveSubSessionToTargetScreen(sessionChangeInfo);
        break;
      case SessionDisplayChangeReason.MOVE_SPECIFIC_WINDOW_TO_TARGET_DISPLAY:
        this.moveSpecificSessionToTargetScreen(sessionChangeInfo);
        break;
      case SessionDisplayChangeReason.START_MOVE:
        this.startMoveSession(sessionChangeInfo);
        break;
      case SessionDisplayChangeReason.END_MOVE:
        this.endMoveSession(sessionChangeInfo);
        break;
      case SessionDisplayChangeReason.DRAG_START:
        this.startMoveSession(sessionChangeInfo);
        break;
      case SessionDisplayChangeReason.REFRESH:
        this.refreshContainerSessionList(sessionChangeInfo);
        break;
      case SessionDisplayChangeReason.CHANGE_PARENT_SESSION:
        this.subSessionChangeParentSession(sessionChangeInfo);
        break;
      case SessionDisplayChangeReason.MOVE_TO_TARGET_DISPLAY_NOT_SHOW:
        this.moveNotShowRecentToTarget(sessionChangeInfo);
        break;
      default:
        break;
    }
    return;
  }

  private moveMainSessionToTargetScreen(sessionChangeInfo: SessionChangeInfo): void {
    log.showInfo(`moveMainSessionToTargetScreen targetScreenId: ${sessionChangeInfo.targetScreenId}` +
      `, curScreenId: ${sessionChangeInfo.curScreenId}`);
    this.moveSessionToTargetScreen(sessionChangeInfo, true);
  }

  /**
   * when container change to another screen, update screenProperty
   * @param containerSession
   * @param targetScreenProperty
   */
  public updateContainerSessionDisplayInfo(containerSession: SCBSceneContainerSession,
    targetScreenProperty: SCBScreenProperty) {
    if (!containerSession || !targetScreenProperty) {
      log.showWarn(`updateContainerSession failed.`);
      return;
    }
    containerSession.updateScreenProperty(targetScreenProperty);
  }

  private moveSubSessionToTargetScreen(sessionChangeInfo: SessionChangeInfo): void {
    log.showInfo(`moveSubSessionToTargetScreen targetScreenId: ${sessionChangeInfo.targetScreenId}` +
      `, curScreenId: ${sessionChangeInfo.curScreenId}`);
    this.moveSessionToTargetScreen(sessionChangeInfo, false);
  }

  private subSessionChangeParentSession(sessionChangeInfo: SessionChangeInfo): void {
    log.showInfo(`subSessionChangeParentSession targetScreenId: ${sessionChangeInfo.targetScreenId}`);
    this.moveSessionToTargetScreen(sessionChangeInfo, false);
  }

  private moveNotShowRecentToTarget(sessionChangeInfo: SessionChangeInfo): void {
    log.showInfo(`moveNotShowRecentToTarget currentScreenId: ${sessionChangeInfo.curScreenId},
      targetScreenId: ${sessionChangeInfo.targetScreenId}`);
    if (sessionChangeInfo.curScreenId === sessionChangeInfo.targetScreenId) {
      return;
    }
    // get containerSession in not show list
    for (let persistentId of sessionChangeInfo.persistentIds) {
      let containerSession = SCBSceneSessionManager.getInstance().
        getContainerSessionListNotShowRecent(sessionChangeInfo.curScreenId).findByPersistentId(persistentId);
      if (!containerSession) {
        log.showWarn(`persistentId: ${persistentId} moveNotShowRecentToTarget failed.`);
        continue;
      }
      let targetScreenProperty = this.getTargetScreenProperty(sessionChangeInfo.targetScreenId);
      if (!targetScreenProperty) {
        log.showError(`moveNotShowRecentToTarget get targetScreenProperty failed!`);
        return;
      }
      this.updateContainerSessionDisplayInfo(containerSession, targetScreenProperty);
      containerSession.primarySession?.updateDisplayId(sessionChangeInfo.targetScreenId);
      this.addListNotShowRecent(sessionChangeInfo.targetScreenId, containerSession);
      this.removeListNotShowRecent(sessionChangeInfo.curScreenId, containerSession);
    }
  }

  private moveSessionToTargetScreen(sessionChangeInfo: SessionChangeInfo, isMainSession: boolean): void {
    let curContainerSessionList: SCBSceneContainerSessionArray =
      SCBSceneSessionManager.getInstance().getContainerSessionList(sessionChangeInfo.curScreenId);

    let tmpContainerMap: Map<number, SCBSceneContainerSession> = new Map();

    // get containerSession in current screen
    for (let id of sessionChangeInfo.persistentIds) {
      let containerSession = curContainerSessionList.findByPersistentId(id, true);
      if (!containerSession) {
        log.showWarn(`moveSessionToTargetScreen not find containerSession. persistentId:${id}`);
        continue;
      }
      if (containerSession.primarySession?.isSessionResizeWhenDragEnd) {
        log.showWarn(`moveSessionToTargetScreen not to move for isSessionResizeWhenDragEnd is true. persistentId:${id}`);
        continue;
      }
      tmpContainerMap.set(id, containerSession);
    }

    let targetContainerSessionList: SCBSceneContainerSessionArray =
      SCBSceneSessionManager.getInstance().getContainerSessionList(sessionChangeInfo.targetScreenId);
    for (let iter of tmpContainerMap.entries()) {
      let persistentId = iter[0];
      let containerSession = iter[1];

      // add to target screen
      if (!targetContainerSessionList.findByContainerId(containerSession.containerId)) {
        log.showDebug(`moveSessionToTargetScreen add:${containerSession.primarySession?.sceneInfo.persistentId}` +
          `, screenId:${sessionChangeInfo.targetScreenId}, target len:${targetContainerSessionList.length}`);
        targetContainerSessionList.push(containerSession);
      }

      targetContainerSessionList.sortByTopmost();
      let sessionRectChangeInfo = sessionChangeInfo.sessionRectChangeMap.get(persistentId);
      if (sessionRectChangeInfo !== undefined && sessionRectChangeInfo !== null) {
        this.onSessionRectChange(sessionRectChangeInfo, sessionChangeInfo,
          containerSession, persistentId, curContainerSessionList, isMainSession);
      }

      // remove from current screen
      if (!curContainerSessionList.isContainerInScreenHasSession(
        containerSession.containerId, sessionChangeInfo.curScreenId)) {
        let index = curContainerSessionList.indexOf(containerSession);
        if (index === -1) {
          log.showWarn(`moveSessionToTargetScreen find container failed. containerId:${containerSession.containerId}` +
            `, screenId:${sessionChangeInfo.curScreenId}`);
          continue;
        }
        log.showDebug(`moveSessionToTargetScreen remove:${containerSession.primarySession?.sceneInfo.persistentId}` +
          `, screenId:${sessionChangeInfo.curScreenId}`);
        curContainerSessionList.splice(index, 1);
      }
      log.showInfo(`moveSessionToTargetScreen after remove. curScreen len:${curContainerSessionList.length}` +
        `, targetScreen len:${targetContainerSessionList.length}`);
    }
    return;
  }

  private getTargetScreenProperty(screenId: number): SCBScreenProperty | null {
    for (let screenSession of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      if (screenSession.scbScreenProperty.screenId === screenId) {
        return screenSession.scbScreenProperty;
      }
    }
    return null;
  }

  private updateSessionScreenId(persistentId: number, containerSession: SCBSceneContainerSession,
    containerSessionList: SCBSceneContainerSessionArray, sessionChangeInfo: SessionChangeInfo,
    isMainSession: boolean) {
    let screenId: number = sessionChangeInfo.targetScreenId;
    if (isMainSession) {
      let targetScreenProperty = this.getTargetScreenProperty(screenId);
      if (!targetScreenProperty) {
        log.showError(`updateSessionScreenId get targetScreenProperty failed!`);
        return;
      }
      this.updateContainerSessionDisplayInfo(containerSession, targetScreenProperty);
      if (containerSession.primarySession) {
        containerSession.primarySession.isCrossingScreen = true;
        containerSession.primarySession.updateDisplayId(screenId);
        // moveTo场景，新屏幕上得SCBScene还未注册callback，需要在这里做可用区域避让
        this.springBackIfNeeded(containerSession.primarySession, targetScreenProperty);
      }
    } else {
      let subSession = containerSessionList.getSessionByPersistentId(persistentId) as SCBSpecificSession;
      if (subSession) {
        subSession.isCrossingScreen = true;
        subSession.updateDisplayId(screenId);
      } else {
        log.showWarn(`updateSessionScreenId find subSession failed. persistentId:${persistentId}`);
      }
    }
  }

  private startMoveSession(sessionChangeInfo: SessionChangeInfo): void {
    log.showInfo(`startMoveSession curScreenId: ${sessionChangeInfo.curScreenId}`);
    let curContainerSessionList: SCBSceneContainerSessionArray =
      SCBSceneSessionManager.getInstance().getContainerSessionList(sessionChangeInfo.curScreenId);

    let tmpContainerArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

    // get containerSession of subwindow in current screen
    for (let id of sessionChangeInfo.persistentIds) {
      let containerSession = curContainerSessionList.findByPersistentId(id, true);
      if (!containerSession) {
        log.showWarn(`moveSubSessionToTargetScreen not find containerSession. persistentId:${id}`);
        continue;
      }
      tmpContainerArray.push(containerSession);
    }

    if (tmpContainerArray.length === 0) {
      return;
    }

    // add temp container session to other screen for window hot area animation.
    for (let screenSession of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      let screenId: ESObject = screenSession.session.screenId;
      // add container to target screen
      let targetContainerSessionList: SCBSceneContainerSessionArray =
        SCBSceneSessionManager.getInstance().getContainerSessionList(screenId);

      for (let containerSession of tmpContainerArray) {
        // if target screen has container session, no need to add
        if (targetContainerSessionList.findByContainerId(containerSession.containerId)) {
          continue;
        }
        targetContainerSessionList.push(containerSession);
        log.showDebug(`startMoveSession push persistentId${containerSession.primarySession?.sceneInfo.persistentId}, ` +
          `to screen:${screenId}`);
      }
      log.showInfo(`startMoveSession screenId:${screenId}, containerSessionList len:${targetContainerSessionList.length}`);
    }
  }

  private endMoveSession(sessionChangeInfo: SessionChangeInfo): void {
    log.showInfo(`endMoveSession curScreenId: ${sessionChangeInfo.curScreenId}`);
    let curContainerSessionList: SCBSceneContainerSessionArray =
      SCBSceneSessionManager.getInstance().getContainerSessionList(sessionChangeInfo.curScreenId);

    let tmpContainerArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

    // get containerSession of subwindow in current screen
    for (let id of sessionChangeInfo.persistentIds) {
      let containerSession = curContainerSessionList.findByPersistentId(id, true);
      if (!containerSession) {
        log.showWarn(`moveSubSessionToTargetScreen not find containerSession. persistentId:${id}`);
        continue;
      }
      tmpContainerArray.push(containerSession);
    }

    // add temp container session to other screen for window hot area animation.
    for (let screenSession of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      let screenId: ESObject = screenSession.session.screenId;
      // add container to target screen
      let targetContainerSessionList: SCBSceneContainerSessionArray =
        SCBSceneSessionManager.getInstance().getContainerSessionList(screenId);

      for (let containerSession of tmpContainerArray) {
        // if target screen has container session, no need to remove
        if (targetContainerSessionList.isContainerInScreenHasSession(containerSession.containerId, screenId)) {
          continue;
        }
        let index = targetContainerSessionList.indexOf(containerSession);
        if (index === -1) {
          log.showWarn(`endMoveSession find container failed. containerId:${containerSession.containerId}` +
            `, screenId:${sessionChangeInfo.curScreenId}`);
          continue;
        }
        log.showDebug(`endMoveSession remove:${containerSession.primarySession?.sceneInfo.persistentId}, screenId:${screenId}`);
        targetContainerSessionList.splice(index, 1);
      }
      log.showInfo(`endMoveSession screenId:${screenId}, containerSessionList len:${targetContainerSessionList.length}`);
    }
  }

  private refreshContainerSessionList(sessionChangeInfo: SessionChangeInfo): void {
    log.showInfo(`refreshContainerSessionList`);
    let curContainerSessionList: SCBSceneContainerSessionArray =
      SCBSceneSessionManager.getInstance().getContainerSessionList(sessionChangeInfo.curScreenId);

    let tmpContainerArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

    // get containerSession of subwindow in current screen
    for (let id of sessionChangeInfo.persistentIds) {
      let containerSession = curContainerSessionList.findByPersistentId(id, true);
      if (!containerSession) {
        log.showWarn(`refreshContainerSessionList not find containerSession. persistentId:${id}`);
        continue;
      }
      tmpContainerArray.push(containerSession);
    }
    log.showInfo(`refreshContainerSessionList tmpContainerArray len:${tmpContainerArray.length}`);

    // if containerSession no session in current screen, remove duplicate containerSession
    for (let screen of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      let screenId: ESObject = screen.session.screenId;
      let targetContainerSessionList: SCBSceneContainerSessionArray =
        SCBSceneSessionManager.getInstance().getContainerSessionList(screenId);
      for (let containerSession of tmpContainerArray) {
        // if target screen has container session, no need to remove
        if (targetContainerSessionList.isContainerInScreenHasSession(containerSession.containerId, screenId)) {
          log.showInfo(`refreshContainerSessionList isContainerInScreenHasSession`);
          continue;
        }
        let index = targetContainerSessionList.indexOf(containerSession);
        if (index === -1) {
          log.showWarn(`refreshContainerSessionList find container failed.` +
            `, screenId:${sessionChangeInfo.curScreenId}`);
          continue;
        }
        targetContainerSessionList.splice(index, 1);
        log.showInfo(`refreshContainerSessionList remove:${containerSession?.primarySession?.sceneInfo.persistentId},` +
          `screenId:${screenId}, targetContaienrSessionList len:${targetContainerSessionList.length}`);
      }
    }
  }

  /**
   * main session closed
   * @param containerId main session containerId
   */
  public onMainSessionClosed(containerId: number) {
    // remove containerSession in all screen by containerId
    for (let screen of SCBScreenSessionManager.getInstance().getScreenSessionList()) {
      let screenId: ESObject = screen.session.screenId;
      let targetContainerSessionList: SCBSceneContainerSessionArray =
        SCBSceneSessionManager.getInstance().getContainerSessionList(screenId);
      let index = targetContainerSessionList.findIndexByContainerId(containerId);
      if (index === -1) {
        continue;
      }
      targetContainerSessionList.splice(index, 1);
      log.showInfo(`onMainSessionClosed screenId:${screenId},` +
        `targetContaienrSessionList len:${targetContainerSessionList.length}`);
    }
  }


  /**
   * register controller for SCBSpecificScenePanel
   */
  public registerSpecificSessionController(screenId: number, zorder: number,
    controller: SpecificSessionController) : void {
    log.showInfo(`[SCBSpecific] register, screenId ${screenId}, zorder ${zorder}`);
    if (!this.specificControllerMap.has(screenId)) {
      this.specificControllerMap.set(screenId, new Map());
    }
    this.specificControllerMap.get(screenId)?.set(zorder, controller);
    let sessions = this.specificCacheList.get(screenId)?.get(zorder);
    if (sessions) {
      sessions.forEach((session) => {
        log.showInfo(`[SCBSpecific] recover, screenId ${screenId}, zorder ${zorder}`);
        controller.addSession(session);
      })
      sessions.length = 0;
    }
  }

  /**
   * unregister controller for SCBSpecificScenePanel
   */
  public unRegisterSpecificSessionController(screenId: number, zorder: number) : void {
    if (this.specificControllerMap.get(screenId)?.get(zorder)) {
      this.specificControllerMap.get(screenId)?.delete(zorder);
    }
  }

  //SpecificSessionMap:
  private specificSessionMap: Map<number, SCBSpecificSceneSessionList> = new Map();

  public getSpecificSessionList(zorder: number): SCBSpecificSceneSessionList {
    if (!this.specificSessionMap.has(zorder)) {
      this.specificSessionMap.set(zorder, new SCBSpecificSceneSessionList());
    }
    return this.specificSessionMap.get(zorder)!;
  }

  private moveSpecificSessionToTargetScreen(sessionChangeInfo: SessionChangeInfo): void {
    if (sessionChangeInfo.persistentIds.length !== 1) {
      log.showError('[SCBSpecific] do not move specificSessions in one callback');
      return;
    }
    if (!sessionChangeInfo.sessionType) {
      log.showError('[SCBSpecific] sessionType do not exist, return');
      return;
    }
    let zorder = SCBSceneSessionManager.getInstance().getPanelZorderByType(sessionChangeInfo.sessionType);
    if (zorder === undefined) {
      log.showError('[SCBSpecific] zorder do not exist, return');
      return;
    }
    let targetSession : SCBSpecificSession | undefined = this.getSpecificSessionList(zorder).find((scbSession) => {
      return scbSession?.session.persistentId === sessionChangeInfo.persistentIds[0];
    });
    if (targetSession == null) {
      log.showError('[SCBSpecific] can not find session in current specificScenePanel');
      return;
    }
    let curRect: ESObject = sessionChangeInfo.sessionRectChangeMap.get(targetSession.persistentId)?.newRect;
    if (curRect) {
      targetSession.currRect.setRectNum(curRect.posX_, curRect.posY_, curRect.width_, curRect.height_);
    }
    targetSession.updateDisplayId(sessionChangeInfo.targetScreenId);
  }

  public mergeSpecificSessionList(screenId: number): void {
    let mainScreenId = SCBSceneSessionManager.getInstance().mainScreenId;
    const extendScreenSession: SCBScreenSession | null =
      SCBScreenSessionManager.getInstance().getScreenSession(screenId);
    const mainScreenSession: SCBScreenSession | null = SCBScreenSessionManager.getInstance().getMainScreenSession();
    this.specificSessionMap.forEach((list: SCBSpecificSceneSessionList) => {
      list?.forEach((session: SCBSpecificSession) => {
        this.updateSystemSceneFollowScreen(session, extendScreenSession?.scbScreenProperty,
          mainScreenSession?.scbScreenProperty);
        session?.updateDisplayIdRecursively(mainScreenId, screenId);
      });
    });
    let appSubSessionList = SCBSceneSessionManager.getInstance().getFullScreenSubSessionList();
    appSubSessionList?.forEach((item)=> {
      if (item.screenId === screenId) {
        item.updateDisplayId(mainScreenId);
      }
      item.onUpdateMaximizeRect();
    });
    if (appSubSessionList?.length > 0) {
      SCBSceneSessionManager.getInstance().updateSystemBarProperty();
    }
  }

  private updateSystemSceneFollowScreen(specificSession: SCBSpecificSession,
    oldScreenProperty: SCBScreenProperty | null | undefined,
    newScreenProperty: SCBScreenProperty | null | undefined): void {
    if (!specificSession || !specificSession.isActive || !oldScreenProperty || !newScreenProperty) {
      log.showInfo(`${specificSession.getName()} property not satisfy to process`);
      return;
    }
    const oldSessionRect = specificSession.currRect.copy();
    if (specificSession.screenId === oldScreenProperty.screenId) {
      if (this.isFullScreenSessionNeedFollowScreen(specificSession, oldScreenProperty)) {
        specificSession.updateSizeChangeReason(sceneSessionManager.SessionSizeChangeReason.UNDEFINED);
        specificSession.currRect.setRectNum(newScreenProperty.left, newScreenProperty.top, newScreenProperty.width,
          newScreenProperty.height);
      } else if (this.isNonFullScreenFloatSession(specificSession, oldScreenProperty)) {
        LayoutPolicyHelper.getInstance().handleFreeWindowRect(specificSession.currRect, oldScreenProperty,
          newScreenProperty);
      }
    }
    this.updateSubSession(specificSession, oldScreenProperty, newScreenProperty, oldSessionRect,
      oldScreenProperty.screenId);
    log.showInfo(`merge specific session ${specificSession.getName()}, rect is ` +
      `${specificSession.currRect.printPx()}, isFollowScreenChange ${specificSession.isFollowScreenChange}`);
  }

  private initArea(reason: sceneSessionManager.SessionSizeChangeReason,
    rect: sceneSessionManager.SessionRect, sceneSession: SCBSceneSession | SCBSpecificSession): SCBSessionRect {
    let area: SCBSessionRect = sceneSession.currRect.copy();

    log.showInfo(`initAvoidanceArea start, id: ${sceneSession.session.persistentId}, reason: ${reason},` +
      `newRect: [${rect.posX_}, ${rect.posY_}, ${rect.width_}, ${rect.height_}]` +
      `currRect: [${sceneSession.currRect.left.getPx()}, ${sceneSession.currRect.top.getPx()},` +
      `${sceneSession.currRect.width.getPx()}, ${sceneSession.currRect.height.getPx()}]`);
    if (reason === sceneSessionManager.SessionSizeChangeReason.MOVE) {
      area.left.setNumber(rect.posX_);
      area.top.setNumber(rect.posY_);
    } else if (reason === sceneSessionManager.SessionSizeChangeReason.RECOVER ||
      reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END) {
      area.left.setNumber(rect.posX_);
      area.top.setNumber(rect.posY_);
      area.width.setNumber(rect.width_);
      area.height.setNumber(rect.height_);
    }

    return area;
  }

  private onSessionRectChange(sessionRectChangeInfo: SessionRectChangeInfo, sessionChangeInfo: SessionChangeInfo,
    containerSession: SCBSceneContainerSession, persistentId: number,
    containerSessionList: SCBSceneContainerSessionArray, isMainSession: boolean): void {
    let displayId: number = sessionChangeInfo.targetScreenId;
    if (!containerSession) {
      log.showWarn('onSessionRectChange containerSession is null');
      return;
    }

    let session: SCBSceneSession | SCBSpecificSession | null =
      containerSessionList.getSessionByPersistentId(persistentId);
    if (session === null) {
      log.showWarn('onSessionRectChange session is null');
      return;
    }

    let rect = sessionRectChangeInfo.newRect;
    let reason = sessionRectChangeInfo.reason;

    if (!rect) {
      log.showWarn('onSessionRectChange rect is null');
      return;
    }

    let area: SCBSessionRect = this.getTargetSessionLayout(rect, sessionChangeInfo, session, reason);

    if (session instanceof SCBSceneSession) {
      if (session.sceneInfo.windowMode === SCBSceneMode.FULLSCREEN &&
        reason === sceneSessionManager.SessionSizeChangeReason.MOVE && session.isRecoveredFullScreen) {
        log.showInfo('recovered fullscreen sceneSession cannot move');
        return;
      }
    }

    if (session instanceof SCBSpecificSession && (session as SCBSpecificSession).subWindowAnchorInfo.isFollowParent) {
      this.updateSessionScreenId(persistentId, containerSession, containerSessionList,
        sessionChangeInfo, isMainSession);
      return;
    }

    let context: UIContext | undefined = this.contextMap.get(displayId);
    if (!session.sessionData.isDragging && context) {
      context.animateTo({
        duration: 0,
      }, () => {
        this.updateCurrentRect(area, session);
        this.updateSessionScreenId(persistentId, containerSession, containerSessionList,
          sessionChangeInfo, isMainSession);
      })
    } else {
      this.updateCurrentRect(area, session);
      this.updateSessionScreenId(persistentId, containerSession, containerSessionList,
        sessionChangeInfo, isMainSession);
    }
    log.showInfo(`onSessionRectChange end, id: ${session.session.persistentId}, reason: ${reason}` +
      `rect: [${session.currRect.left.getPxStr()}, ${session.currRect.top.getPxStr()}, ` +
      `${session.currRect.width.getPxStr()}, ${session.currRect.height.getPxStr()}]`);
  }

  private getTargetSessionLayout(targetRect: sceneSessionManager.SessionRect, sessionChangeInfo: SessionChangeInfo,
    session: SCBSceneSession | SCBSpecificSession,
    reason: sceneSessionManager.SessionSizeChangeReason): SCBSessionRect {
    let area: SCBSessionRect = this.initArea(reason, targetRect, session);
    if (!this.isNeedUpdateSessionRect(session, sessionChangeInfo.targetScreenId)) {
      return area;
    }

    let anchor: Pointer2D = this.getAnchor(session, area, reason);
    this.updateRectWithDpiChange(area, sessionChangeInfo.curScreenId, sessionChangeInfo.targetScreenId,
      undefined, anchor);

    log.showInfo(`getTargetSessionLayout end. ` +
      `area:[${area.left.getPxStr()}, ${area.top.getPxStr()}, ${area.width.getPxStr()}, ${area.height.getPxStr()}]`);

    return area;
  }

  private getAnchor(session: SCBSceneSession | SCBSpecificSession, targetArea: SCBSessionRect,
    reason: sceneSessionManager.SessionSizeChangeReason): Pointer2D {
    // 拖拽场景以鼠标松手位置为缩放锚点
    if (reason === sceneSessionManager.SessionSizeChangeReason.DRAG_END) {
      return new Pointer2D(session.currMovePointerPos.pointerPosX, targetArea.top.getPx());
    } else if (reason === sceneSessionManager.SessionSizeChangeReason.MOVE) {
      // moveTo场景以窗口左上角进行缩放
      return new Pointer2D(targetArea.left.getPx(), targetArea.top.getPx());
    } else {
      // 默认以窗口左上角为锚点进行缩放
      return new Pointer2D(targetArea.left.getPx(), targetArea.top.getPx());
    }
  }

  public updateRectWithDpiChange(rect: SCBSessionRect, srcScreenId: number, targetScreenId: number,
    tarDensity?: number, anchor?: Pointer2D): void {
    log.showDebug(`updateRectWithDpiChange start update rect:[${rect.left.getPxStr()}, ${rect.top.getPxStr()}, ` +
      `${rect.width.getPxStr()}, ${rect.height.getPxStr()}], ` +
      `srcScreenId:${srcScreenId}, targetScreenId:${targetScreenId}, tarDensity:${tarDensity}`);

    let srcDensity: number | undefined = this.screenDensityMap.get(srcScreenId);
    let targetDensity: number | undefined = tarDensity !== undefined ? tarDensity :
      this.screenDensityMap.get(targetScreenId);
    if (!srcDensity || !targetDensity) {
      log.showWarn(`updateRectWithDpiChange failed. srcDensity:${srcDensity}, targetDensity:${targetDensity}`);
      return;
    }

    if (srcDensity === targetDensity) {
      log.showInfo(`updateRectWithDpiChange density not change`);
      return;
    }

    // 以鼠标所在x坐标为中心做横向缩放
    if (srcDensity === 0) {
      log.showError(`updateRectWithDpiChange srcDensity is 0. Error!`);
      return;
    }
    let scaleRatio: number = targetDensity / srcDensity;
    LayoutPolicyHelper.getInstance().updateRectWithDensityChange(rect, scaleRatio, anchor);
  }

  private isNeedUpdateSessionRect(session: SCBSceneSession | SCBSpecificSession, targetScreenId: number): boolean {
    if (session instanceof SCBSceneSession) {
      if (session.defaultDensityEnabled) {
        log.showInfo(`use default density. ` +
          `session id:${session.sceneInfo.persistentId}, screenId:${session.sceneInfo.screenId}`)
        return false;
      }

      // 跨屏时触发最大化或分屏流程时，窗口大小不需要跟随DPI变化
      return !session.isNeedHandleWindowDragHotArea(targetScreenId);
    }
    return true;
  }

  private updateCurrentRect(area: SCBSessionRect, session: SCBSceneSession | SCBSpecificSession | null): void {
    if (!session) {
      return;
    }
    if ((area.left.getPx() !== session.currRect.left.getPx()) ||
      (area.top.getPx() !== session.currRect.top.getPx())) {
      session.currRect.setPos(area.left, area.top);
    }
    if ((area.width.getPx() !== session.currRect.width.getPx()) ||
      (area.height.getPx() !== session.currRect.height.getPx())) {
      session.currRect.setSize(area.width, area.height);
    }
  }

  /**
   * set scene borderRadius when clear scene
   * @param scene responds to clear scene
   * @param scale control borderRadius scale
   * @param currentPercent current scene's clear progress
   */
  public setSceneBorderRadiusInClearScene(scene: SCBSceneContainerSession | SCBSpecificSession,
    scale: number, currentPercent: number): void {
    if (!scene || scene instanceof SCBSpecificSession) {
      return;
    }
    if (scene instanceof SCBSceneContainerSession) {
      const sceneBorderRadius = SCBWindowSceneConfig.getInstance().windowSceneConfig.floatCornerRadius * scale;
      if (scene.primarySession !== null && scene.primarySession.sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
        scene.primarySession.floatBorderRadius = sceneBorderRadius;
        if (scale === 0 || (scale === 1 && currentPercent === 1)) {
          log.showInfo(`${scene.primarySession.getName()} is set boardRadius in clear scene is: ${sceneBorderRadius}`);
        }
      }
      if (scene.secondarySession !== null && scene.secondarySession.sceneInfo.windowMode !== SCBSceneMode.FLOATING) {
        scene.secondarySession.floatBorderRadius = sceneBorderRadius;
      }
    }
  }

  /**
   * reSet scene borderRadius while into recent
   * @param scenes function queryFrontForWIND result
   */
  public resetSceneBorderRadiusIntoRecent(scenes: Array<SCBSceneContainerSession | SCBSpecificSession> = []): void {
    if (scenes.length <= 0) {
      return;
    }
    for (const scene of scenes) {
      this.setSceneBorderRadiusInClearScene(scene, 0, 1);
    }
  }

  /**
   * recover visibility in clearScene while into recent
   * @param frontScenes scenes in clearScene Operation
   */
  public recoverVisibilityInClearScene(frontScenes: Array<SCBSceneContainerSession | SCBSpecificSession>) {
    if (frontScenes.length <= 0) {
      return;
    }
    for (const scene of frontScenes) {
      this.setSceneBorderRadiusInClearScene(scene, 0, 1);
      if (scene instanceof SCBSceneContainerSession && scene.isActive) {
        scene.needRenderVisibility.setVisibilityWithDfx(true, TAG, 'recoverVisibilityIntoRecent',
          scene.getName());
      }
    }
  }

  /**
   * 注册获取是否待分屏状态事件
   *
   * @param callback
   * @param screenId
   */
  public registerGetIsPairSplitCallback(callback: Function, screenId: number): void {
    this.getIsPairSplitCallbackMap.set(screenId, callback);
  }

  /**
   * 反注册获取是否待分屏状态事件
   *
   * @param screenId
   */
  public unRegisterGetIsPairSplitCallback(screenId: number): void {
    this.getIsPairSplitCallbackMap.delete(screenId);
  }

  /**
   * 获取是否待分屏状态
   *
   * @param screenId
   * @returns
   */
  public getIsPairSplit(screenId: number): boolean {
    let getIsPairSplitCallback = this.getIsPairSplitCallbackMap.get(screenId);
    if (getIsPairSplitCallback) {
      return getIsPairSplitCallback();
    }
    return false;
  }

  /**
   * 注册UI上下文
   *
   * @param context
   * @param screenId
   */
  public registerUIContext(context: UIContext, screenId: number) {
    if (screenId !== INVALID_SCREENID && context) {
      this.contextMap.set(screenId, context);
    }
  }

  public unregisterUIContext(screenId: number) {
    if (screenId !== INVALID_SCREENID) {
      this.contextMap.delete(screenId);
    }
  }

  /**
   * 注册给对应screen的containerSessionListNotShowRecent添加containerSession事件
   *
   * @param callback
   * @param screenId
   */
  public registerAddListNotShowRecentCallback(callback: Function, screenId: number): void {
    this.addListNotShowRecentCallbackMap.set(screenId, callback);
  }

  /**
   * 解注册给对应screen的containerSessionListNotShowRecent添加containerSession事件
   *
   * @param screenId
   */
  public unRegisterAddListNotShowRecentCallback(screenId: number): void {
    this.addListNotShowRecentCallbackMap.delete(screenId);
  }

  /**
   * 给对应screen的containerSessionListNotShowRecent添加containerSession
   *
   * @param screenId
   * @returns
   */
  private addListNotShowRecent(screenId: number, containerSession: SCBSceneContainerSession): void {
    let addListNotShowRecentCallback = this.addListNotShowRecentCallbackMap.get(screenId);
    if (addListNotShowRecentCallback) {
      addListNotShowRecentCallback(containerSession);
    }
  }

  /**
   * 注册给对应screen的containerSessionListNotShowRecent删除containerSession事件
   *
   * @param callback
   * @param screenId
   */
  public registerRemoveListNotShowRecentCallback(callback: Function, screenId: number): void {
    this.removeListNotShowRecentCallbackMap.set(screenId, callback);
  }

  /**
   * 解注册给对应screen的containerSessionListNotShowRecent删除containerSession事件
   *
   * @param screenId
   */
  public unRegisterRemoveListNotShowRecentCallback(screenId: number): void {
    this.removeListNotShowRecentCallbackMap.delete(screenId);
  }

  /**
   * 从对应screen的containerSessionListNotShowRecent删除containerSession
   *
   * @param screenId
   * @returns
   */
  private removeListNotShowRecent(screenId: number, containerSession: SCBSceneContainerSession): void {
    let removeListNotShowRecentCallback = this.removeListNotShowRecentCallbackMap.get(screenId);
    if (removeListNotShowRecentCallback) {
      removeListNotShowRecentCallback(containerSession);
    }
  }

  /**
   * 注册对应screen的SceneHiddenModeVisChange回调函数
   *
   * @param callback
   * @param screenId
   */
  public registerSceneHiddenModeVisChangeCallback(callback: Function, screenId: number): void {
    this.sceneHiddenModeVisChangeCallbackMap.set(screenId, callback);
  }

  /**
   * 解注册对应screen的SceneHiddenModeVisChange回调函数
   *
   * @param screenId
   */
  public unRegisterSceneHiddenModeVisChangeCallback(screenId: number): void {
    this.sceneHiddenModeVisChangeCallbackMap.delete(screenId);
  }

  /**
   * 调用对应screen的onSceneHiddenModeVisChange
   *
   * @param screenId
   * @returns
   */
  private sceneHiddenModeVisChange(screenId: number, containerSession: SCBSceneContainerSession,
    visible?: boolean, isFromClient?: boolean): void {
    let sceneHiddenModeVisChangeCallback = this.sceneHiddenModeVisChangeCallbackMap.get(screenId);
    if (sceneHiddenModeVisChangeCallback) {
      sceneHiddenModeVisChangeCallback(containerSession, visible, isFromClient);
    }
  }

  /**
   * move containerSession to another screen for display
   *
   * @param containerSession
   * @param fromScreenId
   * @param toScreenId
   * @param visible
   * @param isFromClient
   * @returns
   */
  public moveContainerSessionToAnotherScreenForDisplay(containerSession: SCBSceneContainerSession,
    fromScreenId: number, toScreenId: number, visible?: boolean, isFromClient?: boolean): void {
    let targetScreenProperty = this.getTargetScreenProperty(toScreenId);
    if (!targetScreenProperty) {
      log.showError(`get targetScreenProperty failed!`);
      return;
    }
    this.removeListNotShowRecent(fromScreenId, containerSession);
    this.updateExtendContainerSession(containerSession, targetScreenProperty);
    this.addListNotShowRecent(toScreenId, containerSession);
    this.sceneHiddenModeVisChange(toScreenId, containerSession, visible, isFromClient);
  }

  /**
   * update containerSession when changeMode
   *
   * @param containerSession
   * @param screenProperty
   */
  public updateContainerSessionWithChangeMode(containerSession: SCBSceneContainerSession,
    originScreenProperty: SCBScreenProperty, targetScreenProperty: SCBScreenProperty, targetDensity: number): void {
    log.showInfo(`updateContainerSessionWithChangeMode`);
    let oldScreenProperty = new SCBScreenProperty();
    oldScreenProperty.copy(containerSession.screenProperty);
    if (containerSession.screenProperty.screenId === targetScreenProperty.screenId) {
      containerSession.updateScreenProperty(targetScreenProperty);
    } else {
      // 子窗和主窗不在一个屏幕，需要用originScreenProperty作为oldScreenProperty
      oldScreenProperty.copy(originScreenProperty);
    }
    if (containerSession.primarySession) {
      log.showInfo(`updateContainerSessionWithChangeMode primarySession ` +
        `persistentId: ${containerSession.primarySession.sceneInfo.persistentId},` +
        `bundleName: ${containerSession.primarySession.sceneInfo.bundleName}`);
      const oldMainRect: SCBSessionRect = containerSession.primarySession.currRect.copy();
      if (containerSession.screenProperty.screenId === targetScreenProperty.screenId) {
        this.doUpdateFreeAndFullSession(containerSession, oldScreenProperty, targetScreenProperty, targetDensity);
      }
      log.showInfo(`updateContainerSessionWithChangeMode: ` +
        `sceneSession: ${containerSession.primarySession.getName()}, ` +
        `rect from ${oldMainRect.printPx()} change to ${containerSession.primarySession.currRect.printPx()}`);
      this.updateSubSession(containerSession.primarySession, oldScreenProperty, targetScreenProperty, oldMainRect,
        containerSession.screenProperty.screenId, targetDensity);
    }
    this.updateSplitSessionWithChangeMode(containerSession, oldScreenProperty, targetScreenProperty);
  }

  private doUpdateFreeAndFullSession(containerSession: SCBSceneContainerSession,
    oldScreenProperty: SCBScreenProperty, targetScreenProperty: SCBScreenProperty, targetDensity?: number): void {
    if (!containerSession.primarySession) {
      return;
    }
    let windowMode = containerSession.primarySession.sceneInfo.windowMode;
    switch (windowMode) {
      case SCBSceneMode.FLOATING:
        if (this.isNeedUpdateSessionRect(containerSession.primarySession, targetScreenProperty.screenId)) {
          this.updateRectWithDpiChange(containerSession.primarySession.currRect, oldScreenProperty.screenId,
            targetScreenProperty.screenId, targetDensity);
        }
        LayoutPolicyHelper.getInstance().handleFreeWindowRect(containerSession.primarySession.currRect,
          oldScreenProperty, targetScreenProperty, containerSession.primarySession);
        let curDensity: number | undefined = targetDensity !== undefined ? targetDensity :
          this.screenDensityMap.get(targetScreenProperty.screenId);
        if (curDensity !== undefined) {
          containerSession.primarySession.sessionData.lastDpi = curDensity;
        }
        break;
      case SCBSceneMode.FULLSCREEN:
        LayoutPolicyHelper.getInstance().handleFullScreenWindowRect(containerSession.primarySession,
          oldScreenProperty, targetScreenProperty);
        break;
      default:
        break;
    }
  }

  private updateSplitSessionWithChangeMode(containerSession: SCBSceneContainerSession,
    oldScreenProperty: SCBScreenProperty, screenProperty: SCBScreenProperty): void {
    if (containerSession.isSplit && containerSession.secondarySession) {
      if (containerSession.screenProperty.screenId === screenProperty.screenId) {
        this.doUpdateSplitSession(containerSession, screenProperty);
      }
      if (containerSession.primarySession) {
        if (containerSession.screenProperty.screenId === screenProperty.screenId) {
          LayoutPolicyHelper.getInstance().handleFreeWindowRect(containerSession.primarySession.lastRect,
            oldScreenProperty, screenProperty, containerSession.primarySession);
        }
      }
      const oldMainRect: SCBSessionRect = containerSession.secondarySession.currRect.copy();
      if (containerSession.screenProperty.screenId === screenProperty.screenId) {
        LayoutPolicyHelper.getInstance().handleFreeWindowRect(containerSession.secondarySession.lastRect,
          oldScreenProperty, screenProperty);
      }
      this.updateSubSession(containerSession.secondarySession, oldScreenProperty, screenProperty, oldMainRect,
        containerSession.screenProperty.screenId);
    }
  }

  private doUpdateSplitSession(containerSession: SCBSceneContainerSession, screenProperty: SCBScreenProperty): void {
    const primaryWidth = Number.parseFloat(containerSession.dividerParam.primary.width);
    const secondaryWidth = Number.parseFloat(containerSession.dividerParam.secondary.width);
    const ratios = primaryWidth / (primaryWidth + secondaryWidth);
    let uiContext: UIContext | undefined = this.contextMap.get(screenProperty.screenId);
    const splitSceneWidth = screenProperty.width -
      SCBSystemSceneUtils.getInstance().vp2px(uiContext, DividerStyle.DIVIDER_WIDTH);
    let priTargetWidth = ratios * splitSceneWidth;
    let secTargetWidth = (1 - ratios) * splitSceneWidth;
    const newPriTargetWidth = LayoutPolicyHelper.getInstance().calculatePrimaryWidthBySplitMinWidth(
      containerSession, screenProperty, priTargetWidth, secTargetWidth);
    secTargetWidth = priTargetWidth + secTargetWidth - newPriTargetWidth;
    priTargetWidth = newPriTargetWidth;
    log.showInfo(`doUpdateSplitSession priTargetWidth: ${priTargetWidth},` +
      ` secTargetWidth: ${secTargetWidth}`);
    let topThreshold = this.getTopThreshold(screenProperty.screenId);
    let bottomThreshold = this.getBottomThreshold(screenProperty);
    containerSession.dividerParam.primary.width = (priTargetWidth / screenProperty.width * 100).toString() + '%';
    containerSession.dividerParam.secondary.width = (secTargetWidth / screenProperty.width * 100).toString() + '%';
    containerSession.dividerParam.primary.height = (bottomThreshold - topThreshold) / screenProperty.height * 100 + '%';
    containerSession.dividerParam.secondary.height = containerSession.dividerParam.primary.height;
    SCBSplitLayoutHelper.refreshSplitContainer(containerSession, screenProperty, undefined);
    if (containerSession.primarySession && containerSession.secondarySession) {
      containerSession.dividerParam.positionX = `${containerSession.isSplitPrimaryMode() ?
        SCBSystemSceneUtils.getInstance().px2vp(uiContext, containerSession.primarySession.currRect.width.getPx()) :
        SCBSystemSceneUtils.getInstance().px2vp(uiContext, containerSession.secondarySession.currRect.width.getPx())}`;
      containerSession.dividerParam.positionY = `${SCBSystemSceneUtils.getInstance().px2vp(uiContext, topThreshold)}`;
      containerSession.dividerParam.dividerWidth = DividerStyle.DIVIDER_WIDTH;
      containerSession.dividerParam.dividerHeight = SCBSystemSceneUtils.getInstance()
        .px2vp(uiContext, bottomThreshold - topThreshold);
    }
  }

  /**
   * check whether is full screen size session which need to follow screen change, including two cases:
   * 1. full screen size session whose isFollowScreenChange flag is true
   * 2. full screen size session whose type is TYPE_FLOAT
   *
   * @param specificSession subsession
   * @param screenProperty target screen property
   */
  public isFullScreenSessionNeedFollowScreen(specificSession: SCBSpecificSession,
    screenProperty: SCBScreenProperty): boolean {
    const isSessionFullScreen: boolean =
      LayoutPolicyHelper.getInstance().isFullScene(specificSession.currRect, screenProperty);
    return isSessionFullScreen && (specificSession.isFollowScreenChange ||
      specificSession.session?.type === sceneSessionManager.SessionType.TYPE_FLOAT)
  }

  /**
   * check whether is non-full screen size session whose type is TYPE_FLOAT, indicating pip case
   *
   * @param specificSession subsession
   * @param screenProperty target screen property
   */
  public isNonFullScreenFloatSession(specificSession: SCBSpecificSession, screenProperty: SCBScreenProperty): boolean {
    const isSessionFullScreen: boolean =
      LayoutPolicyHelper.getInstance().isFullScene(specificSession.currRect, screenProperty);
    return specificSession.session?.type === sceneSessionManager.SessionType.TYPE_FLOAT && !isSessionFullScreen;
  }

  /**
   * move hidden containerSession to another screen for display
   *
   * @param containerSession
   * @param fromScreenId
   * @param toScreenId
   */
  public moveHiddenSessionToAnotherScreenForDisplay(containerSession: SCBSceneContainerSession, fromScreenId: number,
    toScreenId: number) {
    this.removeListNotShowRecent(fromScreenId, containerSession);
    containerSession.primarySession?.updateDisplayId(toScreenId);
    if (containerSession.screenProperty) {
      containerSession.screenProperty.screenId = toScreenId;
    }
    this.addListNotShowRecent(toScreenId, containerSession);
  }

  public updateDensity(screenId: number, density: number): void {
    this.screenDensityMap.set(screenId, density);
  }

  private initListener() {
    try {
      display.on('change', (displayId: number) => { this.notifyDisplayChange(displayId) });
    } catch (error) {
      log.showError(`ondisplaychenge error.code: ${error?.code}, error.message: ${error?.message}`);
    }
  }

  private notifyDisplayChange(displayId: number): void {
    log.showInfo(`notifyDisplayChange displayId:${displayId}`);
    let callback = this.displayChangeCallbackMap.get(displayId);
    if (!callback) {
      log.showError(`notifyDisplayChange get callback failed. displayId:${displayId}`);
      return;
    }
    callback();
  }

  /**
   * 注册display变化监听
   * @param callback
   * @param screenId
   */
  public registerDisplayChangeCallback(callback: Function, screenId: number): void {
    if (!callback) {
      log.showWarn(`registerDisplayChangeCallback failed. screenId:${screenId}`);
      return;
    }
    this.displayChangeCallbackMap.set(screenId, callback);
  }

  /**
   * 解注册display变化监听
   * @param screenId
   */
  public unregisterDisplayChangeCallback(screenId: number): void {
    this.displayChangeCallbackMap.delete(screenId);
  }
}