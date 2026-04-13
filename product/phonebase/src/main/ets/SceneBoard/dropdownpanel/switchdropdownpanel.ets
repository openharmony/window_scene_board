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

import {
  AppStorageUtil,
  DataProperty,
  DomainName,
  LogDomain,
  LogHelper,
  Trace,
  TraceUtil
} from '@ohos/basicutils';
import {
  DropDownEvent,
  DropDownStatus,
  EvtBus,
  HiDfxEventUtil,
  HiSysDataShowHide,
  PluginCardChangeEvent,
  TargetChangeState,
  TargetPanel,
  HiSysEventUtil
} from '@ohos/frameworkwrapper';
import { DropDownPanelManager, DropDownPanelConstants, StatusBarType } from '@ohos/systemuicommon/Index';
import { NtfListScrollController } from '@ohos/notificationcomponent/src/main/ets/controller/NtfListScrollController';
import curves from '@ohos.curves';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import Controller from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterController';
import { PrivacySensorViewModel } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/viewModel/PrivacySensorViewModel';
import { ScreenLockAdapter, statusBarMaskManager } from '@ohos/systemuicommon';
import { StatusBarManager } from '@ohos/systemuicommon/src/main/ets/statusbar/manager/StatusBarManager';
import {
  DropdownPanelChangeFinishedEvent
} from '@ohos/notificationcomponent/src/main/ets/common/event/NotificationEvent';
import { systemUIWorkerManager } from '@ohos/systemuicommon/newTsIndex';
import { EnvVm } from '@ohos/systemuicommon/newIndex';
import {
  NotificationPanelVmInjectorFactory
} from '@ohos/notificationcomponent/src/main/ets/viewmodel/NotificationPanelVmInjectorFactory';

const TAG = 'DropdownPanel-Switchdropdownpanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const DISTANCE_DROP_HORIZONTAL_MIN = 200;
const FLING_TARGET_DISMISS_ANIM_CURVE = curves.cubicBezierCurve(0.2, 0, 0.2, 1);
const PANEL_TRANSITION_ANIM_CURVE = FLING_TARGET_DISMISS_ANIM_CURVE;
const FAST_SPEED = -500;

/**
 * 双中心切换动效处理公共组件
 */
@Component
export default struct SwitchDropdownPanel {
  @StorageLink('dropDownEvent')
  @Watch('onDropdownChanged')
  dropDownEvent: DropDownEvent = DropDownPanelManager.getDropDownEvent();
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false;
  @Link contentOpacity: number;
  @Link contentScale: number;
  @Link contentTransX: number;
  @Link contentTransY: number;
  @Link contentZIndex: number;
  private progress: number = 0;
  private currentPanel: TargetPanel = TargetPanel.NONE;
  private lastTargetChanged: TargetChangeState = TargetChangeState.NONE;
  private listScroller: NtfListScrollController | undefined = undefined;
  private isHorizontalStart: boolean = false;
  private lastY: number = 0;
  private maxY: number = 0;
  private isInOpacityAnim: boolean = false;
  private isFlingAnimPlaying: boolean = false;
  private isVerticalSwitchBacked: boolean = false; // 一次交替下拉过程中是否已经反悔回到过原面板
  @Prop horizontalDropPanelPosition: number;

