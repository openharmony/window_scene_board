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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationEvent } from '../../event/NotificationEvent';
import { TaskQueue, TaskItem } from '../../utils/TaskQueue';
import { InnerEventUtil } from '../../utils/InnerEventUtil';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveDataVm } from '../interface/ILiveDataVm';
import { LiveNotification } from '../model/LiveNotification';
import { LiveBaseVm } from './LiveBaseVm';
import { NotificationDataManager } from '../../manager/NotificationDataManager';
import { NotificationUtil } from '../../utils/NotificationUtil';
import { LiveTimeoutEvent } from '../../event/LiveViewEvent';
import { LiveCapsuleRemindType } from '../model/LiveCommonModel';
import { sysTimerMgr } from '@ohos/systemuiutils/src/main/ets/timer/SysTimerManager';
import {
  DeleteNotificationErrorCode,
  DeleteNotificationMaintenance } from '../../maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '../../maintenance/StatisticsConstants';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import { ILiveMetaBallVisibleVm } from '../interface/ILiveMetaBallVisibleVm';
import { BannerVm } from '../../vm/BannerVm';
import { ScenePanelAdapter } from '../../adapter/ScenePanelAdapter';
import { EvtBus } from '@ohos/frameworkwrapper';
import { ScreenRecordEvent } from '../../event/StatusBarEvent';
import camera from '@ohos.multimedia.camera';
import {
  GlobalContext
} from '@ohos/frameworkwrapper';

const TAG = 'LiveDataVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const CLEAR_ALL_APP_DELAY = 900;
const NOTIFICATION_TIMEOUT = 30000;
const TORCH_MODE_ON: number = 1;

@ObservedV2
export class LiveDataVm extends LiveBaseVm implements ILiveDataVm {
  /**
   * 所有实况数据全集
   */
  public liveMap: Map<string, LiveNotification> = new Map();
  /**
   * 是否执行多任务一键清除任务
   */
  public isClearAllApp: boolean = false;
  /**
   * 使用任务队列排队处理，避免动画混乱
   */
  protected taskQueue = new TaskQueue(TAG, 1);
  /**
   * 抢占动效计时
   */
  protected remindTimerMap: Map<string, number> = new Map();

  protected timerVm = this.vmInjector.getTimerVm();
  protected capsuleListVm = this.vmInjector.getCapsuleListVm();
  protected cardListVm = this.vmInjector.getCardListVm();

  private delTimerLive: Map<string, LiveNotification> = new Map();

  @Computed
  get liveMetaBallVisibleVm(): ILiveMetaBallVisibleVm {
    return this.vmInjector.getMetaBallVisibleVm();
  }

  public init(): void {
    InnerEventUtil.on(NotificationEvent, this.onNotificationEvent);
  }

  public onNotificationEvent = (event: NotificationEvent): void => {
    let liveList = event.notificationList.filter(
      (ntf) => ntf.isLiveView() && !ntf.isConvertFromNormal && !ntf.isInstantBanner()) as LiveNotification[];
    log.showWarn(`Recieve live event: ${event.eventType}, updateType: ${event.updateType}, live length: ${liveList.length}, isClearAllApp: ${this.isClearAllApp}`);

    if (!liveList.length && event.eventType !== NotificationEvent.EVENT_TYPE_INIT) {
      return;
    }

    if (this.clearAllIsNeedHandle(event, liveList[0])) {
      return;
    }
    let task: TaskItem | undefined = undefined;
    if (event.eventType === NotificationEvent.EVENT_TYPE_INIT) {
      task = new TaskItem('onInit', () => this.onInit(liveList));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_ADD) {
      task = new TaskItem('onAdd', () => this.onAdd(liveList[0]));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_UPDATE && !event.isBatch) {
      task = new TaskItem('onSingleUpdate', () => this.onSingleUpdate(liveList));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_UPDATE && event.isBatch) {
      task = new TaskItem('onBatchUpdate', () => this.onBatchUpdate(liveList));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_REMOVE) {
      task = new TaskItem('onRemove_' + liveList[0].hashCode, () => this.onRemove(liveList));
    }

    if (task) {
      task.timeout = NOTIFICATION_TIMEOUT;
      this.taskQueue.add(task);
    }
  };

