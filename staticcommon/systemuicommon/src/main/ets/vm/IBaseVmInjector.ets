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
import { SystemUIUseScene } from '../constants/SystemuiConstants';
import { SystemUIColorVm } from './SystemUIColorVm';

export interface IBaseVmInjector {
  /**
   * 使用场景
   */
  scene: SystemUIUseScene;

  /**
   * 获取颜色相关的VM
   *
   * @returns 颜色VM
   */
  getColorVm(): SystemUIColorVm;

  /**
   * 给一个字符串id拼接场景前缀
   *
   * @param id 后缀ID
   * @returns 拼接ID
   */
  getId(id: string): string;

  /**
   * 清理当前所有vm
   */
  clearVm(): void;
}