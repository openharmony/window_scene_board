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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  DeviceInfoVm,
  INotificationMenuVm,
  INotificationSwipeVm,
  INotificationListVm,
  NotificationItemBaseVm,
  INotificationCardVm,
  AnimationBase,
  ResourceVm,
  DropdownVm,
  DropDownPanelManager,
} from '@ohos/systemuicommon/newIndex';
import { NotificationApiUtil } from '../utils/NotificationApiUtil';
import { curves } from '@kit.ArkUI';
import { NotificationNormalVm } from './NotificationNormalVm';
import {
  NormalNotification,
  NormalNotificationGroup,
  NotificationBase, NotificationCategory, SystemUIUseScene } from '@ohos/systemuicommon/newTsIndex';
import { AccessibilityVm } from '@ohos/systemuicommon/src/main/ets/vm/AccessibilityVm';
import { DropDownEvent } from '@ohos/frameworkwrapper';
import { NotificationSysEventReporter, VibratorUtil } from '@ohos/systemuicommon';

const TAG = 'NotificationSwipeVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
const CLEAR_BUTTON_ID = 'NotificationClearButtonView_button';
const EXTRA_NTF_TITLE_ID = 'NotificationMoreHeaderView_Title_Extra_Ntf';
const LIST_EMPTY_ID = 'NotificationListView_empty';

@ObservedV2
export class NotificationSwipeVm extends NotificationItemBaseVm implements INotificationSwipeVm {
  protected static instances: Map<string, NotificationSwipeVm> = new Map();
  /**
   * 触发手势速度滑动临界值
   */
  protected static readonly SWIPE_SPEED = 750;
  /**
   * 触发手势横滑的临界值
   */
  protected static readonly SWIPE_DISTANCE = 5;
  /**
   * 松手时的动画曲线
   */
  protected static readonly SWIPE_ANIMATION_CURVES = curves.springCurve(0, 1, 228, 23);
  /**
   * 从右向左滑动，展开或关闭的临界值
   */
  protected static readonly SWIPE_LEFT_CRITICAL = 12;
  /**
   * 从左向右滑动清除通知的阈值
   */
  protected static readonly SWIPE_RIGHT_PERCENT = 1.0 / 2;
  /**
   * 阻尼系数，平移值*系数
   */
  protected static readonly SWIPE_DAMP = 0.4;
  /**
   * 左横滑动态跟手率系数
   */
  protected static readonly DYNAMIC_FOLLOW_FACTOR = -1.848
  /**
   * 从右向左长滑动清除通知的阈值
   */
  protected static readonly SWIPE_LEFT_DELETE_PERCENT = 0.67;
  /**
   * 横向偏移量
   */
  @Trace public offsetX: number = 0;
  /**
   * 是否需要振动
   */
  protected needVibrate: boolean = true;
  /**
   * 开始滑动时的横向偏移量
   */
  protected startOffsetX: number = 0;
  /**
   * 是否为分组中的条目
   */
  private isInGroup: boolean = false;
  /**
   * 条目宽度
   */
  @Computed get itemWidth(): number {
    return this.vmInjector.getPanelVm().cardWidth;
  }
  /**
   * 卡片删除偏移
   */
  @Computed get deleteOffset(): number {
    return this.itemWidth;
  }
  /**
   * 通知中心面板触摸Y轴点，-1无触摸
   */
  @Computed get panelDownWindowY(): number {
    return this.vmInjector.getPanelVm()?.panelDownWindowY ?? -1;
  }
  /**
   * 通知列表是否滑动中
   */
  @Computed get listIsScrolling(): boolean {
    return this.vmInjector.getListScrollerVm()?.isScrolling ?? false;
  }

  /**
   * 通知列表是否正在一键清除
   */
  @Computed get isClearingAll(): boolean {
    return this.vmInjector.getClearButtonVm()?.isClearingAll ?? false;
  }

