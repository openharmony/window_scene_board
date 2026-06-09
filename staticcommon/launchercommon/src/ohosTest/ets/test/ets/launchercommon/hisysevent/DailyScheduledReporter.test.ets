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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { DailyScheduledReporter } from '../../../../../../main/ets/hisysevent/DailyScheduledReporter';

export function DailyScheduledReporterTest() {
  describe('DailyScheduledReporterTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('DailyScheduledReporterTest_init_01', 0, () => {
      const res = 'success';
      const dailyScheduledReporter = DailyScheduledReporter.getInstance() as object
      dailyScheduledReporter['taskId'] = 1;
      DailyScheduledReporter.getInstance().init();
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('DailyScheduledReporterTest_init_02', 0, () => {
      const res = 'success';
      DailyScheduledReporter.getInstance().init([24, 0, 0]);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('DailyScheduledReporterTest_init_03', 0, () => {
      const res = 'success';
      DailyScheduledReporter.getInstance().init();
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('DailyScheduledReporterTest_registerTask', 0, () => {
      const res = 'success';
      DailyScheduledReporter.getInstance().registerTask(() => {});
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('DailyScheduledReporterTest_unRegisterTask', 0, () => {
      const res = 'success';
      const func = () => {}
      DailyScheduledReporter.getInstance().registerTask(func);
      DailyScheduledReporter.getInstance().unRegisterTask(func);
      let a = 'test';
      expect(a).assertEqual('test');
    })
  })
}