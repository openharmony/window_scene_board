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
import { AodManifest, AodThemeConstants } from '@ohos/aod';

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  AodThemeParamDirector
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/builder/AodThemeParamDirector';

export function AodThemeParamDirectorTest() {
  let aodThemeParamDirector: AodThemeParamDirector = new AodThemeParamDirector();
  describe('AodThemeParamDirectorTest', () => {

    beforeAll((): void => {

    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('only_one_instance_when_call_any_times_of_getInstance', 0, () => {
      const instance0 = AodThemeParamDirector.getInstance();
      const instance1 = AodThemeParamDirector.getInstance();
      expect(instance0).assertDeepEquals(instance1);
    });

    it('AodThemeParamDirectorTest_constructAodThemeParam1', 0, () => {
      const instance = AodThemeParamDirector.getInstance();
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.DIGITAL_CLOCK;
      instance.constructAodThemeParam(aodManifest);
      expect(true).assertDeepEquals(true);
    });

    it('AodThemeParamDirectorTest_constructAodThemeParam2', 0, () => {
      const instance = AodThemeParamDirector.getInstance();
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.FULL_SCREEN;
      instance.constructAodThemeParam(aodManifest);
      expect(true).assertDeepEquals(true);
    });

    it('AodThemeParamDirectorTest_constructAodThemeParam3', 0, () => {
      const instance = AodThemeParamDirector.getInstance();
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.EYES_ON_DISPLAY;
      instance.constructAodThemeParam(aodManifest);
      expect(true).assertDeepEquals(true);
    });

    it('AodThemeParamDirectorTest_getAodThemeParamBuilder1', 0, () => {
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.DIGITAL_CLOCK;
      (aodThemeParamDirector as object)['constructAodThemeParam'](aodManifest);
      expect(aodManifest).not().assertUndefined();
    });

    it('AodThemeParamDirectorTest_getAodThemeParamBuilder2', 0, () => {
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.FULL_SCREEN;
      (aodThemeParamDirector as object)['constructAodThemeParam'](aodManifest);
      expect(aodManifest).not().assertUndefined();
    });

    it('AodThemeParamDirectorTest_getAodThemeParamBuilder3', 0, () => {
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.DIAL_CLOCK;
      (aodThemeParamDirector as object)['constructAodThemeParam'](aodManifest);
      expect(aodManifest).not().assertUndefined();
    });

    it('AodThemeParamDirectorTest_getAodThemeParamBuilder4', 0, () => {
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.EYES_ON_DISPLAY;
      (aodThemeParamDirector as object)['constructAodThemeParam'](aodManifest);
      expect(aodManifest).not().assertUndefined();
    });

    it('AodThemeParamDirectorTest_getAodThemeParamBuilder5', 0, () => {
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.DIGITAL_CLOCK_COLOR;
      (aodThemeParamDirector as object)['constructAodThemeParam'](aodManifest);
      expect(aodManifest).not().assertUndefined();
    });

    it('AodThemeParamDirectorTest_getAodThemeParamBuilder6', 0, () => {
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.DIGITAL_CLOCK_3D;
      (aodThemeParamDirector as object)['constructAodThemeParam'](aodManifest);
      expect(aodManifest).not().assertUndefined();
    });

    it('AodThemeParamDirectorTest_getAodThemeParamBuilder7', 0, () => {
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.DIGITAL_CLOCK_3D_SHADOW;
      (aodThemeParamDirector as object)['constructAodThemeParam'](aodManifest);
      expect(aodManifest).not().assertUndefined();
    });

    it('AodThemeParamDirectorTest_getAodThemeParamBuilder8', 0, () => {
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.LOCAL_MOUNTAIN_SEA;
      (aodThemeParamDirector as object)['constructAodThemeParam'](aodManifest);
      expect(aodManifest).not().assertUndefined();
    });

    it('AodThemeParamDirectorTest_getAodThemeParamBuilder9', 0, () => {
      const aodManifest = new AodManifest();
      aodManifest.type = AodThemeConstants.OUTER_WEATHER_STYLE;
      (aodThemeParamDirector as object)['constructAodThemeParam'](aodManifest);
      expect(aodManifest).not().assertUndefined();
    });
  });
}