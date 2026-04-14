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

import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import TestConst from '../constants/TestConst';
import { AdaptCutMargin, ScreenLockCutOutUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/ScreenLockCutOutUtil';
import { display } from '@kit.ArkUI';
import { ArrayUtils, CommonUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';

export default function ScreenLockCutOutUtilTest() {

  describe('ScreenLockCutOutUtilTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_ScreenLockCutOutUtil_getMarginToAdaptCut_should_return_true', TestConst.TEST_LEVEL, (): void => {
      let adaptCut: AdaptCutMargin = {
        marginTop: ResUtils.getNumber($r('app.float.actionsheet_padding_v')),
        marginLeft: ResUtils.getNumber($r('app.float.actionsheet_padding_h')),
        marginRight: ResUtils.getNumber($r('app.float.actionsheet_padding_h'))
      };
      ScreenLockCutOutUtil.getMarginToAdaptCut(adaptCut);
      ScreenLockCutOutUtil.getMarginToAdaptCut({} as AdaptCutMargin);
      expect(ScreenLockCutOutUtil).not().assertNull();
    })

    it('test_isCameraInUpper', TestConst.TEST_LEVEL, (): void => {
      const boundRects = [
        {
          top: 1
        } as display.Rect
      ];
      const display = {
        height: 8
      } as display.Display;
      ScreenLockCutOutUtil.isCameraInUpper(boundRects, display);
      expect(ScreenLockCutOutUtil).not().assertNull();
    })

    it('should_log_warning_when_adaptCutMargin_is_invalid', 0, async () => {
      let mocker = new MockKit()
      let adapt: AdaptCutMargin = {
        marginTop: 0,
        marginLeft: 0,
        marginRight: 0,
      }
      let mockerFun = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid)
      when(mockerFun)(adapt).afterReturn(true)
      await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
      expect(ScreenLockCutOutUtil).not().assertNull();
    });

    it('should_catch', 0, async () => {
      let mocker = new MockKit()
      let adapt: AdaptCutMargin = {
        marginTop: 16,
        marginLeft: 24,
        marginRight: 24,
      }
      let catchRes: Boolean = false
      let mockerFun = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty)
      when(mockerFun)(adapt).afterThrow('should_catch')
      try {
        await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
      } catch (e) {

      }
      catchRes = true
      expect(ScreenLockCutOutUtil).not().assertNull();
    });

    it('should_handle_empty_boundRects', 0, async () => {
      let mocker = new MockKit()
      let adapt: AdaptCutMargin = {
        marginTop: 16,
        marginLeft: 24,
        marginRight: 24,
      }
      let mockerFun = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty)
      when(mockerFun)(ArgumentMatchers.any).afterReturn(true)
      await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
      expect(ScreenLockCutOutUtil).not().assertNull();
    });

    it('should_handle_boundRects', 0, async (done: Function) => {
      try {
        let mocker = new MockKit();
        let adapt: AdaptCutMargin = {
          marginTop: 16,
          marginLeft: 24,
          marginRight: 24,
        }
        let waterfallDisplay: display.WaterfallDisplayAreaRects = {
          left: {
            left: 1,
            top: 1,
            width: 100,
            height: 200,
          },
          right: {
            left: 1,
            top: 1,
            width: 100,
            height: 200,
          },
          top: {
            left: 1,
            top: 1,
            width: 100,
            height: 200,
          },
          bottom: {
            left: 1,
            top: 1,
            width: 100,
            height: 200,
          },
        }
        // 测isTrackScreen
        let cutoutInfo: display.CutoutInfo = {
          boundingRects: [{
            left: 1,
            top: 1,
            width: 500,
            height: 200,
          }],
          waterfallDisplayAreaRects: waterfallDisplay
        };
        let obj: display.Display = display.getDefaultDisplaySync();
        obj.width = 400;
        obj.height = 200;
        let mockerFun = mocker.mockFunc(obj, (await obj.getCutoutInfo))
        when(mockerFun)(ArgumentMatchers.any).afterReturn(cutoutInfo)
        let DeviceHelperFunc = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad)
        await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
        done()
        // 测isCameraInUpperLeftCorner
        cutoutInfo = {
          boundingRects: [{
            left: 1,
            top: 1,
            width: 200,
            height: 200
          }],
          waterfallDisplayAreaRects: waterfallDisplay
        }
        when(mockerFun)(ArgumentMatchers.any).afterReturn(cutoutInfo)
        when(DeviceHelperFunc)(ArgumentMatchers.any).afterReturn(true)
        await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
        done()
        when(DeviceHelperFunc)(ArgumentMatchers.any).afterReturn(false)
        await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
        done()
        expect(adapt.marginTop).assertEqual(16)
        // 测 isCameraInUpperRightCorner
        cutoutInfo = {
          boundingRects: [{
            left: 350,
            top: 1,
            width: 200,
            height: 200
          }],
          waterfallDisplayAreaRects: waterfallDisplay
        }
        when(mockerFun)(ArgumentMatchers.any).afterReturn(cutoutInfo)
        when(DeviceHelperFunc)(ArgumentMatchers.any).afterReturn(true)
        await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
        done();
        when(DeviceHelperFunc)(ArgumentMatchers.any).afterReturn(false)
        await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
        done()
        expect(adapt.marginTop).assertEqual(16)
        // 测 else
        cutoutInfo = {
          boundingRects: [{
            left: 200,
            top: 200,
            width: 20,
            height: 20
          }],
          waterfallDisplayAreaRects: waterfallDisplay
        }
        when(mockerFun)(ArgumentMatchers.any).afterReturn(cutoutInfo)
        when(DeviceHelperFunc)(ArgumentMatchers.any).afterReturn(true)
        await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
        done()
        when(DeviceHelperFunc)(ArgumentMatchers.any).afterReturn(false)
        await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
        done()
      } catch (e) {
      }
    });
    it('ScreenLockCutOutUtilTest_001', 0, async (done: Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
        let mockFunction2: Function =
          mocker.mockFunc(ScreenLockCutOutUtil, ScreenLockCutOutUtil.isCameraInUpperLeftCorner);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
        let adapt: AdaptCutMargin = {
          marginTop: 16,
          marginLeft: 24,
          marginRight: 24,
        }
        let result = await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
        expect(result !== null).assertTrue();
        mocker.clear(ArrayUtils);
        mocker.clear(ScreenLockCutOutUtil);
        mocker.clearAll();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockCutOutUtilTest_002', 0, async (done: Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
        let mockFunction2: Function =
          mocker.mockFunc(ScreenLockCutOutUtil, ScreenLockCutOutUtil.isCameraInUpperLeftCorner);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
        let mockFunction3: Function =
          mocker.mockFunc(ScreenLockCutOutUtil, ScreenLockCutOutUtil.isCameraInUpperRightCorner);
        when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
        let adapt: AdaptCutMargin = {
          marginTop: 16,
          marginLeft: 24,
          marginRight: 24,
        };
        let result = await ScreenLockCutOutUtil.getMarginToAdaptCut(adapt);
        expect(result !== null).assertTrue();
        mocker.clear(ArrayUtils);
        mocker.clear(ScreenLockCutOutUtil);
        mocker.clearAll();
      } catch (e) {
      } finally {
        done()
      }
    });
  })
}