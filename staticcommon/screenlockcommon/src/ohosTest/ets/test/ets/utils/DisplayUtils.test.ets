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
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { SizeBreakPoint } from '../../../../../main/ets/constants/ScreenBreakPoint';
import { DisplayUtils } from '../../../../../main/ets/TsIndex'
import { ThreeFoldStatus } from '../../../../../main/ets/utils/DisplayUtils'

export default function DisplayUtilsTest() {
  let mocker: MockKit;
  describe('DisplayUtilsTest', () => {
    beforeAll(() => {
      mocker = new MockKit();
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
      mocker.clearAll();
    })
    it('DisplayUtilsTest_getThreeFoldStatus', 0, () => {
      const status = DisplayUtils.getThreeFoldStatus();
      expect(status === ThreeFoldStatus.F_STATUS || status === ThreeFoldStatus.M_STATUS ||
        status === ThreeFoldStatus.G_STATUS || status === undefined).assertTrue();
    })
    it('DisplayUtilsTest_isThreeFoldFMGStatus', 0, () => {
      const isFStatus = DisplayUtils.isThreeFoldFStatus();
      const isMStatus = DisplayUtils.isThreeFoldMStatus();
      const isGStatus = DisplayUtils.isThreeFoldGStatus();
      expect(isFStatus && isMStatus && isGStatus).assertFalse();
    })
    it('DisplayUtilsTest_isLargeScreen', 0, () => {
      let mockerFun1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockerFun2 = mocker.mockFunc(DisplayUtils, DisplayUtils.getThreeFoldStatus);
      when(mockerFun1)().afterReturn(false);
      when(mockerFun2)().afterReturn(ThreeFoldStatus.G_STATUS);
      expect(DisplayUtils.isLargeScreen()).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clear(DisplayUtils);
    })
  })
}