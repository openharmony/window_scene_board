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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import { SCBScenePersistent } from '../../../../../../../main/ets/scene/session/SCBScenePersistent'
import sceneSessionManager from '@ohos.sceneSessionManager'
import { SCBSceneContainerSessionArray, SCBScreenProperty } from '../../../../../../../main/ets/TsIndex'
import { DeviceHelper } from '@ohos/frameworkwrapper';

export function SCBScenePersistentTest() {
  describe('SCBScenePersistentTest', () => {
    let scenePersistent = new SCBScenePersistent();
    let sceneInfo: sceneSessionManager.SceneRecoverInfo = {
      bundleName: "testBundle",
      moduleName: "testModule",
      abilityName: "testAbility",
      appIndex: 1,
      screenId: 1,
      windowMode: 1,
      sessionState: 1,
      sessionType: 1,
      requestOrientation: 1,
      layoutFullScreen: false,
      recoverRect: {
        posX_: 100,
        posY_: 100,
        width_: 100,
        height_: 100
      },
      mainWindowTopmost: false,
      currentRotation: 0,
      transitionAnimationMap: new Map(),
      supportWindowModes: [0, 1, 2]
    };

    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
      Reflect.get(scenePersistent, 'scbPersistentMap').clear();
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

    it('setSessionAliveStatus01', Level.LEVEL0, () => {
      scenePersistent.setSessionAliveStatus(-1, true);
      scenePersistent.addToLocalPersistentMap(-1, sceneInfo);
      scenePersistent.setSessionAliveStatus(-1, true);
      scenePersistent.setSessionAliveStatus(-1, false);
    });

    it('modifyPersistentMap01', Level.LEVEL0, () => {
      scenePersistent.modifyPersistentMap(-1, sceneInfo, 0);

      scenePersistent.setRecoverFinished();
      scenePersistent.modifyPersistentMap(0, sceneInfo, 0);

      scenePersistent.modifyPersistentMap(-1, sceneInfo, 0);
    });

    it('initUserPersistentDir01', Level.LEVEL0, () => {
      scenePersistent.initUserPersistentDir(-1);

      scenePersistent.initUserPersistentDir(1);

      scenePersistent.initUserPersistentDir(1);
    });

    it('readPersistentJsonArray01', Level.LEVEL0, () => {
      scenePersistent.readPersistentJsonArray();
    });

    it('recoverSessionList01', Level.LEVEL0, () => {
      let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      scenePersistent.recoverSessionList(containerSessionList, screenProperty);

      scenePersistent.recoverSessionList(null, null);
    });

    it('setLockInRecentStatus01', Level.LEVEL0, async () => {
      const persistentId = 100;
      scenePersistent.addToLocalPersistentMap(persistentId, sceneInfo);
      scenePersistent.setLockInRecentStatus(persistentId, true);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').size).assertEqual(1);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(persistentId).isLockedInRecent).assertTrue();
    });

    it('setLockInRecentStatus02', Level.LEVEL0, async () => {
      const persistentId = 100;
      scenePersistent.addToLocalPersistentMap(persistentId, sceneInfo);
      scenePersistent.setLockInRecentStatus(persistentId, true);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').size).assertEqual(1);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(persistentId).isLockedInRecent).assertTrue();
      scenePersistent.setLockInRecentStatus(persistentId, false);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').size).assertEqual(1);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(persistentId).isLockedInRecent).assertFalse();
    });

    it('setLockInRecentStatus03', Level.LEVEL0, async () => {
      const persistentId = 100;
      scenePersistent.setLockInRecentStatus(persistentId, true);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').size).assertEqual(0);
    });

    it('setLockInRecentStatus04', Level.LEVEL0, async () => {
      const persistentId = 100;
      scenePersistent.addToLocalPersistentMap(persistentId, sceneInfo);
      scenePersistent.setLockInRecentStatus(persistentId, true);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').size).assertEqual(1);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(persistentId).isLockedInRecent).assertTrue();
      scenePersistent.setLockInRecentStatus(persistentId, true);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').size).assertEqual(1);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(persistentId).isLockedInRecent).assertTrue();
    });

    it('setLockInRecentStatus05', Level.LEVEL0, async () => {
      const persistentId = 100;
      scenePersistent.addToLocalPersistentMap(persistentId, sceneInfo);
      for (let i = 0; i < 1000; i++) {
        scenePersistent.setLockInRecentStatus(persistentId, true);
      }
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').size).assertEqual(1);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(persistentId).isLockedInRecent).assertTrue();
    });

    it('getCacheLockInRecentStatus', Level.LEVEL0, async () => {
      const persistentId = 200;
      expect(scenePersistent.getCacheLockInRecentStatus(persistentId)).assertFalse();
      Reflect.get(scenePersistent, 'scbPersistentCacheMap').set(persistentId, {
        bundleName: 'bundleName',
        abilityName: 'abilityName',
        moduleName: 'moduleName',
        appIndex: 0,
        persistentId: persistentId,
        rotation: 0,
        isAlive: true,
        isLockedInRecent: true,
      });
      expect(scenePersistent.getCacheLockInRecentStatus(persistentId)).assertTrue();
    });
  });

  describe('SCBScenePersistent_setSessionLabel_testSuite', () => {
    let scenePersistent = new SCBScenePersistent();
    let sceneInfo: sceneSessionManager.SceneRecoverInfo = {
      bundleName: "testBundle",
      moduleName: "testModule",
      abilityName: "testAbility",
      appIndex: 1,
      screenId: 1,
      windowMode: 1,
      sessionState: 1,
      sessionType: 1,
      requestOrientation: 1,
      layoutFullScreen: false,
      recoverRect: {
        posX_: 100,
        posY_: 100,
        width_: 100,
        height_: 100
      },
      mainWindowTopmost: false,
      currentRotation: 0,
      transitionAnimationMap: new Map(),
      supportWindowModes: [0, 1, 2]
    };

    beforeEach(() => {
      Reflect.get(scenePersistent, 'scbPersistentMap').clear();
    })

    it('test_whenPersistentIdDoesNotExistInSCBPersistentMap_thenReturn', Level.LEVEL0, () => {
      scenePersistent.setSessionLabel(111, "abc");
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(111)).assertEqual(undefined);
    });

    it('test_whenOldLabelNotEqualNewLabel_thenSetSuccess', Level.LEVEL0, () => {
      scenePersistent.addToLocalPersistentMap(9527, sceneInfo);
      scenePersistent.setSessionLabel(9527, "abc");
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(9527).label).assertEqual("abc");
    });

    it('test_whenOldLabelEqualNewLabel_thenReturn', Level.LEVEL0, () => {
      scenePersistent.addToLocalPersistentMap(9527, sceneInfo);
      scenePersistent.setSessionLabel(9527, "abc");
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(9527).label).assertEqual("abc");
      scenePersistent.setSessionLabel(9527, "abc");
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(9527).label).assertEqual("abc");
    });
  });

  describe('SCBScenePersistent_getCacheSessionLabel_testSuite', () => {
    let scenePersistent = new SCBScenePersistent();
    let sceneInfo: sceneSessionManager.SceneRecoverInfo = {
      bundleName: "testBundle",
      moduleName: "testModule",
      abilityName: "testAbility",
      appIndex: 1,
      screenId: 1,
      windowMode: 1,
      sessionState: 1,
      sessionType: 1,
      requestOrientation: 1,
      layoutFullScreen: false,
      recoverRect: {
        posX_: 100,
        posY_: 100,
        width_: 100,
        height_: 100
      },
      mainWindowTopmost: false,
      currentRotation: 0,
      transitionAnimationMap: new Map(),
      supportWindowModes: [0, 1, 2]
    };

    beforeEach(() => {
      Reflect.get(scenePersistent, 'scbPersistentCacheMap').clear();
    })

    it('test_whenSceneInfoDataIsNull_thenReturnEmptyString', 0, () => {
      const result = scenePersistent.getCacheSessionLabel(111);
      expect(result).assertEqual('');
    });

    it('test_whenSceneInfoDataIsNotNull_thenReturnLabel', 0, () => {
      Reflect.get(scenePersistent, 'scbPersistentCacheMap').set(9527, {
        bundleName: 'bundleName',
        abilityName: 'abilityName',
        moduleName: 'moduleName',
        appIndex: 0,
        persistentId: 9527,
        rotation: 0,
        isAlive: true,
        isLockedInRecent: true,
        lastUsedPosition: 'test',
        label: 'testLabel'
      });
      expect(scenePersistent.getCacheSessionLabel(9527)).assertEqual('testLabel');
    });
  });

  describe('SCBScenePersistent_setLastUsedTimestamp_testSuite', () => {
    let scenePersistent = new SCBScenePersistent();
    let sceneInfo: sceneSessionManager.SceneRecoverInfo = {
      bundleName: "testBundle",
      moduleName: "testModule",
      abilityName: "testAbility",
      appIndex: 1,
      screenId: 1,
      windowMode: 1,
      sessionState: 1,
      sessionType: 1,
      requestOrientation: 1,
      layoutFullScreen: false,
      recoverRect: {
        posX_: 100,
        posY_: 100,
        width_: 100,
        height_: 100
      },
      mainWindowTopmost: false,
      currentRotation: 0,
      transitionAnimationMap: new Map(),
      supportWindowModes: [0, 1, 2]
    };

    beforeEach(() => {
      Reflect.get(scenePersistent, 'scbPersistentMap').clear();
    })

    it('test_whenPersistentIdDoesNotExistInSCBPersistentMap_thenReturn', Level.LEVEL0, () => {
      scenePersistent.setLastUsedTimestamp(120, 11);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(121)).assertEqual(undefined);
    });

    it('test_whenLastUsedTimestampIsDiff_thenSetSuccess', Level.LEVEL0, () => {
      scenePersistent.addToLocalPersistentMap(9528, sceneInfo);
      scenePersistent.setLastUsedTimestamp(9528, 11);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(9528).lastUsedTimestamp).assertEqual(11);
    });

    it('test_whenLastUsedTimestampIsSame_thenReturn', Level.LEVEL0, () => {
      scenePersistent.addToLocalPersistentMap(9528, sceneInfo);
      scenePersistent.setLastUsedTimestamp(9528, 10);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(9528).lastUsedTimestamp).assertEqual(10);
    });

    it('test_whenSetHasPrivacyModeControlTrue_thenSuccess', Level.LEVEL0, () => {
      let persistentId = 1000;
      scenePersistent.addToLocalPersistentMap(persistentId, sceneInfo);
      scenePersistent.setHasPrivacyModeControl(persistentId, true);
      expect(Reflect.get(scenePersistent, 'scbPersistentMap').get(persistentId).hasPrivacyModeControl).assertTrue();
    });
  });

}