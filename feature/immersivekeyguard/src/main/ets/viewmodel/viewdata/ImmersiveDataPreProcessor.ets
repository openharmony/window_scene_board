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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { ImmersiveConstants } from '../../common/ImmersiveConstants';
import { ImmersiveEntryEvent, ImmersiveType } from '@ohos/systemuicommon';
import {
  NtfEventType
} from '@ohos/systemuicommon';
import { ImmInvertColorMgr, ImmRunningLockMgr } from '@ohos/screenlockcommon/Index';
import { ImmersiveListVm } from '../ImmersiveListVm';
import { ImmersiveNtfData } from './ImmersiveNtfData';
import { ImmersiveCardVm } from '../ImmersiveCardVm';
import { ImmersiveSysEventUtil, Lifecycle } from '../../common/ImmersiveSysEventUtil';
import { immersiveNtfSceneHelper } from './ImmersiveNtfSceneHelper';
import { ImmersiveNtfScene } from '../../common/anim/ImmersiveAnimConstants';
import { UIExtentionLoadingStateMgr } from '../../model/manager/UIExtentionLoadingStateMgr';
import { ImmersiveCardHandle } from '../viewevent/ImmersiveCardHandle';
import { BaseNotification, immersiveKgMgr, SysTypeCode } from '@ohos/systemuicommon';
import { ImmersiveCapsuleVm } from '../ImmersiveCapsuleVm';
import { immersiveStateMgr } from '../../common/manager/ImmersiveStateManager';

const TAG = 'ImmersiveDataPreProcessor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸锁屏通知原生数据处理器
 * 针对从外部接收数据的新增、删除、更新等场景作预处理
 * 建立或取消数据与资源之间的关联关系
 *
 */
export class ImmersiveDataPreProcessor {
  /**
   * 原生通知数据集
   */
  private ntfMap: Map<string, BaseNotification> = new Map();

  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 沉浸列表业务管理器
   */
  private listVm?: ImmersiveListVm;

  /**
   * 沉浸卡片业务管理器
   */
  private cardVm?: ImmersiveCardVm;

  /**
   * 沉浸胶囊业务管理器
   */
  private capsuleVm?: ImmersiveCapsuleVm;

  /**
   * 沉浸卡片UI界面事件处理
   */
  private cardEventHandle?: ImmersiveCardHandle;

  /**
   * 通知数据事件处理器
   */
  private eventHandler: Map<NtfEventType, (ntfList: Array<BaseNotification>) => void> = new Map([
    [NtfEventType.EVENT_TYPE_INIT, (ntfList: Array<BaseNotification>): void => {
      this.handleNtfInit(ntfList);
    }],
    [NtfEventType.EVENT_TYPE_POST_ADD, (ntfList: Array<BaseNotification>): void => {
      this.handleNtfAddUpdate(ntfList, false);
    }],
    [NtfEventType.EVENT_TYPE_POST_UPDATE, (ntfList: Array<BaseNotification>): void => {
      this.handleNtfAddUpdate(ntfList, true);
    }],
    [NtfEventType.EVENT_TYPE_POST_CANCEL, (ntfList: Array<BaseNotification>): void => {
      this.handleNtfRemove(ntfList);
    }]
  ]);

  /**
   * 通知数据新增、更新、删除回调
   */
  private onImmersiveEntryEvent = (event?: ImmersiveEntryEvent): void => {
    if (!event || !event.notificationList) {
      return;
    }
    let eventType = (event?.eventType ?? NtfEventType.EVENT_TYPE_INIT) as NtfEventType;
    this.eventHandler.get(eventType)?.(event.notificationList);
  };

  /**
   * 初始化
   *
   * @param listVm 列表业务管理器 cardVM 卡片业务管理器 capsuleVm 胶囊业务管理器
   */
  init(listVm: ImmersiveListVm, cardVM: ImmersiveCardVm, capsuleVm: ImmersiveCapsuleVm): void {
    this.listVm = listVm;
    this.cardVm = cardVM;
    this.capsuleVm = capsuleVm;
    this.eventMgr.on(ImmersiveEntryEvent, this.onImmersiveEntryEvent);
  }

  /**
   * 释放vm
   */
  destroy(): void {
    this.eventMgr.offAll();
    this.ntfMap?.clear();
    immersiveNtfSceneHelper.clearNtfChangeScene();
  }


  /**
   * 设置沉浸卡片UI界面事件处理
   *
   * @param cardHandle 沉浸卡片UI界面事件处理
   */
  setImmersiveCardHandle(cardEventHandle?: ImmersiveCardHandle): void {
    this.cardEventHandle = cardEventHandle;
  }

  private handleNtfInit(ntfList: BaseNotification[]) {
    this.ntfMap?.clear();
    ntfList?.forEach(entry => {
      this.processAddOrUpdate(entry, true);
    })
  }

