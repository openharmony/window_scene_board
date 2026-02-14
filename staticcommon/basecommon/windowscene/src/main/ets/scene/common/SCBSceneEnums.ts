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

export enum ContainerDataCategory {
  BASIC,
  MISSION_MANAGEMENT,
  RECENT,
  FLOATING,
  MID_SCENE,
  SINGLE_POCKET
}

export enum ContainerStateCategory {
  BASIC,
  MISSION_MANAGEMENT,
}

export enum SceneDataCategory {
  BASIC,
  MISSION_MANAGEMENT,
}

export enum SceneStateCategory {
  BASIC,
  MISSION_MANAGEMENT,
}

export enum StartMode {
  MAIN_TASK = 1,
  RECENT_TASK
}

export enum BackgroundReason {
  DEFAULT,
  EXPAND_TO_FOLD_SINGLE_POCKET,
}