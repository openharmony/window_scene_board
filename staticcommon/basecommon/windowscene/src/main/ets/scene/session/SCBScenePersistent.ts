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


import Fileio from '@ohos.fileio';
import type sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneSessionManager } from './SCBSceneSessionManager';
import { SCBSceneContainerSession } from './SCBSceneContainerSession';
import { SCBSceneInfo } from './SCBSceneInfo';
import { SCBSceneSession } from './SCBSceneSession';
import type { SCBSceneContainerSessionArray } from './SCBSceneContainerSession';
import { SCBSceneMissionManager } from '../manager/SCBSceneMissionManager';
import { SCBScreenProperty } from '../../screen/session/SCBScreenSession';
import { RotationConstants } from '@ohos/commonconstants';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { ArrayUtils } from '@ohos/basicutils';
import type ctx from '@ohos.app.ability.common';
import { RdbStorePersistManager } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '../../screen/session/SCBScreenSessionManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ContainerDataCategory } from '../common/SCBSceneEnums';
import { SCBAppUseControlManager, ControlType } from '../appUseControl/SCBAppUseControlManager';

const TAG = 'SCBScenePersistent';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const OPEN_FLAGS = 0o1101;
const OPEN_MODE = 0o640;
const READ_RDB_MODE = true;

interface PersistentSceneInfo {
  bundleName: string;
  abilityName: string;
  moduleName: string;
  appIndex: number;
  persistentId: number;
  rotation: number;
  isAlive: boolean;
  isLockedInRecent: boolean; // is session locked in recent by user
  lastUsedPosition: string;
  label: string;
  lastUsedTimestamp: number;
  hasPrivacyModeControl: boolean;
}

/**
 * Session persistent class
 */
export class SCBScenePersistent {
  private scbPersistentMap = new Map();
  private scbPersistentCacheMap = new Map<number, PersistentSceneInfo>(); // Only use during recovery
  private currentUserId: number = -1;
  private isRecoverFinished: boolean = false;
  private persistentExceptList: string[] = [];
  private hasRecover_ = false;

  /**
   * Recover session persistent
   *
   * @param { SCBSceneContainerSessionArray } containerSessionList
   * @param { SCBScreenProperty } screenProperty Screen
   */
  public async recoverSessionList(containerSessionList: SCBSceneContainerSessionArray,
    screenProperty: SCBScreenProperty, callback?: Function): Promise<void> {
    await this.readPersistContent(containerSessionList, screenProperty);
    SCBSceneMissionManager.getInstance().notifyPersistentRecoverFinished();
    callback(false);
    this.isRecoverFinished = true;
    this.scbPersistentCacheMap.clear();
  }

  public set hasRecover(hasRecover: boolean) {
    this.hasRecover_ = hasRecover;
  }

  public get hasRecover(): boolean {
    return this.hasRecover_;
  }

  /**
   * Delete persistent hashmap element
   *
   * @param { Number } persistentId
   */
  public deletePersistentMapElement(persistentId: number): void {
    log.showWarn(`delete from persistentMap, persistentId: ${persistentId}`);
    this.scbPersistentMap.delete(persistentId);
    this.saveSCBSceneInfoToJson();
  }

