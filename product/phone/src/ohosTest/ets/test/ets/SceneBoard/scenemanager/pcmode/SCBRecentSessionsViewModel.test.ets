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
  SCBRecentSessionInfo,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty
} from '@ohos/windowscene';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
  Level
} from '@ohos/hypium';
import {
  MemoryHelper,
  SCBRecentSessionsViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/pcmode/SCBRecentSessionsViewModel';
import { AppItemInfo, AppModel, LayoutViewModel } from '@ohos/launchercommon';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ReflectionUtils } from '../multiwindow/ReflectionUtils';
import {
  SCBRecentStyleConstants
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/pcmode/SCBRecentStyleConstants';

let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
let memoryHelper: MemoryHelper = new MemoryHelper();

export default function SCBRecentSessionsViewModelTest() {
  describe('SCBRecentSessionsViewModelTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    getInstanceTest();
    getRecentSessionInfoTest();
    isSupportSplitModeTest();
    updateRecentSessionInfoTest();
    setScreenPropertyTest();
    getScreenWidthTest();
    getScreenHeightTest();
    setRecentPropertyTest();
    getCurrentShowWidthTest();
    getCurrentShowHeightTest();
    setSplitRecentPropertyTest();
    getSplitOffsetTest();
    getRecentSessionsNotIncludeTest();
    getRecentSessionsTest();
    getRecentSessionsListTest();
    terminateRecentIfAllClearTest();
    getTitleHeightTest();
    judgeAnimationTypeTest();
    getRecentTitleAppNameIdTest();
    printTest();
    registerDebugCommandTest();
    memoryHelperGetInstanceTest();
    memoryHelperInitTest();
    memoryHelperRefreshTest();
    memoryHelperGetLengthTest();
    memoryHelperSetCacheTest();
    memoryHelperGetCacheTest();

    it('getInstance', 0, () => {
      try {
        let vmInstance: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        expect(vmInstance).not().assertNull();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('mockTest', 0, () => {
      try {
        let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('mockBundle', 'mockMoudle', 'mockAbility');
        let scbSceneSession: SCBSceneSession = new SCBSceneSession(
          sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let scContainerSession: SCBSceneContainerSession =
          new SCBSceneContainerSession(scbSceneSession, screenProperty);
        sessionList.add(scContainerSession);
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
          SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getScreenWidthTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.setScreenProperty(2, 4);
        expect(scbRecentSession.getScreenWidth()).assertEqual(2);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getScreenHeightTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.setScreenProperty(2, 4);
        expect(scbRecentSession.getScreenHeight()).assertEqual(4);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getCurrentShowWidthTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.setRecentProperty(4, 4);
        expect(scbRecentSession.getCurrentShowWidth()).assertEqual(4);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getCurrentShowHeightTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.setRecentProperty(4, 4, true);
        expect(scbRecentSession.getCurrentShowHeight()).assertEqual(4);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setRecentPropertyTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.setRecentProperty(2, 4);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setSplitRecentPropertyTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.setSplitRecentProperty(2, 2, false);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getSplitOffsetTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.setSplitRecentProperty(112, 112, true);
        expect(scbRecentSession.getSplitOffset()).assertEqual(62);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getRecentSessionsListIfNotSupportSplitModeTest', 0, () => {
      try {
        let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('ifNotSupportSplitModeBundle',
          'ifNotSupportSplitModeMoudle', 'ifNotSupportSplitModeAbility');
        let scbSceneSession: SCBSceneSession = new SCBSceneSession(
          sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let scContainerSession: SCBSceneContainerSession =
          new SCBSceneContainerSession(scbSceneSession, screenProperty);
        sessionList.add(scContainerSession);
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
          SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.getRecentSessionsListIfNotSupportSplitMode();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getRecentSessionsNotIncludeTest', 0, () => {
      try {
        let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('getRecentSessionsNotIncludeBundle',
          'getRecentSessionsNotIncludeMoudle', 'getRecentSessionsNotIncludeAbility');
        let scbSceneSession: SCBSceneSession = new SCBSceneSession(
          sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let scContainerSession: SCBSceneContainerSession =
          new SCBSceneContainerSession(scbSceneSession, screenProperty);
        sessionList.add(scContainerSession);
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
          SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        let ids: number[] = [];
        scbRecentSession.getRecentSessionsNotInclude(ids);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getRecentSessionsNotInclude2Test', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        let ids: number[] = [];
        let sessionList2: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
          SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList2);
        scbRecentSession.getRecentSessionsNotInclude(ids);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getRecentSessionsNotInclude3Test', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        let ids: number[] = [];
        let sessionList3: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
          SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList3);
        let mocker2: MockKit = new MockKit();
        let mockFunc2 = mocker2.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppInfoByBundleName);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(new AppItemInfo());
        scbRecentSession.getRecentSessionsNotInclude(ids);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getRecentSessionsTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        let rSessions: SCBRecentSessionInfo[] = scbRecentSession.getRecentSessions();
        expect(rSessions).not().assertNull();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getRecentSessions2Test', 0, () => {
      try {
        let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('getRecentSessions2Bundle',
          'getRecentSessions2Moudle', 'getRecentSessions2Ability');
        let scbSceneSession: SCBSceneSession = new SCBSceneSession(
          sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let scContainerSession: SCBSceneContainerSession =
          new SCBSceneContainerSession(scbSceneSession, screenProperty);
        sessionList.add(scContainerSession);
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
          SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.getRecentSessions();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setRecentSessionsListCallbackTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getRecentSessionsListTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.getRecentSessionsList();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getRecentSessionsList3Test', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('getRecentSessionsList3Bundle',
          'getRecentSessionsList3Moudle', 'getRecentSessionsList3Ability');
        let scbSceneSession: SCBSceneSession = new SCBSceneSession(
          sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        let screenProperty: SCBScreenProperty = new SCBScreenProperty();
        let scContainerSession: SCBSceneContainerSession =
          new SCBSceneContainerSession(scbSceneSession, screenProperty);
        sessionList.add(scContainerSession);
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
          SCBSceneSessionManager.getInstance().getContainerSessionList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);
        scbRecentSession.getRecentSessionsList();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getRecentSessionsList4Test', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppInfoByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(new AppItemInfo());
        scbRecentSession.getRecentSessionsList();
        mocker.clear(AppModel.getInstance());
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setSplittingSessionIdTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.setSplittingSessionId(1);
      } catch (e) {
        expect(false).assertFail();
      }
    })


    it('terminateRecentIfAllClearTest', 0, () => {
      try {
        let scbRecentSession: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
        scbRecentSession.terminateRecentIfAllClear();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('init', 0, () => {
      try {
        let mhInstance: MemoryHelper = MemoryHelper.getInstance();
        mhInstance.init(1);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('reInit', 0, () => {
      try {
        let mhInstance: MemoryHelper = MemoryHelper.getInstance();
        mhInstance.init(2);
        mhInstance.init(3);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('refresh', 0, () => {
      try {
        let mhInstance: MemoryHelper = MemoryHelper.getInstance();
        mhInstance.refresh();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getLength', 0, () => {
      try {
        let mhInstance: MemoryHelper = MemoryHelper.getInstance();
        mhInstance.init(2);
        mhInstance.getLength();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('setCache', 0, () => {
      try {
        let mhInstance: MemoryHelper = MemoryHelper.getInstance();
        mhInstance.setCache(0, 1);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getCache', 0, () => {
      try {
        let mhInstance: MemoryHelper = MemoryHelper.getInstance();
        mhInstance.setCache(0, 2);
        expect(mhInstance.getCache(0)).assertEqual(2);
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('getCache', 0, () => {
      try {
        let mhInstance: MemoryHelper = MemoryHelper.getInstance();
        mhInstance.setCache(0, 2);
        expect(mhInstance.getCache(0)).assertEqual(2);
      } catch (e) {
        expect(false).assertFail();
      }
    })
  })
}

function getInstanceTest() {
  it('getInstanceTest', Level.LEVEL0, (): void => {
    let testGetInstance = SCBRecentSessionsViewModel.getInstance();
    expect(testGetInstance === undefined).assertFalse();
  });
}

function getRecentSessionInfoTest() {
  it('getRecentSessionInfoTest_01', 0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let getRecentSessionInfoResult: SCBRecentSessionInfo = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel, 'getRecentSessionInfo', scbSceneSession);
    expect(getRecentSessionInfoResult === undefined).assertFalse();
  });
  it('getRecentSessionInfoTest_02', 0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle1', 'testModule1', 'testAbility1');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let getRecentSessionInfo: Function = ReflectionUtils.getProperty(
      sCBRecentSessionsViewModel,'getRecentSessionInfo') as Function;
    expect(getRecentSessionInfo(scbSceneSession).sessionId).assertEqual(scbSceneSession.session.persistentId);
  });

  it('getRecentSessionInfoTest_03', 0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let getRecentSessionInfo: SCBRecentSessionInfo = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel,'getRecentSessionInfo',scbSceneSession) ;
    expect(getRecentSessionInfo.sessionId).assertEqual(scbSceneSession.session.persistentId);
  });
}


function isSupportSplitModeTest() {
  it('isSupportSplitModeTest_01', Level.LEVEL0, (): void => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('undefined', 'testModule', 'testAbility');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let isSupportSplitModeResult: boolean = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel, 'isSupportSplitMode', scbSceneSession);
    expect(isSupportSplitModeResult).assertFalse();
  });
  it('isSupportSplitModeTest_02', Level.LEVEL0, (): void => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'undefined', 'testAbility');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let isSupportSplitModeResult: boolean = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel, 'isSupportSplitMode', scbSceneSession);
    expect(isSupportSplitModeResult).assertFalse();
  });
  it('isSupportSplitModeTest_03', Level.LEVEL0, (): void => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'undefined');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let isSupportSplitModeResult: boolean = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel, 'isSupportSplitMode', scbSceneSession);
    expect(isSupportSplitModeResult).assertFalse();
  });
  it('isSupportSplitModeTest_04', Level.LEVEL0, (): void => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let isSupportSplitModeResult: boolean = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel, 'isSupportSplitMode', scbSceneSession);
    expect(isSupportSplitModeResult).assertFalse();
  });
  it('isSupportSplitModeTest_05', Level.LEVEL0, (): void => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    sceneInfo.supportWindowModes = [0, 1, 2];
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let isSupportSplitModeResult: boolean = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel, 'isSupportSplitMode', scbSceneSession);
    expect(isSupportSplitModeResult).assertTrue();
  });
  it('isSupportSplitModeTest_06', Level.LEVEL0, (): void => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    sceneInfo.supportWindowModes = [0, 2];
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let isSupportSplitModeResult: boolean = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel, 'isSupportSplitMode', scbSceneSession);
    expect(isSupportSplitModeResult).assertFalse();
  });
  it('isSupportSplitModeTest_07', Level.LEVEL0, (): void => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    sceneInfo.supportWindowModes = [];
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let isSupportSplitModeResult: boolean = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel, 'isSupportSplitMode', scbSceneSession);
    expect(isSupportSplitModeResult).assertFalse();
  });
  it('isSupportSplitModeTest_08', Level.LEVEL0, (): void => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    sceneInfo.supportWindowModes = [1];
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let isSupportSplitModeResult: boolean = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel, 'isSupportSplitMode', scbSceneSession);
    expect(isSupportSplitModeResult).assertTrue();
  });
}

