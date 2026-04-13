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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { baseStateMgr, ImmersiveType, ImmersiveState, ImmersiveTypeScene } from '@ohos/systemuicommon';
import {
  DisplaySizeState,
  StateType,
  immersiveKgMgr
} from '@ohos/systemuicommon';
import { vibratorMgr } from '@ohos/launchercommon';
import { CommonConstants } from '@ohos/launchercommon';
import { ImmersiveAnimScene } from '../../common/anim/ImmersiveAnimConstants';
import { CapsulePositionType } from '../../common/ImmersiveConstants';
import { ImmersiveSysEventUtil, StatusParams, ToggleWay } from '../../common/ImmersiveSysEventUtil';
import { AnimStyleType } from '../../model/data/anim/ImmersiveAnimStyle';
import { ImmersiveCapsuleVm } from '../ImmersiveCapsuleVm';
import { ImmersiveAnimManager } from '../viewanim/ImmersiveAnimManager';
import { SlClockAnimManager } from '../viewanim/SlClockAnimManager';
import { KeyguardStatusService, WDefault } from '@ohos/screenlockcommon';
import {
  CmpPosWrapper,
  DynamicCurveRate,
  WidgetAnimState,
  WidgetAnimStateV2,
  WidgetStyleStateV2
} from '@ohos/screenlockcommon/Index';
import { defaultStopHandle, IImmersiveEventStopListener, ImmersiveEventStopHandle } from './ImmersiveEventStopHandle';
import { KeyguardSlGreetModel } from '@ohos/screenlockcommon/src/main/ets/bean/KeyGuardStatusEnum';
import { ImmersiveCapsuleAnimManager } from '../viewanim/ImmersiveCapsuleAnimManager';
import { immersiveVm } from '../ImmersiveVm';
import { IImmersiveCapsuleHandle } from '../../common/interface/IImmersiveCapsuleHandle';
import { IImmersiveNtfVmInjector } from '../../common/interface/IImmersiveNtfVmInjector';
import { CapShowType } from '../../common/constants/ImmCapConst';
import { ImmCapDataArray } from '../../model/data/v2/ImmCapDataArray';
import { IImmersiveCapVm } from '../../common/interface/IImmersiveCapVm';
import { IImmersiveCapAnimVm } from '../../common/interface/IImmersiveCapAnimVm';
import { ISlClockAnimVm } from '../../common/interface/ISlClockAnimVm';
import { IImmersiveWholeAnimVm } from '../../common/interface/IImmersiveWholeAnimVm';
import { ImmComAnimScene } from '../../common/constants/ImmComConst';

const TAG = 'ImmersiveCapsuleHandle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 胶囊事件相关常量
 */
export enum CapTouchConst {
  /**
   * 上滑开启阈值
   */
  GESTURE_UP_SLOP = 5,

  /**
   * 上滑最大距离
   */
  GESTURE_UP_MAX_Y = 30,

  /**
   * 缩放进度最大位移值
   */
  MAX_Y_FOR_SCALE = 100,

  /**
   * 上滑速度阈值
   */
  GESTURE_UP_VEL_Y = 1000,

  /**
   * 上滑离手点向下速度阈值
   */
  GESTURE_DOW_VEL_Y = 200,

  /**
   * 阴影胶囊，位移比例
   */
  SHADOW_Y_FACTOR = 0.8,

  /**
   * 速度计算，位移最小值
   */
  VEL_OFFSET_MIN = 100,

  /**
   * 速度最大值限制
   */
  VEL_MAX = 15,

  /**
   * 跟手比率常数
   */
  COEFFICIENT_K = 12.0
}

/**
 * 沉浸胶囊事件处理
 */
export class ImmersiveCapsuleHandle implements IImmersiveCapsuleHandle {
  /**
   * 胶囊vm
   */
  private capVm?: ImmersiveCapsuleVm;

  /**
   * 动效管理
   */
  private animMgr?: ImmersiveAnimManager;

  /**
   * 胶囊动效管理
   */
  private capsuleAnimMgr?: ImmersiveCapsuleAnimManager;

  /**
   * 时钟组件动效管理器
   */
  private clockAnimMgr?: SlClockAnimManager;

