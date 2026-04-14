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
import i18n from '@ohos.i18n';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { OuterButtonDockData } from '../../../../main/ets/default/data/OuterButtonDockData';
import { SmallFoldStyleUtil } from '@ohos/launchercommon/src/main/ets/utils/SmallFoldStyleUtil';
import { EditModeDockConstants } from '../../../../main/ets/default/common/constants/EditModeStyleConstants';

/**
 * 定义语言常量
 */
const SIMPLIFIED_CHINESE: string = 'zh-Hans';
const ENGLISH: string = 'en-Latn';

export function OuterButtonDockDataTest() {
  describe('OuterButtonDockDataTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_getMaxFontScale', 0, async () => {
      const outerButtonDockData = new OuterButtonDockData();
      const language = i18n.System.getSystemLanguage();
      i18n.System.setSystemLanguage(SIMPLIFIED_CHINESE);
      expect(outerButtonDockData.getMaxFontScale()).assertEqual(SmallFoldStyleUtil.LEVEL_BIG_2_FONT_SIZE_SCALE);
      await sleep(1000);
      i18n.System.setSystemLanguage(ENGLISH);
      expect(outerButtonDockData.getMaxFontScale()).assertEqual(SmallFoldStyleUtil.NORMAL_FONT_SIZE_SCALE);
      await sleep(1000);
      i18n.System.setSystemLanguage('bo');
      expect(outerButtonDockData.getMaxFontScale()).assertEqual(SmallFoldStyleUtil.LEVEL_BIG_1_FONT_SIZE_SCALE);
      await sleep(1000);
      i18n.System.setSystemLanguage(language);
    })

    it('test_getStdFontSize', 0, async () => {
      const outerButtonDockData = new OuterButtonDockData();
      const language = i18n.System.getSystemLanguage();
      i18n.System.setSystemLanguage(ENGLISH);
      expect(outerButtonDockData.getStdFontSize()).assertEqual(EditModeDockConstants.OUTER_EDIT_MODE_EN_FONT_SIZE);
      await sleep(1000);
      i18n.System.setSystemLanguage(SIMPLIFIED_CHINESE);
      expect(outerButtonDockData.getStdFontSize()).assertEqual(EditModeDockConstants.OUTER_EDIT_MODE_FONT_SIZE);
      await sleep(1000);
      i18n.System.setSystemLanguage(language);
    })
  })
}

const sleep: Function = (ms: number): Promise<void> => {
  return new Promise(res => setTimeout(res, ms))
};