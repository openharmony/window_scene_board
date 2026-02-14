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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { SCBSceneSession } from '../../../TsIndex';
import { SceneStateCategory } from '../../common/SCBSceneEnums';
import { ScbNumber } from '../../session/SCBSessionRect';
import { ISceneState } from './ISceneState';

const TAG = 'SceneStateOfBasic';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Basic UI state of SCBScene
 */
@Observed
export class SceneStateOfBasic implements ISceneState {
  readonly category: SceneStateCategory = SceneStateCategory.BASIC;
  sceneSession: SCBSceneSession;

  width: ScbNumber = new ScbNumber();
  height: ScbNumber = new ScbNumber();
  visibility: boolean = true;

  constructor(sceneSession: SCBSceneSession) {
    this.sceneSession = sceneSession;
  }
}