  /**
   * Read persistent data as PersistentSceneInfo json array
   *
   * @returns { Promise<Array<PersistentSceneInfo>> }
   */
  public async readPersistentJsonArray(): Promise<Array<PersistentSceneInfo>> {
    try {
      let strData: string = null;
      if (READ_RDB_MODE) { //read RDB mode
        strData = await this.queryPersistData(this.currentUserId);
      } else { //read TXT mode
        if (!this.isExisted(this.getPersistentFileAbsPath())) {
          log.showWarn('get persistent file failed.');
          return [];
        }
        strData = Fileio.readTextSync(this.getPersistentFileAbsPath(), {});
      }

      if (strData == null) {
        log.showWarn('read persist data is null');
        return [];
      }
      const jsonArray = JSON.parse(strData);
      if (ArrayUtils.isEmpty(jsonArray)) {
        log.showWarn('parse persistent info failed.');
        return [];
      }

      let sceneInfoDataArray = [];
      for (const data of jsonArray) {
        const sceneInfoData: PersistentSceneInfo = {
          bundleName: data.bundleName,
          moduleName: data.moduleName,
          abilityName: data.abilityName,
          appIndex: data.appIndex,
          persistentId: data.persistentId,
          rotation: data.rotation ?? 0,
          isAlive: data.isAlive,
          isLockedInRecent: data.isLockedInRecent,
          lastUsedPosition: data.lastUsedPosition,
          label: data.label,
          lastUsedTimestamp: data.lastUsedTimestamp,
          hasPrivacyModeControl: data.hasPrivacyModeControl,
        };
        sceneInfoDataArray.push(sceneInfoData);
        if (!this.isRecoverFinished) {
          this.scbPersistentCacheMap.set(sceneInfoData.persistentId, sceneInfoData);
        }
      }
      return sceneInfoDataArray;
    } catch (err) {
      log.showError(`Failed to fetch persistent json array, message : ${err.message}, code : ${err.code}`);
      return [];
    }
  }

  /**
   * Set Session isLock Status
   *
   * @param { Number } persistentId
   * @param { Boolean } isLock
   */
  public setLockInRecentStatus(persistentId: number, isLock: boolean): void {
    let sceneInfoData = this.scbPersistentMap.get(persistentId);
    if (!sceneInfoData) {
      log.showWarn(`PersistentId:${persistentId} does not exist in scbPersistentMap.`);
      return;
    }
    log.showInfo(`Set persistentId:${persistentId} ${sceneInfoData.isLockedInRecent} isLock to ${isLock}`);
    if (sceneInfoData.isLockedInRecent === isLock) {
      log.showWarn('The lock status remains unchanged');
      return;
    }
    sceneInfoData.isLockedInRecent = isLock;
    this.saveSCBSceneInfoToJson();
  }

  /**
   * Get Session cache isLock Status
   *
   * @param { Number } persistentId
   */
  public getCacheLockInRecentStatus(persistentId: number): boolean {
    let sceneInfoData = this.scbPersistentCacheMap.get(persistentId);
    if (!sceneInfoData) {
      log.showWarn(`PersistentId:${persistentId} does not exist in scbPersistentCacheMap.`);
      return false;
    }
    return sceneInfoData.isLockedInRecent;
  }

  /**
   * Get Session cache lastUsedPosition
   *
   * @param { Number } persistentId
   */
  public getCacheLastUsedPosition(persistentId: number): string {
    let sceneInfoData = this.scbPersistentCacheMap.get(persistentId);
    if (!sceneInfoData) {
      log.showWarn(`PersistentId:${persistentId} does not exist in scbPersistentCacheMap.`);
      return '';
    }
    return sceneInfoData.lastUsedPosition;
  }

  /**
   * Get Session cache lastUsedTimestamp
   *
   * @param { Number } persistentId
   */
  public getCacheLastUsedTimestamp(persistentId: number): number {
    let sceneInfoData = this.scbPersistentCacheMap.get(persistentId);
    if (!sceneInfoData) {
      log.showWarn(`PersistentId:${persistentId} does not exist in scbPersistentCacheMap.`);
      return 0;
    }
    return sceneInfoData.lastUsedTimestamp;
  }

  /**
   * Set Session isAlive Status
   *
   * @param { Number } persistentId
   * @param { Boolean } isAlive
   */
  public setSessionAliveStatus(persistentId: number, isAlive: boolean): void {
    let sceneInfoData = this.scbPersistentMap.get(persistentId);
    if (sceneInfoData == null) {
      log.showWarn(`PersistentId=${persistentId} does not exist in scbPersistentMap.`);
      return;
    }
    log.showInfo(`Set persistentId = ${persistentId} isAlive to ${isAlive}`);
    if (sceneInfoData.isAlive === isAlive) {
      log.showWarn('The alive status remains unchanged');
      return;
    }
    sceneInfoData.isAlive = isAlive;
    this.saveSCBSceneInfoToJson();
  }

