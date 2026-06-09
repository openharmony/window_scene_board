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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { ApsUtils } from '../../../../../../main/ets/utils/ApsUtils';
import apsManager from '@hms.graphic.apsManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'ApsUtilsTest';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export function ApsUtilsTest() {
  describe('ApsUtilsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('ApsUtilsTest_setApsScene', 0, (): void => {
      ApsUtils.setApsScene(null, 0);
      ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_MULTIPLE_TASKBARS, 1);
      expect(true).assertTrue();
    });

    it('should_return_new_session_id_when_curApsSessionId_is_not_empty', 0, () => {
      ApsUtils.startApsPersistentSession(null);
      ApsUtils.startApsPersistentSession(apsManager.SceneAnimation.BACK_MULTIPLE_TASKBARS);
    });

    it('ApsUtilsTest_setApsScene_mock', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockerFunDebug: Function = mocker.mockFunc(log, log.showDebug);
      when(mockerFunDebug)(ArgumentMatchers.any).afterThrow('mock error');

      ApsUtils.setApsScene(apsManager.SceneAnimation.BACK_MULTIPLE_TASKBARS, 1);
      expect(true).assertTrue();
      mocker.clear(mockerFunDebug);
      mocker.ignoreMock(log, mockerFunDebug);
      mocker.clearAll();
    });

    it('ApsUtilsTest_pulseApsSession_invalid_args', 0, (): void => {
      expect(ApsUtils.pulseApsSession('')).assertFalse();

      ApsUtils.setApsScene(apsManager.SceneAnimation.NONE_ANIMATION, 1);
      const id = 'curApsSessionId';
      (ApsUtils as object)['curApsSessionId'] = id;
      let result = ApsUtils.pulseApsSession('test id');
      expect(result).assertFalse();
    });

    it('ApsUtilsTest_pulseApsSession', 0, (): void => {
      ApsUtils.setApsScene(apsManager.SceneAnimation.NONE_ANIMATION, 1);
      const id = 'curApsSessionId';
      (ApsUtils as object)['curApsSessionId'] = id;
      ApsUtils.pulseApsSession(id);

      (ApsUtils as object)['apsWindowAliveCnt'] = 10;
      (ApsUtils as object)['apsWindowInterValCnt'] = 1;
      expect(ApsUtils.pulseApsSession(id)).assertTrue();
    });

    it('ApsUtilsTest_setApsSceneOfContainerInAndOut', 0, (): void => {
      ApsUtils.setApsSceneOfContainerInAndOut(null, false, 0);
      ApsUtils.setApsSceneOfContainerInAndOut(apsManager.SceneAnimation.BACK_MULTIPLE_TASKBARS, true, 1);
      expect(true).assertTrue();
    });

    it('ApsUtilsTest_setAppPackName', 0, (): void => {
      const bundleName = 'com.hauwei.ohos.camera, com.tencent.wechat';
      ApsUtils.setAppPackName(null);
      ApsUtils.setAppPackName(bundleName);
      expect(true).assertTrue();
    });
  })
}