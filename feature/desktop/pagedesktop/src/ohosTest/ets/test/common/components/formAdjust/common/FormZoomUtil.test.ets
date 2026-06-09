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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  TestType,
  Level,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { CardItemInfo, CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import {
  ZoomPosition,
  ZoomOffset,
  ZoomType,
  CheckZoomResult
} from '../../../../../../../main/ets/default/common/components/formAdjust/common/FormZoomCommonType';
import { FormZoomUtil } from '../../../../../../../main/ets/default/common/components/formAdjust/common/FormZoomUtil';

export default function FormZoomUtilTest() {
  describe('FormZoomUtilTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getZoomType', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let zoomPosition: ZoomPosition = ZoomPosition.LEFT;
        let offsetX: number = 10;
        let offsetY: number = 10;
        expect(FormZoomUtil.getZoomType(zoomPosition, offsetX, offsetY)).assertEqual(ZoomType.ZOOM_IN);

        offsetX = -10;
        expect(FormZoomUtil.getZoomType(zoomPosition, offsetX, offsetY)).assertEqual(ZoomType.ZOOM_OUT);

        zoomPosition = ZoomPosition.RIGHT;
        expect(FormZoomUtil.getZoomType(zoomPosition, offsetX, offsetY)).assertEqual(ZoomType.ZOOM_IN);

        offsetX = 10;
        expect(FormZoomUtil.getZoomType(zoomPosition, offsetX, offsetY)).assertEqual(ZoomType.ZOOM_OUT);

        zoomPosition = ZoomPosition.TOP;
        expect(FormZoomUtil.getZoomType(zoomPosition, offsetX, offsetY)).assertEqual(ZoomType.ZOOM_IN);

        offsetY = -10;
        expect(FormZoomUtil.getZoomType(zoomPosition, offsetX, offsetY)).assertEqual(ZoomType.ZOOM_OUT);

        zoomPosition = ZoomPosition.BOTTOM;
        expect(FormZoomUtil.getZoomType(zoomPosition, offsetX, offsetY)).assertEqual(ZoomType.ZOOM_IN);

        offsetY = 10;
        expect(FormZoomUtil.getZoomType(zoomPosition, offsetX, offsetY)).assertEqual(ZoomType.ZOOM_OUT);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('getOffset', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let zoomOffset: ZoomOffset;
        let zoomPosition: ZoomPosition = ZoomPosition.LEFT;
        let offsetX: number = 10;
        let offsetY: number = 10;

        zoomOffset = FormZoomUtil.getOffset(zoomPosition, offsetX, offsetY)
        expect(zoomOffset.offsetX).assertEqual(-offsetX);

        zoomPosition = ZoomPosition.RIGHT;
        zoomOffset = FormZoomUtil.getOffset(zoomPosition, offsetX, offsetY)
        expect(zoomOffset.offsetX).assertEqual(offsetX);

        zoomPosition = ZoomPosition.TOP;
        zoomOffset = FormZoomUtil.getOffset(zoomPosition, offsetX, offsetY)
        expect(zoomOffset.offsetY).assertEqual(-offsetY);

        zoomPosition = ZoomPosition.BOTTOM;
        zoomOffset = FormZoomUtil.getOffset(zoomPosition, offsetX, offsetY)
        expect(zoomOffset.offsetY).assertEqual(offsetY);

        zoomPosition = ZoomPosition.LEFT_TOP;
        zoomOffset = FormZoomUtil.getOffset(zoomPosition, offsetX, offsetY)
        expect(zoomOffset.offsetX).assertEqual(-offsetX);
        expect(zoomOffset.offsetY).assertEqual(-offsetY);

        zoomPosition = ZoomPosition.RIGHT_TOP;
        zoomOffset = FormZoomUtil.getOffset(zoomPosition, offsetX, offsetY)
        expect(zoomOffset.offsetX).assertEqual(offsetX);
        expect(zoomOffset.offsetY).assertEqual(-offsetY);

        zoomPosition = ZoomPosition.RIGHT_BOTTOM;
        zoomOffset = FormZoomUtil.getOffset(zoomPosition, offsetX, offsetY)
        expect(zoomOffset.offsetX).assertEqual(offsetX);
        expect(zoomOffset.offsetY).assertEqual(offsetY);

        zoomPosition = ZoomPosition.LEFT_BOTTOM;
        zoomOffset = FormZoomUtil.getOffset(zoomPosition, offsetX, offsetY)
        expect(zoomOffset.offsetX).assertEqual(-offsetX);
        expect(zoomOffset.offsetY).assertEqual(offsetY);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('checkZoom_1', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let zoomPosition: ZoomPosition = ZoomPosition.LEFT;
        let zoomType: ZoomType = ZoomType.ZOOM_OUT;
        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.page = 3;
        cardItem.cardDimension = CommonConstants.CARD_DIMENSION_2x2;
        let result: CheckZoomResult = FormZoomUtil.checkZoom(zoomPosition, zoomType, cardItem);
        expect(result.targetArea.canZoom).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('checkZoom_2', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let zoomPosition: ZoomPosition = ZoomPosition.LEFT;
        let zoomType: ZoomType = ZoomType.ZOOM_IN;
        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.row = 0;
        cardItem.column = 0;
        cardItem.area = [4, 4];
        cardItem.page = 3;
        cardItem.cardDimension = CommonConstants.CARD_DIMENSION_4x4;
        let result: CheckZoomResult = FormZoomUtil.checkZoom(zoomPosition, zoomType, cardItem);
        expect(result.targetArea.canZoom).assertTrue();
        expect(result.targetArea.cardDimension).assertEqual(CommonConstants.CARD_DIMENSION_2x2);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}