  /**
   * Set lastUsedTimestamp
   *
   * @param { Number } persistentId
   * @param { Number } lastUsedTimestamp
   */
  public setLastUsedTimestamp(persistentId: number, lastUsedTimestamp: number): void {
    let sceneInfoData = this.scbPersistentMap.get(persistentId);
    if (sceneInfoData == null) {
      log.showWarn(`PersistentId=${persistentId} does not exist in scbPersistentMap.`);
      return;
    }
    if (sceneInfoData.lastUsedTimestamp === lastUsedTimestamp) {
      log.showWarn('The lastUsedTimestamp remains unchanged');
      return;
    }
    log.showInfo(`Set persistentId = ${persistentId} lastUsedTimestamp to ${lastUsedTimestamp}`);

    sceneInfoData.lastUsedTimestamp = lastUsedTimestamp;
    this.saveSCBSceneInfoToJson();
  }

  /**
   * Set hasPrivacyModeControl
   *
   * @param { Number } persistentId
   * @param { boolean } hasPrivacyModeControl
   */
  public setHasPrivacyModeControl(persistentId: number, hasPrivacyModeControl: boolean): void {
    let sceneInfoData = this.scbPersistentMap.get(persistentId);
    if (sceneInfoData == null) {
      log.showWarn(`PersistentId=${persistentId} does not exist in scbPersistentMap.`);
      return;
    }
    if (sceneInfoData.hasPrivacyModeControl === hasPrivacyModeControl) {
      log.showWarn('The hasPrivacyModeControl remains unchanged');
      return;
    }
    log.showInfo(`Set persistentId = ${persistentId} hasPrivacyModeControl to ${hasPrivacyModeControl}`);
    sceneInfoData.hasPrivacyModeControl = hasPrivacyModeControl;
    this.saveSCBSceneInfoToJson();
  }

  /**
   * Set session label
   *
   * @param { number } persistentId
   * @param { string } label
   */
  public setSessionLabel(persistentId: number, label: string): void {
    let sceneInfoData = this.scbPersistentMap.get(persistentId);
    if (sceneInfoData == null) {
      log.showWarn(`PersistentId=${persistentId} does not exist in scbPersistentMap.`);
      return;
    }
    log.showInfo(`Set persistentId = ${persistentId} label`);
    if (sceneInfoData.label === label) {
      log.showWarn('The label unchanged');
      return;
    }
    sceneInfoData.label = label;
    this.saveSCBSceneInfoToJson();
  }

  /**
   * Get session label
   *
   * @param { Number } persistentId
   */
  public getCacheSessionLabel(persistentId: number): string {
    let sceneInfoData = this.scbPersistentCacheMap.get(persistentId);
    if (!sceneInfoData) {
      log.showWarn(`PersistentId:${persistentId} does not exist in scbPersistentCacheMap.`);
      return '';
    }
    return sceneInfoData.label;
  }

  /**
   * Set recover finished
   */
  public setRecoverFinished(): void {
    this.isRecoverFinished = true;
    this.saveSCBSceneInfoToJson();
    this.scbPersistentCacheMap.clear();
  }

  /**
   * get recover finished
   *
   * @returns { Boolean }
   */
  public getRecoverFinished(): Boolean {
    return this.isRecoverFinished;
  }

