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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LanguageUtil } from '../../../../../../main/ets/default/utils/LanguageUtil';


/**
 * LanguageUtil测试
 *
 * @since 2025-06-11
 */
export default function LanguageUtilTest() {
  describe('getCurrentLanguage_testSuite', () => {


    it('atc_should_return_DEFAULT_CHINESE_CN_when_systemLanguage_includes_SIMPLIFIED_CHINESE', 0, () => {
      let mocker: MockKit = new MockKit();

      const result: ESObject = LanguageUtil.getCurrentLanguage();
      expect(result).assertEqual(LanguageUtil.DEFAULT_CHINESE_CN);

    });

    it('atc_should_return_CHINESE_HK_when_systemLanguage_includes_TRADITIONAL_CHINESE_and_languageRegions_length_greater_than_1_and_second_element_is_REGION_HK', 0, () => {
      let mocker: MockKit = new MockKit();

      const result: ESObject = LanguageUtil.getCurrentLanguage();
      expect(result).assertEqual(LanguageUtil.CHINESE_HK);

    });

    it('atc_should_return_CHINESE_TW_when_systemLanguage_includes_TRADITIONAL_CHINESE_and_languageRegions_length_greater_than_1_and_second_element_is_not_REGION_HK', 0, () => {
      let mocker: MockKit = new MockKit();

      const result: ESObject = LanguageUtil.getCurrentLanguage();
      expect(result).assertEqual(LanguageUtil.CHINESE_TW);

    });

    it('atc_should_return_deviceLanguage_when_systemLanguage_includes_deviceLanguage_and_not_includes_TRADITIONAL_CHINESE_or_SIMPLIFIED_CHINESE', 0, () => {
      let mocker: MockKit = new MockKit();

      const result: ESObject = LanguageUtil.getCurrentLanguage();
      expect(result).assertEqual('en_US');

    });

    it('atc_should_return_matchedLanguage_when_systemLanguage_does_not_include_deviceLanguage_and_includes_language_in_SUPPORT_MULTI_LANGUAGES', 0, () => {
      let mocker: MockKit = new MockKit();

      const result: ESObject = LanguageUtil.getCurrentLanguage();
      expect(result).assertEqual('ug_CN');

    });

    it('atc_should_return_DEFAULT_CHINESE_CN_when_systemLanguage_does_not_include_any_language_in_SUPPORT_MULTI_LANGUAGES', 0, () => {
      let mocker: MockKit = new MockKit();

      const result: ESObject = LanguageUtil.getCurrentLanguage();
      expect(result).assertEqual(LanguageUtil.DEFAULT_CHINESE_CN);

    });
  });
}