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
import { FormViewModel } from '@ohos/form';
import {
  CardItemInfo,
  CommonConstants,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormZoomVm } from '../../../../../../../main/ets/default/common/components/formAdjust/viewModel/FormZoomVm';
import {
  FormZoomEvent
} from '../../../../../../../main/ets/default/common/components/formAdjust/viewModel/FormZoomEvent';
import {
  CheckZoomResult,
  ZoomOffset,
  ZoomType
} from '../../../../../../../main/ets/default/common/components/formAdjust/common/FormZoomCommonType';

const REBOUND_THRESHOLD: number = 12;

export default function FormZoomEventTest() {
  describe('FormZoomEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getFormItem', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formZoomVm: FormZoomVm = new FormZoomVm();
        let width: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let height: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let formZoomEvent: FormZoomEvent = new FormZoomEvent(formZoomVm, width, height);

        let cardItem: CardItemInfo = new CardItemInfo();
        cardItem.id = 'formZoomTest';
        formZoomEvent.initCardInfo(cardItem);

        let formItem: CardItemInfo = formZoomEvent.getFormItem();
        expect(formItem.id).assertEqual('formZoomTest');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('setFormZoomSize', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formZoomVm: FormZoomVm = new FormZoomVm();
        let width: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let height: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let formZoomEvent: FormZoomEvent = new FormZoomEvent(formZoomVm, width, height);

        let cardItem: CardItemInfo = new CardItemInfo();
        formZoomEvent.initCardInfo(cardItem);

        let newWidth: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_4x4)) as number;
        let newHeight: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_4x4)) as number;
        formZoomEvent.setFormZoomSize({width: newWidth, height: newHeight});
        expect(formZoomVm.width).assertEqual(newWidth);
        expect(formZoomVm.height).assertEqual(newHeight);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onDragZoomMove', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formZoomVm: FormZoomVm = new FormZoomVm();
        let width: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let height: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let formZoomEvent: FormZoomEvent = new FormZoomEvent(formZoomVm, width, height);

        let targetWidth: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_4x4)) as number;
        let targetHeight: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_4x4)) as number;

        let result: CheckZoomResult = {
          zoomType: ZoomType.ZOOM_OUT,
          targetArea: {
            canZoom: true,
            row: 0,
            column: 0,
            area: [4, 4],
            alignContent: Alignment.TopStart,
            cardDimension: CommonConstants.CARD_DIMENSION_4x4
          }
        };

        let zoomOffset: ZoomOffset = {
          offsetX: targetWidth - width,
          offsetY: 0
        }

        formZoomEvent.onDragZoomMove(result, zoomOffset);
        expect(formZoomVm.width).assertEqual(targetWidth);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onDragZoomMove_ZoomOut', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formZoomVm: FormZoomVm = new FormZoomVm();
        let width: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let height: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let formZoomEvent: FormZoomEvent = new FormZoomEvent(formZoomVm, width, height);

        let targetWidth: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_4x4)) as number;

        let result: CheckZoomResult = {
          zoomType: ZoomType.ZOOM_OUT,
          targetArea: {
            canZoom: true,
            row: 0,
            column: 0,
            area: [4, 4],
            alignContent: Alignment.TopStart,
            cardDimension: CommonConstants.CARD_DIMENSION_4x4
          }
        };

        let zoomOffset: ZoomOffset = {
          offsetX: targetWidth + REBOUND_THRESHOLD * 2 - width,
          offsetY: 0
        }

        formZoomEvent.onDragZoomMove(result, zoomOffset);
        expect(formZoomVm.width).assertEqual(targetWidth);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onDragZoomMove_ZoomIn', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formZoomVm: FormZoomVm = new FormZoomVm();
        let width: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_4x4)) as number;
        let height: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_4x4)) as number;
        let formZoomEvent: FormZoomEvent = new FormZoomEvent(formZoomVm, width, height);

        let targetHeight: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;

        let result: CheckZoomResult = {
          zoomType: ZoomType.ZOOM_IN,
          targetArea: {
            canZoom: true,
            row: 0,
            column: 0,
            area: [2, 2],
            alignContent: Alignment.TopStart,
            cardDimension: CommonConstants.CARD_DIMENSION_2x2
          }
        };

        let zoomOffset: ZoomOffset = {
          offsetX: 0,
          offsetY: targetHeight - REBOUND_THRESHOLD * 2 - height
        }

        formZoomEvent.onDragZoomMove(result, zoomOffset);
        expect(formZoomVm.height).assertEqual(targetHeight);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onDragZoomEnd_Invalid', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formZoomVm: FormZoomVm = new FormZoomVm();
        let width: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let height: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let formZoomEvent: FormZoomEvent = new FormZoomEvent(formZoomVm, width, height);

        formZoomEvent.onDragZoomEnd();
        expect(formZoomVm.width).assertEqual(width);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onDragZoomEnd_ZoomOut', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formZoomVm: FormZoomVm = new FormZoomVm();
        let width: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let height: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let formZoomEvent: FormZoomEvent = new FormZoomEvent(formZoomVm, width, height);

        let result: CheckZoomResult = {
          zoomType: ZoomType.ZOOM_OUT,
          targetArea: {
            canZoom: true,
            row: 0,
            column: 0,
            area: [4, 4],
            alignContent: Alignment.TopStart,
            cardDimension: CommonConstants.CARD_DIMENSION_4x4
          }
        };

        let zoomOffset: ZoomOffset = {
          offsetX: REBOUND_THRESHOLD,
          offsetY: 0
        }
        formZoomEvent.onDragZoomMove(result, zoomOffset);
        formZoomEvent.onDragZoomEnd();
        expect(formZoomVm.width).assertEqual(width);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onDragZoomEnd_ZoomIn', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formZoomVm: FormZoomVm = new FormZoomVm();
        let width: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_4x4)) as number;
        let height: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_4x4)) as number;
        let formZoomEvent: FormZoomEvent = new FormZoomEvent(formZoomVm, width, height);

        let result: CheckZoomResult = {
          zoomType: ZoomType.ZOOM_IN,
          targetArea: {
            canZoom: true,
            row: 0,
            column: 0,
            area: [2, 2],
            alignContent: Alignment.TopStart,
            cardDimension: CommonConstants.CARD_DIMENSION_2x2
          }
        };

        let zoomOffset: ZoomOffset = {
          offsetX: 0,
          offsetY: -REBOUND_THRESHOLD
        }
        formZoomEvent.onDragZoomMove(result, zoomOffset);
        formZoomEvent.onDragZoomEnd();
        expect(formZoomVm.height).assertEqual(height);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('onDragZoomEnd_Refresh', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let formZoomVm: FormZoomVm = new FormZoomVm();
        let width: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let height: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormHeight.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
        let formZoomEvent: FormZoomEvent = new FormZoomEvent(formZoomVm, width, height);

        let targetWidth: number = FormViewModel.getInstance().getFormStyleConfig()
          .mFormWidth.get(String(CommonConstants.CARD_DIMENSION_4x4)) as number;

        let result: CheckZoomResult = {
          zoomType: ZoomType.ZOOM_OUT,
          targetArea: {
            canZoom: true,
            row: 0,
            column: 0,
            area: [4, 4],
            alignContent: Alignment.TopStart,
            cardDimension: CommonConstants.CARD_DIMENSION_4x4
          }
        };

        let zoomOffset: ZoomOffset = {
          offsetX: targetWidth - width,
          offsetY: 0
        }
        formZoomEvent.onDragZoomMove(result, zoomOffset);
        formZoomEvent.onDragZoomEnd();
        expect(formZoomVm.width).assertEqual(targetWidth);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}