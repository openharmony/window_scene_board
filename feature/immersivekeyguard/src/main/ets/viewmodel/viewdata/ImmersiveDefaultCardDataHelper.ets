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

import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus } from '@ohos/frameworkwrapper';
import { ImmersiveConstants } from '../../common/ImmersiveConstants';
import { BaseNotification, ImmersiveEntryEvent, NtfEventType,
  DefaultImmersiveUtils,
  immersiveKgMgr} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ImmersiveNtfData } from './ImmersiveNtfData';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { LimitMap } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/utils/LimitMap';
import { LimitSet } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/utils/LimitSet';
import { OneMirrorStaticStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { LiveViewHideContentEvent } from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import { NotificationStateManager } from '@ohos/screenlockcommon';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { IUiExtensionDataArr } from '../../model/interface/IUiExtensionDataArr';

const TAG = 'ImmersiveCardDataHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 这里做一个限制，最多记录下2000个沉浸卡片
const MAX_IMMERSIVE_CARD_NUM = 2000;

/**
 * 沉浸锁屏数据监听，记录所有可进沉浸态通知卡片
 */
class ImmersiveDefaultCardDataHelper {
  // 实况数据全集，hashcode - 通知数据
  private allLiveList: LimitMap<string, BaseNotification> = new LimitMap(TAG, MAX_IMMERSIVE_CARD_NUM);
  // 有效沉浸大卡数据集，hashcode
  private validImmList: LimitSet<string> = new LimitSet(TAG, MAX_IMMERSIVE_CARD_NUM);
  // 是否开启实况隐藏内容
  private isLiveHideContent: boolean = false;
  // 是否存在沉浸态数据
  private hasImmData: boolean = false;
  // 沉浸卡片UI数据
  private cardList: IUiExtensionDataArr | undefined = undefined;

  /**
   * 通知数据事件处理器
   */
  private eventHandler: Map<NtfEventType, (ntfList: Array<BaseNotification>) => void> = new Map([
    [NtfEventType.EVENT_TYPE_INIT, (ntfList: Array<BaseNotification>): void => {
      this.handleNtfInit(ntfList);
    }],
    [NtfEventType.EVENT_TYPE_POST_ADD, (ntfList: Array<BaseNotification>): void => {
      this.handleNtfAdd(ntfList);
    }],
    [NtfEventType.EVENT_TYPE_POST_UPDATE, (ntfList: Array<BaseNotification>): void => {
      this.handleNtfUpdate(ntfList);
    }],
    [NtfEventType.EVENT_TYPE_POST_CANCEL, (ntfList: Array<BaseNotification>): void => {
      this.handleNtfRemove(ntfList);
    }]
  ]);

  private updateData = (event?: ImmersiveEntryEvent): void => {
    if (!event || !event.notificationList) {
      return;
    }
    let eventType = (event?.eventType ?? NtfEventType.EVENT_TYPE_INIT) as NtfEventType;
    this.eventHandler.get(eventType)?.(event.notificationList);
  };

  private onLiveViewHideContentEvent = (event: LiveViewHideContentEvent): void => {
    NotificationStateManager.setHideLiveViewFlag(event.isLiveViewHideContentEnable());
  };

  constructor() {
    if (DefaultImmersiveUtils.isEnableDefaultImmersive()) {
      EvtBus.on(ImmersiveEntryEvent, this.updateData);
      EvtBus.on(LiveViewHideContentEvent, this.onLiveViewHideContentEvent);
    }
  }

  /**
   * init空方法，让对象进行初始化
   *
   */
  public init(): void {
  }

  /**
   * 设置通知是否支持沉浸态,沉浸大图异步加载后使用
   *
   */
  public addImmersiveNtfDataToShow(hashCode: string): void {
    if (this.tryAddImmData(hashCode)) {
      this.checkDefaultShowImm();
    }
  }

  private handleNtfRemove(ntfList: BaseNotification[]): void {
    ntfList?.forEach(entry => {
      this.tryRemoveImmData(entry?.hashCode);
      this.tryRemoveLiveData(entry?.hashCode);
    });
    // 刷新默认沉浸态
    this.checkDefaultShowImm();
  }

  private handleNtfAdd(ntfList: BaseNotification[]): void {
    this.processAddOrUpdateNtf(ntfList);
  }

  private handleNtfUpdate(ntfList: BaseNotification[]): void {
    this.processAddOrUpdateNtf(ntfList);
  }

  private handleNtfInit(ntfList: BaseNotification[]): void {
    this.processAddOrUpdateNtf(ntfList);
  }

  private processAddOrUpdateNtf(ntfList: BaseNotification[]): void {
    ntfList?.forEach(entry => {
      if (!this.tryAddLiveData(entry)) {
        this.tryRemoveImmData(entry?.hashCode);
        return;
      }
      if (!this.tryAddImmData(entry?.hashCode)) {
        this.tryRemoveImmData(entry?.hashCode);
      }
    });
    // 刷新默认沉浸态
    this.checkDefaultShowImm();
  }

  private shouldShowImmersiveNtfData(ntfData: ImmersiveNtfData): boolean {
    if (!ntfData || !ntfData.cardData) {
      return false;
    }
    // 播控允许默认沉浸态
    if (DefaultImmersiveUtils.isEnableImmersiveBroad() && ntfData.cardData.isMediaCenter()) {
      return true;
    }
    // 其他沉浸实况，在隐藏内容时均无法默认沉浸态
    if (this.isLiveHideContent) {
      return false;
    }
    // 判断是否是可以进沉浸态的通知
    if (DefaultImmersiveUtils.isEnableImmersiveLive() && ntfData.shouldShowInImmersiveCard() &&
      DefaultImmersiveUtils.isEnableAppImmersive(ntfData.creatorBundleName)) {
      return true;
    }
    return false;
  }

  private flagMediaCenter(hasMediaCenter: boolean): void {
    // 标记存在播控沉浸数据
    slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
    ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, hasMediaCenter);
  }

  private checkDefaultShowImm(): void {
    const curHasImmData = !this.validImmList.isEmpty();
    if (this.hasImmData !== curHasImmData) {
      log.showInfo(`checkDefaultShowImm curHasImmData: ${curHasImmData}`);
      this.hasImmData = curHasImmData;
      let oneMirrorSt = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE);
      oneMirrorSt?.setSlState(OneMirrorStaticStateType.IS_NEED_SHOW_IMMERSIVE, curHasImmData);
      // 当沉浸态数据归0时，小外屏记忆能力恢复为默认进沉浸态
      if (!curHasImmData) {
        immersiveKgMgr.setOuterDefaultImmState(true);
      }
    }
  }

  private tryAddLiveData(ntf: BaseNotification): boolean {
    if (!ntf) {
      return false;
    }
    if (!ntf.isLiveType() || !Boolean(ntf.immersiveNtfData)) {
      return false;
    }
    // 缓存实况通知
    this.allLiveList.set(ntf.hashCode, ntf);
    return true;
  }

  private tryRemoveLiveData(hashcode: string): boolean {
    return this.allLiveList.delete(hashcode);
  }

  private tryAddImmData(hashcode: string): boolean {
    let ntf = this.allLiveList.get(hashcode) as NotificationEntry;
    if (!ntf) {
      return false;
    }
    // 锁屏不可见，无需添加
    if (ntf.isHiddenInKeyGuard()) {
      return false;
    }
    // 非沉浸卡片，无需添加
    let immData = ntf.immersiveNtfData as ImmersiveNtfData;
    if (!this.shouldShowImmersiveNtfData(immData)) {
      return false;
    }
    // 标记播控
    if (immData.cardData?.isMediaCenter()) {
      this.flagMediaCenter(true);
    }
    this.validImmList.add(hashcode);
    return true;
  }

  private tryRemoveImmData(hashcode: string): boolean {
    let immData = this.allLiveList.get(hashcode)?.immersiveNtfData as ImmersiveNtfData;
    if (immData?.cardData?.isMediaCenter()) {
      this.flagMediaCenter(false);
    }
    this.cardList?.removeUiExtensionData(immData);
    return this.validImmList.delete(hashcode);
  }

  /**
   * 设置沉浸卡片UI数据
   *
   * @param arr 沉浸卡片UI数据
   */
  public setUiExtensionDataArr(arr: IUiExtensionDataArr): void {
    this.cardList = arr;
  }
}

// 单例
export let immersiveDefaultCardDataHelper: ImmersiveDefaultCardDataHelper =
  SingletonHelper.getInstance(ImmersiveDefaultCardDataHelper, TAG);