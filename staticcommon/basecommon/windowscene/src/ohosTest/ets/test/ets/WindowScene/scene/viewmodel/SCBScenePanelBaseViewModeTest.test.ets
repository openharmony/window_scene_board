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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  when,
} from '@ohos/hypium'
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneMissionEvent,
  SCBScenePanelBaseViewModel,
  SCBSceneSession,
  SCBScreenProperty,
} from '../../../../../../../main/ets/TsIndex';
import { ReflectionUtils } from '../../utils/ReflectionUtils';
import {
  BasicSceneMissionTemplate
} from '../../../../../../../main/ets/scene/framework/missiontemplate/BasicSceneMissionTemplate';

const TAG = 'SCBScenePanelBaseViewModel';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export function SCBScenePanelBaseViewModelTest() {
  describe('SCBScenePanelBaseViewModel_addSceneContainerSession_testSuite', () => {
    let vm: SCBScenePanelBaseViewModel =
      new SCBScenePanelBaseViewModel(new SCBScreenProperty(), new SCBSceneContainerSessionArray());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testAdd', 'testAdd', 'testAdd', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    afterAll(() => {
      let containerSessionList: SCBSceneContainerSessionArray = ReflectionUtils.getProperty(vm, 'containerSessionList');
      containerSessionList.forEach((containerSession) => {
        containerSession.requestDestruction(true);
      });
      containerSessionList.clear();
    })

    it('test_whenAddNewSceneContainerSession_thenSuccess', Level.LEVEL0, () => {
      expect(ReflectionUtils.getProperty(vm, 'containerSessionList').length).assertEqual(0);

      vm.addSceneContainerSession(containerSession);
      expect(ReflectionUtils.getProperty(vm, 'containerSessionList').length).assertEqual(1);
    });

    it('test_whenAddExistentSceneContainerSession_thenAddFail', Level.LEVEL0, () => {
      let length: number = ReflectionUtils.getProperty(vm, 'containerSessionList').length;
      let container = vm.getContainerSessionByPersistentIdOrContainerId(undefined, containerSession.containerId);
      expect(container).assertDeepEquals(containerSession)

      vm.addSceneContainerSession(containerSession);
      expect(ReflectionUtils.getProperty(vm, 'containerSessionList').length).assertEqual(length);
    });
  });

  describe('SCBScenePanelBaseViewModel_removeSceneContainerSession_testSuite', () => {
    let vm: SCBScenePanelBaseViewModel =
      new SCBScenePanelBaseViewModel(new SCBScreenProperty(), new SCBSceneContainerSessionArray());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testAdd', 'testAdd', 'testAdd', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    afterAll(() => {
      let containerSessionList: SCBSceneContainerSessionArray = ReflectionUtils.getProperty(vm, 'containerSessionList');
      containerSessionList.forEach((containerSession) => {
        containerSession.requestDestruction(true);
      });
      containerSessionList.clear();
    })

    it('test_whenAddNewSceneContainerSession_thenSuccess', Level.LEVEL0, () => {
      expect(ReflectionUtils.getProperty(vm, 'containerSessionList').length).assertEqual(0);

      vm.addSceneContainerSession(containerSession);
      expect(ReflectionUtils.getProperty(vm, 'containerSessionList').length).assertEqual(1);
    });

    it('test_whenAddExistentSceneContainerSession_thenAddFail', Level.LEVEL0, () => {
      let length: number = ReflectionUtils.getProperty(vm, 'containerSessionList').length;
      let container = vm.getContainerSessionByPersistentIdOrContainerId(undefined, containerSession.containerId);
      expect(container).assertDeepEquals(containerSession)

      vm.addSceneContainerSession(containerSession);
      expect(ReflectionUtils.getProperty(vm, 'containerSessionList').length).assertEqual(length);
    });
  });

  describe('SCBScenePanelBaseViewModel_getContainerSessionByPersistentIdOrContainerId_testSuite', () => {
    let vm: SCBScenePanelBaseViewModel =
      new SCBScenePanelBaseViewModel(new SCBScreenProperty(), new SCBSceneContainerSessionArray());
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testAdd', 'testAdd', 'testAdd', 0, 9527);
    let sceneSession: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let containerSession: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

    afterAll(() => {
      let containerSessionList: SCBSceneContainerSessionArray = ReflectionUtils.getProperty(vm, 'containerSessionList');
      containerSessionList.forEach((containerSession) => {
        containerSession.requestDestruction(true);
      });
      containerSessionList.clear();
    })

    it('test_whenNotFind_thenReturnNull', Level.LEVEL0, () => {
      let containerSession: SCBSceneContainerSession | null = vm.getContainerSessionByPersistentIdOrContainerId(11,11);
      expect(containerSession).assertNull();
    });

    it('test_whenFindByPersistentId_thenSuccess', Level.LEVEL0, () => {
      vm.addSceneContainerSession(containerSession);
      let res: SCBSceneContainerSession | null =
        vm.getContainerSessionByPersistentIdOrContainerId(containerSession?.primarySession?.sceneInfo.persistentId);
      expect(res).assertDeepEquals(containerSession);
    });

    it('test_whenFindByContainerId_thenSuccess', Level.LEVEL0, () => {
      vm.addSceneContainerSession(containerSession);
      let res: SCBSceneContainerSession | null =
        vm.getContainerSessionByPersistentIdOrContainerId(undefined, containerSession.containerId);
      expect(res).assertDeepEquals(containerSession);
    });
  });

  describe('SCBScenePanelBaseViewModel_raiseSceneToTop_testSuite', () => {
    let vm: SCBScenePanelBaseViewModel =
      new SCBScenePanelBaseViewModel(new SCBScreenProperty(), new SCBSceneContainerSessionArray());
    let sceneInfo01: SCBSceneInfo = new SCBSceneInfo('testAdd01', 'testAdd01', 'testAdd01', 0, 9527);
    let sceneInfo02: SCBSceneInfo = new SCBSceneInfo('testAdd02', 'testAdd02', 'testAdd02', 0, 9528);
    let sceneSession01: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo01), sceneInfo01);
    let sceneSession02: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo02), sceneInfo02);
    let containerSession01: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession01, new SCBScreenProperty());
    let containerSession02: SCBSceneContainerSession =
      new SCBSceneContainerSession(sceneSession02, new SCBScreenProperty());
    vm.addSceneContainerSession(containerSession01);
    vm.addSceneContainerSession(containerSession02);

    afterAll(() => {
      let containerSessionList: SCBSceneContainerSessionArray = ReflectionUtils.getProperty(vm, 'containerSessionList');
      containerSessionList.forEach((containerSession) => {
        containerSession.requestDestruction(true);
      });
      containerSessionList.clear();
    })

    it('test_whenRaiseExistedScene_thenSuccess', Level.LEVEL0, () => {
      let containerSessionList: SCBSceneContainerSessionArray = ReflectionUtils.getProperty(vm, 'containerSessionList');
      expect(containerSessionList.getTopSession()).assertDeepEquals(containerSession02);

      vm.raiseSceneToTop(containerSession01);
      expect(containerSessionList.getTopSession()).assertDeepEquals(containerSession01);
    });
  });

  describe('SCBScenePanelBaseViewModel_registerAndGetMissionTemplate_testSuite', () => {
    let vm: SCBScenePanelBaseViewModel =
      new SCBScenePanelBaseViewModel(new SCBScreenProperty(), new SCBSceneContainerSessionArray());
    class Tes01Template implements BasicSceneMissionTemplate {
      public get process(): Function {
        return () => {
          return 1;
        };
      }
    }
    class Tes02Template implements BasicSceneMissionTemplate {
      public get process(): Function {
        return () => {
          return 2;
        };
      }
    }

    it('test_whenAddMissionTemplate_thenSuccess', Level.LEVEL0, () => {
      vm.registerMissionTemplate(SCBSceneMissionEvent.START_SCENE_FROM_OTHER, new Tes01Template());
      vm.registerMissionTemplate(SCBSceneMissionEvent.START_SCENE_FROM_VIRTUAL, new Tes02Template());

      let template01: Function = vm.getMissionProcessor(SCBSceneMissionEvent.START_SCENE_FROM_OTHER);
      expect(template01()).assertEqual(1);
      let template02: Function = vm.getMissionProcessor(SCBSceneMissionEvent.START_SCENE_FROM_VIRTUAL);
      expect(template02()).assertEqual(2);
    });
  });
}