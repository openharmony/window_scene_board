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

import { systemDateTime } from '@kit.BasicServicesKit';
import { describe, expect, it } from '@ohos/hypium';
import { TimerParam } from '../../../../../main/ets/service/api/TsTimer';
import { tsTimer } from '../../../../../main/ets/service/impl/TsTimerImpl';

export default function TsTimerTest() {
  describe('startTimerTest', () => {
    it('startTimer_success', 0, async () => {
      let endTime: number = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false) + 6000;
      let param: TimerParam = {
        endTime: endTime,
        onTimer: () => {
        }
      }
      let timerId: Nullable<number> = await tsTimer.get().startTimer(param);
      expect(timerId).not().assertEqual(undefined);
    });
  });

  describe('stopTimerTest', () => {
    it('stopTimer', 0, async () => {
      let endTime: number = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false) + 6000;
      let param: TimerParam = {
        endTime: endTime,
        onTimer: () => {
        }
      }
      let timerId: Nullable<number> = await tsTimer.get().startTimer(param);
      let result: boolean = await tsTimer.get().stopTimer(timerId ?? -1);
      expect(result).assertTrue();
    });

    it('stopTimer_error', 0, async () => {
      let result: boolean = await tsTimer.get().stopTimer(-1);
      expect(result).assertFalse();
    });
  });
}