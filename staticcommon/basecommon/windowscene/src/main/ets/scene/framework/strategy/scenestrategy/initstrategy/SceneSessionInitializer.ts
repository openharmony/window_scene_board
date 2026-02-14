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

import { SCBSceneSession } from '../../../../../TsIndex';
import { SceneSessionInitBasicStrategy } from './SceneSessionInitBasicStrategy';

export interface ISceneSessionInitStrategy {
  init(sceneSession: SCBSceneSession): void;
}

/**
 * 窗口数据初始化
 */
export class SceneSessionInitializer {
  public static getInstance(): SceneSessionInitializer {
    if (!globalThis.SceneSessionInitializer) {
      globalThis.SceneSessionInitializer = new SceneSessionInitializer();
    }
    return globalThis.SceneSessionInitializer;
  }

  public init(sceneSession: SCBSceneSession): void {
    // 注册基础的数据和状态变量
    SceneSessionInitBasicStrategy.getInstance().init(sceneSession);
  }
}