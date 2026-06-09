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

import { afterAll, afterEach, beforeAll, beforeEach, describe, Level, it, expect } from '@ohos/hypium';
import { CapsulePositionType } from '../../../../../../main/ets/common/ImmersiveConstants';
import { ImmersiveCapsuleList } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCapsuleList';
import { ImmersiveNtfData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';

export function ImmersiveCapsuleListTest() {

  describe('ImmersiveCapsuleListTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_addDataChangeListener', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleList();
      data.addDataChangeListener((type: CapsulePositionType, data?: ImmersiveNtfData): void => {

      });
      expect(res).assertTrue();
    });

    it('test_removeDataChangeListener', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleList();
      data.removeDataChangeListener((type: CapsulePositionType, data?: ImmersiveNtfData): void => {

      });
      expect(res).assertTrue();
    });

    it('test_getNtfData', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleList();
      data.getNtfData(CapsulePositionType.TYPE_CONTENT);
      expect(res).assertTrue();
    });

    it('test_update', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleList();
      data.update(new ImmersiveCapsuleList());
      expect(res).assertTrue();
    });

    it('test_clear', Level.LEVEL0, (): void => {
      let res = true;
      let data = new ImmersiveCapsuleList();
      data.clear();
      expect(res).assertTrue();
    });
  })
}