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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { ClockBindData }  from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockBindData';

export default function ClockBindDataTest() {

  describe('ClockBindDataTest', (): void => {
    let mClockBindData:ClockBindData = new ClockBindData();
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_updateLineSeparatorHeight_return', 0, (): void => {
      let displayScale:number = 2;
      mClockBindData.updateLineSeparatorHeight(displayScale);
      expect(mClockBindData.lineSeparatorHeight).assertEqual(96);
    })

    it('test_isDateSeparatorStyle', 0, (): void => {
      mClockBindData.isDateSeparatorStyle();
      expect(mClockBindData.dateWeekStyle).assertEqual(2);
    })

    it('test_isDateSingleLineStyle', 0, (): void => {
      mClockBindData.isDateSingleLineStyle();
      expect(mClockBindData.dateWeekStyle).assertEqual(2);
    })

  })
}