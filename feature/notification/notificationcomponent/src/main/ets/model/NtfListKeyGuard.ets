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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ScreenLockEvent, ScreenOnOffEvent } from '@ohos/frameworkwrapper';
import { SCBOobeManager } from '@ohos/windowscene';
import { NtfAutoScreenOnEvent, NtfHideContentEvent, LiveViewHideContentEvent } from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import { LiveTimeoutEvent } from '@ohos/systemuicommon';
import { NotificationEntry } from './NotificationEntry';
import { NtfListCallback, NtfListVm } from './NtfListVm';
import { UserSwitchService } from '@ohos/screenlockcommon/src/main/ets/services/UserSwitchService';

const TAG = 'NtfListKeyGuard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NtfListKeyGuard extends NtfListVm {
  /**
   * 锁屏实况通知是否隐藏通知内容
   */
  private isLiveViewHideContent: boolean = false;

  /**
   * 全局状态监听
   */
  private gloalStateListeners: Set<NtfGlobalStateCallback> = new Set();

  /**
   * 检测是否需要隐藏实况通知内容
   */
  private checkShouldHideLiveViewContent(): void {
    log.showInfo(`isLiveViewHideContent:${this.isLiveViewHideContent} isSecureAndLocked:${this.isSecureAndLocked}`);
    let shouldHide = this.isLiveViewHideContent && this.isSecureAndLocked;
    if ((shouldHide != this.shouldHideLiveViewContent) || this.hasAppLocked) {
      this.shouldHideLiveViewContent = this.isLiveViewHideContent && this.isSecureAndLocked;
      this.hasAppLocked = false;
      this.ntfAdapterList.forEach((entry: NotificationEntry) => {
        if (!entry.isLiveType()) {
          return;
        }
        this.setEntryHideContent(entry, this.isLiveViewHideContent && this.isSecureAndLocked);
        entry.notifyDataChanged();
        entry.childrenEntry?.forEach((childEntry: NotificationEntry) => {
          childEntry?.notifyDataChanged();
        });
      });
      this.gloalStateListeners.forEach((listener) => listener.onHideContentChange?.(this.shouldHideLiveViewContent));
    }
  }

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private onScreenOnOffEvent = (event: ScreenOnOffEvent): void => {
    this.isScreenOn = event.isScreenOn();
    log.showInfo(`onScreenOnOffEvent isScreenOn: ${event.isScreenOn()}`);
  }

  /**
   * 收到通知自动亮屏开关事件
   *
   * @param event 事件
   */
  private onNtfAutoScreenOnEvent = (event: NtfAutoScreenOnEvent): void => {
    this.isNtfAutoScreenOn = event.isNtfAutoScreenOnEnable();
    log.showInfo(`onNtfAutoScreenOnEvent isNtfAutoScreenOn: ${event.isNtfAutoScreenOnEnable()}`);
  }

  /**
   * 锁屏隐藏实况内容开关事件
   *
   * @param event 事件
   */
  private onLiveViewHideContentEvent = (event: LiveViewHideContentEvent): void => {
    this.isLiveViewHideContent = event.isLiveViewHideContentEnable();
    log.showInfo(`this.isLiveViewHideContent:${this.isLiveViewHideContent}`);
    this.checkShouldHideLiveViewContent();
  }

  protected handleScreenLockEvent(event: ScreenLockEvent) {
    let isSecureAndLocked = event.isSecureAndLocked();
    if (this.isSecureAndLocked !== isSecureAndLocked) {
      this.isSecureAndLocked = isSecureAndLocked;
      this.callback?.onKgLockStateChange?.(isSecureAndLocked);
    }
    this.checkShouldHideNtfContent();
    this.checkShouldHideLiveViewContent();
  }

  /**
   * 检测是否需要隐藏通知内容
   */
  protected checkShouldHideNtfContent(): void {
    let shouldHide = this.isNtfHideContent && this.isSecureAndLocked;
    if (shouldHide !== this.shouldHideNtfContent) {
      log.showWarn(`isNtfHideContent:${this.isNtfHideContent} isSecureAndLocked:${this.isSecureAndLocked}`);
      this.shouldHideNtfContent = shouldHide;
      this.updateEntry();
      this.gloalStateListeners.forEach((listener) => listener.onHideContentChange?.(this.shouldHideNtfContent));
    }
  }

  /**
   * 实况数据超时事件
   */
  private onLiveTimeoutEvent = (event: LiveTimeoutEvent): void => {
    log.showInfo('onLiveTimeoutEvent keyguard hide: ' + event?.hashCode);

    // 超时数据，在锁屏页面不显示
    if (CommonUtils.isInvalid(event?.hashCode)) {
      return;
    }
    let entry = this.ntfAdapterList.find((value) => {
      let child = value?.getFirstChildEntry();
      return value?.hashCode === event?.hashCode || child?.hashCode === event?.hashCode;
    });
    entry = entry?.getFirstChildEntry();
    if (CommonUtils.isInvalid(entry)) {
      return;
    }

    // 删除数据
    let array: NotificationEntry[] = [];
    array.push(entry!);
    this.handleNtfRemove(array);
  };

  init(callback: NtfListCallback): void {
    super.init(callback);
    this.eventMgr.on(ScreenOnOffEvent, this.onScreenOnOffEvent)
      .on(NtfAutoScreenOnEvent, this.onNtfAutoScreenOnEvent)
      .on(LiveViewHideContentEvent, this.onLiveViewHideContentEvent)
      .on(LiveTimeoutEvent, this.onLiveTimeoutEvent);
  }

  getLockScreenListInfo(lockTimeFromParam: number = -1): NtfListInfoKeyGuard {
    let lockTime = this.getLockTime(lockTimeFromParam);
    let notificationList = this.getNtfAdapterList() ?? [];
    let ntfListInfo: NtfListInfoKeyGuard = { count: 0, ntfList: [] };
    if (SCBOobeManager.isOobeActivated()) {
      log.showInfo('do not show lock screen notifications during OOBE phase');
      return ntfListInfo;
    }
    notificationList.forEach((entry) => {
      if (CommonUtils.isInvalid(entry)) {
        return;
      }
      if (this.addToScreenList(entry, lockTime)) {
        ntfListInfo.ntfList.push(entry);
        ntfListInfo.count += entry.isGroup ? entry.childrenEntry!.length : 1;
      }
    });

    return ntfListInfo;
  }

  /**
   * 获取锁屏是否在加锁状态
   *
   * @returns 锁屏是否在加锁状态
   */
  isKeyguardLocked(): boolean {
    return this.isSecureAndLocked;
  }

  private getLockTime(lockTimeFromParam: number) {
    if (lockTimeFromParam < 0 && this.callback?.getLockScreenTime) {
      return this.callback.getLockScreenTime();
    } else {
      return lockTimeFromParam;
    }
  }

  private addToScreenList(entry: NotificationEntry, lockTime: number): boolean {
    if (entry.isHiddenInKeyGuard()) {
      return false;
    }
    if (entry.isOngoing || entry.isLiveType() || entry.deliveryTime > lockTime) {
      return true;
    }
    return false;
  }

  protected onDataReloaded(): void {
    // 锁屏场景空实现, 减少刷新
  }

  /**
   * 注册数据变化监听
   *
   * @param listener 监听器
   */
  registerGlobalStateListener(listener: NtfGlobalStateCallback): void {
    if (!listener) {
      log.showError('Register global state listener failed: listener is null.');
      return;
    }
    this.gloalStateListeners.add(listener);
  }

  /**
   * 注销数据变化监听
   *
   * @param listener 监听器
   */
  unregisterGlobalStateListener(listener: NtfGlobalStateCallback): void {
    if (!listener) {
      log.showError('Unregister global state listener failed: listener is null.');
      return;
    }
    this.gloalStateListeners.delete(listener);
  }

  protected handleNtfAddUpdateKeyGuard(isExtraScreenOn: boolean): void {
    if (!this.checkAccountConsistency()) {
      return;
    }
    super.handleNtfAddUpdateKeyGuard(isExtraScreenOn);
  }

  /**
   * 检查当前用户ID与前台用户ID一致性
   */
  private checkAccountConsistency(): boolean {
    if (!UserSwitchService.getInstance().isCurrentUserActive) {
      log.showWarn('currentUserId is not ForegroundUserId');
      return false;
    }
    return true;
  }
}

export interface NtfListInfoKeyGuard {
  count: number,
  ntfList: Array<NotificationEntry>
}

export interface NtfGlobalStateCallback {
  /**
   * 隐藏通知内容变化回调
   *
   * @param isHideContent 是否隐藏通知内容
   */
  onHideContentChange: (isHideContent: boolean) => void;
}
