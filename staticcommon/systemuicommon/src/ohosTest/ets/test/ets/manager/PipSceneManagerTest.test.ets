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
import { Singleton } from '../../../main/ets/utils/Singleton';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../../../main/ets/live/model/LiveNotification';
import { SCBSceneContainerSession } from '@ohos/windowscene';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { PipSceneManager } from '../../../main/ets/manager/PipSceneManager';
export default function PipSceneManagerTest() {
  describe('addPipScene_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_add_pip_scene', 0, async () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      pipscenemanager.addPipScene(scene);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_clear_previous_pip_scenes_when_add_pip_scene', 0, async () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      pipscenemanager.addPipScene(scene);

      expect(pipscenemanager.pipScenes.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_remove_pip_scene', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      scene.primarySession = new SCBSceneSession();
      scene.primarySession.sceneInfo = { bundleName: 'com.example.app' };

      pipscenemanager.removePipScene(scene);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_remove_scene_from_pipScenes_when_remove_pip_scene', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      scene.primarySession = new SCBSceneSession();
      scene.primarySession.sceneInfo = { bundleName: 'com.example.app' };

      pipscenemanager.removePipScene(scene);

      expect(pipscenemanager.pipScenes.has(scene)).assertFalse();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_return_false_when_live_is_not_media_player', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(false);
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(false);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_return_true_when_live_is_media_player_and_primary_session_matches', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(true);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();
      containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      containerSession.secondarySession = { sceneInfo: { bundleName: 'test2', appIndex: 2 } };
      pipscenemanager.pipScenes = [containerSession];
      live.creatorBundleName = 'test';
      live.appIndex = 1;
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(true);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_return_true_when_live_is_media_player_and_secondary_session_matches', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(true);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();
      containerSession.primarySession = { sceneInfo: { bundleName: 'test2', appIndex: 2 } };
      containerSession.secondarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      pipscenemanager.pipScenes = [containerSession];
      live.creatorBundleName = 'test';
      live.appIndex = 1;
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(true);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_return_false_when_live_is_media_player_and_no_session_matches', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(true);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();
      containerSession.primarySession = { sceneInfo: { bundleName: 'test2', appIndex: 2 } };
      containerSession.secondarySession = { sceneInfo: { bundleName: 'test3', appIndex: 3 } };
      pipscenemanager.pipScenes = [containerSession];
      live.creatorBundleName = 'test';
      live.appIndex = 1;
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(false);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_log_info_when_add_pip_scene', 0, async () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      pipscenemanager.addPipScene(scene);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_clear_previous_pip_scenes_when_add_pip_scene', 0, async () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      pipscenemanager.addPipScene(scene);

      expect(pipscenemanager.pipScenes.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_remove_pip_scene', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      scene.primarySession = new SCBSceneSession();
      scene.primarySession.sceneInfo = { bundleName: 'com.example.app' };

      pipscenemanager.removePipScene(scene);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_remove_scene_from_pipScenes_when_remove_pip_scene', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      scene.primarySession = new SCBSceneSession();
      scene.primarySession.sceneInfo = { bundleName: 'com.example.app' };

      pipscenemanager.removePipScene(scene);

      expect(pipscenemanager.pipScenes.has(scene)).assertFalse();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_return_false_when_live_is_not_media_player', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(false);
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(false);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_return_true_when_live_is_media_player_and_primary_session_matches', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(true);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();
      containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      containerSession.secondarySession = { sceneInfo: { bundleName: 'test2', appIndex: 2 } };
      pipscenemanager.pipScenes = [containerSession];
      live.creatorBundleName = 'test';
      live.appIndex = 1;
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(true);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_return_true_when_live_is_media_player_and_secondary_session_matches', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(true);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();
      containerSession.primarySession = { sceneInfo: { bundleName: 'test2', appIndex: 2 } };
      containerSession.secondarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      pipscenemanager.pipScenes = [containerSession];
      live.creatorBundleName = 'test';
      live.appIndex = 1;
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(true);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_return_false_when_live_is_media_player_and_no_session_matches', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(true);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();
      containerSession.primarySession = { sceneInfo: { bundleName: 'test2', appIndex: 2 } };
      containerSession.secondarySession = { sceneInfo: { bundleName: 'test3', appIndex: 3 } };
      pipscenemanager.pipScenes = [containerSession];
      live.creatorBundleName = 'test';
      live.appIndex = 1;
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(false);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });
    it('should_log_info_when_add_pip_scene', 0, async () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      pipscenemanager.addPipScene(scene);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_clear_previous_pip_scenes_when_add_pip_scene', 0, async () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      pipscenemanager.addPipScene(scene);

      expect(pipscenemanager.pipScenes.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_remove_pip_scene', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      scene.primarySession = new SCBSceneSession();
      scene.primarySession.sceneInfo = { bundleName: 'com.example.app' };

      pipscenemanager.removePipScene(scene);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_remove_scene_from_pipScenes_when_remove_pip_scene', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      scene.primarySession = new SCBSceneSession();
      scene.primarySession.sceneInfo = { bundleName: 'com.example.app' };

      pipscenemanager.removePipScene(scene);

      expect(pipscenemanager.pipScenes.has(scene)).assertFalse();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_return_false_when_live_is_not_media_player', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(false);
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(false);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_return_true_when_live_is_media_player_and_primary_session_matches', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(true);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();
      containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      containerSession.secondarySession = { sceneInfo: { bundleName: 'test2', appIndex: 2 } };
      pipscenemanager.pipScenes = [containerSession];
      live.creatorBundleName = 'test';
      live.appIndex = 1;
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(true);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_return_true_when_live_is_media_player_and_secondary_session_matches', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(true);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();
      containerSession.primarySession = { sceneInfo: { bundleName: 'test2', appIndex: 2 } };
      containerSession.secondarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      pipscenemanager.pipScenes = [containerSession];
      live.creatorBundleName = 'test';
      live.appIndex = 1;
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(true);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_return_false_when_live_is_media_player_and_no_session_matches', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(true);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();
      containerSession.primarySession = { sceneInfo: { bundleName: 'test2', appIndex: 2 } };
      containerSession.secondarySession = { sceneInfo: { bundleName: 'test3', appIndex: 3 } };
      pipscenemanager.pipScenes = [containerSession];
      live.creatorBundleName = 'test';
      live.appIndex = 1;
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(false);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });
    it('should_log_info_when_add_pip_scene', 0, async () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      pipscenemanager.addPipScene(scene);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_clear_previous_pip_scenes_when_add_pip_scene', 0, async () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      pipscenemanager.addPipScene(scene);

      expect(pipscenemanager.pipScenes.length).assertEqual(1);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_remove_pip_scene', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      scene.primarySession = new SCBSceneSession();
      scene.primarySession.sceneInfo = { bundleName: 'com.example.app' };

      pipscenemanager.removePipScene(scene);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_remove_scene_from_pipScenes_when_remove_pip_scene', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      let scene: SCBSceneContainerSession = new SCBSceneContainerSession(new SCBSceneSession(), new SCBScreenProperty());
      scene.primarySession = new SCBSceneSession();
      scene.primarySession.sceneInfo = { bundleName: 'com.example.app' };

      pipscenemanager.removePipScene(scene);

      expect(pipscenemanager.pipScenes.has(scene)).assertFalse();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });


    it('should_return_false_when_live_is_not_media_player', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(false);
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(false);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_return_true_when_live_is_media_player_and_primary_session_matches', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(true);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();
      containerSession.primarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      containerSession.secondarySession = { sceneInfo: { bundleName: 'test2', appIndex: 2 } };
      pipscenemanager.pipScenes = [containerSession];
      live.creatorBundleName = 'test';
      live.appIndex = 1;
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(true);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });

    it('should_return_true_when_live_is_media_player_and_secondary_session_matches', 0, () => {
      let pipscenemanager: PipSceneManager = new PipSceneManager();
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isMediaPlayer);
      when(mockfunc)([]).afterReturn(true);
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession();
      containerSession.primarySession = { sceneInfo: { bundleName: 'test2', appIndex: 2 } };
      containerSession.secondarySession = { sceneInfo: { bundleName: 'test', appIndex: 1 } };
      pipscenemanager.pipScenes = [containerSession];
      live.creatorBundleName = 'test';
      live.appIndex = 1;
      const result = pipscenemanager.isPipLive(live);
      expect(result).assertEqual(true);
      mocker.ignoreMock(live, live.isMediaPlayer);
    });
  });
}
