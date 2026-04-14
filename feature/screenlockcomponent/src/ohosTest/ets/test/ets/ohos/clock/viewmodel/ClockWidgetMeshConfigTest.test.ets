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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level, expect } from '@ohos/hypium';
import clockWidgetMeshConfig from '@ohos/screenlockwidget/src/main/ets/clock/viewmodel/ClockWidgeMeshConfig';
import { AnyClock } from '@ohos/screenlockwidget/src/main/ets/editsheet/models/AnyClock';
import { ClockLayout } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';

/**
 * 沉浸式锁屏测试用例
 */
export default function ClockWidgetMeshConfigTest() {
  describe('ClockWidgetMeshConfigTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    let anyClock: AnyClock = new AnyClock();

    it('test_setClockMesh', Level.LEVEL0, (): void => {
      anyClock.layout = ClockLayout.DIMENSION_4_4;
      clockWidgetMeshConfig.setClockMesh(anyClock);
      anyClock.layout = ClockLayout.DIMENSION_4_2;
      clockWidgetMeshConfig.setClockMesh(anyClock);
      anyClock.layout = ClockLayout.DIMENSION_2_4;
      clockWidgetMeshConfig.setClockMesh(anyClock);
      anyClock.layout = ClockLayout.DIMENSION_3_6;
      clockWidgetMeshConfig.setClockMesh(anyClock);
      anyClock.layout = ClockLayout.DIMENSION_6_6;
      clockWidgetMeshConfig.setClockMesh(anyClock);
      anyClock.layout = ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SEPERATOR;
      clockWidgetMeshConfig.setClockMesh(anyClock);
      anyClock.layout = ClockLayout.MOUNTAIN_CLOCK_LAYOUT;
      clockWidgetMeshConfig.setClockMesh(anyClock);
      anyClock.layout = ClockLayout.NORMAL_CLOCK_LAYOUT;
      clockWidgetMeshConfig.setClockMesh(anyClock);
      anyClock.layout = ClockLayout.NORMAL_CLOCK_LAYOUT_LEFT;
      clockWidgetMeshConfig.setClockMesh(anyClock);
      anyClock.layout = ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL;
      clockWidgetMeshConfig.setClockMesh(anyClock);
      expect(clockWidgetMeshConfig).not().assertNull();
    });
  });
}