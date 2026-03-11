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

import { LogDomain, Logger } from '@ohos/basicutils';
import {
  describe,
  beforeAll,
  it,
  expect,
  Level,
  beforeEach,
  MockKit,
  when,
  ArgumentMatchers,
  afterEach,
  afterAll,
} from '@ohos/hypium';
import {
  SCBSpecificSceneSessionList,
  SpecificPanelZOrder,
  SCBSceneSessionManager,
  SCBSceneInfo
} from '../../../../../main/ets/TsIndex';
import { SCBSpecificSceneManager } from '../../../../../../Index';
import { SCBSpecificScenePanelHandler } from '../../../../../main/ets/scene/manager/SCBSpecificSceneManager';
import { ReflectionUtils } from '../WindowScene/utils/ReflectionUtils';
import { SCBSpecificSession } from '../../../../../main/ets/scene/session/SCBSpecificSession';

class MockVirtualSpecificScenePanelHandler implements SCBSpecificScenePanelHandler {
  screenId: number = 0;
  zorder: number = 0;
  specificSceneSessionList = new SCBSpecificSceneSessionList();

  getSpecificSceneSessionList(): SCBSpecificSceneSessionList {
    return this.specificSceneSessionList;
  }

  pushInSpecificSession(session: SCBSpecificSceneSessionList, fromScreenId: number): void {
  }
}

export default function SCBSpecificSceneManagerTest() {

  describe('SCBSpecificSceneManagerTest_SpecificPanelAndScreen_TestSuite', () => {
    let specificSceneManager = SCBSpecificSceneManager.getInstance();
    const TAG = 'SCBSpecificSceneManager';
    let log = Logger.getLogHelper(LogDomain.WINDOW);
    let mocker: MockKit = new MockKit();

    beforeAll(() => {

    });

    it('should_logInfo_when_screenStateChanged', 0, async () => {
      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      specificSceneManager.notifyScreenStateChange(1000, false);
      mocker.verify('showInfo', [TAG]).once();

      specificSceneManager.notifyScreenStateChange(1000, true);
      mocker.verify('showInfo', [TAG]).once();

      mocker.ignoreMock(log, log.showInfo);
    });

    it('should_registerPanelFailed_when_useNullPanelHandler', 0, async () => {
      let panelMap = ReflectionUtils.getProperty(specificSceneManager,
        'specificPanelMap') as Map<number, SCBSpecificScenePanelHandler>;
      const curSize = panelMap.size;
      specificSceneManager.registerSpecificScenePanelHandler(null);
      expect(panelMap.size).assertEqual(curSize);
    });

    it('should_unregisterPanelFailed_when_useNullPanelHandler', 0, async () => {
      let panelMap = ReflectionUtils.getProperty(specificSceneManager,
        'specificPanelMap') as Map<number, SCBSpecificScenePanelHandler>;
      const curSize = panelMap.size;
      specificSceneManager.unregisterSpecificScenePanelHandler(null);
      expect(panelMap.size).assertEqual(curSize);
    });

    it('should_moveSpecificSessionToMainScreen_when_screenDisconnect', 0, async () => {
      let specificScenePanel1001 = new MockVirtualSpecificScenePanelHandler();
      specificScenePanel1001.screenId = 1001;
      specificScenePanel1001.zorder = SpecificPanelZOrder.ABOVE_SCENE_PANEL;
      specificSceneManager.registerSpecificScenePanelHandler(specificScenePanel1001);

      let sceneInfo = new SCBSceneInfo('com.test', 'entry', 'TestAbility');
      sceneInfo.screenId = 1001;
      let sceneSession = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
      let scbSceneSession = new SCBSpecificSession(sceneSession, () => {});
      specificScenePanel1001.specificSceneSessionList.push(scbSceneSession);
      expect(scbSceneSession.screenId).assertEqual(1001);

      specificSceneManager.notifyScreenStateChange(1001, false);
      expect(scbSceneSession.screenId).assertEqual(0);
    });
  });
}