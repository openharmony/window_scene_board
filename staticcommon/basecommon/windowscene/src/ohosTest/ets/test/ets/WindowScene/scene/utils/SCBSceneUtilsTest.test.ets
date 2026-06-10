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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium'
import { SCBSceneInfo } from '../../../../../../../main/ets/scene/session/SCBSceneInfo'
import { SCBSceneOrientation } from '../../../../../../../main/ets/scene/session/SCBSceneOrientation'
import { SCBSceneSession } from '../../../../../../../main/ets/scene/session/SCBSceneSession'
import { SCBSceneSessionManager } from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager'
import { SCBSceneUtils } from '../../../../../../../main/ets/scene/utils/SCBSceneUtils'
import { ReflectionUtils } from '../../utils/ReflectionUtils'
import {
  WindowMode
} from '../../../../../../../../../../basecommon/componenthelper/src/main/ets/manager/ASCFWindowManager'

export default function SCBSceneUtilsTest() {
  describe('SCBSceneUtilsTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_isPhoneCallScene_should_return_false_when_null_info', 0, () => {
      expect(SCBSceneUtils.isPhoneCallScene(null)).assertFalse();
    })

    it('test_isPhoneCallScene_should_return_false_when_not_phone_info', 0, () => {
      const sceneInfo = new SCBSceneInfo('com.test.test', 'entry', 'MainAbility');
      expect(SCBSceneUtils.isPhoneCallScene(sceneInfo)).assertFalse();
    })

    it('test_isPhoneCallScene_should_return_false_when_phone_call_bundle_not_call_ability', 0, () => {
      const sceneInfo = new SCBSceneInfo('com.ohos.callui', 'entry', 'TestAbility');
      expect(SCBSceneUtils.isPhoneCallScene(sceneInfo)).assertTrue();

      const sceneInfo2 = new SCBSceneInfo('com.ohos.meetimeservice', 'test', 'TestAbility');
      expect(SCBSceneUtils.isPhoneCallScene(sceneInfo2)).assertTrue();
    })

    it('test_isPhoneCallScene_should_return_true_when_phone_info', 0, () => {
      const sceneInfo = new SCBSceneInfo('com.ohos.callui', 'entry', 'com.ohos.callui.MainAbility');
      expect(SCBSceneUtils.isPhoneCallScene(sceneInfo)).assertTrue();

      const sceneInfo2 = new SCBSceneInfo('com.ohos.meetimeservice', 'test', 'CallUIKitAbility');
      expect(SCBSceneUtils.isPhoneCallScene(sceneInfo2)).assertTrue();
    })

    it('test_isLandscapeApp_with_sceneInfo', 0, () => {
      let sceneInfo = new SCBSceneInfo('com.test.test', 'entry', 'TestAbility');
      let mocker: MockKit = new MockKit();
      let sceneManager = SCBSceneSessionManager.getInstance();
      let mockFunc: Function = mocker.mockFunc(sceneManager, sceneManager.getAbilityOrientation);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.USER_ROTATION_LANDSCAPE);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.HORIZONTAL);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.REVERSE_HORIZONTAL);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.SENSOR_HORIZONTAL);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertTrue();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.UNSPECIFIED);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.VERTICAL);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.REVERSE_VERTICAL);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.SENSOR);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.SENSOR_VERTICAL);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.AUTO_ROTATION_RESTRICTED);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.LOCKED);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.FOLLOW_RECENT);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.AUTO_ROTATION_UNSPECIFIED);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.USER_ROTATION_PORTRAIT);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.USER_ROTATION_PORTRAIT_INVERTED);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      when(mockFunc)(ArgumentMatchers.any).afterReturn(SCBSceneOrientation.FOLLOW_DESKTOP);
      expect(SCBSceneUtils.isLandscapeApp(sceneInfo)).assertFalse();

      mocker.clear(sceneManager);
    })

    it('test_isLandscapeApp_with_sceneSession', 0, () => {
      let sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('isLandscapeApp', 'isLandscapeApp', 'isLandscapeApp');
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_LANDSCAPE;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertTrue();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_LANDSCAPE_INVERTED;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertTrue();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_LANDSCAPE_RESTRICTED;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertTrue();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.HORIZONTAL;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertTrue();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.REVERSE_HORIZONTAL;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertTrue();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR_HORIZONTAL;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertTrue();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.UNSPECIFIED;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.VERTICAL;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.REVERSE_VERTICAL;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.SENSOR_VERTICAL;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_RESTRICTED;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_PORTRAIT_RESTRICTED;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.LOCKED;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.FOLLOW_RECENT;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.AUTO_ROTATION_UNSPECIFIED;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_PORTRAIT;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.USER_ROTATION_PORTRAIT_INVERTED;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();

      sceneSession.sessionData.requestOrientation = SCBSceneOrientation.FOLLOW_DESKTOP;
      expect(SCBSceneUtils.isLandscapeApp(sceneSession)).assertFalse();
    })
  })
}