  protected dropdownEvent: DropDownEvent = DropdownVm.instance.dropdownEvent;
  /**
   * 菜单宽度
   */
  protected menuWidth: number = 0;
  /**
   * 上一次滑动位置
   */
  protected lastOffsetX: number = 0;
  /**
   * 是否从左向右横滑
   */
  protected isLeftToRight: boolean = false;
  /**
   * 是否正在删除
   */
  protected isSwipeRemoving: boolean = false;
  /**
   * 展开收起动效实例
   */
  protected swipeAnimation = new AnimationBase(AnimationBase.NAMES.NTF_CARD_SWIPE_ANIMATION, true);

  protected cardVm?: INotificationCardVm = this.vmInjector.getCardVm?.(this.ntf);
  protected menuVm?: INotificationMenuVm = this.vmInjector.getMenuVm?.(this.ntf);
  protected listVm?: INotificationListVm = this.vmInjector.getListVm?.();

  init(): void {
    NotificationSwipeVm.instances.set(this.getKey(), this);
    log.showInfo(`init swipe vm for ${this.getKey()}, isRemoveAllowed: ${this.ntf.isRemoveAllowed}`);
  }

  destroy(): void {
    log.showInfo(`destroy swipe vm for ${this.getKey()}, reminging size: ${NotificationSwipeVm.instances.size}`);
    NotificationSwipeVm.instances.delete(this.getKey());
  }

  @Monitor('offsetX')
  onOffsetXChange(monitor: IMonitor) {
    this.menuVm?.updateSwipeOffsetX(monitor.value()?.now as number, this.isSwipeRemoving);
  }

  @Monitor('panelDownWindowY', 'listIsScrolling', 'dropdownEvent.moveY', 'dropdownEvent.progress', 'isClearingAll')
  onSwipeResetEvent() {
    if (this.checkNeedReset()) {
      this.update(0, true);
    }
  }

  /**
   * 检测是否需要重置通知卡片，该函数供子类重写
   */
  protected checkNeedReset(): boolean {
    if (this.offsetX === 0 || this.isSwipeRemoving) {
      return false;
    }

    // 当前四种场景reset通知卡片:
    // 1. 卡片未touch状态, 此时触摸点变化
    if (this.panelDownWindowY !== -1 && !this.cardVm?.isTouching) {
      return true;
    }
    // 2. 列表列表滚动场景
    if (this.listIsScrolling) {
      return true;
    }
    // 3. onBackPress场景
    if (this.dropdownEvent.progress === 0 && this.dropdownEvent.moveY === 0) {
      return true;
    }
    // 4. 一键清除场景
    if (this.isClearingAll) {
      return true;
    }

    return false;
  }

  public static reset(exceptInstance?: NotificationSwipeVm, animation: boolean = true): void {
    for (const instance of NotificationSwipeVm.instances.values()) {
      if (instance.offsetX === 0 || exceptInstance === instance || instance.isSwipeRemoving) {
        continue;
      }
      log.showInfo(`Reset ${instance.ntf?.hashCode}, animation:${animation}`);
      instance.update(0, animation);
    }
  }

  /**
   * 左滑阈值：列表场景为菜单宽度
   * @param itemWidth
   */
  public setLeftThreshold(threshold: number): void {
    this.menuWidth = threshold;
  }

  /**
   * 右滑阈值比例，列表场景固定
   * @param itemWidth
   */
  public setRightThreshold(threshold: number): void {}

  /**
   * 获取横向偏移量
   * @returns
   */
  public getOffsetX(): number {
    return this.offsetX;
  }

  /**
   * 重置偏移
   */
  public resetOffsetX(isResetCurrent?: boolean): void {
    log.showInfo(`Reset offsetX of ${this.ntf?.hashCode}`);
    if (isResetCurrent) {
      this.update(0, true);
      return;
    }
    NotificationSwipeVm.reset(this);
  }

  /**
   * 删除通知滑动
   * @returns
   */
  public removeNtf(): void {
    log.showInfo(`Remove ntf for ${this.ntf?.hashCode}`);
    this.remove(-this.itemWidth, Math.abs(-this.itemWidth - this.offsetX));
  }

