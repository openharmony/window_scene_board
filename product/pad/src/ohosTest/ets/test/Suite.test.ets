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

import { describe } from '@ohos/hypium';

import {
  basicLauncherForOhSuite,
  VoiceHiVoiceHAPSuite,
  ImmersiveKeyguardSuite,
  launcherComponentsSuite,
  LauncherNavigationForOhSuite,
  MultiwindowSuite,
  SceneboardAodSuite,
  sceneboardDesktopeditSuite,
  SceneBoardExtSuite,
  sceneboardFolderSuite,
  sceneboardFrameworkSuite,
  sceneboardMultitasksSuite
} from '@ohos/phonebase/src/ohosTest/ets/test/Suite.test';

export default function PipelineDemoSuite() {
  describe("sceneboard_aod", () => SceneboardAodSuite);

  describe('ImmersiveKeyguard', () => ImmersiveKeyguardSuite);

  // Phone中多任务模块的所有DT用例
  describe('sceneboard_multitasks', () => sceneboardMultitasksSuite);

  // 设备桌面导航
  describe('launcher_navigation_for_oh', () => LauncherNavigationForOhSuite);

  describe("sceneboard_folder", () => sceneboardFolderSuite);

  describe("multiwindow", () => MultiwindowSuite);

  describe("launcher_components", () => launcherComponentsSuite);

  describe("basic_launcher_for_oh", () => basicLauncherForOhSuite);

  // Phone中合一框架的所有DT用例
  describe('sceneboard_framework', () => sceneboardFrameworkSuite);

  // 意图框架
  describe('voice-HiVoiceHAP', () => VoiceHiVoiceHAPSuite);

  describe('window_scene_board', () => SceneBoardExtSuite);

  // 桌面编辑DT测试套
  describe("sceneboard_desktopedit", sceneboardDesktopeditSuite);
}