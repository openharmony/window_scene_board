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
import { CustomPromise } from '@ohos/frameworkwrapper';
import { DomainName, LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveViewShowAuthEvent, NotificationEvent, NotificationEventForBridge } from '../event/NotificationEvent';
import { NotificationBase, NotificationBaseForBridge } from '../model/NotificationBase';
import { InnerEventUtil } from '../utils/InnerEventUtil';
import { Singleton } from '../utils/Singleton';
import { notificationSubscribe } from '@kit.NotificationKit';
import { crossModuleCallUtil } from '../utils/CrossModuleCallUtil';
import { TraceUtil } from '@ohos/basicutils';
import {
  DeleteNotificationErrorCode,
  DeleteNotificationMaintenance } from '../maintenance/DeleteNotificationMaintenance';
import { LiveNotification } from '../live/model/LiveNotification';
import wantAgent, { WantAgent } from '@ohos.app.ability.wantAgent';
import { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import { LiveExceptionCode } from '../live/constants/LiveExceptionCode';
import { LiveViewDataStatus } from '../liveview/common/LiveConstants';
import { messageChannel } from '../messageChannel/MessageChannel';

const TAG = 'NotificationDataManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知冻结原因
 */
enum NotificationFrozenReason {
  /**
   * 通知中心移除
   */
  DROPDOWN_REMOVE = 'DROPDOWN_REMOVE_NOTIFICATION',
  /**
   * 通知中心拉起应用
   */
  DROPDOWN_START_WANTAGENT = 'DROPDOWN_START_WANTAGENT',
  /**
   * 实况卡片移除
   */
  LIVE_PANEL_REMOVE = 'LIVE_PANEL_REMOVE',
  /**
   * 实况面板展开
   */
  LIVE_PANEL_EXPAND = 'LIVE_PANEL_EXPAND',
  /**
   * 实况面板展开
   */
  LIVE_PANEL_COLLAPSE = 'LIVE_PANEL_COLLAPSE',
  /**
   * 胶囊列表动效
   */
  LIVE_CAPSULE_ANIM = 'LIVE_CAPSULE_ANIM',
  /**
   * 实况卡片更新动效
   */
  LIVE_UPDATE_ANIM = 'LIVE_UPDATE_ANIM',
  /**
   * 通知中心下拉跟手
   */
  DROPDOWN_MOVE_DOWN = 'DROPDOWN_MOVE_DOWN',
}

/**
 * 通知数据管理
 */
export class NotificationDataManager {
  public static readonly REASON = NotificationFrozenReason;

  @Singleton.decorate()
  public static get instance(): NotificationDataManager { return new NotificationDataManager(); }

  /**
   * 通知集
   * 通知hashCode => 通知数据
   */
  public readonly ntfMap: Map<string, NotificationBase> = new Map();

  private freezeReasonMap: Map<NotificationFrozenReason, number> = new Map();
  private freezePromise?: CustomPromise<void>;
  private isPostNtfNonUpdateEvent: boolean = false;

  /**
   * 初始化
   */
  public init(): void {
    InnerEventUtil.produceOn(NotificationEvent, this.onProduceNtfEvent);
    crossModuleCallUtil.register('hasNotification', this.hasNtf);
    messageChannel.onMessage('updateAuthorization', (hashCode: string) => this.updateAuthorization(hashCode));
  }

  /**
   * 保存从ANS收到的通知数据
   *
   * @param ntf 通知数据
   * @return true更新数据，false新增数据
   */
  public saveNtf(ntf: NotificationBase): boolean {
    const isUpdate = this.ntfMap.has(ntf.hashCode);
    log.showWarn(`SaveNtf ${ntf.hashCode}, isUpdate: ${isUpdate}`);
    if (isUpdate) {
      this.ntfMap.get(ntf.hashCode).releaseImages(ntf);
    }
    this.ntfMap.set(ntf.hashCode, ntf);
    return isUpdate;
  }

  /**
   * 使用新传入的通知对象更新已有通知数据
   * @param oldNtfList 待更新通知列表
   * @param isBatch 是否为批量更新
   * @param updateType 通知更新场景，传入更新类型
   */
  public async updateExistNtf(oldNtfList: NotificationBase[], updateType?: number): Promise<void> {
    const newNtfList: NotificationBase[] = [];
    for (const oldNtf of oldNtfList) {
      if (!this.ntfMap.has(oldNtf.hashCode)) {
        log.showWarn(`Not find ${oldNtf.hashCode} in ntfMap`);
        continue;
      }
      const newNtf = oldNtf.clone();
      newNtf.enableHeadsUp(false);
      this.ntfMap.set(newNtf.hashCode, newNtf);
      newNtfList.push(newNtf);
    }

    log.showInfo(`Update exist ntf length: ${newNtfList.length}, updateType: ${updateType}`);
    await this.postNtfEvent(NotificationEvent.EVENT_TYPE_UPDATE, newNtfList, updateType);
  }

  public async updateAuthorization(hashCode: string): Promise<void> {
    const ntf = this.ntfMap.get(hashCode);
    if (ntf && ntf.isLiveView() && ntf.card.isOtherCard()) {
      ntf.card.isShowAuthorization = false;
      log.showInfo(`Update ${hashCode} isShowAuthorization false`);
      const event = new LiveViewShowAuthEvent(hashCode);
      InnerEventUtil.post(LiveViewShowAuthEvent, event);
    }
  }

  /**
   * 删除本地通知数据，主要给ANS回调使用
   * @param ntfList
   * @param isInMap 通知是否在ntfMap内。部分场景如超数量上限，此时通知已经从map中移除了
   * @returns
   */
  public async removeLocalNtf(ntfList: NotificationBase[], isInMap = true): Promise<void> {
    LogWithHa.warn(log, `remove local ntf list ${ntfList.map((ntf) => ntf.hashCode)}`, LiveExceptionCode.LOCAL_LIVE_STACK_INFO, new Error());
    ntfList = this.flatNtfList(ntfList);
    const validNtfList: NotificationBase[] = [];
    const invalidNtfList: NotificationBase[] = [];
    for (const ntf of ntfList) {
      ntf.releaseImages();
      if (isInMap) {
        if (!this.ntfMap.has(ntf.hashCode)) {
          invalidNtfList.push(ntf);
          continue;
        }
        this.ntfMap.delete(ntf.hashCode);
      }
      validNtfList.push(ntf);
    }

    if (validNtfList.length) {
      log.showWarn(`Remove ntfList: ${validNtfList.map((ntf) => ntf.hashCode).join(', ')}`);
      this.postNtfEvent(NotificationEvent.EVENT_TYPE_REMOVE, validNtfList);
    }
    if (invalidNtfList.length) {
      log.showWarn(`Remove invalid ntfList: ${invalidNtfList.map((ntf) => ntf.hashCode).join(', ')}`);
      this.postNtfEvent(NotificationEvent.EVENT_TYPE_REMOVE, invalidNtfList);
    }
  }

  public async removeLocalNtfByHashCode(hashCodes: string[]): Promise<void> {
    const ntfList: NotificationBase[] = [];
    for (let i = 0; i < hashCodes.length; i++) {
      const ntf = this.ntfMap.get(hashCodes[i]);
      if (!ntf) {
        log.showInfo(`ntf is not in map: ${hashCodes[i]}}`);
        continue;
      }
      ntfList.push(ntf);
    }
    if (!ntfList.length) {
      return;
    }
    await this.removeLocalNtf(ntfList);
  }

  /**
   * 删除实况
   * @param ntfList
   * @returns
   */
  public async removeLiveView(ntfList: NotificationBase[], isClick: boolean = false,
    isInMap: boolean = true): Promise<void> {
    log.showWarn('Remove liveViewList');
    ntfList = this.flatNtfList(ntfList);
    if (isClick) {
      this.removeAnsNtf(ntfList, notificationSubscribe.RemoveReason.CLICK_REASON_REMOVE);
    } else {
      this.removeAnsNtf(ntfList, notificationSubscribe.RemoveReason.CANCEL_REASON_REMOVE);
    }
    await this.removeLocalNtf(ntfList, isInMap);
  }

  /**
   * 发送通知列表初始化事件
   */
  public async postInitNtfEvent(): Promise<void> {
    await this.postNtfEvent(NotificationEvent.EVENT_TYPE_INIT, Array.from(this.ntfMap.values()));
  }

  /**
   * 发送新增通知事件
   * @param ntf 通知集
   */
  public async postAddNtfEvent(ntf: NotificationBase): Promise<void> {
    await this.postNtfEvent(NotificationEvent.EVENT_TYPE_ADD, [ntf]);
  }

  /**
   * 发送更新通知事件
   * @param ntfList 通知集
   */
  public async postUpdateNtfEvent(ntf: NotificationBase): Promise<void> {
    await this.postNtfEvent(NotificationEvent.EVENT_TYPE_UPDATE, [ntf], NotificationEvent.UPDATE_TYPE_ANS);
  }

  /**
   * 判断是否存在某条通知
   * @param creatorUid
   * @param ntfId
   * @returns
   */
  public hasNtf = (creatorUid: number, ntfId: number): boolean => {
    let hasNotification = false;
    for (const entry of this.ntfMap.values()) {
      if (entry?.creatorUid === creatorUid && entry?.id === ntfId) {
        hasNotification = true;
        break;
      }
    }
    return hasNotification;
  };

  /**
   * 冻结通知数据更新
   * @param reason
   */
  public freeze(reason: NotificationFrozenReason, timeout = 500): void {
    log.showInfo(`Freeze with reason: ${reason}`);
    TraceUtil.startTrace(DomainName.SYS_UI, `${TAG}_Freeze:${reason}`);
    if (!this.freezePromise) {
      this.freezePromise = new CustomPromise();
    }
    if (this.freezeReasonMap.has(reason)) {
      clearTimeout(this.freezeReasonMap.get(reason));
    }
    // 设置超时500ms后自动解冻，避免业务不调用解冻导致通知数据一直不更新
    const freezeTimerId = setTimeout(() => {
      log.showWarn(`Timeout for freeze reason: ${reason}`);
      this.unfreeze(reason);
    }, timeout);
    this.freezeReasonMap.set(reason, freezeTimerId);
  }

  /**
   * 解冻通知数据更新
   * @param reason
   */
  public unfreeze(reason: NotificationFrozenReason): void {
    log.showInfo(`Unfreeze with reason: ${reason}`);
    if (this.freezeReasonMap.has(reason)) {
      clearTimeout(this.freezeReasonMap.get(reason));
      this.freezeReasonMap.delete(reason);
    }

    if (this.freezePromise && this.freezeReasonMap.size === 0) {
      this.freezePromise.resolve();
      this.freezePromise = undefined;
    }

    TraceUtil.endTrace(DomainName.SYS_UI, `${TAG}_Freeze:${reason}`);
  }

  /**
   * 手动调用删除通知数据
   * @param ntfList
   * @param reason
   * @returns
   */
  private async removeAnsNtf(ntfList: NotificationBase[], reason: notificationSubscribe.RemoveReason): Promise<void> {
    const hashCodes: string[] = ntfList.map((ntf) => ntf.hashCode);
    log.showInfo(`Notify ans remove notification [${hashCodes}] begin`);
    const deleteInfo = DeleteNotificationMaintenance.getDeleteInfo(ntfList);
    try {
      await notificationSubscribe.remove(hashCodes, reason);
      DeleteNotificationMaintenance.manualDelete(ntfList, deleteInfo, undefined);
      log.showWarn(`Notify ans remove notification [${hashCodes}] end`);
    } catch (e) {
      DeleteNotificationMaintenance.manualDelete(ntfList, deleteInfo,
        DeleteNotificationErrorCode.NTF_CANCEL_FAIL);
      log.error(`Notify ans remove notification [${hashCodes}] error:`, e);
    }
  }

  /**
   * 检查通知数据是否冻结，冻结的话会等待解冻
   * @returns
   */
  public async checkFreeze(): Promise<void> {
    if (this.freezePromise) {
      await this.freezePromise;
    }
  }

  /**
   * 创建通知事件
   * @param eventType 事件类型
   * @param ntfList 通知集
   * @returns
   */
  private createNtfEvent(eventType: number, ntfList: NotificationBase[]): NotificationEvent {
    log.showInfo(`postNtfEvent type: ${eventType}, length: ${ntfList?.length}`);
    const event = new NotificationEvent(eventType, ntfList);
    return event;
  }

  /**
   * 发送通知事件，需要根据冻结场景进行等待
   * @param eventType 事件类型
   * @param ntfList 通知集
   * @param updateType 通知更新场景，传入更新类型
   */
  private async postNtfEvent(eventType: number, ntfList: NotificationBase[], updateType?: number): Promise<void> {
    if (this.checkNeedWaitFreeze(eventType, ntfList)) {
      this.isPostNtfNonUpdateEvent = true;
      await this.checkFreeze();
      this.isPostNtfNonUpdateEvent = false;
      this.createAndPostEvent(eventType, ntfList, updateType);
      return;
    }

    // 检查当前是否存在等待事件
    if (this.isPostNtfNonUpdateEvent) {
      await this.checkFreeze();
      this.createAndPostEvent(eventType, ntfList, updateType);
      return;
    }

    this.createAndPostEvent(eventType, ntfList, updateType);
  }

  /**
   * 检查需要等待的场景
   * @param eventType
   * @param ntfList
   * @param isBatch
   * @returns
   */
  private checkNeedWaitFreeze(eventType: number, ntfList: NotificationBase[]): boolean {
    // 非更新
    if (eventType !== NotificationEvent.EVENT_TYPE_UPDATE) {
      return true;
    }

    // 强提醒
    if (ntfList[0]?.isLiveView()) {
      const live: LiveNotification = ntfList[0];
      if (live.isFlip() || live.isExpand()) {
        return true;
      }
    }

    return false;
  }

  /**
   * 发送通知事件
   * @param eventType 事件类型
   * @param ntfList 通知集
   * @param updateType 通知更新场景，传入更新类型
   */
  private createAndPostEvent(eventType: number, ntfList: NotificationBase[], updateType?: number): void {
    const event = this.createNtfEvent(eventType, ntfList);
    if (eventType === NotificationEvent.EVENT_TYPE_UPDATE && updateType !== undefined) {
      // update事件，设置触发更新的变更类型
      event.updateType = updateType;
    }
    InnerEventUtil.post(NotificationEvent, event);

    this.postNotificationForBridge(event);
  }

  /**
   * 发送精简版通知事件到主线程，只提供必要的字段
   * @param event 完整的通知事件
   */
  private postNotificationForBridge(event: NotificationEvent): void {
    const ntfList: NotificationBaseForBridge[] = [];
      event.notificationList.forEach(ntf => {
        ntfList.push({
          hashCode: ntf.hashCode,
          id: ntf.id,
          creatorUid: ntf.creatorUid,
          isLiveView: ntf.isLiveView(),
          slotType: ntf.slotType,
          liveViewData: ntf.isLiveView() ? {
            event: ntf.card?.isOtherCard() ? ntf.card.event : undefined,
            status: ntf.isEnd ? LiveViewDataStatus.END : LiveViewDataStatus.CREATE,
            isSupportImm: ntf.isSupportImmersive(),
          } : undefined,
        });
    });

    const ntfEventForBridge = new NotificationEventForBridge(event.eventType, ntfList);
    InnerEventUtil.post(NotificationEventForBridge, ntfEventForBridge);
  }

  /**
   * 通知事件生产者
   * 返回通知初始化列表
   * @return 初始化列表
   */
  private onProduceNtfEvent = (): NotificationEvent => {
    log.showInfo(`onProduceNtfEntryEvent, ntfList length is: ${this.ntfMap?.size}`);
    return this.createNtfEvent(NotificationEvent.EVENT_TYPE_INIT, Array.from(this.ntfMap.values()));
  };

  /**
   * 将通知列表打平，如果有组通知则需要拆成子通知
   * @param ntfList
   * @returns
   */
  private flatNtfList(ntfList: NotificationBase[]): NotificationBase[] {
    const flatNtfList: NotificationBase[] = [];
    for (const ntf of ntfList) {
      if (ntf.isNormalGroup()) {
        flatNtfList.push(...ntf.children);
      } else {
        flatNtfList.push(ntf);
      }
    }
    return flatNtfList;
  }
}