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

import { UIUtils } from '@ohos.arkui.StateManagement';
import { Singleton } from '../utils/Singleton';
import DropDownPanelManager, { DropDownPanelConstants } from '../manager/DropDownPanelManager';
import { systemUIWorkerManager } from '../manager/SystemUIWorkerManager';
import { AnimateToScheduleUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { DropDownEvent,
  DropDownPanelManagerWrapper,
  TargetChangeState, TargetPanel } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ObjectCopyUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { Trace as TracePoint } from '@ohos/basicutils';
import { StatusBarType } from '../plugin/info/StatusBarType';
import { DeviceInfoVm } from './DeviceInfoVm';
import { process } from '@kit.ArkTS';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'DropdownVm');

/**
 * 下拉面板ViewModel
 */
@ObservedV2
export class DropdownVm {
  // instrument ignore next
  @Singleton.decorate()
  public static get instance(): DropdownVm { return new DropdownVm(); }

  /**
   * 纵向滑动最小触发距离
   */
  public static readonly VERTICAL_PAN_DISTANCE = 5;
  /**
   * 下拉事件对象
   */
  @Trace public readonly dropdownEvent = UIUtils.makeObserved(new DropDownEvent());
  /**
   * 是否可以收起下拉面板
   */
  @Trace public canCollapsePanel = true;

  @Trace public statusBarType: number = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;

  /**
   * 只根据下拉态判断状态栏显示规格
   */
  @Trace public isDropdownOnly: boolean = false;
  /**
   * 下拉面板是否在显示中，在缓慢下拉场景，有可能面板已经拉出，但是状态栏还未切换至下拉状态，此时不算下拉完成，建议通过isDropDown判断
   * @returns
   */
  @Computed public get isShow(): boolean {
    return this.dropdownEvent.target !== TargetPanel.NONE;
  }

  /**
   * 下拉面板是否显示完成。状态栏变为TYPE_MAIN_PHONE_DROPDOWN后才算真正下拉完成。要监听下拉面板是否显示，建议使用该变量判断
   * @returns
   */
  @Computed public get isDropDown(): boolean {
    return this.statusBarType === StatusBarType.TYPE_MAIN_PHONE_DROPDOWN;
  }

  /**
   * 下拉面板类型
   * @returns
   */
  @Computed public get dropDownType(): TargetPanel {
    return this.dropdownEvent.target;
  }

  /**
   * 状态栏显示规格切换不仅依赖状态栏类型，回依据进度合类型综合判断。
   * 非下拉状态 进度大于目标值 时为True,下拉状态下不考虑进度，均为True。
   * @returns
   */
  @Computed public get checkShowDropDownType(): boolean {
    if (this.isDropdownOnly) {
      return this.isDropDown;
    } else {
      if (this.isDropDown) {
        return true;
      }
      return this.dropdownEvent.progress > 0.25;
    }
  }

  /**
   * 最后一次下拉的时间
   */
  public lastDropdownTime = 0;
  /**
   * 是否更新下拉跟手参数
   */
  @Trace public isNeedUpdateMoveY = true;
  /**
   * 最近一次的下拉面板类型
   */
  private lastTarget: TargetPanel = TargetPanel.NONE;
  /**
   * 通知设置弹窗是否关闭
   */
  @Trace public ntfSettingsDialogClose: boolean = true;

  /**
   * 一镜到底动效中
   */
  @Trace
  public oneMirrorAnimating: boolean = false;

  /**
   * 通知中心effectComponent组件高度用于刷新effectComponent
   */
  @Trace
  public effectComponentHeight: string = '100%';

  /**
   * 通知面板内容容器组件可见性属性
   */
  @Trace
  public visibility: Visibility = Visibility.Visible;

  /**
   * 是否从控制中心横滑切换到通知中心
   */
  public isFromCCToNC: boolean = false;

  public constructor() {
  }