  /**
   * 左长滑/右长滑删除通知打点
   * @returns
   */
  private reportNtfSlipLeftRight() {
    NotificationSysEventReporter.notificationSlipLeftRight({
      CREATOR_BUNDLE_NAME: this.ntf?.creatorBundleName,
      NOTIFICATION_ID: this.ntf?.id,
      NOTIFICATION_SLOT_TYPE: this.ntf?.slotType,
      DISPLAY_SCENE: this.ntf ? 3 : 4,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      IS_GROUP: this.ntf?.isNormalGroup() ? 1 : this.isInGroup ? 2 : 0,
      IS_AGGREGATE:  0,
      NOTIFICATION_CONTROL_FLAGS: this.ntf?.controlConfig?.flags,
      BUNDLE_TYPE: this.ntf?.bundleType,
      TRACE_ID: this.ntf?.traceId
    });
  }

  protected update(endOffsetX: number, animation: boolean): void {
    if (this.offsetX === endOffsetX) {
      return;
    }
    if (animation) {
      this.swipeAnimation.executeAnimation([
        {
          curve: NotificationSwipeVm.SWIPE_ANIMATION_CURVES,
          event: () => {
            this.offsetX = endOffsetX;
          }
        }
      ]);
    } else {
      this.offsetX = endOffsetX;
    }
  }

  protected async remove(endOffsetX: number, duration: number): Promise<void> {
    if (this.isSwipeRemoving) {
      return;
    }
    log.showInfo(`Swipe remove start, endOffsetX: ${endOffsetX}, duration: ${duration}, stack: ${new Error().stack}`);

    AccessibilityVm.instance.sendEventByResource($r('app.string.cc_accessibility_str_ntf_swipe_remove_text'));

    // 更多通知折叠删除无左滑动效，与旧版本一致
    if (this.isMoreBrief()) {
      NotificationApiUtil.removeNtfByCancel(this.listVm?.moreNtfList || []);
      AccessibilityVm.instance.requestFocusAccessibility(this.getRemoveAccessibilityId(this.ntf), true);
      return;
    }

    this.isSwipeRemoving = true;
    await new AnimationBase(AnimationBase.NAMES.NTF_CARD_SWIPE_ANIMATION, true).executeAnimation([{
      duration: duration,
      curve: Curve.Smooth,
      event: () => {
        this.offsetX = endOffsetX * this.getExpandDistance();
      },
    }]);
    NotificationApiUtil.removeNtfByCancel([this.ntf]);
    const isInGroup: boolean = (this.listVm?.getGroupNtf(this.ntf) !== undefined) && !this.ntf.isNormalGroup();
    if (isInGroup) {
      AccessibilityVm.instance.requestFocusAccessibility(this.getInGroupRemoveAccessibilityId(), true);
    } else if (!this.ntf.isLiveView()) {
      // 实况横滑删除这里不处理，在NotificationListVm中处理，后续迁移
      AccessibilityVm.instance.requestFocusAccessibility(this.getRemoveAccessibilityId(this.ntf), true);
    }
    this.isSwipeRemoving = false;
  }

  /**
   * 获取横滑手势处理器
   * @returns
   */
  public getPanGestureHandler(): PanGestureHandler {
    return new PanGestureHandler({
      direction: PanDirection.Horizontal,
      distance: NotificationSwipeVm.SWIPE_DISTANCE
    })
      .onActionStart((event: GestureEvent) => this.handleActionStart(event))
      .onActionUpdate((event: GestureEvent) => this.handleActionUpdate(event))
      .onActionEnd((event: GestureEvent) => this.handleActionEnd(event))
      .onActionCancel(() => this.handleActionCancel());
  }

  protected handleActionStart(event: GestureEvent): void {
    log.showInfo(`handleActionStart: ${event?.axisVertical}`);
    this.resetOffsetX();
    this.startOffsetX = this.offsetX;
    this.lastOffsetX = this.offsetX;
    NotificationNormalVm.hideActionButtons(this.vmInjector.scene);
    log.showInfo(`Start swipe ${this.ntf?.hashCode}, startTranslateX: ${this.startOffsetX}`);
  }

