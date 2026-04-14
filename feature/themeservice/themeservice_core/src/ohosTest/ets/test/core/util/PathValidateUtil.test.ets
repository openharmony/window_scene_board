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

import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { FileUtil } from '@ohos/themeservicebase/Index';
import { PathValidateUtil } from '../../../../../main/ets/validate/PathValidateUtil';

export default function PathValidateUtilTest() {
  describe('PathValidateUtilTest', () => {

    it('should_return_false_when_pkgNames_is_empty', 0, async (done: Function) => {
      const result = await PathValidateUtil.validatePkgPath("path", []);
      expect(result).assertFalse();
      done();
    });

    it('should_return_false_when_any_pkgPath_does_not_exist', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtil, FileUtil.isFileExists);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result = await PathValidateUtil.validatePkgPath("path", ["pkg1"]);
      expect(result).assertFalse();
      mocker.ignoreMock(FileUtil, FileUtil.isFileExists);
      done();
    });

    it('should_return_true_when_all_pkgPaths_exist', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtil, FileUtil.isFileExists);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result = await PathValidateUtil.validatePkgPath("path", ["pkg1", "pkg2"]);
      expect(result).assertTrue();
      mocker.ignoreMock(FileUtil, FileUtil.isFileExists);
      done();
    });
  })
}