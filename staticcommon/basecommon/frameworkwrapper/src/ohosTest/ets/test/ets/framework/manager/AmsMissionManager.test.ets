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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { amsMissionManager } from '../../../../../../main/ets/manager/AmsMissionManager';


export function AmsMissionManagerTest() {
  describe('AmsMissionManagerTest', () => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    it('clearMission_missionId_zero', 0, async (done: Function) => {
      amsMissionManager['mMissionId'] = 0;
      await amsMissionManager.clearMission(amsMissionManager['mMissionId']);
      expect(true).assertTrue();
      done();
    })

    it('clearMission_missionId', 0, async (done: Function) => {
      amsMissionManager['mMissionId'] = -1;
      await amsMissionManager.clearMission(amsMissionManager['mMissionId']);
      expect(true).assertTrue();
      amsMissionManager['mMissionId'] = 1000;
      await amsMissionManager.clearMission(amsMissionManager['mMissionId']);
      expect(true).assertTrue();
      done();
    })

    it('clearAllMissions_void', 0, async (done: Function) => {
      await amsMissionManager.clearAllMissions();
      expect(true).assertTrue();
      done();
    })

    it('getRecentMissionsList_array', 0, async (done: Function) => {
      let res = await amsMissionManager.getOriginRecentMissionsList();
      expect(res).not().assertUndefined();
      done();
    })

    it('moveMissionToFront_return_nothing', 0, async (done: Function) => {
      let missionId: number = 0;
      await amsMissionManager.moveMissionToFront(missionId);
      expect(true).assertTrue();
      missionId = 1;
      await amsMissionManager.moveMissionToFront(missionId, 1);
      expect(true).assertTrue();
      done();
    })
  })
}
