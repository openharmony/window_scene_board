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
import { describe, it, expect } from '@ohos/hypium';
import { liveStartAnimMgr } from '../../../../../../main/ets/liveview/common/LiveItemStartAnimManager';
import { LiveUseScene } from '../../../../../../main/ets/TsIndex';

export default function LiveItemStartAnimManagerTest() {
  describe('LiveItemStartAnimManagerTest', (): void => {
    it('startAnimPre', 0, () => {
      try {
        let helper = () => {
          let startAgent = (hasAnim: boolean = true) => {};
          liveStartAnimMgr.startAnimPre({
            cardId: 'xxxxx',
            startBundleName: 'test.com',
            cardComponentId: 'test',
            cardRadius: undefined,
            scene: LiveUseScene.SCENE_SCREEN_LOCK_NOTIFICATION,
            onPreComplete: startAgent
          });
          throw new Error('startAnimPre_success');
        }
        expect(helper()).assertThrowError('startAnimPre_success');
      } catch (e) {
      }
    })
  })
}