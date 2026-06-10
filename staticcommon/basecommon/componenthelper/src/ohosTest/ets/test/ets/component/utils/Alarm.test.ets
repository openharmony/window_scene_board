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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import Alarm from '../../../../../../main/ets/utils/Alarm';
import AlarmListener from '../../../../../../main/ets/utils/AlarmListener';

/**
 * 定时器 DT测试套
 */
export function AlarmTest() {
  describe('AlarmTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('AlarmTest_create_new', Level.LEVEL0, (): void => {
      let alarm: Alarm = new Alarm();
      expect(alarm).not().assertNull();
      expect(alarm.isAlarmPending()).assertFalse();
      alarm.setAlarm(Number.MAX_VALUE);
      alarm.setAlarm(Number.MAX_VALUE);
      alarm.setAlarm(0);
      alarm.setAlarm(0);
      expect(alarm.isAlarmPending()).assertTrue();
      alarm.cancelAlarm();
      expect(alarm.isAlarmPending()).assertFalse();
    })

    it('AlarmTest_run', Level.LEVEL0, async (done: Function) => {
      let alarm: Alarm = new Alarm();
      let count: number = 0;
      /* 这里会等待定时任务执行，所以不能给长时间 */
      alarm.setAlarm(1);
      let listener: AlarmListener = {
        onAlarm: (): void => {
          count = 1;
          expect(count).assertEqual(1);
          done();
        }
      }
      alarm.setHandler(listener);
      alarm.run();
    })

    it('AlarmTest_run_when_not_pending', Level.LEVEL0, () => {
      let alarm: Alarm = new Alarm();
      expect(alarm).not().assertNull();
      expect(alarm.isAlarmPending()).assertFalse();
      alarm.run();
      expect(alarm.isAlarmPending()).assertFalse();
    })

    it('AlarmTest_run_without_handler', Level.LEVEL0, () => {
      let alarm: Alarm = new Alarm();
      expect(alarm).not().assertNull();
      alarm.setAlarm(0);
      expect(alarm.isAlarmPending()).assertTrue();
      alarm.run();
      expect(alarm.isAlarmPending()).assertFalse();
    })
  })
}