  public init(): void {
    try {
      const dropdownEventProxy = DropDownPanelManagerWrapper.getInstance().dropDownEventProxy;
      // 从dropdownEventProxy同步值到DropdownVm.dropdownEvent
      const keys = Object.keys(dropdownEventProxy.value);
      dropdownEventProxy.addWatcher(keys as (keyof DropDownEvent)[], () => {
        ObjectCopyUtil.simpleClone(dropdownEventProxy.value, this.dropdownEvent);
      });

      // 监听设备折合展开事件处理
      DeviceInfoVm.instance.emitter.on('foldStatusChange', this.onFoldStatusChanged);

      log.showInfo('Init end');
    } catch (e) {
      log.error(`Init error:`, e);
    }
  }

  setDropdownOnly(isDropdownOnly: boolean): void {
    this.isDropdownOnly = isDropdownOnly;
  }

  public updateStatusBarType(statusBarType: number): void {
    this.statusBarType = statusBarType;
  }

  /**
   * 隐藏下拉面板
   * @param isAnim 是否需要动画
   */
  public hidePanel(isAnim: boolean): void {
    DropDownPanelManager.postRequestHideWindow(isAnim);
  }

  /**
   * 设置下拉面板内容组件的可见性
   * @param visibility
   */
  public setVisibility(visibility: Visibility): void {
    this.visibility = visibility;
  }

  /**
   * 设置是否更新下拉跟手参数
   * @param isNeedUpdateMoveY
   */
  public setIsNeedUpdateMoveY(isNeedUpdateMoveY: boolean): void {
    log.showInfo(`setIsNeedUpdateMoveY: ${isNeedUpdateMoveY}`);
    this.isNeedUpdateMoveY = isNeedUpdateMoveY;
  }

  /**
   * 下拉面板纵向滑动，更新moveY
   * @param event 下拉事件
   */
  public onPanVertical = (event: GestureEvent): void => {
    if (!this.isNeedUpdateMoveY) {
      log.showInfo(`No need update moveY.`);
      return;
    }

    if (DropDownPanelManager.getDropDirection(event.offsetX, event.offsetY) !== TargetChangeState.VERTICAL) {
      log.showInfo(`onPanVertical, is not vertical`);
      this.dropdownEvent.moveY = 0;
      DropDownPanelManager.clearDropDirection();
      return;
    }

    // 上滑收起面板
    if (event.offsetY < DropDownPanelConstants.DISTANCE_FOLD_NOTIFICATION_DROPDOWN) {
      if (DropDownPanelManager.isPanelDismissing()) {
        log.showInfo(`Panel is dismissing.`)
        return;
      }
      DropDownPanelManager.animDelayToDismiss(0);
      this.dropdownEvent.moveY = event.offsetY;
    } else if (event.offsetY >= 0) {
      this.dropdownEvent.moveY = event.offsetY;
    }

    DropDownPanelManagerWrapper.getInstance().dropDownEventProxy.updateSilent(this.dropdownEvent);
  };

  /**
   * 结束纵向滑动
   */
  public onPanVerticalEnd = (event?: GestureEvent): void => {
    log.showInfo(`onPanVerticalEnd, offset is ${event?.offsetY}, panel is ${DropDownPanelManager.isPanelDismissing()}`);
    if (event && this.isFastUpSlide(event) && !DropDownPanelManager.isPanelDismissing()) {
      log.showInfo(`FastUpSlide notification panel start dismiss`);
      DropDownPanelManager.animDelayToDismiss(0);
      this.dropdownEvent.moveY = event.offsetY;
      return;
    }
    DropDownPanelManager.touchEndCheckAnim();
  };

  /**
   * 取消纵向滑动
   */
  public onPanVerticalCancel = (): void => {
    log.showInfo('onPanVerticalCancel');
    DropDownPanelManager.touchEndCheckAnim();
    DropDownPanelManager.clearDropDirection();
  };