  private clearAllIsNeedHandle(event: NotificationEvent, live: LiveNotification): boolean {
    if (!this.isClearAllApp) {
      return false;
    }
    if (event.eventType === NotificationEvent.EVENT_TYPE_REMOVE && live.isInstant()) {
      return false
    }
    return true;
  }

  async onInit(liveList: LiveNotification[]): Promise<void> {
    liveList = liveList.filter((live) => this.checkLiveValid(live));
    const oldLiveMap = new Map(this.liveMap);

    this.liveMap.clear();
    for (const newLive of liveList) {
      this.liveMap.set(newLive.hashCode, newLive);
      const oldLive = oldLiveMap.get(newLive.hashCode);
      if (!oldLive) { // 处理新增的
        log.showWarn(`OnInit add for ${newLive.hashCode}`);
        this.timerVm.setLiveTimer(newLive);
        this.setOtherTimeout(newLive);
      } else if (oldLive !== newLive) { // 处理更新的
        log.showWarn(`OnInit update for ${newLive.hashCode}`);
        this.timerVm.updateLiveTimer(newLive, oldLive);
        this.setOtherTimeout(newLive);
        this.vmInjector.updateVmByLive(newLive, TAG);
      }
      this.addLiveCloseContainer(newLive);
    }
    const removeLiveList: LiveNotification[] = [];
    for (const live of oldLiveMap.values()) {
      if (this.liveMap.has(live.hashCode)) {
        continue;
      }
      removeLiveList.push(live);
      if (live.isInstant()) {
        this.vmInjector.getLiveRemindVm().clearRemindCapsule();
      }
    }
    await this.capsuleListVm.initLiveList(liveList);
    if (BannerVm.instance.isLivePanel()) {
      this.vmInjector.getCardListVm().initLiveList(liveList);
    }

    // 最后处理删除的
    for (const live of oldLiveMap.values()) {
      if (!this.liveMap.has(live.hashCode)) {
        this.timerVm.deleteLiveTimer(live);
        this.clearTimeout(live);
        this.vmInjector.deleteVmByLive(live);
        this.removeLiveCloseContainer(live);
      }
    }
  }

  async onAdd(live: LiveNotification): Promise<void> {
    if(live.isFlashLight() && !this.checkTorchMode()) {
      // 手电筒开启实况显示前再检查一下手电筒状态。
      NotificationDataManager.instance.removeLiveView([live]);
      return;
    }
    this.timerVm.setLiveTimer(live);
    if (!this.checkLiveValid(live)) {
      this.delTimerLive.set(live.hashCode, live);
      return;
    }
    LiveHiSysEvent.reportLiveUpdateEvent(live);
    this.liveMap.set(live.hashCode, live);
    this.setOtherTimeout(live);

    // 即时需要等待动效出场完成
    if (live.isInstant()) {
      if (live.isFaceLock()) {
        this.capsuleListVm.addLive(live);
      } else {
        await this.capsuleListVm.addLive(live);
      }
      this.setRemindTimeout(live, false);
      return;
    }

    this.capsuleListVm.addLive(live);
    await this.cardListVm.addLive(live);
    this.addLiveCloseContainer(live);
    this.checkScreenRecording(live);
  }

  private checkScreenRecording(live: LiveNotification, isRemove: boolean = false): void {
    if (!live?.isScreenRecorder()) {
      return;
    }
    log.showInfo(`post record event, isRemove: ${isRemove}`);
    // 发送录屏胶囊显示消失事件
    let event = new ScreenRecordEvent(!isRemove, live?.capsule?.backgroundColor ?? LiveStyle.CAPSULE_CONTENT_COLOR);
    EvtBus.post(ScreenRecordEvent, event);
  }

