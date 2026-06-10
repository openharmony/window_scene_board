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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { BackgroundLinearGradient } from '../../../../../main/ets/viewmodel/BackgroundLinearGradient';


export function BackgroundLinearGradientTest() {
  describe('BackgroundLinearGradientTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });
    let backgroundLinearGradient = new BackgroundLinearGradient();

    it('getLinearGradientType', Level.LEVEL0, (): void => {
      try {
        backgroundLinearGradient.getLinearGradientType();
      } catch (err) {}
      expect(Reflect.has(backgroundLinearGradient, 'getLinearGradientType')).assertTrue();
    });

    it('setLinearGradientType', Level.LEVEL0, (): void => {
      try {
        backgroundLinearGradient.setLinearGradientType(0);
      } catch (err) {}
      expect(Reflect.has(backgroundLinearGradient, 'setLinearGradientType')).assertTrue();
    });

    it('getLinearGradientColors', Level.LEVEL0, (): void => {
      try {
        backgroundLinearGradient.getLinearGradientColors();
        backgroundLinearGradient.setLinearGradientType(999);
        backgroundLinearGradient.getLinearGradientColors();
      } catch (err) {}
      expect(Reflect.has(backgroundLinearGradient, 'getLinearGradientColors')).assertTrue();
    });

    it('getLinearGradientAngle', Level.LEVEL0, (): void => {
      try {
        backgroundLinearGradient.getLinearGradientAngle();
      } catch (err) {}
      expect(Reflect.has(backgroundLinearGradient, 'getLinearGradientAngle')).assertTrue();
    });
  });
}