  protected handleActionUpdate(event: GestureEvent): void {
    const offsetX = ResourceVm.instance.getXDirectionValue(event.offsetX);
    this.update(this.getRealOffsetX(offsetX), false);
    this.overRemoveThresholdVibration();
  }

  protected handleActionEnd(event: GestureEvent): void {
    log.info(`handleActionEnd:`, event);
    const offsetX = ResourceVm.instance.getXDirectionValue(event.offsetX);
    this.isLeftToRight = offsetX > 0;
    // 触发滑动删除
    if (event.axisVertical === 0 && event.velocity >= NotificationSwipeVm.SWIPE_SPEED && this.handleSwipeSpeed(event)) {
      return;
    }
    this.stop(this.getRealOffsetX(offsetX), event.velocity);
  }

  protected handleActionCancel(): void {
    log.info(`handleActionCancel:`);
    this.stop(0);
  }

  protected stop(offsetX: number, velocity?: number): void {
    log.showInfo(`Stop swipe ${this.ntf?.hashCode} offsetX: ${offsetX}, menuWidth: ${this.menuWidth}` +
      `, velocity:${velocity}`);
    this.needVibrate = true;
    if (this.isLeftToRight) {
      this.updateLeftToRight(offsetX, velocity);
    } else {
      this.updateRightToLeft(offsetX, 1, velocity);
    }
  }

  protected updateRightToLeft(offsetX: number, expandTranX: number = 1, velocity?: number): void {
    log.showInfo(`updateRightToLeft, offsetX: ${offsetX}, isRemoveAllowed: ${this.isRemoveAllowed()}`);
    if (-offsetX < (this.getRemoveOffsetXThreshold() + this.menuWidth)) {
      // 左滑小于临界值，展示删除和设置按钮打点
      this.reportSlipLeft(this.ntf)
    }
    let endOffsetX = 0;
    if (-offsetX >= (this.getRemoveOffsetXThreshold() + this.menuWidth) && this.isRemoveAllowed()) {
      // 左滑超过删除临界值，删除通知
      endOffsetX = -this.deleteOffset * expandTranX;
      this.remove(endOffsetX, this.getRemoveDuration(endOffsetX, offsetX, velocity));
      this.reportNtfSlipLeftRight()
      return;
    }
    // 菜单展开状态
    if (-this.startOffsetX >= this.menuWidth) {
      // 滑动位置小于菜单宽度则位置恢复，否则回到原来位置
      endOffsetX = -offsetX < this.menuWidth ? 0 : this.startOffsetX;
    } else {
      // 菜单收起状态
      if (offsetX <= -NotificationSwipeVm.SWIPE_LEFT_CRITICAL) {
        // 左滑超过菜单展开临界值，则滑到菜单宽度的位置
        endOffsetX = -this.menuWidth;
        AccessibilityVm.instance.sendEventByResource($r('app.string.cc_accessibility_str_ntf_swipe_left_text'),
          $r('app.string.cc_accessibility_str_ntf_collapse_tips'));
      }
    }
    this.update(endOffsetX, true);
  }


  /**
   * 左滑展示设置和删除按钮打点
   * @returns
   */
  private reportSlipLeft(ntf: NotificationBase): void {
    NotificationSysEventReporter.notificationSlipLeft({
      CREATOR_BUNDLE_NAME: ntf?.creatorBundleName,
      NOTIFICATION_SLOT_TYPE: ntf?.slotType,
      TIME_STAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      NOTIFICATION_ID: ntf?.id,
      NOTIFICATION_CONTROL_FLAGS: ntf?.controlConfig?.flags,
      BUNDLE_TYPE: ntf?.bundleType,
      TRACE_ID: ntf?.traceId
    });
  }