function updateRecentSessionInfoTest() {
  it('updateRecentSessionInfoTest_01', 0, () => {
    let testRecentSessionInfo: SCBRecentSessionInfo = new SCBRecentSessionInfo();
    let testSCBSceneInfo_01: SCBSceneInfo = new SCBSceneInfo('', '', '');
    let testSession_01 = sceneSessionManager.requestSceneSession(testSCBSceneInfo_01);
    let testPrimarySCBSceneSession_01: SCBSceneSession = new SCBSceneSession(testSession_01, testSCBSceneInfo_01);
    let testSCBScreenProperty_01: SCBScreenProperty = new SCBScreenProperty();
    let testContainer: SCBSceneContainerSession = new SCBSceneContainerSession(
      testPrimarySCBSceneSession_01, testSCBScreenProperty_01);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let updateRecentSessionInfo: Function = ReflectionUtils.getProperty(
      sCBRecentSessionsViewModel,'updateRecentSessionInfo') as Function;
    updateRecentSessionInfo(testRecentSessionInfo, testContainer);
    expect(true).assertTrue();
  });

  it('getRecentSessionInfoTest_02', 0, () => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
    let scbSceneSession: SCBSceneSession = new SCBSceneSession(
      sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    let getRecentSessionInfo: SCBRecentSessionInfo = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel,'getRecentSessionInfo',scbSceneSession) ;
    expect(getRecentSessionInfo.sessionId).assertEqual(scbSceneSession.session.persistentId);
  });

  it('updateRecentSessionInfoTest_03', 0, () => {
    let testRecentSessionInfo: SCBRecentSessionInfo = new SCBRecentSessionInfo();
    let testSCBSceneInfo_01: SCBSceneInfo = new SCBSceneInfo('', '', '');
    let testSession_01 = sceneSessionManager.requestSceneSession(testSCBSceneInfo_01);
    let testPrimarySCBSceneSession_01: SCBSceneSession = new SCBSceneSession(testSession_01, testSCBSceneInfo_01);
    let testSCBScreenProperty_01: SCBScreenProperty = new SCBScreenProperty();
    let testContainer: SCBSceneContainerSession = new SCBSceneContainerSession(
      testPrimarySCBSceneSession_01, testSCBScreenProperty_01);

    let updateRecentSessionInfo: SCBRecentSessionInfo = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel,'updateRecentSessionInfo',testRecentSessionInfo, testContainer);
    expect(updateRecentSessionInfo.isActive).assertEqual(testContainer.isActive);
  });
}

