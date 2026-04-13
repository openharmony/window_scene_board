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
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseViewController } from '@ohos/frameworkcommon';
import type { Equality } from '@ohos/basicutils';
import { baseStateMgr } from './BaseStateManager';
import { DisplaySizeState, IState, StateType } from './BaseState';


const TAG = 'SysDialogState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 系统弹框类型，两个面板
 * 一个低层级面板，一个高层级面板
 */
export enum SysDialogType {
  /**
   * 低层级面板
   */
  TYPE_DEFAULT = 'SYSTEM_ALERT_DEFAULT',

  /**
   * 高层级面板
   */
  TYPE_UPPER = 'SYSTEM_ALERT_UPPER'
}

/**
 * 系统弹框面板当前显示类型
 */
export enum SysDialogPanelType {
  /**
   * 无显示
   */
  TYPE_NONE = 0,

  /**
   * 外部三方系统应用请求弹框
   */
  TYPE_OUTER = 0x01,

  /**
   * 内部低电量关机提醒弹框
   */
  TYPE_INNER_SHUTDOWN = 0x02,

  /**
   * 外部三方系统应用请求弹框，(防误触)覆盖模式共存
   */
  TYPE_OUTER_UNOCCLUDE = 0x04
}

/**
 * 系统弹框当前显示类型状态管理
 */
@Observed
export class SysDialogPanelTypeState implements IState {
  /**
   * 弹框当前实现类型，默认无显示
   */
  panelType: SysDialogPanelType = SysDialogPanelType.TYPE_NONE;

  /**
   * 复写接口IState
   *
   * @returns 状态类型
   */
  getStateType(): StateType {
    return StateType.TYPE_SYS_DIALOG_PANEL_TYPE;
  }

  /**
   * 添加显示类型
   *
   * @param type 目标类型
   */
  addPanelType(type: SysDialogPanelType): void {
    this.panelType |= type;
  }

  /**
   * 清除显示类型
   *
   * @param type 目标类型
   */
  clearPanelType(type: SysDialogPanelType): void {
    this.panelType &= ~(type as number);
  }

  /**
   * 当前是否显示目标类型
   *
   * @param type 目标类型
   * @returns true显示目标类型
   */
  hasPanelType(type: SysDialogPanelType): boolean {
    // 无显示场景
    if (type === SysDialogPanelType.TYPE_NONE && this.panelType === SysDialogPanelType.TYPE_NONE) {
      return true;
    }
    return (this.panelType & type) !== 0;
  }
}

/**
 * 面板返回键按压监听
 */
export type OnBackPressListener = (dialogType?: SysDialogType) => boolean;

/**
 * 返回键按压监听优先级
 */
export enum BackPressPriority {
  /**
   * 低电量弹框优先级，最高优先级
   */
  PRIORITY_SHUTDOWN = 0,

  /**
   * 其他优先级，最低优先级
   */
  PRIORITY_OTHER = 999
}

/**
 * 返回按钮监听器管理
 */
class BackPressListenerInfo implements Equality {
  /**
   * 监听器优先级，默认最低
   */
  priority: BackPressPriority = BackPressPriority.PRIORITY_OTHER;

  /**
   * 监听器
   */
  listener?: OnBackPressListener;

  /**
   * 复写 Equality
   *
   * @param other 待比较对象
   * @returns true相等
   */
  equals(other: object): boolean {
    if (!(other instanceof BackPressListenerInfo)) {
      return false;
    }
    return this.listener === (other as BackPressListenerInfo).listener;
  }
}

/**
 * 系统弹框状态管理
 */
@Observed
export class SysDialogState {
  /**
   * 弹框类型名称
   */
  private typeName?: SysDialogType;

  private screenId?: number = 0;

  /**
   * 面板控制器
   */
  private panelController?: BaseViewController;

  /**
   * 返回按钮监听器集
   */
  private backPressListeners: Array<BackPressListenerInfo> = new Array();

  /**
   * 当前弹框面板是否获焦状态
   */
  private isFocused: boolean = false;

  /**
   * 弹框面板当前显示类型状态管理
   */
  panelTypeState: SysDialogPanelTypeState = new SysDialogPanelTypeState();

  /**
   * 屏幕宽高大小状态
   */
  displaySizeState: DisplaySizeState = baseStateMgr.getBaseState(StateType.TYPE_DISPLAY_SIZE) as DisplaySizeState;


  /**
   * 构造
   *
   * @param name 弹框名
   */
  constructor(name: SysDialogType) {
    this.typeName = name;
  }

  /**
   * 初始化面板控制器
   */
  initPanelController(screenId: number = 0): void {
    this.screenId = screenId;
    this.panelController = new BaseViewController(this.typeName ?? SysDialogType.TYPE_DEFAULT, screenId);
  }

  /**
   * 获取面板控制器
   *
   * @returns 面板控制器
   */
  getPanelController(): BaseViewController | undefined {
    return this.panelController;
  }

  /**
   * 获取当前弹框名
   *
   * @returns 弹框名
   */
  getDialogType(): SysDialogType {
    return this.typeName ?? SysDialogType.TYPE_DEFAULT;
  }

  /**
   * 获取屏幕id
   * @returns
   */
  getScreenId(): number {
    return this.screenId ?? 0;
  }

  /**
   * 添加返回按钮监听
   *
   * @param listener 监听器
   * @param priority 优先级
   */
  addBackPressListener(listener: OnBackPressListener, priority?: BackPressPriority): void {
    if (CommonUtils.isInvalid(listener)) {
      return;
    }
    let priorityResult = CommonUtils.isInvalid(priority) ? BackPressPriority.PRIORITY_OTHER : priority;
    let listenerInfo = new BackPressListenerInfo();
    listenerInfo.priority = priorityResult ?? BackPressPriority.PRIORITY_OTHER;
    listenerInfo.listener = listener;
    ArrayUtils.updateArr(this.backPressListeners, listenerInfo);
    this.sortBackPressListeners();
  }

  /**
   * 移除返回按钮监听
   *
   * @param listener 监听器
   */
  removeBackPressListener(listener: OnBackPressListener): void {
    if (CommonUtils.isInvalid(listener)) {
      return;
    }
    let priorityResult = BackPressPriority.PRIORITY_OTHER;
    let listenerInfo = new BackPressListenerInfo();
    listenerInfo.priority = priorityResult;
    listenerInfo.listener = listener;
    ArrayUtils.deleteArr(this.backPressListeners, listenerInfo);
  }

  /**
   * 获取返回按钮监听器
   *
   * @returns 监听器集
   */
  getBackPressListeners(): Array<BackPressListenerInfo> {
    return this.backPressListeners;
  }

  /**
   * 设置聚焦状态
   *
   * @param isFocused true聚焦
   */
  setFocused(isFocused: boolean): void {
    this.isFocused = isFocused;
  }

  /**
   * 当前面板是否聚焦
   *
   * @returns true聚焦
   */
  isPanelFocused(): boolean {
    return this.isFocused;
  }

  /**
   * 排序返回按钮监听器
   */
  private sortBackPressListeners(): void {
    this.backPressListeners.sort((listenerA, listenerB) => {
      return listenerA.priority - listenerB.priority;
    });
  }
}