  protected updateLeftToRight(offsetX: number, velocity?: number): void {
    let endOffsetX = 0;
    // 非展开菜单状态且可删除，右滑超过临界值时删除，否则位置恢复
    if (offsetX >= NotificationSwipeVm.SWIPE_RIGHT_PERCENT * this.itemWidth && this.isRemoveAllowed() &&
      -this.startOffsetX <= this.menuWidth) {
      endOffsetX = this.deleteOffset;
      this.remove(endOffsetX, this.getRemoveDuration(endOffsetX, offsetX, velocity));
      this.reportNtfSlipLeftRight()
      return;
    } else {
      endOffsetX = 0;
      AccessibilityVm.instance.sendEventByResource($r('app.string.cc_accessibility_str_ntf_swipe_right_text'));
    }
    this.update(endOffsetX, true);
  }

  protected handleSwipeSpeed(event: GestureEvent): boolean {
    log.showInfo(`handleSwipeSpeed direction: ${this.isLeftToRight}` +
      `, isRemoveAllowed: ${this.isRemoveAllowed()}, speed: ${event.velocity}`);
    NotificationNormalVm.hideActionButtons(this.vmInjector.scene);
    if (!this.isRemoveAllowed()) {
      return false;
    }
    // 从左向右滑，并且通知可清除，菜单未展开，直接清除 或者 从右往左滑，如果是菜单展开状态则删除
    const isRemove = (this.isLeftToRight && (-this.startOffsetX < this.menuWidth || this.menuWidth === 0)) ||
      (!this.isLeftToRight && this.startOffsetX <= -this.menuWidth);
    if (!isRemove) {
      return false;
    }
    const duration = Math.abs(this.itemWidth - Math.abs(this.offsetX)) / event.velocity * 1000;
    this.remove(this.isLeftToRight ? this.itemWidth : -this.itemWidth, duration);
    return true;
  }

  protected getRealOffsetX(swipeOffsetX: number): number {
    // 原始滑动偏移位置
    const originalOffsetX = swipeOffsetX + this.startOffsetX;
    // 计算后真实的偏移位置
    let realOffsetX = originalOffsetX;

    // 右滑
    if ((this.startOffsetX > -this.menuWidth && swipeOffsetX > 0) || this.itemWidth === 0) {
      // 能够清除无阻尼，不能清除加阻尼
      realOffsetX = this.isRemoveAllowed() ? originalOffsetX : originalOffsetX * NotificationSwipeVm.SWIPE_DAMP;
    } else if (this.itemWidth !== 0 && this.menuWidth > 0) {
      // 超出菜单偏移
      const overMenuOffsetX = Math.abs(originalOffsetX) - this.menuWidth;
      // 超出menu宽度的偏移量需要加阻尼，使用动态阻尼率
      if (overMenuOffsetX > 0) {
        const dynamicFollowRate =
          Math.exp(NotificationSwipeVm.DYNAMIC_FOLLOW_FACTOR * overMenuOffsetX *
          NotificationSwipeVm.SWIPE_LEFT_DELETE_PERCENT / this.itemWidth);
        realOffsetX = dynamicFollowRate * (originalOffsetX - this.lastOffsetX) + this.offsetX;
      }
    }
    this.lastOffsetX = originalOffsetX;
    return realOffsetX;
  }

  protected getKey(): string {
    return this.vmInjector.getId(`${TAG}_${this.ntf?.hashCode}`);
  }

  protected getRemoveOffsetXThreshold(): number {
    return DeviceInfoVm.instance.isLandscape ? 220 : 100;
  }

  protected isMoreBrief(): boolean {
    const isCollapsed = this.vmInjector.getNotificationMoreHeaderVm()?.isCollapsed ?? false;
    return this.ntf.isMoreNtf() && isCollapsed;
  }

  /**
   * 是否允许横滑删除
   * @returns
   */
  protected isRemoveAllowed(): boolean {
    if (this.isMoreBrief() || this.ntf.isLiveView() || this.ntf.isOngoing) {
      return false;
    }
    return this.ntf?.isRemoveAllowed;
  }