function setScreenPropertyTest() {
  it('setScreenPropertyTest_01', 0, () => {
    sCBRecentSessionsViewModel.setScreenProperty(100, 100);
    let testMScreenWidth: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mScreenWidth');
    let testMScreenHeight: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mScreenHeight');
    expect(testMScreenWidth).assertEqual(100);
    expect(testMScreenHeight).assertEqual(100);
  });
}

function getScreenWidthTest() {
  it('getScreenWidthTest_01', 0, () => {
    sCBRecentSessionsViewModel.setScreenProperty(300, 200);
    expect(sCBRecentSessionsViewModel.getScreenWidth()).assertEqual(300);
  });
}

function getScreenHeightTest() {
  it('getScreenHeightTest_01', 0, () => {
    sCBRecentSessionsViewModel.setScreenProperty(300, 200);
    expect(sCBRecentSessionsViewModel.getScreenHeight()).assertEqual(200);
  });
}

function setRecentPropertyTest() {
  it('setRecentPropertyTest_01', 0, () => {
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    sCBRecentSessionsViewModel.setRecentProperty(400, 400, false);
    let testSplitOffset: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel,'splitOffset');
    expect(testSplitOffset).assertEqual(0);

  });
  it('setRecentPropertyTest_02', 0, () => {
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    sCBRecentSessionsViewModel.setRecentProperty(400, 400, true);
    let testSplitOffset: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel,'splitOffset');
    expect(testSplitOffset).assertEqual(0);
  });
  it('setRecentPropertyTest_03', 0, () => {
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    sCBRecentSessionsViewModel.setRecentProperty(400, 400, true);
    let testmCurrentShowWidth: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mCurrentShowWidth');
    let testmCurrentShowHeight: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mCurrentShowHeight');
    let testmCardMaxHeight: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mCardMaxHeight');
    let testmCardMinHeight: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mCardMinHeight');
    let testmWorkspaceWidth: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mWorkspaceWidth');
    let testmCardMargin: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mCardMargin');
    let testmarginToLeftEdge: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'marginToLeftEdge');
    expect(testmCurrentShowWidth).assertEqual(194);
    expect(testmCurrentShowHeight).assertEqual(400);
    expect(testmCardMaxHeight).assertEqual(160);
    expect(testmCardMinHeight).assertEqual(72);
    expect(testmWorkspaceWidth).assertEqual(162.96);
  })
  it('setRecentPropertyTest_04', 0, () => {
    let sCBRecentSessionsViewModel: SCBRecentSessionsViewModel = SCBRecentSessionsViewModel.getInstance();
    sCBRecentSessionsViewModel.setRecentProperty(400, 400, false);
    let testmCurrentShowWidth: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mCurrentShowWidth');
    let testmCurrentShowHeight: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mCurrentShowHeight');
    let testmCardMaxHeight: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mCardMaxHeight');
    let testmCardMinHeight: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mCardMinHeight');
    let testmWorkspaceWidth: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mWorkspaceWidth');
    let testmCardMargin: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'mCardMargin');
    let testmarginToLeftEdge: number = ReflectionUtils.getProperty(sCBRecentSessionsViewModel, 'marginToLeftEdge');
    expect(testmCurrentShowWidth).assertEqual(400);
    expect(testmCurrentShowHeight).assertEqual(400);
    expect(testmCardMaxHeight).assertEqual(160);
    expect(testmCardMinHeight).assertEqual(72);
    expect(testmWorkspaceWidth).assertEqual(336);
    expect(testmCardMargin).assertEqual(8.4);
    expect(testmarginToLeftEdge).assertEqual(32);
  });
}

