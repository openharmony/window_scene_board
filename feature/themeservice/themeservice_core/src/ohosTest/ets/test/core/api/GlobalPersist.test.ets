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
import { describe, expect, it, Level, TestType } from '@ohos/hypium';
import { GlobalPersistInfo } from '../../../../../main/ets/remote/model/GlobalPersistInfo';
import { globalPersistService } from '../../../../../main/ets/service/impl/GlobalPersistServiceImpl';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { AssertUtils } from '../../../core/util/AssertUtils';

const globalPersistInfo: GlobalPersistInfo = {
  themeId: '1',
  version: 1,
  data: {
    'key': 'data',
  },
};

export default function GlobalPersistTest() {
  describe('GlobalPersistTest', () => {
    it('set_globalPersist_test', 0, async () => {
      let ret: boolean = await TSOhosTestManger.getTsCoreRemoteApi().setGlobalPersist(globalPersistInfo);
      expect(ret).assertTrue();

      let resInfo: Nullable<GlobalPersistInfo> = await TSOhosTestManger.getTsCoreRemoteApi().getGlobalPersist();
      expect(resInfo?.themeId).assertEqual(globalPersistInfo.themeId);
      expect(resInfo?.version).assertEqual(globalPersistInfo.version);
      expect(resInfo?.data).assertDeepEquals(globalPersistInfo.data);
    });

    it('get_globalPersist_test', 0, async () => {
      globalPersistService.get().clearGlobalPersistData();

      await TSOhosTestManger.getTsCoreRemoteApi().setGlobalPersist(globalPersistInfo);
      globalPersistService.get().clearGlobalPersistData();
      let resInfo: Nullable<GlobalPersistInfo> = await TSOhosTestManger.getTsCoreRemoteApi().getGlobalPersist();
      expect(resInfo?.themeId).assertEqual(globalPersistInfo.themeId);
      expect(resInfo?.version).assertEqual(0);
      expect(resInfo?.data).assertDeepEquals({});
    });

    it('setGlobalPersist_parallel_test', TestType.SECURITY | Level.LEVEL1, async () => {
      await AssertUtils.expectParallelInvoke(() =>
      TSOhosTestManger.getTsCoreRemoteApi().setGlobalPersist(globalPersistInfo));
    });
  });

}