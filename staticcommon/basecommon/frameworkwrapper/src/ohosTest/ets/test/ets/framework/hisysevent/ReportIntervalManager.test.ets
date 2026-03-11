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
import { DfxEvent, reportIntervalMgr } from '../../../../../../main/ets/hisysevent/ReportIntervalManager';

export function ReportIntervalManagerTest() {
  describe('ReportIntervalManagerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('ReportIntervalManagerTest_addEventCount', 0, (): void => {
      let eventFlag: string = '';
      reportIntervalMgr.addEventCount(eventFlag);
      eventFlag = 'mTest';
      reportIntervalMgr.addEventCount(eventFlag);
      expect(reportIntervalMgr.addEventCount(eventFlag) === undefined).assertTrue();
    })

    it('ReportIntervalManagerTest_createReportInterval', 0, (): void => {
      reportIntervalMgr.clearReportInterval();
      expect(reportIntervalMgr.clearReportInterval() === undefined).assertTrue();
      reportIntervalMgr['timerId'] = 3600;
      reportIntervalMgr.clearReportInterval();
      expect(true).assertTrue();
      expect(reportIntervalMgr.createReportInterval() === undefined).assertTrue();
      reportIntervalMgr.createReportInterval();
    })

    it('ReportIntervalManagerTest_reportCount', 0, (): void => {
      reportIntervalMgr.clearEventCounts()
      reportIntervalMgr['reportCount']();
      reportIntervalMgr.addEventCount('test_event_count');
      reportIntervalMgr['reportCount']();
      reportIntervalMgr.addEventCount('LOGO_L');
      reportIntervalMgr['reportCount']();
      reportIntervalMgr.addEventCount('BRIGHTNESS_UP');
      reportIntervalMgr['reportCount']();
      reportIntervalMgr.addEventCount('BRIGHTNESS_DOWN');
      reportIntervalMgr['reportCount']();
      expect(true).assertTrue();
    })

    it('ReportIntervalManagerTest_registerEvent', 0, (): void => {
      let dfxEvent: DfxEvent = {
        report: (): void => {

        }
      }
      reportIntervalMgr.registerEvent(dfxEvent);
      reportIntervalMgr.registerEvent(dfxEvent);
      expect(reportIntervalMgr['eventList'].length).assertLarger(0);

      reportIntervalMgr.unRegisterEvent(dfxEvent);
      reportIntervalMgr.unRegisterEvent(dfxEvent);
      expect(reportIntervalMgr['eventList'].indexOf(dfxEvent)).assertEqual(-1);
    })

    it('ReportIntervalManagerTest_clearEvent', 0, (): void => {
      reportIntervalMgr.clearEvent();
      expect(reportIntervalMgr['eventList'].length).assertEqual(0);
    })
  })
}
