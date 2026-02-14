/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { SCBSceneContainerSession } from '../../../../../TsIndex';
import { ContainerSessionInitBasicStrategy } from './ContainerSessionInitBaiscStrategy';

export interface IContainerSessionInitStrategy {
  init(containerSession: SCBSceneContainerSession): void;
}

/**
 * 窗口容器数据初始化
 */
export class ContainerSessionInitializer {
  public static getInstance(): ContainerSessionInitializer {
    if (!globalThis.ContainerSessionInitializer) {
      globalThis.ContainerSessionInitializer = new ContainerSessionInitializer();
    }
    return globalThis.ContainerSessionInitializer;
  }

  public init(containerSession: SCBSceneContainerSession): void {
    // 注册基础的数据和状态变量
    ContainerSessionInitBasicStrategy.getInstance().init(containerSession);
  }
}