  /**
   * Add one session to local persistent map
   *
   * @param { number } persistentId
   * @param { sceneSessionManager.SceneRecoverInfo } sceneInfo
   */
  public addToLocalPersistentMap(persistentId: number, sceneInfo: sceneSessionManager.SceneRecoverInfo): void {
    const sceneInfoData: PersistentSceneInfo = {
      bundleName: sceneInfo.bundleName,
      abilityName: sceneInfo.abilityName,
      moduleName: sceneInfo.moduleName,
      appIndex: sceneInfo.appIndex,
      persistentId: persistentId,
      rotation: 0,
      isAlive: true,
      isLockedInRecent: this.scbPersistentCacheMap.get(persistentId)?.isLockedInRecent,
      lastUsedPosition: this.scbPersistentCacheMap.get(persistentId)?.lastUsedPosition,
      label: this.scbPersistentCacheMap.get(persistentId)?.label,
      lastUsedTimestamp: this.scbPersistentCacheMap.get(persistentId)?.lastUsedTimestamp,
      hasPrivacyModeControl: this.scbPersistentCacheMap.get(persistentId)?.hasPrivacyModeControl,
    };
    this.scbPersistentMap.set(persistentId, sceneInfoData);
  }

  /**
   * get all persistent ids
   *
   * @returns { Array<number> }
   */
  public getAllPersistentIds(): Array<number> {
    let ids: Array<number> = [];
    for (const id of this.scbPersistentMap.keys()) {
      ids.push(id);
    }
    return ids;
  }

  /**
   * Modify persistent hashmap
   *
   * @param { Number } persistentId
   * @param { sceneSessionManager.SceneInfo } sceneInfo
   * @param { Number } currentRotation
   */
  public modifyPersistentMap(persistentId: number, sceneInfo: sceneSessionManager.SceneInfo, currentRotation: number = 0,
    lastUsedPosition: string = '', lastUsedTimestamp: number = -1): void {
    if (!this.isRecoverFinished) {
      log.showWarn('Recover not finished yet');
      return;
    }
    let sceneInfoData: PersistentSceneInfo = this.scbPersistentMap.get(persistentId);
    if (sceneInfoData) {
      sceneInfoData.bundleName = sceneInfo.bundleName;
      sceneInfoData.abilityName = sceneInfo.abilityName;
      sceneInfoData.moduleName = sceneInfo.moduleName;
      sceneInfoData.appIndex = sceneInfo.appIndex;
      sceneInfoData.rotation = currentRotation;
      sceneInfoData.lastUsedPosition = lastUsedPosition;
      sceneInfoData.lastUsedTimestamp = lastUsedTimestamp === -1 ? sceneInfoData.lastUsedTimestamp : lastUsedTimestamp;
      this.scbPersistentMap.delete(persistentId);
    } else {
      sceneInfoData = {
        bundleName: sceneInfo.bundleName,
        abilityName: sceneInfo.abilityName,
        moduleName: sceneInfo.moduleName,
        appIndex: sceneInfo.appIndex,
        persistentId: persistentId,
        rotation: currentRotation,
        isAlive: false,
        isLockedInRecent: this.scbPersistentCacheMap.get(persistentId)?.isLockedInRecent,
        lastUsedPosition: lastUsedPosition,
        label: this.scbPersistentCacheMap.get(persistentId)?.label,
        lastUsedTimestamp: lastUsedTimestamp,
        hasPrivacyModeControl: false,
      };
    }
    log.showInfo(`update to persistentMap, bundleName: ${sceneInfoData.bundleName} ` +
      `moduleName: ${sceneInfoData.moduleName} abilityName: ${sceneInfoData.abilityName}`);
    this.scbPersistentMap.set(persistentId, sceneInfoData);
    this.saveSCBSceneInfoToJson();
  }

  private saveSCBSceneInfoToJson(): void {
    let scbSceneInfoArray: PersistentSceneInfo[] = [];
    for (let value of this.scbPersistentMap.values()) {
      scbSceneInfoArray.push(value);
    }

    const strData = JSON.stringify(scbSceneInfoArray);
    if (READ_RDB_MODE) {
      this.upsertPersistData(strData);
    } else {
      this.writeStringToFile(strData, this.getPersistentFileAbsPath());
    }
  }