  /**
   * 列表业务注入器
   */
  private vmInjector?: IImmersiveNtfVmInjector;

  /**
   * 动态跟手比率计算器
   */
  private dynamicRate: DynamicCurveRate = new DynamicCurveRate(CapTouchConst.GESTURE_UP_MAX_Y)
    .setK(CapTouchConst.COEFFICIENT_K);

  /**
   * 初始y值
   */
  private initY: number = -CapTouchConst.GESTURE_UP_SLOP;

  /**
   * 上一次y值
   */
  private preY: number = -CapTouchConst.GESTURE_UP_SLOP;

  /**
   * 一次手势事件总位移
   */
  private gTranY: number = 0;

  /**
   * 上滑是否已震动
   */
  private isUpVibrator: boolean = false;

  private isStopEvent: boolean = false;

  // AOD场景事件拦截器
  private eventStopHandle?: ImmersiveEventStopHandle = defaultStopHandle;

  private immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();

  /**
   * 事件拦截切换监听器
   */
  private eventStopListener: IImmersiveEventStopListener = {
    onEventStop: (isStop: boolean): void => {
      this.isStopEvent = isStop;
      if (isStop) {
        this.endScrollUpBack(0, false);
      }
    }
  };

  /**
   * 绑定胶囊VM
   *
   * @param capsuleVm 胶囊VM
   * @returns 链式
   */
  bindCapsuleVm(capsuleVm: ImmersiveCapsuleVm): ImmersiveCapsuleHandle {
    this.capVm = capsuleVm;
    return this;
  }

  /**
   * 绑定动效管理
   *
   * @param animMgr 动效管理
   * @returns 链式
   */
  bindAnimMgr(animMgr: ImmersiveAnimManager): ImmersiveCapsuleHandle {
    this.animMgr = animMgr;
    this.capsuleAnimMgr = animMgr.getCapsuleAnimMgr();
    this.clockAnimMgr = animMgr.getSlClockAnimMgr();
    return this;
  }

