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

import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  AnimValue,
  AccessibilityUtil,
  ImmersiveType,
  ImmersiveTypeScene,
  immersiveKgMgr,
  BaseConstants,
  ImmersiveState
} from '@ohos/systemuicommon';
import { ImmersiveAnimKey, ImmersiveAnimScene } from '../../common/anim/ImmersiveAnimConstants';
import { immersiveFgCtrl } from '../../model/service/ImmersiveFingerControll';
import { ImmersiveListVm } from '../ImmersiveListVm';
import { ImmersiveAnimManager } from '../viewanim/ImmersiveAnimManager';
import { NtfListStaticState } from '../viewdata/NtfListState';
import { ImmersiveListAnimManager } from '../viewanim/ImmersiveListAnimManager';
import { SlClockAnimManager } from '../viewanim/SlClockAnimManager';
import { NotificationStateManager } from '@ohos/screenlockcommon';
import {
  TouchRunnableManager,
  TriggerType
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/TouchRunnableManager';
import { ImmersiveSysEventUtil, StatusParams, ToggleWay } from '../../common/ImmersiveSysEventUtil';
import { CmpPosWrapper, DynamicCurveRate, WidgetAnimState, WidgetAnimStateV2 } from '@ohos/screenlockcommon/Index';
import { Runnable } from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/Runnable';
import { DownPosition } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { NotificationItemStyle } from '@ohos/notificationcomponent/src/main/ets/vm/style/NotificationItemStyle';
import { notificationStyle } from '@ohos/notificationcomponent/src/main/ets/vm/style/NotificationStyle';
import { immersiveStateHelper } from '../../common/helper/ImmersiveStateHelper';
import { SlListWidgetBindState } from '../../model/data/SlListWidgetBindState';
import {
  defaultStopHandle,
  IImmersiveEventStopListener,
  ImmersiveEventStopHandle
} from './ImmersiveEventStopHandle';
import { immersiveStateMgr } from '../../common/manager/ImmersiveStateManager';
import { IImmersiveListHandle } from '../../common/interface/IImmersiveListHandle';
import { IImmersiveNtfVmInjector } from '../../common/interface/IImmersiveNtfVmInjector';
import { IImmersiveListVm } from '../../common/interface/IImmersiveListVm';
import { SlListStaticStateV2 } from '../../model/data/v2/SlListStaticStateV2';
import { SlListBindStateV2 } from '../../model/data/v2/SlListBindStateV2';
import { ImmListConst, ListAnimSuffix, StopTouchReason } from '../../common/constants/ImmListConst';
import { ImmComAnimScene } from '../../common/constants/ImmComConst';
import { ISlClockAnimVm } from '../../common/interface/ISlClockAnimVm';
import { IImmersiveWholeAnimVm } from '../../common/interface/IImmersiveWholeAnimVm';
import { IImmersiveListAnimVm } from '../../common/interface/IImmersiveListAnimVm';
import { NotificationArray } from '@ohos/systemuicommon/newTsIndex';

const TAG = 'ImmersiveListHandle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 列表事件相关常量
 */
export enum ListTouchConst {
  /**
   * 滚动偏移阈值
   */
  SCROLL_OFFSET_SLOP = 20,

  /**
   * 手势触发阈值
   */
  GESTURE_DEFAULT_SLOP = 5,

  /**
   * 下滑最大距离
   */
  GESTURE_DOWN_MAX_Y = 100,

  /**
   * 缩放进度计算最大位移
   */
  DOWN_MAX_Y_FOR_SCALE = 180,

  /**
   * 下滑速度阈值
   */
  GESTURE_DOWN_VEL_Y = 1000,

  /**
   * 下滑离手点向上速度阈值
   */
  GESTURE_UP_VEL_Y = 200,

  /**
   * 缩放梯度
   */
  SCALE_STEP = 0.03,

  /**
   * 位移指数基数最大值
   */
  RANGE_POW_MAX = 0.95,

  /**
   * 位移指数基数最小值
   */
  RANGE_POW_MIN = 0.7,

  /**
   * 最后一个条目位移指数基数
   */
  END_ITEM_POW_BASE = 0.55,

  /**
   * 条目层叠间距
   */
  ITEM_SPACE_BASE = 0,

  /**
   * 条目层叠间距梯度
   */
  ITEM_SPACE_STEP = 2,

  /**
   * 最大速度
   */
  VEL_MAX = 15,

  /**
   * 默认跟手比率常数
   */
  COEFFICIENT_K_COMMON = 3.6,

  /**
   * 拦截下拉场景，跟手比率常数
   */
  COEFFICIENT_K_INTERCEPT = 4.6,

  /**
   * 单双击事件间隔有300ms，沉浸态切换延时450ms
   */
  IMM_CHANGE_TIME = 450,
}

// 条目裁切参数
interface ItemClipParam {
  clipOffsetY: number;
  clipHeight: number;
}

/**
 * 沉浸通知列表事件处理
 */
export class ImmersiveListHandle implements IImmersiveListHandle {
  /**
   * 列表vm
   */
  private listVm?: ImmersiveListVm;

  /**
   * 动效管理
   */
  private animMgr?: ImmersiveAnimManager;

  /**
   * 列表动效管理
   */
  private listAnimMgr?: ImmersiveListAnimManager;

  /**
   * 时钟元素动效管理器
   */
  private clockAnimMgr?: SlClockAnimManager;

  /**
   * 列表业务注入器
   */
  private vmInjector?: IImmersiveNtfVmInjector;

  /**
   * 触摸事件任务管理
   */
  private touchMgr: TouchRunnableManager = new TouchRunnableManager();

  /**
   * 通知样式
   */
  private ntfStyle: NotificationItemStyle = notificationStyle.item;

  /**
   * 手势ID，保持单指
   */
  private gestureId?: number;

  /**
   * 动态跟手比率计算
   */
  private dynamicRate: DynamicCurveRate = new DynamicCurveRate(ListTouchConst.GESTURE_DOWN_MAX_Y)
    .setK(ListTouchConst.COEFFICIENT_K_COMMON);

  /**
   * 是否开启下滑跟手
   */
  private isDownScrollEnable: boolean = false;

  /**
   * 初始y值，下滑起始值
   */
  private initY: number = ListTouchConst.GESTURE_DEFAULT_SLOP;

  /**
   * 上一次y值
   */
  private preY: number = ListTouchConst.GESTURE_DEFAULT_SLOP;

  /**
   * 一次手势事件总位移
   */
  private gTranY: number = 0;

  /**
   * 下拉手势异常结束任务
   */
  private downGestureEndRunnable: Runnable = () => {
    this.onGestureEnd(PanDirection.Down, true);
  };

  /**
   * 是否拦截事件
   */
  private isStopEvent: boolean = false;

  /**
   * 事件拦截状态管理
   */
  private eventStopHandle?: ImmersiveEventStopHandle = defaultStopHandle;

  /**
   * 沉浸状态
   */
  private immersiveState: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();

  /**
   * 事件拦截切换监听器
   */
  private eventStopListener: IImmersiveEventStopListener = {
    onEventStop: (isStop: boolean): void => {
      this.isStopEvent = isStop;
      if (isStop && this.isDownScrollEnable) {
        this.startList2CapsuleAnim(0, true);
      }
    }
  };

  /**
   * 绑定列表VM
   *
   * @param listVm 列表VM
   * @returns 链式
   */
  bindListVm(listVm: ImmersiveListVm): ImmersiveListHandle {
    this.listVm = listVm;
    return this;
  }

  /**
   * 绑定动效管理
   *
   * @param animMgr 动效管理
   * @returns 链式
   */
  bindAnimMgr(animMgr: ImmersiveAnimManager): ImmersiveListHandle {
    this.animMgr = animMgr;
    this.listAnimMgr = animMgr.getListAnimMgr();
    this.clockAnimMgr = animMgr.getSlClockAnimMgr();
    return this;
  }

  /**
   * 绑定事件拦截
   *
   * @param eventStopHandle 事件拦截
   * @returns 链式
   */
  bindStopHandle(eventStopHandle: ImmersiveEventStopHandle): ImmersiveListHandle {
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
    this.eventStopHandle?.unregisterEventStopListener(this.eventStopListener);
    this.eventStopHandle?.destroy();
  }

  /**
   * 列表高度，最大可滑动距离
   *
   * @param height 列表高度
   */
  setListHeight(height: number): void {
    this.dynamicRate.setMaxDeltaX(height);
  }

  /**
   * 列表触摸事件回调
   *
   * @param event 事件
   */
  onListTouchEvent(event: TouchEvent): void {
    // V2样式
    if (this.vmInjector) {
      // 列表面板down点处理
      let globalDown: DownPosition =
        { positionX: event?.touches[0]?.screenX, positionY: event?.touches[0]?.screenY };
      this.vmInjector.getPanelVm().setPanelGlobalDownPosition(globalDown);
      // 无数据，不拦截事件
      if (!event || ArrayUtils.isEmpty(this.getStaticStV2()?.getListData())) {
        return;
      }
      // 拦截事件
      if (this.getStaticStV2()?.isStopPropagation()) {
        event.stopPropagation();
      }
    }
    let id = event?.changedTouches?.[0]?.id ?? 0;
    let eventType = event?.type ?? TouchType.Cancel;
    this.touchMgr.updateTouchType(id, eventType);
  }

  /**
   * 条目事件拦截
   *
   * @param event 事件
   * @param itemKey 条目标示
   * @returns 事件分发模式
   */
  onItemTouchIntercept(event: TouchEvent, itemKey?: string): HitTestMode {
    if (!itemKey) {
      return HitTestMode.Default;
    }
    let min = BaseConstants.MIN_VALUE;
    let eventObj = event?.touches?.[min];
    if (!eventObj) {
      return HitTestMode.Default;
    }
    let clipParam = this.getItemClipParam(itemKey);
    let offsetY = clipParam.clipOffsetY;
    let clipHeight = clipParam.clipHeight;
    if (clipHeight === min) {
      return HitTestMode.Default;
    }
    let touchY = eventObj.y;
    if (touchY >= offsetY && touchY <= (offsetY + clipHeight)) {
      return HitTestMode.Default;
    }
    // 超出裁剪范围的事件统一拦截
    return HitTestMode.Block;
  }

  /**
   * 手势触发回调
   *
   * @param direction 手势方向
   * @param event 事件参数
   */
  onGestureStart(direction: PanDirection, event: GestureEvent): void {
    if (CommonUtils.isInvalid(this.gestureId)) { // 记录单指ID
      this.gestureId = event.fingerList?.[0]?.id;
    }
    switch (direction) {
      case PanDirection.Up:
        this.upStart(event);
        break;
      case PanDirection.Down:
        this.downStart(event);
        break;
      case PanDirection.Left:
      case PanDirection.Right:
        this.leftRightStart(event);
        break;
      default:
        break;
    }
  }

  /**
   * 手势更新回调
   *
   * @param direction 手势方向
   * @param event 事件参数
   */
  onGestureUpdate(direction: PanDirection, event: GestureEvent): void {
    switch (direction) {
      case PanDirection.Down:
        this.downUpdate(event);
        break;
      default:
        break;
    }
  }

  /**
   * 手势结束回调
   *
   * @param direction 手势方向
   * @param isCancel 手势是否中断取消
   * @param event 事件参数
   */
  onGestureEnd(direction: PanDirection, isCancel: boolean, event?: GestureEvent): void {
    switch (direction) {
      case PanDirection.Up:
        this.upEnd(isCancel, event);
        break;
      case PanDirection.Down:
        this.downEnd(isCancel, event);
        break;
      default:
        break;
    }
    // 锁屏事件拦截复位
    this.getStaticState().isStopPropagation = true;
    this.getStaticStV2()?.setStopPropagation(true);
    this.gestureId = undefined;
  }

  /**
   * 列表滚动开始
   */
  scrollStart(): void {
    if (this.vmInjector) { // V2样式
      this.getAnimMgrV2()?.interruptAnim(ImmComAnimScene.ANIM_LIST_CAP_TOUCH_BACK);
      return;
    }
    // 开启滑动后打断动效
    this.animMgr?.interruptAnimScene(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH_BACK);
  }

  /**
   * 滑动触顶、触底
   */
  scrollReachStartEnd(): void {
    if (!this.getStaticState()?.itemUpdateAnim) { // 无更新动效时，触顶触底允许刷新
      this.scrollList(0);
    }
  }

  /**
   * 列表滚动帧生效前回调
   *
   * @param offset 滚动偏移
   */
  scrollFrameBegin(offset: number): void {
    if (this.isAtEnd() && offset >= 0) { // 已经触底，继续上滑时拦截
      return;
    }
    // 当偏移阈值过大时，需提前计算叠加效果
    if (Math.abs(offset) > ListTouchConst.SCROLL_OFFSET_SLOP) {
      this.scrollList(offset);
    }
  }

  /**
   * 列表滚动，跟手动效
   *
   * @param offset 滑动偏移
   * @param isResolveWait 释放动效拦截
   */
  scrollList(offset: number, isResolveWait?: boolean): void {
    this.listAnimMgr?.updateListAnimParas({ offset: offset, isFromScroll: true, isResolveWait: isResolveWait });
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
    let listData = this.getListData();
    if (listData && listData?.length === 0) {
      return false;
    }
    let rootPos = this.vmInjector ? this.getImmListAnimVm()?.getRootPos() :
      this.animMgr?.getListViewPosition(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT);
    let itemPos = CmpPosWrapper.wrapper(rootPos);
    let touchHotZonesMaxX = itemPos.getCmpGlobalX() + itemPos.getCmpWidth();
    let touchHotZonesMaxY = itemPos.getCmpGlobalY() + itemPos.getCmpHeight();
    return globalX >= itemPos.getCmpGlobalX() && globalX <= touchHotZonesMaxX &&
      globalY >= itemPos.getCmpGlobalY() && globalY <= touchHotZonesMaxY;
  }

  /**
   * 上滑触发处理
   *
   * @param event 事件
   */
  private upStart(event: GestureEvent): void {
    // 上滑时，列表已经触底，屏蔽列表滑动，事件透传解锁
    if (this.isAtEnd()) {
      this.getBindState().setListScrollEnable(false);
      this.getStaticState().isStopPropagation = false;
      // V2样式
      this.getBindStV2()?.setScrollerEnable(false);
      this.getStaticStV2()?.setStopPropagation(false, StopTouchReason.REASON_UP_AT_END);
      ImmersiveSysEventUtil.reportListAtEndUnlockEvent(ToggleWay.UP);
    }
  }

  /**
   * 上滑结束处理
   *
   * @param isCancel 是否取消
   * @param event 事件
   */
  private upEnd(isCancel: boolean, event?: GestureEvent): void {
    if (this.isAnimating()) { // 过渡动效中，不再继续触发手势
      log.showWarn('upEnd list to cap animating');
      return;
    }
    // 上滑结束时，恢复列表滑动，保证触底
    if (!this.getBindState().getListScrollEnable()) {
      this.getBindState().setListScrollEnable(true);
      this.listVm?.scrollListToBottom();
    }
    // V2样式
    if (this.vmInjector && !this.getBindStV2()?.isScrollerEnable()) {
      this.getBindStV2()?.setScrollerEnable(true);
      this.getStaticStV2()?.scrollListToBottom();
    }
  }

  /**
   * 下滑触发处理
   *
   * @param event 事件
   */
  private downStart(event: GestureEvent): void {
    if (!this.immersiveState.isShowList()) {
      log.showWarn('downStart list is not showing');
      return;
    }
    if (this.isAnimating()) { // 过渡动效中，不再继续触发手势
      log.showWarn('downStart list to cap animating');
      return;
    }
    // 下滑时，列表已经触顶，屏蔽列表滑动，开启下滑跟手
    this.isDownScrollEnable = false;
    if (this.isAtTop()) {
      this.getBindState().setListScrollEnable(false);
      this.getBindStV2()?.setScrollerEnable(false);
      this.isDownScrollEnable = true;
      if (this.vmInjector) { // v2样式，最大高度限制
        let maxHeight = this.getStaticStV2()?.getListMaxHeight() ?? 0;
        this.dynamicRate.setMaxDeltaX(maxHeight);
      }
      // 跟手比率区分
      this.dynamicRate.setK(this.isInterceptDownScroll() ?
        ListTouchConst.COEFFICIENT_K_INTERCEPT : ListTouchConst.COEFFICIENT_K_COMMON);
      // 开启单指保护任务
      if (CommonUtils.isNumber(this.gestureId)) {
        this.touchMgr.addUpRunnable(this.gestureId!, this.downGestureEndRunnable, TriggerType.TRIGGER_TIMEOUT);
      }
    }
    // 打断胶囊到列表动效
    if (this.isDownScrollEnable) {
      this.startTouchAnim();
    }
    // 计算位移值
    this.resetTran();
    this.downUpdate(event);
  }

  /**
   * 下滑更新处理
   *
   * @param event 事件
   */
  private downUpdate(event: GestureEvent): void {
    if (!this.isDownScrollEnable || this.isStopEvent) {
      return;
    }
    // 计算位移，保持向下位移
    let rate = this.dynamicRate.getRate(this.initY, event.offsetY);
    let deltaY = event.offsetY - this.preY;
    this.gTranY += (deltaY * rate);
    this.preY = event.offsetY;
    this.gTranY = Math.max(0, this.gTranY);
    // V2样式
    if (this.vmInjector) {
      this.setItemTouchValueV2(this.gTranY);
    } else {
      this.setItemTouchValue(this.gTranY);
    }
  }

  /**
   * 下滑结束处理
   *
   * @param isCancel 是否取消
   * @param event 事件
   */
  private downEnd(isCancel: boolean, event?: GestureEvent): void {
    // 下滑结束，恢复列表滑动
    let isDownScroll = this.isDownScrollEnable;
    this.isDownScrollEnable = false;
    if (!isDownScroll) { // 无跟手事件
      this.resetListScrollEnable(false);
      return;
    }
    if (CommonUtils.isNumber(this.gestureId)) { // 清除结束任务
      this.touchMgr.cancelUpRunnable(this.gestureId!);
    }
    // V2样式
    if (this.vmInjector) {
      this.endTouchAnimV2();
    } else {
      // 跟手结束
      this.endTouchAnim();
    }
    // 跟手直接回退
    if (this.isInterceptDownScroll() || this.isStopEvent) {
      this.isStopEvent = false;
      this.startList2CapsuleAnim(0, true);
      return;
    }
    // 离手向上速度，回退
    let velY = event?.velocityY ?? 0;
    let offsetY = event?.offsetY ?? this.preY;
    if (velY < -ListTouchConst.GESTURE_UP_VEL_Y) {
      this.startList2CapsuleAnim(velY, true);
      return;
    }
    // 沉浸列表态，切换到胶囊态
    if (offsetY >= ListTouchConst.GESTURE_DOWN_MAX_Y || velY >= ListTouchConst.GESTURE_DOWN_VEL_Y) {
      this.startList2CapsuleAnim(velY);
      // 列表下滑到胶囊打点
      ImmersiveSysEventUtil.reportListToCapEvent(StatusParams.LIST, StatusParams.CAPSULE, ToggleWay.DOWN);
      return;
    }
    this.startList2CapsuleAnim(velY, true);
  }

  /**
   * 开启列表过渡胶囊动效
   *
   * @param vel 速度
   * @param isBack 是否跟手回退
   */
  private startList2CapsuleAnim(vel: number, isBack: boolean = false): void {
    let maxVel = ListTouchConst.GESTURE_DOWN_MAX_Y;
    let validVel = this.getValidVelocity(vel, isBack ? -maxVel : maxVel);
    if (isBack) { // 回退
      // V2样式
      if (this.vmInjector) {
        this.getAnimMgrV2()?.startList2CapTouchBackAnim(validVel);
      } else {
        this.animMgr?.startList2CapsuleTouchBackAnim(validVel);
      }
      this.resetListScrollEnable();
      return;
    }
    // 时钟元素共享速度
    NotificationStateManager.updateTouchVelocityY(validVel);
    // V2样式
    if (this.vmInjector) {
      this.getListVmV2()?.onListToCap(validVel, ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL, () => {
        this.resetListScrollEnable();
        NotificationStateManager.updateTouchVelocityY(0);
      });
    } else {
      immersiveStateMgr.switchImmersiveState(ImmersiveType.TYPE_CAPSULE, false,
        ImmersiveTypeScene.SCENE_LIST_DOWN_SCROLL);
      // 动效期间，屏蔽指纹显示
      let scene = ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX;
      immersiveFgCtrl.addFingerHideScene(scene);
      this.animMgr?.startList2CapsuleFixAnim(validVel, undefined, () => {
        setTimeout(() => this.listVm?.resetGroupItemToCollapse()); // 组通知延时收起
        this.resetListScrollEnable();
        immersiveFgCtrl.removeFingerHideScene(scene);
        NotificationStateManager.updateTouchVelocityY(0);
      });
    }
    // 列表态切换到胶囊态，无障碍播报'已收起'
    AccessibilityUtil.sendAccessibilityByResource($r('app.string.cc_accessibility_str_ntf_swipe_right_text'));
  }

  /**
   * 设置通知条目跟手位移、缩放
   *
   * @param tranY 位移距离
   */
  private setItemTouchValue(tranY: number): void {
    let startIndex = this.getStaticState().startItemIndex;
    let endIndex = this.getStaticState().endItemIndex;
    let itemArr = this.listVm?.getNtfList();
    let preState: WidgetAnimState | undefined = undefined;
    let prePos: CmpPosWrapper | undefined = undefined;
    let max = AnimValue.VALUE_MAX;
    let min = AnimValue.VALUE_MIN;
    let progress = Math.min(Math.abs(tranY) / ListTouchConst.DOWN_MAX_Y_FOR_SCALE, max);
    this.clockAnimMgr?.setTouchAnimValue(tranY, progress);
    let itemSpace = ListTouchConst.ITEM_SPACE_BASE;
    let powStep = (ListTouchConst.RANGE_POW_MAX - ListTouchConst.RANGE_POW_MIN) / (endIndex - startIndex + max);
    let isOnlyOne = startIndex === endIndex;
    for (let i = endIndex; i >= startIndex; i--) {
      let hashcode = itemArr?.[i]?.getGroupKey();
      if (CommonUtils.isInvalid(hashcode)) {
        continue;
      }
      let isEndItem = i === endIndex;
      let itemState = this.animMgr?.getListAnimState(hashcode);
      let itemPos = CmpPosWrapper.wrapper(this.animMgr?.getListViewPosition(hashcode));
      let preHeight = prePos?.getCmpHeight() ?? min;
      let preTranY = preState?.getTranY() ?? min;
      // 最后一个条目位移最少，后续往上逐级位移加大
      let notEndPow = ListTouchConst.RANGE_POW_MIN + powStep * (endIndex - max - i);
      let powBase = isEndItem ? ListTouchConst.END_ITEM_POW_BASE : notEndPow;
      let indexCount = isOnlyOne ? max : i - startIndex; // 索引差值
      let itemTranY = tranY * Math.pow(powBase, indexCount);
      let itemScale = max - (ListTouchConst.SCALE_STEP * (indexCount + max) * progress);
      // 存在pre条目时，条目位移不能超过pre条目
      if (!isEndItem) {
        let validHeight = Math.min(itemPos.getCmpHeight(), preHeight - itemSpace);
        itemTranY = Math.min(itemTranY, validHeight + preTranY);
        itemSpace += ListTouchConst.ITEM_SPACE_STEP;
      }
      let scene = ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH;
      itemState?.setAnimScene({ isAnimating: true, animScene: scene, isForceRemove: false })
        .setTranY(itemTranY).setScaleX(itemScale).setScaleY(itemScale).setZIndex(min - i)
        .setWidth(itemPos.getCmpWidth()).setHeight(itemPos.getCmpHeight());
      preState = itemState;
      prePos = itemPos;
    }
  }

  /**
   * 计算通知条目跟手位移、缩放 V2
   *
   * @param tranY 位移距离
   */
  private setItemTouchValueV2(tranY: number): void {
    if (!this.vmInjector) {
      log.showError('setItemTouchValueV2 vmInjector is null');
      return;
    }
    let startIndex = this.getImmListAnimVm()?.getItemStartIndex() ?? ImmListConst.INVALID_INDEX;
    let endIndex = this.getImmListAnimVm()?.getItemEndIndex() ?? ImmListConst.INVALID_INDEX;
    let itemArr = this.getListData();
    let preState: WidgetAnimStateV2 | undefined = undefined;
    let prePos: CmpPosWrapper | undefined = undefined;
    let max = AnimValue.VALUE_MAX;
    let min = AnimValue.VALUE_MIN;
    let progress = Math.min(Math.abs(tranY) / ListTouchConst.DOWN_MAX_Y_FOR_SCALE, max);
    this.getClockAnimVm()?.setTouchAnimValue(tranY, progress);
    let itemSpace = ListTouchConst.ITEM_SPACE_BASE;
    let powStep = (ListTouchConst.RANGE_POW_MAX - ListTouchConst.RANGE_POW_MIN) / (endIndex - startIndex + max);
    let isOnlyOne = startIndex === endIndex;
    for (let i = endIndex; i >= startIndex; i--) {
      let hashcode = itemArr?.[i]?.groupKey;
      if (CommonUtils.isInvalid(hashcode)) {
        continue;
      }
      let isEndItem = i === endIndex;
      let itemState = this.getImmListAnimVm()?.getItemComAnimSt(hashcode!);
      let itemPos = CmpPosWrapper.wrapper(this.getImmListAnimVm()?.getItemPos(hashcode!));
      let preHeight = prePos?.getCmpHeight() ?? min;
      let preTranY = preState?.getTranY() ?? min;
      // 最后一个条目位移最少，后续往上逐级位移加大
      let notEndPow = ListTouchConst.RANGE_POW_MIN + powStep * (endIndex - max - i);
      let powBase = isEndItem ? ListTouchConst.END_ITEM_POW_BASE : notEndPow;
      // 索引差值
      let indexCount = isOnlyOne ? max : i - startIndex;
      let itemTranY = tranY * Math.pow(powBase, indexCount);
      let itemScale = max - (ListTouchConst.SCALE_STEP * (indexCount + max) * progress);
      // 存在pre条目时，条目位移不能超过pre条目
      if (!isEndItem) {
        let validHeight = Math.min(itemPos.getCmpHeight(), preHeight - itemSpace);
        itemTranY = Math.min(itemTranY, validHeight + preTranY);
        itemSpace += ListTouchConst.ITEM_SPACE_STEP;
      }
      let scene = ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH;
      itemState?.setAnimScene({ isAnimating: true, animScene: scene, isForceRemove: false })
        .setTranY(itemTranY).setScaleX(itemScale).setScaleY(itemScale).setZIndex(min - i)
        .setWidth(itemPos.getCmpWidth()).setHeight(itemPos.getCmpHeight());
      preState = itemState;
      prePos = itemPos;
    }
  }

  /**
   * 位移复位
   */
  private resetTran(): void {
    this.preY = this.initY;
    this.gTranY = 0;
  }

  /**
   * 列表滑动开关复位
   *
   * @param isResetTop 是否复位到顶部
   */
  private resetListScrollEnable(isResetTop: boolean = true): void {
    if (isResetTop && !this.isAtTop()) { // 恢复顶部
      if (this.vmInjector) {
        this.getStaticStV2()?.scrollListToTop();
      } else {
        this.listVm?.scrollListToTop();
      }
    }
    // V2样式
    if (this.vmInjector && !this.getBindStV2()?.isScrollerEnable()) {
      this.getBindStV2()?.setScrollerEnable(true);
      return;
    }
    if (!this.getBindState().getListScrollEnable()) {
      this.getBindState().setListScrollEnable(true);
    }
  }

  /**
   * 标示跟手动效开启
   */
  private startTouchAnim(): void {
    this.ntfStyle.isDisableSwipe = true; // 禁用条目横滑
    // V2样式，禁用条目横滑点击
    this.getBindStV2()?.setItemSwipeEnable(false);
    // V2样式
    if (this.vmInjector) {
      this.getClockAnimVm()?.requestInterruptClockAnim();
      this.getAnimMgrV2()?.interruptAnim(ImmComAnimScene.ANIM_CAP_LIST_FIX)
        .interruptAnim(ImmComAnimScene.ANIM_LIST_CAP_TOUCH_BACK)
        .interruptAnim(ImmComAnimScene.ANIM_CARD_LIST);
      this.getClockAnimVm()?.startClockAnimScene(ImmComAnimScene.ANIM_LIST_CAP_TOUCH);
    } else {
      this.clockAnimMgr?.requestInterruptClockAnim();
      this.animMgr?.interruptAnimScene(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      this.animMgr?.interruptAnimScene(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH_BACK);
      this.animMgr?.interruptAnimScene(ImmersiveAnimScene.SCENE_CARD_TO_LIST);
      this.clockAnimMgr?.startClockAnimScene(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH);
    }
  }

  /**
   * 标示跟手动效结束
   */
  private endTouchAnim(): void {
    this.ntfStyle.isDisableSwipe = undefined; // 条目横滑解禁
    let scene = ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH;
    let startIndex = this.getStaticState().startItemIndex;
    let endIndex = this.getStaticState().endItemIndex;
    let itemArr = this.listVm?.getNtfList();
    for (let i = startIndex; i <= endIndex; i++) {
      let hashcode = itemArr?.[i]?.getGroupKey();
      if (CommonUtils.isInvalid(hashcode)) {
        continue;
      }
      let itemState = this.animMgr?.getListAnimState(hashcode);
      itemState?.setAnimScene({ isAnimating: false, animScene: scene, isForceRemove: false });
    }
    this.clockAnimMgr?.endClockAnimScene(scene);
  }

  /**
   * 标示跟手动效结束 V2
   */
  private endTouchAnimV2(): void {
    if (!this.vmInjector) {
      log.showError('endTouchAnimV2 vmInjector is null');
      return;
    }
    // 启用条目横滑点击
    this.getBindStV2()?.setItemSwipeEnable(true);
    let scene = ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH;
    let startIndex = this.getImmListAnimVm()?.getItemStartIndex() ?? ImmListConst.INVALID_INDEX;
    let endIndex = this.getImmListAnimVm()?.getItemEndIndex() ?? ImmListConst.INVALID_INDEX;
    let itemArr = this.getListData();
    for (let i = startIndex; i <= endIndex; i++) {
      let groupKey = itemArr?.[i]?.groupKey;
      if (groupKey === undefined) {
        continue;
      }
      let itemState = this.getImmListAnimVm()?.getItemComAnimSt(groupKey);
      itemState?.setAnimScene({ isAnimating: false, animScene: scene, isForceRemove: false });
    }
    this.getClockAnimVm()?.endClockAnimScene(scene);
  }

  /**
   * 左右滑动事件触发
   *
   * @param event 事件
   */
  private leftRightStart(event: GestureEvent): void {
    // 左右滑动时，非条目消费，则透传解锁
    if (!this.getStaticState().isTouchingItem) {
      this.getStaticState().isStopPropagation = false;
    }
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
    if (absVel > ListTouchConst.VEL_MAX) {
      vel = (vel / absVel) * ListTouchConst.VEL_MAX;
    }
    return vel;
  }

  /**
   * 条目裁切参数
   *
   * @param itemKey 条目标识
   * @returns 裁切参数
   */
  private getItemClipParam(itemKey: string): ItemClipParam {
    let min = BaseConstants.MIN_VALUE;
    if (this.vmInjector) { // V2样式
      let foldHelper = this.vmInjector.getImmItemHelperVm().getListAnimH(ListAnimSuffix.ITEM_FOLD_ANIM);
      let foldAnim = foldHelper.getItemSt(itemKey);
      let clipOffsetY = foldAnim?.getClipOffsetY() ?? min;
      let clipHeight = (foldAnim?.getClipHeight() ?? min) as number;
      return { clipOffsetY: clipOffsetY, clipHeight: clipHeight };
    }
    let animParas = this.listVm?.getListBindState()?.getNtfAnimPara(itemKey);
    let clipOffsetY = animParas?.ntfItemClipOffsetY ?? min;
    let clipHeight = animParas?.ntfItemClipHeight ?? min;
    return { clipOffsetY: clipOffsetY, clipHeight: clipHeight };
  }

  /**
   * 是否拦截下滑
   *
   * @returns true拦截下滑
   */
  private isInterceptDownScroll(): boolean {
    // 低指纹显示状态，不允许下拉
    return immersiveFgCtrl.isLowPosFingerPrint() ||
      immersiveKgMgr.getImmersiveDisplayState().immersiveType !== ImmersiveType.TYPE_LIST;
  }

  /**
   * 当前是否正在过渡动效中
   *
   * @returns true动效中
   */
  private isAnimating(): boolean {
    if (this.vmInjector) { // V2样式
      let animState = this.getAnimStV2();
      return animState?.isSceneAnimating(ImmComAnimScene.ANIM_LIST_CAP_FIX) ?? false;
    }
    let state = this.animMgr?.getListAnimState(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT);
    return state?.isSceneAnimating(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX) ?? false;
  }

  /**
   * 列表滑动是否触顶
   *
   * @returns true已触顶
   */
  private isAtTop(): boolean {
    if (this.vmInjector) { // V2样式
      return this.getStaticStV2()?.isListAtTop() ?? false;
    }
    return this.listVm?.isListAtTop() ?? false;
  }

  /**
   * 列表滑动是否触底
   *
   * @returns true已触底
   */
  private isAtEnd(): boolean {
    if (this.vmInjector) { // V2样式
      return this.getStaticStV2()?.isListAtEnd() ?? false;
    }
    return this.listVm?.getListScroller()?.isAtEnd() ?? false;
  }

  /**
   * 非UI绑定状态
   *
   * @returns 非UI状态
   */
  private getStaticState(): NtfListStaticState {
    return this.listVm?.getListStaticState() ?? new NtfListStaticState();
  }

  /**
   * UI绑定状态
   *
   * @returns UI状态
   */
  private getBindState(): SlListWidgetBindState {
    return immersiveStateHelper.getSlListBindState() as SlListWidgetBindState;
  }

  /**
   * 列表数据集
   *
   * @returns 数据集
   */
  private getListData(): NotificationArray | undefined {
    return this.getListVmV2()?.getSlNtfList();
  }

  /**
   * 列表业务管理器
   *
   * @returns 业务管理器
   */
  private getListVmV2(): IImmersiveListVm | undefined {
    return this.vmInjector?.getImmersiveListVm();
  }

  /**
   * 列表静态状态V2
   *
   * @returns 静态状态
   */
  private getStaticStV2(): SlListStaticStateV2 {
    return this.getListVmV2()?.getSlStaticState() as SlListStaticStateV2;
  }

  /**
   * 列表UI绑定状态V2
   *
   * @returns UI绑定状态
   */
  private getBindStV2(): SlListBindStateV2 {
    return this.getListVmV2()?.getSlBindState() as SlListBindStateV2;
  }

  /**
   * 列表动效状态V2
   *
   * @returns 动效状态
   */
  private getAnimStV2(): WidgetAnimStateV2 {
    return this.getListVmV2()?.getSlAnimState() as WidgetAnimStateV2;
  }

  /**
   * 沉浸模块全局动效管理器
   *
   * @returns 动效管理器
   */
  private getAnimMgrV2(): IImmersiveWholeAnimVm | undefined {
    return this.vmInjector?.getImmersiveWholeAnimVm();
  }

  /**
   * 沉浸模块列表动效管理器
   *
   * @returns 动效管理器
   */
  private getImmListAnimVm(): IImmersiveListAnimVm | undefined {
    return this.vmInjector?.getImmersiveListAnimVm();
  }

  private getClockAnimVm(): ISlClockAnimVm | undefined {
    return this.vmInjector?.getSlClockAnimVm();
  }
}