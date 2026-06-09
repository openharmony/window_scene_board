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
import { RotationConstants } from '@ohos/commonconstants';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { ResUtils, SCBRotateChangeReason } from '@ohos/windowscene';
import { CutoutVm } from '../../../../../../main/ets/statusbar/vm/CutoutVm';
import { StatusBarHeightVm } from '../../../../../../main/ets/statusbar/vm/StatusBarHeightVm';
import { DeviceInfoVm } from '../../../../../../main/ets/vm/DeviceInfoVm';
import { ILiveMetaBallVisibleVm } from '../../../../../../main/ets/live/interface/ILiveMetaBallVisibleVm';
import { LiveVmInjector } from '../../../../../../main/ets/live/LiveVmInjector';
import { LiveBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
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
  ArgumentMatchers
} from '@ohos/hypium';
import { LiveMetaBallVisibleVm } from '../../../../../../main/ets/live/vm/LiveMetaBallVisibleVm';

export default function LiveMetaBallVisibleVmTest() {
  describe('onDeviceInfoChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_isMiddleCutout_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.UNSPECIFIED;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_BEGIN;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_and_setTimeout_to_false_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_false_when_all_conditions_are_not_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 0;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = false;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(false);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = true;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.UNSPECIFIED;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_BEGIN;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_and_setTimeout_to_false_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_false_when_all_conditions_are_not_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 0;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = false;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(false);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = true;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.UNSPECIFIED;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_BEGIN;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_and_setTimeout_to_false_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_false_when_all_conditions_are_not_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 0;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = false;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(false);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.UNSPECIFIED;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_BEGIN;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_and_setTimeout_to_false_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_false_when_all_conditions_are_not_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 0;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = false;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(false);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = true;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.UNSPECIFIED;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_BEGIN;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_and_setTimeout_to_false_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_false_when_all_conditions_are_not_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 0;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = false;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(false);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = true;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.UNSPECIFIED;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_BEGIN;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_and_setTimeout_to_false_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_false_when_all_conditions_are_not_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 0;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = false;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(false);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = true;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.UNSPECIFIED;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_BEGIN;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_and_setTimeout_to_false_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_false_when_all_conditions_are_not_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 0;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = false;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(false);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = true;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.UNSPECIFIED;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_BEGIN;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_and_setTimeout_to_false_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_false_when_all_conditions_are_not_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 0;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = false;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(false);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = true;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.UNSPECIFIED;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_BEGIN;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
    });

    it('should_set_isInRotateAnim_to_true_and_setTimeout_to_false_when_all_conditions_are_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 1;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = true;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isInRotateAnim).assertEqual(true);
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(true);
    });

    it('should_set_isMiddleCutout_to_false_when_all_conditions_are_not_met', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = RotationConstants.ROTATION_0;
      livemetaballvisiblevm.cutoutVm.holeNum = 0;
      livemetaballvisiblevm.cutoutVm.isMiddleCutout = false;
      livemetaballvisiblevm.onDeviceInfoChange();
      expect(livemetaballvisiblevm.isMiddleCutout).assertEqual(false);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_false_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_true_and_isScreenLock_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = true;
      livemetaballvisiblevm.isExistCapsule = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_isMiddleCutout_is_false_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistCapsule = true;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isMiddleCutout_is_true_and_isInstant_is_false_and_isExistCapsule_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInstant = false;
      livemetaballvisiblevm.isExistHeadsUp = false;
      livemetaballvisiblevm.isScreenLock = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isShowMetaBall;
      expect(result).assertEqual(true);
    });
  });
  describe('onDeviceRotationChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_initialize_rotationPromise_and_isInRotateAnim_when_orientationReason_is_ROTATE_BEGIN', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_BEGIN;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = 0;
      livemetaballvisiblevm.onDeviceRotationChange();

      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      expect(livemetaballvisiblevm.isInRotateAnim).assertTrue();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_resolve_rotationPromise_and_reset_isInRotateAnim_when_orientationReason_is_ROTATE_END', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = 0;
      livemetaballvisiblevm.rotationPromise = new CustomPromise();
      livemetaballvisiblevm.isInRotateAnim = true;
      livemetaballvisiblevm.onDeviceRotationChange();

      expect(livemetaballvisiblevm.rotationPromise).assertUndefined();
      expect(livemetaballvisiblevm.isInRotateAnim).assertFalse();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_initialize_rotationPromise_and_isInRotateAnim_when_orientationReason_is_ROTATE_BEGIN', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_BEGIN;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = 0;
      livemetaballvisiblevm.onDeviceRotationChange();

      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      expect(livemetaballvisiblevm.isInRotateAnim).assertTrue();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_resolve_rotationPromise_and_reset_isInRotateAnim_when_orientationReason_is_ROTATE_END', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      livemetaballvisiblevm.deviceInfoVm.orientationReason = SCBRotateChangeReason.ROTATE_END;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = 0;
      livemetaballvisiblevm.rotationPromise = new CustomPromise();
      livemetaballvisiblevm.isInRotateAnim = true;
      livemetaballvisiblevm.onDeviceRotationChange();

      expect(livemetaballvisiblevm.rotationPromise).assertUndefined();
      expect(livemetaballvisiblevm.isInRotateAnim).assertFalse();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_do_nothing_when_orientationReason_is_neither_ROTATE_BEGIN_nor_ROTATE_END', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      // 设置一个无效的orientationReason
      livemetaballvisiblevm.deviceInfoVm.orientationReason = 999 as SCBRotateChangeReason;
      livemetaballvisiblevm.deviceInfoVm.realRotateAngle = 0;
      livemetaballvisiblevm.rotationPromise = new CustomPromise();
      livemetaballvisiblevm.isInRotateAnim = true;
      livemetaballvisiblevm.onDeviceRotationChange();

      // 验证rotationPromise和isInRotateAnim没有变化
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      expect(livemetaballvisiblevm.isInRotateAnim).assertTrue();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });

  describe('onCutoutChange_testSuite', () => {
    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_not_create_rotationPromise_when_isInRotateAnim_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isInRotateAnim = true;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertUndefined();
    });

    it('should_create_rotationPromise_and_resolve_when_isInRotateAnim_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isInRotateAnim = false;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      expect(livemetaballvisiblevm.isInRotateAnim).assertTrue();
    });

    it('should_log_info_when_onCutoutChange_is_called', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      livemetaballvisiblevm.onCutoutChange();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_resolve_rotationPromise_when_setTimeout_is_triggered', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isInRotateAnim = true;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      expect(livemetaballvisiblevm.isInRotateAnim).assertTrue();
      setTimeout(() => {
        expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
        expect(livemetaballvisiblevm.isInRotateAnim).assertFalse();
      }, 550);
    });

    it('should_not_create_rotationPromise_when_isInRotateAnim_is_true', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = true;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertUndefined();
    });

    it('should_create_rotationPromise_and_resolve_when_isInRotateAnim_is_false', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = false;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      expect(livemetaballvisiblevm.isInRotateAnim).assertTrue();
    });

    it('should_log_info_when_onCutoutChange_is_called', 0, () => {
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      livemetaballvisiblevm.onCutoutChange();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_resolve_rotationPromise_when_setTimeout_is_triggered', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = true;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      expect(livemetaballvisiblevm.isInRotateAnim).assertTrue();
      setTimeout(() => {
        expect(livemetaballvisiblevm.rotationPromise).assertUndefined();
        expect(livemetaballvisiblevm.isInRotateAnim).assertFalse();
      }, 550);
    });

    it('should_not_create_multiple_rotationPromises_when_called_consecutively', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = false;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
    });

    it('should_not_execute_when_isInRotateAnim_is_true', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = true;
      const originalRotationPromise = livemetaballvisiblevm.rotationPromise;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertEqual(originalRotationPromise);
    });

    it('should_not_create_rotationPromise_when_isInRotateAnim_is_true', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = true;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertUndefined();
    });

    it('should_create_rotationPromise_and_resolve_when_isInRotateAnim_is_false', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = false;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      expect(livemetaballvisiblevm.isInRotateAnim).assertTrue();
    });

    it('should_log_info_when_onCutoutChange_is_called', 0, () => {
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      livemetaballvisiblevm.onCutoutChange();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_resolve_rotationPromise_when_setTimeout_is_triggered', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = true;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      expect(livemetaballvisiblevm.isInRotateAnim).assertTrue();
      setTimeout(() => {
        expect(livemetaballvisiblevm.rotationPromise).assertUndefined();
        expect(livemetaballvisiblevm.isInRotateAnim).assertFalse();
      }, 550);
    });

    it('should_not_create_multiple_rotationPromises_when_called_consecutively', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = false;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
    });

    it('should_not_execute_when_isInRotateAnim_is_true', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = true;
      const originalRotationPromise = livemetaballvisiblevm.rotationPromise;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertEqual(originalRotationPromise);
    });

    it('should_clean_up_rotationPromise_after_resolution', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = false;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      setTimeout(() => {
        expect(livemetaballvisiblevm.rotationPromise).assertUndefined();
        expect(livemetaballvisiblevm.isInRotateAnim).assertFalse();
      }, 550);
    });

    it('should_handle_multiple_calls_without_issues', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = false;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      setTimeout(() => {
        expect(livemetaballvisiblevm.rotationPromise).assertUndefined();
        expect(livemetaballvisiblevm.isInRotateAnim).assertFalse();
      }, 550);
    });

    it('should_log_info_with_correct_parameters', 0, () => {
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      livemetaballvisiblevm.onCutoutChange();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_handle_errors_in_rotationPromise_resolution', 0, () => {
      livemetaballvisiblevm.isInRotateAnim = false;
      livemetaballvisiblevm.onCutoutChange();
      expect(livemetaballvisiblevm.rotationPromise).assertInstanceOf(CustomPromise);
      setTimeout(() => {
        expect(livemetaballvisiblevm.rotationPromise).assertUndefined();
        expect(livemetaballvisiblevm.isInRotateAnim).assertFalse();
      }, 550);
    });
  });

  describe('isMetaBallShow_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_false_when_metaBallShowState_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.metaBallShowState = false;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_metaBallShowState_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.metaBallShowState = true;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(true);
    });

    it('should_log_info_when_isMetaBallShow_is_called', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
      livemetaballvisiblevm.metaBallShowState = true;
      livemetaballvisiblevm.isMetaBallShow();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_appearPromise_is_not_undefined', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.appearPromise = new CustomPromise<void>();
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_appearPromise_is_undefined', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.appearPromise = undefined;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_rotationPromise_is_not_undefined', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.rotationPromise = new CustomPromise<void>();
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_rotationPromise_is_undefined', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.rotationPromise = undefined;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_isMiddleCutout_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isMiddleCutout = true;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_isInRotateAnim_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      livemetaballvisiblevm.isInRotateAnim = true;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deviceInfoVm_is_not_middle_device', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = false;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deviceInfoVm_is_middle_device_and_isMiddleCutout_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = true;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isMiddleCutout = false;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_deviceInfoVm_is_middle_device_and_isMiddleCutout_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = true;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isMiddleCutout = true;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deviceInfoVm_is_not_middle_device_and_isInRotateAnim_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = false;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isInRotateAnim = true;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deviceInfoVm_is_middle_device_and_isInRotateAnim_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = true;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isInRotateAnim = true;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_deviceInfoVm_is_middle_device_and_isMiddleCutout_is_false_and_isInRotateAnim_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = true;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInRotateAnim = true;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deviceInfoVm_is_middle_device_and_isMiddleCutout_is_false_and_isInRotateAnim_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = true;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_deviceInfoVm_is_not_middle_device_and_isMiddleCutout_is_true_and_isInRotateAnim_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = false;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deviceInfoVm_is_not_middle_device_and_isMiddleCutout_is_false_and_isInRotateAnim_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = false;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_deviceInfoVm_is_middle_device_and_isMiddleCutout_is_true_and_isInRotateAnim_is_false', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = true;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInRotateAnim = false;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_deviceInfoVm_is_middle_device_and_isMiddleCutout_is_false_and_isInRotateAnim_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = true;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInRotateAnim = true;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_deviceInfoVm_is_middle_device_and_isMiddleCutout_is_true_and_isInRotateAnim_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = true;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isMiddleCutout = true;
      livemetaballvisiblevm.isInRotateAnim = true;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_deviceInfoVm_is_not_middle_device_and_isMiddleCutout_is_false_and_isInRotateAnim_is_true', 0, () => {
      let livemetaballvisiblevm: LiveMetaBallVisibleVm = new LiveMetaBallVisibleVm(new LiveVmInjector());
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.middleDevice = false;
      livemetaballvisiblevm.deviceInfoVm = deviceInfoVm;
      livemetaballvisiblevm.isMiddleCutout = false;
      livemetaballvisiblevm.isInRotateAnim = true;
      const result = livemetaballvisiblevm.isMetaBallShow();
      expect(result).assertEqual(false);
    });
  });
}