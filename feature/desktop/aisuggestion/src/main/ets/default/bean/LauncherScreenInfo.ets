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
import type { LauncherScreenPageInfo } from './LauncherScreenPageInfo';

/**
 * 特定桌面屏幕信息
 *
 * @since 2023-10-08
 */
export class LauncherScreenInfo {
  /**
   * 屏幕索引
   */
  public screenIndex: number = 0;

  /**
   * 当前屏展示的内容
   */
  public currentScreenInfo?: LauncherScreenPageInfo;

  /**
   * 双屏的模式下相邻屏展示内容
   */
  public nearScreenInfo?: LauncherScreenPageInfo;

  /**
   * 当桌面隐藏图标列表,需要语音助手推荐时过滤该部分应用
   */
  public hideAppList?: string[];
}