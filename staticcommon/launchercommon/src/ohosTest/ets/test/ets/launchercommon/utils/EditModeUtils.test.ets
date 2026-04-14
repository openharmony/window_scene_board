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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, MockKit, when } from '@ohos/hypium';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { DesktopMode, editModeManager } from '../../../../../../main/ets/TsIndex';
import { EditModeUtils } from '../../../../../../main/ets/TsIndex';

export function EditModeUtilTest() {
  describe('EditModeUtilTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('isSupportEditMode', Level.LEVEL0, (): void => {
      if (DeviceHelper.isPhone()) {
        expect(EditModeUtils.isSupportEditMode()).assertTrue();
      } else {
        expect(EditModeUtils.isSupportEditMode()).assertFalse();
      }
    })

    it('should_return_false_when_isInEditMode_given_null', Level.LEVEL0, (): void => {
      expect(EditModeUtils.isInEditMode(null)).assertFalse();
    })

    it('isInEditMode', Level.LEVEL0, (): void => {
      EditModeUtils['isPC'] = true;
      expect(EditModeUtils.isInEditMode(DesktopMode.EDIT_MODE)).assertFalse();
      EditModeUtils['isPC'] = false;
      expect(EditModeUtils.isInEditMode(DesktopMode.EDIT_MODE)).assertTrue();
      EditModeUtils['isPC'] = DeviceHelper.isPC();
    })

    it('test_getDesktopScale1', 0, () => {
      let mocker: MockKit = new MockKit();
      let isInEditMode = mocker.mockFunc(editModeManager, editModeManager.isInEditMode);
      when(isInEditMode)().afterReturn(false);
      expect(EditModeUtils.getDesktopScale()).assertEqual(1);
      when(isInEditMode)().afterReturn(true);
      expect(EditModeUtils.getDesktopScale()).assertLarger(0);
      mocker.clear(editModeManager);
      mocker.clearAll();
    })

    it('test_convertWithDesktopScale1', 0, () => {
      let mocker: MockKit = new MockKit();
      let desktopScale = mocker.mockFunc(EditModeUtils, EditModeUtils.getDesktopScale);
      when(desktopScale)().afterReturn(10);
      expect(EditModeUtils.convertWithDesktopScale(2)).assertEqual(20);
      mocker.clear(EditModeUtils);
      mocker.clearAll();
    })

    it('test_getFolderBackgroundTranslateY', 0, () => {
      let result = EditModeUtils.getFolderBackgroundTranslateY(100, 1, 10);
      expect(result).not().assertNull();
    })

    it('should_return_false_when_isInEditMode_given_normal_mode', Level.LEVEL0, (): void => {
      expect(EditModeUtils.isInEditMode(DesktopMode.NORMAL_MODE)).assertFalse();
    })

    it('test_getScaleSize', 0, () => {
      expect(EditModeUtils.getScaleSize(12, 1)).assertEqual('12vp');
      expect(EditModeUtils.getScaleSize($r('sys.float.ohos_id_text_size_body1'), 1)).assertEqual('16vp');
    })

    it('test_getAppScaleSize', 0, () => {
      expect(EditModeUtils.getAppScaleSize(12, 1)).assertContain('vp');
      expect(EditModeUtils.getAppScaleSize($r('sys.float.ohos_id_text_size_body1'), 1)).assertContain('vp');
    })

    it('test_getBackgroundHeight_01', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction1)().afterReturn(true);
      let res = EditModeUtils.getBackgroundHeight(1, 2, 3)
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker1.clearAll();
    })

    it('test_getBackgroundHeight_02', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction1)().afterReturn(false);
      let res = EditModeUtils.getBackgroundHeight(1, 2, 3)
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker1.clearAll();
    })

    it('test_getBackplaneAddHeight_01', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(true);
      let res = EditModeUtils.getBackplaneAddHeight()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.clearAll();
    })

    it('test_getBackplaneAddHeight_01', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(false);
      let res = EditModeUtils.getBackplaneAddHeight()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.clearAll();
    })

    it('test_getPrevNextMargin_01', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(true);
      let mockFunction2: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockFunction2)().afterReturn(true);
      let res = EditModeUtils.getPrevNextMargin()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      mocker1.clearAll();
    })

    it('test_getPrevNextMargin_02', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(false);
      let mockFunction2: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockFunction2)().afterReturn(true);
      let res = EditModeUtils.getPrevNextMargin()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      mocker1.clearAll();
    })

    it('test_getPrevNextMargin_03', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(true);
      let mockFunction2: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockFunction2)().afterReturn(false);
      let res = EditModeUtils.getPrevNextMargin()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      mocker1.clearAll();
    })

    it('test_getPrevNextMargin_04', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(false);
      let mockFunction2: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockFunction2)().afterReturn(false);
      let res = EditModeUtils.getPrevNextMargin()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      mocker1.clearAll();
    })

    it('test_getPrevNextMargin_05', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(false);
      let mockFunction2: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockFunction2)().afterReturn(true);
      let mockFunction3: Function = mocker1.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunction3)().afterReturn(true);
      let res = EditModeUtils.getPrevNextMargin()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      mocker1.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker1.clearAll();
    })

    it('test_getPrevNextMargin_06', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(false);
      let mockFunction2: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockFunction2)().afterReturn(true);
      let mockFunction3: Function = mocker1.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunction3)().afterReturn(false);
      let res = EditModeUtils.getPrevNextMargin()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      mocker1.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker1.clearAll();
    })

    it('test_getPrevNextMargin_07', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(true);
      let mockFunction2: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockFunction2)().afterReturn(false);
      let mockFunction3: Function = mocker1.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunction3)().afterReturn(true);
      let res = EditModeUtils.getPrevNextMargin()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      mocker1.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker1.clearAll();
    })

    it('test_getPrevNextMargin_08', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(true);
      let mockFunction2: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockFunction2)().afterReturn(false);
      let mockFunction3: Function = mocker1.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunction3)().afterReturn(false);
      let res = EditModeUtils.getPrevNextMargin()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      mocker1.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker1.clearAll();
    })

    it('test_getPrevNextMargin_09', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(false);
      let mockFunction2: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockFunction2)().afterReturn(false);
      let mockFunction3: Function = mocker1.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunction3)().afterReturn(true);
      let res = EditModeUtils.getPrevNextMargin()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      mocker1.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker1.clearAll();
    })

    it('test_getPrevNextMargin_10', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)().afterReturn(false);
      let mockFunction2: Function = mocker1.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      when(mockFunction2)().afterReturn(false);
      let mockFunction3: Function = mocker1.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(mockFunction3)().afterReturn(false);
      let res = EditModeUtils.getPrevNextMargin()
      expect(res).not().assertNull();
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker1.ignoreMock(DeviceHelper, DeviceHelper.isLandscape);
      mocker1.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker1.clearAll();
    })

    it('test_getFolderBackgroundWidth_01', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(EditModeUtils, EditModeUtils.getPrevNextMargin);
      when(mockFunction1)().afterReturn(0.01);
      let res = EditModeUtils.getFolderBackgroundWidth()
      expect(res).not().assertNull();
      mocker1.ignoreMock(EditModeUtils, EditModeUtils.getPrevNextMargin);
      mocker1.clearAll();
    })

    it('test_getFolderBackgroundWidth_02', 0, () => {
      let mocker1: MockKit = new MockKit();
      let mockFunction1: Function = mocker1.mockFunc(EditModeUtils, EditModeUtils.getPrevNextMargin);
      when(mockFunction1)().afterReturn(5);
      let res = EditModeUtils.getFolderBackgroundWidth()
      expect(res).not().assertNull();
      mocker1.ignoreMock(EditModeUtils, EditModeUtils.getPrevNextMargin);
      mocker1.clearAll();
    })
  })
}