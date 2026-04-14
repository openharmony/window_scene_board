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
import { AnimatorScene, DELAY_GC_TIMEOUT, GcController } from '@ohos/frameworkcommon/src/main/ets/memory/GcController';

export function GcControllerTest() {
  describe('GcControllerTest', (): void => {
    beforeAll((): void => {
      GcController.getInstance();
    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('checkRequestGc', 0, (): void => {
      expect(GcController.getInstance().requestGcTask('DT test')).assertTrue();
    })

    it('checkDelayGc', 0, (): void => {
      GcController.getInstance().delayGcTask(AnimatorScene.UNLOCK);
      expect(GcController.getInstance().requestGcTask('DT test')).assertFalse();
    })

    it('checkRestoreGc', 0, (): void => {
      GcController.getInstance().delayGcTask(AnimatorScene.UNLOCK);
      expect(GcController.getInstance().requestGcTask('DT test')).assertFalse();
      GcController.getInstance().restoreGcTask(AnimatorScene.UNLOCK);
      expect(GcController.getInstance().requestGcTask('DT test')).assertTrue();
    })

    it('checkDelayGc2', 0, (): void => {
      GcController.getInstance().delayGcTask(AnimatorScene.UNLOCK);
      GcController.getInstance().delayGcTask(AnimatorScene.OPEN_APP);
      expect(GcController.getInstance().requestGcTask('DT test')).assertFalse();
      GcController.getInstance().restoreGcTask(AnimatorScene.OPEN_APP);
      expect(GcController.getInstance().requestGcTask('DT test')).assertFalse();
      GcController.getInstance().restoreGcTask(AnimatorScene.UNLOCK);
      expect(GcController.getInstance().requestGcTask('DT test')).assertTrue();
    })

    it('checkDelayGc3', 0, async (done: Function) => {
      GcController.getInstance().delayGcTask(AnimatorScene.UNLOCK);
      expect(GcController.getInstance().requestGcTask('DT test')).assertFalse();
      setTimeout(() => {
        expect(GcController.getInstance().requestGcTask('DT test')).assertTrue();
        done();
      }, DELAY_GC_TIMEOUT);
    })

    it('checkRestoreGc4', 0, (): void => {
      GcController.getInstance().delayGcTask(AnimatorScene.UNLOCK);
      expect(GcController.getInstance().requestGcTask('DT test')).assertFalse();
      GcController.getInstance().restoreGcTask(AnimatorScene.UNLOCK);
      expect(GcController.getInstance().requestGcTask('DT test')).assertTrue();
    })
  })
}