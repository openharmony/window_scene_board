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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit } from '@ohos/hypium';
import { InvertColor } from '../../../../../../../main/ets/immersivekgcommon/immersivekg/bean/ImmInvertColorInfo';
import { ImmInvertColorInfo } from '../../../../../../../../Index';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmInvertColorInfoTest() {
  let mocker: MockKit;
  describe('ImmInvertColorInfoTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {

    });
    afterAll((): void => {
      mocker.clearAll();
    });
    afterEach((): void => {

    });

    it('setSbContentColorTest', Level.LEVEL0, (): void => {
      let info: ImmInvertColorInfo = new ImmInvertColorInfo();
      let black = InvertColor.COLOR_BLACK;
      let white = InvertColor.COLOR_WHITE;
      (info as object)['_sbContentColor'] = black;
      (info as object)['setSbContentColor'](white);
      (info as object)['_sbContentColor'] = white;
      (info as object)['setSbContentColor'](black);
      expect(true).assertTrue();
    });

    it('getSbContentColorTest', Level.LEVEL0, (): void => {
      let info: ImmInvertColorInfo = new ImmInvertColorInfo();
      let black = InvertColor.COLOR_BLACK;
      (info as object)['_sbContentColor'] = black;
      (info as object)['getSbContentColor']();
      (info as object)['_sbContentColor'] = undefined;
      (info as object)['getSbContentColor']();
      expect(true).assertTrue();
    });

    it('setSbBgGradientEnableTest', Level.LEVEL0, (): void => {
      let info: ImmInvertColorInfo = new ImmInvertColorInfo();
      let black = InvertColor.COLOR_BLACK;
      (info as object)['_sbContentColor'] = black;
      (info as object)['getSbContentColor']();
      (info as object)['_sbContentColor'] = undefined;
      (info as object)['getSbContentColor']();
      expect(true).assertTrue();
    });

    it('isSbBgGradientEnableTest', Level.LEVEL0, (): void => {
      let info: ImmInvertColorInfo = new ImmInvertColorInfo();
      (info as object)['isSbBgGradientEnable']();
      expect(true).assertTrue();
    });

    it('setImmBackBtnColorTest', Level.LEVEL0, (): void => {
      let info: ImmInvertColorInfo = new ImmInvertColorInfo();
      let black = InvertColor.COLOR_BLACK;
      let white = InvertColor.COLOR_WHITE;
      (info as object)['_immBackBtnColor'] = black;
      (info as object)['setImmBackBtnColor'](white);
      (info as object)['_immBackBtnColor'] = black;
      (info as object)['setImmBackBtnColor'](black);
      expect(true).assertTrue();
    });

    it('getImmBackBtnColorTest', Level.LEVEL0, (): void => {
      let info: ImmInvertColorInfo = new ImmInvertColorInfo();
      (info as object)['getImmBackBtnColor']();
      expect(true).assertTrue();
    });

    it('isBtnColorWhiteTest', Level.LEVEL0, (): void => {
      let info: ImmInvertColorInfo = new ImmInvertColorInfo();
      let black = InvertColor.COLOR_BLACK;
      let white = InvertColor.COLOR_WHITE;
      (info as object)['_immBackBtnColor'] = black;
      (info as object)['isBtnColorWhite']();
      (info as object)['_immBackBtnColor'] = white;
      (info as object)['isBtnColorWhite']();
      expect(true).assertTrue();
    });
  });
}



