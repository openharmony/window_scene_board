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

import Curves from '@ohos.curves';
import { ResUtils } from '@ohos/windowscene';
import { CmpPosWrapper, ImmersiveLiveAnimSceneEnum } from '@ohos/screenlockcommon/Index';
import { ImmersiveType, ImmersiveState, immersiveKgMgr, AccessibilityUtil } from '@ohos/systemuicommon';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { ImmersiveCardVm } from '../ImmersiveCardVm';
import { ImmersiveAnimManager } from '../viewanim/ImmersiveAnimManager';
import { ImmersiveCardAnimManager } from '../viewanim/ImmersiveCardAnimManager';
import {
  IImmersiveState,
  immersiveStateMgr,
  OnImmersiveStateChangeListener
} from '../../common/manager/ImmersiveStateManager';
import { IImmersiveCardHandle } from '../../common/interface/IImmersiveCardHandle';
import { IImmersiveNtfVmInjector } from '../../common/interface/IImmersiveNtfVmInjector';
import { IImmersiveCardAnimVm } from '../../common/interface/IImmersiveCardAnimVm';

// 单双击事件间隔有300ms，沉浸态切换延时450ms
const IMM_CHANGE_TIME = 450

/**
 * 沉浸卡片UI界面事件处理
 */
export class ImmersiveCardHandle implements IImmersiveCardHandle {
  /**
   * 卡片vm
   */
  private cardVm?: ImmersiveCardVm;
  /**
   * 动效管理
   */
  private animMgr?: ImmersiveAnimManager;
  /**
   * 卡片动效管理
   */
  private cardAnimMgr?: ImmersiveCardAnimManager;

  /**
   * 列表业务注入器
   */
  private vmInjector?: IImmersiveNtfVmInjector;

  /**
   * 沉浸锁屏显示状态
   */
  private immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();

  /**
   * 事件拦截时沉浸状态
   */
  private interruptImmType: ImmersiveType = ImmersiveType.TYPE_CAPSULE;

  /**
   * 检测沉浸态切换时延时任务
   */
  private checkImmId?: number;

  /**
   * 沉浸状态切换回调
   */
  private onImmStateChange: OnImmersiveStateChangeListener = (state?: IImmersiveState): void => {
    this.checkChangeImmType();
  };

  /**
   * 绑定卡片VM
   *
   * @param cardVm 卡片VM
   * @returns 链式
   */
  bindCardVm(cardVm: ImmersiveCardVm): ImmersiveCardHandle {
    this.cardVm = cardVm;
    return this;
  }

  /**
   * 绑定动效管理
   *
   * @param animMgr 动效管理
   * @returns 链式
   */
  bindAnimMgr(animMgr: ImmersiveAnimManager): ImmersiveCardHandle {
    this.animMgr = animMgr;
    this.cardAnimMgr = animMgr.getCardAnimMgr();
    return this;
  }

  /**
   * 设置业务注入器
   *
   * @param vmInjector 注入器
   */
  setVmInjector(vmInjector: IImmersiveNtfVmInjector): void {
    // 初始化一次即可
    if (!this.vmInjector) {
      this.vmInjector = vmInjector;
    }
  }

  /**
   * 初始化
   */
  public init(): void {
    this.interruptImmType = this.immersiveState.immersiveType;
    immersiveStateMgr.registerOnImmersiveStateChangeListener(this.onImmStateChange);
  }

  /**
   * 销毁回收
   */
  public destroy(): void {
    immersiveStateMgr.unregisterOnImmersiveStateChangeListener(this.onImmStateChange);
  }

  /**
   * 触发卡片到胶囊动效 下滑卡片 侧滑退出 点击区域外
   */
  public execCardToCapsuleAnim(): void {
    this.cardAnimMgr?.fillImmersiveCardAnimData();
    immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_CAPSULE);
    this.animMgr?.startCardToCapsuleAnim();
  }

  public execCardToCapsuleAnimForOuterScreen(): void {
    if (SystemUICcmConfig.instance.isEnabledLive2) {
      // 实况2.0小外屏卡片到胶囊动效由SysUI侧实现，退出沉浸态打断列表到卡片动效
      immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_CAPSULE);
      this.animMgr?.getImmeLiveAnimMgr().interruptedExecutor(
        ImmersiveLiveAnimSceneEnum.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM);
      return;
    }
    this.cardAnimMgr?.fillImmersiveCardAnimData();
    let immeCode = this.cardVm?.getShowList().showData?.hashCode;
    immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_CAPSULE);
    // 采用动效数据填充，直接清除数据
    this.cardVm?.getShowList().setShowData();
    this.animMgr?.startImmeCardToLiveCapsuleFixAnim(immeCode);
  }

  public execCardToListAnim(): void {
    this.animMgr?.startCardToListFixAnim();
  }

  /**
   * 执行卡片上下位移动效
   *
   * @param isFold true表示小卡收拢，执行下移动效，否则执行上移动效
   */
  public execCardUpDownAnim(isFold: boolean): void {
    animateTo({ curve: Curves.springCurve(0, 1, 228, 23) }, () => {
      this.cardVm?.changeCardState(isFold);
      AccessibilityUtil.sendAccessibility(isFold ?
      ResUtils.getInnerString($r('app.string.immersive_card_tip_status_down')) :
      ResUtils.getInnerString($r('app.string.immersive_card_tip_status_up')));
    });
  }

  /**
   * 热区匹配检测
   *
   * @param globalX X坐标
   * @param globalY Y坐标
   * @returns true热区匹配
   */
  public checkMatchHotZones(globalX: number, globalY: number): boolean {
    // 沉浸态时，所有区域均为沉浸态热区
    return Boolean(this.immersiveState?.isImmersive(this.interruptImmType));
  }

  /**
   * 精确位置匹配检测
   *
   * @param globalX X坐标
   * @param globalY Y坐标
   * @returns true位置匹配
   */
  public checkMatchExactArea(globalX: number, globalY: number): boolean {
    if (!this.immersiveState?.isImmersive()) {
      return false;
    }
    let rootPos = this.vmInjector ? this.getCardAnimVm()?.getRootPos() : this.animMgr?.getCardViewArea();
    let itemPos = CmpPosWrapper.wrapper(rootPos);
    let touchHotZonesMaxX = itemPos.getCmpGlobalX() + itemPos.getCmpWidth();
    let touchHotZonesMaxY = itemPos.getCmpGlobalY() + itemPos.getCmpHeight();
    return globalX >= itemPos.getCmpGlobalX() && globalX <= touchHotZonesMaxX &&
      globalY >= itemPos.getCmpGlobalY() && globalY <= touchHotZonesMaxY;
  }

  private checkChangeImmType(): void {
    // 沉浸状态切换，事件拦截状态延时处理
    let curImmType = this.immersiveState.immersiveType;
    if (this.interruptImmType !== curImmType) {
      this.clearCheckImmRunnable();
      // 如果由沉浸态切换为非沉浸态，则延时赋值
      if (this.interruptImmType === ImmersiveType.TYPE_IMMERSIVE) {
        this.checkImmId = setTimeout(() => {
          this.clearCheckImmRunnable();
          this.interruptImmType = curImmType;
        }, IMM_CHANGE_TIME);
      } else {
        this.interruptImmType = curImmType;
      }
    }
  }

  private clearCheckImmRunnable(): void {
    // 清除延时任务
    if (this.checkImmId) {
      clearTimeout(this.checkImmId);
      this.checkImmId = undefined;
    }
  }

  private getCardAnimVm(): IImmersiveCardAnimVm | undefined {
    return this.vmInjector?.getImmersiveCardAnimVm();
  }
}