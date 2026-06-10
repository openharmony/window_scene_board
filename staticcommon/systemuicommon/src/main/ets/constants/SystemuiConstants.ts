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

export class SystemuiConstants {
  /**
   * Push包名
   */
  public static readonly PUSH_BUNDLE_NAME = 'com.ohos.pushservice';

  /**
   * 更新通知配置的事件名
   */
  public static readonly NOTIFICATION_CONFIG_CHANGE_EVENT = 'user.custom.systemui.NOTIFICATION_CONFIG_CHANGE_EVENT';

  /**
   * 恢复流程入库完成事件
   */
  public static readonly NOTIFICATION_BACK_UP_EVENT = 'user.custom.systemui.NOTIFICATION_BACK_UP_EVENT';

  /**
   * Trace点位：worker初始化
   */
  public static readonly TRACE_THREAD_INIT = 'SYSUI_THREAD_INIT';

  /**
   * Trace点位：线程间通信
   */
  public static readonly TRACE_THREAD_MESSAGE = 'SYSUI_THREAD_MESSAGE:';

  /**
   * Trace点位：线程间调用
   */
  public static readonly TRACE_THREAD_CALL = 'SYSUI_THREAD_CALL:';

  /**
   * 置顶数量限制
   */
  public static readonly PIN_TOP_APPS_LIMIT = 5;

  /**
   * push 通知 SystemUI 拉起三方应用 成功时 调用push 的 code
   */
  static readonly INVOKE_APP_SUCCESS: number = 0;

  /**
   * push 通知 SystemUI 拉起三方应用 失败时 调用push 的 code
   */
  static readonly INVOKE_APP_FAIL: number = 1;

  /**
   * push 通知中wantAgentInfo 参数 key
   */
  static readonly KEY_PUSH_WANT_AGENT_INFO: string = 'push_wantAgentInfo';

  /**
   * push 通知 SystemUI拉起应用成功 回调push结果 参数 key
   */
  static readonly KEY_START_APP_RESULT: string = 'startAppResult';

  /**
   * push 通知 SystemUI拉起push的want 参数 errorCode key
   */
  static readonly KEY_INVOKE_PUSH_WANT_PARAMETERS_ERROR_CODE: string = 'errorCode';

  /**
   * push 通知 SystemUI拉起push的want 参数 desc key
   */
  static readonly KEY_INVOKE_PUSH_WANT_PARAMETERS_DESC: string = 'desc';

  /**
   * Default invalid value.
   */
  static INVALID_VALUE = -1;

  //手机重启时，消息deliveryTime与当前时间的间隔阈值
  public static readonly LIVE_TIME_DIFF = 30000;

  /**
   * 通过通知卡片拉起应用，在want中传递拉起原因。value
   */
  public static readonly NC_LAUNCH_REASON_MESSAGE = 'ReasonMessage_Notification';

  /**
   * 多屏协同开关出现事件
   */
  public static readonly DISTRIBUTED_DEVICE_TYPES_CHANGE = 'notification.event.DISTRIBUTED_DEVICE_TYPES_CHANGE';
}

/**
 * APS模块场景启动和结束
 */
export enum APSSceneState {
  // APS模块场景结束
  END_SCENE = 0,
  // APS模块场景启动
  START_SCENE = 1
}

/**
 * SystemUI使用场景
 */
export enum SystemUIUseScene {
  /**
   * 状态栏
   */
  STATUSBAR = 'StatusBar',
  /**
   * 下拉面板
   */
  DROPDOWN = 'Dropdown',
  /**
   * 横幅
   */
  BANNER = 'Banner',
  /**
   * 横幅蒙层
   */
  BANNER_MASK = 'BannerMask',
  /**
   * 锁屏
   */
  KG = 'KG',
  /**
   * 实况面板
   */
  LIVE = 'Live',
  /**
   * 沉浸态
   */
  IMMERSIVE = 'Immersive',
  /**
   * 扩展新形态小折叠产品折叠态
   */
  OUTERHOME = 'OuterHome',
  /**
   * 悬浮球
   */
  FLOATING_BALL = 'FloatingBall',
}