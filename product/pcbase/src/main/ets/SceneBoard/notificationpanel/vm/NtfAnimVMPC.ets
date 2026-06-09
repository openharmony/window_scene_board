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
import { curves } from '@kit.ArkUI';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { NtfAnimVM } from '@ohos/notificationcomponent/src/main/ets/vm/NtfAnimVM';
import {
  NotificationAnimationParamsPC
} from '../model/NotificationAnimationParamsPC';

const TAG = 'NtfListVmPc';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 一键删除每个通知动效间隔时延
 */
const NTF_ITEM_DELAY: number = 32;

/**
 * 通知动效通用时长
 */
const NTF_ANIM_DURATION: number = 250;

/**
 * 通知列表动效vm
 */
@Observed
export class NtfAnimVMPC extends NtfAnimVM {
  /**
   * 每个通知卡片动效参数
   */
  public ntfAnimParamsPC: Record<string, NotificationAnimationParamsPC> = {};
  /**
   * 是否正在清除所有通知
   */
  public isClearingAll: boolean = false;
  /**
   * 记录List中每个Item的高度
   */
  private ntfHeightParams: Record<string, number> = {};
  /**
   * 清除所有通知动效总延迟
   */
  private clearAllDelay: number = 0;

  init(): void {
    super.init();
    this.ntfAnimParamsPC = {};
    this.isClearingAll = false;
    this.ntfHeightParams = {};
    this.clearAllDelay = 0;
    this.ntfListItemTransition = TransitionEffect.asymmetric(
      TransitionEffect.OPACITY
        .animation({ duration: 167, delay: 83, curve: curves.interpolatingSpring(0, 1, 228, 23) })
        .combine(TransitionEffect.opacity(0))
        .combine(TransitionEffect.scale({ x: 0.6, y: 0.6 })),
      TransitionEffect.OPACITY
        .animation({ duration: 250, delay: 0, curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1) })
        .combine(TransitionEffect.scale({ x: 0.7, y: 0.7 })
          .animation({ duration: 250, delay: 0, curve: curves.cubicBezierCurve(0.84, 0, 0.16, 1) })
        )
    );
  }

  /**
   * 设置清除全部通知动效时长
   */
  setClearAllDelay(firstIndex: number, lastIndex: number): void {
    this.clearAllDelay = (lastIndex - firstIndex + 1) * NTF_ITEM_DELAY;
  }

  /**
   * 获取清除全部通知动效时长
   *
   * @returns delay and duration time
   */
  getClearAllDelay(): number {
    return this.clearAllDelay;
  }

  /**
   * 设置是否正在清除所有通知
   */
  setClearingAll(isClearingAll: boolean): void {
    this.isClearingAll = isClearingAll;
  }

  /**
   * 检查是否正在清除所有通知
   */
  checkClearingAll(): boolean {
    return this.isClearingAll;
  }

  /**
   * 设置每个通知item高度
   */
  setNtfHeightParams(key: string, height: number): void {
    this.ntfHeightParams[key] = height;
  }

  /**
   * 一键删除动效参数更新
   */
  updateClearAllAnimationParams(firstIndex: number, lastIndex: number, ntfList: Array<NotificationEntry>): void {
    let translate: number = 0;
    let previousScale: number = 1;
    let previousItemHeight: number = 0;
    log.showDebug('updateClearAllAnimationParams firstIndex:' + firstIndex + ' lastIndex:' + lastIndex);
    for (let itemIndex = firstIndex; itemIndex <= lastIndex; itemIndex++) {
      let visibleIndex = itemIndex - firstIndex;
      let itemScale: number = (100 - 3 * (lastIndex - firstIndex + 1 - visibleIndex)) / 100;
      let itemHeight: number = this.ntfHeightParams[ntfList[itemIndex]?.getGroupTypeKey()];
      let itemTranslate: number = 0;
      if (visibleIndex !== 0) {
        itemTranslate = -((1 - itemScale) * itemHeight + (1 - previousScale) * previousItemHeight) / 2 + translate;
      }
      translate = itemTranslate;
      previousScale = itemScale;
      previousItemHeight = itemHeight;
      let key = ntfList[itemIndex]?.getGroupTypeKey();
      this.ntfAnimParamsPC[key] = new NotificationAnimationParamsPC(0, 1, 1, 0);
      this.ntfAnimParamsPC[key].clearAnimTransY = itemTranslate;
      this.ntfAnimParamsPC[key].clearAnimScale = itemScale;
      this.ntfAnimParamsPC[key].clearAnimDelay = 32 * itemIndex;
      this.ntfAnimParamsPC[key].clearAnimOpacity = 0;
      log.showDebug('ntfAnimParamsPC key:' + key + ' clearAnimScale:' + this.ntfAnimParamsPC[key].clearAnimDelay);
    }
  }

  /**
   * 获取通知卡片转场动效,包含一键删除和单个删除
   */
  getNtfListItemTransition(entry: NotificationEntry): TransitionEffect | undefined {
    let key: string = entry.getGroupTypeKey();
    log.showDebug('getNtfListItemTransition ntfAnimParamsPC key:' + key + ' isClearingAll:' + this.isClearingAll);
    if (!this.isClearingAll || CommonUtils.isInvalid(this.ntfAnimParamsPC[key])) {
      return this.getNtfItemTransition(entry);
    }
    let ntfAnimParamsPCItem: NotificationAnimationParamsPC = this.ntfAnimParamsPC[key];
    let itemTranslate: number = ntfAnimParamsPCItem.clearAnimTransY;
    let itemScale: number = ntfAnimParamsPCItem.clearAnimScale;
    let itemDelay: number = ntfAnimParamsPCItem.clearAnimDelay;
    let itemOpacity: number = ntfAnimParamsPCItem.clearAnimOpacity;
    let clearAllTransition: TransitionEffect = TransitionEffect.asymmetric(
      TransitionEffect.OPACITY
        .animation({ duration: 167, delay: 83, curve: curves.interpolatingSpring(0, 1, 228, 23) })
        .combine(TransitionEffect.opacity(0))
        .combine(TransitionEffect.scale({ x: 0.6, y: 0.6 })),
      TransitionEffect.translate({ y: itemTranslate })
        .animation({ duration: 250, delay: itemDelay, curve: Curve.Friction })
        .combine(TransitionEffect.scale({ x: itemScale, y: itemScale }))
        .combine(TransitionEffect.opacity(itemOpacity)
          .animation({ duration: 250, delay: itemDelay, curve: Curve.Sharp }))
    );
    return clearAllTransition;
  }

  /**
   * 获取通知列表变化动效时长
   */
  getNtfListDataChangeDuration(): number {
    return this.isClearingAll ? this.getClearAllDuration() : super.getNtfListDataChangeDuration();
  }

  /**
   * 获取一键删除动效时长
   */
  getClearAllDuration(): number {
    return this.getClearAllDelay() + NTF_ANIM_DURATION;
  }

  /**
   * 获取通知卡片转场动效，单个删除
   */
  getNtfItemTransition(entry: NotificationEntry): TransitionEffect | undefined {
    let isDeletingItem: boolean = this.isDeletingItem(entry);
    log.showDebug('getNtfItemTransition entry key:' + entry.getGroupTypeKey() + ' isDeletingItem:' + isDeletingItem);
    return isDeletingItem ? this.ntfListItemTransition : undefined;
  }

  /**
   * 获取通知list总高度
   *
   * @returns
   */
  getListHeight(oldHeight: number | undefined): number | string | undefined {
    return this.isClearingAll ? oldHeight : undefined;
  }

  /**
   * 清空动效数据
   */
  clear(): void {
    this.ntfAnimParamsPC = {};
    this.isClearingAll = false;
  }
}