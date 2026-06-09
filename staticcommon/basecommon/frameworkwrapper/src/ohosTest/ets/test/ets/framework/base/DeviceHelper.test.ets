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
  TestType,
  Size,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import { DeviceHelper } from '../../../../../../main/ets/base/DeviceHelper'

export function DeviceHelperTest() {
  describe('DeviceHelperTest', () => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterEach((): void => {
    });
    afterAll((): void => {
    });

    it('isPhone', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(DeviceHelper.isPhone()).assertInstanceOf('Boolean');
    })

    it('isPC', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(DeviceHelper.isPC()).assertInstanceOf('Boolean');
    })

    it('isCAR', TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void => {
      expect(DeviceHelper.isCAR()).assertInstanceOf('Boolean');
    })

    it('isHYM', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(DeviceHelper.isHYM()).assertInstanceOf('Boolean');
    })

    it('isPhoneOrPad', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(DeviceHelper.isPhoneOrPad()).not().assertFail();
      expect(DeviceHelper.isPhoneOrPad()).assertInstanceOf('Boolean');
    })

    it('isMatchDevice', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(DeviceHelper.isMatchDevice(null)).assertFalse();
      expect(DeviceHelper.isMatchDevice('tablet')).not().assertFail();
      expect(DeviceHelper.isMatchDevice('')).assertFalse();
      expect(DeviceHelper.isMatchDevice('')).assertInstanceOf('Boolean');
      expect(DeviceHelper.isMatchDevice('phone')).assertInstanceOf('Boolean');
      expect(DeviceHelper.isMatchDevice('default')).assertInstanceOf('Boolean');
      expect(DeviceHelper.isMatchDevice('2in1')).assertInstanceOf('Boolean');
      expect(DeviceHelper.isMatchDevice('car')).assertInstanceOf('Boolean');
      expect(DeviceHelper.isMatchDevice('wearable')).assertInstanceOf('Boolean');
    })

    it('getDeviceType', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(DeviceHelper.getDeviceType()).assertEqual(DeviceHelper.DEVICE_TYPE);
      expect(DeviceHelper.getDeviceType()).assertInstanceOf('String');
    })

    it('isLargeInFoldProduct', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(DeviceHelper.isLargeInFoldProduct()).assertInstanceOf('Boolean');
    })

    it('DeviceHelperTest_isWatch', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(DeviceHelper.isWatch()).assertInstanceOf('Boolean');
    })

    it('DeviceHelperTest_isEmulator', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(DeviceHelper.isEmulator()).assertInstanceOf('Boolean');
    })

    it('DeviceHelperTest_getFoldDisplayMode', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(DeviceHelper.getFoldDisplayMode()).assertInstanceOf('Number');
    })

    it('isFoldExpandedButNotSmallFoldProduct', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(DeviceHelper.isFoldExpandedButNotSmallFoldProduct()).assertInstanceOf('Boolean');
    })

    it('DeviceHelperTest_isHAD', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockerFun = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockerFun)().afterReturn(true);
      expect(DeviceHelper.isHAD()).assertInstanceOf('Boolean');
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('DeviceHelperTest_isPhoneOrPad', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockerFun = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockerFun)().afterReturn(false);
      DeviceHelper.isPhoneOrPad();
      expect(DeviceHelper.isMatchDevice('tablet')).assertEqual(DeviceHelper.isPad());
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('DeviceHelperTest_isSubDisplayMode', 0, (): void => {
      expect(DeviceHelper.isSubDisplayMode()).assertInstanceOf('Boolean');
    })

    it('DeviceHelperTest_isLandscape', 0, (): void => {
      expect(DeviceHelper.isLandscape()).assertInstanceOf('Boolean');
    })

    it('DeviceHelperTest_isLandscape', 0, (): void => {
      expect(DeviceHelper['stringToArray'](undefined)).not().assertNull();
      expect(DeviceHelper['stringToArray']('11,22')).not().assertNull();
      expect(DeviceHelper['stringToArray']('38')).not().assertNull();
    })

    it('DeviceHelperTest_isLargeScreen', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockerFun1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockerFun2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isUltraScreenProduct);
      let mockerFun3 = mocker.mockFunc(DeviceHelper, DeviceHelper.isGState);
      when(mockerFun1)().afterReturn(true);
      expect(DeviceHelper.isLargeScreen()).assertTrue();
      when(mockerFun1)().afterReturn(false);
      when(mockerFun2)().afterReturn(true);
      when(mockerFun3)().afterReturn(true);
      expect(DeviceHelper.isLargeScreen()).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
  })
}