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

import Curves from '@ohos.curves'
import { NotificationEntry } from '../model/NotificationEntry';
import { ntfMgr } from '../model/NotificationManager';
import { LogDomain, LogHelper, TraceUtil, DomainName } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { HiDfxEventUtil, HiSysDataDirection, EvtBus, DeviceHelper } from '@ohos/frameworkwrapper';
import animator, { AnimatorResult } from '@ohos.animator';
import { NotificationSysEventReporter, BannerState, bannerMgr} from '@ohos/systemuicommon';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { NtfSwipeDeleteEvent } from '../common/event/NotificationEvent';
import { SlNtfItemWidth } from '../common/SlNtfItemWidth';
import NTF_LIST_VM_HOLDER from '../model/NtfListVmHolder';
import { NotificationType } from '../common/NotificationType';
import { notificationStyle } from '../vm/style/NotificationStyle';
import { NotificationUtils } from '../common/NotificationUtils';
import { DeleteNotificationMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import util from '@ohos.util';
import lazy { NotificationDataManager } from '@ohos/systemuicommon/newTsIndex';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { NotificationAnimationParas } from '../common/NotificationAnimationParas';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { VibratorUtil } from '@ohos/systemuicommon';

const TAG = 'NtfItemSwipeController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const OPACITY_WHEN_DELETING = 0.5;

/**
 * 横滑阻尼系数，平移值*系数
 */
const SWIPE_DAMP = 0.4;

/**
 * 左横滑动态跟手率系数
 */
const DYNAMIC_FOLLOW_FACTOR = -1.848;

/**
 * 横滑默认阻尼系数
 */
const SWIPE_DEFAULT_DAMP = 1;

/**
 * 从左向右滑动清除通知的阈值
 */
const SWIPE_RIGHT_PERCENT = 1.0 / 2;

/**
 * 从右向左长滑动清除通知的阈值
 */
const SWIPE_LEFT_DELETE_PERCENT = 0.67;

/**
 * 从右向左滑动，展开或关闭的临界值
 */
const SWIPE_LEFT_CRITICAL = 12;

/**
 * 按钮区域右边界
 */
const RIGHT_BORDER = 0;

/**
 * 按钮裁剪区域滑动系数
 */
const CLIP_TRANSLATE_SPEED_PERCENT = 2;

/**
 * 通知条目显示删除、设置按钮时的卡片位置
 */
const MENU_ROW_SHOW_ITEM_TRAN = -140;
/**
 * 左滑删除横幅，扩大位移，防止闪烁
 */
const HEADS_UP_LEFT_SWIPE_REMOVE_EXPAND = 1.05;

/**
 * 锁屏通知左滑菜单裁剪参数传递
 */
interface KgMenuClipParam {
  /**
   * menu宽度
   */
  menuWidth: number,
  /**
   * menu高度
   */
  menuHeight: number,
  /**
   * 通知Y轴偏移量
   */
  offsetY: number,
  /**
   * menu外边距top值
   */
  marginTopVal: number,
}

/**
 * 通知条目横滑控制器
 *
 * @since 2023-01-11
 */
export class NtfItemSwipeController {
  /**
   * 触发手势速度滑动临界值
   */
  public static readonly SWIPE_SPEED = 750;

  /**
   * 触发手势横滑的临界值
   */
  public static readonly SWIPE_DISTANCE = 5;

  /**
   * 触发手势竖滑的临界值
   */
  public static readonly VERTICAL_DISTANCE = ArkUIAdapter.px2vp(1);

  /**
   * 横滑回调集
   */
  private swipeCallbacks: Set<SwipeCallback> = new Set();

  /**
   * 通知数据
   */
  private ntfEntry?: NotificationEntry | null;

  /**
   * 是否为横幅通知
   */
  private isHeadsUpNtf: boolean = false;

  /**
   * 条目右侧menu按钮宽度
   */
  private itemMenuWidth: number = 0;

  /**
   * 条目宽度
   */
  private itemWidth: number = 0;

  /**
   * 通知条目当前横向平移距离
   */
  private itemTranX: number = 0;

  /**
   * 通知条目横滑动画
   */
  private itemTranAnim: AnimateParam | null = null;

  /**
   * 该条通知是否可右滑删除
   */
  public isItemCanClear: boolean = true;

  /**
   * 开始滑动前，条目平移位置
   */
  private startAnimItemTranX: number = 0;

  /**
   * 上一时刻手指横滑位置
   */
  private lastOriItemTranX: number = 0;

  /**
   * 上一时刻真实横滑位置
   */
  private lastRealItemTranX: number = 0;

  /**
   * 当次滑动是否为竖向滑动
   */
  private isVertical: boolean = false;

  /**
   * 记录滑动是否从左向右滑动
   */
  private isLeft2right: boolean = false;

  public isRemoving: boolean = false;

  /**
   * 记录横滑手势速度
   */
  private swipeSpeed: number = 0;

  private isSettingsIgnore: boolean = false;

  /**
   * 是否为分组中的条目
   */
  private isInGroup: boolean = false;

  /**
   * 锁屏条目宽度
   */
  private slItemWidth?: SlNtfItemWidth;

  /**
   * pc触控板双指轻滑，降低滑动速度
   */
  private isNeedSlowSpeed: boolean = false;

  private isRTL: boolean = RTLUtil.isRTL();

  private menuThreshold: number = 100;

  /*
   * banner窗口状态管理
   */
  private bannerState: BannerState = bannerMgr.getBannerState();
  private groupEntryCB: () => NotificationEntry | undefined = () => undefined;

  public swipePercent: number = SWIPE_RIGHT_PERCENT;

  /**
   * 是否需要振动
   */
  private needVibrate: boolean = true;

  /**
   * 注册横滑监听器
   *
   * @param swipeCallback 回调器
   */
  registerSwipeCallback(swipeCallback: SwipeCallback): void {
    this.swipeCallbacks.add(swipeCallback);
  }

  /**
   * 注销横滑监听器
   *
   * @param swipeCallback 回调器
   */
  unregisterSwipeCallback(swipeCallback: SwipeCallback): void {
    this.swipeCallbacks.delete(swipeCallback);
  }

  setGroupEntryCB(getGroupEntryCB: () => NotificationEntry | undefined) {
    this.groupEntryCB = getGroupEntryCB;
  }

  /**
   * 重置起始位置
   */
  resetStartPosition(): void {
    this.itemTranX = 0;
  }

  /**
   * 设置通知数据
   *
   * @param entry 通知数据
   */
  setNtfEntry(entry: NotificationEntry | null): void {
    this.ntfEntry = entry;
    this.getItemCanClear();
  }

  setSettingsIgnore(isSettingsIgnore: boolean): void {
    this.isSettingsIgnore = isSettingsIgnore;
    this.getItemCanClear();
  }

  getItemCanClear(): void {
    let canClear: boolean = false;
    if (this.ntfEntry?.isLiveType()) {
      canClear = Boolean(this.ntfEntry?.canClear());
    } else {
      canClear = Boolean(this.ntfEntry?.canDelete() && !this.ntfEntry?.isOngoing);
    }
    this.isItemCanClear = canClear;
  }

  /**
   * 设置是否为横幅通知
   *
   * @param isHeadsUp true横幅通知
   */
  setHeadsUpNtf(isHeadsUp: boolean): void {
    this.isHeadsUpNtf = isHeadsUp;
  }

  /**
   * 设置条目menu宽度
   *
   * @param menuWidth menu按钮宽度
   */
  setItemMenuWidth(menuWidth: number): void {
    this.itemMenuWidth = menuWidth;
  }

  /**
   * 设置条目宽度
   *
   * @param itemWidth 条目宽度
   */
  setItemWidth(itemWidth: number): void {
    if (this.itemWidth !== itemWidth) {
      this.itemWidth = itemWidth;
      if (this.slItemWidth) { // 锁屏条目宽度记录
        setTimeout(() => this.slItemWidth?.setItemWidth(itemWidth));
      }
    }
  }

  setIsInGroup(isInGroup: boolean) {
    this.isInGroup = isInGroup;
  }
  setMenuDelThreshold(value: number) {
    this.menuThreshold = value;
  }
  /**
   * get item width.
   */
  getItemWidth(): number {
    return this.itemWidth;
  }

  /**
   * 锁屏场景条目宽度记录
   *
   * @returns 条目宽度
   */
  public getSlItemWidth(): SlNtfItemWidth {
    if (this.slItemWidth) {
      return this.slItemWidth;
    }
    this.slItemWidth = new SlNtfItemWidth();
    return this.slItemWidth;
  }

  /**
   * 手势响应判断
   *
   * @param type 面板类型
   * @param info 手势信息
   * @returns 判断结果
   */
  public onGestureJudgeBegin(type: number, info: GestureInfo): GestureJudgeResult {
    if (!NotificationType.isKeyguard(type)) { // 非锁屏面板，直接放行
      return GestureJudgeResult.CONTINUE;
    }
    // 屏蔽横滑、点击事件
    let isTarGesture = info.type === GestureControl.GestureType.PAN_GESTURE ||
      info.type === GestureControl.GestureType.SWIPE_GESTURE || info.type === GestureControl.GestureType.TAP_GESTURE;
    if (!isTarGesture) {
      return GestureJudgeResult.CONTINUE;
    }
    // 禁用横滑
    return notificationStyle.item.isDisableSwipe ? GestureJudgeResult.REJECT : GestureJudgeResult.CONTINUE;
  }

  private updateGestureSlow(event: GestureEvent): void {
    log.showInfo(`updateGestureSlow ${event.source}, ${event.sourceTool}`);
    this.isNeedSlowSpeed = event.source === SourceType.Mouse && event.sourceTool === 9;
  }

  /**
   * 开始横滑
   *
   * @param event 手势事件
   */
  onStartSwipe(event: GestureEvent): void {
    // 初始判断是否为竖向滑动
    this.isVertical = this.isVerticalSwipe(event);
    // 只处理横滑，竖滑收起
    if (this.isVertical) {
      if (this.isSwipeExpand()) {
        this.swipe2Collapse();
      }
      return;
    }
    if (DeviceHelper.isPC()) {
      this.updateGestureSlow(event);
    }
    this.isRTL = RTLUtil.isRTL();
    // 开始滑动时，记录条目平移位置
    this.startAnimItemTranX = this.itemTranX;
    this.lastRealItemTranX = this.itemTranX;
    this.lastOriItemTranX = this.itemTranX;
    // 无需动效
    this.notifyTranAnimChange(null);
    this.notifyTranXChange(event.offsetX);
  }

  /**
   * 更新横滑
   *
   * @param event 手势事件
   */
  onUpdateSwipe(event: GestureEvent, ntfAniParameters?: NotificationAnimationParas): void {
    // 竖滑不处理
    if (this.isVertical) {
      return;
    }
    // 无需动效
    this.notifyTranAnimChange(null);
    this.notifyTranXChange(event.offsetX, ntfAniParameters);
    this.overRemoveThresholdVibration();
  }

  /**
   * 结束横滑
   *
   * @param event 手势事件
   * @param isKeyGuard 是否锁屏界面触发
   */
  onEndSwipe(event: GestureEvent, isKeyGuard: boolean = false): void {
    this.needVibrate = true;
    // 记录滑动方向
    this.isLeft2right = this.isRTL ? event.offsetX < 0 : event.offsetX > 0;
    // 竖滑不处理
    if (this.isVertical) {
      return;
    }
    // 无需动效
    this.notifyTranAnimChange(null);
    this.notifyTranXChange(event.offsetX);
    // 结束滑动
    this.handleSwipeTouchEnd(isKeyGuard, event.velocity);
    log.showInfo(`swipe end: ${event.velocity}, ${event.velocityX}`);
  }

  /**
   * 横滑被取消
   * @param isKeyGuard 是否锁屏界面触发
   */
  onCancelSwipe(isKeyGuard: boolean = false): void {
    // 竖滑不处理
    if (this.isVertical) {
      return;
    }
    // 结束滑动
    this.handleSwipeTouchEnd(isKeyGuard, 0);
  }
  /**
   * 当前swipe展开时，收起swipe
   */
  swipe2Collapse(): void {
    if (this.itemTranX == 0 || this.isRemoving) {
      return;
    }
    // 开始位移动画
    this.startTranXAnim(0);
  }

  /**
   * 点击删除按钮时，滑动删除通知条目
   */
  swipe2Delete(): void {
    // 开始位移动画
    this.startTranXAnim(this.getRTLValue(-this.itemWidth), true, true);
  }

  /**
   * 获取条目menu宽度
   *
   * @return menu宽度
   */
  getItemMenuWidth(): number {
    return this.itemMenuWidth;
  }

  /**
   * build menu clip rect
   *
   * @param menuWidth menu's width
   * @param ntfTranX notification transx
   * @param ntfHeight notification's height
   * @returns clip rect
   */
  buildMenuClipRect(menuWidth: number, ntfTranX: number, ntfHeight: Length): string {
    this.isRTL = RTLUtil.isRTL();
    let menuPositionX = this.getRTLValue(-1 * menuWidth);
    let ntfTranXAdj = 0;
    if (menuPositionX < 0) {
      ntfTranXAdj = ntfTranX <= menuPositionX ? (-1 * this.itemWidth * SWIPE_LEFT_DELETE_PERCENT) : ntfTranX;
    } else {
      ntfTranXAdj = ntfTranX >= menuPositionX ? (this.itemWidth * SWIPE_LEFT_DELETE_PERCENT) : ntfTranX;
    }
    if (this.getRTLValue(ntfTranX) > 0) {
      ntfTranXAdj = 0;
    }
    let commands: string = 'M';
    commands += this.isRTL ? '0' : Math.floor(ArkUIAdapter.vp2px(menuWidth - Math.abs(ntfTranXAdj)));
    commands += ' 0 H';
    commands += this.isRTL ? Math.floor(ArkUIAdapter.vp2px(Math.abs(ntfTranXAdj))) :
    Math.floor(ArkUIAdapter.vp2px(menuWidth));
    commands += ' V';
    commands += Math.floor(ArkUIAdapter.vp2px(Number(ntfHeight)));
    commands += ' H';
    commands += this.isRTL ? '0' : Math.floor(ArkUIAdapter.vp2px(menuWidth - Math.abs(ntfTranXAdj)));
    commands += ' Z';
    return commands;
  }

  /**
   *  锁屏通知 build menu clip rect
   *
   * @param menuWidth menu宽度
   * @param menuHeight menu高度
   * @param offsetY 通知Y轴偏移量
   * @param marginTopVal menu外边距top值
   * @returns clip rect
   */
  buildKgMenuClipRect(paras: KgMenuClipParam): RectAttribute {
    let clipRect = new Rect({
      width: this.itemWidth,
      height: paras.menuHeight,
      radius: 0,
    }).position({
      y: paras.offsetY > paras.marginTopVal ? paras.offsetY - paras.marginTopVal : 0,
      x: paras.menuWidth - this.itemWidth
    });
    return clipRect;
  }

  /**
   * 判断是否在裁剪区域内滑动
   *
   * @param tranX 滑动结束位置
   * @param itemTranX 滑动开始事件
   * @returns 判断结果
   */
  checkIsInClipRange(tranX: number, itemTranX: number): boolean {
    if (this.itemMenuWidth === 0) {
      return false;
    }
    // 菜单的左右边框位置
    let leftBorder = this.isRTL ? RIGHT_BORDER : -this.itemMenuWidth;
    let rightBorder = this.isRTL ? this.itemMenuWidth : RIGHT_BORDER;
    return (tranX == leftBorder && itemTranX > leftBorder) ||
      (tranX == rightBorder && itemTranX < rightBorder);
  }

  /**
   * 获取裁剪区域滑动动画
   *
   * @param begin 开始位置
   * @param end 结束位置
   * @returns 滑动动画
   */
  getClipTranslateAnimation(begin: number, end: number): AnimatorResult {
    let duration = this.itemMenuWidth * CLIP_TRANSLATE_SPEED_PERCENT;
    let translateAnimator = animator.create({
      duration: duration,
      easing: 'ease-out',
      delay: 0,
      fill: 'forwards',
      direction: 'normal',
      iterations: 1,
      begin: begin,
      end: end
    })
    return translateAnimator;
  }

  /**
   * 是否竖向滑动
   *
   * @param event 滑动事件
   * @return true 竖向
   */
  private isVerticalSwipe(event: GestureEvent): boolean {
    return Math.abs(event.offsetY) > Math.abs(event.offsetX);
  }

  /**
   * 当前条目是否swipe展开
   *
   * @return true 展开
   */
  isSwipeExpand(): boolean {
    return this.itemTranX < 0;
  }
  private getRTLValue(value:number): number {
    let mark = this.isRTL ? -1 : 1;
    return mark * value;
  }
  /**
   * 处理touch滑动结束事件
   *
   * @param isKeyGuard 是否锁屏界面触发
   * @param speed 横滑速度
   */
  private handleSwipeTouchEnd(isKeyGuard: boolean = false, speed: number) {
    let isSpeedCanClear = speed >= NtfItemSwipeController.SWIPE_SPEED;
    let isLongSwipeCanClear = Math.abs(this.itemTranX) >= (this.swipePercent * this.itemWidth);
    let isShowMenuCanClear = Math.abs(this.itemTranX) >= (this.itemMenuWidth + this.menuThreshold);
    if (this.isLeft2right) {
      if (Math.abs(this.startAnimItemTranX) === this.itemMenuWidth && this.itemMenuWidth !== 0) {
        // 从左向右滑，菜单展开时，复位至0
        this.startTranXAnim(0);
      } else {
        // 未达到阈值或无法删除，复位至0
        if (!this.isItemCanClear || (!isLongSwipeCanClear && !isSpeedCanClear)) {
          log.showInfo('SwipeTouchEnd reset to 0');
          // 复位
          this.startTranXAnim(0);
        } else {
          // 删除
          this.swipeSpeed = isSpeedCanClear ? speed : 0;
          DeleteNotificationMaintenance.addNtfMap(this.ntfEntry?.isGroup ? this.ntfEntry.childrenEntry : [this.ntfEntry]
            , DeleteNotificationType.RIGHT_SLIDE_DELETE, this.isInGroup);
          this.doRemove(isKeyGuard);
        }
      }
    } else {
      // 从右向左滑动
      if (this.isHeadsUpNtf && !isSpeedCanClear && !isLongSwipeCanClear) {
        // 横幅通知左长滑未达到阈值
        this.startTranXAnim(0);
        return
      }
      if (this.startAnimItemTranX !== 0 && isSpeedCanClear && this.isItemCanClear) {
        // 菜单显示时再次左滑，速度达到阈值，删除通知
        DeleteNotificationMaintenance.addNtfMap(this.ntfEntry?.isGroup ? this.ntfEntry.childrenEntry : [this.ntfEntry]
          , DeleteNotificationType.LEFT_SLIDE_DELETE, this.isInGroup);
        this.doRemove();
        return;
      }
      if ((isShowMenuCanClear || this.isHeadsUpNtf) && this.isItemCanClear) {
        this.swipeSpeed = isSpeedCanClear ? speed : 0;
        DeleteNotificationMaintenance.addNtfMap(this.ntfEntry?.isGroup ? this.ntfEntry.childrenEntry : [this.ntfEntry]
          , DeleteNotificationType.LEFT_SLIDE_DELETE, this.isInGroup);
        // 滑动达到阈值，删除
        this.doRemove(isKeyGuard);
        return;
      }
      this.doShowMenu();
    }
  }
  private doRemove(isKeyGuard:boolean = false) {
    this.ntfEntry?.notifyOutChanged();
    // 延迟100ms删除，先改变动画属性
    setTimeout(()=> {
      log.showInfo('swipe doRemove');
      let tranX: number = this.getRTLValue(this.itemWidth);
      if (this.isHeadsUpNtf) {
        // 横幅通知根据屏幕宽度计算移出屏幕的终点
        let screenWidth = ArkUIAdapter.px2vp(this.bannerState.displaySizeState.displayWidth)
        let distance = (screenWidth - this.itemWidth) / 2 + this.itemWidth;
        tranX = this.getRTLValue(distance) * HEADS_UP_LEFT_SWIPE_REMOVE_EXPAND;
      }
      this.startTranXAnim(this.isLeft2right ? tranX : -tranX, true);
      HiDfxEventUtil.reportDeleteNotificationBySwipe((this.ntfEntry as NotificationEntry)?.creatorBundleName,
        this.isLeft2right ? HiSysDataDirection.TO_RIGHT : HiSysDataDirection.TO_LEFT);
      this.reportNtfSlipLeftRight(isKeyGuard);
    }, DeviceHelper.isPC() ? 100 : 0);
  }
  private doShowMenu() {
    // 无法删除，复位至菜单或显示菜单
    log.showInfo('swipe doShowMenu');
    let endTranX = this.getRTLValue(-this.itemMenuWidth);
    this.startTranXAnim(endTranX);
    if (this.startAnimItemTranX === 0) {
      /* 菜单显示打点 */
      HiDfxEventUtil.reportLeftSwipeNtfShowMenu((this.ntfEntry as NotificationEntry)?.creatorBundleName);
      this.reportSlipLeft(this.ntfEntry as NotificationEntry);
    }
  }
  private setDeletingOpacity() {
    log.showInfo('SetDeletingOpacity.');
    this.swipeCallbacks.forEach((callback: SwipeCallback) => {
      callback.onUpdateItemOpacity?.(OPACITY_WHEN_DELETING);
    });
  }

  private reportSlipLeft(entry: NotificationEntry): void {
    NotificationSysEventReporter.notificationSlipLeft({
      CREATOR_BUNDLE_NAME: entry?.creatorBundleName,
      NOTIFICATION_SLOT_TYPE: entry?.slotType,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      NOTIFICATION_ID: entry?.id,
      NOTIFICATION_CONTROL_FLAGS: entry?.controlConfig?.flags,
      BUNDLE_TYPE: entry?.bundleType,
      TRACE_ID: entry?.traceId
    });
  }

  /**
   * 删除通知
   * 如果保护态的组通知，删除关联的组通知，否则删除该通知即可
   */
  private removeEntry = (entry: NotificationEntry): void => {
    if (!entry) {
      log.showWarn(`removeEntry entry is undefined!`);
      return;
    }
    if (AppProtectedVm.get().isProtected(entry.bundleIdxTag)) {
      let groupEntry = this.groupEntryCB();
      if (groupEntry?.childrenEntry) {
        ntfMgr.batchRemoveNtf(groupEntry.childrenEntry);
      } else if (entry.groupEntry?.childrenEntry) {
        ntfMgr.batchRemoveNtf(entry.groupEntry.childrenEntry);
      }
    } else {
      ntfMgr.removeNtfEntryByCancel(entry);
    }
  }

  /**
   * 开启横向平移动画
   *
   * @param endTranX 平移最终值
   * @param isRemoveEntry 是否移除通知
   * @param isFromBtn 是否来自点击按钮
   * @param isInNtfPanel 是否为通知中心
   */
  private startTranXAnim(endTranX: number, isRemoveEntry?: boolean, isFromBtn?: boolean, isInNtfPanel?: boolean): void {
    let anim: AnimateParam;
    // 位移动画
    if (isRemoveEntry) {
      // 重新计算duration，在横滑删除时，继承跟手速度，防止手抬起后动效衔接卡顿
      let duration = Math.abs(endTranX - this.itemTranX);
      if (this.swipeSpeed && !isFromBtn) {
        duration = Math.abs(endTranX - this.itemTranX) / this.swipeSpeed * 1000;
      }
      TraceUtil.startTrace(DomainName.SYS_UI, `Swipe2Remove_${this.ntfEntry?.hashCode}`);
      this.notifySwipeDeleteStart();
      const tempEntry = this.ntfEntry;
      const hashCode = this.ntfEntry?.hashCode ?? '';
      log.showInfo(`remove hashCode ${hashCode}`);
      if (!this.isHeadsUpNtf) { // 防止点击按钮删除通知中心闪烁
        NTF_LIST_VM_HOLDER.getNtfListVmInstance(NotificationType.TYPE_PHONE_DROPDOWN)?.setUpdateFreeze(`${hashCode}_DROPDOWN`);
        NTF_LIST_VM_HOLDER.getNtfListVmInstance(NotificationType.TYPE_PHONE_KEYGUARD)?.setUpdateFreeze(`${hashCode}_KEYGUARD`);
        if (SystemUICcmConfig.instance.isEnabledLive2) {
          NotificationDataManager.instance.freeze(NotificationDataManager.REASON.DROPDOWN_REMOVE, 2000);
        }
        this.removeEntry(tempEntry as NotificationEntry);
      } else { // 清除通知的动作要延迟到动画结束再进行，否则动画会被直接打断，造成横幅无动画直接消失
        setTimeout(() => {
          this.removeEntry(tempEntry as NotificationEntry);
        }, duration);
      }
      if (!this.isLeft2right && !this.isHeadsUpNtf) {
        let delayTime = Math.max(duration - 100, 0);
          // 左长滑删除最后几帧透明度变化
        if (delayTime === 0) {
          this.setDeletingOpacity();
        } else {
          setTimeout(() => {
            this.setDeletingOpacity();
          }, delayTime)
        }
      }
      anim = {
        // 距离作为毫秒数 动画曲线和不移除通知的保持一致，否则会出现松手后抖动一下
        duration: duration,
        curve: Curve.Smooth,
        onFinish: () => {
          log.showInfo(`Swipe2Remove_${hashCode} onFinish begin`);
          TraceUtil.endTrace(DomainName.SYS_UI, `Swipe2Remove_${hashCode}`);
          this.notifySwipeDeleteEnd();
          NTF_LIST_VM_HOLDER.getNtfListVmInstance(NotificationType.TYPE_PHONE_DROPDOWN)?.releaseUpdateFreeze(`${hashCode}_DROPDOWN`);
          NTF_LIST_VM_HOLDER.getNtfListVmInstance(NotificationType.TYPE_PHONE_KEYGUARD)?.releaseUpdateFreeze(`${hashCode}_KEYGUARD`);
          if (SystemUICcmConfig.instance.isEnabledLive2) {
            NotificationDataManager.instance.unfreeze(NotificationDataManager.REASON.DROPDOWN_REMOVE);
          }
          if (this.isHeadsUpNtf) {
            // 删除动画结束后重置remove，避免横幅通知需要连续滑动两次才能删除
            this.isRemoving = false;
          }
          log.showInfo(`Swipe2Remove_${hashCode} onFinish end`);
        }
      }
      log.showInfo(`Swipe2Remove_${hashCode} anim ${util.getHash(anim)}`);
    } else {
      anim = { curve: Curves.springCurve(0, 1, 228, 23), onFinish: () => this.setItemSwipeExpandStatus(endTranX) };
    }
    this.swipeSpeed = 0;
    this.isRemoving = isRemoveEntry as boolean;
    this.notifyTranAnimChange(anim);
    // 开始位移
    this.notifyTranXEndValue(endTranX, isRemoveEntry, anim);
  }

  private notifySwipeDeleteStart(): void {
    let event = new NtfSwipeDeleteEvent();
    event.eventType = NtfSwipeDeleteEvent.EVENT_TYPE_START;
    event.entry = this.ntfEntry;
    event.inGroup = this.isInGroup;
    EvtBus.post(NtfSwipeDeleteEvent, event);
  }

  private notifySwipeDeleteEnd(): void {
    let event = new NtfSwipeDeleteEvent();
    event.eventType = NtfSwipeDeleteEvent.EVENT_TYPE_END;
    EvtBus.post(NtfSwipeDeleteEvent, event);
  }

  /**
   * 平移距离回调
   *
   * @param tranX 触摸平移距离
   */
  private notifyTranXChange(tranX: number, ntfAniParameters?: NotificationAnimationParas): void {
    // 计算无阻尼状态时，条目平移位置
    let oriItemTranX = tranX + this.startAnimItemTranX;
    let realItemTranX = oriItemTranX;
    // 从左向右偏移，或者横幅通知，（在无需放慢情况下）都是滑动回弹或直接清除
    if ((this.getRTLValue(oriItemTranX) > 0 || this.isHeadsUpNtf) && !this.isNeedSlowSpeed) {
      // 能够清除无阻尼，不能清除加阻尼
      let damp = this.isItemCanClear ? SWIPE_DEFAULT_DAMP : SWIPE_DAMP;
      realItemTranX = oriItemTranX * damp;
    } else { // 从右向左偏移
      let overMenuTranX = Math.abs(oriItemTranX) - this.itemMenuWidth;
      // 超出menu宽度的偏移量需要加阻尼，使用动态阻尼率
      if (overMenuTranX > 0) {
        let dynamicFollowRate =
        Math.exp(DYNAMIC_FOLLOW_FACTOR * overMenuTranX * SWIPE_LEFT_DELETE_PERCENT / this.itemWidth);
        realItemTranX = dynamicFollowRate * (oriItemTranX - this.lastOriItemTranX) + this.lastRealItemTranX;
      }
    }
    this.lastOriItemTranX = oriItemTranX;
    this.lastRealItemTranX = realItemTranX;

    ntfAniParameters?.updateTranX(realItemTranX);

    // 回调
    log.showInfo(`notifyTranXChange ${tranX} to ${realItemTranX}, ${this.isNeedSlowSpeed}`);
    this.notifyTranXEndValue(realItemTranX);
    this.setItemSwipeExpandStatus(realItemTranX);
  }

  private setItemSwipeExpandStatus(tranX: number): void {
    if (this.ntfEntry) {
      this.ntfEntry.isItemSwipeExpand = tranX < 0;
    }
  }

  /**
   * 回调平移最终值
   *
   * @param endTranX 最终值
   * @param isRemoveEntry 是否删除通知
   * @param itemAnim 动画参数
   */
  private notifyTranXEndValue(endTranX: number, isRemoveEntry?: boolean, itemAnim?: AnimateParam): void {
    // 有变化，回调
    if (this.itemTranX != endTranX || isRemoveEntry) {
      this.itemTranX = endTranX;
      this.swipeCallbacks.forEach((callback: SwipeCallback) => {
        callback.onUpdateItemTranX?.(endTranX, isRemoveEntry ?? false);
        callback.onExtendUpdateItemTranX?.(endTranX, isRemoveEntry ?? false, itemAnim);
      });
    }
  }

  /**
   * 平移动效回调
   *
   * @param tranAnim 动效
   */
  private notifyTranAnimChange(tranAnim: AnimateParam | null): void {
    if (this.itemTranAnim != tranAnim) {
      this.itemTranAnim = tranAnim;
      this.swipeCallbacks.forEach((callback: SwipeCallback) => {
          callback.onUpdateItemAnim?.(tranAnim);
      });
    }
  }

  /**
   * 左右横滑删除通知打点
   * @param isKeyGuard
   */
  private reportNtfSlipLeftRight(isKeyGuard: boolean = false) {
    let isInAggregate = this.ntfEntry?.isInAggregate;
    NotificationSysEventReporter.notificationSlipLeftRight({
      CREATOR_BUNDLE_NAME: this.ntfEntry?.creatorBundleName,
      NOTIFICATION_ID: this.ntfEntry?.id,
      NOTIFICATION_SLOT_TYPE: isInAggregate ? null : this.ntfEntry?.slotType,
      DISPLAY_SCENE: isKeyGuard ? 2 : this.isHeadsUpNtf ? 3 : 4,
      TIME_STAMP: NotificationUtils.getNtfTimeStampByBoard(isKeyGuard),
      IS_GROUP: this.ntfEntry?.isGroup ? 1 : this.isInGroup ? 2 : 0,
      IS_AGGREGATE: isInAggregate ? 1 : 0,
      NOTIFICATION_CONTROL_FLAGS: this.ntfEntry?.controlConfig?.flags,
      BUNDLE_TYPE: this.ntfEntry?.bundleType,
      TRACE_ID: this.ntfEntry?.traceId
    });
  }

  /**
   * 超过删除通知阈值触发振动
   */
  protected overRemoveThresholdVibration(): void {
    // 横幅通知横滑不振动
    if (this.isHeadsUpNtf) {
      return;
    }
    const isDeleteThreshold: boolean = -this.itemTranX >= (this.itemMenuWidth + this.menuThreshold);
    if (isDeleteThreshold && this.needVibrate && this.isItemCanClear) {
      this.needVibrate = false;
      VibratorUtil.startVibration('haptic.drag', 'physicalFeedback');
    } else if (!isDeleteThreshold) {
      this.needVibrate = true;
    }
  }
}

/**
 * swipe处理结果回调
 */
export interface SwipeCallback {
  /**
   * 更新通知条目横向平移距离
   *
   * @param tranX 平移距离
   * @param isRemoveEntry 是否移除通知
   */
  onUpdateItemTranX?(tranX: number, isRemoveEntry: boolean): void;

  /**
   * 更新通知条目横向平移动画
   *
   * @param itemAnim 动画
   */
  onUpdateItemAnim?(itemAnim: AnimateParam | null): void;

  /**
   * 更新通知条目横向平移距离，扩展接口
   * 带有动画参数则开启动效，否则直接设置位移值
   *
   * @param tranX 平移距离
   * @param isRemoveEntry 是否移除通知
   * @param itemAnim 动画参数
   */
  onExtendUpdateItemTranX?(tranX: number, isRemoveEntry: boolean, itemAnim?: AnimateParam): void;

  /**
   * 更新通知条目透明度
   *
   * @param opacity:透明度
   */
  onUpdateItemOpacity?(opacity: number): void;
}