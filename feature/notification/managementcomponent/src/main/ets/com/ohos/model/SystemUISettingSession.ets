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

import type UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { LengthMetrics } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';

export type KeyValPair = Record<string, Object>;

interface NotificationConfigParam {
  bundleName?: string;
  appIndex?: number;
  isFromNc?: boolean;
  uid?: number;
  isMetaService?: boolean;
}

export interface PushParam {
  /**
   * 包名
   */
  bundleName?: string;
  /**
   * 分身下标
   */
  appIndex?: number;
  /**
   * 跳转到通知配置详情的参数
   */
  config?: NotificationConfigParam
}

export interface PageContext {
  session: UIExtensionContentSession;
  /* 拉起二级界面时，是否通过主界面（即返回是否是需要先回到主界面） */
  isFromHome?: boolean;
  bundleInfo?: KeyValPair;
  appIndex?: number;
  /* 启动目标是否为二级界面，判断是否为外部直接拉起二级界面场景 */
  isLaunch2SubPage?: boolean;
  /* 有值是表示拉起主界面 */
  mainPageName?: string,
  /* 二级界面名 */
  subPageName?: string;
  isMetaService?: boolean;
}

export interface SessionMarginValue {
  end: LengthMetrics
}