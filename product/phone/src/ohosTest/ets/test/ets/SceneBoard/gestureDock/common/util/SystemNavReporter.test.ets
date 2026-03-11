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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';

import {
  SystemNavReporter
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/util/SystemNavReporter';
import {
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';

export function SystemNavReporterTest() {
  describe('SystemNavReporterTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('SystemNavReporterTest_getForegroundSessionList_001', 0, (): void => {
      let scbSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mocker: MockKit = new MockKit();
      let containerSessionList =
        mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList);
      when(containerSessionList)().afterReturn([]);
      let floatContainerSessionList = mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getFloatingSessionList);
      when(floatContainerSessionList)().afterReturn([]);
      expect(SystemNavReporter.getForegroundSessionList()).assertEqual(['desktop']);
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
    })

    it('SystemNavReporterTest_getForegroundSessionList_002', 0, (): void => {
      let scbSceneSessionManager = SCBSceneSessionManager.getInstance();
      let scbSceneInfo: SCBSceneInfo =
        new SCBSceneInfo('com.ohos.photos', 'phone_photos', 'com.ohos.photos.MainAbility');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let container: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let mocker: MockKit = new MockKit();
      let activeContainerSession =
        mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList().getTopActiveSession);
      when(activeContainerSession)().afterReturn(container);
      let floatContainerSessionList =
        mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getFloatingSessionList);
      when(floatContainerSessionList)().afterReturn([]);
      container.isSplit = true;
      SystemNavReporter.getForegroundSessionList();
      container.isSplit = false;
      expect(SystemNavReporter.getForegroundSessionList() !== undefined).assertTrue();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
    })

    it('SystemNavReporterTest_getForegroundSessionList_003', 0, (): void => {
      let scbSceneSessionManager = SCBSceneSessionManager.getInstance();
      let scbSceneInfo: SCBSceneInfo =
        new SCBSceneInfo('com.ohos.photos', 'phone_photos', 'com.ohos.photos.MainAbility');
      let scbSceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
      let container: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
      let mocker: MockKit = new MockKit();
      let activeContainerSession =
        mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getContainerSessionList().getTopActiveSession);
      when(activeContainerSession)().afterReturn(null);
      let floatContainerSessionList =
        mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getFloatingSessionList);
      when(floatContainerSessionList)().afterReturn([container]);
      expect(SystemNavReporter.getForegroundSessionList() !== undefined).assertTrue();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
    })
  })
}
