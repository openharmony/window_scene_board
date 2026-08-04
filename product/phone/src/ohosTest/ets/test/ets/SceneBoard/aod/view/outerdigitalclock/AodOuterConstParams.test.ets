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
  AodOuterConstParams
} from '../../../../../../../../../../phonebase/src/main/ets/SceneBoard/aod/view/outerdigitalclock/AodOuterConstParams';
import { describe, expect, it } from '@ohos/hypium';
import { AodUtil, OuterAodConstants } from '@ohos/aod';

export function AodOuterConstParamsTest() {
  describe('AodOuterConstParamsTest', () => {
    it('test_setSquareOuterScreenParams', 0, async (done: Function) => {
      (AodOuterConstParams as object)['setSquareOuterScreenParams']();
      expect(AodOuterConstParams.timeTextWidth ===
        AodUtil.align4Byte(vp2px(OuterAodConstants.SQUARE_TIME_TEXT_WIDTH))).assertTrue();
      expect(AodOuterConstParams.timeTextHeightTop ===
        AodUtil.align4Byte(vp2px(OuterAodConstants.SQUARE_TIME_TEXT_HEIGHT_TOP))).assertTrue();
      expect(AodOuterConstParams.timeTextHeightBottom  ===
        AodUtil.align4Byte(vp2px(OuterAodConstants.SQUARE_TIME_TEXT_HEIGHT_BOTTOM))).assertTrue();
      done();
    });
  })
}