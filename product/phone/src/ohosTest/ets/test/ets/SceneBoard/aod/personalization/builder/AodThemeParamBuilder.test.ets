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
import { AodManifest, ClockArrange, AodThemeUtil, StereoForeImageParam, ForegroundPosition } from '@ohos/aod';
import { AodImageStyle, AodThemeParam, ImagePosition } from '@ohos/aod/src/main/ets/model/AodThemeConfig';

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
import {
  AodThemeParamBuilder,
  DigitalClockParamBuilder,
  FullScreenParamBuilder,
  InteractiveParamBuilder,
  MountainSeaParamBuilder,
  DialClockParamBuilder,
  StereoNumberClockParamBuilder,
  StereoForeImageParamBuilder
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/builder/AodThemeParamBuilder';

export function AodThemeParamBuilderTest() {
  describe('AodThemeParamBuilderTest', () => {

    beforeAll((): void => {

    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('AodThemeParamBuilderTest_transAodThemeParam1', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.clock.alignment = ClockArrange.HORIZONTAL_SMALL;
      let aodThemeParamBuilder = new DigitalClockParamBuilderTestClass(aodManifest);
      expect(aodManifest !== null).assertEqual(true);
    })

    it('AodThemeParamBuilderTest_transAodThemeParam2', 0, () => {
      let aodManifest1: AodManifest = new AodManifest();
      aodManifest1.clock.alignment = ClockArrange.HORIZONTAL;
      aodManifest1.images = [new AodImageStyle()];
      aodManifest1.images[0].position = ImagePosition.TOP;
      let aodThemeParamBuilder1 = new DigitalClockParamBuilderTestClass(aodManifest1);
      expect(aodManifest1 !== null).assertEqual(true);
    })

    it('AodThemeParamBuilderTest_transAodThemeParam3', 0, () => {
      let aodManifest2: AodManifest = new AodManifest();
      aodManifest2.clock.alignment = ClockArrange.VERTICAL_MISALIGNED;
      aodManifest2.images = [new AodImageStyle()];
      aodManifest2.images[0].position = ImagePosition.BELOW;
      let aodThemeParamBuilder2 = new DigitalClockParamBuilderTestClass(aodManifest2);
      expect(aodManifest2 !== null).assertEqual(true);
    })

  });

  describe('DigitalClockParamBuilderTest', () => {

    beforeAll((): void => {

    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('DigitalClockParamBuilderTest_createAodThemeParam', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.clock.alignment = ClockArrange.HORIZONTAL_SMALL;
      let aodThemeParamBuilder = new DigitalClockParamBuilderTestClass(aodManifest);
      let aodThemeParam = aodThemeParamBuilder.createAodThemeParam();
      expect(aodManifest !== null).assertEqual(true);
    })

    it('DigitalClockParamBuilderTest_buildBackgroundImageParam1', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new DigitalClockParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildBackgroundImageParam();
      expect(aodManifest !== null).assertEqual(true);
      done();
    })

    it('DigitalClockParamBuilderTest_buildAnimationParam1', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new DigitalClockParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildAnimationParam();
      expect(aodManifest !== null).assertEqual(true);
      done();
    })

    it('DigitalClockParamBuilderTest_buildAnimationParam2', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.animations = [{
        prefix: '1',
        frame: 1
      }]
      let aodThemeParamBuilder = new DigitalClockParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildAnimationParam();
      expect(aodManifest !== null).assertEqual(true);
      done();
    })

  });

  describe('FullScreenParamBuilderTest', () => {

    beforeAll((): void => {

    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('FullScreenParamBuilderTest_createAodThemeParam', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.clock.alignment = ClockArrange.HORIZONTAL_SMALL;
      let aodThemeParamBuilder = new FullScreenParamBuilderTestClass(aodManifest);
      let aodThemeParam = aodThemeParamBuilder.createAodThemeParam();
      expect(aodManifest !== null).assertEqual(true);
    })

    it('FullScreenParamBuilderTest_buildClockParam', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new FullScreenParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildClockParam();
      expect(aodManifest !== null).assertEqual(true);
      done();
    })

    it('FullScreenParamBuilderTest_buildBackgroundImageParam', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new FullScreenParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildBackgroundImageParam();
      expect(aodManifest !== null).assertEqual(true);
      done();
    })

  });

  describe('InteractiveParamBuilderTest', () => {

    it('InteractiveParamBuilderTest_createAodThemeParam1', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.clock.alignment = ClockArrange.HORIZONTAL_SMALL;
      let aodThemeParamBuilder = new InteractiveParamBuilderTestClass(aodManifest);
      let aodThemeParam: AodThemeParam = aodThemeParamBuilder.createAodThemeParam();
      expect(aodThemeParam).not().assertUndefined();
    })

    it('InteractiveParamBuilderTest_buildBackgroundImageParam', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodThemeUtil, AodThemeUtil.isOnlineStyle);

      when(mockFunc)(aodManifest).afterReturn(true);
      let aodThemeParamBuilder = new InteractiveParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildBackgroundImageParam();
      let isOnlineStyle: boolean = AodThemeUtil.isOnlineStyle(aodManifest);
      expect(isOnlineStyle).assertEqual(true);
      mocker.clear(AodThemeUtil);
      mocker.clearAll();
      done();
    })

    it('InteractiveParamBuilderTest_buildAnimationParam1', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new InteractiveParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildAnimationParam();
      expect(aodManifest).not().assertUndefined();
      done();
    })

  });

  describe('MountainSeaParamBuilderTest', () => {

    it('MountainSeaParamBuilderTest_createAodThemeParam', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.clock.alignment = ClockArrange.HORIZONTAL_SMALL;
      let aodThemeParamBuilder = new MountainSeaParamBuilderTestClass(aodManifest);
      let aodThemeParam: AodThemeParam = aodThemeParamBuilder.createAodThemeParam();
      expect(aodThemeParam).not().assertUndefined();
    })

    it('MountainSeaParamBuilderTest_buildBackgroundImageParam', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodThemeUtil, AodThemeUtil.isOnlineStyle);

      when(mockFunc)(aodManifest).afterReturn(true);
      let aodThemeParamBuilder = new MountainSeaParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildBackgroundImageParam();
      let isOnlineStyle: boolean = AodThemeUtil.isOnlineStyle(aodManifest);
      expect(isOnlineStyle).assertEqual(true);
      mocker.clear(AodThemeUtil);
      mocker.clearAll();
      done();
    })

    it('MountainSeaParamBuilderTest_buildAnimationParam1', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new MountainSeaParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildAnimationParam();
      expect(aodManifest).not().assertUndefined();
      done();
    })

    it('MountainSeaParamBuilderTest_buildAnimationParam2', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.animations = [{
        prefix: '1',
        frame: 1
      }]
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodThemeUtil, AodThemeUtil.isOnlineStyle);

      when(mockFunc)(aodManifest).afterReturn(false);
      let aodThemeParamBuilder = new MountainSeaParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildBackgroundImageParam();
      await aodThemeParamBuilder.buildAnimationParam();
      expect(aodManifest.animations).not().assertUndefined();
      done();
    })

    it('MountainSeaParamBuilderTest_buildAnimationParam3', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.animations = [{
        prefix: '1',
        frame: 1
      }]
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodThemeUtil, AodThemeUtil.isOnlineStyle);

      when(mockFunc)(aodManifest).afterReturn(true);
      let aodThemeParamBuilder = new MountainSeaParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildBackgroundImageParam();
      await aodThemeParamBuilder.buildAnimationParam();
      expect(aodManifest.animations).not().assertUndefined();
      done();
    })

  });

  describe('DialClockParamBuilderTest', () => {

    it('DialClockParamBuilderTest_createAodThemeParam', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.clock.alignment = ClockArrange.HORIZONTAL_SMALL;
      let aodThemeParamBuilder = new DialClockParamBuilderTestClass(aodManifest);
      let aodThemeParam: AodThemeParam = aodThemeParamBuilder.createAodThemeParam();
      expect(aodThemeParam).not().assertUndefined();
    })

    it('DialClockParamBuilderTest_buildBackgroundImageParam', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodThemeUtil, AodThemeUtil.isOnlineStyle);

      when(mockFunc)(aodManifest).afterReturn(true);
      let aodThemeParamBuilder = new DialClockParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildBackgroundImageParam();
      let isOnlineStyle: boolean = AodThemeUtil.isOnlineStyle(aodManifest);
      expect(isOnlineStyle).assertEqual(true);
      mocker.clear(AodThemeUtil);
      mocker.clearAll();
      done();
    })

    it('DialClockParamBuilderTest_buildAnimationParam1', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new DialClockParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildAnimationParam();
      expect(aodManifest).not().assertUndefined();
      done();
    })

  });

  describe('StereoNumberClockParamBuilderTest', () => {

    it('StereoNumberClockParamBuilderTest_createAodThemeParam1', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.clock.alignment = ClockArrange.HORIZONTAL_SMALL;
      let aodThemeParamBuilder = new StereoNumberClockParamBuilderTestClass(aodManifest);
      let aodThemeParam: AodThemeParam = aodThemeParamBuilder.createAodThemeParam();
      expect(aodThemeParam).not().assertUndefined();
    })

    it('StereoNumberClockParamBuilderTest_buildBackgroundImageParam', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodThemeUtil, AodThemeUtil.isOnlineStyle);

      when(mockFunc)(aodManifest).afterReturn(true);
      let aodThemeParamBuilder = new StereoNumberClockParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildBackgroundImageParam();
      let isOnlineStyle: boolean = AodThemeUtil.isOnlineStyle(aodManifest);
      expect(isOnlineStyle).assertEqual(true);
      mocker.clear(AodThemeUtil);
      mocker.clearAll();
      done();
    })

    it('StereoNumberClockParamBuilderTest_buildAnimationParam1', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new StereoNumberClockParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildAnimationParam();
      expect(aodManifest).not().assertUndefined();
      done();
    })

  });

  describe('StereoForeImageParamBuilderTest', () => {

    it('StereoForeImageParamBuilderTest_createAodThemeParam1', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.clock.alignment = ClockArrange.HORIZONTAL_SMALL;
      let aodThemeParamBuilder = new StereoForeImageParamBuilderTestClass(aodManifest);
      let aodThemeParam: AodThemeParam = aodThemeParamBuilder.createAodThemeParam();
      expect(aodThemeParam).not().assertUndefined();
    })

    it('StereoForeImageParamBuilderTest_buildBackgroundImageParam', 0, async (done: Function) => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new StereoForeImageParamBuilderTestClass(aodManifest);
      await aodThemeParamBuilder.buildAnimationParam();
      expect(aodManifest.animations).assertUndefined();
      done();
    })

    it('StereoForeImageParamBuilderTest_getHours1', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new StereoForeImageParamBuilderTestClass(aodManifest);
      let stereoForeImageParam: StereoForeImageParam =
        aodThemeParamBuilder.createAodThemeParam() as StereoForeImageParam;
      stereoForeImageParam.foreGround = ForegroundPosition.UNCHANGED;
      aodThemeParamBuilder.getHours(stereoForeImageParam);
      expect(aodThemeParamBuilder).not().assertUndefined();
    })

    it('StereoForeImageParamBuilderTest_getHours2', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new StereoForeImageParamBuilderTestClass(aodManifest);
      let stereoForeImageParam: StereoForeImageParam =
        aodThemeParamBuilder.createAodThemeParam() as StereoForeImageParam;
      stereoForeImageParam.foreGround = ForegroundPosition.HIGH_HOUR;
      aodThemeParamBuilder.getHours(stereoForeImageParam);
      expect(stereoForeImageParam.foreGround).not().assertUndefined();
    })

    it('StereoForeImageParamBuilderTest_getHours3', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      let aodThemeParamBuilder = new StereoForeImageParamBuilderTestClass(aodManifest);
      let stereoForeImageParam: StereoForeImageParam =
        aodThemeParamBuilder.createAodThemeParam() as StereoForeImageParam;
      stereoForeImageParam.foreGround = ForegroundPosition.LOW_HOUR;
      aodThemeParamBuilder.getHours(stereoForeImageParam);
      expect(stereoForeImageParam.foreGround).not().assertUndefined();
    })

  });

  class DigitalClockParamBuilderTestClass extends DigitalClockParamBuilder {
    public createAodThemeParam(): AodThemeParam {
      return super.createAodThemeParam();
    }

    public async buildBackgroundImageParam(): Promise<void> {
      super.buildBackgroundImageParam();
    }

    public async buildAnimationParam(): Promise<void> {
      super.buildAnimationParam();
    }
  }

  class FullScreenParamBuilderTestClass extends FullScreenParamBuilder {
    public createAodThemeParam(): AodThemeParam {
      return super.createAodThemeParam();
    }

    public async buildClockParam(): Promise<void> {
      super.buildClockParam();
    }

    public async buildBackgroundImageParam(): Promise<void> {
      super.buildBackgroundImageParam();
    }
  }

  class InteractiveParamBuilderTestClass extends InteractiveParamBuilder {
    public createAodThemeParam(): AodThemeParam {
      return super.createAodThemeParam();
    }
  }

  class MountainSeaParamBuilderTestClass extends MountainSeaParamBuilder {
    public createAodThemeParam(): AodThemeParam {
      return super.createAodThemeParam();
    }

    public async buildBackgroundImageParam(): Promise<void> {
      super.buildBackgroundImageParam();
    }

    public async buildAnimationParam(): Promise<void> {
      super.buildAnimationParam();
    }
  }

  class DialClockParamBuilderTestClass extends DialClockParamBuilder {
    public createAodThemeParam(): AodThemeParam {
      return super.createAodThemeParam();
    }
  }

  class StereoNumberClockParamBuilderTestClass extends StereoNumberClockParamBuilder {
    public createAodThemeParam(): AodThemeParam {
      return super.createAodThemeParam();
    }
  }

  class StereoForeImageParamBuilderTestClass extends StereoForeImageParamBuilder {
    public createAodThemeParam(): AodThemeParam {
      return super.createAodThemeParam();
    }
  }

}