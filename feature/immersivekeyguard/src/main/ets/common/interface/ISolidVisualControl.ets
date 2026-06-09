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

import { WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';

/**
 * 纯色模式视效管控抽象层
 */
export interface ISolidVisualControl {
  /**
   * 纯色业务初始化
   */
  solidInit(): void;

  /**
   * 纯色业务资源回收
   */
  solidDestroy(): void;

  /**
   * 纯色模式是否开启
   *
   * @returns true开启纯色模式
   */
  isSolidEnable(): boolean;

  /**
   * 是否禁用提亮
   *
   * @returns true禁用提亮
   */
  isDisableBright(): boolean;

  /**
   * 刷新纯色模式颜色值
   *
   * @param solidStyle 纯色模式样式管理器
   */
  updateSolidColor(solidStyle: WidgetStyleStateV2): void;
}