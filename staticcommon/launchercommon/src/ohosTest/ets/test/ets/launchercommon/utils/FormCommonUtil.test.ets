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

import Want from '@ohos.app.ability.Want';
import formInfo from '@ohos.app.form.formInfo';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  MockKit,
  expect,
  ArgumentMatchers,
  when,
} from '@ohos/hypium';
import { OverflowConstants, FormType } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import { CommonConstants, FormLocation } from '../../../../../../main/ets/constants/CommonConstants';
import { FormCommonUtil } from '../../../../../../main/ets/TsIndex';
import { CardItemInfo } from '../../../../../../main/ets/bean/CardItemInfo';
import { GameCardInfo } from '../../../../../../main/ets/bean/GameCardInfo';
import { TextColor, WallpaperColorManager } from '@ohos/frameworkwrapper';
import { image } from '@kit.ImageKit';
import { componentUtils } from '@kit.ArkUI';

const FORM_TRANSPARENCY_COLOR = '#00000000';

export function FormCommonUtilTest() {
  describe('FormCommonUtilTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterAll(() => {
    });
    afterEach(() => {
    });
    it('getCommonWant', 0, () => {
      expect(FormCommonUtil.getCommonWant(undefined)).not().assertEqual(0);
      expect(FormCommonUtil.getCommonWant({ extend1: ' ', isTransparent: false, formLocation: undefined }))
        .not().assertEqual(0);

      let want: Want = {};
      want = FormCommonUtil.getCommonWant({
        extend1: JSON.stringify(want),
        isTransparent: true,
        formLocation: FormLocation.DESKTOP });
      expect(want.parameters?.[CommonConstants.FORM_BACKGROUND_TRANSPARENCY]).assertEqual(FORM_TRANSPARENCY_COLOR);
      expect(want.parameters?.[CommonConstants.FORM_LOCATION_KEY]).assertEqual(FormLocation.DESKTOP);
    });

    it('getCommonWantTextColor', 0, () => {
      WallpaperColorManager.getInstance().mTextColor = new TextColor(FORM_TRANSPARENCY_COLOR, 1, 1, 1, '1', 1);
      WallpaperColorManager.getInstance().mOuterTextColor = new TextColor(FORM_TRANSPARENCY_COLOR, 1, 1, 1, '1', 4);
      let want: Want = {};
      want = FormCommonUtil.getCommonWant({
        extend1: JSON.stringify(want),
        isTransparent: true,
        formLocation: FormLocation.DESKTOP,
        isOuterDesktop: false});
      expect(want.parameters?.[formInfo.FormParam.HOST_BG_INVERSE_COLOR_KEY]).assertEqual(WallpaperColorManager.getInstance().mTextColor);
    });

    it('getCommonWantOuterTextColor', 0, () => {
      WallpaperColorManager.getInstance().mTextColor = new TextColor(FORM_TRANSPARENCY_COLOR, 1, 1, 1, '1', 1);
      WallpaperColorManager.getInstance().mOuterTextColor = new TextColor(FORM_TRANSPARENCY_COLOR, 1, 1, 1, '1', 4);
      let want: Want = {};
      want = FormCommonUtil.getCommonWant({
        extend1: JSON.stringify(want),
        isTransparent: true,
        formLocation: FormLocation.DESKTOP,
        isOuterDesktop: true});
      expect(want.parameters?.[formInfo.FormParam.HOST_BG_INVERSE_COLOR_KEY]).assertEqual(WallpaperColorManager.getInstance().mOuterTextColor);
    });

    it('test_updateFormColor', 0, () => {
      FormCommonUtil.updateFormColor('1', false);
      WallpaperColorManager.getInstance().mTextColor = new TextColor(FORM_TRANSPARENCY_COLOR, 1, 1, 1, '1', 1);
      FormCommonUtil.updateFormColor('1', false);
      expect(true).assertTrue();
    })

    it('test_getFormComponentId', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      let ret = FormCommonUtil.getFormComponentId(item, false);
      expect(ret).assertEqual('FormItem_InvalidId');
    })

    it('test_getFormStackComponentId', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      let ret = FormCommonUtil.getFormStackComponentId('');
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_getFormStackComponentId_01', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      let ret = FormCommonUtil.getFormStackComponentId(undefined);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_getFormStackComponentId_02', 0, () => {
      let item: CardItemInfo = new CardItemInfo();
      let ret = FormCommonUtil.getFormStackComponentId('123');
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_updateFormColor', 0, () => {
      let ret = FormCommonUtil.updateFormColor('123', true);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_updateFormColor_01', 0, () => {
      let ret = FormCommonUtil.updateFormColor('123', false);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_updateFormColor_02', 0, () => {
      let ret = FormCommonUtil.updateFormColor('', false);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_updateFormColor_03', 0, () => {
      let ret = FormCommonUtil.updateFormColor('', true);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_requestFormWithParams', 0, () => {
      let ret = FormCommonUtil.requestFormWithParams('');
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_requestFormWithParams_01', 0, () => {
      let ret = FormCommonUtil.requestFormWithParams('123');
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_requestFormWithParams_02', 0, () => {
      let wantParams: Record<string, Object> | undefined = undefined;
      let ret = FormCommonUtil.requestFormWithParams('123', wantParams);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_transformCardId', 0, () => {
      let ret = FormCommonUtil.transformCardId('');
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_transformCardId_01', 0, () => {
      let ret = FormCommonUtil.transformCardId('0');
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_transformCardId_02', 0, () => {
      let ret = FormCommonUtil.transformCardId('123');
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_convertPixelMap2String', 0, () => {
      let pixelMap: image.PixelMap | undefined = undefined;
      let ret = FormCommonUtil.convertPixelMap2String(pixelMap);
    })

    it('test_convertString2PixelMap', 0, () => {
      let ret = FormCommonUtil.convertString2PixelMap('');
    })

    it('test_convertString2PixelMap_01', 0, () => {
      let ret = FormCommonUtil.convertString2PixelMap(undefined);
    })

    it('test_convertString2PixelMap_02', 0, () => {
      let ret = FormCommonUtil.convertString2PixelMap('123');
    })

    it('test_getEnableBlurBackground', 0, () => {
      let cardItem = null;
      let ret = FormCommonUtil.getEnableBlurBackground(cardItem);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_getEnableBlurBackground_01', 0, () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.isTransparent = true;
      let ret = FormCommonUtil.getEnableBlurBackground(cardItem);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_getEnableBlurBackground_02', 0, () => {
      let cardItem: CardItemInfo = new CardItemInfo();
      cardItem.isTransparent = false;
      let ret = FormCommonUtil.getEnableBlurBackground(cardItem);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_getFormRect', 0, () => {
      let formBuilderId: string = '';
      let ret = FormCommonUtil.getFormRect(formBuilderId);
      expect(ret).assertUndefined();
    })

    it('test_getFormRect', 0, () => {
      let formBuilderId: string = '';
      let componentItem: componentUtils.ComponentInfo =
        {
          size: { width: 100, height: 100 },
          windowOffset: { x: 10, y: 10 },
          localOffset: { x: 0, y: 0 },
          screenOffset: { x: 0, y: 0 },
          translate: { x: 0, y: 0, z: 0 },
          scale: {
            x: 0,
            y: 0,
            z: 0,
            centerX: 0,
            centerY: 0
          },
          rotate: {
            x: 0,
            y: 0,
            z: 0,
            centerX: 0,
            centerY: 0,
            angle: 0
          },
          transform: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        };
      const mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(componentUtils, componentUtils.getRectangleById);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(componentItem);
      let ret: formInfo.Rect | undefined = FormCommonUtil.getFormRect(formBuilderId);
      expect(ret?.width).assertEqual(100);
      expect(ret?.height).assertEqual(100);
      expect(ret?.left).assertEqual(10);
      expect(ret?.top).assertEqual(10);
    })

    it('test_getInfoType_commonType', 0, () => {
      let gameCardInfo: GameCardInfo = new GameCardInfo();
      let ret = FormCommonUtil.getFormType(gameCardInfo);
      expect(ret).assertEqual(FormType.COMMON_FORM_TYPE);
    })

    it('test_getInfoType_animationType', 0, () => {
      let gameCardInfo: GameCardInfo = new GameCardInfo();
      gameCardInfo.extensionType = OverflowConstants.ANIMATION_TYPE;
      let ret = FormCommonUtil.getFormType(gameCardInfo);
      expect(ret).assertEqual(FormType.ANIMATION_FORM_TYPE);
    })

    it('test_getInfoType_interactionType', 0, () => {
      let gameCardInfo: GameCardInfo = new GameCardInfo();
      gameCardInfo.extensionType = OverflowConstants.INTERACTION_TYPE;
      let ret = FormCommonUtil.getFormType(gameCardInfo);
      expect(ret).assertEqual(FormType.INTERACTION_FORM_TYPE);
    })

    it('test_getInfoType_quickType', 0, () => {
      let gameCardInfo: GameCardInfo = new GameCardInfo();
      gameCardInfo.gameType = OverflowConstants.QUICK_TYPE_GAMECARD;
      let ret = FormCommonUtil.getFormType(gameCardInfo);
      expect(ret).assertEqual(FormType.INTERACTION_FORM_TYPE);
    })
  })
}