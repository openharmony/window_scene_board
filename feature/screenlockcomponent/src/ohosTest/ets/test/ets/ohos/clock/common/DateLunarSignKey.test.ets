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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level, expect } from '@ohos/hypium';
import { VisibleKeyWrapper, SignFormKey }  from '@ohos/screenlockwidget/src/main/ets/clock/common/SignFormKey';

/**
 * 沉浸式锁屏测试用例
 */
export default function DateLunarSignKeyTest() {
  describe('DateLunarSignKeyTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_DateLunarSignKey', Level.LEVEL1, (): void => {
      expect(SignFormKey.VISIBLE_NONE).not().assertNull();
      expect(SignFormKey.VISIBLE_SIGN).not().assertNull();
      expect(SignFormKey.VISIBLE_FORM).not().assertNull();
      expect(SignFormKey.VISIBLE_SIGN_FORM).not().assertNull();
    });

    it('test_VisibleKeyWrapperGetKey', Level.LEVEL0, (): void => {
      let viskeywapper = new VisibleKeyWrapper();
      viskeywapper.isSignVisible = undefined;
      viskeywapper.isFormVisible = undefined;
      VisibleKeyWrapper.getKey(viskeywapper);
      viskeywapper.isSignVisible = true;
      VisibleKeyWrapper.getKey(viskeywapper);
      viskeywapper.isSignVisible = false;
      VisibleKeyWrapper.getKey(viskeywapper);
      viskeywapper.isFormVisible = false;
      VisibleKeyWrapper.getKey(viskeywapper);
      viskeywapper.isFormVisible = true;
      expect(VisibleKeyWrapper).not().assertNull();
    });
  });
}