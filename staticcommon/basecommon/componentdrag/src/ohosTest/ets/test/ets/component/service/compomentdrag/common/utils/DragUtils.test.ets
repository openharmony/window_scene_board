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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  DragGridItem,
  DragGridPosition
} from '../../../../../../../../../main/ets/service/compomentdrag/common/type/CommonTypes'
import { DragUtils } from '../../../../../../../../../main/ets/service/compomentdrag/common/utils/DragUtils'

export default function DragUtilsTest() {
  describe('DragUtilsTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('isGridItem1x1_test_01', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: [1, 1]
      };
      DragUtils.isGridItem1x1(dragGridItem);
      expect(dragUtils).not().assertUndefined();
    })

    it('isGridItem1x1_test_02', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {};
      DragUtils.isGridItem1x1(dragGridItem);
      expect(dragUtils).not().assertUndefined();
    })

    it('isGridItem1x1_test_03', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: []
      };
      DragUtils.isGridItem1x1(dragGridItem);
      expect(dragUtils).not().assertUndefined();
    })

    it('isGridItem1x1_test_04', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: [2, 1]
      };
      DragUtils.isGridItem1x1(dragGridItem);
      expect(dragUtils).not().assertUndefined();
    })

    it('isGridItem1x1_test_05', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: [1, 2]
      };
      DragUtils.isGridItem1x1(dragGridItem);
      expect(dragUtils).not().assertUndefined();
    })

    it('isDragItemValid_test_01', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: [1, 1]
      };
      DragUtils.isDragItemValid(dragGridItem);
      expect(dragUtils).not().assertUndefined();
    })

    it('isDragItemValid_test_02', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {};
      DragUtils.isDragItemValid(dragGridItem);
      expect(dragUtils).not().assertUndefined();
    })

    it('isDragItemValid_test_03', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: -1,
        column: 1,
        area: [1, 1]
      };
      DragUtils.isDragItemValid(dragGridItem);
      expect(dragUtils).not().assertUndefined();
    })

    it('isDragItemValid_test_04', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: -1,
        area: [1, 1]
      };
      DragUtils.isDragItemValid(dragGridItem);
      expect(dragUtils).not().assertUndefined();
    })

    it('isDragItemValid_test_05', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: -1
      };
      DragUtils.isDragItemValid(dragGridItem);
      expect(dragUtils).not().assertUndefined();
    })

    it('isAreaValid_test_01', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: -1,
        area: [1, 1]
      };
      DragUtils.isAreaValid(dragGridItem.area);
      expect(dragUtils).not().assertUndefined();
    })

    it('isAreaValid_test_02', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: -1,
        area: []
      };
      DragUtils.isAreaValid(dragGridItem.area);
      expect(dragUtils).not().assertUndefined();
    })

    it('isAreaValid_test_03', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: -1,
        area: [1]
      };
      DragUtils.isAreaValid(dragGridItem.area);
      expect(dragUtils).not().assertUndefined();
    })

    it('isAreaValid_test_04', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: -1,
        area: [0, 1]
      };
      DragUtils.isAreaValid(dragGridItem.area);
      expect(dragUtils).not().assertUndefined();
    })

    it('isAreaValid_test_05', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: -1,
        area: [1, 0]
      };
      DragUtils.isAreaValid(dragGridItem.area);
      expect(dragUtils).not().assertUndefined();
    })

    it('isGridPositionEqual_test_01', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      DragUtils.isGridPositionEqual(null, null);
      expect(dragUtils).not().assertUndefined();
    })

    it('isGridPositionEqual_test_02', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let other: DragGridPosition = {
        row: 1,
        column: 1
      }
      DragUtils.isGridPositionEqual(null, other);
      expect(dragUtils).not().assertUndefined();
    })

    it('isGridPositionEqual_test_03', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let ori: DragGridPosition = {
        row: 1,
        column: 1
      }
      DragUtils.isGridPositionEqual(ori, null);
      expect(dragUtils).not().assertUndefined();
    })

    it('isGridPositionEqual_test_04', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let ori: DragGridPosition = {
        row: 1,
        column: 1
      }
      let other: DragGridPosition = {
        row: 1,
        column: 1
      }
      DragUtils.isGridPositionEqual(ori, other);
      expect(dragUtils).not().assertUndefined();
    })

    it('getCoveredItem_test_01', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: undefined,
        column: 1,
        area: [1, 0]
      };
      let layout: DragGridItem[] = [dragGridItem, dragGridItem]
      let dragGridPosition: DragGridPosition = {
        row: 1,
        column: 1
      }
      DragUtils.getCoveredItem(layout, dragGridItem, dragGridPosition);
      expect(dragUtils).not().assertUndefined();
    })

    it('getCoveredItem_test_02', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: undefined,
        area: [1, 0]
      };
      let layout: DragGridItem[] = [dragGridItem, dragGridItem]
      let dragGridPosition: DragGridPosition = {
        row: 1,
        column: 1
      }
      DragUtils.getCoveredItem(layout, dragGridItem, dragGridPosition);
      expect(dragUtils).not().assertUndefined();
    })

    it('getCoveredItem_test_03', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: undefined
      };
      let layout: DragGridItem[] = [dragGridItem, dragGridItem]
      let dragGridPosition: DragGridPosition = {
        row: 1,
        column: 1
      }
      DragUtils.getCoveredItem(layout, dragGridItem, dragGridPosition);
      expect(dragUtils).not().assertUndefined();
    })

    it('getCoveredItem_test_04', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: [1, 1]
      };
      let layout: DragGridItem[] = [dragGridItem, dragGridItem]
      let dragGridPosition: DragGridPosition = {
        row: 1,
        column: 1
      }
      DragUtils.getCoveredItem(layout, dragGridItem, dragGridPosition);
      expect(dragUtils).not().assertUndefined();
    })

    it('getCoveredItem_test_05', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: [0, 1]
      };
      let layout: DragGridItem[] = [dragGridItem, dragGridItem]
      let dragGridPosition: DragGridPosition = {
        row: 1,
        column: 1
      }
      DragUtils.getCoveredItem(layout, dragGridItem, dragGridPosition);
      expect(dragUtils).not().assertUndefined();
    })

    it('getCoveredItem_test_06', 0, () => {
      let dragUtils: DragUtils = new DragUtils();
      let dragGridItem: DragGridItem = {
        row: 1,
        column: 1,
        area: [1, 0]
      };
      let layout: DragGridItem[] = [dragGridItem, dragGridItem]
      let dragGridPosition: DragGridPosition = {
        row: 1,
        column: 1
      }
      DragUtils.getCoveredItem(layout, dragGridItem, dragGridPosition);
      expect(dragUtils).not().assertUndefined();
    })
  })
}