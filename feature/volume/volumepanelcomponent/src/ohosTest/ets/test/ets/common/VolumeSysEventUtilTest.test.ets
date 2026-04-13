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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { VolumeReportBuilder, VolumeReportParams, VolumeSysEventUtil } from '../../../../../main/ets/com/ohos/common/VolumeSysEventUtil';

export function VolumeSysEventUtilTest() {
  describe('VolumeSysEventUtilTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_builder', Level.LEVEL0, (): void => {
      let builder: VolumeReportBuilder = VolumeReportBuilder.builder();
      expect(builder !== undefined).assertTrue();
    });

    it('test_build', Level.LEVEL0, (): void => {
      let builder: VolumeReportBuilder = VolumeReportBuilder.builder();
      let param: VolumeReportParams = builder.build();
      expect(param !== undefined).assertTrue();
    });

    it('test_channel', Level.LEVEL0, (): void => {
      let builder: VolumeReportBuilder = VolumeReportBuilder.builder();
      let param: VolumeReportBuilder = builder.channel(0);
      expect(param !== undefined).assertTrue();
    });

    it('test_isLocked', Level.LEVEL0, (): void => {
      let builder: VolumeReportBuilder = VolumeReportBuilder.builder();
      let param: VolumeReportBuilder = builder.isLocked(true);
      expect(param !== undefined).assertTrue();
    });

    it('test_uiType', Level.LEVEL0, (): void => {
      let builder: VolumeReportBuilder = VolumeReportBuilder.builder();
      let param: VolumeReportBuilder = builder.uiType(1);
      expect(param !== undefined).assertTrue();
    });

    it('test_volume', Level.LEVEL0, (): void => {
      let builder: VolumeReportBuilder = VolumeReportBuilder.builder();
      let param: VolumeReportBuilder = builder.volume(20);
      expect(param !== undefined).assertTrue();
    });
  });
}