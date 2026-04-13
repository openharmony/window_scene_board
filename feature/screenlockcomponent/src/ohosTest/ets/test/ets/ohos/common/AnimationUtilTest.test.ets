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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { CommonAnimationUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/AnimationUtil';

export default function AnimationUtilTest1() {
  describe('AnimationUtilTest1', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_createAnimateTo_return', 0, (): void => {
      let curve = Curve.Linear;
      let delay = 1;
      let duration = 1;
      let finish = () => {
      };
      CommonAnimationUtil.createAnimateTo(curve, delay, duration, finish);
      CommonAnimationUtil.createAnimateToImmediately(curve, delay, duration, finish);
      expect(curve).not().assertNull();
    })

    it('test_isFaceSkinExist_return', 0, (): void => {
      const isDark = true;
      CommonAnimationUtil.isFaceSkinExist(isDark);
      let result = CommonAnimationUtil.getCurrentThemePath();
      expect(result).not().assertUndefined();
    })

    it('test_isFileAccessed_return', 0, (): void => {
      let fileListPath: string[] = [];
      const result = CommonAnimationUtil.isFileAccessed('1', fileListPath);
      expect(result).assertEqual(false);
    })

    it('test_isFileAccessed_return_one', 0, (): void => {
      let fileListPath: string[] = ['1'];
      const result = CommonAnimationUtil.isFileAccessed('1', fileListPath);
      expect(result).assertEqual(false);
    })
  })
}