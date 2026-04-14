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
import {
  LiveViewSysEventUtil
} from '../../../../../../main/ets/liveview/common/LiveViewSysEventUtil';
import {
  LiveOtherExtendData
} from '../../../../../../main/ets/liveview/data/extend/LiveOtherExtendData';
import { LiveViewData } from '../../../../../../main/ets/liveview/data/LiveViewData';

const DEFAULT = 0;

export function LiveViewSysEventUtilTest() {
  describe('LiveViewSysEventUtilTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('reportCapsuleNumChangeEvent', DEFAULT, (): void => {
      let liveViewData: Array<LiveViewData> = new Array<LiveViewData>();
      let reportCapsuleNumChangeEvent = (): void => {
        LiveViewSysEventUtil.reportCapsuleNumChangeEvent(liveViewData);
      };
      expect(reportCapsuleNumChangeEvent).not().assertFail();
    })

    it('reportClickExtendEvent', DEFAULT, (): void => {
      let extendData: LiveOtherExtendData;
      const NOTIFICATION_TYPE = 2;
      let reportLiveViewEventClickExtend = (): void => {
        LiveViewSysEventUtil.reportClickExtendEvent(extendData,NOTIFICATION_TYPE);
      };
      expect(reportLiveViewEventClickExtend).not().assertFail();
    })
  })
}

