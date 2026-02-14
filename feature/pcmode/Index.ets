/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

export { sPcModeUtils } from './src/main/ets/utils/SCBPcModeUtils';
export { SCBFreeWindowsViewModelManager } from './src/main/ets/SCBFreeWindowsViewModelManager'
export { SCBPcScenePanelManager, SpecificSessionController } from './src/main/ets/instance/SCBPcScenePanelManager'
export { IFreeWindowsViewModel } from './src/main/ets/presenter/IFreeWindowsViewModel';
export { SCBScenePanelProxy } from './src/main/ets/presenter/SCBScenePanelProxy';
export { PolicyType,
  ViewModelType,
  ExitSplitParam,
  ScreenForm,
  RealScreenInfo,
  MonitorExitSplitName,
  WindowSizeLimits} from './src/main/ets/constants/BaseConstants';
export { SCBSessionListManager, PcSCBSceneContainerSessionArray } from './src/main/ets/instance/SCBSessionListManager';
export { SwipeGestureManager } from './src/main/ets/instance/SwipeGestureManager';
export { SwipeGestureDirection } from './src/main/ets/constants/SwipeGestureDirection';
export { SCBPCSceneMissionProcessor } from './src/main/ets/scenemanager/SCBPCSceneMissionProcessor';
export { sceneAnimationManager } from './src/main/ets/instance/SceneAnimationManager';
export { SystemAnimatedScene } from './src/main/ets/constants/SystemAnimatedScene';
export { systemAniSceneCtrl } from './src/main/ets/utils/SystemAnimatedSceneController';
export { SessionTempList, SessionTempListGroupNames } from './src/main/ets/utils/SessionTempListUtils'
export { SCBSystemSceneUtils } from './src/main/ets/utils/SCBSystemSceneUtils';
export { DividerStyle } from './src/main/ets/constants/DividerStyleConstants';
export { SCBSplitLayoutHelper } from './src/main/ets/utils/SCBSplitLayoutHelper';
export { AttractionAnimController } from './src/main/ets/animation/AttractionAnimController';
export { SCBSceneSnapShot } from './src/main/ets/scenemanager/SCBSceneSnapShot';
export { SCBSceneHelper } from './src/main/ets/utils/SCBSceneHelper';
export { LayoutConstants, SubWindowChangeReason } from './src/main/ets/constants/LayoutConstants';
export { LayoutPolicyHelper } from './src/main/ets/layout/LayoutPolicyHelper';