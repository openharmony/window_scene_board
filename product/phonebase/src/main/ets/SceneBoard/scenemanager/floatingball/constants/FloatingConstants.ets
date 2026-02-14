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

import commonEvtMgr from '@ohos.commonEventManager';

export class Constants {
  public static readonly RECENT_EVENT: string = 'RECENT_EVENT'; // event
  public static readonly RETURN_DESKTOP_EVENT: string = 'RETURN_DESKTOP_EVENT'; // event
  public static readonly ENTER_RECENT: string = 'ENTER_RECENT'; // eventType
  public static readonly SLIP_UP: string = 'SLIP_UP'; // eventType
  public static readonly START_SCENE_FROM_RECENT: string = 'START_SCENE_FROM_RECENT'; // eventType

  public static readonly PACKAGE_NAME: string = 'com.ohos.sceneboard';
  /**
   * 订阅者名称
   */
  public static readonly SUBSCRIBER_NAME: string = 'Fb_panel';
  /**
   * 最大悬浮球个数
   */
  public static readonly MAX_NUMBER: number = 2;
  /**
   * 高于悬浮垃圾桶index
   */
  public static INDEX_ABOVE_DUMPSTER: number = 1910;
  /**
   * 悬浮球面板组件id
   */
  public static readonly FLOATING_BALL_PANEL_ID = 'FloatingBallPanelComponentId';
}

export type SubscribeCallbackType = (data: commonEvtMgr.CommonEventData) => void;

/**
 * 订阅者信息
 */
export class SubscriberInfo {
  /**
   * 订阅者名称
   */
  public name: string;
  /**
   * 订阅者信息
   */
  public subscriber?: commonEvtMgr.CommonEventSubscriber;
  /**
   * 创建订阅者的订阅信息
   */
  public subscribeInfo: commonEvtMgr.CommonEventSubscribeInfo;
  /**
   * 接收公共事件数据的回调函数
   */
  public subscribeCallBack: SubscribeCallbackType;

  constructor(name: string, subscribeInfo: commonEvtMgr.CommonEventSubscribeInfo,
    subscribeCallBack: SubscribeCallbackType) {
    this.name = name;
    this.subscribeInfo = subscribeInfo;
    this.subscribeCallBack = subscribeCallBack;
  }
}

export interface IScenePanelStateData {
  destState: number;
  moduleName: string;
  srcState: number;
}

export enum FBTemplate {
  /**
   * 图标(icon) + 主文本(title)
   */
  STATIC = 1,
  /**
   * 主文本(title) + 副文本(content)(颜色不同)
   */
  NORMAL,
  /**
   * 图标(icon) + 主文本(title)(数字|文本) + 副文本(content)
   */
  EMPHATIC,
  /**
   * 主文本(title)
   */
  SIMPLE
};

export enum ActionEvent {
  /**
   * 关闭事件
   */
  CLOSE = 'close',
  /**
   * 点击事件
   */
  CLICK = 'click',
}

/**
 * 回弹起始方向
 */
export enum SpringBack {
  /**
   * 从左边回弹
   */
  LEFT = 'left',
  /**
   * 从右边回弹
   */
  RIGHT = 'right',
  /**
   * 从上边回弹
   */
  TOP = 'top',
  /**
   * 从下边回弹
   */
  BOTTOM = 'bottom',
}

/**
 * 删除类型
 */
export enum RemoveType {
  /**
   * 应用删除
   */
  APP = -1,
  /**
   * 拖动垃圾桶删除
   */
  DUMPSTER = 0,
  /**
   * 长按单个删除
   */
  LONG_PRESS_SINGLE = 1,
  /**
   * 长按全部删除
   */
  LONG_PRESS_ALL = 2,
  /**
   * kill应用进程删除
   */
  KILL_PROCESS = 3,
  /**
   * 挤占删除
   */
  SQUEEZE = 4,
}