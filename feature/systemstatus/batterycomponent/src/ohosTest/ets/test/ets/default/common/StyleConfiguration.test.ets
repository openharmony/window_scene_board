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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, DEFAULT} from '@ohos/hypium';
import StyleConfiguration from '../../../../../../main/ets/default/common/StyleConfiguration';
import { BatteryComponentStyle, BatteryPicStyle } from '../../../../../../main/ets/default/common/StyleConfiguration';

export function BatteryStyleTest() {
  describe('BatteryStyleTest', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('BatteryStyle_getBatteryComponentStyleTest01', DEFAULT, (): void => {
      const style: BatteryComponentStyle = StyleConfiguration.getBatteryComponentStyle();
      expect(style instanceof BatteryComponentStyle).assertTrue();
    })

    it('BatteryStyle_getBatteryPicStyleTest01', DEFAULT, (): void => {
      const style: BatteryPicStyle = StyleConfiguration.getBatteryPicStyle();
      expect(style instanceof BatteryPicStyle).assertTrue();
    })

    it('BatteryStyle_getBatteryPicStyleForScreenLockTest01', DEFAULT, (): void => {
      const style: BatteryPicStyle = StyleConfiguration.getBatteryPicStyleForScreenLock();
      expect(style instanceof BatteryPicStyle).assertTrue();
    })
  })
}
