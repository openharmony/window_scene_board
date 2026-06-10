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
import type { IUpdatable } from '../../base/common/interface/IUpdatable';
import type { LiveExtendType } from './LiveConstants';

/**
 * 实况卡片、胶囊扩展数据类型接口
 */
export interface ILiveExtendData extends IUpdatable {
  /**
   * 扩展数据类型的具体类型，可用于数据转换
   *
   * @returns 扩展数据类型
   */
  getLiveExtendType(): LiveExtendType;
}