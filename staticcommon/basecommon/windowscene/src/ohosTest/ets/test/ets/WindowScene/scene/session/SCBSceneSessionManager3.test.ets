/*
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
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when,
} from '@ohos/hypium';
import BundleManager from '@ohos.bundle.bundleManager';
import { SCBSceneInfo } from '../../../../../../../..';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSceneSessionManager } from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import { SystemSessionInfo } from '../../../../../../../../';
import { SCBSceneContainerSessionArray } from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';

export function SCBSceneSessionManagerTest3() {
  describe('SCBSceneSessionManagerTest3', () => {

    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('processRecover_invalidPersistentId', 0, () => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      manager.processRecover(1, 0);
    });

    it('pairSplitFromDock_specified_launchType', 0, () => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('notifySessionExceptionBundleName',
        'notifySessionExceptionModuleName', 'notifySessionExceptionBundleName');

      sceneInfo.launchType = BundleManager.LaunchType.SPECIFIED;
      manager.pairSplitFromDock(1, 1, sceneInfo);

      sceneInfo.launchType = BundleManager.LaunchType.MULTITON;
      manager.pairSplitFromDock(1, 1, sceneInfo);

      sceneInfo.launchType = BundleManager.LaunchType.SINGLETON;
      manager.pairSplitFromDock(1, 1, sceneInfo);
    });

    it('requestFocus_persistentId_undefined', 0, async (done: Function) => {
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(scbSceneSessionManager).not().assertNull();
      scbSceneSessionManager.requestFocus(undefined);
      done();
    });

    it('requestFocus_persistentId_defined', 0, async (done: Function) => {
      let scbSceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(scbSceneSessionManager).not().assertNull();
      scbSceneSessionManager.requestFocus(1);
      done();
    });

    it('resetLastStatusBarProperty_test_001', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      manager.resetLastStatusBarProperty();
      done();
    });

    it('registerSystemBarPropertyCallbacks_test_01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const func1 = () => {
        return false;
      }
      const func2 = () => {
        return true;
      }

      manager.registerSystemBarPropertyCallbacks(func1);
      manager.registerSystemBarPropertyCallbacks(func2);
      manager.registerSystemBarPropertyCallbacks(func1);
      done();
    });

    it('unRegisterSystemBarPropertyCallbacks_test_01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const func1 = () => {
        return false;
      }
      const func2 = () => {
        return true;
      }

      manager.registerSystemBarPropertyCallbacks(func1);
      manager.registerSystemBarPropertyCallbacks(func2);

      manager.unRegisterSystemBarPropertyCallbacks(func1);
      manager.unRegisterSystemBarPropertyCallbacks(func1);
      done();
    });


    it('unRegisterSystemBarPropertyRecentCallbacks_test_01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const func1 = () => {
        return false;
      }
      const func2 = () => {
        return true;
      }

      manager.registerSystemBarPropertyRecentCallbacks(func1);
      manager.registerSystemBarPropertyRecentCallbacks(func2);
      manager.registerSystemBarPropertyRecentCallbacks(func1);

      manager.unRegisterSystemBarPropertyRecentCallbacks(func1);
      manager.unRegisterSystemBarPropertyRecentCallbacks(func1);
      done();
    });

    it('unregisterUpdateScenePanelStateCallback_test_01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const func1 = () => {
        return false;
      }
      const func2 = () => {
        return true;
      }

      manager.registerUpdateScenePanelStateCallback(1, 1, func1);
      manager.registerUpdateScenePanelStateCallback(1, 1, func1);
      manager.registerUpdateScenePanelStateCallback(2, 2, func2);

      manager.unregisterUpdateScenePanelStateCallback(1, 1);
      manager.unregisterUpdateScenePanelStateCallback(2, 3);
      manager.unregisterUpdateScenePanelStateCallback(3, 3);
      done();
    });

    it('requestSystemSceneSession_test_01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let sessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_APP,
        sceneName: 'test',
        sceneZIndex: 0,
        hitTestMode: HitTestMode.Default,
        windowInputType: 1,
      };
      let systemSceneSession = manager.requestSystemSceneSession(sessionInfo);
      manager.requestSystemSceneSessionDestruction(systemSceneSession);
      manager.requestSystemSceneSessionDestruction(systemSceneSession, 1);
      done();
    });

    it('onRemoveContainerSession_test', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      manager.onRemoveContainerSession(1);
      const func1 = () => {
        return false;
      }
      manager.registerRemoveContainerSessionCallback(func1, 1);
      manager.onRemoveContainerSession(1);
      manager.onRemoveContainerSession(2);
      done();
    });

    it('onRemoveSpecialContainerSession_test_001', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const func1 = () => {
        return false;
      }
      let expectRes = new SCBSceneContainerSessionArray();
      let res = manager.onRemoveSpecialContainerSession();
      expect(res).assertDeepEquals(expectRes);

      manager.registerRemoveSpecialContainerSessionCallback(func1);
      res = manager.onRemoveSpecialContainerSession();
      expect(res).not().assertNull();
      done();
    });

    it('notifyContainerSessionChangeReqOrientation_test_001', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      manager.notifyContainerSessionChangeReqOrientation(0, 0, 0);
      done();
    });

    it('notifyFullScreenTitleBarAppear_test', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      manager.notifyFullScreenTitleBarAppear();
      const func1 = () => {
        return false;
      }
      manager.registerFullScreenTitleBarAppearCallback(func1);
      manager.notifyFullScreenTitleBarAppear();
      done();
    });

    it('isDesktopNeedProcessFloatWindow_testCase_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockGetSessionById: Function = mocker.mockFunc(manager, manager.getSessionById);
      when(mockGetSessionById)(ArgumentMatchers.any).afterReturn({
        session: {
          type: sceneSessionManager.SessionType.TYPE_SYSTEM_FLOAT
        }
      });
      let result = manager.isDesktopNeedProcessFloatWindow();
      expect(result).assertEqual(false);
      mocker.ignoreMock(manager, manager.getSessionById);
      done();
    });

    it('isDesktopNeedProcessFloatWindow_testCase_2', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockGetSessionById: Function = mocker.mockFunc(manager, manager.getSessionById);
      when(mockGetSessionById)(ArgumentMatchers.any).afterReturn({
        session: {
          type: sceneSessionManager.SessionType.TYPE_APP
        }
      });
      let result = manager.isDesktopNeedProcessFloatWindow();
      expect(result).assertEqual(false);
      mocker.ignoreMock(manager, manager.getSessionById);
      done();
    });

    it('processSystemBackEventTest01', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let mockFunc1 : Function = mocker.mockFunc(manager, manager.isDesktopNeedProcessFloatWindow);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let res = manager.processSystemBackEvent();
      expect(res).assertTrue();
      mocker.ignoreMock(manager, manager.isDesktopNeedProcessFloatWindow);
      done();
    });

    it('processSystemBackEventTest02', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let mockFunc1 : Function = mocker.mockFunc(manager, manager.isDesktopNeedProcessFloatWindow);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2 : Function = mocker.mockFunc(manager, manager.getSystemSceneSessionWithId);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      let res = manager.processSystemBackEvent();
      expect(res).assertFalse();
      mocker.ignoreMock(manager, manager.isDesktopNeedProcessFloatWindow);
      mocker.ignoreMock(manager, manager.getSystemSceneSessionWithId);
      done();
    });

    it('registerGlobalSearchExitCallbackTest', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      manager.registerGlobalSearchExitCallback(null);

      let expectWithAnimation: boolean = false;
      const callback = (withAnimation: boolean): void => {
        expectWithAnimation = withAnimation;
      }
      manager.registerGlobalSearchExitCallback(callback);
      let globalSearchExitCallback: Function = Reflect.get(manager, "globalSearchExitCallback");
      expect(globalSearchExitCallback).assertEqual(callback);
      manager.notifyGlobalSearchExit();
      expect(expectWithAnimation).assertTrue();
      manager.notifyGlobalSearchExit(false);
      expect(expectWithAnimation).assertFalse();
      manager.unregisterGlobalSearchExitCallback();
      globalSearchExitCallback = Reflect.get(manager, "globalSearchExitCallback");
      expect(globalSearchExitCallback).assertEqual(null);
      done();
    });
  });
}