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

import { SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { IImmComVm } from './IImmComVm';
import { IImmItemHelperVm } from './IImmItemHelperVm';
import { IImmStyleConfigHelper } from './IImmStyleConfigHelper';

/**
 * 沉浸模块业务注入器抽象层
 */
export interface IImmersiveVmInjector {
  /**
   * 获取状态管理器名
   *
   * @returns 管理器名
   */
  getStateMgr(): SlStateMgr;

  /**
   * 沉浸模块条目状态辅助工具统一管理业务
   *
   * @returns 辅助工具管理业务
   */
  getImmItemHelperVm(): IImmItemHelperVm;

  /**
   * 沉浸模块默认样式配置辅助工具
   *
   * @returns 默认样式配置工具
   */
  getImmStyleConfigHelper(): IImmStyleConfigHelper;

  /**
   * 沉浸模块通用能力
   *
   * @returns 通用能力
   */
  getImmComVm(): IImmComVm | undefined;
}