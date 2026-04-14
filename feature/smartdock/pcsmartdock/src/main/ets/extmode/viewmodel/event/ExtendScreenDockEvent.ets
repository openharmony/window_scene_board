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
import { DockItemInfo } from '@ohos/launchercommon';

/**
 * Dock栏跨组件事件定义
 */
export class ExtendScreenDockEvent {
  /**
   * 事件类型值 - 列表初始化
   */
  public static readonly EVENT_TYPE_INIT = 0;

  /**
   * 事件类型值 - 常驻区应用变化
   */
  public static readonly EVENT_TYPE_RESIDENT_APPS_CHANGED = 1;

  /**
   * 事件类型值 - 运行区应用变化
   */
  public static readonly EVENT_TYPE_RECENT_APPS_CHANGED = 2;

  /**
   * 事件类型值 - 系统入口应用变化
   */
  public static readonly EVENT_TYPE_SYSTEM_APPS_CHANGED = 3;

  /**
   * 事件类型
   */
  public eventType: number = 0;

  /**
   * 事件参数
   */
  public eventParams: DockItemInfo[] = [];

  public eventTypeName: string = 'ExtendScreenDockEvent';

  /**
   *
   * 是否合法事件
   *
   * @param code
   * @returns
   */
  public static isValid(code: number): boolean {
    return code <= ExtendScreenDockEvent.EVENT_TYPE_SYSTEM_APPS_CHANGED &&
      code >= ExtendScreenDockEvent.EVENT_TYPE_INIT;
  }
}
