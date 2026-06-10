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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {
  ImmersiveConstants,
  ImmersiveStatus,
  KeyguardConstants,
  CapsulePositionType
} from '../../../../../main/ets/common/ImmersiveConstants';

export function ImmersiveConstantsTest() {
  describe('ImmersiveConstantsTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('KeyguardConstants_getKgClockMinHeight', Level.LEVEL1, (): void => {
      let mock = new MockKit();

      // 场景手机+PAD
      let isPhone1 = mock.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      let isPad1 = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPhone1)().afterReturn(true);
      when(isPad1)().afterReturn(true);
      let result1 = KeyguardConstants.getKgClockMinHeight();
      expect(result1).not().assertNull();
      mock.clear(DeviceHelper);
      mock.clearAll();
    });

    it('KeyguardConstants_getKgClockMinHeight2', Level.LEVEL1, (): void => {
      let mock = new MockKit();
      let isPhone1 = mock.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      let isFold = mock.mockFunc(DeviceHelper, DeviceHelper.isFold);
      let isPad1 = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPhone1)().afterReturn(true);
      when(isFold)().afterReturn(false);
      when(isPad1)().afterReturn(true);
      let result1 = KeyguardConstants.getKgClockMinHeight();
      expect(result1).not().assertNull();
      mock.clear(DeviceHelper);
      mock.clearAll();
    });

    it('KeyguardConstants_getKgMinHeight', Level.LEVEL1, (): void => {
      let result = KeyguardConstants.getKgMinHeight();
      expect(result).not().assertNull();
    });

    it('KeyguardConstants_CONSTANTS', Level.LEVEL1, (): void => {
      expect(KeyguardConstants.NARROW_DOWN_CLOCK_VIWE_HEIGHT).not().assertNull();
      expect(KeyguardConstants.TIME_VIEW_HEIGHT_IN_LAND).not().assertNull();
      expect(KeyguardConstants.DATE_VIEW_HEIGHT_IN_LAND).not().assertNull();
      expect(KeyguardConstants.CLOCK_VIEW_MARGIN_TOP_DEFAULT).not().assertNull();
      expect(KeyguardConstants.CLOCK_VIEW_MARGIN_TOP_PAD_DEFAULT).not().assertNull();
      expect(KeyguardConstants.MESH_START).not().assertNull();
      expect(KeyguardConstants.MESH_END).not().assertNull();
      expect(KeyguardConstants.DEFAULT_CLOCK_LAYOUT_AMOUNT_Y).not().assertNull();
    });

    it('ImmersiveStatus_CONSTANTS', Level.LEVEL1, (): void => {
      expect(ImmersiveStatus.CAPSULE).not().assertNull();
      expect(ImmersiveStatus.IMMERSIVE).not().assertNull();
      expect(ImmersiveStatus.LIST).not().assertNull();
    });

    it('CapsulePositionType_CONSTANTS', Level.LEVEL1, (): void => {
      expect(CapsulePositionType.TYPE_NONE).not().assertNull();
      expect(CapsulePositionType.TYPE_CONTENT).not().assertNull();
      expect(CapsulePositionType.TYPE_SHADOW).not().assertNull();
      expect(CapsulePositionType.TYPE_REMIND).not().assertNull();
      expect(CapsulePositionType.TYPE_ANIM_CONTENT).not().assertNull();
      expect(CapsulePositionType.TYPE_ANIM_SHADOW).not().assertNull();
    });

    it('ImmersiveConstants_getNtfListPaddingTop', Level.LEVEL1, (): void => {
      expect(ImmersiveConstants.getNtfListPaddingTop()).not().assertNull();
    });

    it('ImmersiveConstants_getNtfListPaddingBottom', Level.LEVEL1, (): void => {
      expect(ImmersiveConstants.getNtfListPaddingBottom()).not().assertNull();
    });

    it('ImmersiveConstants_getImmersiveID', Level.LEVEL1, (): void => {
      expect(ImmersiveConstants.getImmersiveID('test')).not().assertNull();
    });

    it('ImmersiveConstants_CONSTANTS', Level.LEVEL1, (): void => {
      expect(ImmersiveConstants.LOG_PREFIX).not().assertNull();
      expect(ImmersiveConstants.NTF_LIST_PADDING).not().assertNull();
      expect(ImmersiveConstants.NOTIFICATION_LIST_MARGIN_TOP).not().assertNull();
      expect(ImmersiveConstants.NOTIFICATION_LIST_MARGIN_BOTTOM).not().assertNull();
      expect(ImmersiveConstants.LIST_ROOT_OFFSET).not().assertNull();
      expect(ImmersiveConstants.LIST_ROOT_RADIUS).not().assertNull();
      expect(ImmersiveConstants.CLOCK_DELAY_TIME).not().assertNull();
    });
  });
}