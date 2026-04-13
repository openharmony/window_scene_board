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
import type { IUpdatable } from '../../base/common/interface/IUpdatable';
import type { LiveType } from './LiveConstants';

/**
 * 实况卡片模板数据类型接口
 */
export interface ILiveTemplateData extends IUpdatable {
  /**
   * 获取实况类型
   *
   * @returns 实况类型
   */
  getLiveType(): LiveType;
}