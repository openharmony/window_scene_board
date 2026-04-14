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
import { TSManager } from '@ohos/themeservicekit/Index';
import { TSOhosTestManger } from '../../core/TSOhosTestManger';

export default function TSManagerTest() {
  describe('TSManagerTest', () => {
    it('TSManagerTest_01', 0, () => {
      // 检查返回的TSRemoteApi对象是否与我们之前创建的对象相同
      expect(TSManager.getRemoteCaller(TSOhosTestManger.getContext())).not().assertUndefined();
      expect(TSManager.getRemoteApi(TSOhosTestManger.getContext())).not().assertUndefined();
    });
  });
}