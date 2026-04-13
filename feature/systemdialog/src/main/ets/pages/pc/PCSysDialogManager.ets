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

import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { ViewCallback, viewMgrPolicy } from '@ohos/frameworkwrapper';
import {
  baseStateMgr,
  IState,
  OnStateChangeListener,
  StateType,
  SysDialogType,
  SysDialogState,
  SysDialogPanelType,
  OnBackPressListener,
  BackPressPriority
} from '@ohos/systemuiutils';
import {
  GestureEnableCaller,
  OccludeKeygaurdScene,
  SCBEventId,
  scbGestureManager,
  SCBSceneSessionManager,
  SCBScreenSessionManager
} from '@ohos/windowscene';

const TAG = 'PCSysDialogManager';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);


/**
 * 弹框面板状态监听
 */
class DialogViewCallback implements ViewCallback {
  /**
   * 目标弹框状态管理器
   */
  private dialogState?: SysDialogState;

  /**
   * 屏幕id
   */
  private screenId: number = 0;

  /**
   * 构造
   *
   * @param state 状态管理器
   */
  constructor(state: SysDialogState, screenId: number) {
    this.dialogState = state;
    this.screenId = screenId;
  }

  /**
   * 聚焦回调
   */
  onGainFocus(): void {
    this.dialogState?.setFocused(true);
  }

  /**
   * 失焦回调
   */
  onLoseFocus(): void {
    this.dialogState?.setFocused(false);
  }
}

interface StatusBarGestureStatusCallback {
  onStatusBarEnabledChange(enable: boolean): void;
}

/**
 * 系统弹框面板统一管理
 */
export class PCSysDialogManager {
  private type: SysDialogType = SysDialogType.TYPE_DEFAULT;
  // 屏幕Id
  private screenId: number = 0;
  /**
   * 弹框状态管理集
   */
  private dialogState: SysDialogState;

  /**
   * 面板状态监听器
   */
  private viewCallbacks: Map<string, DialogViewCallback> = new Map();
  private statusBarGestureStatusCallback?: StatusBarGestureStatusCallback;
  private isNeedUpdateScreenLockOccluded: boolean = false;
  private viewType: string;
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
  private onBackPress = (state: SysDialogState): void => {
    let type = state?.getDialogType();
    state?.getBackPressListeners().find((info) => {
      // 优先级，消费则终止
      return info?.listener?.(type!);
    });
  };

