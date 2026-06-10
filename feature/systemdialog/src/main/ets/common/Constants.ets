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

export enum SysDialogZOrder {
  DEFAULT = 1,
  UPPER = 2
}

export enum SysDialogZIndex {
  INSTANTSHARE = 10,
  DEFAULT = 1902
}

// Add for AuthWidget rotate on 5.0, and removed on 5.1
export enum UiExtNodeAngle {
  DEFAULT = '0',
  TO_PORTRAIT = '90',
  TO_INVERTED = '180',
  TO_PORTRAIT_INVERTED = '270'
}

export enum GestureState {
  DISABLE = 0,
  ENABLE = 1,
}

export enum RotateState {
  /**
   * 禁止旋转
   */
  DISABLE = 0,
  /**
   * 默认为1 允许旋转
   */
  ENABLE = 1,
}

export enum UnoccludeState {
  /**
   * 默认为0，禁用(防误触)共存覆盖状态
   */
  DISABLE = 0,
  /**
   * 使能(防误触)共存覆盖状态
   */
  ENABLE = 1,
}

export enum FocusState {
  /**
   * 跟随系统默认
   */
  DEFAULT = -1,
  /**
   * 不获取焦点
   */
  DISABLE = 0,
  /**
   * 主动获取焦点并聚焦UEC
   */
  ENABLE = 1,
}

export class SysDialogParamsKey {
  public static readonly isEnableRotate = 'isEnableRotate';
  public static readonly isEnableStatusBarGesture = 'isEnableStatusBarGesture';
  public static readonly isEnableBackGesture = 'isEnableBackGesture';
  public static readonly disableUpGesture = 'disableUpGesture';
  public static readonly sysDialogZOrder = 'sysDialogZOrder';
  public static readonly isPageCoexistence = 'isPageCoexistence';
}

export class GestureConstant {
  // 最小拖动识别距离20vp
  public static readonly TOUCH_SLOP = px2vp(20);
  // 手势滑动速度,往上值为负数
  public static readonly SWIPE_SPEED = -250;
  // 滑动偏移量
  public static readonly PAN_DISTANCE = 80;
  // 热区高度
  public static readonly HOT_AREA_HEIGHT = 28;
}

export class RPCReadKey {
  public static readonly FLAGS = 'flags';
}

export class CommonDialog {
  // 业务方传递参数的个数
  public static readonly SIZE = 1;
  // 通用弹框的包名
  public static readonly BUNDLE_NAME = 'com.ohos.sceneboard';
  // 通用弹框的ability名称
  public static readonly ABILITY_NAME = 'com.ohos.sceneboard.alert';
  // uiExtensionType
  public static readonly UEC_TYPE_KEY = 'ability.want.params.uiExtensionType';
  public static readonly UEC_TYPE_VALUE = 'sysDialog/common';
  // 系统分享包名
  public static readonly INSTANTSHARE_BUNDLE_NAME = 'com.ohos.instantshare';
}

export class ToastTip {
  public static readonly SIZE = 1;
}

/**
 * rpc请求指令
 */
export class RequestCommand {
  // 默认系统弹框指令
  public static readonly START_DIALOG = 1;
  public static readonly SEND_REMOTE_OBJECT = 2;
  // 关闭弹框指令
  public static readonly CLOSE_DIALOG = 3;
  // 调用通用弹框指令
  public static readonly COMMON_DIALOG = 4;
  public static readonly TOAST = 5;
  // rpc请求的最大参数个数
  public static readonly LIMIT_PARAMETER_SIZE = 10;
}

/**
 * rpc返回码
 */
export class ReplyCode {
  // 成功
  public static readonly SUCCESS = 0;
  // 错误
  public static readonly ERROR = 1;
}

export class ReportParams {
  public static readonly PACKAGE_NAME = 'com.ohos.sceneboard';
  public static readonly PROCESS_NAME = 'sceneBoard';
}