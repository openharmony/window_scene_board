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
import { SCBSceneContainer } from './SCBSceneContainer';
import { SCBScreenProperty, SCBSceneContainerSession, ScenePanelState, SCBSpecificSession } from '@ohos/windowscene';
import { SingleContext } from '@ohos/basicutils';


@Component
export struct SCBSceneContainerRefresh {
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  @Link screenProperty: SCBScreenProperty;
  @Prop singleContext?: SingleContext;
  @Link isExitSplit: boolean;
  @Prop isPairSplit: boolean = false;
  @Link scenePanelState: ScenePanelState;
  onGestureChange: Function = (): void => {};
  getToggleHomeScene: Function = (screenId: number): Array<SCBSceneContainerSession | SCBSpecificSession> => [];
  addToToggleHomeScene: Function = (session: SCBSpecificSession): void => {};
  getScreenDpiDensity: Function = (): number => 0;
  onSceneRectChange: Function = (): void => {};
  deleteSceneCardInRecent: Function = (): void => {};

  build() {
    SCBSceneContainer({
      sceneContainerSession: this.sceneContainerSession,
      dividerParam: this.sceneContainerSession.dividerParam,
      screenProperty: $screenProperty,
      singleContext: this.singleContext,
      onGestureChange: this.onGestureChange,
      onSceneRectChange: this.onSceneRectChange,
      isExitSplit: $isExitSplit,
      isPairSplit: this.isPairSplit,
      needRenderScale: this.sceneContainerSession.needRenderScale,
      needRenderBlurRadius: this.sceneContainerSession.needRenderBlurRadius,
      needRenderAlpha: this.sceneContainerSession.needRenderAlpha,
      needRenderShowInRecent: this.sceneContainerSession.needRenderShowInRecent,
      needRenderRecentSceneBorderRadius: this.sceneContainerSession.needRenderRecentSceneBorderRadius,
      needRenderRecentDeleteScale: this.sceneContainerSession.needRenderRecentDeleteScale,
      needRenderRecentDeleteTranslate: this.sceneContainerSession.needRenderRecentDeleteTranslate,
      needRenderRecentClosingAnimating: this.sceneContainerSession.needRenderRecentClosingAnimating,
      needRenderSplitBackgroundColor: this.sceneContainerSession.needRenderSplitBackgroundColor,
      needRenderRecentMinBackgroundShow: this.sceneContainerSession.needRenderRecentMinBackgroundShow,
      needRenderSubSceneShow: this.sceneContainerSession.needRenderSubSceneShow,
      needRenderZIndex: this.sceneContainerSession.needRenderZIndex,
      getScreenDpiDensity: this.getScreenDpiDensity,
      needRenderRecentHoverState: this.sceneContainerSession.needRenderRecentHoverState,
      scenePanelState: $scenePanelState,
      deleteSceneCardInRecent: this.deleteSceneCardInRecent
    })
  }
}
