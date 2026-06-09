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
import rpc from '@ohos.rpc';
import { GestureState, RotateState, SysDialogZOrder } from './Constants';

/**
 * 类型，唯一标示
 */
type Tid = string;

/**
 * 外部扩展参数key
 */
export const PARAMETER_EXTENSION_KEY = 'ability.want.params.uiExtensionType';

export interface IExtraInfo {
  // commonDialog弹框中的应用名
  appName?: string;
  // commonDialog弹框的标题
  title: string;
  // commonDialog弹框的内容
  content: string;
  // commonDialog弹框的按钮
  button: string;
}
/**
 * 参数集
 */
export interface IParameters {
  extraInfo?: IExtraInfo,
  /**
   * 弹窗层级,默认1低层级,值为2表示高层级
   */
  sysDialogZOrder?: SysDialogZOrder,
  /**
   * 是否开启返回手势事件,默认不返回, 值为1表示开启
   */
  isEnableBackGesture?: GestureState,
  /**
   * 是否开启下拉手势,默认不开启,值为1表示开启
   */
  isEnableStatusBarGesture?: GestureState,
  /**
   * 是否禁用兜底,默认启用,值为1表示不启用兜底
   */
  disableUpGesture?: number,
  /**
   * 是否禁用旋转, 默认不禁用,值为0表示禁用
   */
  isEnableRotate?: RotateState,
  /**
   * 是否强制主屏幕弹出
   */
  isForceShowMainScreen?: boolean,
}

export interface ReceiveEventInfo {
  onReceiveEvent: Function;
}

export type IParam = Record<string, Object>;

/**
 * UIExtensionComponent参数
 */
export interface IWant {
  bundleName?: string,
  abilityName?: string,
  parameters?: IParam,
}

/**
 * 弹框数据
 */
export interface ISystemDialogData {
  id: Tid, // current data unique id. equal to connectId
  connectId: string, // client server connect id
  sysDialogZOrder?: SysDialogZOrder, // dialog zorder
  want: IWant, // ArkUI UIExtensionComponent parameter
  remoteObject?: rpc.RemoteObject, // remoteObject from client
  timestamp?: number, // request timestamp
  screenId?: number,
  count?: number,
  flag?: number,
}

/**
 * 弹框数据刷新事件
 */
export class DialogDataEvent {
  /**
   * 弹框层级，默认低层级
   */
  public dialogZOrder: SysDialogZOrder = SysDialogZOrder.DEFAULT;

  /**
   * 弹框数据集
   */
  public dataList: Array<ISystemDialogData> = [];

  /**
   * 底层级弹框数据集
   */
  public defaultList: Array<ISystemDialogData> = [];

  /**
   * 高层级弹框数据集
   */
  public upperList: Array<ISystemDialogData> = [];

  /**
   * 当前所操作的弹窗
   */
  public item: ISystemDialogData | null = null;

  /**
   * 弹窗流程，区分pre 和 show
   */
  public count?: number;

  /**
   * 弹窗流程标记
   */
  public flag?: number;

  /**
   * 事件名称
   */
  public static eventTypeName: string = 'DialogDataEvent';
}