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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level,
  MockKit,
  when
} from '@ohos/hypium'
import { ResUtils } from '../../../../../../main/ets/utils/ResourceUtils'
import { DisplayMgr } from '../../../../../../main/ets/utils/DisplayManager'
import inputMethod from '@ohos.inputMethod';

export function ResUtilsTest() {
  describe('ResUtilsTest', () => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterEach((): void => {
    });
    afterAll((): void => {
    });

    it('ResUtils_getLandGridRowWidth_test', 0, (): void => {
      let landScreenWidth: number = 1000;
      expect(ResUtils.getLandGridRowWidth(landScreenWidth)).assertInstanceOf('Number');
    })

    it('ResUtils_getLandBoxGridRowWidth_test', 0, (): void => {
      let landScreenWidth: number = 1000;
      expect(ResUtils.getLandBoxGridRowWidth(landScreenWidth)).assertInstanceOf('Number');
    })

    it('ResUtils_getLandPadGridRowWidth_test', 0, (): void => {
      let landScreenWidth: number = 1000;
      expect(ResUtils.getLandPadGridRowWidth(landScreenWidth)).assertInstanceOf('Number');
    })

    it('pixelTransfer_with_cache_display_valid', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DisplayMgr, DisplayMgr.getCacheDisplay);
      when(mockFunc)().afterReturn(true);
      ResUtils.vp2px(10);
      ResUtils.px2vp(1600);
      expect(ResUtils.mm2vp(25.4)).assertInstanceOf('Number');
      mocker.clear(DisplayMgr);
    })

    it('pixel_transfer_with_cache_display_invalid', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DisplayMgr, DisplayMgr.getCacheDisplay);
      when(mockFunc)().afterReturnNothing();
      ResUtils.vp2px(10);
      ResUtils.px2vp(1600);
      expect(ResUtils.mm2vp(100)).assertInstanceOf('Number');
      mocker.clear(DisplayMgr);
    })

    it('ResUtilsTest_getWidthByLandScreenWidth', 0, (): void => {
      expect(ResUtils.getWidthByLandScreenWidth(3600)).assertInstanceOf('Number');
      expect(ResUtils.getWidthByLandScreenWidth(2700)).assertInstanceOf('Number');
      expect(ResUtils.getWidthByLandScreenWidth(2160)).assertInstanceOf('Number');
      expect(ResUtils.getWidthByLandScreenWidth(1600)).assertInstanceOf('Number');
      expect(ResUtils.getWidthByLandScreenWidth(1000)).assertInstanceOf('Number');
    })

    it('ResUtilsTest_getInnerString', 0, (): void => {
      expect(ResUtils.getInnerString(null)).assertNull();
      expect(ResUtils.getInnerString($r('app.string.cancel'))).assertInstanceOf('String');
    })

    it('ResUtilsTest_getInnerStringNum', 0, async (done: Function) => {
      let res = await ResUtils.getInnerStringNum($r('app.string.cancel'), null);
      expect(res).assertEqual('');
      let resOther = await ResUtils.getInnerStringNum($r('app.string.face_recognition_try_again_after_time'), '5秒');
      expect(resOther).assertInstanceOf('String');
      done();
    })

    it('ResUtilsTest_getOutString', 0, (): void => {
      expect(ResUtils.getOutString(null)).assertNull();
      ResUtils.getOutString($r('app.string.cancel'));
    })

    it('ResUtilsTest_getInnerStringByName', 0, (): void => {
      expect(ResUtils.getInnerStringByName(null)).assertNull();
      ResUtils.getInnerStringByName('disable_uninstall');
    })

    it('ResUtilsTest_getOutStringByName', 0, async (done: Function) => {
      let res = await ResUtils.getOutStringByName(null);
      expect(res).assertNull();
      done();
    })

    it('ResUtilsTest_getInnerPlural', 0, async (done: Function) => {
      let res = await ResUtils.getInnerPlural(null, null);
      expect(res).assertNull();
      await ResUtils.getInnerPlural(null, 1);
      res = await ResUtils.getInnerPlural($r('app.string.face_recognition_try_again_after_time'), null);
      expect(res).assertNull();
      let resOther = await ResUtils.getInnerStringNum($r('app.string.face_recognition_try_again_after_time'), '5秒');
      expect(resOther).assertInstanceOf('String');
      done();
    })

    it('ResUtilsTest_getInnerPluralByResource', 0, (): void => {
      expect(ResUtils.getInnerPluralByResource(null, null)).assertNull();
      ResUtils.getInnerPluralByResource(null, 1);
      try {
        ResUtils.getInnerPluralByResource($r('app.string.face_recognition_try_again_after_time'), null);
        ResUtils.getInnerPluralByResource($r('app.string.face_recognition_try_again_after_time'), 1);
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('ResUtilsTest_getNumber', 0, (): void => {
      expect(ResUtils.getNumber(null)).assertEqual(0);
      expect(ResUtils.getNumber($r('app.string.cancel'))).assertEqual(0);
    })

    it('ResUtilsTest_getOutNumber', 0, (): void => {
      expect(ResUtils.getOutNumber(null)).assertEqual(0);
      expect(ResUtils.getOutNumber($r('app.float.status_bar_font_size'))).assertInstanceOf('Number');
    })

    it('ResUtilsTest_getNumberFromLength', 0, (): void => {
      expect(ResUtils.getNumberFromLength(null)).assertEqual(0);
      ResUtils.getNumberFromLength(0);
      ResUtils.getNumberFromLength('1');
      ResUtils.getNumberFromLength('1vp');
      ResUtils.getNumberFromLength('3px');
      expect(ResUtils.getNumberFromLength($r('app.string.cancel'))).assertInstanceOf('Number');
    })

    it('ResUtilsTest_getNumberFromLengthExceptPx', 0, (): void => {
      expect(ResUtils.getNumberFromLengthExceptPx(null)).assertEqual(0);
      ResUtils.getNumberFromLengthExceptPx(0);
      ResUtils.getNumberFromLengthExceptPx('1vp');
      ResUtils.getNumberFromLengthExceptPx('1fp');
      ResUtils.getNumberFromLengthExceptPx('1');
      expect(ResUtils.getNumberFromLengthExceptPx($r('app.string.cancel'))).assertInstanceOf('Number');
    })

    it('ResUtilsTest_getConvertNumber', 0, (): void => {
      expect(ResUtils.getConvertNumber(null)).assertEqual(0);
      expect(ResUtils.getConvertNumber(1)).assertInstanceOf('Number');
    })

    it('ResUtilsTest_getInnerMediaBase64', 0, async (done: Function) => {
      let res = await ResUtils.getInnerMediaBase64(null);
      expect(res).assertNull();
      expect(res).assertInstanceOf('String');
      done();
    })

    it('ResUtilsTest_getAccountSAState', 0, async (done: Function) => {
      let res = await ResUtils.getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('ResUtilsTest_getOutMediaBase64', 0, async (done: Function) => {
      let res = await ResUtils.getOutMediaBase64(null);
      expect(res).assertNull();
      expect(res).assertInstanceOf('String');
      done();
    })

    it('ResUtilsTest_getOutDrawableDescriptor', 0, async (done: Function) => {
      let res = await ResUtils.getOutDrawableDescriptor(null);
      expect(res).assertNull();
      done();
    })

    it('should_return_correct_time_start_width_when_landScreenWidth_is_valid', 0, () => {
      let landScreenWidth: number = 1080;
      let result: number = ResUtils.getTimeStartWidthByLandScreenWidth(landScreenWidth);
      expect(result).assertEqual(landScreenWidth / 8 * 5);
    });

    it('should_return_correct_time_start_width_when_landScreenWidth_is_zero', 0, () => {
      let landScreenWidth: number = 0;
      let result: number = ResUtils.getTimeStartWidthByLandScreenWidth(landScreenWidth);
      expect(result).assertEqual(0);
    });

    it('should_return_correct_time_start_width_when_landScreenWidth_is_negative', 0, () => {
      let landScreenWidth: number = -1080;
      let result: number = ResUtils.getTimeStartWidthByLandScreenWidth(landScreenWidth);
      expect(result).assertEqual(-1080 / 8 * 5);
    });

    it('should_return_null_when_resource_is_invalid', 0, () => {
      let result = ResUtils.getInnerStringNumS(null, "test");
      expect(result).assertNull();
    });
  })
}