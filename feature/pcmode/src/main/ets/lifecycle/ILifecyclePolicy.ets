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

import { SCBSceneContainerSession, SCBSceneSession } from '@ohos/windowscene';
import { IBase } from '../base/IBase';

/**
 * 生命周期策略类
 */
export interface ILifecyclePolicy extends IBase {
  /**
   * 最小化所有窗口
   */
  minimizeAllScene(): void;
  /**
   * 实时更新前台窗口最大数量限制
   */
  updateForegroundWindowNum(windowNum: number): void;
  /**
   * 最小化应用
   * @param container
   */
  minimizeContainer(container: SCBSceneContainerSession): void ;
}