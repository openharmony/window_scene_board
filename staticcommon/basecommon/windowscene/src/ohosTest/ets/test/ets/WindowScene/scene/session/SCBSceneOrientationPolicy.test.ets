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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect
} from '@ohos/hypium'

import {
  SCBSceneOrientationPolicy,
  SCBFollowDesktopOrientationPolicy,
  SCBDefaultOrientationPolicy
} from '../../../../../../../main/ets/scene/session/SCBSceneOrientationPolicy';
import { RotationConstants } from '@ohos/commonconstants';

export function SCBSceneOrientationPolicyTest() {
  describe('SCBSceneOrientationPolicyTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('setRotationPolicyTest', 0, () => {
      SCBFollowDesktopOrientationPolicy.getInstance().setRotationPolicy(false,false,false,false);
      expect(SCBFollowDesktopOrientationPolicy.getInstance().rotationPolicyMap.get(RotationConstants.ROTATION_0)).assertFalse();
    })
    it('parseRotationPolicyTest', 0, () => {
      let rotationPolicyMap = SCBDefaultOrientationPolicy.parseRotationPolicy("15");
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_0)).assertTrue();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_90)).assertTrue();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_180)).assertTrue();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_270)).assertTrue();
    })
    it('parseAutoRotationUnspecifiedPolicyTest_1', 0, () => {
      let rotationPolicyMap = SCBSceneOrientationPolicy.parseAutoRotationUnspecifiedRotationPolicy("15");
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_0)).assertTrue();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_90)).assertTrue();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_180)).assertTrue();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_270)).assertTrue();
    });
    it('parseAutoRotationUnspecifiedPolicyTest_2', 0, () => {
      let rotationPolicyMap = SCBSceneOrientationPolicy.parseAutoRotationUnspecifiedRotationPolicy("14");
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_0)).assertTrue();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_90)).assertTrue();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_180)).assertFalse();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_270)).assertTrue();
    });
    it('parseAutoRotationUnspecifiedPolicyTest_3', 0, () => {
      let rotationPolicyMap = SCBSceneOrientationPolicy.parseAutoRotationUnspecifiedRotationPolicy("9");
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_0)).assertTrue();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_90)).assertFalse();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_180)).assertFalse();
      expect(rotationPolicyMap.get(RotationConstants.ROTATION_270)).assertTrue();
    });
    it('getRotationPolicyMapTest', 0, () => {
      SCBDefaultOrientationPolicy.getInstance().parseDefaultRotationPolicyConfig("15");
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_0)).assertTrue();
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_90)).assertTrue();
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_180)).assertTrue();
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_270)).assertTrue();
      SCBDefaultOrientationPolicy.getInstance().parseDefaultRotationPolicyConfig("1");
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_0)).assertTrue();
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_90)).assertFalse();
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_180)).assertFalse();
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_270)).assertFalse();
    })
    it('parseDefaultRotationPolicyConfigTest', 0, () => {
      SCBDefaultOrientationPolicy.getInstance().parseDefaultRotationPolicyConfig("15");
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_0)).assertTrue();
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_90)).assertTrue();
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_180)).assertTrue();
      expect(SCBDefaultOrientationPolicy.getInstance().getRotationPolicyMap().get(RotationConstants.ROTATION_270)).assertTrue();
    })
    it('isRotateLockedUnrelatedTest', 0, () => {
      SCBDefaultOrientationPolicy.getInstance().parseDefaultRotationPolicyConfig("15");
      expect(SCBDefaultOrientationPolicy.getInstance().isRotateLockedUnrelated()).assertFalse();
      SCBDefaultOrientationPolicy.getInstance().parseDefaultRotationPolicyConfig("1");
      expect(SCBDefaultOrientationPolicy.getInstance().isRotateLockedUnrelated()).assertTrue();
    })
  })
}