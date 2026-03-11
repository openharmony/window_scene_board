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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneSession } from '../session/SCBSceneSession';
import { SCBSpecificSession } from '../session/SCBSpecificSession';
import { SCBSystemSceneSession } from '../session/SCBSystemSceneSession';

const TAG = 'SCBWindowFocusController';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const INVALID_PERSISTENT_ID: number = 0;

export const DEFAULT_DISPLAY_GROUP_ID: number = 0;

interface FocusGroup {
  focusedSessionId: number;
  focusedSession?: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession;
  lastFocusedSessionId: number;
  displayGroupId: number;
  displayIds:Set<number>
}

export class SCBWindowFocusController {
  private focusGroupMap: Map<number, FocusGroup> = new Map();
  private displayId2GroupIdMap: Map<number, number> = new Map();

  constructor() {
    this.addFocusGroup(DEFAULT_DISPLAY_GROUP_ID, DEFAULT_DISPLAY_GROUP_ID);
  }

  /**
   * get focus display group id
   *
   * @param displayId
   * @returns displayGroupId
   */
  public getDisplayGroupId(displayId: number): number {
    if (displayId === DEFAULT_DISPLAY_GROUP_ID) {
      return DEFAULT_DISPLAY_GROUP_ID;
    }
    if(this.displayId2GroupIdMap.has(displayId)){
      return this.displayId2GroupIdMap.get(displayId);
    }
    return DEFAULT_DISPLAY_GROUP_ID;
  }

  /**
   * add focus group
   *
   * @param displayGroupId displayId of screenSession
   * @param isVirtual  virtual screen or not
   */
  public addFocusGroup(displayId: number, displayGroupId: number): void {
    log.showInfo(`addFocusGroup displayId: ${displayId}, displayGroupId: ${displayGroupId}`);
    this.displayId2GroupIdMap.set(displayId, displayGroupId);
    if (!this.focusGroupMap.has(displayGroupId)) {
      this.focusGroupMap.set(displayGroupId, {
        focusedSessionId: INVALID_PERSISTENT_ID,
        lastFocusedSessionId: INVALID_PERSISTENT_ID,
        focusedSession: null,
        displayGroupId,
        displayIds: new Set()
      });
    }
    const focusGroup = this.focusGroupMap.get(displayGroupId);
    focusGroup.displayIds.add(displayId);
  }

  /**
   * remove focus group
   *
   * @param displayGroupId displayId of screenSession
   */
  public removeFocusGroup(displayId:number, displayGroupId: number): void {
    log.showInfo(`removeFocusGroup displayId: ${displayId}, displayGroupId: ${displayGroupId}`);
    if(this.focusGroupMap.has(displayGroupId)){
      const focusGroup = this.focusGroupMap.get(displayGroupId);
      focusGroup.displayIds.delete(displayId);
      if(focusGroup.displayIds.size === 0 ){
        this.removeFocusedGroup(displayGroupId);
      }
      log.showInfo(`removeFocusGroup success. displayId: ${displayGroupId}`);
    }else{
      log.showError(`displayGroupId invalid, displayId: ${displayId}, displayGroupId: ${displayGroupId}`);
    }
    this.displayId2GroupIdMap.delete(displayId);
  }

  /**
   * set focused session
   *
   * @param displayGroupId displayId of session
   * @param focusedSessionId sessionId of focused session
   * @param lastFocusedSessionId sessionId of last focused session
   * @param focusedSession focused session
   */
  public setFocusedSession(displayGroupId: number, focusedSessionId: number, lastFocusedSessionId: number,
    focusedSession?: SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession): void {
    log.showInfo(`setFocusedSession, displayGroupId: ${displayGroupId}, sessionId: ${focusedSessionId}, displayId: ${displayGroupId}, screenId: ${focusedSession?.session.screenId}`);
    let displayIds: Set<number> = new Set();
    if(this.focusGroupMap.has(displayGroupId)){
      displayIds = this.focusGroupMap.get(displayGroupId).displayIds;
    }
    if(focusedSession?.session.screenId){
      displayIds.add(focusedSession?.session.screenId);
    }
    this.focusGroupMap.set(displayGroupId, {
      focusedSessionId,
      lastFocusedSessionId,
      focusedSession,
      displayGroupId,
      displayIds
    });
    
  }

  /**
   * remove focused group from map
   *
   * @param displayGroupId
   */
  public removeFocusedGroup(displayGroupId: number): void {
    log.showDebug(`removeFocusedGroup displayGroupId: ${displayGroupId}`);
    this.focusGroupMap.delete(displayGroupId);
  }

  /**
   * get focus group from map
   *
   * @param displayId
   * @returns focus group
   */
  public getFocusGroup(displayId: number): FocusGroup | null {
    const displayGroupId = this.getDisplayGroupId(displayId);
    log.showDebug(`getFocusGroup displayId:${displayId} displayGroupId: ${displayGroupId}`);
    const focusGroup = this.focusGroupMap.get(displayGroupId);
    if (!focusGroup) {
      log.showError(`get focus group fail, displayId: ${displayId}`);
      return null;
    }
    return focusGroup;
  }

  /**
   * get focus group from map
   *
   * @param displayGroupId
   * @returns focus group
   */
  public getFocusGroupByGroupId(displayGroupId: number): FocusGroup | null {
    log.showDebug(`getFocusGroup displayGroupId: ${displayGroupId}`);
    const focusGroup = this.focusGroupMap.get(displayGroupId);
    if (!focusGroup) {
      log.showError(`get focus group fail, displayGroupId: ${displayGroupId}`);
      return null;
    }
    return focusGroup;
  }

  /**
   * get focused session
   *
   * @param displayId
   * @returns focused session
   */
  public getFocusedSession(displayId: number): SCBSceneSession | SCBSpecificSession | SCBSystemSceneSession | null {
    log.showDebug(`getFocusedSession displayId: ${displayId}`);
    const focusGroup = this.getFocusGroup(displayId);
    return focusGroup?.focusedSession || null;
  }

  /**
   * get focused sceneSession
   *
   * @param displayId
   * @returns focused sceneSession
   */
  public getFocusedSceneSession(displayId: number): SCBSceneSession | null {
    const focusGroup = this.getFocusGroup(displayId);
    if (!focusGroup) {
      return null;
    }
    const focusedSession = focusGroup.focusedSession;
    if (focusedSession instanceof SCBSceneSession) {
      return focusedSession;
    }
    if (focusedSession instanceof SCBSpecificSession) {
      return focusedSession.getParentSession();
    }
    return null;
  }

  /**
   * get focused session id
   *
   * @param displayId
   * @returns focused session id
   */
  public getFocusedSessionId(displayId: number): number {
    const focusGroup = this.getFocusGroup(displayId);
    log.showDebug(`getFocusedSessionId: ${focusGroup?.focusedSessionId}`);
    return focusGroup?.focusedSessionId || INVALID_PERSISTENT_ID;
  }

  /**
   * get last focused session id
   *
   * @param displayId
   * @returns last focused session id
   */
  public getLastFocusedSessionId(displayId: number): number {
    const focusGroup = this.getFocusGroup(displayId);
    log.showDebug(`getLastFocusedSessionId: ${focusGroup?.lastFocusedSessionId}`);
    return focusGroup?.lastFocusedSessionId || INVALID_PERSISTENT_ID;
  }
}

