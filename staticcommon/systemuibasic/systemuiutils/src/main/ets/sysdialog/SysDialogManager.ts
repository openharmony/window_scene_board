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

import { SingletonHelper, CommonUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { viewMgrPolicy, ViewCallback } from '@ohos/frameworkwrapper';
import {
  OccludeKeygaurdScene,
  scbGestureManager,
  GestureEnableCaller,
  SCBEventId,
  SCBSceneSessionManager,
  SCBScreenSessionManager
} from '@ohos/windowscene';

import { baseStateMgr } from './BaseStateManager';
import { IState, StateType } from './BaseState';
import { OnStateChangeListener } from './StateListenerRegister';
import {
  BackPressPriority,
  OnBackPressListener,
  SysDialogPanelType,
  SysDialogState,
  SysDialogType
} from './SysDialogState';

const TAG = 'SysDialogManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const DIALOG_REGISTER_CALLBACK_RETRY_LIMIT: number = 3;


/**
 * 弹框面板状态监听
 */
class DialogViewCallback implements ViewCallback {
  /**
   * 目标弹框状态管理器
   */
  private dialogState?: SysDialogState;

  /**
   * 构造
   *
   * @param state 状态管理器
   */
  constructor(state?: SysDialogState) {
    this.dialogState = state;
  }

  /**
   * 聚焦回调
   */
  onGainFocus(): void {
    this.dialogState?.setFocused(true);
    sysDialogMgr.checkNavigationEnable();
  }

  /**
   * 失焦回调
   */
  onLoseFocus(): void {
    this.dialogState?.setFocused(false);
    sysDialogMgr.checkNavigationEnable();
  }
}

interface StatusBarGestureStatusCallback {
  onStatusBarEnabledChange(enable: boolean): void;
}

/**
 * 系统弹框面板统一管理
 */
class SysDialogManager {
  /**
   * 弹框状态管理集
   */
  private dialogStates: Map<SysDialogType, SysDialogState> = new Map([
    // 低层级弹框
    [SysDialogType.TYPE_DEFAULT, new SysDialogState(SysDialogType.TYPE_DEFAULT)],
    // 高层级弹框
    [SysDialogType.TYPE_UPPER, new SysDialogState(SysDialogType.TYPE_UPPER)]
  ]);
  // 是否支持左右手势
  private isSupportBackPressGesture: boolean = false;

  public setBackPressGestureState(isEnable: boolean): void {
    this.isSupportBackPressGesture = isEnable;
  }

  private isUnoccludeState: boolean = false;

  public setUnoccludeState(isEnable: boolean): void {
    this.isUnoccludeState = isEnable;
  }

  /**
   * 面板状态监听器
   */
  private viewCallbacks: Map<SysDialogType, DialogViewCallback> = new Map();

  private statusBarGestureStatusCallback?: StatusBarGestureStatusCallback;

  private isNeedUpdateScreenLockOccluded: boolean = false;

  private isNeedUpdatePageCoexistence: boolean = false;
  private viewType?: SysDialogType;
  private persistentId?: number;

  /**
   * 屏幕宽高变化回调
   */
  private onBaseStateChange: OnStateChangeListener = {
    /**
     * 基础状态回调
     */
    onStateChange: (state: IState): void => {
      switch (state.getStateType()) {
        case StateType.TYPE_DISPLAY_SIZE:
          this.onDisplaySizeChange();
          break;
        default:
          break;
      }
    }
  };

  /**
   * 返回键按压回调
   */
  private onBackPress = (state?: SysDialogState): void => {
    let type = state?.getDialogType();
    state?.getBackPressListeners().find((info) => {
      // 优先级，消费则终止
      return info?.listener?.(type);
    });
  };

  /**
   * 构造
   */
  constructor() {
    // 屏幕宽高变化监听
    baseStateMgr.registerStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.onBaseStateChange);
  }

  /**
   * 目标弹框初始化
   *
   * @param type 目标弹框类型
   * @param persistentId 面板ID
   */
  appear(type: SysDialogType, persistentId: number): void {
    let state = this.getDialogState(type);
    if (CommonUtils.isInvalid(state)) {
      return;
    }
    this.viewType = type;
    this.persistentId = persistentId;
    state?.initPanelController();
    let controller = state?.getPanelController();
    viewMgrPolicy.registerViewController(type, controller);
    controller?.updateId(persistentId);

    // 监听焦点切换
    let callback = new DialogViewCallback(state);
    this.viewCallbacks.set(type, callback);
    viewMgrPolicy.registerViewCallback(type, callback);

    // 注册返回键按压监听
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, persistentId, () => this.onBackPress(state));

    // 初始化面板大小
    this.checkUpdatePanelArea(type);
  }

  /**
   * 目标弹框资源回收
   *
   * @param type 目标弹框类型
   */
  disappear(type: SysDialogType): void {
    let state = this.getDialogState(type);
    if (CommonUtils.isInvalid(state)) {
      return;
    }

    // 注销焦点切换监听
    viewMgrPolicy.unRegisterViewCallback(this.viewType, this.viewCallbacks.get(this.viewType as SysDialogType));
    viewMgrPolicy.unregisterViewController(this.viewType);
    viewMgrPolicy.offGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId);
    this.viewCallbacks.delete(this.viewType as SysDialogType);
    baseStateMgr.unregisterStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.onBaseStateChange);
  }

  /**
   * 获取目标弹框状态
   *
   * @param type 目标弹框类型
   * @returns 弹框状态
   */
  getDialogState(type: SysDialogType): SysDialogState | undefined {
    return this.dialogStates.get(type);
  }

  /**
   * 请求三方系统样式弹框
   *
   * @param type 弹框面板
   */
  requestPanelOuter(type: SysDialogType): void {
    if (type === SysDialogType.TYPE_UPPER && this.processUnoccludePanelOuter()) {
      log.showInfo(`add or clear panel type: SysDialogPanelType.TYPE_OUTER_UNOCCLUDE`);
      return;
    }
    this.addPanelType(type, SysDialogPanelType.TYPE_OUTER);
  }

  private processUnoccludePanelOuter(): boolean {
    log.showInfo(`processUnoccludePanelOuter update: ${this.isNeedUpdatePageCoexistence}, state: ${this.isUnoccludeState}`);
    // 当有防误触弹窗时，isUnoccludeState会被标记为true，此时需要发送共存的覆盖模式
    if (!this.isNeedUpdatePageCoexistence && this.isUnoccludeState) {
      this.addPanelType(SysDialogType.TYPE_UPPER, SysDialogPanelType.TYPE_OUTER_UNOCCLUDE);
      this.isNeedUpdatePageCoexistence = true;
      return true;
    }
    // 当防误触弹窗消失时，isUnoccludeState会被表示为false，此时需要移除共存的覆盖模式
    if (this.isNeedUpdatePageCoexistence && !this.isUnoccludeState) {
      this.clearPanelType(SysDialogType.TYPE_UPPER, SysDialogPanelType.TYPE_OUTER_UNOCCLUDE);
      this.updateKeyguardUnOccludedState(false);
      this.isNeedUpdatePageCoexistence = false;
      return true;
    }
    return false;
  }

  private updateKeyguardUnOccludedState(isEnableUnocclude: boolean): void {
    log.showInfo('updateKeyguardOccludedState SYSTEM_DIALOG_UNOCCLUDE:' + isEnableUnocclude);
    SCBSceneSessionManager.getInstance().updateKeyguardOccludedState(OccludeKeygaurdScene.SYSTEM_DIALOG_UNOCCLUDE, isEnableUnocclude);
  }

  /**
   * 释放三方系统样式弹框
   *
   * @param type 弹框面板
   */
  releasePanelOuter(type: SysDialogType): void {
    if (type === SysDialogType.TYPE_UPPER) {
      log.showInfo('clear panel type: SysDialogPanelType.TYPE_OUTER_UNOCCLUDE');
      this.processUnoccludePanelOuter();
    }
    this.clearPanelType(type, SysDialogPanelType.TYPE_OUTER);
  }

  /**
   * 请求内部低电量关机提醒弹框
   *
   * @param type 弹框面板
   */
  requestPanelInnerShutdown(type: SysDialogType): void {
    this.setGestureState(type, false, false);
    this.addPanelType(type, SysDialogPanelType.TYPE_INNER_SHUTDOWN);
  }

  /**
   * 释放内部低电量关机提醒弹框
   *
   * @param type 弹框面板
   */
  releasePanelInnerShutdown(type: SysDialogType): void {
    this.setGestureState(type, true, false);
    this.clearPanelType(type, SysDialogPanelType.TYPE_INNER_SHUTDOWN);
  }

  /**
   * 注册返回按钮监听器
   *
   * @param type 弹框类型
   * @param listener 监听器
   * @param priority 优先级
   */
  registerBackPressListener(type: SysDialogType, listener: OnBackPressListener, priority?: BackPressPriority): void {
    this.getDialogState(type)?.addBackPressListener(listener, priority);
  }

  /**
   * 注销返回按钮监听器
   *
   * @param type 弹框类型
   * @param listener 监听器
   */
  unregisterBackPressListener(type: SysDialogType, listener: OnBackPressListener): void {
    this.getDialogState(type)?.removeBackPressListener(listener);
  }

  /**
   * 设置手势启用禁用状态
   */
  public setGestureState(dialog: SysDialogType, isEnableStatusBarGesture: boolean, isEnableBackGesture: boolean): void {
    let state = this.getDialogState(dialog);
    if (CommonUtils.isInvalid(state)) {
      return;
    }
    log.showInfo(`setGestureState start: ${isEnableStatusBarGesture} ${isEnableBackGesture}`);
    // 设置返回手势状态
    this.setBackPressGestureState(isEnableBackGesture);
    this.checkNavigationEnable();
    // 设置下拉手势
    this.statusBarGestureStatusCallback?.onStatusBarEnabledChange(isEnableStatusBarGesture);
    log.showInfo('setGestureState end');
  }

  /**
   * 系统弹窗设置窗口旋转
   * @param isEnableRotate 是否启用旋转
   */
  public setEnableRotate(isEnableRotate: boolean): void {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (CommonUtils.isInvalid(screenSession)) {
      log.showError(`screenSession is invalid`);
      return;
    }
    log.showInfo(`setEnableRotate ${isEnableRotate}`);
    screenSession?.setEnableRotate(isEnableRotate, 'sysDialog');
    if (isEnableRotate) {
      screenSession?.rotationChangeEntry(screenSession.sensorScreenProperty.rotation, 'unlock sysDialog rotation');
    }
  }

  /**
   * 检测手势导航是否屏蔽
   */
  checkNavigationEnable(): void {
    // 存在弹框聚焦，则屏蔽手势导航，低电量关机提醒弹框例外
    let isFocused = false;
    let hasShutdown = false;
    this.dialogStates.forEach((state) => {
      isFocused ||= state.isPanelFocused();
      hasShutdown ||= state.panelTypeState.hasPanelType(SysDialogPanelType.TYPE_INNER_SHUTDOWN);
    });
    log.showInfo('checkNavigationEnable isFocused: ' + isFocused + ', ' + hasShutdown + ', ' + this.isSupportBackPressGesture);
    const isGestureNavbarEnable: boolean = !isFocused || hasShutdown;
    const isEnableBackGesture: boolean = this.isSupportBackPressGesture || isGestureNavbarEnable;
    log.showInfo(`checkNavigationEnable isEnableBackGesture: ${isEnableBackGesture} ${isGestureNavbarEnable}`);
    scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.SYSTEM_DIALOG, isEnableBackGesture, isGestureNavbarEnable);
  }

  /**
   * 更新目标弹框面板显示区域
   *
   * @param type 目标弹框类型
   */
  checkUpdatePanelArea(type: SysDialogType): void {
    let state = this.getDialogState(type);
    if (CommonUtils.isInvalid(state)) {
      return;
    }
    state?.getPanelController()?.updateRect({
      left: 0,
      top: 0,
      width: px2vp(state.displaySizeState.displayWidth),
      height: px2vp(state.displaySizeState.displayHeight)
    });
  }

  registerStatusBarGestureStatusListener(callback?: StatusBarGestureStatusCallback): void {
    log.showInfo('registerStatusBarGestureStatusListener');
    this.statusBarGestureStatusCallback = callback;
  }

  /**
   * 屏幕宽高变化回调
   */
  private onDisplaySizeChange(): void {
    log.showInfo('onDisplaySizeChange start');
    this.checkUpdatePanelArea(SysDialogType.TYPE_DEFAULT);
    this.checkUpdatePanelArea(SysDialogType.TYPE_UPPER);
  }

  /**
   * 调整系统弹窗层级
   *
   * @param index 层级
   */
  public setZIndex(index: number): void {
    viewMgrPolicy.setZIndex(SysDialogType.TYPE_DEFAULT, index);
  }

  /**
   * 添加弹框面板显示类型
   *
   * @param dialog 弹框面板
   * @param type 目标显示类型
   */
  private addPanelType(dialog: SysDialogType, type: SysDialogPanelType): void {
    let state = this.getDialogState(dialog);
    if (CommonUtils.isInvalid(state)) {
      return;
    }

    let panelState = state?.panelTypeState;
    if (panelState?.hasPanelType(type)) {
      return;
    }

    log.showInfo('addPanelType: ' + dialog + ', ' + type);
    panelState?.addPanelType(type);

    // 聚焦时才判断手势导航状态
    if (state?.isPanelFocused()) {
      this.checkNavigationEnable();
    }

    // 显示面板
    state?.getPanelController()?.show();
    // 高级系统弹窗在锁屏时一镜到底动画禁用
    if (SCBSceneSessionManager.getInstance().isScreenLocked() && dialog === SysDialogType.TYPE_UPPER) {
      if (type === SysDialogPanelType.TYPE_OUTER_UNOCCLUDE) {
        this.updateKeyguardUnOccludedState(true);
        return;
      }
      log.showInfo('updateKeyguardOccludedState SYSTEM_DIALOG:true');
      SCBSceneSessionManager.getInstance().updateKeyguardOccludedState(OccludeKeygaurdScene.SYSTEM_DIALOG, true);
      this.isNeedUpdateScreenLockOccluded = true;
    }
  }

  /**
   * 清除弹框面板显示类型
   *
   * @param dialog 弹框面板
   * @param type 目标显示类型
   */
  private clearPanelType(dialog: SysDialogType, type: SysDialogPanelType): void {
    let state = this.getDialogState(dialog);
    if (CommonUtils.isInvalid(state)) {
      return;
    }
    let panelState = state?.panelTypeState;
    if (!panelState?.hasPanelType(type)) {
      return;
    }
    log.showInfo('clearPanelType: ' + dialog + ', ' + type);
    panelState?.clearPanelType(type);

    // 聚焦时才判断手势导航状态
    if (state?.isPanelFocused()) {
      this.checkNavigationEnable();
    }

    // 隐藏面板
    if (panelState.hasPanelType(SysDialogPanelType.TYPE_NONE)) {
      state?.getPanelController()?.hide();
      // 锁屏一镜到底动画启用
      if (this.isNeedUpdateScreenLockOccluded) {
        log.showInfo('updateKeyguardOccludedState SYSTEM_DIALOG:false');
        SCBSceneSessionManager.getInstance().updateKeyguardOccludedState(OccludeKeygaurdScene.SYSTEM_DIALOG, false);
        this.isNeedUpdateScreenLockOccluded = false;
      }
    }
  }

  /**
   * 判断当前是否有系统弹窗
   *
   * @param dialog 类型
   * @returns 返回当前是否有系统弹窗
   */
  public isSysDialogShowing(dialog: SysDialogType): boolean {
    let state = this.getDialogState(dialog);
    if (CommonUtils.isInvalid(state)) {
      return false;
    }
    return state?.getPanelController()?.isShowing() ?? false;
  }
}

// 单例
export let sysDialogMgr: SysDialogManager = SingletonHelper.getInstance(SysDialogManager, TAG);