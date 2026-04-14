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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { AnyClock , AnyClockInterface } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';

export default function AnyClockTest() {

  describe('AnyClockTest', (): void => {
    let args: AnyClockInterface = {
      x: 1,
      y: 1,
      layout: 1,
      alignment: 1,
      clockStrokeColor: 'string',
      clockFontFamily: 'string',
      isClockTextShadowEnabled: true,
      isClockTextBlurEffectEnabled: true,
      isClockDateVisible: true,
      isClockLunarVisible: true,
      isClockSignatureVisible: true,
      clockSignatureText: 'string'
    }
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getGridAmountWidth_return-one', 0, (): void => {
      args.layout = 0;
      let mAnyClock: AnyClock = new AnyClock(args);
      expect(mAnyClock.getGridAmountWidth()).assertEqual(4)
    })

    it('test_getGridAmountWidth_return-ones', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 16;
      expect(mAnyClock.getGridAmountWidth()).assertEqual(4)
    })

    it('test_getGridAmountWidth_return-two', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 1;
      expect(mAnyClock.getGridAmountWidth()).assertEqual(4)
    })

    it('test_getGridAmountWidth_return-twos', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 10;
      expect(mAnyClock.getGridAmountWidth()).assertEqual(2)
    })

    it('test_getGridAmountWidth_return-tw', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 17;
      expect(mAnyClock.getGridAmountWidth()).assertEqual(2)
    })

    it('test_getGridAmountWidth_return-three', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 15;
      expect(mAnyClock.getGridAmountWidth()).assertEqual(2)
    })

    it('test_getGridAmountWidth_return-threes', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 14;
      expect(mAnyClock.getGridAmountWidth()).assertEqual(4)
    })

    it('test_getGridAmountWidth_return-four', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 2;
      expect(mAnyClock.getGridAmountWidth()).assertEqual(4)
    })

    it('test_getGridAmountWidth_return-fours', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 11;
      expect(mAnyClock.getGridAmountWidth()).assertEqual(4)
    })

    it('test_getGridAmountWidth_return-fou', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 12;
      expect(mAnyClock.getGridAmountWidth()).assertEqual(4)
    })

    it('test_getGridAmountWidth_return-for', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 13;
      expect(mAnyClock.getGridAmountWidth()).assertEqual(4)
    })

    it('test_getGridAmountWidth_return-last', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 100;
      expect(mAnyClock.getGridAmountWidth()).assertEqual(4)
    })

    it('test_getGridAmountHeight_return-one', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 0;
      expect(mAnyClock.getGridAmountHeight()).not().assertNull();
    })

    it('test_getGridAmountHeight_return-ones', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 16;
      expect(mAnyClock.getGridAmountHeight()).not().assertNull();
    })

    it('test_getGridAmountHeight_return-two', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 1;
      expect(mAnyClock.getGridAmountHeight()).not().assertNull();
    })

    it('test_getGridAmountHeight_return-twos', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 10;
      expect(mAnyClock.getGridAmountHeight()).assertEqual(4)
    })

    it('test_getGridAmountHeight_return-tw', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 17;
      expect(mAnyClock.getGridAmountHeight()).assertEqual(4)
    })

    it('test_getGridAmountHeight_return-three', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 15;
      expect(mAnyClock.getGridAmountHeight()).assertEqual(4)
    })

    it('test_getGridAmountHeight_return-threes', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 14;
      expect(mAnyClock.getGridAmountHeight()).not().assertNull();
    })

    it('test_getGridAmountHeight_return-four', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 2;
      expect(mAnyClock.getGridAmountHeight()).not().assertNull();
    })

    it('test_getGridAmountHeight_return-fours', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 11;
      expect(mAnyClock.getGridAmountHeight()).assertEqual(2)
    })

    it('test_getGridAmountHeight_return-fou', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 12;
      expect(mAnyClock.getGridAmountHeight()).assertEqual(2)
    })

    it('test_getGridAmountHeight_return-for', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 13;
      expect(mAnyClock.getGridAmountHeight()).assertEqual(2)
    })

    it('test_getGridAmountHeight_return-last', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock(args);
      args.layout = 100;
      expect(mAnyClock.getGridAmountHeight()).assertEqual(2)
    })

    it('test_getGridAmountWidth_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.getGridAmountWidth()).assertEqual(4)
    })

    it('test_getGridAmountHeight_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.getGridAmountHeight()).assertEqual(4)
    })

    it('test_argsX_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.x).assertEqual(0);
    })

    it('test_argsY_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.y).assertEqual(0);
    })

    it('test_layout_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.layout).assertEqual(0);
    })

    it('test_alignment_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.alignment).assertEqual(1);
    })

    it('test_clockStrokeColor_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.clockStrokeColor).assertEqual('#FFFFFF');
    })

    it('test_clockFontFamily_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.clockFontFamily).assertEqual('HarmonyHeiTi');
    })

    it('test_isClockTextShadowEnabled_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.isClockTextShadowEnabled).assertEqual(true);
    })

    it('test_isClockTextBlurEffectEnabled_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.isClockTextBlurEffectEnabled).assertEqual(true);
    })

    it('test_isClockDateVisible_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.isClockDateVisible).assertEqual(true);
    })

    it('test_isClockLunarVisible_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.isClockLunarVisible).assertEqual(true);
    })

    it('test_isClockSignatureVisible_return', 0, (): void => {
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.isClockSignatureVisible).assertEqual(false);
      expect(mAnyClock.clockSignatureText).assertEqual('');
    })

    it('test_argsXs_return', 0, (): void => {
      args.x = 1;
      let mAnyClock: AnyClock = new AnyClock(args);
      expect(mAnyClock.x).assertEqual(1);
    })

    it('test_argsYs_return', 0, (): void => {
      args.y = 1;
      let mAnyClock: AnyClock = new AnyClock(args);
      expect(mAnyClock.y).assertEqual(1);
    })

    it('test_layouts_return', 0, (): void => {
      args.layout = 0;
      let mAnyClock: AnyClock = new AnyClock(args);
      expect(mAnyClock.layout).assertEqual(0);
    })

    it('test_alignments_return', 0, (): void => {
      args.alignment = 2;
      let mAnyClock: AnyClock = new AnyClock();
      expect(mAnyClock.alignment).assertEqual(1);
    })

    it('test_clockStrokeColors_return', 0, (): void => {
      args.clockStrokeColor = '#AAAAAA';
      let mAnyClock: AnyClock = new AnyClock(args);
      expect(mAnyClock.clockStrokeColor).assertEqual('#AAAAAA');
    })

    it('test_clockFontFamilyEts_return', 0, (): void => {
      args.clockFontFamily = 'HarmonyBaiDi';
      let mAnyClock: AnyClock = new AnyClock(args);
      expect(mAnyClock.clockFontFamily).not().assertNull();
    })

    it('test_isClockTextShadowEEts_return', 0, (): void => {
      args.isClockTextShadowEnabled = false;
      let mAnyClock: AnyClock = new AnyClock(args);
      expect(mAnyClock.isClockTextShadowEnabled).assertEqual(false);
    })

    it('test_isClockTextBlurEffectEEts_return', 0, (): void => {
      args.isClockTextBlurEffectEnabled = false;
      let mAnyClock: AnyClock = new AnyClock(args);
      expect(mAnyClock.isClockTextBlurEffectEnabled).assertEqual(false);
    })

    it('test_isClockDateVisibleEts_return', 0, (): void => {
      args.isClockDateVisible = false;
      let mAnyClock: AnyClock = new AnyClock(args);
      expect(mAnyClock.isClockDateVisible).assertEqual(false);
    })

    it('test_isClockLunarVisibleEts_return', 0, (): void => {
      args.isClockLunarVisible = true;
      let mAnyClock: AnyClock = new AnyClock(args);
      expect(mAnyClock.isClockLunarVisible).assertEqual(true);
    })

    it('test_isClockSignatureVisibleEts_return', 0, (): void => {
      args.isClockSignatureVisible = true;
      args.clockSignatureText = 'result';
      let mAnyClock: AnyClock = new AnyClock(args);
      expect(mAnyClock.isClockSignatureVisible).assertEqual(true);
      expect(mAnyClock.clockSignatureText).assertEqual('result');
    })

  })
}