  private handleNtfAddUpdate(ntfList: BaseNotification[], arg1: boolean) {
    ntfList?.forEach(entry => {
      this.processAddOrUpdate(entry);
    })
  }

  private handleNtfRemove(ntfList: BaseNotification[]) {
    ntfList?.forEach(entry => {
      log.showInfo(`handleNtfRemove ${entry.hashCode}`);
      this.ntfMap?.delete(entry?.hashCode);
      let itemData = entry.immersiveNtfData as ImmersiveNtfData;
      if (!entry.isLiveType()) {
        ImmersiveSysEventUtil.reportNotifyLifeCycleEvent(itemData, Lifecycle.DELETE);
      }
      // 清除壁纸反色缓存
      ImmInvertColorMgr.getInstance().deleteCacheByHash(entry?.hashCode);
    })
  }

  private processAddOrUpdate(entry: BaseNotification, isInit?: boolean) {
    if (!entry || !entry.immersiveNtfData || !entry?.hashCode) {
      return;
    }
    let oldData = this.ntfMap?.get(entry?.hashCode);
    log.showInfo(`processAddOrUpdate isUpdate:${oldData !== undefined} entry.code:${entry?.hashCode}`);
    if (!oldData) {
      let itemData = entry.immersiveNtfData as ImmersiveNtfData;
      entry.liveViewData?.setIconClickListener(this.listVm?.getIconClickListener(itemData), true);
      entry.immersiveNtfData.setLiveViewData(entry.liveViewData, true);
      this.ntfMap?.set(entry?.hashCode, entry);
      if (!entry.isLiveType()) {
        ImmersiveSysEventUtil.reportNotifyLifeCycleEvent(itemData, Lifecycle.CREATE);
      }
      this.recordNtfScene(entry, ImmersiveNtfScene.SCENE_NTF_ADD, isInit);
    } else {
      this.cardVm?.setUpdateData(oldData.immersiveNtfData as ImmersiveNtfData, entry);
      oldData.immersiveNtfData?.update(entry.immersiveNtfData);
      entry.immersiveNtfData = oldData.immersiveNtfData;
      oldData.immersiveNtfData.setLiveViewData(entry.liveViewData, true);
      if (!entry.isLiveType()) {
        ImmersiveSysEventUtil.reportNotifyLifeCycleEvent(entry.immersiveNtfData as ImmersiveNtfData, Lifecycle.UPDATE);
      }
      this.recordNtfScene(entry, ImmersiveNtfScene.SCENE_NTF_UPDATE, isInit);
    }
    // 记录沉浸大卡常亮开关
    let cardData = (entry?.immersiveNtfData as ImmersiveNtfData)?.cardData;
    if (cardData) {
      ImmRunningLockMgr.getInstance().cacheRunningLockState(entry?.hashCode, cardData.isKeepScreenOnEnable());
      ImmRunningLockMgr.getInstance().requestUpdateRunningLockState(entry?.hashCode);
    }

    this.handlePhoneNtfToList(entry);
  }

  /**
   * 锁屏通话类实况以列表态展示
   *
   * @param entry 通知基础数据
   */
  private handlePhoneNtfToList(entry: BaseNotification) {
    if (!entry?.liveViewData?.isSysTypeCode(SysTypeCode.PHONE)) {
      return;
    }
    let immersiveState = immersiveKgMgr.getImmersiveDisplayState();
    let isCapsule = immersiveState.isCapsule();
    let isImmersive = immersiveState.isImmersive();
    log.showInfo(`ImmersiveCapsuleState is ${isCapsule} and immersiveCardState is ${isImmersive}`);
    if (isImmersive) {
      if (this.isSwitchState()) {
        immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_LIST);
      } else {
        this.cardEventHandle?.execCardToListAnim();
      }
    }
    if (isCapsule) {
      if (this.isSwitchState()) {
        immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_LIST);
      } else {
        this.capsuleVm?.startCapsuleToList();
      }
    }
  }

  /**
   * 是否直接切换锁屏通知状态
   *
   * @returns boolean 直接切换锁屏通知状态
   */
  private isSwitchState(): boolean {
    let length: number = this.listVm?.getNtfList()?.length ?? 0;
    log.showInfo(`length is ${length}`);
    if (length === 0) {
      return true;
    }
    return false;
  }

  private recordNtfScene(entry: BaseNotification, scene: ImmersiveNtfScene, isInit?: boolean) {
    if (isInit) {
      return;
    }
    if (scene === ImmersiveNtfScene.SCENE_NTF_ADD) {
      immersiveNtfSceneHelper.onNtfAdd(entry?.hashCode);
    } else if (scene === ImmersiveNtfScene.SCENE_NTF_UPDATE) {
      immersiveNtfSceneHelper.onNtfUpdate(entry?.hashCode);
    }
  }
}