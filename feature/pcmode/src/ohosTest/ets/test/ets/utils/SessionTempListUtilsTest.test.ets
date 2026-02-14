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
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty
} from '@ohos/windowscene';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers,
  when} from '@ohos/hypium'
import { SessionTempList } from '../../../../../main/ets/utils/SessionTempListUtils';

export function SessionTempListUtilsTest() {
  describe('SessionTempListUtilsTest', () => {
    let sessionTempList: SessionTempList;
    let mocker: MockKit;
    let mockMap: Map<string, Function[]>;
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
      sessionTempList = new SessionTempList();
      mocker = new MockKit();
      mockMap = new Map<string, Function[]>();
      (sessionTempList as object)['afterRemoveCallbackGroupMap'] = mockMap;
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_registerTimeoutOne', 0, async (done: Function) => {
      try {
        let containerSession: SCBSceneContainerSession = registerTimeoutTem();
        (sessionTempList as object)['timeoutGroupMap'].set('groupOne', undefined);
        (sessionTempList as object)['registerTimeout']('groupOne', containerSession, () => {
          sessionTempList.removeSession('groupOne', containerSession, true);
        });
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    })

    it('test_registerTimeoutTwo', 0, async (done: Function) => {
      try {
        let containerSession: SCBSceneContainerSession = registerTimeoutTem();
        let cs: Map<SCBSceneContainerSession, number> = new Map();
        cs.set(containerSession, 1);
        (sessionTempList as object)['timeoutGroupMap'].set('groupTwo', cs);
        (sessionTempList as object)['registerTimeout']('groupTwo', containerSession, () => {
          sessionTempList.removeSession('groupTwo', containerSession, true);
        });
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    })

    it('test_registerTimeoutThree', 0, async (done: Function) => {
      try {
        let containerSession: SCBSceneContainerSession = registerTimeoutTem();
        let cs: Map<SCBSceneContainerSession, number> = new Map();
        (sessionTempList as object)['timeoutGroupMap'].set('groupThree', cs);
        (sessionTempList as object)['registerTimeout']('groupThree', containerSession, () => {
          sessionTempList.removeSession('groupTwo', containerSession, true);
        });
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    })

    it('test_unRegisterTimeoutOne', 0, async (done: Function) => {
      try {
        let containerSession: SCBSceneContainerSession = registerTimeoutTem();
        let cs: Map<SCBSceneContainerSession, number> = new Map();
        cs.set(containerSession, 1);
        (sessionTempList as object)['timeoutGroupMap'].set('unGroupOne', cs);
        (sessionTempList as object)['unRegisterTimeout']('unGroupOne', containerSession);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    })

    it('test_unRegisterTimeoutTwo', 0, async (done: Function) => {
      try {
        let containerSession: SCBSceneContainerSession = registerTimeoutTem();
        (sessionTempList as object)['timeoutGroupMap'].set('unGroupTwo', undefined);
        (sessionTempList as object)['unRegisterTimeout']('unGroupTwo', containerSession);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    })

    it('test_unRegisterTimeoutThree', 0, async (done: Function) => {
      try {
        let containerSession: SCBSceneContainerSession = registerTimeoutTem();
        let cs: Map<SCBSceneContainerSession, number> = new Map();
        (sessionTempList as object)['timeoutGroupMap'].set('unGroupOne', cs);
        (sessionTempList as object)['unRegisterTimeout']('unGroupThree', containerSession);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    })

    it('test_triggerRemoveCallbacksOne', 0, async (done: Function) => {
      try {
        let containerSession: SCBSceneContainerSession = registerTimeoutTem();
        let cg: Map<string, Function[]> = new Map();
        (sessionTempList as object)['afterRemoveCallbackGroupMap'].set('testGroupOne', cg);
        (sessionTempList as object)['triggerRemoveCallbacks']('testGroupOne', containerSession);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    })

    it('test_triggerRemoveCallbacksTwo', 0, async (done: Function) => {
      try {
        let containerSession: SCBSceneContainerSession = registerTimeoutTem();
        let cg: Map<string, Function[]> = new Map();
        (sessionTempList as object)['afterRemoveCallbackGroupMap'].set('testGroupTwo', cg);
        (sessionTempList as object)['triggerRemoveCallbacks']('testGroupTwo', containerSession);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    })

    it('test_printLogOne', 0, async (done: Function) => {
      try {
        (sessionTempList as object)['printLog']('sessionGroupMap');
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    })

    it('test_printLogTwo', 0, async (done: Function) => {
      try {
        (sessionTempList as object)['printLog']('timeoutGroupMap');
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    })

    it('test_printLogThree', 0, async (done: Function) => {
      try {
        (sessionTempList as object)['printLog']('all');
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    })

    it('not_register_if_groupName_is_empty', 0, async (done: Function) => {
      try {
        sessionTempList.registerAfterRemoveSession('', () => {});
        expect(mockMap.size).assertEqual(0);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    });

    it('add_callback_group_not_exist', 0, async (done: Function) => {
      try {
        let callback: Function = (containerSession: SCBSceneContainerSession) => {
          containerSession.requestDestruction(true);
        };
        let mockSet = mocker.mockFunc(mockMap, mockMap.set);
        when(mockSet)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(undefined);
        sessionTempList.registerAfterRemoveSession('group1', callback);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        mocker.clear(mockMap);
        done();
      }
    });

    it('add_callback_to_existing_group', 0, async (done: Function) => {
      try {
        let callback = () => {};
        let callbacks = [() => {}];
        mockMap.set('group1', callbacks);
        let mockGet = mocker.mockFunc(mockMap, mockMap.get);
        let mockSet = mocker.mockFunc(mockMap, mockMap.set);
        when(mockGet)(ArgumentMatchers.any).afterReturn(callbacks);
        when(mockSet)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(undefined);
        sessionTempList.registerAfterRemoveSession('group1', callback);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        mocker.clear(mockMap);
        done();
      }
    });

    it('should_do_nothing_if_groupName_is_empty', 0, async (done: Function) => {
      try {
        sessionTempList.unRegisterAfterRemoveSession('', () => {});
        expect(mockMap.has('')).assertFalse();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    });

    it('should_do_nothing_if_callbackGroup_is_undefined', 0, async (done: Function) => {
      try {
        sessionTempList.unRegisterAfterRemoveSession('group1', () => {});
        expect(mockMap.has('group1')).assertFalse();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    });

    it('should_do_nothing_if_callbackGroup_is_empty', 0, async (done: Function) => {
      try {
        mockMap.set('group2', []);
        sessionTempList.unRegisterAfterRemoveSession('group2', () => {});
        expect(mockMap.get('group2')?.length).assertEqual(0);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('should_remove_callback_from_callbackGroup_if_present', 0, async (done: Function) => {
      try {
        const callback = () => {};
        mockMap.set('group3', [callback]);
        sessionTempList.unRegisterAfterRemoveSession('group3', callback);
        expect(mockMap.get('group3')?.includes(callback)).assertFalse();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('should_not_remove_any_callback_if_not_present', 0, async (done: Function) => {
      try {
        const callback1 = () => {};
        const callback2 = () => {};
        mockMap.set('group4', [callback1]);
        sessionTempList.unRegisterAfterRemoveSession('group4', callback2);
        expect(mockMap.get('group4')?.includes(callback1)).assertTrue();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('removeSession_groupName_or_containerSession_is_null', 0, async (done: Function) => {
      try {
        let session = registerTimeoutTem();
        sessionTempList.removeSession(null, session);
        sessionTempList.removeSession('groupName', null);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('removeSession_if_sessionGroup_does_not_exist', 0, async (done: Function) => {
      try {
        let session = registerTimeoutTem();
        sessionTempList.removeSession('groupName', session);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('removeSession_if_session_not_found_in_sessionGroup', 0, async (done: Function) => {
      try {
        let session = registerTimeoutTem();
        (sessionTempList as object)['sessionGroupMap'].set('groupName', []);
        sessionTempList.removeSession('groupName', session);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('removeSession_and_trigger_callbacks', 0, async (done: Function) => {
      try {
        let session = registerTimeoutTem();
        (sessionTempList as object)['sessionGroupMap'].set('groupName', [session]);
        sessionTempList.removeSession('groupName', session, true);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('removeSession_without_triggering_callbacks', 0, async (done: Function) => {
      try {
        let session = registerTimeoutTem();
        (sessionTempList as object)['sessionGroupMap'].set('groupName', [session]);
        sessionTempList.removeSession('groupName', session, false);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('insert_groupName_or_containerSession_is_null', 0, async (done: Function) => {
      try {
        let containerSession = registerTimeoutTem();
        sessionTempList.insert(null, containerSession);
        sessionTempList.insert('groupName', null);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('insert_new_group_not_exists', 0, async (done: Function) => {
      try {
        let containerSession = registerTimeoutTem();
        sessionTempList.insert('newGroup', containerSession);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('existing_group_containerId_does_not_exist', 0, async (done: Function) => {
      try {
        let containerSession = registerTimeoutTem();
        (sessionTempList as object)['sessionGroupMap'].set('existingGroup', []);
        sessionTempList.insert('existingGroup', containerSession);
        sessionTempList.insert('existingGroup', containerSession);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('containerId_already_exists_in_group', 0, async (done: Function) => {
      try {
        let containerSession = registerTimeoutTem();
        (sessionTempList as object)['sessionGroupMap'].set('existingGroup', [containerSession]);
        sessionTempList.insert('existingGroup', containerSession);
        sessionTempList.insert('existingGroup', containerSession);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('getSession_groupName_is_empty', 0, async (done: Function) => {
      try {
        const result = sessionTempList.getSession('', 123);
        expect(result).assertUndefined();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('getSession_persistentId_is_zero', 0, async (done: Function) => {
      try {
        const result = sessionTempList.getSession('group1', 0);
        expect(result).assertUndefined();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('getSession_groupName_not_exist', 0, async (done: Function) => {
      try {
        const result = sessionTempList.getSession('nonexistentGroup', 123);
        expect(result).assertUndefined();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('getSession_sessionGroup_is_empty', 0, async (done: Function) => {
      try {
        (sessionTempList as object)['sessionGroupMap'].set('emptyGroup', []);
        const result = sessionTempList.getSession('emptyGroup', 123);
        expect(result).assertUndefined();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('getSession_session_is_found1', 0, async (done: Function) => {
      try {
        let mockSession = registerTimeoutTem(123);
        (sessionTempList as object)['sessionGroupMap'].set('emptyGroup', [mockSession]);
        sessionTempList.getSession('group1', 123);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('getSession_session_is_found2', 0, async (done: Function) => {
      try {
        let mockSession = registerTimeoutTem(111);
        (sessionTempList as object)['sessionGroupMap'].set('emptyGroup', [mockSession]);
        sessionTempList.getSession('group1', 123);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('getSession_removeAfterGet_is_true', 0, async (done: Function) => {
      try {
        let mockSession = registerTimeoutTem(123);
        (sessionTempList as object)['sessionGroupMap'].set('emptyGroup', [mockSession]);
        sessionTempList.getSession('group1', 123, true);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('getSceneSession_groupName_is_empty', 0, async (done: Function) => {
      try {
        const result = sessionTempList.getSceneSession('', 123);
        expect(result).assertUndefined();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('getSceneSession_persistentId_is_zero', 0, async (done: Function) => {
      try {
        const result = sessionTempList.getSceneSession('group1', 0);
        expect(result).assertUndefined();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      done();
    });

    it('getSceneSession_returns_undefined', 0, async (done: Function) => {
      try {
        let mockerFunc = mocker.mockFunc(sessionTempList, sessionTempList.getSession);
        when(mockerFunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(undefined);
        const result = sessionTempList.getSceneSession('group1', 123);
        expect(result).assertUndefined();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      mocker.clear(sessionTempList);
      done();
    });

    it('getSceneSession_matched_primarySession', 0, async (done: Function) => {
      try {
        let mockGetSession = registerTimeoutTem(123);
        let mockerFunc = mocker.mockFunc(sessionTempList, sessionTempList.getSession);
        when(mockerFunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(mockGetSession);
        sessionTempList.getSceneSession('group1', 123);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      mocker.clear(sessionTempList);
      done();
    });

    it('getSceneSession_matched_secondarySession', 0, async (done: Function) => {
      try {
        let mockGetSession = addSceneSessionTem(123);
        let mockerFunc = mocker.mockFunc(sessionTempList, sessionTempList.getSession);
        when(mockerFunc)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(mockGetSession);
        sessionTempList.getSceneSession('group1', 123);
        expect(sessionTempList).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      }
      mocker.clear(sessionTempList);
      done();
    });

  })
}

function registerTimeoutTem(persistentId?: number): SCBSceneContainerSession {
  let testSCBScreenProperty = new SCBScreenProperty();
  let testSCBSceneInfo: SCBSceneInfo =
    new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName', 1, persistentId || 1);
  let testSession = SCBSceneSessionManager.getInstance().requestSceneSession(testSCBSceneInfo);
  let scbSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
  let containerSession: SCBSceneContainerSession =
    new SCBSceneContainerSession(scbSceneSession, testSCBScreenProperty);
  return containerSession;
}

function addSceneSessionTem(persistentId?: number): SCBSceneContainerSession {
  let testSCBScreenProperty = new SCBScreenProperty();
  let testSCBSceneInfo: SCBSceneInfo =
    new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName', 1, persistentId || 1);
  let testSession = SCBSceneSessionManager.getInstance().requestSceneSession(testSCBSceneInfo);
  let testSCBSceneInfo2: SCBSceneInfo =
    new SCBSceneInfo('testBundleName2', 'testModuleName2', 'testAbilityName2', 2, persistentId || 2);
  let testSession2 = SCBSceneSessionManager.getInstance().requestSceneSession(testSCBSceneInfo2);
  let scbSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
  let containerSession: SCBSceneContainerSession =
    new SCBSceneContainerSession(scbSceneSession, testSCBScreenProperty);
  containerSession.addSceneSession(new SCBSceneSession(testSession2, testSCBSceneInfo2));
  return containerSession;
}