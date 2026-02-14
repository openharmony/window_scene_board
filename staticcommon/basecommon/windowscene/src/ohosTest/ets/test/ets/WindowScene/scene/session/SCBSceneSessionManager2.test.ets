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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium'
import {
  SCBSceneSessionManager,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScreenProperty,
  sSCBOobeManager,
  sSampleManager
} from '../../../../../../../..';
import { RectItem } from '@ohos/basicutils';

export function SCBSceneSessionManagerTest2() {
  describe('SCBSceneSessionManagerTest2', () => {
    const mocker: MockKit = new MockKit();
    // mock 系统接口
    const func1: Function = mocker.mockFunc(sSCBOobeManager, sSCBOobeManager.isOobeActivated);
    const func2: Function = mocker.mockFunc(sSCBOobeManager, sSCBOobeManager.isTrustlistForWms);
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('addActiveSessionList', 0, () => {
      SCBSceneSessionManager.getInstance().addActiveSessionList(233);
      expect(SCBSceneSessionManager.getInstance().checkActiveSessionListIsEmpty()).assertFalse();
    })

    it('getSceneContainerFromList', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const screenProperty: SCBScreenProperty = new SCBScreenProperty();

      const sceneInfo1: SCBSceneInfo = new SCBSceneInfo('getSceneContainerFromListBundle', 'getSceneContainerFromListModule', 'getSceneContainerFromListAbility');
      const sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
      const persistentId1: number = 111;

      const sceneInfo2: SCBSceneInfo = new SCBSceneInfo('getSceneContainerFromList2Bundle', 'getSceneContainerFromList2Module', 'getSceneContainerFromList2Ability');
      const sceneSession2: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
      const persistentId2: number = 222;

      const sceneContainerSession: SCBSceneContainerSession  = new SCBSceneContainerSession(sceneSession1, screenProperty);

      const sceneContainerSession2: SCBSceneContainerSession  = new SCBSceneContainerSession(sceneSession2, screenProperty);
      const containerList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerList.add(sceneContainerSession2);
      containerList.add(sceneContainerSession);


      const callback = () => {
        return containerList;
      };
      sceneSessionManager.registerGetSpecialContainerSessionListCallback(callback);
      const containerSession1 = sceneSessionManager.getSceneContainerSessionFromSpecialScenePanel(333);
      expect(containerSession1).assertNull();

      const containerSession2 = sceneSessionManager.getSceneContainerSessionFromSpecialScenePanel(persistentId2);
      expect(containerSession2).assertNull();
    })

    it('registerOnFocusedCallback', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let target: number = 1;

      const callback1: Function = () => {
        target = 2;
      };
      sceneSessionManager.registerOnFocusedCallback(callback1);
      expect(target).assertEqual(2);

      const callback2 = null;
      sceneSessionManager.registerOnFocusedCallback(callback2);
      expect(target).assertEqual(2);

      sceneSessionManager.unregisterOnFocusedCallback(callback1);

      const callback3: Function = () => {
        console.log('callback3');
      };
      sceneSessionManager.unregisterOnFocusedCallback(callback3);
      expect(target).assertEqual(2);
    })

    it('registerOnNtfFloatingWindowCallback', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let target: number = 1;

      const callback1: Function = () => {
        target = 2;
      };
      sceneSessionManager.registerOnNtfFloatingWindowCallback(callback1);
      sceneSessionManager.notifyNtfFloatingWindowCallback();
      expect(target).assertEqual(2);

      const callback2 = null;
      sceneSessionManager.unregisterOnNtfFloatingWindowCallback(callback2);
      expect(target).assertEqual(2);

      sceneSessionManager.registerOnUnfocusedCallback(callback1);
      sceneSessionManager.unregisterOnNtfFloatingWindowCallback(callback1);
      sceneSessionManager.notifyNtfFloatingWindowCallback();
      expect(target).assertEqual(2);
    })

    it('notifyNtfFloatingRect', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const rectItem: RectItem = new RectItem(0, 0, 4, 4);
      let target: number = 1;

      const callback1 = null;
      sceneSessionManager.registerOnGetFloatingRectCallback(callback1);
      sceneSessionManager.notifyNtfFloatingRect(rectItem);
      expect(target).assertEqual(1);

      const callback2 = () => {
        target = 2;
      };
      sceneSessionManager.registerOnGetFloatingRectCallback(callback2);
      sceneSessionManager.notifyNtfFloatingRect(rectItem);
      expect(target).assertEqual(2);
    })

    it('notifySessionException', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('notifySessionExceptionBundleName', 'notifySessionExceptionModuleName', 'notifySessionExceptionBundleName');
      let target: number = 1;
      const callback1 = null;
      const callback2 = () => {
        target = 2;
      };

      when(func1)(ArgumentMatchers.any).afterReturn(false);
      sceneSessionManager.registerSessionExceptionListener(callback1);
      sceneSessionManager.handleSessionException(true, sceneInfo);
      expect(target).assertEqual(1);

      sceneSessionManager.registerSessionExceptionListener(callback2);
      sceneSessionManager.handleSessionException(true, sceneInfo);
      expect(target).assertEqual(1);

      when(func1)(ArgumentMatchers.any).afterReturn(true);
      sceneSessionManager.handleSessionException(true, sceneInfo);
      sceneSessionManager.unRegisterSessionExceptionListener();
      expect(target).assertEqual(2);
    })

    it('notifyStartScene', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('notifyStartSceneBundle', 'notifyStartSceneModule', 'notifyStartSceneAbility');
      let target: number = 1;
      const callback1 = null;
      const callback2 = () => {
        target = 2;
      };

      sceneSessionManager.registerStartSceneListener(callback1);
      sceneSessionManager.startSceneFromOther(sceneInfo);
      expect(target).assertEqual(1);

      sceneSessionManager.registerStartSceneListener(callback2);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      sceneSessionManager.startSceneFromOther(sceneInfo);
      expect(target).assertEqual(2);
      sceneSessionManager.unregisterStartSceneListener();
    })

    it('notifyAnimationFinishedCallback', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let target: number = 1;
      const callback1 = null;
      const callback2 = () => {
        target = 2;
      };

      sceneSessionManager.registerOnAnimationFinishedCallback(callback1);
      sceneSessionManager.notifyAnimationFinishedCallback(true);
      expect(target).assertEqual(1);

      sceneSessionManager.registerOnAnimationFinishedCallback(callback2);
      sceneSessionManager.notifyAnimationFinishedCallback(true);
      expect(target).assertEqual(2);
    })

    it('notifyGrayAppIconCallback', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let target: number = 1;
      const callback1 = null;
      const callback2 = () => {
        target = 2;
      };

      const screenProperty: SCBScreenProperty = new SCBScreenProperty();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('grayAppIconBundle', 'grayAppIconModule', 'grayAppIconAbility');
      const sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      const sceneContainerSession: SCBSceneContainerSession  = new SCBSceneContainerSession(sceneSession, screenProperty);

      sceneSessionManager.registerGrayAppIconCallback(callback1);
      sceneSessionManager.notifyGrayAppIconCallback(sceneContainerSession, true);
      expect(target).assertEqual(1);

      sceneSessionManager.registerGrayAppIconCallback(callback2);
      sceneSessionManager.notifyGrayAppIconCallback(sceneContainerSession, true);
      expect(target).assertEqual(2);
    })

    it('registerOnUnfocusedCallback', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let target: number = 1;
      const callback1 = null;
      const callback2 = () => {
        target = 2;
      };

      sceneSessionManager.registerOnUnfocusedCallback(callback1);
      // 覆盖异常分支，注销一个未注册的函数
      sceneSessionManager.unregisterOnUnfocusedCallback(callback2);
      expect(target).assertEqual(1);

      sceneSessionManager.registerOnUnfocusedCallback(callback2);
      expect(target).assertEqual(2);
      sceneSessionManager.unregisterOnUnfocusedCallback(callback2);
    })

    it('startSceneInVirtual', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      sceneSessionManager.startSceneInVirtual(null);

      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('startSceneInVirtualBundle', 'startSceneInVirtualModule', 'startSceneInVirtualAbility');

      when(func1)(ArgumentMatchers.any).afterReturn(true);
      when(func2)(ArgumentMatchers.any).afterReturn(false);
      sceneSessionManager.startSceneInVirtual(sceneInfo);

      when(func1)(ArgumentMatchers.any).afterReturn(false);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      sceneSessionManager.startSceneInVirtual(sceneInfo);

      sceneSessionManager.storeCastTask(sceneInfo);
      sceneSessionManager.startSceneInVirtual(sceneInfo);
      expect(sceneSessionManager).not().assertNull();
    })

    it('requestSceneSession', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('requestSceneSessionBundle', 'requestSceneSessionModule', 'requestSceneSessionAbility');
      let sceneSession = sceneSessionManager.requestSceneSession(sceneInfo, false);
      expect(sceneSession).not().assertNull();

      const mocker: MockKit = new MockKit();
      // mock API接口
      const func1: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.requestSceneSession);
      when(func1)(ArgumentMatchers.any).afterReturn(null);
      sceneSession = sceneSessionManager.requestSceneSession(sceneInfo, false);
      expect(sceneSession).assertNull();
    })

    it('startSceneFromIcon', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('startSceneFromIconBundle', 'startSceneFromIconModule', 'startSceneFromIconAbility');

      when(func1)(ArgumentMatchers.any).afterReturn(true);
      when(func2)(ArgumentMatchers.any).afterReturn(false);
      sceneSessionManager.startSceneFromIcon(sceneInfo);

      when(func1)(ArgumentMatchers.any).afterReturn(false);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      sceneSessionManager.startSceneFromIcon(sceneInfo);
      expect(sceneSessionManager).not().assertNull();
    })

    it('startFloatFromDock', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('startFloatFromDockBundle', 'startFloatFromDockModule', 'startFloatFromDockAbility');

      when(func1)(ArgumentMatchers.any).afterReturn(true);
      when(func2)(ArgumentMatchers.any).afterReturn(false);
      sceneSessionManager.startFloatFromDock(sceneInfo);

      when(func1)(ArgumentMatchers.any).afterReturn(false);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      sceneSessionManager.startFloatFromDock(sceneInfo);
      expect(sceneSessionManager).not().assertNull();
    })

    it('transitionFloat', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('transitionFloatBundle', 'transitionFloatModule', 'transitionFloatAbility');
      const persistentId = 233;
      sceneSessionManager.transitionFloat(null, persistentId);
      sceneSessionManager.transitionFloat(undefined, persistentId);
      sceneSessionManager.transitionFloat(sceneInfo, persistentId);
      expect(sceneSessionManager).not().assertNull();
    })

    it('startSceneFromOther', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('startSceneFromOtherBundle', 'startSceneFromOtherModule', 'startSceneFromOtherAbility');
      sceneSessionManager.startSceneFromOther(sceneInfo);

      when(func1)(ArgumentMatchers.any).afterReturn(true);
      when(func2)(ArgumentMatchers.any).afterReturn(false);
      sceneSessionManager.startSceneFromOther(sceneInfo);

      when(func1)(ArgumentMatchers.any).afterReturn(false);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      const checkFunc = () => {
        return false;
      }
      const checkFunc2 = () => {
        return true;
      }
      sSampleManager.dominateScreen(true);
      sceneSessionManager.startSceneFromOther(sceneInfo);

      sSampleManager.dominateScreen(false);
      sSampleManager.registerCheckFunction(checkFunc);
      sceneSessionManager.startSceneFromOther(sceneInfo);

      sSampleManager.registerCheckFunction(checkFunc2);
      sceneSessionManager.startSceneFromOther(sceneInfo);
      expect(sceneSessionManager).not().assertNull();
    })

    it('startSceneFromNotification', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('notificationBundle', 'notificationModule', 'notificationAbility');

      when(func1)(ArgumentMatchers.any).afterReturn(true);
      when(func2)(ArgumentMatchers.any).afterReturn(false);
      sceneSessionManager.startSceneFromNotification(sceneInfo);

      when(func1)(ArgumentMatchers.any).afterReturn(false);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      sceneSessionManager.startSceneFromNotification(sceneInfo);
      sceneSessionManager.startSceneFromNotification(sceneInfo);
      expect(sceneSessionManager).not().assertNull();
    })

    it('startSceneTransition', 0, () => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const toSceneInfo: SCBSceneInfo = new SCBSceneInfo('toInfoBundle', 'toInfoModule', 'toInfoAbility', 0, 233);
      const toSceneInfo2: SCBSceneInfo = new SCBSceneInfo('toInfo2Bundle', 'toInfo2Module', 'toInfo2Ability', 0, 234);
      const fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('fromInfoBundle', 'fromInfoModule', 'fromInfoAbility', 0, 233);

      when(func1)(ArgumentMatchers.any).afterReturn(true);
      when(func2)(ArgumentMatchers.any).afterReturn(false);
      sceneSessionManager.startSceneTransition(toSceneInfo, fromSceneInfo);

      when(func1)(ArgumentMatchers.any).afterReturn(true);
      when(func2)(ArgumentMatchers.any).afterReturn(false);
      sceneSessionManager.startSceneTransition(toSceneInfo, fromSceneInfo);
      sceneSessionManager.startSceneTransition(toSceneInfo2, fromSceneInfo);
      expect(sceneSessionManager).not().assertNull();
    })

    it('success_when_startSceneTransition_isExternalScreenIntercepted_true_and_false', 0, () => {
      // 1.数据打桩
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const toSceneInfo: SCBSceneInfo = new SCBSceneInfo('toInfoBundle', 'toInfoModule', 'toInfoAbility', 0, 233);
      const fromSceneInfo: SCBSceneInfo = new SCBSceneInfo('fromInfoBundle', 'fromInfoModule', 'fromInfoAbility', 0, 233);
      const funcReturnFalse = () => {
        return false;
      }
      sceneSessionManager.registerExternalScreenInterceptorCallback(funcReturnFalse);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      when(func2)(ArgumentMatchers.any).afterReturn(false);

      // 2.执行测试方法
      sceneSessionManager.startSceneTransition(toSceneInfo, fromSceneInfo);

      const funcReturnTrue = () => {
        return true;
      }
      sceneSessionManager.registerExternalScreenInterceptorCallback(funcReturnTrue);

      // 2.执行测试方法
      sceneSessionManager.startSceneTransition(toSceneInfo, fromSceneInfo);

      // 3.验证结果
      expect(sceneSessionManager).not().assertNull();
    })

    it('success_when_startSceneFromIcon_isExternalScreenIntercepted_true_and_false', 0, () => {
      // 1.数据打桩
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('startSceneFromIconBundle', 'startSceneFromIconModule', 'startSceneFromIconAbility');
      const funcReturnFalse = () => {
        return false;
      }
      const funcReturnTrue = () => {
        return true;
      }

      // 2.执行测试方法
      sceneSessionManager.registerExternalScreenInterceptorCallback(funcReturnFalse);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      sceneSessionManager.startSceneFromIcon(sceneInfo);

      sceneSessionManager.registerExternalScreenInterceptorCallback(funcReturnTrue);
      sceneSessionManager.startSceneFromIcon(sceneInfo);

      // 3.验证结果
      expect(sceneSessionManager).not().assertNull();
    })

    it('success_when_startSceneFromOther_isExternalScreenIntercepted_true_and_false', 0, () => {
      // 1.数据打桩
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('startSceneFromOtherBundle', 'startSceneFromOtherModule', 'startSceneFromOtherAbility');
      sceneSessionManager.startSceneFromOther(sceneInfo);
      const funcReturnFalse = () => {
        return false;
      }
      const funcReturnTrue = () => {
        return true;
      }
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      sceneSessionManager.registerExternalScreenInterceptorCallback(funcReturnFalse);
      sSampleManager.dominateScreen(true);

      // 2.执行测试方法
      sceneSessionManager.startSceneFromOther(sceneInfo);

      sceneSessionManager.registerExternalScreenInterceptorCallback(funcReturnTrue);
      sceneSessionManager.startSceneFromOther(sceneInfo);

      // 3.验证结果
      expect(sceneSessionManager).not().assertNull();
    })

    it('success_when_startSceneFromNotification_isExternalScreenIntercepted_true_and_false', 0, () => {
      // 1.数据打桩
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const sceneInfo: SCBSceneInfo = new SCBSceneInfo('notificationBundle', 'notificationModule', 'notificationAbility');
      const funcReturnFalse = () => {
        return false;
      }
      const funcReturnTrue = () => {
        return true;
      }
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      sceneSessionManager.registerExternalScreenInterceptorCallback(funcReturnFalse);

      // 2.执行测试方法
      sceneSessionManager.startSceneFromNotification(sceneInfo);

      sceneSessionManager.registerExternalScreenInterceptorCallback(funcReturnTrue);
      sceneSessionManager.startSceneFromNotification(sceneInfo);

      // 3.验证结果
      expect(sceneSessionManager).not().assertNull();
    })

    it('onAddExtendContainerSessionTest', 0, () => {
      const sessionManager = SCBSceneSessionManager.getInstance();
      const containerList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let extendScreenId = -1;
      let callback: Function = (containerList: SCBSceneContainerSessionArray, screenId: number) => {
        extendScreenId = screenId;
      };
      sessionManager.registerAddExtendContainerSessionCallback(callback, 0);
      sessionManager.onAddExtendContainerSession(containerList, 11, 0);
      expect(extendScreenId).assertEqual(11);
    })
  })
}