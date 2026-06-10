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
import { describe, beforeEach, afterEach, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { PCUtils } from '@ohos/pcbase/src/main/ets/common/utils/PCUtils';
import { UIContext } from '@ohos.arkui.UIContext';

export default function PCUtilsTest() {
  describe('PCUtilsTest', () => {

    let mocker: MockKit;
    beforeEach(() => {
      mocker = new MockKit();
    });

    afterEach(() => {
    });

    it('should_return_true_is2D_one', 0, async (done: Function) => {
      try {
        let mockIsPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        let mockIsEmulator = mocker.mockFunc(DeviceHelper, DeviceHelper.isEmulator);
        when(mockIsPC)().afterReturn(true);
        when(mockIsEmulator)().afterReturn(true);
        const result = PCUtils.is2D();
        expect(result).assertTrue();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        mocker.clear(DeviceHelper);
        done();
      }
    });

    it('should_return_true_is2D_two', 0, async (done: Function) => {
      try {
        let mockIsPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        let mockIsEmulator = mocker.mockFunc(DeviceHelper, DeviceHelper.isEmulator);
        let mockIsEnableDesktopFeatureAnimation = mocker.mockFunc(PCUtils, PCUtils.isEnableDesktopFeatureAnimation);
        when(mockIsPC)().afterReturn(false);
        when(mockIsEmulator)().afterReturn(false);
        when(mockIsEnableDesktopFeatureAnimation)().afterReturn(false);
        const result = PCUtils.is2D();
        expect(result).assertTrue();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        mocker.clear(DeviceHelper);
        done();
      }
    });

    it('should_return_false_is2D_three', 0, async (done: Function) => {
      try {
        let mockIsPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        let mockIsEnableDesktopFeatureAnimation = mocker.mockFunc(PCUtils, PCUtils.isEnableDesktopFeatureAnimation);
        when(mockIsPC)().afterReturn(false);
        when(mockIsEnableDesktopFeatureAnimation)().afterReturn(true);
        const result = PCUtils.is2D();
        expect(result).assertFalse();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        mocker.clear(DeviceHelper);
        done();
      }
    });

    it('test_isEnableDesktopFeatureAnimation', 0, async (done: Function) => {
      try {
        const result = PCUtils.isEnableDesktopFeatureAnimation();
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    });

    it('test_getIsEnterSpaceEnabled', 0, async (done: Function) => {
      try {
        const result = PCUtils.getIsEnterSpaceEnabled();
        expect(result).not().assertNull();
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    });

    it('test_vp2px_uiContext_is_not_null', 0, async (done: Function) => {
      let uiContextMock: UIContext = new UIContext();
      let vp2pxMock: Function = mocker.mockFunc(uiContextMock, uiContextMock.vp2px);
      try {
        when(vp2pxMock)(ArgumentMatchers.any).afterReturn(100);
        const result = PCUtils.vp2px(uiContextMock, 50);
        expect(result).assertEqual(100);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        mocker.clear(uiContextMock);
        done();
      }
    });

    it('test_vp2px_uiContext_is_null', 0, async (done: Function) => {
      try {
        const result = PCUtils.vp2px(null, 50);
        expect(result).assertLarger(50); // Assuming global vp2px just returns the input value
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    });

    it('test_vp2px_uiContext_normal', 0, async (done: Function) => {
      try {
        const result = PCUtils.vp2px(new UIContext(), 50);
        expect(result).assertLargerOrEqual(50);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    });

    it('test_px2vp_uiContext_is_not_null', 0, async (done: Function) => {
      let uiContextMock: UIContext = new UIContext();
      let px2vpMock: Function = mocker.mockFunc(uiContextMock, uiContextMock.px2vp);
      try {
        when(px2vpMock)(ArgumentMatchers.any).afterReturn(50);
        const result = PCUtils.px2vp(uiContextMock, 100);
        expect(result).assertEqual(50);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        mocker.clear(uiContextMock);
        done();
      }
    });

    it('test_px2vp_uiContext_is_null', 0, async (done: Function) => {
      try {
        const result = PCUtils.px2vp(null, 50);
        expect(result).assertLessOrEqual(50);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    });

    it('test_px2vp_uiContext_normal', 0, async (done: Function) => {
      try {
        const result = PCUtils.px2vp(new UIContext(), 50);
        expect(result).assertLessOrEqual(50);
      } catch (e) {
        expect(e).assertEqual('error: ' + JSON.stringify(e.message));
      } finally {
        done();
      }
    });

  });
}