  /**
   * 超过删除通知阈值触发振动
   */
  protected overRemoveThresholdVibration(): void {
    // 横幅通知横滑不振动
    if (this.vmInjector.scene === SystemUIUseScene.BANNER) {
      return;
    }
    const isDeleteThreshold: boolean = -this.offsetX - this.menuWidth >= this.getRemoveOffsetXThreshold();
    if (isDeleteThreshold && this.needVibrate && this.isRemoveAllowed()) {
      this.needVibrate = false;
      VibratorUtil.startVibration('haptic.drag', 'physicalFeedback');
    } else if (!isDeleteThreshold) {
      this.needVibrate = true;
    }
  }

  public getSwipeAccessibilityDescription(): string {
    if (this.offsetX < 0) {
      return ResourceVm.instance.getString($r('app.string.cc_accessibility_str_ntf_collapse_tips'));
    }
    if (!this.ntf.wantAgent && !this.ntf.isNormalGroup()) {
      return ResourceVm.instance.getString($r('app.string.cc_accessibility_str_ntf_focused_action_tips'));
    }
    return [ResourceVm.instance.getString($r('app.string.cc_accessibility_str_click')),
      ResourceVm.instance.getString($r('app.string.cc_accessibility_str_ntf_focused_action_tips'))].join(' ');
  }

  protected getExpandDistance(): number {
    return 1;
  }

  /**
   * 通知列表中删除通知，获取下一个焦点id
   *
   * @param removeNtf 被删除的通知数据
   * @returns id 下一个焦点id
   */
  getRemoveAccessibilityId(removeNtf: NotificationBase): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    if (!this.listVm) {
      return '';
    }
    const isMore: boolean = removeNtf.isMoreNtf();
    const targetList = isMore ? this.listVm.moreNtfList : this.listVm.mainNtfList;
    const otherList = isMore ? this.listVm.mainNtfList : this.listVm.moreNtfList;
    const curIndex: number = targetList.findIndex((ntf) => {
      return ntf.hashCode === removeNtf.hashCode;
    });
    if (targetList.length === 1 && otherList.length > 0) {
      return isMore ? CLEAR_BUTTON_ID : EXTRA_NTF_TITLE_ID;
    }
    if (targetList.length === 1 && otherList.length <= 0) {
      return LIST_EMPTY_ID;
    }
    if (curIndex === targetList.length - 1) {
      return this.vmInjector.getCardVm(targetList[curIndex - 1]).getAccessibilityFocusId();
    }
    return this.vmInjector.getCardVm(targetList[curIndex + 1]).getAccessibilityFocusId();
  }

  /**
   * 删除子通知，获取下一个焦点id
   *
   * @returns id 下一个焦点id
   */
  private getInGroupRemoveAccessibilityId(): string {
    if (!AccessibilityVm.instance.isEnabled) {
      return '';
    }
    if (!this.listVm) {
      return '';
    }
    const groupNtf: NormalNotificationGroup | undefined = this.listVm.getGroupNtf(this.ntf);
    if (!groupNtf) {
      return '';
    }
    const children: NormalNotification[] = groupNtf.children;
    const curIndex: number = children.findIndex((ntf) => {
      return ntf.hashCode === this.ntf.hashCode;
    });
    if (children.length === 1) {
      // 组通知被删除，聚焦通知列表中下一条通知
      return this.getRemoveAccessibilityId(groupNtf);
    }
    if (curIndex === children.length - 1) {
      // 最后一条子通知，聚焦前一条子通知
      return this.vmInjector.getCardVm(children[curIndex - 1]).getAccessibilityFocusId();
    }
    // 非最后一条子通知，聚焦后一条子通知
    return this.vmInjector.getCardVm(children[curIndex + 1]).getAccessibilityFocusId();
  }

  private getRemoveDuration(endOffsetX: number, offsetX: number, velocity?: number): number {
    if (velocity && velocity >= NotificationSwipeVm.SWIPE_SPEED) {
      return Math.abs(endOffsetX - offsetX) / velocity * 1000;
    }
    return Math.abs(endOffsetX - offsetX);
  }
}