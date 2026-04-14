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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper';
import type { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import type { NtfListInfoKeyGuard, NtfListKeyGuard } from '@ohos/notificationcomponent/src/main/ets/model/NtfListKeyGuard';
import { ImmersiveNtfData } from './ImmersiveNtfData';
import { DefaultImmersiveUtils, HideNtfContentEvent, ImmersiveConstants, SysTypeCode } from '@ohos/systemuicommon';
import { immersiveNtfSceneHelper } from './ImmersiveNtfSceneHelper';
import { OneMirrorStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { immersiveStateHelper } from '../../common/helper/ImmersiveStateHelper';

const TAG = 'ImmersiveDataGroupPacker';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸锁屏通知分组数据处理器
 * 将单条数据封装为组通知
 * 更新分组数据的状态为隐藏等
 */
export class ImmersiveDataGroupPacker {
  /**
   * 沉浸锁屏分组通知数据集
   */
  private groupList: ImmersiveNtfData[] = [];

  /**
   * 通知列表VM, 用于接入通知数据
   */
  private ntfListVM?: NtfListKeyGuard;

  /**
   * 暂存分组前需要在锁屏中显示的通知原生数据列表
   */
  private lockScreenNtfList: NotificationEntry[] = [];

  /**
   * 多事件统一管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 上次分组数据个数
   */
  private oldGroupSize: number = 0;

  /**
   * 第一个可以进沉浸态的通知
   */
  private firstImmersiveCardNtfData?: ImmersiveNtfData = undefined;

  /**
   * 初始化
   *
   * @param groupList 组通知列表
   * @param ntfListVM NtfListKeyGuard
   */
  init(ntfListVM: NtfListKeyGuard) {
    this.ntfListVM = ntfListVM;
    this.eventMgr.on(HideNtfContentEvent, this.onHideNtfContentEvent);
  }

  /**
   * 释放资源
   */
  destroy(): void {
    this.deleteGroup();
    this.ntfListVM = undefined;
    ArrayUtils.clearArr(this.groupList);
    ArrayUtils.clearArr(this.lockScreenNtfList);
    this.eventMgr.offAll();
  }

  private deleteGroup(): void {
    this.groupList.forEach(data => {
      data?.deleteGroup();
    })
    ArrayUtils.clearArr(this.groupList);
    immersiveNtfSceneHelper.clearImmersiveDataScene();
    this.firstImmersiveCardNtfData = undefined;
  }

  /**
   * 获取分组后的通知数据
   *
   * @returns
   */
  getGroupList(): ImmersiveNtfData[] | undefined {
    return this.groupList;
  }

  /**
   * 通知列表是否为空
   */
  isEmptyGroupList(): boolean {
    return this.groupList.length === 0;
  }

  /**
   * 获取锁屏通知列表
   *
   * @returns 锁屏通知列表
   */
  getNtfList(): NotificationEntry[] {
    return this.lockScreenNtfList;
  }

  /**
   * 根据分组名获取锁屏通知列表数据
   *
   * @param groupKey 分组名
   * @returns 列表数据
   */
  findNativeData(groupKey: string): NotificationEntry | undefined {
    if (!groupKey) {
      return undefined;
    }
    for (let i = 0; i < this.lockScreenNtfList.length; i++) {
      if (this.lockScreenNtfList[i].getGroupKey() === groupKey) {
        return this.lockScreenNtfList[i];
      }
    }
    return undefined;
  }

  /**
   * 根据分组的groupKey获取分组数据
   *
   * @param groupKey 分组名
   * @returns 分组数据
   */
  findGroupData(groupKey: string): ImmersiveNtfData | undefined {
    if (!groupKey) {
      return undefined;
    }
    for (let i = 0; i < this.groupList.length; i++) {
      if (this.groupList[i].groupKey === groupKey) {
        return this.groupList[i];
      }
    }
    return undefined;
  }

  /**
   * 从锁屏通知列表读取通知数据并分组
   * 此处复用了原有通知中心NtfListVm模块的锁屏数据过滤和排序
   */
  packGroup(setHide?: boolean): void {
    let ntfListInfo: NtfListInfoKeyGuard | undefined = this.ntfListVM?.getLockScreenListInfo();
    this.lockScreenNtfList = ntfListInfo?.ntfList ?? [];
    this.oldGroupSize = this.getGroupSize();
    this.deleteGroup();
    this.lockScreenNtfList.forEach(data => {
      this.processGroupData(data, setHide);
    })
  }

  /**
   * 获取分组数据个数
   *
   * @returns 分组数据个数
   */
  getGroupSize(): number {
    return this.groupList.length;
  }

  /**
   * 获取上次分组数据个数
   *
   * @returns 上次分组数据个数
   */
  getOldGroupSize(): number {
    return this.oldGroupSize;
  }

  /**
   * 获取第一个可以进入沉浸态的通知
   *
   * @returns 第一个沉浸态卡片通知数据
   */
  getFirstCardData(): ImmersiveNtfData | undefined {
    return this.firstImmersiveCardNtfData;
  }

  /**
   * 从原始通知数据中取出每条子通知，根据分组键值groupKey查询已有分组数据
   * 未查询到分组数据时，则将当前子通知作为新的分组数据插入groupList
   * 查询到分组数据时，将当前子通知与已有分组数据合并
   *
   * @param data 子通知数据
   * @param flag 是否查找播控实况通知
   */
  private processGroupData(data: NotificationEntry, setHide?: boolean): void {
    if (!data || !data.childrenEntry) {
      return;
    }
    data.childrenEntry.forEach(newEntry => {
      if (!newEntry || !newEntry?.immersiveNtfData) {
        return;
      }
      newEntry?.immersiveNtfData.setNtfHide(newEntry?.isHideContent);
      newEntry?.immersiveNtfData.setAppLocked(newEntry?.isAppLocked);
      let group: ImmersiveNtfData | null =
        ArrayUtils.find(this.groupList, (newEntry?.immersiveNtfData as ImmersiveNtfData));
      if (!group) {
        group = newEntry?.immersiveNtfData as ImmersiveNtfData;
        group?.createGroup();
        this.groupList.push(group);
      } else {
        group?.addChildData(newEntry?.immersiveNtfData as ImmersiveNtfData);
      }
      immersiveNtfSceneHelper.setImmersiveDataScene(group.groupKey, newEntry.hashCode);
      // 如果是桌面到锁屏场景需要标识记录默认进沉浸态的数据
      if (!immersiveStateHelper.getOneMirrorStaticState()?.getSlState(OneMirrorStaticStateType.IS_DESKTOP_TO_SL)) {
        return;
      }
      // 播控实况处理
      if (DefaultImmersiveUtils.isEnableImmersiveBroad()) {
        // 如果当前通知是播控且播控属性未占用
        if (newEntry.liveViewData?.isSysTypeCode(SysTypeCode.BROADCASTING_CENTER) &&
          !this.firstImmersiveCardNtfData) {
          this.firstImmersiveCardNtfData = newEntry.immersiveNtfData as ImmersiveNtfData;
          return;
        }
      }
      // 三方实况处理
      if (DefaultImmersiveUtils.isEnableImmersiveLive() && !setHide &&
        !newEntry.liveViewData?.isSysTypeCode(SysTypeCode.BROADCASTING_CENTER)) {
        if (newEntry.immersiveNtfData?.shouldShowInImmersiveCard() &&
          !this.firstImmersiveCardNtfData &&
          DefaultImmersiveUtils.isEnableAppImmersive(newEntry.liveViewData?.creatorBundleName)) {
          this.firstImmersiveCardNtfData = newEntry.immersiveNtfData as ImmersiveNtfData;
        }
      }
    })
  }

  /**
   * 更新沉浸分组通知隐藏状态
   *
   */
  private onHideNtfContentEvent = (event?: HideNtfContentEvent): void => {
    if (!event || !event.groupKey) {
      return;
    }
    this.groupList.forEach(group => {
      if (group?.groupKey !== event.groupKey) {
        return;
      }
      group?.capsuleData?.setNtfHide(event.shouldHide);
    });
  }
}