  /**
   * 绑定事件拦截
   *
   * @param eventStopHandle 事件拦截
   * @returns 链式
   */
  bindStopHandle(eventStopHandle: ImmersiveEventStopHandle): ImmersiveCapsuleHandle {
    this.eventStopHandle = eventStopHandle;
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
  init(): void {
    this.eventStopHandle?.init();
    this.eventStopHandle?.registerEventStopListener(this.eventStopListener);
  }

  /**
   * 释放资源
   */
  destroy(): void {
    this.eventStopHandle?.destroy()
    this.eventStopHandle?.unregisterEventStopListener(this.eventStopListener);
    // 强制恢复
    this.endScrollUpBack(0, false);
  }

  /**
   * 根布局touch事件
   *
   * @param event 事件
   */
  onRootTouch(event: TouchEvent): void {
    // 胶囊无数据时，不拦截事件
    if (this.getCapData()?.isEmpty()) {
      return;
    }
    event?.stopPropagation();
  }

  /**
   * 手势开启
   *
   * @param event 事件
   */
  onGestureStart(event: GestureEvent): void {
    log.showInfo(`onGestureStart: ${this.isStopEvent} ${event.offsetY}`);
    if (this.isStopEvent) {
      return;
    }
    // 复位
    this.resetTran();
    this.setScrollUpState(true);
    this.updateScrollUp(event.offsetY);
  }

  /**
   * 手势更新
   *
   * @param event 事件
   */
  onGestureUpdate(event: GestureEvent): void {
    this.updateScrollUp(event.offsetY);
    if (this.isUpVibrator) {
      return;
    }
    if (this.isMaxUp(event.offsetY ?? 0)) {
      this.isUpVibrator = true;
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_LONG_PRESS,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    }
  }

  /**
   * 手势结束
   *
   * @param event 事件
   * @param isCancel 是否取消场景
   */
  onGestureEnd(event?: GestureEvent, isCancel: boolean = false): void {
    log.showInfo(`onGestureEnd: ${this.isStopEvent} ${isCancel} ${event?.velocityY} ${event?.offsetY}`);
    // 灭屏时已强制恢复
    if (this.isStopEvent) {
      this.isStopEvent = false;
      return;
    }

    // 手势打断，直接回退
    if (isCancel || !event) {
      this.endScrollUpBack();
      return;
    }
    let tranY = event.offsetY;
    let velY = event.velocityY;
    this.updateScrollUp(tranY);
    // 离手速度向下，直接回退
    if (velY > CapTouchConst.GESTURE_DOW_VEL_Y) {
      this.endScrollUpBack(this.getValidVelocity(velY, CapTouchConst.GESTURE_UP_MAX_Y));
      return;
    }
    // 离手速度向上，切换状态；向上位移超出阈值，切换状态
    if ((velY < 0 && Math.abs(velY) >= CapTouchConst.GESTURE_UP_VEL_Y) || (this.isMaxUp(tranY))) {
      KeyguardStatusService.setSlGreetMode(KeyguardSlGreetModel.SL_GREET_OFF);
      this.endScrollUpSuccess(this.getValidVelocity(velY, -CapTouchConst.VEL_OFFSET_MIN));
      return;
    }
    // 阈值不足，回退
    this.endScrollUpBack(this.getValidVelocity(velY, CapTouchConst.GESTURE_UP_MAX_Y));
  }

  /**
   * 热区匹配检测
   *
   * @param globalX X坐标
   * @param globalY Y坐标
   * @returns true热区匹配
   */
  checkMatchHotZones(globalX: number, globalY: number): boolean {
    // 非列表态，无热区
    if (!this.immersiveState?.isShowList()) {
      return false;
    }
    // 无数据，无热区
    let capData = this.getCapData();
    if (capData && capData.isEmpty()) {
      return false;
    }
    let rootPos = this.vmInjector ? this.getImmCapAnimVm()?.getRootPos() : this.animMgr?.getCapsuleViewArea();
    let itemPos = CmpPosWrapper.wrapper(rootPos);
    let touchHotZonesMaxX = itemPos.getCmpGlobalX() + itemPos.getCmpWidth();
    let touchHotZonesMaxY = itemPos.getCmpGlobalY() + itemPos.getCmpHeight();
    return globalX >= itemPos.getCmpGlobalX() && globalX <= touchHotZonesMaxX &&
      globalY >= itemPos.getCmpGlobalY() && globalY <= touchHotZonesMaxY;
  }

  private isMaxUp(offsetY: number): boolean {
    return offsetY < 0 && Math.abs(offsetY + CapTouchConst.GESTURE_UP_SLOP) >= CapTouchConst.GESTURE_UP_MAX_Y;
  }

  /**
   * 上滑跟手动效
   *
   * @param isStart true开启，false结束
   */
  private setScrollUpState(isStart: boolean): void {
    // 开启跟手动效，打断列表回胶囊动效
    if (isStart) {
      // V2样式
      if (this.vmInjector) {
        this.getClockAnimVm()?.requestInterruptClockAnim();
        let animVm = this.getWholeAnimVm();
        animVm?.interruptAnim(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX);
        animVm?.interruptAnim(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK);
        animVm?.interruptAnim(ImmersiveAnimScene.SCENE_LIST_TO_CARD);
      } else {
        this.clockAnimMgr?.requestInterruptClockAnim();
        this.animMgr?.interruptAnimScene(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX);
        this.animMgr?.interruptAnimScene(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK);
        this.animMgr?.interruptAnimScene(ImmersiveAnimScene.SCENE_LIST_TO_CARD);
      }
    }
    // V2样式
    if (this.vmInjector) {
      let scene = ImmComAnimScene.ANIM_CAP_LIST_TOUCH_BACK;
      this.getContentSt()?.setAnimScene({ isAnimating: isStart, animScene: scene, isForceRemove: false });
      this.getRemindSt()?.setAnimScene({ isAnimating: isStart, animScene: scene, isForceRemove: false });
      this.getShadowSt()?.setAnimScene({ isAnimating: isStart, animScene: scene, isForceRemove: false });
      if (isStart) {
        this.getClockAnimVm()?.startClockAnimScene(scene);
      } else {
        this.getClockAnimVm()?.endClockAnimScene(scene);
      }
    } else {
      let scene = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH;
      this.getContentState()?.setAnimScene({ isAnimating: isStart, animScene: scene, isForceRemove: false });
      this.getRemindState()?.setAnimScene({ isAnimating: isStart, animScene: scene, isForceRemove: false });
      this.getShadowState()?.setAnimScene({ isAnimating: isStart, animScene: scene, isForceRemove: false });
      if (isStart) {
        this.clockAnimMgr?.startClockAnimScene(scene);
      } else {
        this.clockAnimMgr?.endClockAnimScene(scene);
      }
    }
  }

  /**
   * 更新上滑进度
   *
   * @param offsetY 偏移量
   */
  private updateScrollUp(offsetY: number): void {
    // 计算位移，保持向上位移
    let rate = this.dynamicRate.getRate(this.initY, offsetY);
    let deltaY = offsetY - this.preY;
    this.gTranY += (deltaY * rate);
    this.preY = offsetY;
    this.gTranY = Math.min(0, this.gTranY);
    // 内容胶囊位移
    let realContentY = this.gTranY;
    // 阴影胶囊比例限制
    let realShadowY = realContentY * CapTouchConst.SHADOW_Y_FACTOR;
    // 胶囊缩放过渡
    let progress = Math.min(Math.abs(realContentY) / CapTouchConst.MAX_Y_FOR_SCALE, WDefault.MAX_VALUE);
    // V2样式
    if (this.vmInjector) {
      this.getContentSt()?.setTranY(realContentY);
      this.getRemindSt()?.setTranY(realContentY);
      this.getShadowSt()?.setTranY(realShadowY);
    } else {
      this.getContentState()?.setTranY(realContentY);
      this.getRemindState()?.setTranY(realContentY);
      this.getShadowState()?.setTranY(realShadowY);
    }
    this.recordContentTranY(realContentY);
    this.recordShadowTranY(realShadowY);
    // V2样式
    if (this.vmInjector) {
      this.getClockAnimVm()?.setTouchAnimValue(realContentY, progress, false);
    } else {
      this.clockAnimMgr?.setTouchAnimValue(realContentY, progress, false);
    }
  }

  /**
   * 上滑结束，恢复胶囊
   *
   * @param vel 离手速度
   */
  private endScrollUpBack(vel: number = 0, isAnim: boolean = true): void {
    if (isAnim) {
      if (this.vmInjector) {
        this.getWholeAnimVm()?.startCap2ListTouchBackAnim(vel);
      } else {
        this.animMgr?.startCapsule2ListTouchBackAnim(vel);
      }
    }
    this.setScrollUpState(false);
    this.recordContentTranY(0);
    this.recordShadowTranY(0);
    this.resetTran();
  }

  /**
   * 上滑结束，触发状态切换
   *
   * @param vel 离手速度
   */
  private endScrollUpSuccess(vel: number = 0): void {
    if (this.vmInjector) {
      this.getImmCapVm()?.onCapToList(vel, ImmersiveTypeScene.SCENE_CAP_UP_SCROLL);
      // 动效开启后复位
      this.recordContentTranY(0);
      this.recordShadowTranY(0);
      this.setScrollUpState(false);
      this.resetTran();
      return;
    }
    let capData = this.capVm?.getShowList().getNtfData(CapsulePositionType.TYPE_CONTENT);
    ImmersiveSysEventUtil.reportToggleStatusEvent(capData, StatusParams.CAPSULE, StatusParams.LIST, ToggleWay.UP);
    this.capVm?.onCapsuleToList(vel).then(() => {
      // 动效开启后复位
      this.recordContentTranY(0);
      this.recordShadowTranY(0);
    });
    this.setScrollUpState(false);
    this.resetTran();
  }

  /**
   * 手势位移复位
   */
  private resetTran(): void {
    this.preY = this.initY;
    this.gTranY = 0;
    // 可滑动区域，屏幕高度
    let display = baseStateMgr.getBaseState(StateType.TYPE_DISPLAY_SIZE) as DisplaySizeState;
    this.dynamicRate.setMaxDeltaX(px2vp(display.displayHeight));
    this.isUpVibrator = false;
  }

  /**
   * 获取有效速度值
   *
   * @param velY 原速度
   * @param deltaY 位移距离
   * @returns 速度值
   */
  private getValidVelocity(velY: number, deltaY: number): number {
    if (CommonUtils.equals(deltaY, 0)) {
      return 0;
    }
    let vel = velY / deltaY;
    let absVel = Math.abs(vel);
    if (absVel > CapTouchConst.VEL_MAX) {
      vel = (vel / absVel) * CapTouchConst.VEL_MAX;
    }
    return vel;
  }

  /**
   * 记录内容胶囊位移
   *
   * @param tranY 位移
   */
  private recordContentTranY(tranY: number): void {
    // V2样式
    if (this.vmInjector) {
      this.getItemComStyle(CapShowType.CAP_REMIND)?.setTranY(tranY);
      this.getItemComStyle(CapShowType.CAP_CONTENT)?.setTranY(tranY);
    } else {
      this.animMgr?.setCapsuleAnimStyle(CapsulePositionType.TYPE_CONTENT, AnimStyleType.TRAN_Y, tranY);
    }
  }

  /**
   * 记录阴影胶囊位移
   *
   * @param tranY 位移
   */
  private recordShadowTranY(tranY: number): void {
    // V2样式
    if (this.vmInjector) {
      this.getItemComStyle(CapShowType.CAP_SHADOW)?.setTranY(tranY);
    } else {
      this.animMgr?.setCapsuleAnimStyle(CapsulePositionType.TYPE_SHADOW, AnimStyleType.TRAN_Y, tranY);
    }
  }

  /**
   * 内容胶囊动效状态
   *
   * @returns 动效状态
   */
  private getContentState(): WidgetAnimState {
    return this.animMgr?.getCapsuleAnimState(CapsulePositionType.TYPE_CONTENT)!;
  }

  /**
   * 阴影胶囊动效状态
   *
   * @returns 动效状态
   */
  private getShadowState(): WidgetAnimState {
    return this.animMgr?.getCapsuleAnimState(CapsulePositionType.TYPE_SHADOW)!;
  }

  /**
   * 强提醒动效胶囊
   *
   * @returns 动效状态
   */
  private getRemindState(): WidgetAnimState {
    return this.animMgr?.getCapsuleAnimState(CapsulePositionType.TYPE_REMIND)!;
  }

  /**
   * 内容胶囊动效状态V2
   *
   * @returns 动效状态
   */
  private getContentSt(): WidgetAnimStateV2 {
    return this.getImmCapAnimVm()?.getItemComAnimSt(CapShowType.CAP_CONTENT)!;
  }

  /**
   * 阴影胶囊动效状态V2
   *
   * @returns 动效状态
   */
  private getShadowSt(): WidgetAnimStateV2 {
    return this.getImmCapAnimVm()?.getItemComAnimSt(CapShowType.CAP_SHADOW)!;
  }

  /**
   * 强提醒胶囊动效状态V2
   *
   * @returns 动效状态
   */
  private getRemindSt(): WidgetAnimStateV2 {
    return this.getImmCapAnimVm()?.getItemComAnimSt(CapShowType.CAP_REMIND)!;
  }

  /**
   * 获取胶囊通用样式状态管理器
   *
   * @param type 胶囊类型
   * @returns 样式
   */
  private getItemComStyle(type: CapShowType): WidgetStyleStateV2 | undefined {
    return this.getImmCapAnimVm()?.getItemComStyle(type);
  }

  private getCapData(): ImmCapDataArray | undefined {
    return this.getImmCapVm()?.getSlCapData();
  }

  private getImmCapAnimVm(): IImmersiveCapAnimVm | undefined {
    return this.vmInjector?.getImmersiveCapAnimVm();
  }

  private getImmCapVm(): IImmersiveCapVm | undefined {
    return this.vmInjector?.getImmersiveCapVm();
  }

  private getClockAnimVm(): ISlClockAnimVm | undefined {
    return this.vmInjector?.getSlClockAnimVm();
  }

  private getWholeAnimVm(): IImmersiveWholeAnimVm | undefined {
    return this.vmInjector?.getImmersiveWholeAnimVm();
  }
}