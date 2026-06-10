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
import { RectItem } from '../../../../../../../src/main/ets/utils/Rect';

export function RectTest() {
  describe('RectTest', (): void => {
    let preDelHotArea: RectItem = new RectItem(0, 0, 0, 0);
    beforeAll((): void => {
      preDelHotArea.set(0, 0, 4, 4);
    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_RectItem_width', Level.LEVEL0, (): void => {
      let rect: RectItem = new RectItem(0, 0, 1, 1);
      let width: number = rect.width();
      expect(width).assertEqual(1);
    })

    it('test_RectItem_height', Level.LEVEL0, (): void => {
      let rect: RectItem = new RectItem(0, 0, 1, 1);
      let height: number = rect.height();
      expect(height).assertEqual(1);
    })

    it('test_RectItem_contains', Level.LEVEL0, (): void => {
      let res:boolean = preDelHotArea.contains(1, 1);
      expect(res).assertTrue();
    })

    it('test_RectItem_containsRect', Level.LEVEL0, (): void => {
      let area: RectItem = new RectItem(0, 0, 1, 1);
      let res:boolean = preDelHotArea.containsRect(area);
      expect(res).assertTrue();
    })

    it('test_RectItem_centerX', Level.LEVEL0, (): void => {
      let res:number = preDelHotArea.centerX();
      expect(res).assertEqual(2);
    })

    it('test_RectItem_centerY', Level.LEVEL0, (): void => {
      let res:number = preDelHotArea.centerY();
      expect(res).assertEqual(2);
    })

    it('test_RectItem_offset', Level.LEVEL0, (): void => {
      let rect: RectItem = new RectItem(0, 0, 4, 4);
      rect.offset(1, 2);

      expect(rect.left).assertEqual(0 + 1);
      expect(rect.right).assertEqual(4 + 1);
      expect(rect.top).assertEqual(0 + 2);
      expect(rect.bottom).assertEqual(4 + 2);
    })

    it('test_RectItem_setRect', Level.LEVEL0, (): void => {
      let rect1: RectItem = new RectItem(0, 0, 4, 4);
      let rect2: RectItem = new RectItem(0, 0, 5, 5);
      rect1.setRect(rect2);

      expect(rect1.left).assertEqual(0);
      expect(rect1.top).assertEqual(0);
      expect(rect1.right).assertEqual(5);
      expect(rect1.bottom).assertEqual(5);
    })

    it('test_RectItem_intersects', Level.LEVEL0, (): void => {
      let rect1: RectItem = new RectItem(0, 0, 2, 4);
      let rect2: RectItem = new RectItem(0, 0, 5, 5);
      expect(RectItem.intersects(rect1, rect2)).assertTrue();
      expect(RectItem.intersects(rect1, rect1)).assertTrue();

      let rect3: RectItem = new RectItem(0, 0, 2, 4);
      let rect4: RectItem = new RectItem(0, 5, 1, 6);
      expect(RectItem.intersects(rect3, rect4)).assertFalse();
    })

    it('test_RectItem_union4', Level.LEVEL0, (): void => {
      let rect1: RectItem = new RectItem(0, 0, 2, 4);
      rect1.union4(0, 0, 0, 0);
      expect(rect1.left).assertEqual(0);
      expect(rect1.top).assertEqual(0);
      expect(rect1.right).assertEqual(2);
      expect(rect1.bottom).assertEqual(4);

      let rect2: RectItem = new RectItem(0, 0, 0, 0);
      rect2.union4(0, 0, 2, 4);
      expect(rect2.left).assertEqual(0);
      expect(rect2.top).assertEqual(0);
      expect(rect2.right).assertEqual(2);
      expect(rect2.bottom).assertEqual(4);

      let rect3: RectItem = new RectItem(0, 0, 4, 4);
      rect3.union4(1, 1, 2, 2);
      expect(rect3.left).assertEqual(0);
      expect(rect3.top).assertEqual(0);
      expect(rect3.right).assertEqual(4);
      expect(rect3.bottom).assertEqual(4);

      let rect4: RectItem = new RectItem(1, 1, 2, 2);
      rect4.union4(0, 0, 4, 4);
      expect(rect4.left).assertEqual(0);
      expect(rect4.top).assertEqual(0);
      expect(rect4.right).assertEqual(4);
      expect(rect4.bottom).assertEqual(4);
    })

    it('test_RectItem_union', Level.LEVEL0, (): void => {
      let rect1: RectItem = new RectItem(0, 0, 4, 4);
      let rect2: RectItem = new RectItem(1, 1, 2, 2);
      rect1.union(rect2);
      expect(rect1.left).assertEqual(0);
      expect(rect1.top).assertEqual(0);
      expect(rect1.right).assertEqual(4);
      expect(rect1.bottom).assertEqual(4);
    })

    it('test_RectItem_toString', Level.LEVEL0, (): void => {
      let rect1: RectItem = new RectItem(0, 0, 2, 4);
      let str: String = rect1.toString();
      expect(str).assertEqual('Rect(0, 0 - 2, 4)');
    })

    it('should_return_true_when_point_is_inside_the_rect', 0, () => {
      let rectitem: RectItem = new RectItem(10, 10, 20, 20);
      let result = rectitem.contains(15, 15);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_point_is_outside_the_rect', 0, () => {
      let rectitem: RectItem = new RectItem(10, 10, 20, 20);
      let result = rectitem.contains(5, 5);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_x_is_at_the_left_of_the_rect', 0, () => {
      let rectitem: RectItem = new RectItem(10, 10, 20, 20);
      let result = rectitem.contains(9, 15);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_x_is_at_the_right_of_the_rect', 0, () => {
      let rectitem: RectItem = new RectItem(10, 10, 20, 20);
      let result = rectitem.contains(21, 15);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_y_is_at_the_top_of_the_rect', 0, () => {
      let rectitem: RectItem = new RectItem(10, 10, 20, 20);
      let result = rectitem.contains(15, 9);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_y_is_at_the_bottom_of_the_rect', 0, () => {
      let rectitem: RectItem = new RectItem(10, 10, 20, 20);
      let result = rectitem.contains(15, 21);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_this_contains_r', 0, () => {
      let rectitem: RectItem = new RectItem(0, 0, 10, 10);
      let r: RectItem = new RectItem(1, 1, 5, 5);
      const result = rectitem.containsRect(r);
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_this_does_not_contain_r', 0, () => {
      let rectitem: RectItem = new RectItem(0, 0, 10, 10);
      let r: RectItem = new RectItem(11, 11, 20, 20);
      const result = rectitem.containsRect(r);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_this_is_empty', 0, () => {
      let rectitem: RectItem = new RectItem(0, 0, 0, 0);
      let r: RectItem = new RectItem(1, 1, 5, 5);
      const result = rectitem.containsRect(r);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_this_equals_to_r', 0, () => {
      let rectitem: RectItem = new RectItem(0, 0, 10, 10);
      let r: RectItem = new RectItem(0, 0, 10, 10);
      const result = rectitem.containsRect(r);
      expect(result).assertEqual(true);
    });

    it('should_not_update_rect_when_new_values_are_less_than_current_values', 0, () => {
      let rectitem: RectItem = new RectItem(1, 2, 3, 4);
      let left: number = 0;
      let top: number = 1;
      let right: number = 2;
      let bottom: number = 3;
      rectitem.union4(left, top, right, bottom);
      expect(rectitem.left).assertEqual(0);
      expect(rectitem.top).assertEqual(1);
      expect(rectitem.right).assertEqual(3);
      expect(rectitem.bottom).assertEqual(4);
    });

    it('should_update_rect_when_new_values_are_greater_than_current_values', 0, () => {
      let rectitem: RectItem = new RectItem(5, 6, 7, 8);
      let left: number = 1;
      let top: number = 2;
      let right: number = 3;
      let bottom: number = 4;
      rectitem.union4(left, top, right, bottom);
      expect(rectitem.left).assertEqual(left);
      expect(rectitem.top).assertEqual(top);
      expect(rectitem.right).assertEqual(rectitem.right);
      expect(rectitem.bottom).assertEqual(rectitem.bottom);
    });

    it('should_not_update_rect_when_new_values_are_less_than_current_values_test2', 0, () => {
      let rectitem: RectItem = new RectItem(8, 7, 6, 5);
      let left: number = 1;
      let top: number = 2;
      let right: number = 3;
      let bottom: number = 4;
      rectitem.union4(left, top, right, bottom);
      expect(rectitem.left).assertEqual(left);
      expect(rectitem.top).assertEqual(top);
      expect(rectitem.right).assertEqual(right);
      expect(rectitem.bottom).assertEqual(bottom);
    });
  })
}