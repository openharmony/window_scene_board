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
import {
  EventExclusiveBitMap,
  EventExclusiveConfig,
  EventType
} from '../../../../../../../../main/ets/gesturenavigation/gestureignore/configs/EventExclusiveConfig';

export default function EventExclusiveConfigTest() {
  describe('EventExclusiveConfigTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('EventExclusiveConfigTest_getEventExclusiveBitmap_001', 0, () => {
      EventExclusiveConfig['eventExclusiveInfoMap'] = new Map([
        [EventType.NO_EXCLUSIVE, ['NO_EXCLUSIVE', EventExclusiveBitMap.NO_EXCLUSIVE]],
        [EventType.DESKTOP_DRAG, ['DESKTOP_DRAG', EventExclusiveBitMap.DESKTOP_DRAG]]
      ]);
      expect(EventExclusiveConfig.getEventExclusiveBitmap(EventType.RECENT_CARD_CLICK) !== undefined).assertTrue();
    })
  })
}

