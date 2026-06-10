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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { DragDataType, DragExtraInfo } from '../../../../../../../main/ets/TsIndex';

/**
 * 拖拽额外信息的测试用例
 */
export function DragExtraInfoTest() {
  describe('DragExtraInfoTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('should_return_correct_extra_info_string', Level.LEVEL0, (): void => {
      let extraInfo: DragExtraInfo = new DragExtraInfo(DragDataType.APP);
      expect(extraInfo.toString()).assertEqual(`{ "drag_data_type": "scb_app", "fromDesktop": true,` +
        ` "drag_allow_distributed": false }`);
      extraInfo.setBlurStyle(BlurStyle.Thin);
      expect(extraInfo.toString()).assertEqual(
        '{ "drag_data_type": "scb_app", "drag_blur_style": 1, "fromDesktop": true, "drag_allow_distributed": false }'
      );
      extraInfo.setRadius(10);
      expect(extraInfo.toString()).assertEqual(
        '{ "drag_data_type": "scb_app", "drag_blur_style": 1, "drag_corner_radius": 10,' +
          ' "fromDesktop": true, "drag_allow_distributed": false }'
      );
      extraInfo.setDeviceSn('1');
      expect(extraInfo.toString()).assertEqual(
        '{ "drag_data_type": "scb_app", "drag_blur_style": 1, "drag_corner_radius": 10,' +
          ' "drag_from_device": "1", "fromDesktop": true, "drag_allow_distributed": false }'
      );
      extraInfo.setDragOffsetX(1);
      expect(extraInfo.toString()).assertEqual(
        '{ "drag_data_type": "scb_app", "drag_blur_style": 1, "drag_corner_radius": 10,' +
          ` "drag_from_device": "1", "drag_offset_x": 1,` +
          ' "fromDesktop": true, "drag_allow_distributed": false }'
      );
      extraInfo.setDragOffsetY(1);
      expect(extraInfo.toString()).assertEqual(
        '{ "drag_data_type": "scb_app", "drag_blur_style": 1, "drag_corner_radius": 10,' +
          ` "drag_from_device": "1", "drag_offset_x": 1, "drag_offset_y": 1,` +
          ' "fromDesktop": true, "drag_allow_distributed": false }'
      );
    })
  })
}