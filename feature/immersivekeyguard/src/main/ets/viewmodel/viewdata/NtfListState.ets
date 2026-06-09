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

import { NotificationConfig } from '@ohos/notificationcomponent/src/main/ets/common/NotificationConfig';
import curves from '@ohos.curves';
import { NotificationAnimationParas,
  OnItemPreSizeChange } from '@ohos/notificationcomponent/src/main/ets/common/NotificationAnimationParas';
import { ImmersiveConstants } from '../../common/ImmersiveConstants';
import {
  PromiseInterrupt
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { CommonUtils } from '@ohos/basicutils';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper';
import { interruptHelper } from '../../common/helper/ImmersiveInterruptHelper';

interface NtfConfigKeyGuard {
  maxRotateAngle: number; // 卡片旋转的最大角度
  foldFactor: number; // 堆叠时的缩放比例
}

const TIMEOUT_UPDATE_ANIM = 300;

const TIMEOUT_MESH_INTERRUPT = 50;

/**
 * 沉浸锁屏通知列表静态状态管理
 */
export class NtfListStaticState {
  /**
   * 列表滑动控制器
   */
  private listScroller: Scroller = new Scroller();

  /**
   * 是否开启手势事件，默认开启
   */
  public isGestureEnabled: boolean = true;

  /**
   * 组通知是否允许展开，默认允许
   */
  public groupCanExpand: boolean = true;

  /**
   * 是否使用模糊合并，默认开启
   */
  public isUseEffect: boolean = true;

  /**
   * 通知条目圆角
   */
  public itemRadius: number = NotificationConfig.BORDER_RADIUS;

  /**
   * 当前是否正在触摸item
   */
  public isTouchingItem: boolean = false;

  /**
   * 是否拦截锁屏事件
   */
  public isStopPropagation: boolean = true;

  /**
   * 当前可见条目起始索引
   */
  public startItemIndex: number = -1;

  /**
   * 当前可见条目结尾索引
   */
  public endItemIndex: number = -1;

  /**
   * 条目标识层级索引映射关系
   */
  public groupKeyIndexMap: Map<string, number> = new Map();

  /**
   * 通知卡片跟手动效参数限制
   */
  public config: NtfConfigKeyGuard = { maxRotateAngle: 50, foldFactor: 0.9 };

  /**
   * 通知列表的高度
   */
  public notificationListHeight: number = 0;

  /**
   * 事件处理器
   */
  public eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 通知列表Y轴最大位置
   */
  public listMaxPositionY: number = 0;

  /**
   * 通知列表的最大高度
   */
  public notificationListHeightMax: number = 0;

  /**
   * 条目总高度
   */
  public itemHeightSum: number = 0;

  /**
   * 条目翻转刷新动效
   */
  public itemUpdateAnim?: AnimateParam;

  /**
   * 高度变化条目的动效参数
   */
  public itemChangeParas?: NotificationAnimationParas;

  /**
   * 列表高度是否变化
   */
  public isListHeightChange?: boolean;

  /**
   * 超时清除条目刷新动效的任务ID
   */
  private clearUpdateAnimId?: number;

  /**
   * 列表是否正在滑动
   */
  private isScrolling: boolean = false;

  /**
   * 栅格测量时启动拦截器
   */
  private meshInterrupt?: PromiseInterrupt;

  /**
   * 超时清除栅格测量拦截器的任务ID
   */
  private clearMeshInterruptId?: number;

  /**
   * 当前是否长按动效中
   */
  private isLongClickAnim?: boolean;

  /**
   * 条目出现动效
   */
  public itemTransition: TransitionEffect = TransitionEffect.asymmetric(
    TransitionEffect.OPACITY
    .animation({ duration: 167, delay: 83, curve: curves.interpolatingSpring(0, 1, 228, 23) })
    .combine(TransitionEffect.opacity(0))
    .combine(TransitionEffect.scale({ x: 0.6, y: 0.6 })),
    TransitionEffect.IDENTITY
  );

  /**
   * 条目间距
   */
  public itemSpace: number = 8;

  /**
   * 获取列表滑动控制器
   *
   * @returns 滑动控制器
   */
  public getListScroller(): Scroller {
    return this.listScroller;
  }

  public getListItemRect(index: number): RectResult { // item相对于列表的位置
    try {
      return this.getListScroller().getItemRect(index);
    } catch (e) {
      return { x: 0, y: 0, width: 0, height: 0 };
    }
  }

  public getInitScrollOffset(): number { // 初始滑动偏移
    return -this.itemSpace;
  }

  public getCurScrollOffset(): number { // 当前滑动偏移
    return this.listScroller.currentOffset()?.yOffset ?? this.getInitScrollOffset();
  }

  public getMeshInterrupt(): PromiseInterrupt | undefined { // 栅格测量时开启拦截器
    return this.meshInterrupt;
  }

  public updateMeshInterrupt(interrupt?: PromiseInterrupt): void { // 栅格测量时需开启的拦截器
    if (this.meshInterrupt === interrupt) {
      return;
    }
    this.meshInterrupt = interrupt;
    if (interrupt) { // 有拦截器则开启超时清除
      this.clearMeshInterruptTimeout();
      this.clearMeshInterruptId = setTimeout(() => this.updateMeshInterrupt(), TIMEOUT_MESH_INTERRUPT);
    } else {
      this.clearMeshInterruptTimeout();
    }
  }

  public updateItemAnim(anim?: AnimateParam, isForceAnim?: boolean): void { // 条目翻转效果刷新动效
    if (this.isScrolling && !isForceAnim) { // 列表滑动期间无需动效
      anim = undefined;
    }
    if (this.itemUpdateAnim === anim) {
      return;
    }
    this.itemUpdateAnim = anim;
    if (anim) { // 有动效则开启超时清除
      this.clearUpdateAnimTimeout();
      this.clearUpdateAnimId = setTimeout(() => this.updateItemAnim(), TIMEOUT_UPDATE_ANIM);
    } else {
      this.clearUpdateAnimTimeout();
    }
  }

  public updateChangeItemParas(paras?: NotificationAnimationParas): void { // 高度变化条目的动效参数
    this.itemChangeParas = paras;
  }

  public setListHeightChange(isChange?: boolean): void { // 列表高度变化状态
    this.isListHeightChange = isChange;
  }

  public updateScrolling(isScrolling: boolean): void { // 列表滑动状态
    this.isScrolling = isScrolling;
    if (isScrolling) { // 滑动期间清除动效
      this.updateItemAnim();
      this.itemChangeParas?.resolveClipAnimWait();
      interruptHelper.ntfItemAnimIt.releaseInterrupt();
    }
  }

  public isLongClickAnimating(): boolean { // 当前是否长按动效中
    return this.isLongClickAnim ?? false;
  }

  public updateLongClickAnim(isLongClick?: boolean): void { // 长按动效状态
    this.isLongClickAnim = isLongClick;
  }

  private clearUpdateAnimTimeout(): void { // 清除超时任务
    if (this.clearUpdateAnimId) {
      clearTimeout(this.clearUpdateAnimId);
      this.clearUpdateAnimId = undefined;
    }
  }

  private clearMeshInterruptTimeout(): void { // 清除超时任务
    if (this.clearMeshInterruptId) {
      clearTimeout(this.clearMeshInterruptId);
      this.clearMeshInterruptId = undefined;
    }
  }
}

/**
 * 沉浸锁屏通知列表UI绑定状态管理
 */
@Observed
export class NtfListBindState {
  /**
   * 通知条目反转效果参数
   */
  public ntfAnimParas: Record<string, NotificationAnimationParas | undefined> = {};

  /**
   * 列表高度百分比高度
   */
  public listHeight: string | undefined = undefined;

  /**
   * 列表高度具体高度
   */
  public listRealHeight: Length | undefined = undefined;

  /**
   * 获取目标动效参数
   *
   * @param key 标识
   * @param li 条目size切换监听
   * @returns 动效参数
   */
  public getNtfAnimPara(key: string, li?: OnItemPreSizeChange): NotificationAnimationParas {
    let groupKey = ImmersiveConstants.getImmersiveID(key);
    if (CommonUtils.isInvalid(this.ntfAnimParas[groupKey])) {
      this.ntfAnimParas[groupKey] = new NotificationAnimationParas(0, 0, 1, 1, 0);
    }
    if (li) {
      this.ntfAnimParas[groupKey]?.setItemPreSizeChange(li);
    }
    return this.ntfAnimParas[groupKey]!;
  }

  public delNtfAnimPara(key: string): void {
    // 内存复位
    let groupKey = ImmersiveConstants.getImmersiveID(key);
    this.ntfAnimParas[groupKey] = undefined;
  }
}