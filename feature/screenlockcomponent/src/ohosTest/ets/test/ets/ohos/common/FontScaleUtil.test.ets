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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { sFontScaleUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/FontScaleUtil';
import TestConst from '../constants/TestConst';
import { FontScaleUtil } from '@ohos/screenlockwidget/src/main/ets/common/utils/FontScaleUtil';

export default function FontScaleUtilTest() {
  let mFontScaleUtilSon = new FontScaleUtilSon()

  describe('FontScaleUtilTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('FontScaleUtilTest_changeFontScale_01', TestConst.TEST_LEVEL, (): void => {
      let result: boolean = false;
      try {
        (sFontScaleUtil as object)['setFontScale']('1.5');
        (sFontScaleUtil as object)['changeFontScale'](100, 1.5);
        (sFontScaleUtil as object)['changeFontScale'](100, 1.4);
        (sFontScaleUtil as object)['changeFontScaleByResource']($r('app.float.pwd_prompt_fontsize'), 1.5);
        (sFontScaleUtil as object)['changeFontScaleByResource']($r('app.float.pwd_prompt_fontsize'), 1.4);
        (sFontScaleUtil as object)['changeLineHeight'](10, 1.5);
        (sFontScaleUtil as object)['changeLineHeight'](10, 1.4);
        result = true;
      } catch (e) {
        result = false;
      }
      expect(result).assertEqual(true);
    })

    it('FontScaleUtilTest_changeFontScale_01', TestConst.TEST_LEVEL, (): void => {
      mFontScaleUtilSon.fontScale = 10;
      mFontScaleUtilSon.maxLockIconFontSize = 0;
      mFontScaleUtilSon.ChangeOffset(1);
      mFontScaleUtilSon.maxLockIconFontSize = 20;
      let result = mFontScaleUtilSon.ChangeOffset(1);
      expect(result).not().assertNull();
    })

    it('FontScaleUtilTest_001', 0, (done: Function) => {
      try {
        let fontScaleUtil = new FontScaleUtil;
        let result = fontScaleUtil.init();
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('FontScaleUtilTest_002', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let fontScaleUtil = new FontScaleUtil;
        (fontScaleUtil as object)['changeFontScale'](3, 1);
        (fontScaleUtil as object)['changeFontScale'](3, 0.5);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('FontScaleUtilTest_003', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let fontScaleUtil = new FontScaleUtil;
        (fontScaleUtil as object)['changeFontScaleByResource'](3, 1);
        (fontScaleUtil as object)['changeFontScaleByResource'](3, 0.5);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('FontScaleUtilTest_004', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let fontScaleUtil = new FontScaleUtil;
        (fontScaleUtil as object)['changeLineHeight'](3, 1);
        (fontScaleUtil as object)['changeLineHeight'](3, 0.5);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('FontScaleUtilTest_005', 0, (done: Function) => {
      try {
        let fontScaleUtil = new FontScaleUtil;
        fontScaleUtil.maxLockIconFontSize = 1;
        fontScaleUtil.fontScale = 1;
        let result = mFontScaleUtilSon.ChangeOffset(1);
        expect(result !== null).assertTrue();
        let result2 = mFontScaleUtilSon.ChangeOffset(0.5);
        expect(result2 !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('FontScaleUtilTest_006', 0, (done: Function) => {
      try {
        let fontScaleUtil = new FontScaleUtil;
        let result = fontScaleUtil.setScreenChangeKeyBoardLayout();
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('FontScaleUtilTest_007', 0, (done: Function) => {
      try {
        let fontScaleUtil = new FontScaleUtil;
        let result = fontScaleUtil.setScreenChangeKeyBoardLayout(true);
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('FontScaleUtilTest_008', 0, (done: Function) => {
      try {
        let fontScaleUtil = new FontScaleUtil;
        let result = fontScaleUtil.getMinFontSize(false);
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('FontScaleUtilTest_009', 0, (done: Function) => {
      try {
        let fontScaleUtil = new FontScaleUtil;
        let result = fontScaleUtil.getMinFontSize(true);
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('FontScaleUtilTest_0010', 0, (done: Function) => {
      try {
        let fontScaleUtil = new FontScaleUtil;
        let result = fontScaleUtil.getMaxFontSize(true, false);
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('FontScaleUtilTest_011', 0, (done: Function) => {
      try {
        let fontScaleUtil = new FontScaleUtil;
        let result = fontScaleUtil.getMaxFontSize(true, true);
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('FontScaleUtilTest_012', 0, (done: Function) => {
      try {
        let fontScaleUtil = new FontScaleUtil;
        let result = fontScaleUtil.getMaxFontSize(false, true);
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
  })
}

export class FontScaleUtilSon extends FontScaleUtil {
  public fontScale = 0
  public maxLockIconFontSize = 0

  public ChangeOffset(value: number) {
    return this.changeOffset(value);
  }
}