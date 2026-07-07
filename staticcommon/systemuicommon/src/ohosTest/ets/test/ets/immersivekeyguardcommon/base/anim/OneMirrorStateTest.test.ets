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
import { it, describe, expect } from '@ohos/hypium';
import { OneMirrorState } from '../../../../../../../main/ets/immersivekeyguardcommon/base/anim/OneMirrorState';

export function OneMirrorStateTest() {
  describe('OneMirrorStateTest', (): void => {
    it('test_initOneMirrorState', 0, (): void => {
      let testInstance: OneMirrorState = new OneMirrorState();
      expect(testInstance instanceof OneMirrorState).assertTrue();
    });
    it('test_getRate', 0, (): void => {
      let testInstance: OneMirrorState = new OneMirrorState();
      let res = testInstance.getAodStyle(undefined);
      expect(res === undefined).assertTrue();
    });
    it('test_getRate_true', 0, (): void => {
      let testInstance: OneMirrorState = new OneMirrorState();
      let res = testInstance.getAodStyle(true);
      expect(res !== undefined).assertTrue();
    });
  });
}