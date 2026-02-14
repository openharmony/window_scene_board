/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import {
  SCBSceneContainerSessionArray,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty
} from '../../../../../../../..';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';

let g_persistentId: number = 0x10000;
const TAG = 'SCBSceneContainerSessionArrayTest';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

class TestSessionsManager {
  public testSessionArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();

  init(): void {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();

    let priSceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, ++g_persistentId);
    let priSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(priSceneInfo), priSceneInfo);
    let containerSession = new SCBSceneContainerSession(priSceneSession, screenProperty);
    this.testSessionArray.push(containerSession);

    let secSceneInfo: SCBSceneInfo = new SCBSceneInfo('testSecBundle', 'testSecModule', 'testSecAbility', 0, ++g_persistentId);
    let secSceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(secSceneInfo), secSceneInfo);
    containerSession = new SCBSceneContainerSession(secSceneSession, screenProperty);
    this.testSessionArray.push(containerSession);
  }
}

export function SCBSceneContainerSessionArrayTest() {
  describe('SCBSceneContainerSessionArrayTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    it('SCBSceneContainerSessionArrayTest_isEmpty', 0, () => {
      let manager = new TestSessionsManager();
      expect(manager.testSessionArray.isEmpty()).assertTrue();
      manager.init();
      expect(manager.testSessionArray.isEmpty()).assertFalse();
      expect(manager.testSessionArray.length).assertEqual(2);
    })
    it('SCBSceneContainerSessionArrayTest_clear', 0, () => {
      let manager = new TestSessionsManager();
      manager.init();
      manager.testSessionArray.clear();
      expect(manager.testSessionArray.isEmpty()).assertTrue();
    })
    it('findByContainerId', 0, () => {
      let manager = new TestSessionsManager();
      manager.init();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, ++g_persistentId);
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      manager.testSessionArray.add(containerSession);
      console.log('testSessionArray length is 3');
      let found = manager.testSessionArray.findByContainerId(containerSession.containerId);
      expect(found).assertEqual(containerSession);
      let foundIndex = manager.testSessionArray.findIndexByContainerId(containerSession.containerId);
      expect(foundIndex).not().assertEqual(-1);
    })
    it('findByPersistentId', 0, () => {
      let manager = new TestSessionsManager();
      manager.init();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, ++g_persistentId);

      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      manager.testSessionArray.add(containerSession);
      log.showInfo(`findByPersistentId: persistentId ${g_persistentId}, ${sceneSession.sceneInfo.persistentId}`);
      let found = manager.testSessionArray.findByPersistentId(sceneSession.sceneInfo.persistentId);
      expect(found).not().assertNull();
      let foundIndex = manager.testSessionArray.findIndexByPersistentId(sceneSession.sceneInfo.persistentId);
      expect(foundIndex).not().assertEqual(-1);
    })
    it('add', 0, () => {
      let manager = new TestSessionsManager();
      manager.init();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, ++g_persistentId);
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let ret = manager.testSessionArray.add(containerSession);
      expect(ret).assertTrue();
      expect(manager.testSessionArray.length).assertEqual(3);

      log.showInfo(`findByPersistentId: persistentId ${g_persistentId}, ${sceneSession.sceneInfo.persistentId}`);
      let found = manager.testSessionArray.findIndexByPersistentId(sceneSession.sceneInfo.persistentId);
      expect(found).not().assertEqual(-1);
    })
    it('insert', 0, () => {
      let manager = new TestSessionsManager();
      manager.init();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, ++g_persistentId);
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      let ret = manager.testSessionArray.insert(0, containerSession);
      expect(ret).assertTrue();
      ret = manager.testSessionArray.insert(1, containerSession);
      expect(ret).assertFalse();
      ret = manager.testSessionArray.insert(100, containerSession);
      expect(ret).assertFalse();

      let found = manager.testSessionArray.findIndexByPersistentId(sceneSession.sceneInfo.persistentId);
      expect(found !== -1).assertTrue();
    })
    it('delete', 0, () => {
      let manager = new TestSessionsManager();
      manager.init();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, ++g_persistentId);
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      manager.testSessionArray.add(containerSession);

      let found = manager.testSessionArray.findByContainerId(containerSession.containerId);
      expect(found != null).assertTrue();
      manager.testSessionArray.deleteByContainerId(containerSession.containerId);

      found = manager.testSessionArray.findByContainerId(containerSession.containerId);
      expect(found).assertNull();
    })
    it('getTopSession', 0, () => {
      let manager = new TestSessionsManager();
      manager.init();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility', 0, ++g_persistentId);
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      manager.testSessionArray.add(containerSession);

      let found = manager.testSessionArray.findByContainerId(containerSession.containerId);
      expect(found != null).assertTrue();

      let topSession = manager.testSessionArray.getTopSession();
      expect(topSession != null).assertTrue();
    })
    it('getTopActiveSession', 0, () => {
      let manager = new TestSessionsManager();
      manager.init();

      let topActiveSession = manager.testSessionArray.getTopActiveSession();
      expect(topActiveSession).assertNull();

      let sceneInfo = new SCBSceneInfo('testActiveBundle', 'testActiveModule', 'testActiveAbility', 0, ++g_persistentId);
      let sceneSession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.requestActivation();
      manager.testSessionArray.add(containerSession);

      topActiveSession = manager.testSessionArray.getTopActiveSession();
      expect(topActiveSession).not().assertNull();
    })
    it('clone', 0, () => {
      let manager = new TestSessionsManager();
      manager.init();

      let newArr = manager.testSessionArray.clone();
      newArr.forEach((item => {
        let foundIndex = manager.testSessionArray.findIndexByContainerId(item.containerId);
        expect(foundIndex !== -1).assertTrue();
      }))
    })
  })
}