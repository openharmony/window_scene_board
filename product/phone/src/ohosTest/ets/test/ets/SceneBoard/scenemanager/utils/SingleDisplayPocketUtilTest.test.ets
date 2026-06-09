/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneSessionManager, sSCBOobeManager, } from '@ohos/windowscene';
import { OuterAppManager } from '@ohos/launchercommon';
import { SCBFloatManager } from './../../../../../../../main//ets/SceneBoard/scenemanager/multiwindow/SCBFloatManager';
import { describe, beforeEach, afterEach, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {
  SingleDisplayPocketUtil
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/utils/SingleDisplayPocketUtil';

const TAG: string = 'SingleDisplayPocketUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


export default function SingleDisplayPocketUtilTest() {
  describe('exitSessionForSinglePocket_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('exitSessionForSinglePocket_when_IS_SINGLE_DISPLAY_POCKET_is_false', 0, () => {
      let singleDisplayPocketUtil: SingleDisplayPocketUtil = new SingleDisplayPocketUtil();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(LogHelper, log.showInfo);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockFunc2: Function = mocker.mockFunc(sSCBOobeManager, sSCBOobeManager.isOobeActivated);
      when(mockFunc2)().afterReturn(false);
      let mockFunc3: Function = mocker.mockFunc(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      when(mockFunc3)().afterReturn(SCBSceneSessionManager.getInstance());
      let mockFunc4: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getContainerSessionList);
      when(mockFunc4)().afterReturn({
        getTopActiveSession: () => null
      });
      singleDisplayPocketUtil.transferToBackgroundWhenLocked();
      mocker.ignoreMock(LogHelper, log.showInfo);
      mocker.ignoreMock(sSCBOobeManager, sSCBOobeManager.isOobeActivated);
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getContainerSessionList);
    });

    it('exitSessionForSinglePocket_when_sSCBOobeManager_isOobeActivated_is_true', 0, () => {
      let singleDisplayPocketUtil: SingleDisplayPocketUtil = new SingleDisplayPocketUtil();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(LogHelper, log.showInfo);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockFunc2: Function = mocker.mockFunc(sSCBOobeManager, sSCBOobeManager.isOobeActivated);
      when(mockFunc2)().afterReturn(true);
      let mockFunc3: Function = mocker.mockFunc(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      when(mockFunc3)().afterReturn(SCBSceneSessionManager.getInstance());
      let mockFunc4: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getContainerSessionList);
      when(mockFunc4)().afterReturn({
        getTopActiveSession: () => null
      });
      singleDisplayPocketUtil.transferToBackgroundWhenLocked();
      mocker.ignoreMock(LogHelper, log.showInfo);
      mocker.ignoreMock(sSCBOobeManager, sSCBOobeManager.isOobeActivated);
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getContainerSessionList);
    });
  })
}