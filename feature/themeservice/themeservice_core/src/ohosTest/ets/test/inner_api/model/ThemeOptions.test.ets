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
import { describe, expect, it, TestType } from '@ohos/hypium';
import { ThemeOptions } from '@ohos/themeservice_inner_api/Index';


export default function ThemeOptionsTest() {
  describe('themeOptions_enable', () => {
    it('enable_font', TestType.FUNCTION, async () => {
      let actualValue: string = new ThemeOptions().enableFont().value();
      expect(actualValue).assertEqual('{"fonts":"1"}');
    });
    it('enable_home', TestType.FUNCTION, async () => {
      let actualValue: string = new ThemeOptions().enableHome().value();
      expect(actualValue).assertEqual('{"home":"1"}');
    });
    it('enable_Lock', TestType.FUNCTION, async () => {
      let actualValue: string = new ThemeOptions().enableLock().value();
      expect(actualValue).assertEqual('{"lock":"1"}');
    });
    it('enable_aod', TestType.FUNCTION, async () => {
      let actualValue: string = new ThemeOptions().enableAod().value();
      expect(actualValue).assertEqual('{"aod":"1"}');
    });
    it('enable_icons', TestType.FUNCTION, async () => {
      let actualValue: string = new ThemeOptions().enableIcons().value();
      expect(actualValue).assertEqual('{"icons":"1"}');
    });
    it('enable_skin', TestType.FUNCTION, async () => {
      let actualValue: string = new ThemeOptions().enableSkin().value();
      expect(actualValue).assertEqual('{"skin":"1"}');
    });
    it('enable_fa', TestType.FUNCTION, async () => {
      let actualValue: string = new ThemeOptions().enableFa().value();
      expect(actualValue).assertEqual('{"fa":"1"}');
    });
    it('enable_sub_screen', TestType.FUNCTION, async () => {
      let actualValue: string = new ThemeOptions().enableSubScreen().value();
      expect(actualValue).assertEqual('{"sub_screen":"1"}');
    });
  });
}