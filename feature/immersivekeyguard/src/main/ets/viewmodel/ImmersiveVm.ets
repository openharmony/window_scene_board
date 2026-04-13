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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { ImmersiveConstants } from '../common/ImmersiveConstants';
import type { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import type { NtfListKeyGuard } from '@ohos/notificationcomponent/src/main/ets/model/NtfListKeyGuard';
import { NotificationType } from '@ohos/notificationcomponent/src/main/ets/common/NotificationType';
import NTF_LIST_VM_HOLDER from '@ohos/notificationcomponent/src/main/ets/model/NtfListVmHolder';
import { ImmersiveNtfData } from './viewdata/ImmersiveNtfData';
import { ImmersiveDataPreProcessor } from './viewdata/ImmersiveDataPreProcessor';
import { ImmersiveDataGroupPacker } from './viewdata/ImmersiveDataGroupProcessor';
import { ImmersiveAnimManager } from './viewanim/ImmersiveAnimManager';
import { ImmersiveCapsuleVm } from './ImmersiveCapsuleVm';
import { ImmersiveListVm } from './ImmersiveListVm';
import { ImmersiveCardVm } from './ImmersiveCardVm';
import {
  BaseNotification,
  immersiveKgMgr,
  ImmersiveType,
  ImmersiveTypeScene,
  SysTypeCode
} from '@ohos/systemuicommon';
import { ImmersiveCapsuleHandle } from './viewevent/ImmersiveCapsuleHandle';
import { ImmersiveListHandle } from './viewevent/ImmersiveListHandle';
import { ImmersiveCardHandle } from './viewevent/ImmersiveCardHandle';
import { ImmersiveExtendStyle } from '../model/data/ImmersiveExtendStyle';
import { ImmersiveMeshManager } from './viewlayout/ImmersiveMeshManager';
import {
  NtfDataChangeType,
  NtfListDataChangeListener
} from '@ohos/notificationcomponent/src/main/ets/model/NotificationListAdapter';
import {
  NtfGlobalStateCallback,
  NtfListInfoKeyGuard
} from '@ohos/notificationcomponent/src/main/ets/model/NtfListKeyGuard';
import { NotificationStateManager } from '@ohos/screenlockcommon';
import { ImmersiveSysEventUtil } from '../common/ImmersiveSysEventUtil';
import { ImmersiveEventStopHandle } from './viewevent/ImmersiveEventStopHandle';
import { immersiveDefaultCardDataHelper } from './viewdata/ImmersiveDefaultCardDataHelper';
import { immersiveStateHelper } from '../common/helper/ImmersiveStateHelper';
import {
  ListStaticStateType,
  OneMirrorStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { immersiveStateMgr } from '../common/manager/ImmersiveStateManager';
import { immersiveFgCtrl } from '../model/service/ImmersiveFingerControll';
import { cardList } from './viewdata/ImmersiveCardList';
import { PointCheckParam } from '../common/constants/ImmComConst';

const TAG = 'ImmersiveViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸锁屏卡片、胶囊数据统一管理
 */
class ImmersiveVm {
  /**
   * 通知列表VM, 用于接入通知数据
   */
  private ntfListVM?: NtfListKeyGuard;

  /**
   * 沉浸锁屏数据预处理器
   */
  private preProcessor: ImmersiveDataPreProcessor = new ImmersiveDataPreProcessor();

  /**
   * 沉浸通知分组分组
   */
  private groupManager: ImmersiveDataGroupPacker = new ImmersiveDataGroupPacker();

  /**
   * 沉浸锁屏动效管理器
   */
  private animMgr: ImmersiveAnimManager = new ImmersiveAnimManager();

  /**
   * 沉浸面板网格管理
   */
  private meshMgr: ImmersiveMeshManager = ImmersiveMeshManager.getInstance();

  /**
   * 沉浸胶囊业务管理
   */
  private capsuleVm: ImmersiveCapsuleVm =
    new ImmersiveCapsuleVm(this.animMgr, this.groupManager);

  /**
   * 沉浸列表业务管理
   */
  private listVm: ImmersiveListVm = new ImmersiveListVm(this.animMgr, this.meshMgr);

  /**
   * 沉浸卡片业务管理
   */
  private cardVm: ImmersiveCardVm = new ImmersiveCardVm(this.animMgr, this.groupManager);

  /**
   * 沉浸通知事件拦截管理
   */
  private eventStopHandle: ImmersiveEventStopHandle = new ImmersiveEventStopHandle();

  /**
   * 沉浸胶囊事件管理
   */
  private capEventHandle: ImmersiveCapsuleHandle = new ImmersiveCapsuleHandle()
    .bindCapsuleVm(this.capsuleVm).bindAnimMgr(this.animMgr).bindStopHandle(this.eventStopHandle);

  /**
   * 沉浸列表事件管理
   */
  private listEventHandle: ImmersiveListHandle = new ImmersiveListHandle()
    .bindListVm(this.listVm).bindAnimMgr(this.animMgr).bindStopHandle(this.eventStopHandle);

  /**
   * 卡片事件处理器
   */
  private cardEventHandle: ImmersiveCardHandle = new ImmersiveCardHandle()
    .bindCardVm(this.cardVm).bindAnimMgr(this.animMgr);

  private onHideContentChange: NtfGlobalStateCallback = {
    onHideContentChange: (isHideContent: boolean) => {
      this.processDataChange();
    }
  };
  /**
   * 锁屏通知数据监听对象
   */
  private ntfDataChange: NtfListDataChangeListener = {
    onNtfListDataChange: (dataSource: Array<NotificationEntry>, type ?: NtfDataChangeType) => {
      this.processDataChange();
    }
  };

  constructor() {
    immersiveDefaultCardDataHelper.init();
    immersiveDefaultCardDataHelper.setUiExtensionDataArr(cardList);
  }

  /**
   * 初始化
   */
  initVm(): void {
    this.ntfListVM = NTF_LIST_VM_HOLDER.getNtfListVmInstance(NotificationType.TYPE_PHONE_KEYGUARD) as NtfListKeyGuard;
    this.ntfListVM?.getNtfListAdapter()?.registerDataChangeListener(this.ntfDataChange);
    this.ntfListVM?.registerGlobalStateListener(this.onHideContentChange);
    this.preProcessor.init(this.listVm, this.cardVm, this.capsuleVm);
    this.preProcessor.setImmersiveCardHandle(this.cardEventHandle);
    this.groupManager.init(this.ntfListVM);
    this.meshMgr.init();
    let res = this.setDefaultImmersiveState();
    // 数据处理后重置销毁状态
    this.capsuleVm.setDestroy(false);
    this.cardVm.initVm();
    this.eventStopHandle.init();
    this.capEventHandle.init();
    this.listEventHandle.init();
    this.cardEventHandle.init();
    if (!res) {
      this.setImmersiveDefaultType();
    }
    immersiveStateHelper.getOneMirrorStaticState()?.setSlState(OneMirrorStaticStateType.IS_DESKTOP_TO_SL, false);
  }

  /**
   * 释放vm资源
   */
  destroy(): void {
    if (!this.ntfListVM) {
      return;
    }
    this.ntfListVM?.getNtfListAdapter()?.unregisterDataChangeListener(this.ntfDataChange);
    this.ntfListVM?.unregisterGlobalStateListener(this.onHideContentChange);
    this.ntfListVM = undefined;
    this.preProcessor.destroy();
    this.groupManager.destroy();
    this.meshMgr.destroy();
    // 数据处理前设置销毁状态
    this.capsuleVm.setDestroy(true);
    this.cardVm.destroy();
    this.processDataChange(true);
    this.eventStopHandle.destroy();
    this.capEventHandle.destroy();
    this.listEventHandle.destroy();
    this.cardEventHandle.destroy();
    immersiveKgMgr.setDefaultImmersiveType();
  }

  /**
   * 获取锁屏通知列表
   *
   * @returns 锁屏通知列表
   */
  getNtfListInfoKeyGuard(): NtfListInfoKeyGuard | undefined {
    return this.ntfListVM?.getLockScreenListInfo();
  }

  /**
   * 获取动效管理器
   *
   * @returns 动效管理器
   */
  getImmersiveAnimMgr(): ImmersiveAnimManager {
    return this.animMgr;
  }

  /**
   * 获取胶囊业务管理器
   *
   * @returns 胶囊业务管理器
   */
  getImmersiveCapsuleVm(): ImmersiveCapsuleVm {
    return this.capsuleVm;
  }

  /**
   * 获取列表业务管理器
   *
   * @returns 列表业务管理器
   */
  getImmersiveListVm(): ImmersiveListVm {
    return this.listVm;
  }

  /**
   * 获取卡片业务管理器
   *
   * @returns 卡片业务管理器
   */
  getImmersiveCardVm(): ImmersiveCardVm {
    return this.cardVm;
  }

  /**
   * 沉浸胶囊事件管理器
   *
   * @returns 事件管理器
   */
  getImmersiveCapsuleHandle(): ImmersiveCapsuleHandle {
    return this.capEventHandle;
  }

  /**
   * 获取卡片事件处理器
   *
   * @returns 卡片事件处理器
   */
  getCardEventHandle(): ImmersiveCardHandle {
    return this.cardEventHandle;
  }

  /**
   * 获取胶囊辅助区样式
   *
   * @returns ui样式
   */
  getCapsuleExtendStyle(): ImmersiveExtendStyle {
    return this.capsuleVm.getExtendUiStyle();
  }

  /**
   * 沉浸列表事件管理器
   *
   * @returns 事件管理器
   */
  getImmersiveListHandle(): ImmersiveListHandle {
    return this.listEventHandle;
  }

  /**
   * 根据分组名获取锁屏通知列表数据
   *
   * @param groupKey 分组名
   * @returns 列表数据
   */
  findNativeData(groupKey: string): BaseNotification | undefined {
    return this.groupManager.findNativeData(groupKey);
  }

  /**
   * 根据分组的groupKey获取分组数据
   *
   * @param groupKey 分组名
   * @returns 分组数据
   */
  findGroupData(groupKey: string): ImmersiveNtfData | undefined {
    return this.groupManager.findGroupData(groupKey);
  }

  /**
   * 获取锁屏通知列表
   *
   * @returns 锁屏通知列表
   */
  getNtfList(): BaseNotification[] {
    return this.groupManager.getNtfList();
  }

  /**
   * 设置沉浸面板高度
   *
   * @param height 高度
   */
  setImmersivePanelHeight(height: number | string): void {
    let listPanel = this.listVm.getPanelState();
    if (height !== listPanel.height) {
      listPanel.height = height;
    }
    let cardPanel = this.cardVm.getPanelState();
    if (height !== cardPanel.height) {
      cardPanel.height = height;
    }
  }

  /**
   * 获取沉浸网格状态管理
   *
   * @returns 沉浸网格状态管理
   */
  getImmersiveMeshManager(): ImmersiveMeshManager {
    return this.meshMgr;
  }

  /**
   * 沉浸模块三态热区匹配检测
   *
   * @param param 坐标参数
   * @returns true热区匹配
   */
  checkMatchHotZones(param: PointCheckParam): boolean {
    // 按需匹配热区
    if (this.listEventHandle.checkMatchHotZones(param.globalX, param.globalY)) {
      return true;
    }
    if (this.capEventHandle.checkMatchHotZones(param.globalX, param.globalY)) {
      return true;
    }
    if (this.cardEventHandle.checkMatchHotZones(param.globalX, param.globalY)) {
      return true;
    }
    return false;
  }

  /**
   * 沉浸模块三态精确位置匹配检测
   *
   * @param param 坐标参数
   * @returns true位置匹配
   */
  checkMatchExactArea(param: PointCheckParam): boolean {
    // 按需匹配位置
    if (this.listEventHandle.checkMatchHotZones(param.globalX, param.globalY)) {
      // 列表精确位置与热区一致
      return true;
    }
    if (this.capEventHandle.checkMatchHotZones(param.globalX, param.globalY)) {
      // 胶囊精确位置与热区一致
      return true;
    }
    if (this.cardEventHandle.checkMatchExactArea(param.globalX, param.globalY)) {
      return true;
    }
    return false;
  }

  handleImmersiveBackEvent(isSmallFoldOuterScreen: boolean = false): void {
    let immersiveState = immersiveKgMgr.getImmersiveDisplayState();
    let scene = ImmersiveTypeScene.SCENE_GESTURE_BACK;
    if (immersiveState.isList()) {
      NotificationStateManager.updateTouchVelocityY(0);
      immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_CAPSULE, false, scene);
      ImmersiveSysEventUtil.reportListToCapsuleEvent();
    } else if (immersiveState.isImmersive()) {
      if (isSmallFoldOuterScreen) {
        // 退出沉浸态，小外屏记忆能力置为默认非沉浸态
        immersiveKgMgr.setOuterDefaultImmState(false);
        immersiveVm.getCardEventHandle().execCardToCapsuleAnimForOuterScreen();
        return;
      }
      if (immersiveKgMgr.getBeforeImmersiveState().isCapsule() && !immersiveFgCtrl.isLowPosFingerPrint()) {
        immersiveVm.getCardEventHandle().execCardToCapsuleAnim();
        ImmersiveSysEventUtil.reportExitToCapsuleEvent();
        ImmersiveSysEventUtil.reportExitCpuMemEvent();
      } else {
        immersiveVm.getCardEventHandle().execCardToListAnim();
        ImmersiveSysEventUtil.reportExitToListEvent();
        ImmersiveSysEventUtil.reportExitCpuMemEvent();
      }
    }
  }

  /**
   * 数据刷新时需要更新分组数据列表，并更新UI数据
   */
  private processDataChange(isImmersiveDestroy?: boolean): void {
    this.groupManager.packGroup();
    this.cardVm.checkAndUpdateUiData(undefined, isImmersiveDestroy);
    this.capsuleVm.checkAndUpdateUiData();
  }

  /**
   * 设置默认的锁屏通知状态
   *  @returns 是否默认进入了沉浸态
   */
  private setDefaultImmersiveState(): boolean {
    let setContentHide: boolean | undefined = undefined;
    if (immersiveStateHelper.getSlListStaticState()?.getSlState(ListStaticStateType.NTF_LIST_HIDE_FLAG)) {
      setContentHide = true;
    }
    this.groupManager.packGroup(setContentHide);
    immersiveStateHelper.getSlListStaticState()?.setSlState(ListStaticStateType.NTF_LIST_HIDE_FLAG, false);
    return this.cardVm.checkShouldShowImmersiveDefault();
  }

  /**
   * 获取沉浸式通知消息管理器
   *
   * @returns
   */
  public getGroupManager(): ImmersiveDataGroupPacker {
    return this.groupManager;
  }

  /**
   * 设置通知默认的锁屏通知状态
   */
  private setImmersiveDefaultType(): void {
    let ntfList = this.ntfListVM?.getLockScreenListInfo()?.ntfList;
    let index = ntfList?.findIndex(entry => {
      return entry?.getFirstChildEntry()?.liveViewData?.isSysTypeCode(SysTypeCode.PHONE);
    });
    if (index !== undefined && index !== -1) {
      log.showWarn(`PhoneLiveNotification index is ${index}`);
      //通话类型实况通知，锁屏之上显示列表形态
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    } else {
      // 未设置成沉浸态，使用默认配置来设置锁屏通知状态,列表态或者胶囊态
      immersiveKgMgr.setDefaultImmersiveType();
    }
  }
}

// 单例
export let immersiveVm: ImmersiveVm = SingletonHelper.getInstance(ImmersiveVm, TAG);