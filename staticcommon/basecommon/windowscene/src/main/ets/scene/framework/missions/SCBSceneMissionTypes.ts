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
import { ExecuteCallbackExtraInfo, SCBSceneContainerSession, SCBSceneSession } from '../../../TsIndex';

export interface SCBMainSessionTuple {
  sceneSession: SCBSceneSession | null;
  containerSession: SCBSceneContainerSession | null;
}

/**
 * Scene Mission Management Event
 */
export enum SCBSceneMissionType {
  START_SCENE = 0,
  // process start by one scene
  START_SCENE_FROM_OTHER,
  // process start by two scenes
  START_SCENE_TRANSITION,

  MINIMIZE_SCENE = 10,

  FOREGROUND_SCENE = 20,

  TERMINATE_SCENE = 30,
  TERMINATE_ALL_SCENE,
  EXCEPTION,

  // transfer scenes
  POP_SCENE_OUT,
  PUSH_SCENE_IN,
}

export interface SCBStartSceneOpts {
  startFrom: string; // fromIcon, fromOther or else... will reorganized
  params?: Record<string, Object>;
}

export interface SCBTransitionSceneOpts {
  isBackTransition: boolean;
}

export interface SCBMinimizeSceneOpts {
  needRemoveSession?: boolean;
  shouldBackToCaller?: boolean;
  extraInfo?: ExecuteCallbackExtraInfo;
  needBackground?: boolean;
}

export interface SCBTerminateSceneOpts {
  needRemoveSession: boolean;
  shouldBackToCaller: boolean;
  extraInfo?: ExecuteCallbackExtraInfo;
}

export interface SCBTransferSceneOpts {
  needRefreshFocus?: boolean; // 迁移前后是否刷新focus, popOut:unFocus, pushIn:focus
  needBackground?: boolean; // 迁移前是否在当前Screen-Panel中退后台
  needUpdateScreenId?: boolean; // 迁移前是否更新ScreenId
  params?: Record<string, Object>;
  transferFinishedCallback?: (session: SCBSceneSession) => void; // 迁移流程中通知迁移下树时机，适配有动效场景
}

export interface SCBRequestSessionOpts {
  popFromOtherScreen: boolean;
  backgroundBeforePop: boolean;
}

export interface MainSessionDestructionOpts {
  isDeletePersistentMap: boolean;
  isSaveSnapshot?: boolean;
  isForceClean?: boolean;
  isUserRequestedExit?: boolean;
}