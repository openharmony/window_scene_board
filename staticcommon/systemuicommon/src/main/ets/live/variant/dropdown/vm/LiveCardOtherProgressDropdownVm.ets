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
import { DropdownVm } from '../../../../vm/DropdownVm';
import { EnvVm } from '../../../../vm/EnvVm';
import { LiveCardOtherProgressVm } from '../../../vm/LiveCardOtherProgressVm';

@ObservedV2
export class LiveCardOtherProgressDropdownVm extends LiveCardOtherProgressVm {
  /*
   * 获取进度条背景颜色
   */
  @Computed get lineBackgroundColor(): string {
    if (this.card.layoutBackgroundColor) {
      return this.card.layoutBackgroundColor;
    }
    return EnvVm.instance.isDarkMode ? '#19FFFFFF' : '#19000000';
  }

  public checkStartAnim(): boolean {
    return DropdownVm.instance.isShow;
  }
}