function getCurrentShowWidthTest() {
  it('getCurrentShowWidthTest_01', 0, () => {
    sCBRecentSessionsViewModel.setRecentProperty(400, 400, false);
    expect(sCBRecentSessionsViewModel.getCurrentShowWidth()).assertEqual(400);
  });
  it('getCurrentShowWidthTest_02', 0, () => {
    sCBRecentSessionsViewModel.setRecentProperty(400, 400, true);
    expect(sCBRecentSessionsViewModel.getCurrentShowWidth()).assertEqual(194);
  });
}

function getCurrentShowHeightTest() {
  it('getCurrentShowHeightTest_01', 0, () => {
    sCBRecentSessionsViewModel.setRecentProperty(400, 400, false);
    expect(sCBRecentSessionsViewModel.getCurrentShowHeight()).assertEqual(400);
  });
  it('getCurrentShowHeightTest_02', 0, () => {
    sCBRecentSessionsViewModel.setRecentProperty(400, 400, true);
    expect(sCBRecentSessionsViewModel.getCurrentShowHeight()).assertEqual(400);
  });
}

function setSplitRecentPropertyTest() {
  it('setSplitRecentPropertyTest_01', 0, () => {
    sCBRecentSessionsViewModel.setSplitRecentProperty(400, 400, false);
    expect(sCBRecentSessionsViewModel.getSplitOffset()).assertEqual(0);
  });
  it('setSplitRecentPropertyTest_02', 0, () => {
    sCBRecentSessionsViewModel.setSplitRecentProperty(400, 400, true);
    expect(sCBRecentSessionsViewModel.getSplitOffset()).assertEqual(206);
  });
}

