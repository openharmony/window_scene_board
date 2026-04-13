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
import { describe, expect, it } from '@ohos/hypium';
import { ObjectUtils } from '@ohos/themeservicebase/Index';

export default function ObjectUtilsTest() {
  describe('ObjectUtilsTest02_isNull', () => {
    it('should_return_true_when_object_is_null', 0, () => {
      expect(ObjectUtils.isNull(null)).assertTrue();
    });

    it('should_return_true_when_object_is_undefined', 0, () => {
      expect(ObjectUtils.isNull(undefined)).assertTrue();
    });

    it('should_return_false_when_object_is_not_null_or_undefined', 0, () => {
      expect(ObjectUtils.isNull([])).assertFalse();
    });
  });
}