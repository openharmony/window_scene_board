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
import { KeyValPair } from '../model/SystemUISettingSession';

export interface JumpEvtData {
  name: string,
  data?: KeyValPair,
}

export class NtfSettingJumpEvent {
  public static readonly eventTypeName = 'NtfSettingJumpEvent';
  /**
   * 通知和状态栏二级页面跳转
   */
  public static readonly PAGE_JUMP = 0;
  /**
   * 设置页面跳转
   */
  public static readonly SETTING_PAGE_JUMP = 1;
  /**
   * 事件类型
   */
  public eventType: number;
  /**
   * 页面名
   */
  public pageName: string;
  /**
   * 参数
   */
  public param?: KeyValPair;

  constructor(eventType: number, pageName: string, param?: KeyValPair) {
    this.eventType = eventType;
    this.pageName = pageName;
    this.param = param;
  }
}

/**
 * 设置路由参数类
 */
export class SettingRouterParam {
  public config?: Object | object;
  public startReason?: string;
  public subUri?: string;
  public bundleName?: string;
  public appIndex?: number;
  public itemName?: string;
  public action: string = 'jump';
  public uri: string;
  public isHome: boolean = false;
  public isEntry?: boolean;
  public isBack: boolean = false;

  constructor(uri: string, config?: Object | object, appIndex?: number) {
    this.uri = uri;
    this.config = config;
    this.appIndex = appIndex;
  }
}