function getSplitOffsetTest() {
  it('getSplitOffsetTest_01', 0, () => {
    let result = sCBRecentSessionsViewModel.getRecentSessionsListIfNotSupportSplitMode();
    expect(result !== null).assertTrue();
  });
}

function getRecentSessionsNotIncludeTest() {
  it('getRecentSessionsNotIncludeTest_01', 0, () => {
    let testPersistentIds: number[] = [];
    let result = sCBRecentSessionsViewModel.getRecentSessionsNotInclude(testPersistentIds);
    expect(result !== null).assertTrue();
  });
  it('getRecentSessionsNotIncludeTest_02', 0, () => {
    let mocker: MockKit = new MockKit();
    let func: Function = mocker.mockFunc(sCBRecentSessionsViewModel,
      sCBRecentSessionsViewModel.getRecentSessionsNotInclude);
    when(func)(ArgumentMatchers.any).afterReturn(false);
    mocker.clear(sCBRecentSessionsViewModel);
    mocker.clearAll();
  });
}

function getRecentSessionsTest() {
  it('getRecentSessionsTest_01', 0, () => {
    let result = sCBRecentSessionsViewModel.getRecentSessions();
    expect(result !== null).assertTrue();
  });
}

function getRecentSessionsListTest() {
  it('getRecentSessionsListTest_01', 0, () => {
    let result = sCBRecentSessionsViewModel.getRecentSessionsList();
    expect(result !== null).assertTrue();
  });
}

