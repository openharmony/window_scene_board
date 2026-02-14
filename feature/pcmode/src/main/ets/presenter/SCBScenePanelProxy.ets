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

import {
  ExecuteCallbackExtraInfo,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession, SCBSystemSceneSession, ScenePanelState } from '@ohos/windowscene';

/**
 * ScenePanel代理接口, 用于直接处理scenePanel未下沉的业务
 */
export interface SCBScenePanelProxy {
  // ----------------------------------------------------------------------------------------------------
  // scenePanel
  // ----------------------------------------------------------------------------------------------------
  getSysSceneSession: () => SCBSystemSceneSession;
  getScroller: () => Scroller;
  getScenePanelState: () => ScenePanelState;
  updateScenePanelState: (state: ScenePanelState) => void;
  setIsPairSplit: (isPairSplit: boolean) => void;
  getScreenDpiDensity: () => number;
  enterSplitView: (container: SCBSceneContainerSession, isSplitRecentPrimary: boolean) => void;
  isOpenFromPopup: () => boolean;
  getCardWidth: () => number;
  getCardPositionX: () => number;
  getCardPositionY: () => number;
  isRecycleBin: (sceneInfo?: SCBSceneInfo, extraInfo?: ExecuteCallbackExtraInfo) => boolean;
  setRecentDataList: (isNeedHideAppCenter: boolean) => void;
  updateScreenDensity: (targetDensity: number) => void;
  updateRectToAvoidStatusBar: (session: SCBSceneSession) => void;

  // ----------------------------------------------------------------------------------------------------
  // 多任务
  // ----------------------------------------------------------------------------------------------------
  exitSplitRecentView: (isAnimateImmediately: boolean, isPairSplit: boolean) => void;
  exitSplitRecentViewIfNotShowRecent: () => void;
  exitRecentWhenStartSceneFromRecent: (container: SCBSceneContainerSession) => void;
  recentSceneCloseAnimate: (container: SCBSceneContainerSession) => void;
  updateRecentInfoAfterExitForSplit: (newContainer: SCBSceneContainerSession,
                                      curContainer: SCBSceneContainerSession,
                                      primarySession: SCBSceneSession,
                                      secondarySession: SCBSceneSession | null,
                                      isEnterPair: boolean) => void;
  refreshRecentInfo: () => void;
  exitRecentView: (needAnim: boolean) => void;
  exitAppCenterView: () => void;
  recentSceneResizeAnimate: () => void;
  handleHideCloseInRecent: (containerSession: SCBSceneContainerSession, sceneSession: SCBSceneSession,
    isFromClient: boolean) => void;
  recentOrSplitClose: (containerSession: SCBSceneContainerSession,
                       isException?: boolean,
                       isSaveSnapshot?: boolean,
                       extraInfo?: ExecuteCallbackExtraInfo) => void;
  minimizeSceneInRecent: (container: SCBSceneContainerSession) => void;
  raiseSceneToTopInRecent: (container: SCBSceneContainerSession) => void;
  setPairPersistentId: (persistentId: number) => void;
  sessionRectChangeInRecent: () => void;

  // ----------------------------------------------------------------------------------------------------
  // 侧边dock
  // ----------------------------------------------------------------------------------------------------
  addGestureDockRecentItem: (bundleName: string, appIndex: number) => void;
}