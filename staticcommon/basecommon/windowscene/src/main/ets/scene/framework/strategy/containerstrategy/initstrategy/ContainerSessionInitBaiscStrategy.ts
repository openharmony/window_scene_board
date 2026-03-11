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
import { ContainerDataOfBasic } from '../../../containerdata/ContainerDataOfBasic';
import { ContainerDataOfMissionManagement } from '../../../containerdata/ContainerDataOfMissionManagement';
import { ContainerStateOfMissionManagement } from '../../../containerstate/ContainerStateOfMissionManagement';
import { ContainerStateOfBasic } from '../../../containerstate/ContainerStateOfBasic';
import { IContainerSessionInitStrategy } from './ContainerSessionInitializer';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ContainerSessionInitBasicStrategy';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * 窗口容器基础数据初始化策略
 */
export class ContainerSessionInitBasicStrategy implements IContainerSessionInitStrategy {
  public static getInstance(): ContainerSessionInitBasicStrategy {
    if (!globalThis.ContainerSessionInitBasicStrategy) {
      globalThis.ContainerSessionInitBasicStrategy = new ContainerSessionInitBasicStrategy();
    }
    return globalThis.ContainerSessionInitBasicStrategy;
  }

  public init(containerSession: SCBSceneContainerSession): void {
    log.showInfo(`Initialize the basic data state and mission management data status of the containerSession.`);
    containerSession.registerData(new ContainerDataOfBasic());
    containerSession.registerData(new ContainerDataOfMissionManagement());
    containerSession.registerState(new ContainerStateOfMissionManagement());
    containerSession.registerState(new ContainerStateOfBasic());
  }
}