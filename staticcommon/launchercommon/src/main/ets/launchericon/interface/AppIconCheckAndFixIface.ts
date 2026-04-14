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

import { AppItemInfo } from '../../bean/AppItemInfo';

/**
 * 图标组件支持检测与修复的接口
 */
export interface AppIconCheckAndFixIface {
  /**
   * 是否支持检测与修复
   *
   * @returns true 支持, false 不支持
   */
  isSupportCheckAndFix: () => boolean;

  /**
   * 获取被检测对象的信息
   *
   * @returns AppItemInfo
   */
  getCheckItemInfo: () => AppItemInfo;

  /**
   * 检测图标Image是否正常
   *
   * @returns 图标Image是否正常, true Image正常, false Image异常
   */
  isValidImage: () => boolean;

  /**
   * 检测图标opacity是否正常
   *
   * @returns 图标opacity是否正常, true opacity正常, false opacity异常
   */
  isValidOpacity: () => boolean;

  /**
   * 修复图标Image
   *
   * @returns 是否修复成功
   */
  fixIconImage: () => Promise<void>;

  /**
   * 修复图标Opacity
   *
   * @returns 是否修复成功
   */
  fixIconOpacity: () => void;
}