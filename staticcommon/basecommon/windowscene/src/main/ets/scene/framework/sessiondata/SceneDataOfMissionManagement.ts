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
import { SceneDataCategory } from '../../common/SCBSceneEnums';
import { ISceneData } from './ISceneData';
import sceneSessionManager from '@ohos.sceneSessionManager';

const TAG = 'SceneDataOfMissionManagement';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const DEFAULT_TASK_ID: number = -1;

/**
 * MissionManagement data of SCBScene
 */
export class SceneDataOfMissionManagement implements ISceneData {
  public category: SceneDataCategory = SceneDataCategory.MISSION_MANAGEMENT;

  public isNewWant: boolean = true;
  public sessionState: sceneSessionManager.SessionState;
  public isShowWhenLocked: boolean = false;
  public isActive: boolean = false;
  isShowAboveKeyguard: boolean = false;
  isTemporarilyShowWhenLocked: boolean = false;
  // whether session is foregrounding
  isForegrounding: boolean = false;
  // timeout task id
  foregroundingTimeoutTaskId: number = DEFAULT_TASK_ID;
  pendingRemove: boolean = false;
  lastUsedTimestamp: number;

  // mark scene is about to transfer
  public isPopoutDisappearing: boolean = false;

  // mark sceneSession on which panel
  public onWhichPanel: number;
}