  /**
   * 构造
   */
  constructor(type: SysDialogType, screenId: number) {
    this.type = type;
    this.screenId = screenId;
    this.viewType = type + screenId;
    this.dialogState = new SysDialogState(type);
    // 屏幕宽高变化监听
    baseStateMgr.registerStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.onBaseStateChange);
  }

  /**
   * 目标弹框初始化
   *
   * @param type 目标弹框类型
   * @param persistentId 面板ID
   */
  appear(persistentId: number): void {
    let state = this.getDialogState();
    if (CommonUtils.isInvalid(state)) {
      return;
    }
    this.persistentId = persistentId;
    state.initPanelController(this.screenId);
    let controller = state.getPanelController();
    viewMgrPolicy.registerViewController(this.viewType, controller);
    controller?.updateId(persistentId);

    // 监听焦点切换
    let callback = new DialogViewCallback(state, this.screenId);
    this.viewCallbacks.set(this.viewType, callback);
    viewMgrPolicy.registerViewCallback(this.viewType, callback);

    // 注册返回键按压监听
    viewMgrPolicy.onGestureCallback(SCBEventId.BACK_GESTURE_EVENT, persistentId, () => this.onBackPress(state));
  }

  /**
   * 目标弹框资源回收
   *
   * @param type 目标弹框类型
   */
  disappear(): void {
    let state = this.getDialogState();
    if (CommonUtils.isInvalid(state)) {
      return;
    }

    // 注销焦点切换监听
    viewMgrPolicy.unRegisterViewCallback(this.viewType, this.viewCallbacks.get(this.viewType));
    viewMgrPolicy.unregisterViewController(this.viewType);
    viewMgrPolicy.offGestureCallback(SCBEventId.BACK_GESTURE_EVENT, this.persistentId);
    this.viewCallbacks.delete(this.viewType);
    baseStateMgr.unregisterStateChangeListener(StateType.TYPE_DISPLAY_SIZE, this.onBaseStateChange);
  }

  /**
   * 获取目标弹框状态
   *
   * @param type 目标弹框类型
   * @returns 弹框状态
   */
  getDialogState(): SysDialogState {
    return this.dialogState;
  }

  /**
   * 请求三方系统样式弹框
   *
   * @param type 弹框面板
   */
  requestPanelOuter(): void {
    this.addPanelType(SysDialogPanelType.TYPE_OUTER);
  }

  /**
   * 释放三方系统样式弹框
   *
   * @param type 弹框面板
   */
  releasePanelOuter(): void {
    this.clearPanelType(SysDialogPanelType.TYPE_OUTER);
  }

  /**
   * 请求内部低电量关机提醒弹框
   *
   * @param type 弹框面板
   */
  requestPanelInnerShutdown(): void {
    this.setGestureState(false, false);
    this.addPanelType(SysDialogPanelType.TYPE_INNER_SHUTDOWN);
  }

  /**
   * 释放内部低电量关机提醒弹框
   *
   * @param type 弹框面板
   */
  releasePanelInnerShutdown(): void {
    this.setGestureState(true, false);
    this.clearPanelType(SysDialogPanelType.TYPE_INNER_SHUTDOWN);
  }

  /**
   * 注册返回按钮监听器
   *
   * @param type 弹框类型
   * @param listener 监听器
   * @param priority 优先级
   */
  registerBackPressListener(listener: OnBackPressListener, priority?: BackPressPriority): void {
    this.getDialogState()?.addBackPressListener(listener, priority);
  }

  /**
   * 注销返回按钮监听器
   *
   * @param type 弹框类型
   * @param listener 监听器
   */
  unregisterBackPressListener(listener: OnBackPressListener): void {
    this.getDialogState()?.removeBackPressListener(listener);
  }

  /**
   * 设置手势启用禁用状态
   */
  public setGestureState(isEnableStatusBarGesture: boolean, isEnableBackGesture: boolean): void {
    let state = this.getDialogState();
    if (CommonUtils.isInvalid(state)) {
      return;
    }
    log.showInfo(TAG, `setGestureState start: ${isEnableStatusBarGesture} ${isEnableBackGesture}`);
    this.checkNavigationEnable(isEnableStatusBarGesture, isEnableBackGesture);
    // 设置下拉手势
    this.statusBarGestureStatusCallback?.onStatusBarEnabledChange(isEnableStatusBarGesture);
    log.showInfo(TAG, 'setGestureState end');
  }

  /**
   * 系统弹窗设置窗口旋转
   * @param isEnableRotate 是否启用旋转
   */
  public setEnableRotate(isEnableRotate: boolean): void {
    const screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
    if (CommonUtils.isInvalid(screenSession)) {
      log.showError(TAG, `screenSession is invalid`);
      return;
    }
    log.showInfo(TAG, `setEnableRotate ${isEnableRotate}`);
    screenSession?.setEnableRotate(isEnableRotate, 'sysDialog');
    if (isEnableRotate) {
      screenSession?.rotationChangeEntry(screenSession.sensorScreenProperty.rotation, 'unlock sysDialog rotation');
    }
  }

  /**
   * 检测手势导航是否屏蔽
   */
  checkNavigationEnable(isGestureNavbarEnable: boolean, isEnableBackGesture: boolean): void {
    log.showInfo(TAG, `check nav ${this.type} ${this.screenId} navbar:${isGestureNavbarEnable} back:${isEnableBackGesture}`);
    scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.SYSTEM_DIALOG, isEnableBackGesture,
      isGestureNavbarEnable);
  }

  /**
   * 更新目标弹框面板显示区域
   *
   * @param type 目标弹框类型
   */
  checkUpdatePanelArea(): void {
    try {
      let state = this.getDialogState();
      if (CommonUtils.isInvalid(state)) {
        return;
      }
      const screenSession = SCBScreenSessionManager.getInstance()?.getScreenSession(this.screenId);
      const screenProperty = screenSession?.scbScreenProperty;
      const screenWidth = screenProperty?.width;
      const screenHeight = screenProperty?.height;
      log.showInfo(TAG, `updateRect ${this.screenId} ${this.type} w:${screenWidth} h:${screenHeight}`);
      if (screenWidth && screenHeight) {
        state.getPanelController()?.updateRect({
          left: 0,
          top: 0,
          width: px2vp(screenWidth),
          height: px2vp(screenHeight)
        });
      }
    } catch (err) {
      log.showError(TAG, `updateRect err ${err}`);
    }
  }

  registerStatusBarGestureStatusListener(callback?: StatusBarGestureStatusCallback): void {
    log.showInfo(TAG, 'registerStatusBarGestureStatusListener');
    this.statusBarGestureStatusCallback = callback;
  }

  /**
   * 屏幕宽高变化回调
   */
  private onDisplaySizeChange(): void {
    log.showInfo(TAG, 'onDisplaySizeChange start');
    this.checkUpdatePanelArea();
  }

  /**
   * 添加弹框面板显示类型
   *
   * @param dialog 弹框面板
   * @param type 目标显示类型
   */
  private addPanelType(type: SysDialogPanelType): void {
    let state = this.getDialogState();
    if (CommonUtils.isInvalid(state)) {
      return;
    }

    let panelState = state.panelTypeState;
    if (panelState.hasPanelType(type)) {
      return;
    }

    log.showInfo(TAG, 'addPanelType: ' + this.type + ', ' + type);
    panelState.addPanelType(type);

    // 显示面板
    state.getPanelController()?.show();
    // 高级系统弹窗在锁屏时一镜到底动画禁用
    if (SCBSceneSessionManager.getInstance().isScreenLocked() && this.type === SysDialogType.TYPE_UPPER) {
      log.showInfo(TAG, 'updateKeyguardOccludedState SYSTEM_DIALOG:true');
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
  private clearPanelType(type: SysDialogPanelType): void {
    let state = this.getDialogState();
    if (CommonUtils.isInvalid(state)) {
      return;
    }
    let panelState = state.panelTypeState;
    if (!panelState.hasPanelType(type)) {
      return;
    }
    log.showInfo(TAG, 'clearPanelType: ' + this.type + ', ' + type);
    panelState.clearPanelType(type);
    this.checkNavigationEnable(true, true);

    // 隐藏面板
    if (panelState.hasPanelType(SysDialogPanelType.TYPE_NONE)) {
      state.getPanelController()?.hide();
      // 锁屏一镜到底动画启用
      if (this.isNeedUpdateScreenLockOccluded) {
        log.showInfo(TAG, 'updateKeyguardOccludedState SYSTEM_DIALOG:false');
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
  public isSysDialogShowing(): boolean | undefined {
    let state = this.getDialogState();
    if (CommonUtils.isInvalid(state)) {
      return false;
    }
    return state?.getPanelController()?.isShowing();
  }
}