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
import AnimationUtil from '@ohos/screenlockwidget/src/main/ets/editsheet/utils/AnimationUtil';

export default function AnimationUtilTest() {

  describe('AnimationUtilTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getInAndOutOpacityEffect_return', 0, (): void => {
      let delay: number = 1;
      AnimationUtil.getInAndOutOpacityEffect(delay);
      expect(delay).assertEqual(1);
    })

    it('test_getEditToolbarOpacityEffect_return', 0, (): void => {
      let index: number = 2;
      AnimationUtil.getEditToolbarOpacityEffect();
      AnimationUtil.getBtnInAndOutOpacityEffect();
      AnimationUtil.getPickerListItemTransition(index);
      AnimationUtil.getPickerCardTransition(index);
      expect(index).assertEqual(2);
    })

  })
}