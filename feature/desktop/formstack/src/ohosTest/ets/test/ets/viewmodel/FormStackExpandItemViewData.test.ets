/**
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
import { CheckEmptyUtils } from '@ohos/basicutils';
import { FormStackExpandConfig } from '../../../../../main/ets/common/FormStackExpandConfig';
import { FormStackExpandModel } from '../../../../../main/ets/common/FormStackExpandModel';
import { FormStackUtil } from '../../../../../main/ets/common/FormStackUtil';
import { FormStackExpandItem } from '../../../../../main/ets/viewmodel/FormStackExpandItem';

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when,
} from '@ohos/hypium';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormStackExpandEventInterface } from '../../../../../main/ets/common/FormStackExpandEventInterface';
import { FormStackExpandItemViewData } from '../../../../../main/ets/viewmodel/FormStackExpandItemViewData';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { image } from '@kit.ImageKit';

export function FormStackExpandItemViewDataTest() {
  describe('FormStackExpandItemViewDataTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initData', 0, () => {
      let viewData: FormStackExpandItemViewData =
        FormStackTestUtil.createFormStackExpandItemViewData(FormStackTestUtil.TEST_ITEM_ID1,
        {} as FormStackExpandEventInterface);
      viewData.resetData();
    });
    let formStackExpandItemViewData: FormStackExpandItemViewData = new FormStackExpandItemViewData();
    let formStackExpandItem: FormStackExpandItem = new FormStackExpandItem();
    let expandModel: FormStackExpandModel = new FormStackExpandModel();
    let cardInfo: CardItemInfo = new CardItemInfo();
    let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
    let mEventInterface: FormStackExpandEventInterface = {
      onDelete: (id: string): void => {
      },
      onClick: (id: string): void => {
      },
      onDragStart: (id: string, event?: DragEvent): void => {
      },
      onDragEnd: (id: string, event?: DragEvent): void => {
      },
      onPanGestureStart: (id: string): void => {
      },
      onPanGestureMove: (id: string, offsetY: number): void => {
      },
      onPanGestureEnd: (id: string, offsetY: number, velocityY: number): void => {
      },
      isTopItemOfFormStack: (id: string): boolean => {
        return true;
      },
      getFormStackExpandModel: (): FormStackExpandModel => {
        return new FormStackExpandModel();
      },
      onTouch: (id: string, zoomOut: boolean): void => {
      },
      getExclusiveActionItemId: (): string => {
        return 'a';
      },
      onTrashAngleMoveChange: (id: string, ratio: number): void => {
      },
      onTrashAngleRestored: (id: string, eventFunc: () => void): void => {
      },
      onCardMoveLinkage: (zIndex: number, ratio: number): void => {
      },
      onCardEndLinkage: (zIndex: number, ratio: number, result: number): void => {
      },
      restoreLateralSlideCardPos: (distance: number): void => {
      },
      onLongPressGesture: (id: string): void => {
      },
      syncDragSnapshot: (img: image.PixelMap): void => {
      },
      getFormStackLength: (): number => {
        return 0;
      }
    }

    it('initFormOffsetData_test01', 0, () => {
      config.mFormHeight = 2;
      formStackExpandItemViewData.mItemInfo = formStackExpandItem;
      formStackExpandItemViewData.mEventInterface = mEventInterface;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc =
          mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
        let mockFunc1 = mocker.mockFunc(mEventInterface, mEventInterface.isTopItemOfFormStack);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(config);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
        formStackExpandItemViewData.initFormOffsetData();
        expect(formStackExpandItemViewData).not().assertUndefined();
        mocker.clear(FormStackExpandConfig);
        mocker.clear(mEventInterface);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('initFormOffsetData_test02', 0, () => {
      config.mFormHeight = 2;
      formStackExpandItemViewData.mItemInfo = formStackExpandItem;
      formStackExpandItemViewData.mEventInterface = mEventInterface;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc =
          mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
        let mockFunc1 = mocker.mockFunc(mEventInterface, mEventInterface.isTopItemOfFormStack);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        formStackExpandItemViewData.initFormOffsetData();
        expect(formStackExpandItemViewData).not().assertUndefined();
        mocker.clear(FormStackExpandConfig);
        mocker.clear(mEventInterface);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('updateDelImgTranslateX_test01', 0, () => {
      formStackExpandItemViewData.mItemInfo = undefined;
      formStackExpandItemViewData.updateDelImgTranslateX();
      expect(formStackExpandItemViewData).not().assertUndefined();

      config.mFormWidth = 0;
      formStackExpandItemViewData.mItemInfo = formStackExpandItem;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
        when(mockFunc)().afterReturn(config);
        formStackExpandItemViewData.updateDelImgTranslateX();
        expect(formStackExpandItemViewData).not().assertUndefined();
        mocker.clear(FormStackExpandConfig);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('updateDelImgTranslateX_test02', 0, () => {
      config.mFormWidth = 1;
      config.mIsExpandCenter = false;
      formStackExpandItemViewData.mItemInfo = formStackExpandItem;
      formStackExpandItemViewData.mDeleteImageMoveLongestDistance = 6;
      formStackExpandItemViewData.mFormMargin = 64;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
        when(mockFunc)().afterReturn(config);
        formStackExpandItemViewData.updateDelImgTranslateX();
        expect(formStackExpandItemViewData).not().assertUndefined();
        mocker.clear(FormStackExpandConfig);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('updateDelImgTranslateX_test03', 0, () => {
      config.mFormWidth = 1;
      config.mIsExpandCenter = false;
      config.mDisplayWidth = 50;
      formStackExpandItemViewData.mItemInfo = formStackExpandItem;
      formStackExpandItemViewData.mDeleteImageMoveLongestDistance = 6;
      formStackExpandItemViewData.mFormMargin = 62;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
        when(mockFunc)().afterReturn(config);
        formStackExpandItemViewData.updateDelImgTranslateX();
        expect(formStackExpandItemViewData).not().assertUndefined();
        mocker.clear(FormStackExpandConfig);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('updateDelImgTranslateX_test04', 0, () => {
      config.mFormWidth = 1;
      config.mIsExpandCenter = true;
      config.mDisplayWidth = 50;
      formStackExpandItemViewData.mItemInfo = formStackExpandItem;
      formStackExpandItemViewData.mDeleteImageMoveLongestDistance = 6;
      formStackExpandItemViewData.mFormMargin = 62;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(FormStackExpandConfig, FormStackExpandConfig.getInstance);
        when(mockFunc)().afterReturn(config);
        formStackExpandItemViewData.updateDelImgTranslateX();
        expect(formStackExpandItemViewData).not().assertUndefined();
        mocker.clear(FormStackExpandConfig);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('initImgData_test01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        formStackExpandItem.imgData = undefined;
        formStackExpandItemViewData.mItemInfo = formStackExpandItem;
        formStackExpandItemViewData.mEventInterface = mEventInterface;
        let mockFunc =
          mocker.mockFunc((formStackExpandItem as object), (formStackExpandItem as object)['getFormStackExpandModel']);
        let mockFunc1 = mocker.mockFunc(expandModel, expandModel.getCardInfo);
        let mockFunc2 = mocker.mockFunc(FormStackUtil, FormStackUtil.getFormComponentId);
        let mockFunc3 = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(cardInfo);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn('a');
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
        (formStackExpandItemViewData as object)['initImgData']();
        expect(formStackExpandItemViewData).not().assertUndefined();
        mocker.clear((formStackExpandItem as object));
        mocker.clear(expandModel);
        mocker.clear(FormStackUtil);
        mocker.clear(CheckEmptyUtils);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('initImgData_test02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        formStackExpandItem.imgData = undefined;
        formStackExpandItemViewData.mItemInfo = formStackExpandItem;
        formStackExpandItemViewData.mEventInterface = mEventInterface;
        let mockFunc =
          mocker.mockFunc((formStackExpandItem as object), (formStackExpandItem as object)['getFormStackExpandModel']);
        let mockFunc1 = mocker.mockFunc(expandModel, expandModel.getCardInfo);
        let mockFunc2 = mocker.mockFunc(FormStackUtil, FormStackUtil.getFormComponentId);
        let mockFunc3 = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(expandModel);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(cardInfo);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn('a');
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
        (formStackExpandItemViewData as object)['initImgData']();
        expect(formStackExpandItemViewData).not().assertUndefined();
        mocker.clear((formStackExpandItem as object));
        mocker.clear(expandModel);
        mocker.clear(FormStackUtil);
        mocker.clear(CheckEmptyUtils);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('initImgData_test03', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        formStackExpandItem.imgData = undefined;
        formStackExpandItemViewData.mItemInfo = formStackExpandItem;
        formStackExpandItemViewData.mEventInterface = mEventInterface;
        let mockFunc =
          mocker.mockFunc((formStackExpandItem as object), (formStackExpandItem as object)['getFormStackExpandModel']);
        let mockFunc1 = mocker.mockFunc(expandModel, expandModel.getCardInfo);
        let mockFunc2 = mocker.mockFunc(FormStackUtil, FormStackUtil.getFormComponentId);
        let mockFunc3 = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(expandModel);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(cardInfo);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn('a');
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
        (formStackExpandItemViewData as object)['initImgData']();
        expect(formStackExpandItemViewData).not().assertUndefined();
        mocker.clear((formStackExpandItem as object));
        mocker.clear(expandModel);
        mocker.clear(FormStackUtil);
        mocker.clear(CheckEmptyUtils);
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('initData_test01', 0, () => {
      (formStackExpandItemViewData as object)['initData']();
      expect(formStackExpandItemViewData).not().assertUndefined();
    });
  });
}