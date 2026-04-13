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

import { FormStackEventReporter } from '../../../../../main/ets/common/FormStackEventReporter';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  Level,
  TestType,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { systemDateTime } from '@kit.BasicServicesKit';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { PeriodicStatisticsEvent } from '../../../../../../../formstack/src/main/ets/common/FormStackHiSysEventUtil';

export function FormStackEventReporterTest() {
  describe('FormStackEventReporterTest', () => {
    it('startReportAlarm', TestType.FUNCTION | Level.LEVEL0, () => {
      let formStackEventReporter: FormStackEventReporter = FormStackEventReporter.getInstance();
      formStackEventReporter.startReportAlarm();
      expect((formStackEventReporter as object)['weeklyTask']).not().assertUndefined();
    });

    it('collectStatisticsData', TestType.FUNCTION | Level.LEVEL0, () => {
      let formStackEventReporter: FormStackEventReporter = FormStackEventReporter.getInstance();
      let formStackItem: GridLayoutItemInfo= new GridLayoutItemInfo();
      formStackItem.area = [2, 2];
      formStackItem.layoutInfo = [[ new GridLayoutItemInfo() ]];
      let currentTime: string = systemDateTime.getTime().toString();
      let events: PeriodicStatisticsEvent[] = [];
      (formStackEventReporter as object)['collectStatisticsData'](currentTime, 1, formStackItem, events);
      expect(events.length).assertEqual(1);
    });
  })
}

