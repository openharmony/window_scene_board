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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { BatteryModel } from '../../../../../main/ets/default/batteryModel'

export function BatteryModelTest01() {
  const mBatteryModel: BatteryModel = new BatteryModel();
  describe('BatteryModelTest01', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('BatteryModel_initBatteryModelTest01', 0, () => {
      let batteryModel: BatteryModel = new BatteryModel();
      expect(batteryModel !== undefined).assertTrue();
    });

    it('BatteryModel_initBatteryModelTest02', 0, () => {
      (mBatteryModel as object)['mIsReleased'] = false;
      mBatteryModel.initBatteryModel();
      expect((mBatteryModel as object)['mIsReleased']).assertFalse();
    });

    it('BatteryModel_initBatteryModelTest03', 0, () => {
      (mBatteryModel as object)['mIsReleased'] = true;
      mBatteryModel.initBatteryModel();
      expect((mBatteryModel as object)['mPowerSaveMode'] !== undefined).assertTrue();
    });

    it('BatteryModel_unInitBatteryModelTest01', 0, () => {
      mBatteryModel.unInitBatteryModel();
      expect((mBatteryModel as object)['mIsReleased']).assertTrue();
    });

    it('BatteryModel_registerLowBatteryNtfCallBackTest01', 0, () => {
      mBatteryModel.registerLowBatteryNtfCallBack(async () => {});
      expect((mBatteryModel as object)['publishLowBatteryNtf']).assertInstanceOf('Function');
    });
  })
}

export function BatteryModelTest02() {
  const mBatteryModel: BatteryModel = new BatteryModel();
  describe('BatteryModelTest02', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('BatteryModel_unregisterLowBatteryNtfCallBackTest01', 0, () => {
      mBatteryModel.unregisterLowBatteryNtfCallBack();
      expect((mBatteryModel as object)['publishLowBatteryNtf']).assertUndefined();
    });

    it('BatteryModel_registerShutdownNtfCallBackTest01', 0, () => {
      mBatteryModel.registerShutdownNtfCallBack(() => {});
      expect((mBatteryModel as object)['publishShutdownNtf']).assertInstanceOf('Function');
    });

    it('BatteryModel_unregisterShutdownNtfCallBackTest01', 0, () => {
      mBatteryModel.unregisterShutdownNtfCallBack();
      expect((mBatteryModel as object)['publishShutdownNtf']).assertUndefined();
    });
  })
}
