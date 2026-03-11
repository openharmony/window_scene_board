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

export enum BasicScenePanelState {
  DEFAULT = 0, // null scene on screen
  FULL_SCENE = 1, // a full scene on screen
}

@Observed
export class ScenePanelZIndex {
  public index: number = 100;
}

@Observed
export class ScenePanelBackground {
  public color = Color.White;
}

@Observed
export class ScenePanelVisibility {
  public visible: Visibility = Visibility.Visible;
}

@Observed
export class ScenePanelState {
  public state: BasicScenePanelState = BasicScenePanelState.DEFAULT;
}

/**
 * ScenePanel UI states
 */
@Observed
export class SCBScenePanelStateSession {
  public zIndex: ScenePanelZIndex = new ScenePanelZIndex();
  public background: ScenePanelBackground = new ScenePanelBackground();
  public visibility: ScenePanelVisibility = new ScenePanelVisibility();
}