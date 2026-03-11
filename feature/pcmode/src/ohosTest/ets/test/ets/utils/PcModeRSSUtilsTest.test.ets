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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  ArgumentMatchers,
  when,
} from '@ohos/hypium'
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
} from '@ohos/windowscene';

import { PcModeRSSUtils } from
  '../../../../../main/ets/utils/PcModeRSSUtils';
import sceneSessionManager from '@ohos.sceneSessionManager';

export function PcModeRSSUtilsTest() {
  describe('PcModeRSSUtilsTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    });
    isRssMutexTest();
    onRssMutexTest();
    startListenerTest();
    stopListenerTest();
    processRssDataTest();
  });
}

function startListenerTest() {
  it('startListenerTest', Level.LEVEL0, () => {
    let error = undefined;
    try {
      PcModeRSSUtils.startListener();
    } catch (e) {
      error = e;
    }
    expect(error).assertUndefined();
  });
}

function stopListenerTest() {
  it('stopListenerTest', Level.LEVEL0, () => {
    let error = undefined;
    try {
      PcModeRSSUtils.stopListener();
    } catch (e) {
      error = e;
    }
    expect(error).assertUndefined();
  });
}

function processRssDataTest() {
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let testSceneInfo: SCBSceneInfo;
  let testSceneSession: SCBSceneSession;
  let testContainerSession: SCBSceneContainerSession;
  beforeAll(() => {
    testSceneInfo = new SCBSceneInfo('com.ohos.camera', 'testModule', 'testAbility');
    testSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(testSceneInfo), testSceneInfo);
    testContainerSession = new SCBSceneContainerSession(testSceneSession, screenProperty);
  })
  it('processData', Level.LEVEL0, () => {
    const containerSessionList: SCBSceneContainerSessionArray = SCBSceneSessionManager
      .getInstance().getContainerSessionList();
    containerSessionList.push(testContainerSession);
    let rssData: Record<string, string> = { 'appInfo': 'testBundle', 'reason': 'test' }
    PcModeRSSUtils.processRssData(9, rssData);
    expect(testContainerSession.isActive).assertEqual(true);
  });
}

function isRssMutexTest() {
  it('isRssMutexTest_01', Level.LEVEL0, (): void => {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let isRssMutex = PcModeRSSUtils.isRssMutex(testSCBSceneInfo);
    expect(isRssMutex).assertFalse();
  });

  it('isRssMutexTest_02', Level.LEVEL0, (): void => {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let result = false;
    try {
      let payload: Record<string, string> =
        { 'bundleName': testSCBSceneInfo.bundleName,
          'mode': 'FLOATING' };
      let reply = sceneSessionManager.getRssData(501, payload);
      result = Boolean(reply['result']);
    } catch (err) {
      expect(err).not().assertNull();
    }
    let isRssMutex = PcModeRSSUtils.isRssMutex(testSCBSceneInfo);
    expect(isRssMutex).assertEqual(result);
  });
}

function onRssMutexTest() {
  it('onRssMutexTest_01', Level.LEVEL0, (): void => {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    PcModeRSSUtils.onRssMutex(testSCBSceneInfo);
    let containerSession = SCBSceneSessionManager.getInstance().getContainerSessionList()
      .findByPersistentId(testSCBSceneInfo.persistentId);
    expect(containerSession).assertNull();
  });
}