  private getPersistentFileAbsPath(): string {
    return this.getPersistentFileDir() + '/SCBPersistent';
  }

  private async readPersistContent(containerSessionList: SCBSceneContainerSessionArray,
    screenProperty: SCBScreenProperty): Promise<void> {
    try {
      const sceneInfoDataArray = await this.readPersistentJsonArray();
      if (ArrayUtils.isEmpty(sceneInfoDataArray)) {
        log.showWarn('The sceneInfoData in persistent file is empty.');
        return;
      }
      for (const data of sceneInfoDataArray) {
        log.showInfo('readPersistContent bundleName: ' + data.bundleName + ' moduleName: ' + data.moduleName + ' abilityName: ' + 
          data.abilityName + ' appIndex: ' + data.appIndex + ' persistentId: ' + data.persistentId);
        // If app configuration "removeMissionAfterTerminate" is true, no need to recover.
        if (this.noNeedForPersistent(data.bundleName, data.moduleName, data.abilityName)) {
          log.showInfo(`readPersistContent no need for persistent, persistentId ${data.persistentId}`);
          continue;
        }
        data.isAlive = false;
        let sceneInfo = new SCBSceneInfo(data.bundleName, data.moduleName, data.abilityName, data.appIndex, data.persistentId);
        sceneInfo.isPersistentRecover = true;
        sceneInfo.isLockedInRecent = data.isLockedInRecent;
        sceneInfo.label = data.label;
        sceneInfo.hasPrivacyModeControl = data.hasPrivacyModeControl;
        let sceneSession = this.requestSceneSession(sceneInfo);
        if (sceneSession == null) {
          log.showError('failed to request scene session!');
          continue;
        }
        sceneSession.lastUsedTimestamp = data.lastUsedTimestamp;
        data.persistentId = sceneInfo.persistentId;
        this.scbPersistentMap.set(data.persistentId, data);
        let sceneContainerSession = this.recoverToContainerSession(data.rotation, sceneSession, screenProperty);
        sceneContainerSession.getData(ContainerDataCategory.BASIC)?.setLastUsedPosition(data.lastUsedPosition);
        containerSessionList.push(sceneContainerSession);
      }
      this.saveSCBSceneInfoToJson();
      log.showInfo(`read persist content map size : ${this.scbPersistentMap.size}`);
    } catch (err) {
      log.showError(`read persist content failed, message : ${err.message}, code : ${err.code}`);
      this.deleteFile(this.getPersistentFileAbsPath());
    }
  }

  private recoverToContainerSession(rotation: number, sceneSession: SCBSceneSession,
                                              screenProperty: SCBScreenProperty): SCBSceneContainerSession {
    const screenSession = SCBScreenSessionManager.getInstance().getScreenSession(screenProperty.screenId);
    if (screenSession && screenSession.isRotateScreenPolicy()) {
      let currentScreenProperty = new SCBScreenProperty();
      currentScreenProperty.copy(screenSession.scbScreenProperty);
      currentScreenProperty.rotateTo(rotation);
      let sceneContainerSession = new SCBSceneContainerSession(sceneSession, currentScreenProperty);
      sceneContainerSession.screenProperty.rotation = 0;
      sceneContainerSession.currentRotation = rotation;
      return sceneContainerSession;
    }
    let currentScreenProperty = screenProperty.getRotatedScreenProperty(rotation);
    let sceneContainerSession = new SCBSceneContainerSession(sceneSession, currentScreenProperty);
    return sceneContainerSession;
  }

  private writeStringToFile(strJson: string, filePath: string): void {
    let fd: number | undefined = 0;
    try {
      fd = Fileio.openSync(filePath, OPEN_FLAGS, OPEN_MODE);
      let num = Fileio.writeSync(fd, strJson);
      log.showInfo(`write persist file length :  ${num}`);
    } catch (e) {
      log.showError(`writeStringToFile error : ${e.toString()}`);
    } finally {
      if (fd !== undefined) {
        Fileio.closeSync(fd);
      }
    }
  }

