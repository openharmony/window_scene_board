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

import { describe, it, expect, } from '@ohos/hypium';

import { WindowAnimationUtils } from '../../../../../../../Index';
import { SCBKeyboardManager, SCBKeyboardSession, SCBSessionRect } from '../../../../../../main/ets/TsIndex';


export default function WindowAnimationUtilsTest() {
  describe('WindowAnimationUtilsTest', () => {
    it('getInputAnimationCurve', 0, () => {
      let utils = WindowAnimationUtils.getInstance();
      utils.getInputAnimationCurve('enter');
      utils.getInputAnimationCurve('exit');
      utils.getInputAnimationCurve('exit1');
      expect(true).assertTrue();
    });
    it('getInputAnimationDuration', 0, () => {
      let utils = WindowAnimationUtils.getInstance();
      expect(utils.getInputAnimationDuration('enter')).assertEqual(150);
    });
  });
}