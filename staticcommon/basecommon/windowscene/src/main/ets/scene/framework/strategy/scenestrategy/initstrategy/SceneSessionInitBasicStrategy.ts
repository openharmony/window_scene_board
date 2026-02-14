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
import { SceneDataOfBasic } from '../../../sessiondata/SceneDataOfBasic';
import { SceneDataOfMissionManagement } from '../../../sessiondata/SceneDataOfMissionManagement';
import { SceneStateOfBasic } from '../../../sessionstate/SceneStateOfBasic';
import { ISceneSessionInitStrategy } from './SceneSessionInitializer';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ContainerSessionInitBasicStrategy';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * 窗口基础数据初始化策略
 */
export class SceneSessionInitBasicStrategy implements ISceneSessionInitStrategy {
  public static getInstance(): SceneSessionInitBasicStrategy {
    if (!globalThis.SceneSessionInitBasicStrategy) {
      globalThis.SceneSessionInitBasicStrategy = new SceneSessionInitBasicStrategy();
    }
    return globalThis.SceneSessionInitBasicStrategy;
  }

  public init(sceneSession: SCBSceneSession): void {
    log.showInfo(`Initialize the basic data state and mission management data status of the sceneSession.`);
    sceneSession.registerData(new SceneDataOfBasic());
    sceneSession.registerData(new SceneDataOfMissionManagement());
    sceneSession.registerState(new SceneStateOfBasic(sceneSession));
  }
}