  private isExisted(filePath: string): boolean {
    try {
      Fileio.accessSync(filePath);
    } catch (e) {
      log.showError(`isExit error: ${e.toString()}`);
      return false;
    }
    return true;
  }

  private deleteFile(filePath: string): void {
    try {
      if (!this.isExisted(filePath)) {
        return;
      }
      Fileio.unlinkSync(filePath);
      this.isExisted(filePath);
    } catch (e) {
      log.showError(`deleteFile error: ${e.toString()}`);
    }
  }

  private requestSceneSession(sceneInfo: SCBSceneInfo): SCBSceneSession {
    let sceneSession = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo, true);
    return new SCBSceneSession(sceneSession, sceneInfo);
  }

  /**
   * initUserPersistentDir
   *
   * @param { Number } userId
   */
  public initUserPersistentDir(userId: number): void {
    if (userId === -1 || userId === this.currentUserId) {
      log.showError(`userId is invalid: ${userId}`);
      return;
    }
    this.currentUserId = userId;
    log.showDebug('path:' + this.getPersistentFileDir());
    this.createFileDir(this.getPersistentFileDir());
  }

  private createFileDir(fileDir: string): void {
    if (this.isExisted(fileDir)) {
      return;
    }
    try {
      Fileio.mkdirSync(fileDir);
      log.showInfo(`createFileDir in ${fileDir}`);
    } catch (err) {
      log.showError('query persist data with error message: ' + err.message + ', error code: ' + err.code);
    }
  }

  /**
   * get persistent file dir
   *
   * @returns { String }
   */
  public getPersistentFileDir(): string {
    return `${(GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).filesDir}/` + this.currentUserId;
  }

  /**
   * whether has persistent id
   *
   * @param { Number } persistentId
   * @returns { Boolean }
   */
  public hasPersistentIdElem(persistentId?: number): boolean {
    return this.scbPersistentMap.has(persistentId);
  }

  /**
   * update and insert Persistent
   *
   * @param { String } strData
   */
  public upsertPersistData(strData: string): void {
    RdbStorePersistManager.upsertPersistData(this.currentUserId, strData);
  }

  /**
   * query persistent
   *
   * @param { Number } userId
   * @returns { Promise<string> }
   */
  public async queryPersistData(userId: number): Promise<string> {
    try {
      return await RdbStorePersistManager.queryPersistData(this.currentUserId);
    } catch (err) {
      log.showError('query persist data with error message: ' + err.message + ', error code: ' + err.code);
    }
    return null;
  }

  /**
   * delete persistent Data
   */
  public deletePersistData(): void {
    log.showWarn('start deleting persist data!');
    RdbStorePersistManager.deletePersistData();
    this.isRecoverFinished = true;
    this.scbPersistentCacheMap.clear();
  }

  private noNeedForPersistent(bundleName: string, moduleName: string, abilityName: string): boolean {
    if (this.persistentExceptList.includes(bundleName)) {
      log.showInfo('in persistentExceptList noNeedForPersistent: ' + bundleName);
      return true;
    }
    if (!SCBSceneSessionManager.getInstance().getAbilityInfo(bundleName, moduleName, abilityName)) {
      log.showInfo('Ability not exist persistent ignore, key:%{public}s', bundleName + moduleName + abilityName);
      return true;
    }
    return SCBSceneSessionManager.getInstance().isRemoveSessionAfterTerminate(bundleName, moduleName, abilityName);
  }

  /**
   * addPersistentExceptList
   */
  public addPersistentExceptList(bundleName: string): void {
    log.showInfo(`add app to persistentExceptList, bundleName: ${bundleName}`);
    this.persistentExceptList.push(bundleName);
  }
}
