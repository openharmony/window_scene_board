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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  beforeEach,
  describe,
  expect,
  it,
  Level,
} from '@ohos/hypium'
import {
  SCBSceneStartInterceptor,
  StartInterceptions
} from '../../../../../../../main/ets/scene/framework/missions/SCBSceneStartInterceptor';
import { SCBSceneInfo } from '../../../../../../../main/ets/scene/session/SCBSceneInfo';

const TAG = 'StartSceneTemplate';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export function SCBSceneStartInterceptorTest() {
  describe('SCBSceneStartInterceptor_registerAndUnregisterInterceptorRule_testSuite', () => {
    let interceptorInstance: SCBSceneStartInterceptor = SCBSceneStartInterceptor.getInstance();
    let sceneInfo01: SCBSceneInfo = new SCBSceneInfo('testBundle01', 'testModule01', 'testAbility01', 0, 9527);
    let sceneInfo02: SCBSceneInfo = new SCBSceneInfo('testBundle02', 'testModule02', 'testAbility02', 0, 9626);
    let rule = (sceneInfo: SCBSceneInfo, startFrom: StartInterceptions) => {
      if (sceneInfo.persistentId === 9527) {
        return true;
      }
      return false;
    }

    beforeEach(() => {
      interceptorInstance.clearInterceptorRules();
    });

    it('should_intercept_after_registering_rule_with_specific_screen_and_panel', Level.LEVEL0, () => {
      let screenId: number = 1;
      let panelId: number = 2;
      expect(interceptorInstance.shouldIntercept(sceneInfo01, StartInterceptions.FROM_ICON, screenId, panelId)).assertFalse();

      interceptorInstance.registerInterceptorRule(rule, screenId, panelId);
      expect(interceptorInstance.shouldIntercept(sceneInfo01, StartInterceptions.FROM_ICON, screenId, panelId)).assertTrue();
      expect(interceptorInstance.shouldIntercept(sceneInfo02, StartInterceptions.FROM_ICON, screenId, panelId)).assertFalse();
    });

    it('should_not_intercept_after_unregistering_rule', Level.LEVEL0, () => {
      let screenId: number = 1;
      let panelId: number = 2;
      interceptorInstance.registerInterceptorRule(rule, screenId, panelId);
      expect(interceptorInstance.shouldIntercept(sceneInfo01, StartInterceptions.FROM_ICON, screenId, panelId)).assertTrue();

      interceptorInstance.unregisterInterceptorRule(rule, screenId, panelId);
      expect(interceptorInstance.shouldIntercept(sceneInfo01, StartInterceptions.FROM_ICON, screenId, panelId)).assertFalse();
    });
  })
}