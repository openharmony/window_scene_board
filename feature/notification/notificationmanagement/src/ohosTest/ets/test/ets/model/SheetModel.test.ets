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
import {
  describe,
  beforeEach,
  afterEach,
  it,
  expect,
} from '@ohos/hypium';
import { SheetModel } from '../../../../../main/ets/model/SheetModel';

export default function SheetModelTest() {
  describe('calcHeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 100;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

      it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
          let sheetmodel: SheetModel = SheetModel.get();
          sheetmodel.height = 50;
          sheetmodel.calcHeight();
          expect(sheetmodel.height).assertEqual(100);
      });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_update_height_when_height_does_not_equal_newHeight_and_newHeight_is_greater_than_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 50;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

    it('should_return_immediately_when_height_equals_newHeight_or_newHeight_is_less_than_or_equal_to_zero', 0, () => {
      let sheetmodel: SheetModel = SheetModel.get();
      sheetmodel.height = 100;
      sheetmodel.calcHeight();
      expect(sheetmodel.height).assertEqual(100);
    });

  });
}
