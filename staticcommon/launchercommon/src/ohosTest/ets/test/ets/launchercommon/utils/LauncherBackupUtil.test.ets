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
import { describe, expect, it } from '@ohos/hypium';
import LauncherBackupUtil from '../../../../../../main/ets/utils/LauncherBackupUtil';

export default function LauncherBackupUtilTest() {
  describe('LauncherBackupUtilTest', () => {
    it('test_reportRemoveAppTwin', 0, () => {
      try {
        LauncherBackupUtil.reportRemoveAppTwin('', 0, 0);
      } catch (err) {
        expect(err).assertEqual("test_error");
      }
    });

    it('test_reportRemoveAppTwin1', 0, () => {
      try {
        LauncherBackupUtil.reportRemoveAppTwin('', 0, 1);
      } catch (err) {
        expect(err).assertEqual("test_error");
      }
    });
  })
}