  async onBatchUpdate(liveList: LiveNotification[]): Promise<void> {
    this.cardListVm.localUpdateLiveList(liveList);
    await this.capsuleListVm.localUpdateLiveList(liveList);
    for (const live of liveList) {
      const oldLive = this.liveMap.get(live.hashCode);
      if (oldLive) {
        log.showWarn(`Update live for ${live.hashCode}`);
        this.liveMap.set(live.hashCode, live);
        this.vmInjector.updateVmByLive(live, TAG);
      }
    }
    LiveHiSysEvent.reportLiveUpdateEvent();
  }

  async onSingleUpdate(liveList: LiveNotification[]): Promise<void> {
    const newLive = liveList[0];
    const oldLive = this.liveMap.get(newLive.hashCode);
    if (newLive?.type !== undefined && oldLive?.type !== undefined && newLive?.type !== oldLive?.type) {
      log.showWarn(`Capsule type is not match, not update, new type = ${newLive?.type}, old type = ${oldLive?.type}`);
      return;
    }
    const oldTimerLive = oldLive || this.delTimerLive.get(newLive.hashCode);
    if (oldTimerLive) {
      // 更新卡片定时器
      this.timerVm.updateLiveTimer(newLive, oldTimerLive);
      this.delTimerLive.delete(newLive.hashCode);
    }
    // 更新删除胶囊
    if (!this.checkLiveValid(newLive)) {
      // 下一次更新有胶囊时，把oldCardTimer删掉
      this.delTimerLive.set(newLive.hashCode, newLive);
      this.cardListVm.removeLiveList(liveList);
      await this.capsuleListVm.removeLiveList(liveList);
      // 3s延时删除vmMap，3s内更新会存在Vm残留，更新删除场景需要直接删除
      this.removeLive(liveList, true);
      return;
    }
    LiveHiSysEvent.reportLiveUpdateEvent(newLive);

    // 更新胶囊
    if (oldLive && this.checkLiveValid(oldLive)) {
      if (newLive.card?.isOtherCard() && newLive.isFlip() || !newLive.card?.isOtherCard()) {
        this.clearReminderTimer(this.getRemindTimerKey(newLive, true))
      }
      this.cardListVm.remoteUpdateLive(newLive);
      await this.capsuleListVm.remoteUpdateLive(newLive);
      if (newLive.card?.isOtherCard()) {
        this.setOtherTimeout(newLive);
        if (newLive.isFlip()) {
          this.setRemindTimeout(newLive, true);
        }
      } else {
        this.setRemindTimeout(newLive, true);
      }
      this.liveMap.set(newLive.hashCode, newLive);
      this.vmInjector.updateVmByLive(newLive, TAG);
      this.timerVm.deleteLiveTimer(oldLive, newLive);
      return;
    }

    // 新增胶囊
    await this.onAdd(newLive);
    // 暂时规避实况key问题
    this.vmInjector.updateVmByLive(newLive, TAG);
  }

  async onRemove(liveList: LiveNotification[]): Promise<void> {
    // 删除需要等待动画完成再删除数据、清理定时器、删除VM
    await Promise.all([
      this.cardListVm.removeLiveList(liveList),
      this.capsuleListVm.removeLiveList(liveList),
    ]);
    for (const live of liveList) {
      // 放到removeLive中在update调用时，胶囊从有-无-有的更新过程中，定时器会出问题
      this.timerVm.deleteLiveTimer(live);
      this.delTimerLive.delete(live.hashCode);
    }
    this.removeLive(liveList);
  }

  private removeLive(liveList: LiveNotification[], isUpdateToDelete?: boolean): void {
    for (const live of liveList) {
      log.showWarn(`Remove live for ${live.hashCode}`);
      this.liveMap.delete(live.hashCode);
      this.clearTimeout(live);
      this.vmInjector.deleteVmByLive(live, isUpdateToDelete);
      this.removeLiveCloseContainer(live);
      this.checkScreenRecording(live, true);
    }
  }

