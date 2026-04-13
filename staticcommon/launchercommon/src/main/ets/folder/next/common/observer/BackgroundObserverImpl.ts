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

import { IObserver } from './IObserver';

/**
 * 背板相关的observer接口
 */
export interface BackgroundObserverImpl extends IObserver {
  /**
   * 更新进入退出编辑模式
   * @param isEditMode 是否编辑模式
   */
  updateByEditMode(isEditMode: boolean): void;
}