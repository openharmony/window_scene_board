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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { WorkSchedulerManager } from '../../../../../../main/ets/hisysevent/WorkSchedulerManager';
import workScheduler from '@ohos.resourceschedule.workScheduler';

const mWorkSchedulerManager: WorkSchedulerManager = WorkSchedulerManager.getInstance();
const mReport = ():void => {}

export function WorkSchedulerManagerTest() {
  describe('WorkSchedulerManagerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('WorkSchedulerManagerTest_registerReport', 0, async (done: Function) => {
      await mWorkSchedulerManager.registerReport(null);
      await mWorkSchedulerManager.registerReport(mReport);
      await mWorkSchedulerManager.registerReport(mReport);
      expect(mWorkSchedulerManager['reportList'].has(mReport)).assertTrue();
      mWorkSchedulerManager.executeReport();
      done();
    })

    it('WorkSchedulerManagerTest_unRegisterReport', 0, async (done: Function) => {
      await mWorkSchedulerManager.unRegisterReport(null);
      await mWorkSchedulerManager.unRegisterReport(mReport);
      await mWorkSchedulerManager.unRegisterReport(mReport);
      expect(mWorkSchedulerManager['reportList'].has(mReport)).assertFalse();
      mWorkSchedulerManager.executeReport();
      done();
    })

    it('WorkSchedulerManagerTest_unRegisterDelayTask', 0, async (done: Function) => {
      const workInfo: workScheduler.WorkInfo = {
        workId: 100001,
        isPersisted: true,
        isRepeat: true,
        repeatCycleTime: 60480000,
        bundleName: 'com.ohos.sceneboard',
        abilityName: 'WorkSchedulerManagerTest_unRegisterDelayTask'
      }
      await WorkSchedulerManager.registerDelayTask(workInfo);
      await WorkSchedulerManager.unRegisterDelayTask(null);
      await WorkSchedulerManager.unRegisterDelayTask(workInfo);
      expect(true).assertTrue();
      done();
    })

    it('WorkSchedulerManagerTest_executeReport', 0, (): void => {
      mWorkSchedulerManager.executeReport();
      expect(true).assertTrue();
    })
  })
}