  private checkTorchMode() {
    const mCameraManager: camera.CameraManager = camera.getCameraManager(GlobalContext.getContext());
    if (!mCameraManager || mCameraManager.getTorchMode() !== TORCH_MODE_ON) {
      log.showInfo('Torch mode is close, not need show capsule')
      return false;
    }
    return true;
  }
  /**
   * 检查实况数据有效性
   * @param live
   * @returns
   */
  checkLiveValid(live: LiveNotification): boolean {
    const isValid = live.isShowCapsule();
    if (!isValid) {
      log.showWarn(`live is invalid, no capsule: ${live.capsule === undefined}, isEnd: ${live.isEnd}`);
    }
    return isValid;
  }

  /**
   * 设置实况数据超时计时器
   * @param live
   */
  setOtherTimeout(live: LiveNotification): void {
    if (live.card?.isOtherCard()) {
      const time = live.deliveryTime + NotificationUtil.getOtherLiveTimeout(live) - Date.now();
      log.showInfo(`Set other live timeout for ${live.hashCode}, time: ${time}`);
      sysTimerMgr.startTimer({
        key: this.getKey(live),
        triggerTime: time,
        onTimer: this.onOtherCardTimeout,
        ignoreTriggerTimeCheck: true
      });
    }
  }

  /**
   * 设置实况提醒超时时间
   * @param live
   */
  setRemindTimeout(live: LiveNotification, isUpdate: boolean):void {
    log.showInfo(`start update remind live`);

    const key = this.getRemindTimerKey(live, isUpdate);

    if (!key) {
      log.showInfo(`key is invalid.`);
      return;
    }

    this.clearReminderTimer(key);

    let timerId: number | undefined;
    if (live.isInstant()) {
      log.showInfo(`Set instant live timeout for ${live.hashCode}, time: ${live.duration}`);
      timerId = setTimeout(() => {
        this.onInstantTimeout(key);
        this.remindTimerMap.delete(key);
      }, live.duration);
    } else if (isUpdate && live.isFlip()) {
      log.showInfo(`Set flip live timeout for ${live.hashCode}, time: ${LiveStyle.INSTANT_LIVE_TIMEOUT}`);
      timerId = setTimeout(() => {
        let task: TaskItem | undefined = undefined;
        task = new TaskItem('onFlipTimeout', () => this.onFlipTimeout(key));
        if (task) {
          task.timeout = NOTIFICATION_TIMEOUT;
          this.taskQueue.add(task);
        }
      }, LiveStyle.INSTANT_LIVE_TIMEOUT);
    }

    this.remindTimerMap.set(key, timerId as number);
  }

  private getRemindTimerKey(live: LiveNotification, isUpdate: boolean): string {
    let key: string = '';
    if (live.isInstant()) {
      key = this.getKey(live);
    } else if (isUpdate && live.isFlip()) {
      key = LiveCapsuleRemindType.FLIP + this.getKey(live);
    }
    return key;
  }

  private clearReminderTimer(key: string): void {
    if (this.remindTimerMap.get(key)) {
      log.showInfo(`recieve new remind update, clear timer: ${key}`);
      clearTimeout(this.remindTimerMap.get(key));
      this.remindTimerMap.delete(key);
    }
  }


  /**
   * 清理实况数据超时计时器
   * @param live
   */
  clearTimeout(live: LiveNotification): void {
    sysTimerMgr.destroyTimer(this.getKey(live));
  }

