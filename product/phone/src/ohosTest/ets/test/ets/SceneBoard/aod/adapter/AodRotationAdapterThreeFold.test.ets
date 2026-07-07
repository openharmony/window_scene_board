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

import { describe,  it, expect } from '@ohos/hypium'
import { IAodDisplayInfo, ComponentRect , AodConstants, IAodClockRect} from '@ohos/aod';
import { Rotation270Strategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/Rotation270Strategy';
import {
  AodRotationAdapterThreeFold
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/AodRotationAdapterThreeFold';
import { ThreeFoldAodUtil } from '@ohos/aod/src/main/ets/utils/ThreeFoldAodUtil';
import { MockUtil } from '@ohos/aod/src/ohosTest/ets/test/MockUtil';

export function AodRotationAdapterThreeFoldTest() {
  describe('AodRotationAdapterThreeFoldTest', () => {
    let componentRect: ComponentRect = {
      left: 100,
      right: 100,
      top: 200,
      bottom: 200
    }
    let iAodClockRect: IAodClockRect = {
      clockImageRect: componentRect,
      hourHighClockNumberRect: componentRect,
      hourLowClockNumberRect: componentRect,
      minuteHighClockNumberRect: componentRect,
      minuteLowClockNumberRect: componentRect
    }
    let aodDisplayInfo : IAodDisplayInfo = {
      width: 2224,
      height: 2496,
      rotation: 0,
      orientation: 1,
      deviceInfo: {deviceType: 'phone', phoneType: 1, displayState: 1, foldState: 1},
    }

    it('test_transRectByDisplay1', 0, (): void => {
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isMStatus', (): boolean => {
        return false;
      });
      const aodRotationAdapterThreeFold = new AodRotationAdapterThreeFold(aodDisplayInfo, new Rotation270Strategy());
      let resultRect: ComponentRect = aodRotationAdapterThreeFold.transRectByDisplay(componentRect);
      expect(resultRect.top).assertEqual(componentRect.top);
      MockUtil.clearAll();
    });

    it('test_transRectByDisplay2', 0, (): void => {
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isMStatus', (): boolean => {
        return true;
      });
      const aodRotationAdapterThreeFold = new AodRotationAdapterThreeFold(aodDisplayInfo, new Rotation270Strategy());
      let resultRect: ComponentRect = aodRotationAdapterThreeFold.transRectByDisplay(componentRect);
      expect(resultRect.top).assertEqual(componentRect.top + AodConstants.B_STATE_OFFSET);
      MockUtil.clearAll();
    });

    it('test_transClockImageRect1', 0, (): void => {
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isMStatus', (): boolean => {
        return false;
      });
      const aodRotationAdapterThreeFold = new AodRotationAdapterThreeFold(aodDisplayInfo, new Rotation270Strategy());
      let resultRect: IAodClockRect = aodRotationAdapterThreeFold.transClockImageRect(iAodClockRect);
      expect(resultRect.clockImageRect.top).assertEqual(componentRect.top);
      MockUtil.clearAll();
    });

    it('test_transClockImageRect2', 0, (): void => {
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isMStatus', (): boolean => {
        return true;
      });
      const aodRotationAdapterThreeFold = new AodRotationAdapterThreeFold(aodDisplayInfo, new Rotation270Strategy());
      let resultRect: IAodClockRect = aodRotationAdapterThreeFold.transClockImageRect(iAodClockRect);
      expect(resultRect.clockImageRect.top).assertEqual(componentRect.top + AodConstants.B_STATE_OFFSET);
      MockUtil.clearAll();
    });

    it('test_transForeImgRect', 0, (): void => {
      MockUtil.mockFuncForObj(ThreeFoldAodUtil, 'isMStatus', (): boolean => {
        return false;
      });
      const aodRotationAdapterThreeFold = new AodRotationAdapterThreeFold(aodDisplayInfo, new Rotation270Strategy());
      let resultRect: ComponentRect = aodRotationAdapterThreeFold.transForeImgRect(componentRect);
      expect(resultRect.top).assertEqual(componentRect.top);
      MockUtil.clearAll();
    });
  });
}