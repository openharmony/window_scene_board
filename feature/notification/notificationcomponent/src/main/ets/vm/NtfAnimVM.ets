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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import {
  NtfClearAllAnimation,
  NTF_CLEAR_ALL_OPACITY,
  NTF_CLEAR_ALL_ROTATE_ANGEL,
  NTF_CLEAR_ALL_SCALE
} from '../animation/NtfClearAllAnimation';
import { NtfAnimationConsts } from '../common/NtfAnimationConsts';
import { NotificationEntry } from '../model/NotificationEntry';

const TAG = 'NtfAnimVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知列表变化动效时长
 */
const DATA_CHANGE_DURATION: number = 350;

/**
 * 通知列表动效vm
 */
@Observed
export class NtfAnimVM {
  /**
   * 正在删除的通知项
   */
  public deletingItem?: NotificationEntry;

  // 通知卡片转场动效
  public ntfListItemTransition: TransitionEffect =
    TransitionEffect.asymmetric(this.getNtfAppearTransition(), this.getNtfDisappearTransition());
  /**
   * 更多通知转场动效
   */
  public extraNtfListItemTransition: TransitionEffect =
    TransitionEffect.asymmetric(this.getNtfAppearTransition(), TransitionEffect.OPACITY.animation({ duration: 0 }));

  init(): void {
    this.deletingItem = undefined;
  }

  /**
   * 设置清除全部通知动效时长
   */
  setClearAllDelay(firstIndex: number, lastIndex: number): void {}

  /**
   * 设置是否正在清除所有通知
   */
  setClearingAll(isClearingAll: boolean): void {}

  /**
   * 检查是否正在清除所有通知
   */
  checkClearingAll(): boolean {
    return false;
  }

  /**
   * 获取清除全部通知动效时长
   *
   * @returns delay and duration time
   */
  getClearAllDelay(): number {
    return 0;
  }

  /**
   * 设置每个通知item高度
   */
  setNtfHeightParams(key: string, height: number): void {}

  /**
   * 一键删除动效参数更新
   */
  updateClearAllAnimationParams(firstIndex: number, lastIndex: number, ntfList: Array<NotificationEntry>): void {}

  /**
   * 获取通知卡片转场动效
   */
  getNtfListItemTransition(entry: NotificationEntry): TransitionEffect | undefined {
    return undefined;
  }

  /**
   * 获取通知列表变化动效时长
   */
  getNtfListDataChangeDuration(): number {
    return DATA_CHANGE_DURATION;
  }

  /**
   * 获取一键删除动效时长
   */
  getClearAllDuration(): number {
    return 0;
  }

  /**
   * 设置正在删除的通知
   */
  setDeletingItem(ntfEntry: NotificationEntry | undefined) {
    this.deletingItem = ntfEntry;
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

  /**
   * 获取通知卡片转场动效，单个删除
   */
  getNtfItemTransition(entry: NotificationEntry): TransitionEffect | undefined {
    return undefined;
  }

  /**
   * 获取通知list总高度
   *
   * @returns
   */
  getListHeight(oldHeight: number | undefined): number | string | undefined {
    return '100%';
  }

  /**
   * 清空动效数据
   */
  clear(): void {}

  public getNtfAppearTransition(): TransitionEffect {
    return TransitionEffect.OPACITY
      .animation({ duration: 167, delay: 83, curve: NtfAnimationConsts.LIST_ITEM_TRANSITION_CURVE })
      .combine(TransitionEffect.opacity(0))
      .combine(TransitionEffect.scale({ x: 0.6, y: 0.6 }));
  }

  private getNtfDisappearTransition(): TransitionEffect {
    return TransitionEffect.OPACITY
      .combine(TransitionEffect.scale({ x: 0.6, y: 0.6, centerX: '50%', centerY: 0 }))
      .animation({ duration: 100, curve: NtfAnimationConsts.LIST_ITEM_TRANSITION_CURVE });
  }

  /**
   * 获取一键删除场景卡片的transition退场动效
   * @param ntfClearAllAnimation 一键删除动效参数
   * @param index 当前卡片索引
   * @param firstIndex 第一个卡片索引
   * @param lastIndex 随后一个卡片索引
   * @returns
   */
  public getNtfClearAllTransition(entry: NotificationEntry, ntfClearAllAnimation: NtfClearAllAnimation,
    index: number, firstIndex: number, lastIndex: number): TransitionEffect {

    const isOuterHome = !DeviceHelper.isFoldExpandedOrHalf();
    const delayTime = ntfClearAllAnimation?.getDelayTime(isOuterHome, index, lastIndex);

    const groupKey = entry?.getGroupTypeKey();

    return TransitionEffect.translate({y: ntfClearAllAnimation.getTranslateY(groupKey)})
      .animation({
        // 位移
        delay: delayTime,
        curve: ntfClearAllAnimation.getTranslateCurve(isOuterHome, index, firstIndex)
      }).combine(
        // 缩放
        TransitionEffect.scale({
          x: NTF_CLEAR_ALL_SCALE,
          y: NTF_CLEAR_ALL_SCALE,
          centerX: '50%',
          centerY: 0
        }).animation({
          duration: ntfClearAllAnimation.getScaleDuration(isOuterHome, index, firstIndex) * 0.7,
          delay: delayTime + ntfClearAllAnimation.getScaleDelay(isOuterHome, index, firstIndex),
          curve: Curve.Linear,
        }).combine(
          // 旋转
          TransitionEffect.rotate({
            x: 1,
            angle: NTF_CLEAR_ALL_ROTATE_ANGEL
          }).animation({
            duration: ntfClearAllAnimation.getScaleDuration(isOuterHome, index, firstIndex) * 0.7,
            delay: delayTime + ntfClearAllAnimation.getScaleDelay(isOuterHome, index, firstIndex),
            curve: Curve.Linear,
          }).combine(
            // 透明度
            TransitionEffect.opacity(NTF_CLEAR_ALL_OPACITY).animation({
              duration: ntfClearAllAnimation.getOpacityDuration(isOuterHome, index, firstIndex) * 0.9,
              delay: delayTime,
              curve: ntfClearAllAnimation.clearItemOpacityCurve,
            })
          )
        )
      )
  }
}