  aboutToAppear() {
    log.showInfo(`aboutToAppear Start`);
    DropDownPanelManager.switchDropdownPanelMap.set(this.currentPanel, this);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear`);
    DropDownPanelManager.switchDropdownPanelMap.delete(this.currentPanel);
  }

  /**
   * 下拉事件，切换双中心
   */
  onDropdownChanged() {
    // 通知切控制时需要更新亮度条值与隐私指示器
    if (this.isChangeToControl()) {
      PrivacySensorViewModel.getInstance().initData();
      Controller.updateUIFromCache();
      // 横划时头等舱触发订阅
      let requestEvent = PluginCardChangeEvent.getInstance(PluginCardChangeEvent.PLUGIN_CARD_SHOW);
      EvtBus.post(PluginCardChangeEvent, requestEvent);
    }
    if (this.dropDownEvent.target === TargetPanel.NONE) {
      this.contentTransX = 0;
      this.progress = 0;
      return;
    }
    // 双中心互切场景的节点组缓存生效
    this.isMarkingRenderGroup = true;
    this.handleVerticalSwitch();
    this.handleHorizontalSwitch();
    if (this.dropDownEvent.target === this.currentPanel) {
      this.handleVerticalDropdown();
      this.contentZIndex = 2;
      this.progress = this.dropDownEvent.progress;
    }

    if (this.isSwitchToControlCenterPanelAndHide()) {
      this.contentOpacity = 0;
      this.contentTransY = -60;
    }

    if (this.dropDownEvent.target == TargetPanel.CONTROL_CENTER_PANEL &&
      this.currentPanel === TargetPanel.NOTIFICATION_PANEL) {
      // 切换到控制中心时，组通知需要收起
      AppStorageUtil.setOrCreate('contract', true, new DataProperty(true, false));
    }
    this.lastTargetChanged = this.dropDownEvent.targetChanged;
  }

  /**
   * 判断是否是从通知中心切换到控制中心并收起面板
   */
  private isSwitchToControlCenterPanelAndHide(): boolean {
    return this.dropDownEvent.target === TargetPanel.CONTROL_CENTER_PANEL &&
      this.currentPanel === TargetPanel.NOTIFICATION_PANEL && // 是否从通知中心切换到控制中心
      this.progress === 1 && this.dropDownEvent.progress < 1; // 是否收起面板
  }

  /**
   * 是否通知切向控制
   */
  private isChangeToControl(): boolean {
    if (this.currentPanel === TargetPanel.NOTIFICATION_PANEL) {
      return false;
    }
    if (this.dropDownEvent.targetChanged !== TargetChangeState.HORIZONTAL &&
      this.dropDownEvent.targetChanged !== TargetChangeState.PRE_VERTICAL) {
      return false;
    }
    if (this.lastTargetChanged === TargetChangeState.NONE &&
      this.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL) {
      return true;
    }
    return false;
  }

  /**
   * 处理单中心下拉出现消失场景
   */
  private handleVerticalDropdown(): void {
    if (this.dropDownEvent.targetChanged === TargetChangeState.VERTICAL_FLING_SWITCH) {
      log.showInfo(`handleVerticalDropdown so ${this.dropDownEvent.targetChanged} skip.`);
      return;
    }
    if (this.isChangeToShow()) {
      this.handleVerticalChangeToShow();
      return;
    }

    if (this.isChangeToHide()) {
      this.handelVerticalChangeToHide();
    }
  }

  private handleVerticalChangeToShow() {
    log.showInfo(`handleVerticalChangeToShow. panel: ${this.currentPanel}`);
    if (this.dropDownEvent.targetChanged !== TargetChangeState.HORIZONTAL) {
      this.animatePanelOpacity(true, 'handleVerticalChangeToShow'); // 到达展开阈值，面板出现动效
      setTimeout(() => {
        StatusBarManager.getInstance()?.setStatusBarType(StatusBarType.TYPE_MAIN_PHONE_DROPDOWN);
      }, DropDownPanelConstants.NOTIFICATION_TIME_VIEW_SHOW_DELAY);
    }
  }

  private handelVerticalChangeToHide() {
    log.showInfo(`handelVerticalChangeToHide panel: ${this.currentPanel}`);
    if (this.currentPanel === TargetPanel.NOTIFICATION_PANEL) {
      this.animatePanelOpacity(false, 'handelVerticalChangeToHide'); // 到达收起阈值，面板消失动效
      // 降负载优化：面板开始收起时，关闭一键删除按钮背景实时模糊
      NotificationPanelVmInjectorFactory.get().getClearButtonVm?.()?.enableBackgroundEffect(false);
      log.showInfo('disable clear button backgroundEffect');
    }
    setTimeout(() => {
      const isLock = EnvVm.instance.isLockAndNotEditor();
      StatusBarManager.getInstance()?.setStatusBarType(
        isLock ? StatusBarType.TYPE_MAIN_PHONE_KEYGUARD : StatusBarType.TYPE_MAIN_PHONE_LAUNCHER,
        !isLock
      );
    }, DropDownPanelConstants.NOTIFICATION_TIME_VIEW_SHOW_DELAY);
  }

  private isChangeToShow(): boolean {
    return this.progress < 1 && this.dropDownEvent.progress === 1;
  }

  private isChangeToHide(): boolean {
    return this.progress === 1 && this.dropDownEvent.progress < 1;
  }

  /**
   * 处理单/双中心横滑场景
   */
  private handleHorizontalSwitch(): void {
    // 横坐标偏移，通知中心在左为负，控制中心在右为正
    let value = this.currentPanel === TargetPanel.CONTROL_CENTER_PANEL ? 1 : -1;
    if (this.isHorizontalRelease()) {
      this.handleHorizontalRelease(value); // 横滑离手动效
    } else if (this.dropDownEvent.targetChanged === TargetChangeState.HORIZONTAL_REVERSES) {
      this.handleHorizontalReverse(value); // 单中心反向横滑跟手动效
    } else if (this.dropDownEvent.targetChanged === TargetChangeState.HORIZONTAL) {
      this.contentTransY = 0;
      log.showInfo(`handleHorizontalSwitch targetPanel=${this.dropDownEvent.target} currentPanel=${this.currentPanel}`);
      if (this.dropDownEvent.target != this.currentPanel) {
        this.handleHorizontalTargetTouching(value); // 双中心横滑切换-目标面板跟手动效
      } else {
        this.handleHorizontalSourceTouching(value); // 双中心横滑切换-原面板跟手动效
      }
    } else if (this.isHorizontalStart) {
      this.isHorizontalStart = false; // 非横滑场景，重置横滑相关变量
    } else if (this.currentPanel === TargetPanel.NOTIFICATION_PANEL &&
      this.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL) {
      // 纵向拉出通知中心后兜底终重置面板横向偏移
      this.contentTransX = 0;
    }

    this.initHorizontalTargetPanelTransX(value)
  }

  /**
   * 横滑场景，初始化待呼出面板的横坐标位移，避免开始滑动第一帧时，目标面板contentTransX为0导致闪动。
   * 当前跨线程双中心横滑切换呼出控制中心时需要处理。
   */
  private initHorizontalTargetPanelTransX(value: number) {
    if (!systemUIWorkerManager.isEnabled()) {
      return;
    }

    // 是否是通知面板横滑前的状态
    const isBeforeHorizontalState = this.dropDownEvent.targetChanged === TargetChangeState.NONE &&
      this.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL &&
      this.dropDownEvent.target != this.currentPanel &&
      this.contentOpacity === 1;

    // 横滑前，如果待呼出面板横向位移为0，需要给其设置初始位移，避免闪动。
    if (isBeforeHorizontalState && this.contentTransX === 0) {
      this.contentTransX = this.horizontalDropPanelPosition * value;
    }
  }

  /**
   * 双中心横滑切换-原面板的跟手动效
   */
  private handleHorizontalSourceTouching(value: number): void {
    if (this.dropDownEvent.targetChangedMove * value > 0) {
      let diffMove: number = this.dropDownEvent.targetChangedMove;
      diffMove = Math.abs(diffMove) / DISTANCE_DROP_HORIZONTAL_MIN;
      diffMove = Math.min(diffMove, 1)
      this.contentOpacity = 1 - diffMove;
      this.contentScale = 1 - diffMove / 10;
      this.contentTransX = 0;
    }
  }

  /**
   * 双中心横滑切换-目标面板的跟手动效
   */
  private handleHorizontalTargetTouching(value: number): void {
    this.contentOpacity = 1;
    this.contentScale = 1;
    if (this.dropDownEvent.targetChangedMove) {
      // 避免横滑过快时，handleHorizontalRelease中onfinish执行晚于该处，targetChangedMove=0导致闪烁
      this.contentTransX = this.horizontalDropPanelPosition * value + this.dropDownEvent.targetChangedMove;
    }
    this.contentZIndex = 3;
    if (!this.isHorizontalStart) {
      this.isHorizontalStart = true;
      this.listScroller?.followTransItemAnim(true, false);
    }
  }

  /**
   * 单中心反向横滑-跟手动效
   */
  private handleHorizontalReverse(value: number): void {
    if (this.dropDownEvent.target != this.currentPanel) {
      return;
    }
    this.contentOpacity = 1;
    this.contentScale = 1;
    this.contentTransX = -(-80 * Math.exp(-0.0125 * Math.abs(this.dropDownEvent.targetChangedMove)) + 80) * value;
  }

  /**
   * 双中心横滑切换、单中心反向横滑-面板的离手动效
   */
  private handleHorizontalRelease(value: number): void {
    if (this.dropDownEvent.target != this.currentPanel) {
      return;
    }

    // 找到需要被滑出的面板
    const target = this.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL
      ? TargetPanel.CONTROL_CENTER_PANEL
      : TargetPanel.NOTIFICATION_PANEL;

    animateTo({
      curve: curves.springCurve(this.dropDownEvent.speedX / 5, 1, 228, 28),
      delay: 0, // 动画延迟
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: () => {
        log.showInfo(`horizontal onFinish targetChanged=${this.dropDownEvent.targetChanged}`);
        this.isMarkingRenderGroup = false;

        if (this.dropDownEvent.targetChanged === TargetChangeState.HORIZONTAL_UP_BACK) {
          this.dropDownEvent.targetChanged = TargetChangeState.NONE;
        }
        if (this.isHorizontalStart) {
          performanceMonitor.end('INTO_CC_FROM_NC');
          TraceUtil.endTrace(DomainName.NC, HiSysEventUtil.INTO_CC_FROM_NC, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
          performanceMonitor.end('INTO_NC_FROM_CC');
        }
      }
    }, () => {
      this.contentTransX = 0;
      this.contentOpacity = 1;
      this.contentScale = 1;
      this.dropDownEvent.targetChangedMove = 0;

      const targetPanel = DropDownPanelManager.switchDropdownPanelMap.get(target);
      if (targetPanel) {
        targetPanel.contentTransX = -targetPanel.horizontalDropPanelPosition * value;
        targetPanel.contentZIndex = 1;
      }
    });
  }

  /**
   * 判断是否为横滑离手
   */
  private isHorizontalRelease(): boolean {
    return (this.lastTargetChanged === TargetChangeState.HORIZONTAL ||
      this.lastTargetChanged === TargetChangeState.HORIZONTAL_REVERSES) &&
      (this.dropDownEvent.targetChanged === TargetChangeState.HORIZONTAL_UP_BACK ||
        this.dropDownEvent.targetChanged === TargetChangeState.NONE);
  }

  /**
   * 处理双中心交替下拉场景
   */
  private handleVerticalSwitch(): void {
    if (this.isVerticalSwitchFinished()) {
      this.isVerticalSwitchBacked = false;
      this.maxY = -1;
    }

    if (this.dropDownEvent.targetChanged === TargetChangeState.VERTICAL_FLING) {
      this.handleVerticalFling(); // 原面板与目标面板的抛滑离手动效
      return;
    }

    if (this.isVerticalRelease()) {
      this.updatePanelWithAnim(true); // 交替下拉非抛滑松手后，恢复原面板/目标面板的透明度、缩放、位移
      return;
    }

    this.handleVerticalOverThreshold(); // 处理跟手越过距离阈值
    if (this.dropDownEvent.target != this.currentPanel) {
      return;
    }

    if (this.dropDownEvent.targetChanged === TargetChangeState.VERTICAL && !this.isInOpacityAnim) {
      // 当已经进入opacity动画时，不需要再判断该方法逻辑，避免动画冗余
      this.handleVerticalTargetTouching();
      return;
    }

    if (this.dropDownEvent.targetChanged === TargetChangeState.PRE_VERTICAL) {
      this.handleVerticalSourceTouching();
    }

    this.lastY = this.dropDownEvent.moveY;
  }

  /**
   * 判断交替下拉是否完成
   */
  private isVerticalSwitchFinished(): boolean {
    return this.dropDownEvent.targetChanged === TargetChangeState.NONE &&
      (this.lastTargetChanged === TargetChangeState.PRE_VERTICAL ||
        this.lastTargetChanged === TargetChangeState.VERTICAL ||
        this.lastTargetChanged === TargetChangeState.VERTICAL_FLING ||
        this.lastTargetChanged === TargetChangeState.VERTICAL_FLING_SWITCH);
  }

  /**
   * 是否从控制中心交替下拉到通知中心
   */
  private isVerticalSwitchToNotification(): boolean {
    let targetChanged = this.dropDownEvent.targetChanged;
    let source = this.dropDownEvent.source;
    let isSwitchStart = this.lastTargetChanged === TargetChangeState.NONE &&
      (targetChanged === TargetChangeState.PRE_VERTICAL || targetChanged === TargetChangeState.VERTICAL);
    let isNotification = (source !== TargetPanel.NOTIFICATION_PANEL &&
      this.currentPanel === TargetPanel.NOTIFICATION_PANEL);
    return isSwitchStart && isNotification;
  }

  private isVerticalToNotification(): boolean {
    let source = this.dropDownEvent.source;
    let isSwitchStart = this.lastTargetChanged === TargetChangeState.NONE;
    let isNotification = source !== TargetPanel.NOTIFICATION_PANEL;
    return isSwitchStart && isNotification;
  }

  /**
   * 判断是否在交替下拉非抛滑反悔达到距离阈值前松手
   */
  private isVerticalRelease(): boolean {
    return ((this.lastTargetChanged === TargetChangeState.VERTICAL ||
      this.lastTargetChanged === TargetChangeState.PRE_VERTICAL) &&
      this.dropDownEvent.targetChanged === TargetChangeState.NONE &&
      this.dropDownEvent.target === this.currentPanel);
  }

  /**
   * 双中心交替下拉-原面板跟手动效
   */
  private handleVerticalSourceTouching(): void {
    if (this.dropDownEvent.targetChangedMove <= 1 && this.dropDownEvent.targetChangedMove > 0) {
      this.contentTransX = 0;
      this.contentOpacity = 1 - this.dropDownEvent.targetChangedMove;
      this.contentScale = 1 - this.dropDownEvent.targetChangedMove / 20;
    }
  }

  /**
   * 双中心交替下拉-跟手下拉或上滑越过阈值，处理面板显隐
   */
  private handleVerticalOverThreshold(): void {
    // 刚上滑小于阈值
    if (this.dropDownEvent.targetChanged === TargetChangeState.PRE_VERTICAL &&
      this.lastTargetChanged === TargetChangeState.VERTICAL) {
      if (this.dropDownEvent.target !== this.currentPanel) {
        log.showDebug(`Vertical switch back to source panel, has switch backed=${this.isVerticalSwitchBacked}.`);
        this.updatePanel(false); // 隐藏目标面板
        this.isVerticalSwitchBacked = true;
      }
    }

    // 刚下滑超过阈值
    if ((this.dropDownEvent.targetChanged === TargetChangeState.VERTICAL ||
      this.dropDownEvent.targetChanged === TargetChangeState.VERTICAL_FLING_SWITCH) &&
      this.lastTargetChanged === TargetChangeState.PRE_VERTICAL) {
      if (this.dropDownEvent.target !== this.currentPanel) {
        this.updatePanel(false); // 隐藏原面板
      } else if (!this.isVerticalSwitchBacked) {
        log.showInfo(`Vertical switch to target panel frist time with enter anim.`);
        this.animatePanelOpacity(true, 'handleVerticalOverThreshold'); // 显示目标面板，并触发通知中心的入场动效
      }
    }
  }

  /**
   * 双中心交替下拉-目标面板跟手动效
   */
  private handleVerticalTargetTouching(): void {
    let moveY = this.dropDownEvent.moveY;
    if (moveY < 0) {
      return;
    }
    if (this.lastY <= moveY && moveY > this.maxY) {
      this.maxY = moveY;
    }
    let radio = moveY >= this.maxY ? 1 : moveY / this.maxY;
    if (radio === 1) {
      // 某些手势dropdownEvent的targetChange===2会进入该层，导致下拉无动效
      this.animatePanelOpacity(true, 'handleVerticalTargetTouching')
      return;
    }
    this.contentOpacity = radio;
    this.contentScale = radio * 0.05 + 0.95;
    this.lastY = moveY;
  }

  /**
   * 双中心交替下拉-处理抛滑反悔场景
   */
  private handleVerticalFling(): void {
    if (this.isFlingAnimPlaying) {
      return;
    }

    let source = this.dropDownEvent.source;
    // 目标面板消失动效
    if (source !== this.currentPanel && DropDownPanelManager.getVerticalBackStatus()) {
      this.isFlingAnimPlaying = true;
      this.handleVerticalTargetFling();
    }

    // 原面板等目标面板动效完成后才开始出现动效
    if (source === this.currentPanel && !DropDownPanelManager.getVerticalBackStatus()) {
      this.isFlingAnimPlaying = true;
      this.handleVerticalSourceFling();
    }
    // 抛滑反悔场景，再设置一下通知中心显示状态
    this.listScroller?.followTransItemAnim(true, false)
  }

  /**
   * 隐藏面板
   */
  public hidePanel(): void {
    this.updatePanel(false);
  }

  public onPanelVerticalFlingSwitchShow(): Promise<void> {
    return new Promise((resolve) => {
      this.animatePanelOpacity(true, 'onPanelVerticalFlingSwitchShow', () => {
        this.dropDownEvent.targetChanged = TargetChangeState.NONE;
        log.showInfo(`animatePanelOpacity finish ${this.currentPanel}`);
        resolve();
      });
    });
  }

  public onPanelVerticalFlingSwitchDismiss(): Promise<void> {
    return new Promise((resolve) => {
      this.handleVerticalSourceFlingDismiss(() => {
        log.showInfo(`handleVerticalSourceFlingDismiss finish ${this.currentPanel}`);
        resolve();
      });
    });
  }

  /**
   * 双中心交替下拉-目标面板抛滑消失动效
   */
  private handleVerticalTargetFling(): void {
    const traceName: string = 'VerticalTargetFlingAnim';
    TraceUtil.startTrace(DomainName.SYS_UI, traceName);
    animateTo({
      duration: 100, // 动画时长
      curve: FLING_TARGET_DISMISS_ANIM_CURVE, // 动画曲线
      delay: 0, // 动画延迟
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: () => {
        TraceUtil.endTrace(DomainName.SYS_UI, traceName);
        this.isFlingAnimPlaying = false;
        DropDownPanelManager.setVerticalBackStatus(false); // 目标面板已播放完动效，触发原面板开始动效
        DropDownPanelManager.setTargetPanel(this.dropDownEvent.source);
      }
    }, () => {
      this.updatePanel(false);
      this.dropDownEvent.moveY = 0;
      this.dropDownEvent.translateY = 0;
    })
  }

  /**
   * 双中心交替下拉-原面板抛滑出现动效
   */
  private handleVerticalSourceFling(): void {
    let speedY = this.dropDownEvent.speedY;
    let limit = DropDownPanelManager.getVerticalFlingSpeedLimit();
    let normalized = Math.abs(speedY) >= Math.abs(limit) ? 1 : Math.abs(speedY / limit);
    const traceName: string = 'VerticalSourceFlingAnim';
    TraceUtil.startTrace(DomainName.SYS_UI, traceName);
    animateTo({
      curve: curves.interpolatingSpring(normalized, 0.5, 410, 37), // 继承离手速度
      onFinish: () => {
        TraceUtil.endTrace(DomainName.SYS_UI, traceName);
        this.dropDownEvent.speedY = 0;
        this.dropDownEvent.targetChanged = TargetChangeState.NONE;
        this.isFlingAnimPlaying = false;
      }
    }, () => {
      this.updatePanel(true);
    })
  }

  /**
   * 双中心交替下拉-源标面板抛滑消失动效
   *
   * @param finishCallback 动效完成回调
   */
  private handleVerticalSourceFlingDismiss(finishCallback: () => void = () => {}): void {
    const traceName: string = 'VerticalSourceFlingDismissAnim';
    TraceUtil.startTrace(DomainName.SYS_UI, traceName);
    animateTo({
      duration: 100, // 动画时长
      curve: FLING_TARGET_DISMISS_ANIM_CURVE, // 动画曲线
      delay: 0, // 动画延迟
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: () => {
        TraceUtil.endTrace(DomainName.SYS_UI, traceName);
        finishCallback();
      }
    }, () => {
      this.updatePanel(false);
      this.dropDownEvent.moveY = 0;
      this.dropDownEvent.translateY = 0;
    })
  }

  /**
   * 竖滑场景面板无动效显隐
   */
  private updatePanel(isShow: boolean): void {
    this.contentTransX = 0;
    this.contentTransY = 0;
    this.contentOpacity = isShow ? 1 : 0;
    this.contentScale = isShow ? 1 : 0.95;
  }

  /**
   * 竖滑场景面板有动效显隐
   */
  private updatePanelWithAnim(isShow: boolean): void {
    const traceName: string = 'updatePanelWithAnim';
    TraceUtil.startTrace(DomainName.SYS_UI, traceName);
    animateTo({
      duration: 100, // 动画时长
      curve: PANEL_TRANSITION_ANIM_CURVE, // 动画曲线
      delay: 0, // 动画延迟
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: () => {
        TraceUtil.endTrace(DomainName.SYS_UI, traceName);
      }
    }, () => {
      this.contentTransX = 0;
      this.contentTransY = 0;
      this.contentOpacity = isShow ? 1 : 0;
      this.contentScale = isShow ? 1 : 0.95;
    })
  }

  /**
   * 内容透明度变化动画
   *
   * @param isShow 面板显示or隐藏
   */
  private animatePanelOpacity(isShow: boolean, info?:string, callback: () => void = () => {}): void {
    // 显示列表时，列表滑动到顶部
    if (isShow) {
      this.listScroller?.scrollToFirst();
      this.contentTransX = 0;
      this.contentTransY = 0;
    }
    let source = this.dropDownEvent.source;
    setTimeout(() => {
      if (isShow) {
        if (this.currentPanel === TargetPanel.NOTIFICATION_PANEL) {
          performanceMonitor.begin('INTO_NC_ANI', performanceMonitor.ActionType.FIRST_MOVE);
        } else if (this.currentPanel === TargetPanel.CONTROL_CENTER_PANEL &&
          source === TargetPanel.NOTIFICATION_PANEL) {
          performanceMonitor.begin('INTO_CC_ANI', performanceMonitor.ActionType.FIRST_MOVE);
        }
      }
      this.listScroller?.followTransItemAnim(isShow, true);
    }, 0);
    const traceName: string = `PANEL_OPACITY_${isShow}_${info}`;
    TraceUtil.startTrace(DomainName.SYS_UI, traceName);
    this.isInOpacityAnim = true;
    animateTo({
      duration: !isShow && this.dropDownEvent.speedY < FAST_SPEED ?
      DropDownPanelConstants.PANEL_OPACITY_DURATION_WITH_FAST_SPEED :
      DropDownPanelConstants.PANEL_OPACITY_DURATION, // 动画时长
      curve: isShow ? Curve.EaseIn : Curve.EaseOut, // 动画曲线
      delay: 0, // 动画延迟
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: () => {
        TraceUtil.endTrace(DomainName.SYS_UI, traceName);
        this.isInOpacityAnim = false;
        callback();
        this.handAnimateFinish(isShow, source);
      }
    }, () => {
      AppStorage.setOrCreate('isPanelAnimationDone', false);
      this.contentOpacity = isShow ? 1 : 0;
      if (isShow) {
        this.contentOpacity = 1;
        this.contentScale = 1;
      } else {
        this.contentOpacity = 0;
        this.contentTransY = -60;
      }
    })
  }

  private handAnimateFinish(isShow: boolean, source: TargetPanel) {
    log.showInfo(`opacity anim is done. isShow:${isShow} target:${this.dropDownEvent.target}`)
    AppStorage.setOrCreate('isPanelAnimationDone', true);
    if (isShow) {
      if (this.contentOpacity !== 1 || this.contentScale !== 1) {
        HiDfxEventUtil.reportShowDropdownPanelAbnormal();
      }
      if (this.currentPanel === TargetPanel.CONTROL_CENTER_PANEL && source === TargetPanel.NOTIFICATION_PANEL) {
        performanceMonitor.end('INTO_CC_ANI');
      } else if (this.currentPanel === TargetPanel.NOTIFICATION_PANEL) {
        performanceMonitor.end('INTO_NC_ANI');
      }
    } else {
      if (this.currentPanel === TargetPanel.CONTROL_CENTER_PANEL) {
        HiDfxEventUtil.reportControlCenterShowHide(HiSysDataShowHide.HIDE);
      } else if (this.currentPanel === TargetPanel.NOTIFICATION_PANEL) {
        this.contentTransY = 0;
        // 面板收起完成打开一键删除按钮实时模糊
        NotificationPanelVmInjectorFactory.get().getClearButtonVm?.()?.enableBackgroundEffect(true);
        log.showInfo('enable clear button backgroundEffect');
        HiDfxEventUtil.reportNotificationPanelShowHide(HiSysDataShowHide.HIDE);
      }
      // ContentScale may not be 0.95 when drop down from launcher for a single center
      if (this.contentOpacity !== 0) {
        HiDfxEventUtil.reportHideDropdownPanelAbnormal();
      }
    }
    EvtBus.post(DropdownPanelChangeFinishedEvent,
      new DropdownPanelChangeFinishedEvent(isShow, this.currentPanel, this.dropDownEvent.target));
  }

  build() {
  }
}