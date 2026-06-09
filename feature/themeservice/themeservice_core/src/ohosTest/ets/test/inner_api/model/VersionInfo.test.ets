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
import { describe, expect, it } from '@ohos/hypium';
import { VersionInfo } from '@ohos/themeservice_inner_api/Index';

export default function VersionInfoTest() {
  describe('VersionInfoTest', () => {
    it('should_return_false_when_info_is_undefined', 0, async (done: Function) => {
      let versionInfo = new VersionInfo(1, 2, 3, 4);
      const result = versionInfo.equals(undefined);
      expect(result).assertFalse();
      done();
    });

    it('should_return_false_when_majorVersion_is_different', 0, async (done: Function) => {
      let versionInfo = new VersionInfo(1, 2, 3, 4);
      let otherVersionInfo = new VersionInfo(5, 2, 3, 4);
      const result = versionInfo.equals(otherVersionInfo);
      expect(result).assertFalse();
      done();
    });

    it('should_return_false_when_seniorVersion_is_different', 0, async (done: Function) => {
      let versionInfo = new VersionInfo(1, 2, 3, 4);
      let otherVersionInfo = new VersionInfo(1, 6, 3, 4);
      const result = versionInfo.equals(otherVersionInfo);
      expect(result).assertFalse();
      done();
    });

    it('should_return_false_when_featureVersion_is_different', 0, async (done: Function) => {
      let versionInfo = new VersionInfo(1, 2, 3, 4);
      let otherVersionInfo = new VersionInfo(1, 2, 7, 4);
      const result = versionInfo.equals(otherVersionInfo);
      expect(result).assertFalse();
      done();
    });

    it('should_return_false_when_buildVersion_is_different', 0, async (done: Function) => {
      let versionInfo = new VersionInfo(1, 2, 3, 4);
      let otherVersionInfo = new VersionInfo(1, 2, 3, 8);
      const result = versionInfo.equals(otherVersionInfo);
      expect(result).assertFalse();
      done();
    });

    it('should_return_true_when_all_versions_are_the_same', 0, async (done: Function) => {
      let versionInfo = new VersionInfo(1, 2, 3, 4);
      let otherVersionInfo = new VersionInfo(1, 2, 3, 4);
      const result = versionInfo.equals(otherVersionInfo);
      expect(result).assertTrue();
      done();
    });
  });
}