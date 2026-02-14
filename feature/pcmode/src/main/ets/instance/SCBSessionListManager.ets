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
import { CommonUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
} from '@ohos/windowscene';
import HashMap from '@ohos.util.HashMap';

const TAG = 'SCBSessionListManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class SCBSessionListManager {
  public static allContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  private static containerSessionListMap: HashMap<string, PcSCBSceneContainerSessionArray> =
    new HashMap<string, PcSCBSceneContainerSessionArray>();
  private static SCENE_PANEL_START_Z_ORDER = 110;
  private static SPECIAL_SCENE_PANEL_Z_ORDER = 2100;
  private static SCENE_PANEL_REGISTER_STR = 'SCENE_PANEL_';
  private static SPECIAL_SCENE_PANEL_REGISTER_STR = 'SPECIAL_SCENE_PANEL_';
  private static LOCK = 'LOCK';

  private static getNotLockPersistentIds(): Array<number> {
    let persistentIds: number[] = [];
    SCBSessionListManager.allContainerSessionList.forEach((containerSession) => {
      if (containerSession) {
        persistentIds = persistentIds.concat(containerSession.getSceneSessionIdList());
      }
    });
    return persistentIds;
  }

  private static getLockPersistentIds(): HashMap<String, Array<number>> {
    let persistentIdMap = new HashMap<String, Array<number>>();
    let onLockPersistentIds: number[] = [];
    let underLockPersistentIds: number[] = [];
    SCBSessionListManager.allContainerSessionList.forEach((containerSession) => {
      if (!containerSession || !containerSession.isActive) {
        return;
      }
      if (containerSession.isShowWhenLocked()) {
        onLockPersistentIds = onLockPersistentIds.concat(containerSession.getSceneSessionIdList());
        return;
      }
      underLockPersistentIds = underLockPersistentIds.concat(containerSession.getSceneSessionIdList());
    });
    persistentIdMap.set(SCBSessionListManager.SCENE_PANEL_REGISTER_STR + SCBSessionListManager.LOCK,
      onLockPersistentIds);
    persistentIdMap.set(SCBSessionListManager.SPECIAL_SCENE_PANEL_REGISTER_STR + SCBSessionListManager.LOCK,
      underLockPersistentIds);
    return persistentIdMap;
  }

  public static getNormalContainerArray(screenProperty: SCBScreenProperty): PcSCBSceneContainerSessionArray {
    if (screenProperty === undefined) {
      log.showError('screenProperty is undefined');
      return new PcSCBSceneContainerSessionArray();
    }
    let screenId = screenProperty.screenId;
    log.showInfo('screenId is:%{public}d', screenId);
    if (SCBSessionListManager.containerSessionListMap.hasKey(
      SCBSessionListManager.SCENE_PANEL_REGISTER_STR + screenId)) {
      return SCBSessionListManager.containerSessionListMap.get(
        SCBSessionListManager.SCENE_PANEL_REGISTER_STR + screenId);
    }
    let containerSessionList: PcSCBSceneContainerSessionArray = new PcSCBSceneContainerSessionArray();
    SCBSessionListManager.containerSessionListMap.set(
      SCBSessionListManager.SCENE_PANEL_REGISTER_STR + screenId, containerSessionList);
    return containerSessionList;
  }

  public static getSpecialContainerArray(screenProperty: SCBScreenProperty): PcSCBSceneContainerSessionArray {
    if (screenProperty === undefined) {
      log.showError('screenProperty is undefined');
      return new PcSCBSceneContainerSessionArray();
    }
    let screenId = screenProperty.screenId;
    log.showInfo('special screenId  is:%{public}d', screenId);
    if (SCBSessionListManager.containerSessionListMap.hasKey(
      SCBSessionListManager.SPECIAL_SCENE_PANEL_REGISTER_STR + screenId)) {
      return SCBSessionListManager.containerSessionListMap.get(
        SCBSessionListManager.SPECIAL_SCENE_PANEL_REGISTER_STR + screenId);
    }
    let containerSessionList: PcSCBSceneContainerSessionArray = new PcSCBSceneContainerSessionArray();
    SCBSessionListManager.containerSessionListMap.set(
      SCBSessionListManager.SPECIAL_SCENE_PANEL_REGISTER_STR + screenId, containerSessionList);
    return containerSessionList;
  }

  public static add(sceneContainerSession: SCBSceneContainerSession): Boolean {
    return SCBSessionListManager.allContainerSessionList.add(sceneContainerSession);
  }

  public static insert(containerSessionList: PcSCBSceneContainerSessionArray, index: number,
    sceneContainerSession: SCBSceneContainerSession): boolean {
    if (index === 0) {
      return SCBSessionListManager.allContainerSessionList.insert(0, sceneContainerSession);
    }
    let containerId: number = containerSessionList[index - 1].containerId;
    let previousIndex = SCBSessionListManager.allContainerSessionList.findIndexByContainerId(containerId);
    return SCBSessionListManager.allContainerSessionList.insert(previousIndex + 1, sceneContainerSession);
  }

  public static deleteByContainerId(containerId: number): void {
    SCBSessionListManager.allContainerSessionList.deleteByContainerId(containerId);
  }

  public static sortByTopmost(): void {
    const mainWindowTopmostContainerSessionList: SCBSceneContainerSession[] = [];
    const topmostContainerSessionList: SCBSceneContainerSession[] = [];
    for (let i = SCBSessionListManager.allContainerSessionList.length - 1; i >= 0; i--) {
      const containerSession: SCBSceneContainerSession = SCBSessionListManager.allContainerSessionList[i];
      if (!containerSession || !containerSession.isActive) {
        continue;
      }
      if (containerSession.isTopmost()) {
        topmostContainerSessionList.unshift(containerSession);
        SCBSessionListManager.allContainerSessionList.splice(i, 1);
      } else if (containerSession.isMainWindowTopmost()) {
        mainWindowTopmostContainerSessionList.unshift(containerSession);
        SCBSessionListManager.allContainerSessionList.splice(i, 1);
      }
    }
    SCBSessionListManager.allContainerSessionList.push(
      ...mainWindowTopmostContainerSessionList, ...topmostContainerSessionList);
  }

  private static compareModalType(primarySession: SCBSceneSession | null,
    secondarySession: SCBSceneSession | null): number {
    if (!primarySession || !secondarySession) {
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

  public static sortByModalType(): void {
    SCBSessionListManager.allContainerSessionList.sort((containerSessionA: SCBSceneContainerSession,
      containerSessionB: SCBSceneContainerSession) => {
      let ret: number = SCBSessionListManager.compareModalType(containerSessionA.primarySession,
        containerSessionB.primarySession);
      if (ret !== 0) {
        return ret;
      }
      ret = SCBSessionListManager.compareModalType(containerSessionA.primarySession,
        containerSessionB.secondarySession);
      if (ret !== 0) {
        return ret;
      }
      ret = SCBSessionListManager.compareModalType(containerSessionA.secondarySession,
        containerSessionB.primarySession);
      if (ret !== 0) {
        return ret;
      }
      return SCBSessionListManager.compareModalType(containerSessionA.secondarySession,
        containerSessionB.secondarySession);
    });
  }

  public static splice(spliceContainsArray: SCBSceneContainerSession[]): void {
    spliceContainsArray.forEach((contain) => {
      SCBSessionListManager.allContainerSessionList.deleteByContainerId(contain.containerId);
    });
  }

  public static spliceAndInsert(startContainerId: number, spliceContainsArray: SCBSceneContainerSession[],
    ...scbSceneContainer: SCBSceneContainerSession[]): void {
    log.showDebug(`startContainerId: ${startContainerId} ` +
      `len: ${SCBSessionListManager.allContainerSessionList.length} spliceContainsArray: ${spliceContainsArray.length}`);
    if (spliceContainsArray.length !== 0) {
      let startNum = 0;
      spliceContainsArray.forEach((contain: SCBSceneContainerSession) => {
        let index = SCBSessionListManager.allContainerSessionList.findIndexByContainerId(contain.containerId);
        SCBSessionListManager.allContainerSessionList[index] = scbSceneContainer[startNum++];
      });
      let overScbSceneContainer: SCBSceneContainerSession[] =
        scbSceneContainer.slice(spliceContainsArray.length, scbSceneContainer.length);
      SCBSessionListManager.allContainerSessionList.push(...overScbSceneContainer);
    } else {
      let startIndex = SCBSessionListManager.allContainerSessionList.findIndexByContainerId(startContainerId);
      if (startIndex !== -1) {
        SCBSessionListManager.allContainerSessionList.splice(startIndex, 0, ...scbSceneContainer);
      } else {
        SCBSessionListManager.allContainerSessionList.push(...scbSceneContainer);
      }
    }
  }

  public static refreshZOrder(): void {
    if (!SCBSceneSessionManager.getInstance().isCoreEnable) {
      SCBSceneSessionManager.getInstance().refreshZOrder();
      return;
    }
    if (!AppStorage.get('isLock')) {
      SCBSceneSessionManager.getInstance().refreshPcZOrder(
        SCBSessionListManager.SCENE_PANEL_START_Z_ORDER, SCBSessionListManager.getNotLockPersistentIds());
      return;
    }
    let persistentIdMap = SCBSessionListManager.getLockPersistentIds();
    let onLockPersistentIds = persistentIdMap.get(
      SCBSessionListManager.SCENE_PANEL_REGISTER_STR + SCBSessionListManager.LOCK);
    let underLockPersistentIds = persistentIdMap.get(
      SCBSessionListManager.SPECIAL_SCENE_PANEL_REGISTER_STR + SCBSessionListManager.LOCK);
    SCBSceneSessionManager.getInstance()
      .refreshPcZOrder(SCBSessionListManager.SPECIAL_SCENE_PANEL_Z_ORDER, onLockPersistentIds);
    SCBSceneSessionManager.getInstance()
      .refreshPcZOrder(SCBSessionListManager.SCENE_PANEL_START_Z_ORDER, underLockPersistentIds);
  }

  public static clearContainerSessionListMap(screenId: number): void {
    SCBSessionListManager.containerSessionListMap.get(
      SCBSessionListManager.SCENE_PANEL_REGISTER_STR + screenId)?.superClear();
  }

  public static setNormalContainerArray(screenId: number, containerSessionList: PcSCBSceneContainerSessionArray): void {
    log.showDebug(`setNormalContainerArray screenId: ${screenId}`);
    SCBSessionListManager.containerSessionListMap.set(
      SCBSessionListManager.SCENE_PANEL_REGISTER_STR + screenId, containerSessionList);
  }
}

export class PcSCBSceneContainerSessionArray extends SCBSceneContainerSessionArray {
  /**
   * The clear method is not used, but the impact is great. Only the method is recorded in logs.
   * If necessary, the specific management and control implementation is added.
   */
  public clear(): void {
    log.showError('The clean method is called. Please override the method.');
    super.clear();
  }

  public add(sceneContainerSession: SCBSceneContainerSession): boolean {
    SCBSessionListManager.add(sceneContainerSession);
    let result = super.add(sceneContainerSession);
    log.showInfo('exit to add,containerId: %{public}d', sceneContainerSession.containerId);
    return result;
  }

  public insert(index: number, sceneContainerSession: SCBSceneContainerSession): boolean {
    SCBSessionListManager.insert(this, index, sceneContainerSession);
    let result = super.insert(index, sceneContainerSession);
    log.showInfo('exit to insert: %{public}d', sceneContainerSession.containerId);
    return result;
  }

  public deleteByContainerId(containerId: number): SCBSceneContainerSession | null {
    SCBSessionListManager.deleteByContainerId(containerId);
    let result = super.deleteByContainerId(containerId);
    log.showInfo('exit to deleteByContainerId: %{public}d', containerId);
    return result;
  }

  public sortByTopmost(): void {
    const mainWindowTopmostContainerSessionList: SCBSceneContainerSession[] = [];
    const topmostContainerSessionList: SCBSceneContainerSession[] = [];

    for (let i = this.length - 1; i >= 0; i--) {
      const containerSession: SCBSceneContainerSession = this[i];
      if (!containerSession || !containerSession.isActive) {
        continue;
      }
      if (containerSession.isTopmost()) {
        topmostContainerSessionList.unshift(containerSession);
        super.splice(i, 1);
      } else if (containerSession.isMainWindowTopmost()) {
        mainWindowTopmostContainerSessionList.unshift(containerSession);
        super.splice(i, 1);
      }
    }
    super.push(...mainWindowTopmostContainerSessionList, ...topmostContainerSessionList);
    SCBSessionListManager.sortByTopmost();
    log.showInfo('exit to sortByTopmost');
  }

  public sortByModalType(): void {
    super.sortByModalType();
    SCBSessionListManager.sortByModalType();
  }

  public deleteWithTransitionInactive(index: number): boolean {
    SCBSessionListManager.deleteByContainerId(this[index].containerId);
    let result = super.deleteWithTransitionInactive(index);
    log.showInfo('exit to deleteWithTransitionInactive: %{public}d', this[index].containerId);
    return result;
  }

  public push(...items: SCBSceneContainerSession[]): number {
    for (let i = 0; i < items.length; i++) {
      let item = items[i];
      SCBSessionListManager.allContainerSessionList.push(item);
      super.push(item);
    }
    return items.length;
  }

  public splice(start: number, deleteCount?: number): SCBSceneContainerSession[] {
    let spliceContainsArray: SCBSceneContainerSession[] = super.splice(start, deleteCount);
    SCBSessionListManager.splice(spliceContainsArray);
    log.showInfo('exit to splice start: %{public}d, deleteCount:%{public}d', start, deleteCount);
    return spliceContainsArray;
  };

  public spliceAndInsert(start: number, deleteCount: number,
    ...items: SCBSceneContainerSession[]): SCBSceneContainerSession[] {
    log.showInfo(`[spliceAndInsert] start: ${start} deleteCount: ${deleteCount} len: ${items?.length}`);
    let startContainerId = -1;
    if (start < this.length && deleteCount === 0) {
        startContainerId = this[start]?.containerId;
    }
    let spliceContainsArray = super.splice(start, deleteCount, ...items);
    SCBSessionListManager.spliceAndInsert(startContainerId, spliceContainsArray, ...items);
    return spliceContainsArray;
  }

  /**
   * 该方法直接调用父类的clear方法,不会清空allContainerSessionList
   */
  public superClear(): void {
    if (this.isEmpty()) {
      return;
    }
    super.splice(0, this.length);
  }

  /**
   * 该方法直接调用父类的push方法，不会往allContainerSessionList中添加
   * @param items
   * @returns
   */
  public superPush(...items: SCBSceneContainerSession[]): number {
    let result = super.push(...items);
    return result;
  }
}