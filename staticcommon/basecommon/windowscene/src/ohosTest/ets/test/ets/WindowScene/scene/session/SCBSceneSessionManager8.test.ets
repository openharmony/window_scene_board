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
  when
} from '@ohos/hypium';
import {
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty
} from '../../../../../../../..';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSystemBarProperty } from '../../../../../../../main/ets/scene/session/SCBSceneSession';
import {
  SCBSceneSessionManager,
  ScenePanelState
} from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import { ReflectionUtils } from '../../utils/ReflectionUtils';
import { SCBSceneContainerSessionArray } from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';

let primarySessionGlobal: SCBSceneSession;
let secondSessionGlobal: SCBSceneSession;
let screenPropertyGlobal: SCBScreenProperty;
let sceneInfoGlobal: SCBSceneInfo;

let initAll = () => {
  screenPropertyGlobal = new SCBScreenProperty();
  screenPropertyGlobal.width = 1;
  screenPropertyGlobal.height = 1;
  sceneInfoGlobal = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  primarySessionGlobal = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoGlobal), sceneInfoGlobal);
  secondSessionGlobal = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoGlobal), sceneInfoGlobal);
}

export function SCBSceneSessionManagerTest8() {
  describe('SCBSceneSessionManagerTest8', () => {
    beforeAll(() => {
      initAll();
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('test_rawSystemBarPropertyCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let tmp = 0;
      const callback = () => {
        tmp++;
      };
      manager.registerRawSystemBarPropertyCallback(callback, 0);
      expect(tmp).assertEqual(1);
      ReflectionUtils.useFunc(manager, 'updateRawSystemBarPropertyToCallbacks', new SCBSystemBarProperty(), 0);
      expect(tmp).assertEqual(2);
      ReflectionUtils.useFunc(manager, 'updateSystemBarPropertyToCallbacks', new SCBSystemBarProperty(), 0);
      expect(tmp).assertEqual(3);
      manager.unRegisterRawSystemBarPropertyCallback(callback, 0);
      expect(tmp).assertEqual(3);
      ReflectionUtils.useFunc(manager, 'updateRawSystemBarPropertyToCallbacks', new SCBSystemBarProperty(), 0);
      expect(tmp).assertEqual(3);
    });

    it('test_whenFindMainSessionByInvalidId_thenNull', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      expect(manager.findMainSessionById(0)).assertNull();
    })

    it('test_whenSetIsStatusBarShownForHoverByTrue_thenTrue', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let tmp: boolean = ReflectionUtils.getProperty(manager, 'mIsStatusBarShownForHover');
      manager.setIsStatusBarShownForHover(true);
      expect(manager.getIsStatusBarShownForHover()).assertTrue();
      manager.setIsStatusBarShownForHover(tmp);
      expect(manager.getIsStatusBarShownForHover()).assertEqual(tmp);
    })

    it('test_whenRegisterStatusBarRecoverCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 2;
      };
      manager.registerStatusBarRecoverCallback(callback, 666666666);
      expect(ReflectionUtils.getProperty(manager, 'mainScreenId')).not().assertEqual(-3);
    })

    it('test_whenStatusBarRecoverCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 2;
      };
      manager.registerStatusBarRecoverCallback(callback, 666666666);
      expect(ReflectionUtils.getProperty(manager, 'mainScreenId')).not().assertEqual(-3);
    })

    it('test_whenStatusBarStyleCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 2;
      };
      manager.registerStatusBarStyleCallback(callback);
      expect(ReflectionUtils.getProperty(manager, 'mainScreenId')).not().assertEqual(-3);
      ReflectionUtils.setProperty(manager, 'statusBarStyleCallback', null);
    })

    it('test_whenClearSceneStatusCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 2;
      };
      manager.registerClearSceneStatusCallback(callback, 77777777);
      expect(ReflectionUtils.getProperty(manager, 'mainScreenId')).not().assertEqual(-3);
      manager.unregisterClearSceneStatusCallback(77777777);
    })

    it('test_whenRegisterGestureBarVisibleCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 2;
      };
      manager.registerGestureBarVisibleCallback(callback, 123232);
      expect(ReflectionUtils.getProperty(manager, 'mainScreenId')).not().assertEqual(-3);
      manager.unregisterGestureBarVisibleCallback(123232);
    })

    it('test_whenSetDockMaskVisibleCallbackMap_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 2;
      };
      manager.registerDockMaskVisibleCallback(callback, 22233222);
      expect(ReflectionUtils.getProperty(manager, 'mainScreenId')).not().assertEqual(-3);
      manager.unregisterDockMaskVisibleCallback(22233222);
    })

    it('test_whenSetNavigationBarCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 3;
      };
      manager.registerNavigationBarCallback(callback);
      expect(ReflectionUtils.getProperty(manager, 'navigationBarCallback')).not().assertNull();
      manager.unRegisterNavigationBarCallback();
    })

    it('test_whenSetAutoStartPiPCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 3;
      };
      manager.registerAutoStartPiPCallback(callback);
      expect(ReflectionUtils.getProperty(manager, 'autoStartPiPCallback')).not().assertNull();
      manager.unregisterAutoStartPiPCallback();

      manager.registerStartPiPFailedCallback(callback, 112233);
      expect(ReflectionUtils.getProperty(manager, 'mainScreenId')).not().assertEqual(-3);
      manager.unregisterStartPiPFailedCallback(112233);
    })

    it('test_whenSetUpdatePipExtendSessionCallback_thenSuccess', 0, () => {
        const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
        expect(manager).not().assertNull();
        const callback: Function = () => {
          return 3;
        };
        manager.registerUpdatePipExtendSessionCallback(callback);
        expect(ReflectionUtils.getProperty(manager, 'mainScreenId')).not().assertEqual(-3);
        manager.unregisterUpdatePipExtendSessionCallback();
    })

    it('test_whenRemoveSpecialContainerSessionCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 3;
      };
      manager.registerRemoveSpecialContainerSessionCallback(callback);
      expect(ReflectionUtils.getProperty(manager, 'removeSpecialContainerSessionCallback')).not().assertNull();
      manager.unregisterRemoveSpecialContainerSessionCallback();
    })

    it('test_whenIsScenePanelInStateByInvalidId_thenFalse', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 3;
      };
      expect(manager.isScenePanelInState(99999999999,
        ScenePanelState.FULLSCENE, ScenePanelState.SPLIT)).assertFalse();
    })

    it('test_whenGetFirstActiveFloatSessionByContainerSessionList_thenFail', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      ReflectionUtils.useFunc(manager, 'getFirstActiveFloatSession', containerSessionList);
      expect(ReflectionUtils.getProperty(manager, 'mainScreenId')).not().assertEqual(-3);
    })

    it('test_whenIsNeedMaximizeFloating_thenTrue', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let tmp: boolean = manager.isNeedMaximizeFloating();
      manager.setMaximizeFloatingMode(true);
      expect(manager.isNeedMaximizeFloating()).assertTrue();
      manager.setMaximizeFloatingMode(tmp);
    })

    it('test_whenMidSceneStateChangeCallBack_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 3;
      };
      manager.registerMidSceneStateChangeCallBack(callback);
      expect(ReflectionUtils.getProperty(manager, 'midSceneStateChangeCallBack')).not().assertNull();
      manager.unRegisterMidSceneStateChangeCallBack();
    })

    it('test_whenRegisterNavChangeCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 3;
      };
      manager.registerNavChangeCallback(callback);
      expect(ReflectionUtils.getProperty(manager, 'navChangeCallback')).not().assertNull();
      manager.unRegisterNavChangeCallback();
    })

    it('test_whenRegisterCompatibleViewChangeCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 3;
      };
      manager.registerCompatibleViewChangeCallback(callback);
      expect(ReflectionUtils.getProperty(manager, 'compatibleViewChangeCallback')).not().assertNull();
      manager.unregisterCompatibleViewChangeCallback();
    })

    it('test_whenRegisterSessionDisplayChangeCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 3;
      };
      manager.registerSessionDisplayChangeCallback(callback);
      expect(ReflectionUtils.getProperty(manager, 'sessionDisplayChangeCallback')).not().assertNull();
      manager.unRegisterSessionDisplayChangeCallback();
    })

    it('test_whenRegisterTouchscreenGestureCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 3;
      };
      manager.registerTouchscreenGestureCallback(callback);
      expect(ReflectionUtils.getProperty(manager, 'touchScreenGestureCallback')).not().assertNull();
      manager.unregisterTouchScreenGestureCallback();
    })

    it('test_whenRegisterClearToggleHomeSceneCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const callback: Function = () => {
        return 3;
      };
      manager.registerClearToggleHomeSceneCallback(callback);
      expect(ReflectionUtils.getProperty(manager, 'mainScreenId')).not().assertEqual(-3);
      manager.unRegisterClearToggleHomeSceneCallback(callback);
    })

    it('test_whenRegisterAnimationCallback_thenSuccess', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let sId = 0;
      let pId = 0;
      const callback = (screenId: number, persistentId: number): void => {
        sId = screenId;
        pId = persistentId;
      };
      manager.registerAnimationCallback(callback, 3);
      manager.doAnimation(3, 11);
      expect(sId).assertEqual(3);
      expect(pId).assertEqual(11);
      manager.unregisterAnimationCallback(3);
    })

    it('test_registerAddGestureDockRecentItemCallback', 0, () => {
        const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
        let gestureDockRecentList: Array<string> = [];
        let addGestureDockRecentItemCallback: Function = (bundleName: string, index: number) => {
          if (gestureDockRecentList.indexOf(bundleName) > -1) {
            gestureDockRecentList.splice(gestureDockRecentList.indexOf(bundleName), 1);
          }
          gestureDockRecentList = [bundleName].concat(gestureDockRecentList);
        }
        manager.registerAddGestureDockRecentItemCallback(addGestureDockRecentItemCallback);
        manager.addGestureDockRecentItem('test_bundleName1', 0);
        manager.addGestureDockRecentItem('test_bundleName2', 1);
        expect(gestureDockRecentList.length).assertEqual(2);
        expect(gestureDockRecentList[0]).assertEqual('test_bundleName2');
        expect(gestureDockRecentList[1]).assertEqual('test_bundleName1');

        manager.addGestureDockRecentItem('test_bundleName1', 0);
        expect(gestureDockRecentList.length).assertEqual(2);
        expect(gestureDockRecentList[0]).assertEqual('test_bundleName1');
        expect(gestureDockRecentList[1]).assertEqual('test_bundleName2');
        manager.unregisterAddGestureDockRecentItemCallback();
      })

    it('test_registerHandleSceneWhenPreLock', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const callbackMap: Map<number, Function> =
        ReflectionUtils.getProperty(manager, 'handleWindowWhenPreLockCallbackMap');
      expect(callbackMap.get(100)).assertUndefined();
      const handleSceneWhenPreLockCallback = (): void => {};
      manager.registerHandleSceneWhenPreLock(100, handleSceneWhenPreLockCallback);
      expect(callbackMap.get(100)).not().assertUndefined();
      manager.handleSceneWhenPreLock();
      manager.unregisterHandleSceneWhenPreLock(100);
      expect(callbackMap.get(100)).assertUndefined();
    })
  })
}