  /**
   * 三方实况数据超时移除实况
   */
  public onOtherCardTimeout = async (key: string): Promise<void> => {
    const hashCode = key.substring(TAG.length);
    const live = this.liveMap.get(hashCode);
    if (live) {
      log.showWarn(`Other live ${hashCode} is timeout, update status to end`);
      const newLive = live.clone();
      newLive.isEnd = true;
      NotificationDataManager.instance.updateExistNtf([newLive], NotificationEvent.UPDATE_TYPE_ANS);
      // 兼容老的实况数据超时逻辑，锁屏使用
      setTimeout(() => {
        InnerEventUtil.post(LiveTimeoutEvent, LiveTimeoutEvent.create(hashCode));
      });
      DeleteNotificationMaintenance.manualDelete([live], {
        deleteType: DeleteNotificationType.LIVE_DATA_EXPIRE_HIDE,
        isInGroup: false,
      }, DeleteNotificationErrorCode.CAPSULE_UPDATE_TIMEOUT);
    }
  };

  /**
   * 即时实况超时处理
   */
  public onInstantTimeout = async (key: string): Promise<void> => {
    const hashCode = key.substring(TAG.length);
    const live = this.liveMap.get(hashCode);
    if (live) {
      log.showWarn(`Instant live ${hashCode} is timeout, remove it`);
      DeleteNotificationMaintenance.addNtfMap([live], DeleteNotificationType.INSTANT_CAPSULE_TIMEOUT_DELETE, false);
      NotificationDataManager.instance.removeLiveView([live]);

      const remindVm = this.vmInjector.getLiveRemindVm();
      if (remindVm.isCurrentRemindCapsule(live)) {
        remindVm.clearRemindCapsule();
      }
    }
  };

  /**
   * 胶囊FLIP更新超时处理
   */
  public onFlipTimeout = async (key: string): Promise<void> => {
    const hashCode = key.substring(LiveCapsuleRemindType.FLIP.length + TAG.length);
    const live = this.liveMap.get(hashCode);
    if (live) {
      log.showWarn(`Flip Capsule ${hashCode} is timeout, toggle capsule`);

      const remindVm = this.vmInjector.getLiveRemindVm();
      if (remindVm.isCurrentRemindCapsule(live)) {
        remindVm.clearRemindCapsule();
      }
      await this.capsuleListVm.toggleCapsuleList({ isUpdateImmediately: false });
      this.remindTimerMap.delete(key);
    }
  }

  getKey(live: LiveNotification): string {
    return TAG + live.hashCode;
  }

  /**
   * 多任务一键清除，增加实况应用记录
   */
  private addLiveCloseContainer(live: LiveNotification): void {
    if (live.card?.isOtherCard() && !live.card?.isNavigationCard()) {
      log.showInfo('add closeContainer live: ' + live.hashCode);
      ScenePanelAdapter.addCloseContainerSession({
        bundleName: live.creatorBundleName,
        appIndex: live.appIndex,
      });
    }
  }

  /**
   * 多任务一键清除，删除实况应用记录
   */
  private removeLiveCloseContainer(live: LiveNotification): void {
    if (live.card?.isOtherCard() && !live.card?.isNavigationCard() &&
    !Array.from(this.liveMap.values()).find(e => e.creatorBundleName === live.creatorBundleName)) {
      log.showInfo('remove closeContainer live: ' + live.hashCode);
      ScenePanelAdapter.removeCloseContainer({
        bundleName: live.creatorBundleName,
        appIndex: live.appIndex,
      });
    }
  }

  /**
   * 处理一键清除任务
   */
  public onClearAllApp(): void {
    log.showInfo(`onClearAllApp start`);
    this.isClearAllApp = true;

    setTimeout(() => {
      log.showWarn(`onClearAllApp end`);
      this.isClearAllApp = false;
      const liveList = Array.from(NotificationDataManager.instance.ntfMap.values()).filter(
        (ntf) => ntf.isLiveView() && !ntf.isConvertFromNormal && !ntf.isInstantBanner()) as LiveNotification[];
      this.onInit(liveList);
    }, CLEAR_ALL_APP_DELAY);
  }
}