function terminateRecentIfAllClearTest() {
  it('terminateRecentIfAllClearTest_01', 0, () => {
    let result = sCBRecentSessionsViewModel.terminateRecentIfAllClear();
    expect(result !== null).assertTrue();
  });
}

function getTitleHeightTest() {
  it('getTitleHeightTest_01', 0, () => {
    let titleHeight: number = ReflectionUtils.useFunc(sCBRecentSessionsViewModel,'getTitleHeight');
    let standardTitleHeight: number = SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE +
      SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2
    expect(titleHeight).assertEqual(standardTitleHeight);
  });
  it('getTitleHeightTest_02', 0, () => {
    let titleHeight: number = ReflectionUtils.useFunc(sCBRecentSessionsViewModel,'getTitleHeight');
    let standardTitleHeight: number = SCBRecentStyleConstants.DOUBLE_LIST_DEFAULT_APP_ICON_SIZE +
      SCBRecentStyleConstants.DOUBLE_LIST_APP_INFO_BOTTOM_MARGIN * 2
    expect(titleHeight).assertEqual(standardTitleHeight);
  });
}

function judgeAnimationTypeTest() {
  it('judgeAnimationTypeTest_01', 0, () => {
    let testRecentSessions: Array<SCBRecentSessionInfo> = [];
    let testJudgeAnimationType: void = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel,'judgeAnimationType', testRecentSessions);
    expect(testJudgeAnimationType !== null).assertTrue();
  });
  it('judgeAnimationTypeTest_02', 0, () => {
    let testRecentSessionInfo: SCBRecentSessionInfo = new SCBRecentSessionInfo();
    let testRecentSessions: Array<SCBRecentSessionInfo> = [testRecentSessionInfo];
    let judgeAnimationType: void = ReflectionUtils.useFunc(
      sCBRecentSessionsViewModel,'judgeAnimationType',testRecentSessions);
    expect(judgeAnimationType !== null).assertTrue();
  });
}

function getRecentTitleAppNameIdTest() {
  it('getRecentTitleAppNameIdTest_01', 0, () => {
    let result = sCBRecentSessionsViewModel.getRecentTitleAppNameId(1, 'testBundleName');
    expect(result).assertEqual(1 + SCBRecentStyleConstants.RECENT_VIEW_TITLE + '_Text_' + 'testBundleName');
  });
}

function printTest() {
  it('printTest_01', 0, () => {
    let result = sCBRecentSessionsViewModel.print();
    expect(result !== null).assertTrue();
  });
}

function registerDebugCommandTest() {
  it('registerDebugCommandTest_01', 0, () => {
    let result: void = ReflectionUtils.useFunc(sCBRecentSessionsViewModel,'registerDebugCommand');
    expect(result !== null).assertTrue();
  });
}

function memoryHelperGetInstanceTest() {
  it('memoryHelperGetInstanceTest_01', 0, () => {
    let result = MemoryHelper.getInstance();
    expect(result === undefined).assertFalse()
  });
}

function memoryHelperInitTest() {
  it('memoryHelperInitTest_01', 0, () => {
    memoryHelper.init(-1);
    memoryHelper.refresh();
    expect(memoryHelper.getLength()).assertEqual(0);
  });
  it('memoryHelperInitTest_02', 0, () => {
    memoryHelper.init(1);
    memoryHelper.refresh();
    expect(memoryHelper.getLength()).assertEqual(0);
  });
}

function memoryHelperRefreshTest() {
  it('memoryHelperRefreshTest_01', 0, () => {
    memoryHelper.refresh();
    expect(memoryHelper.getLength()).assertEqual(0);
  });
}

function memoryHelperGetLengthTest() {
  it('memoryHelperGetLengthTest_01', 0, () => {
    expect(memoryHelper.getLength()).assertEqual(0);
  });
}

function memoryHelperSetCacheTest() {
  it('memoryHelperSetCacheTest_01', 0, () => {
    memoryHelper.setCache(0, 1);
    expect(memoryHelper.getLength()).assertEqual(1);
  });
}

function memoryHelperGetCacheTest() {
  it('memoryHelperGetCacheTest_01', 0, () => {
    memoryHelper.setCache(0, 2);
    expect(memoryHelper.getCache(0)).assertEqual(2);
  });
}