  /**
   * 横滑开始
   */
  public onPanHorizontalStart = (event: GestureEvent): void => {
    DropDownPanelManager.onPanActionStart(event);
  };

  /**
   * 横滑过程
   */
  public onPanHorizontalUpdate = (event: GestureEvent): void => {
    DropDownPanelManager.onPanActionUpdate(event);
  };

  /**
   * 横滑结束
   */
  public onPanHorizontalEnd = (event: GestureEvent, isfromPanel?: boolean): void => {
    DropDownPanelManager.onPanActionEnd(event, isfromPanel);
  };

  /**
   * 下拉结束时，检测是否回弹动效
   */
  public touchEndCheckAnim = (): void => {
    DropDownPanelManager.touchEndCheckAnim();
  };

  /**
   * 点击面板顶部位置开始，双中心切换打点需要
   * @param positionX
   * @param positionY
   */
  public updateStartPosition(positionX: number, positionY: number): void {
    DropDownPanelManager.updateStartPosition(positionX, positionY);
  }

  /**
   * 点击面板顶部位置结束，双中心切换打点需要
   * @param positionX
   * @param positionY
   */
  public updateEndPosition(positionX: number, positionY: number): void {
    DropDownPanelManager.updateEndPosition(positionX, positionY);
  }

  @Computed
  public get onDropdownChange(): void {
    // 处理面板显示/隐藏状态改变
    this.dropDownPanelChange();

    return;
  }

  /**
   * 设备折合展开事件处理
   */
  private onFoldStatusChanged = (): void => {
    // 收起双中心将触发竖屏旋转, 设备开合过程中若嵌套屏幕旋转将可能导致状态栏显示异常
    // 使用setTimeout保证先执行完设备开合, 宏任务再执行双中心收起, 避免发生嵌套
    setTimeout(() => {
      log.showInfo(`onFoldStatusChanged hideWindowDirectly!`);
      DropDownPanelManager.hideWindowDirectly();
    });
  }

  /**
   * DropDownPanel变化回调
   * @param updateData
   */
  private dropDownPanelChange(): void {
    if (systemUIWorkerManager.isEnabled()) {
      if (this.isPanelChangeToShow()) {
        // 面板展开时
        // 启用worker高优先级
        TracePoint.start('systemUIWorkerRaisePriority');
        AnimateToScheduleUtils.raiseWorkerThreadPriority(process.tid, true);
      } else if (this.isPanelChangeToHide()) {
        // 面板收起时
        // 取消worker高优先级
        TracePoint.end('systemUIWorkerRaisePriority');
        AnimateToScheduleUtils.raiseWorkerThreadPriority(process.tid, false);
      }
    }
    this.isFromCCToNC = this.lastTarget === TargetPanel.CONTROL_CENTER_PANEL &&
      this.dropdownEvent.target === TargetPanel.NOTIFICATION_PANEL;
    // 记录最近一次显示的面板
    this.lastTarget = this.dropdownEvent.target
  }

  /**
   * 面板展开
   * @returns
   */
  private isPanelChangeToShow(): boolean {
    return this.lastTarget === TargetPanel.NONE &&
      this.dropdownEvent.target !== TargetPanel.NONE;
  }

  /**
   * 面板隐藏
   * @returns
   */
  private isPanelChangeToHide(): boolean {
    return this.lastTarget !== TargetPanel.NONE &&
      this.dropdownEvent.target === TargetPanel.NONE;
  }

  public checkMoveDown(): boolean {
    return DropDownPanelManager.checkMoveDown();
  }

  private isFastUpSlide(event: GestureEvent): boolean {
    const ret = Math.abs(event.offsetX) < Math.abs(event.offsetY) &&
      event.velocityY < DropDownPanelConstants.UP_SLIDE_SPEED_THRESHOLD;
    log.showInfo('IsFastUpSlide. (%{public}d, %{public}d), velocityY: %{public}d, ret: %{public}s',
      event.offsetX, event.offsetY, event.velocityY, ret);
    return ret;
  }
}