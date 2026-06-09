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

import { CheckEmptyUtils, SingletonHelper } from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScenePanelManager,
  RecentsStyleConstants
} from '@ohos/windowscene';
import { LockPreference, RecentLockUtils, EventConstants } from '@ohos/launchercommon';
import { recentRdbStoreManager } from '@ohos/launchercommon';
import { LogDomain, Logger } from '@ohos/basicutils';
import { localEventManager, GlobalContext, DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { settings } from '@kit.BasicServicesKit';

const TAG = 'RecentLockModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 多任务加锁配置
 */
export class RecentLockModel {
  private static readonly tecentInfo = ['com.tencent.wechat', 'EntryAbility', 'entry'];
  private recentLockList: LockPreference[] = [];
  // 多任务加锁数据库是否已经批量插入过数据
  private isInitLockList: boolean = false;

  constructor() {
    this.registerLockListener();
  }

  /**
   * 查询数据库列表到内存
   */
  public async initRecentLockList(): Promise<void> {
    // 初始化多任务加锁列表是否加锁的状态位
    this.isInitLockList =
      settings.getValueSync(GlobalContext.getContext(), RecentsStyleConstants.SETTING_ITEM_RECENT_LOCK,
        'NOT_INIT_RECNET', settings.domainName.USER_PROPERTY) === 'INIT_RECNET';
    log.info(TAG, `isInitLockList ${this.isInitLockList}`);
    if (this.isInitLockList) {
      this.recentLockList = await recentRdbStoreManager.getRecentLockList();
      this.printListLength();
    }
  }

  /**
   * 数据库加锁表创建过之后，更新变量
   */
  public async setIsInitLockList(): Promise<void> {
    // 设置已经写入数据库的标记位
    settings.setValue(GlobalContext.getContext(), RecentsStyleConstants.SETTING_ITEM_RECENT_LOCK, 'INIT_RECNET',
      settings.domainName.USER_PROPERTY);
    this.isInitLockList = true;
  }

  // app卸载的监听器
  private readonly mAddToLockListener: IAddLockListener = {
    onReceiveEvent: (event: string, params: LockPreference): void => {
      log.showDebug(TAG, `receive event: ${event}, params: ${params.bundleName} ${params.appIndex}`);
      if (CheckEmptyUtils.isEmpty(event) || CheckEmptyUtils.isEmpty(params)) {
        log.showError(TAG, `event param is empty.`)
      }
      if (event === EventConstants.EVENT_REQUEST_RECENT_LOCK_ITEM_DELETE) {
        this.deleteRecentLockWhenRemoved(params.bundleName, params.appIndex);
      }
    }
  };

  // 注册app卸载的监听器
  private registerLockListener(): void {
    if (AppStorage.get('registerLockListenerFlag')) {
      return;
    }
    localEventManager.registerEventListener(this.mAddToLockListener, [
      EventConstants.EVENT_REQUEST_RECENT_LOCK_ITEM_DELETE
    ]);
    AppStorage.setOrCreate('registerLockListenerFlag', true);
    log.showDebug(TAG, 'local listener on create');
  }

  /**
   * 反注册app卸载的监听器
   */
  public unregisterLockListener(): void {
    localEventManager.unregisterEventListener(this.mAddToLockListener);
    AppStorage.setOrCreate('registerLockListenerFlag', false);
    this.recentLockList  = [];
    log.showInfo(TAG, 'local listener on destroy');
  }

  /**
   * 创建多任务卡片中加锁卡片的信息list
   */
  private createRecentLockList(): LockPreference[] {
    let containerList: SCBSceneContainerSessionArray =
      SCBScenePanelManager.getInstance().getTotalSessionList();
    let recentLockList: LockPreference[] = [];

    // 添加微信及分身的默认加锁数据，默认两个
    for (let i of [0, 1]) {
      let ailityInfo: LockPreference = {
        bundleName: RecentLockModel.tecentInfo[0],
        abilityName: RecentLockModel.tecentInfo[1],
        moduleName: RecentLockModel.tecentInfo[2],
        appIndex: i
      };
      recentLockList.push(ailityInfo);
    }

    containerList.forEach((container) => {
      if (container.secondarySession || !container.primarySession) {
        log.showError(TAG, `container is null or split.`);
        return;
      }
      log.info(TAG, `recover ${container.containerId}`);
      if (container.primarySession.sceneInfo.isLockedInRecent) {
        log.info(TAG, `recover put ${container.containerId}`);
        recentLockList.push(RecentLockUtils.creatLockInfo(container.primarySession.sceneInfo));
      }
    })
    return recentLockList;
  }

  /**
   * 输出当前加锁卡片的信息
   */
  private async printListLength(): Promise<void> {
    this.recentLockList.forEach((lockParam) => {
      log.info(TAG, `query lock list ${lockParam.bundleName}`);
    })
    log.info(TAG, `length ${this.recentLockList.length}`);
    if (this.recentLockList.length > RecentsStyleConstants.DEFAULT_MAX_RECENT_NUM) {
      log.showError(TAG, `exceed limit`);
    }
  }

  /**
   * 手机重启，数据库表格不存在的时候，批量插入加锁container的信息；读取数据库加锁信息到recentLockList
   */
  public async batchInsertOrUPdateRecentLock(): Promise<void> {
    try {
      // 已经写过数据库或者要写入的数据是空的，不再批量插入列表
      if (this.isInitLockList) {
        log.info(TAG, `no need creat lock list.`);
        return;
      }
      log.info(TAG, `batch insert data.`)
      this.setIsInitLockList();
      let recentLockList: LockPreference[] = this.createRecentLockList();
      recentRdbStoreManager.batchInsertRecentLock(recentLockList);
      this.recentLockList = recentLockList;
    } catch (err) {
      log.showError(TAG, `addrecentLock failed, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  /**
   * 下拉加锁的时候，单个插入加锁container的信息，分屏情况下不做处理.
   * @param { SCBSceneContainerSession } container - 加锁的卡片.
   */
  public insertRecentLock(container: SCBSceneContainerSession): void {
    if (!container || container.secondarySession || !container.primarySession) {
      log.showError(TAG, `container is null or split.`);
      return;
    }
    log.info(TAG, `add ${container.containerId}`);
    let recentLockList: LockPreference[] = [];
    let lockInfo = RecentLockUtils.creatLockInfo(container.primarySession.sceneInfo);
    recentLockList.push(lockInfo);
    this.recentLockList.push(lockInfo);
    log.info(TAG, `length ${this.recentLockList.length}`);
    try {
      recentRdbStoreManager.batchInsertRecentLock(recentLockList);
    } catch (err) {
      log.showError(TAG, `addrecentLock failed, code: ${err?.code}, message: ${err?.message}`);
    }
  }

  /**
   * 进入多任务的时候，把recentLockList的信息更新到多任务卡片中
   * @param { SCBSceneContainerSessionArray } SCBSceneContainerSessionArray - 多任务列表.
   */
  public setRecentLockForEnter(containerList: SCBSceneContainerSessionArray): void {
    containerList.forEach((container) => {
      if (container.secondarySession || !container.primarySession) {
        log.showError(TAG, `container is null or split.`);
        return;
      }
      let lockItem =
        this.recentLockList.find(item => item.bundleName === container.primarySession?.sceneInfo.bundleName &&
          item.abilityName === container.primarySession?.sceneInfo.abilityName &&
          item.appIndex === container.primarySession?.sceneInfo.appIndex &&
          item.moduleName === container.primarySession?.sceneInfo.moduleName);
      if (!CheckEmptyUtils.isEmpty(lockItem)) {
        container.primarySession.sceneInfo.isLockedInRecent = true;
        log.info(TAG, `set lock ${container.getName()}`);
      }
    })
  }

  /**
   * 卡片下拉取消加锁时，从数据库中删除
   * @param { SCBSceneContainerSession } container -主动取消卡片的加锁.
   */
  public async deleteRecentLockForContainer(container: SCBSceneContainerSession): Promise<void> {
    if (CheckEmptyUtils.isEmpty(container)) {
      return;
    }
    let lockInfo = RecentLockUtils.creatLockInfo(container?.primarySession?.sceneInfo);
    await recentRdbStoreManager.deleteRecentLockForContainer(lockInfo);
    let index = this.recentLockList.findIndex(item => item.bundleName === lockInfo.bundleName &&
      item.abilityName === lockInfo.abilityName &&
      item.appIndex === lockInfo.appIndex &&
      item.moduleName === lockInfo.moduleName);
    if (index !== -1) {
      let delItem = this.recentLockList.splice(index, 1);
      log.info(TAG, `del container ${delItem.length}`);
    }
  }

  /**
   * app卸载,从数据库中删除；卸载分身的情况,卸载主应用所有的ability信息需要删除，卸载分身APP ability删除单个信息
   * @param { string } bundleName - 卡片的bundleName.
   * @param { number } appIndex - 卡片的appIndex.
   */
  public async deleteRecentLockWhenRemoved(bundleName: string, appIndex: number): Promise<void> {
    // 卸载分身
    if (appIndex > 0) {
      await recentRdbStoreManager.deleteRecentLock(bundleName, appIndex);
    } else {
      await recentRdbStoreManager.deleteRecentLock(bundleName);
    }
    let index = this.recentLockList.findIndex(item => item.bundleName === bundleName &&
      item.appIndex === appIndex);
    if (index !== -1) {
      let delItem = this.recentLockList.splice(index, 1);
      log.info(TAG, `del ${delItem.length}`);
    }
  }

  private recoverListRecord(): string {
    let ret = 'totalList: ' + SCBScenePanelManager.getInstance().getTotalSessionList().toString();
    ret += '\r\n';
    ret += 'recentList ' + this.recentLockList.toString();
    ret += '\r\n';
    ret += 'isInitLockList ' + this.isInitLockList.toString();
    ret += '\r\n';
    return ret;
  }

  /**
   * 注册debug命令
   */
  private registerDebugCommand(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'info',
        callback: (args: string[]): string => {
          return this.recoverListRecord();
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  /**
   * 注册debug命令
   */
  aboutToAppear() {
    this.registerDebugCommand();
  }
 
  /**
   * 反注册debug命令
   */
  aboutToDisappear() {
    DebugCommandManager.getInstance().unregister(TAG);
  }
}

export const recentLockModel: RecentLockModel = SingletonHelper.getInstance(RecentLockModel, TAG);

export interface IAddLockListener{
  onReceiveEvent: (event: string, params: LockPreference) => void;
}