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

import { NotificationEntry } from '../model/NotificationEntry';
import { ntfMgr } from '../model/NotificationManager';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';

const TAG = 'NtfCloseVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知close按钮数据处理
 */
export class NtfCloseVM {
  private containerPosition?: Position;
  private area?: Area;
  public ntfEntry?: NotificationEntry;

  public buttonPositionX: number = 0;
  public buttonPositionY: number = 0;
  private isMsgCloseIconInsideNtfPanel: boolean = true;

  /**
   * 正在删除的通知项
   */
  public deletingItem?: NotificationEntry;

  /**
   * 组件变化回调
   */
  private ntfCloseCallback: Set<NtfCloseCallback> = new Set();

  /**
   * 是否有通知项平移了，平移时不显示关闭按钮
   */
  private hasItemTranslate: boolean = false;

  private cancelTimerId?: number;

  setContainerPosition(position: Position): void {
    this.containerPosition = position;
    log.info('Set container position:', position);
    this.calculatePosition();
  }

  setItemHover(ntfEntry: NotificationEntry): void {
    log.showInfo(`setItemHover ${ntfEntry?.toSimpleString()}`);
    this.ntfEntry = ntfEntry;
    this.clearCancelTimer();
  }

  registerNtfCloseListener(callback: NtfCloseCallback): void {
    this.ntfCloseCallback.add(callback);
  }

  unregisterNtfCloseListener(callback: NtfCloseCallback): void {
    this.ntfCloseCallback.delete(callback);
  }

  /**
   * 设置右键菜单点击删除的通知项
   */
  setRightMenuItemClick(ntfEntry: NotificationEntry): void {
    this.deletingItem = ntfEntry;
    this.ntfCloseCallback.forEach((callback) => callback?.onDeletingItemChange(ntfEntry));
  }

  /**
   * 是否右键菜单删除或close按钮删除的通知项
   */
  isDeletingItem(ntfEntry: NotificationEntry): boolean {
    if (!ntfEntry) {
      return false;
    }
    return this.deletingItem?.getGroupTypeKey() === ntfEntry?.getGroupTypeKey();
  }

  clearRightMenuDeletingItem(): void {
    this.deletingItem = undefined;
    this.ntfCloseCallback.forEach((callback) => callback?.onDeletingItemChange(undefined));
  }

  cancelItemHover(ntfEntry?: NotificationEntry): void {
    if (!CommonUtils.equals(ntfEntry, this.ntfEntry) && ntfEntry) {
      log.info('cancelItemHover failed');
      return;
    }
    log.info(`cancelItemHover ${ntfEntry?.toSimpleString()}`);
    this.deletingItem = undefined;
    this.ntfCloseCallback.forEach((callback) => callback?.onDeletingItemChange(undefined));
    this.clearCancelTimer();
    this.cancelTimerId = setTimeout(() => {
      log.showInfo('cancelItemHover set undefined');
      this.ntfEntry = undefined;
    }, 20);
  }

  clearCancelTimer(): void {
    log.showInfo('clearCancelTimer');
    if (this.cancelTimerId !== undefined) {
      clearTimeout(this.cancelTimerId);
      this.cancelTimerId = undefined;
    }
  }

  isShow(): boolean {
    return this.isMsgCloseIconInsideNtfPanel &&
      Boolean(this.ntfEntry?.canDelete() && this.containerPosition) && !this.hasItemTranslate;
  }

  updatePosition(ntfEntry: NotificationEntry, area: Area): void {
    log.showInfo(`updatePosition ${ntfEntry?.toSimpleString()}`);
    if (ntfEntry !== this.ntfEntry || !area || !this.containerPosition) {
      log.warn(`updatePosition failed, ${this.ntfEntry?.toSimpleString()} ${area ===
        undefined} ${this.containerPosition === undefined}`);
      return;
    }
    log.info(`updatePosition area:${JSON.stringify(area)}`);
    this.area = area;
    this.calculatePosition();
  }

  private calculatePosition(): void {
    if (!this.area || !this.containerPosition) {
      log.warn(`calculatePosition failed, ${this.area === undefined} ${this.containerPosition === undefined}`);
      return;
    }
    // 关闭按钮在通知卡片内容区右上角，向左偏移14vp，向上偏移6vp
    this.buttonPositionX = RTLUtil.isRTL() ? -14 :
      (this.area.globalPosition.x as number) -
        (this.containerPosition.x as number) +
        (this.area.width as number) -
        14;
    this.buttonPositionY = (this.area.globalPosition.y as number) - (this.containerPosition.y as number) - 6;
    if (this.buttonPositionY >= -7) {
      this.isMsgCloseIconInsideNtfPanel = true;
    } else {
      this.isMsgCloseIconInsideNtfPanel = false;
    }
    log.info(`calculatePosition result, ${this.buttonPositionX} ${this.buttonPositionY}`);
  }

  setItemTranslate(translateX: number): void {
    this.hasItemTranslate = translateX !== 0;
  }

  deleteNotification(): void {
    if (!this.ntfEntry || this.deletingItem) {
      return;
    }
    log.info('Delete notification: ', this.ntfEntry.toSimpleString());
    this.deletingItem = this.ntfEntry;
    this.ntfCloseCallback.forEach((callback) => callback?.onDeletingItemChange(this.ntfEntry));
    ntfMgr.removeNtfEntryByCancel(this.ntfEntry);
    HiDfxEventUtil.reportDeleteNtfByClose(this.ntfEntry.creatorBundleName, this.ntfEntry.id);
  }

  private getMyTransitionEffect(isHeadsUpEntry: boolean): TransitionEffect | undefined {
    if (isHeadsUpEntry) {
      return undefined;
    }
    return TransitionEffect
      .translate({x: -3, y: 1})
      .animation({duration: 300, curve: Curve.Sharp})
  }
}

/**
 * 组件删除交互接口
 */
export interface NtfCloseCallback {
  /**
   * 正在删除的通知item回调
   *
   * @param deletingItem 正在删除的通知
   */
  onDeletingItemChange(deletingItem: NotificationEntry | undefined): void;
}