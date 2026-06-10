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
import { describe, expect, it, Level } from '@ohos/hypium';
import { LiveViewUtil } from '../../../../../main/ets/common/LiveViewUtil';

export default function LiveViewUtilTest() {
  describe('LiveViewUtilTest', () => {
    const position: Position = {
      x: 0, y: 0
    };

    const area: Area = {
      width: 10,
      height: 10,
      position: position,
      globalPosition: position,
    }

    it('isContains', Level.LEVEL0, () => {
      expect(LiveViewUtil.isContains(-Infinity, 10, area)).assertFalse();
    })

    it('isContains2', Level.LEVEL0, () => {
      expect(LiveViewUtil.isContains(0, -Infinity, area)).assertFalse();
    })

    it('isContains3', Level.LEVEL0, () => {
      expect(LiveViewUtil.isContains(Infinity, 0, area)).assertFalse();
    })

    it('isContains4', Level.LEVEL0, () => {
      expect(LiveViewUtil.isContains(0, Infinity, area)).assertFalse();
    })

    it('isContains5', Level.LEVEL0, () => {
      expect(LiveViewUtil.isContains(0, 0, area)).assertTrue();
    })
  })
}