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

import { StringUtils } from '@ohos/themeservicebase/Index';

/**
 * 外屏主题包
 */
export class LemSubScreenInfo {
  private static readonly DEFAULT_ORDER: number = 0;

  /**
   * 主题包Id
   */
  public readonly themeId: string;

  /**
   * 外屏主题包类型
   */
  public readonly type: string = '';

  /**
   * 主题包路径
   */
  public readonly path: string;

  /**
   * 是否显示电量
   */
  public battery: boolean = false;

  /**
   * 震感反馈是否开启
   */
  public vibration: boolean = false;

  /**
   * 声音反馈是否开启
   */
  public sound: boolean = false;

  /**
   * 外屏画廊排序
   */
  public order: number = LemSubScreenInfo.DEFAULT_ORDER;

  /**
   * 构造方法
   * @param themeId 外屏主题id
   * @param path 外屏主题路径
   */
  constructor(themeId: string, path: string) {
    this.themeId = themeId;
    this.path = path;
    if (StringUtils.isEmpty(path)) {
      return;
    }
    if (path.startsWith('/sys_prod')) {
      this.type = 'preset';
    } else if (path.startsWith('/data/themes/s/online/download')) {
      this.type = 'presetFragment';
    } else {
      this.type = 'diy';
    }
  }
}