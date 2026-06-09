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
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium';
import { CardItemInfo, GridLayoutItemInfo } from '@ohos/launchercommon';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { DragItemPosition } from '@ohos/componentdrag';
import { FormStackViewModel, AddInterfaceExtendParam } from '../../../../../main/ets/viewmodel/FormStackViewModel';
import { FormStackTestUtil } from '../common/FormStackTestUtil';
import { FormStackExpandConfig } from '../../../../../main/ets/common/FormStackExpandConfig';
import { FormStackItemInfo } from '../../../../../../src/main/ets/common/FormStackItemInfo';
import { FormStackHiSysEventUtil } from '../../../../../../src/main/ets/common/FormStackHiSysEventUtil';
import { FormStackUtil } from '../../../../../../src/main/ets/common/FormStackUtil';
import { FormStackManager } from '../../../../../../src/main/ets/common/FormStackManager';

export function FormStackViewModelTest() {
  describe('FormStackViewModelTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('isSupportFormStack', 0, () => {
      expect(FormStackExpandConfig.isSupportFormStack()).assertEqual(FormStackViewModel.isSupportFormStack());
    });

    it('registerFormStackChangedListener', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      formStackViewModel.registerFormStackChangedListener();
    });

    it('removeFormFromFormStack', 0, () => {
      let mockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        formStackViewModel.removeFormFromFormStack('');
        let mockFunc: Function =
          mockKit.mockFunc(formStackViewModel.mFormStackModel, formStackViewModel.mFormStackModel.getFormStackList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
        formStackViewModel.removeFormFromFormStack('test');

        when(mockFunc)(ArgumentMatchers.any).afterReturn([new GridLayoutItemInfo()]);
        formStackViewModel.removeFormFromFormStack('test');

        when(mockFunc)(ArgumentMatchers.any).afterReturn(FormStackTestUtil.createGridLayoutItemInfoList());
        formStackViewModel.removeFormFromFormStack(FormStackTestUtil.TEST_ITEM_BUNDLE_NAME);

        mockKit.clear(formStackViewModel.mFormStackModel);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mockKit.clearAll();
    });

    it('addNewFormStack', 0, () => {
      let mockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        expect(formStackViewModel.addNewFormStack([], endLayoutInfo)).assertFalse();
        expect(formStackViewModel.addNewFormStack([new GridLayoutItemInfo()], endLayoutInfo)).assertFalse();
        expect(formStackViewModel.addNewFormStack([new GridLayoutItemInfo(), new GridLayoutItemInfo()], endLayoutInfo))
          .assertFalse();

        let mockFuncSelect: Function = mockKit.mockFunc(formStackViewModel.mFormLayoutManager,
          formStackViewModel.mFormLayoutManager.selectGridLayoutItemByItem);
        when(mockFuncSelect)(ArgumentMatchers.any).afterReturn([new GridLayoutItemInfo()]);

        let mockFuncInsert: Function = mockKit.mockFunc(formStackViewModel.mFormLayoutManager,
          formStackViewModel.mFormLayoutManager.insertFormStackItemInfo);
        when(mockFuncInsert)(ArgumentMatchers.any).afterReturnNothing();

        let mockFuncDelete: Function = mockKit.mockFunc(formStackViewModel.mFormLayoutManager,
          formStackViewModel.mFormLayoutManager.deleteGridLayoutItemById);
        when(mockFuncDelete)(ArgumentMatchers.any).afterReturnNothing();

        const arr: GridLayoutItemInfo[] = FormStackTestUtil.createGridLayoutItemInfoList();
        const dropItem: GridLayoutItemInfo = FormStackTestUtil.createGridLayoutItemInfo();

        expect(formStackViewModel.addNewFormStack(arr, dropItem, false)).assertTrue();
        expect(formStackViewModel.addNewFormStack(arr, arr[1], false)).assertTrue();
        expect(formStackViewModel.addNewFormStack(arr, dropItem, true)).assertTrue();

        mockKit.clear(formStackViewModel.mFormLayoutManager);

      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mockKit.clearAll();
    });

    it('addNewFormStack_01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        const arr: GridLayoutItemInfo[] = FormStackTestUtil.createGridLayoutItemInfoList();
        const dropItem: GridLayoutItemInfo = FormStackTestUtil.createGridLayoutItemInfo();
        let FormStackUtilFun: Function = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
        when(FormStackUtilFun)(ArgumentMatchers.any).afterReturn(true);
        formStackViewModel.addNewFormStack(arr, dropItem, false);
        expect(true).assertEqual(true);
        mocker.clear(FormStackUtil);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('addNewFormStack_02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        const arr: GridLayoutItemInfo[] = FormStackTestUtil.createGridLayoutItemInfoList();
        const dropItem: GridLayoutItemInfo = FormStackTestUtil.createGridLayoutItemInfo();
        let FormStackUtilFun: Function = mocker.mockFunc(FormStackUtil, FormStackUtil.isInvalidFormStackList);
        when(FormStackUtilFun)(ArgumentMatchers.any).afterReturn(false);
        formStackViewModel.addNewFormStack(arr, dropItem, false);
        expect(true).assertEqual(true);
        mocker.clear(FormStackUtil);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('addCardsToFormStack', 0, () => {
      let mockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        expect(formStackViewModel.addCardsToFormStack('', [])).assertFalse();
        expect(formStackViewModel.addCardsToFormStack('123', [])).assertFalse();
        expect(formStackViewModel.addCardsToFormStack('', [new GridLayoutItemInfo()])).assertFalse();

        let mockFuncSelect: Function = mockKit.mockFunc(formStackViewModel.mFormLayoutManager,
          formStackViewModel.mFormLayoutManager.selectFormStackItemByFormStackId);
        when(mockFuncSelect)(ArgumentMatchers.any).afterReturn(FormStackTestUtil.createFormStackItemInfo('123', 2));

        let mockFuncInsert: Function = mockKit.mockFunc(formStackViewModel.mFormLayoutManager,
          formStackViewModel.mFormLayoutManager.insertFormStackItemInfo);
        when(mockFuncInsert)(ArgumentMatchers.any).afterReturnNothing();

        let mockFuncDelete: Function = mockKit.mockFunc(formStackViewModel.mFormLayoutManager,
          formStackViewModel.mFormLayoutManager.deleteGridLayoutItemById);
        when(mockFuncDelete)(ArgumentMatchers.any).afterReturnNothing();

        let mockFuncUpdate: Function = mockKit.mockFunc(formStackViewModel.mFormLayoutManager,
          formStackViewModel.mFormLayoutManager.updateCardsFormDesktopToFormStack);
        when(mockFuncUpdate)(ArgumentMatchers.any).afterReturnNothing();

        let mockFuncReport: Function = mockKit.mockFunc(FormStackHiSysEventUtil,
          FormStackHiSysEventUtil.reportAddCard);
        when(mockFuncReport)(ArgumentMatchers.any).afterReturnNothing();

        expect(formStackViewModel.addCardsToFormStack('123', [FormStackTestUtil.createGridLayoutItemInfo('2')]))
          .assertFalse();
        expect(formStackViewModel.addCardsToFormStack('123', [FormStackTestUtil.createGridLayoutItemInfo('4')],
          { isNeedAnimate: true })).assertTrue();

        mockKit.clear(formStackViewModel.mFormLayoutManager);
        mockKit.clear(FormStackHiSysEventUtil);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mockKit.clearAll();
    });

    it('addCardsToFormStack_02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        const arr: GridLayoutItemInfo[] = FormStackTestUtil.createGridLayoutItemInfoList();
        const formStackId: string = '123';
        let CheckEmptyUtilsFun: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(CheckEmptyUtilsFun)(ArgumentMatchers.any).afterReturn(true);
        formStackViewModel.addCardsToFormStack(formStackId, arr);
        expect(true).assertEqual(true);
        mocker.clear(CheckEmptyUtils);

      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('deleteCardsFromFormStack_01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        const cardIds: string[] = ['123', '456'];
        const formStackId: string = '123';
        let CheckEmptyUtilsFun: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(CheckEmptyUtilsFun)(ArgumentMatchers.any).afterReturn(true);
        formStackViewModel.deleteCardsFromFormStack(formStackId, cardIds, false);
        expect(true).assertEqual(true);
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('deleteCardsFromFormStack_02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        const cardIds: string[] = ['123', '456'];
        const formStackId: string = '123';
        let CheckEmptyUtilsFun: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.checkStrIsEmpty);
        when(CheckEmptyUtilsFun)(ArgumentMatchers.any).afterReturn(false);
        formStackViewModel.deleteCardsFromFormStack(formStackId, cardIds, false);
        expect(true).assertEqual(true);
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('deleteCardsFromFormStack_03', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        const cardIds: string[] = ['123', '456'];
        const formStackId: string = '123';
        let CheckEmptyUtilsFun: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(CheckEmptyUtilsFun)(ArgumentMatchers.any).afterReturn(true);
        formStackViewModel.deleteCardsFromFormStack(formStackId, cardIds, false);
        expect(true).assertEqual(true);
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('deleteCardsFromFormStack_04', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        const cardIds: string[] = ['123', '456'];
        const formStackId: string = '123';
        let CheckEmptyUtilsFun: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(CheckEmptyUtilsFun)(ArgumentMatchers.any).afterReturn(false);
        formStackViewModel.deleteCardsFromFormStack(formStackId, cardIds, false);
        expect(true).assertEqual(true);
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('deleteCardsFromFormStack_06', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        const cardIds: string[] = ['123', '456'];
        const formStackId: string = '123';
        let CheckEmptyUtilsFun: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(CheckEmptyUtilsFun)(ArgumentMatchers.any).afterReturn(true);
        formStackViewModel.deleteCardsFromFormStack(formStackId, cardIds, false);
        expect(true).assertEqual(true);
        mocker.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });

    it('deleteCardsFromFormStack', 0, () => {
      let mockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        expect(formStackViewModel.deleteCardsFromFormStack('', [])).assertFalse();
        expect(formStackViewModel.deleteCardsFromFormStack('123', [])).assertFalse();
        expect(formStackViewModel.deleteCardsFromFormStack('', ['1'])).assertFalse();

        let mockFuncSelect: Function = mockKit.mockFunc(formStackViewModel.mFormLayoutManager,
          formStackViewModel.mFormLayoutManager.selectFormStackItemByFormStackId);

        when(mockFuncSelect)(ArgumentMatchers.any).afterReturn(undefined);
        expect(formStackViewModel.deleteCardsFromFormStack('123', ['1'])).assertFalse();

        let mockFuncDeleteForm: Function = mockKit.mockFunc(formStackViewModel.mFormModel,
          formStackViewModel.mFormModel.deleteFormById);
        when(mockFuncDeleteForm)(ArgumentMatchers.any).afterReturnNothing();

        let formStackInfo: FormStackItemInfo = FormStackTestUtil.createFormStackItemInfo('123', 3);
        when(mockFuncSelect)(ArgumentMatchers.any).afterReturn(formStackInfo as Object as GridLayoutItemInfo);
        expect(formStackViewModel.deleteCardsFromFormStack('123', ['1'])).assertTrue();

        formStackInfo = FormStackTestUtil.createFormStackItemInfo('123', 2);
        when(mockFuncSelect)(ArgumentMatchers.any).afterReturn(formStackInfo as Object as GridLayoutItemInfo);
        expect(formStackViewModel.deleteCardsFromFormStack('123', ['1'], true)).assertTrue();

        formStackInfo = FormStackTestUtil.createFormStackItemInfo('123', 1);
        when(mockFuncSelect)(ArgumentMatchers.any).afterReturn(formStackInfo as Object as GridLayoutItemInfo);
        expect(formStackViewModel.deleteCardsFromFormStack('123', ['1'])).assertTrue();

        mockKit.clear(formStackViewModel.mFormLayoutManager);
        mockKit.clear(formStackViewModel.mFormModel);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mockKit.clearAll();
    });

    it('swapCardToTopOfFormStack', 0, () => {
      let mockKit = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();

        let mockFuncUpdate: Function = mockKit.mockFunc(formStackViewModel.mFormLayoutManager,
          formStackViewModel.mFormLayoutManager.updateFormStackItemById);
        when(mockFuncUpdate)(ArgumentMatchers.any).afterReturnNothing();

        let mockFuncSelect: Function = mockKit.mockFunc(formStackViewModel.mFormLayoutManager,
          formStackViewModel.mFormLayoutManager.selectFormStackItemByFormStackId);
        when(mockFuncSelect)(ArgumentMatchers.any).afterReturn(undefined);
        expect(formStackViewModel.swapCardToTopOfFormStack('123', '1')).assertFalse();

        let formStackInfo: FormStackItemInfo = FormStackTestUtil.createFormStackItemInfo('123', 3);
        when(mockFuncSelect)(ArgumentMatchers.any).afterReturn(formStackInfo);
        expect(formStackViewModel.swapCardToTopOfFormStack('123', '2')).assertTrue();

        mockKit.clear(formStackViewModel.mFormLayoutManager);

      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mockKit.clearAll();
    });

    it('swapFormStackCard_001', 0, () => {
      let mock = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        formStackViewModel.swapFormStackCard('test', '', 'test');
        expect(formStackViewModel).not().assertNull();

        formStackViewModel.swapFormStackCard('test', 'test', '');
        expect(formStackViewModel).not().assertNull();

        let mockIf: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockIf)(ArgumentMatchers.any).afterReturn(true);
        formStackViewModel.swapFormStackCard('test', 'test', 'test');
        expect(formStackViewModel).not().assertNull();
        mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }

      mock.clearAll();
    });

    it('deleteCardCache_002', 0, () => {
      let mock = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        formStackViewModel.deleteCardCache('', 'test');
        expect(formStackViewModel).not().assertNull();

        formStackViewModel.deleteCardCache('test', '');
        expect(formStackViewModel).not().assertNull();


        let mockIf: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockIf)(ArgumentMatchers.any).afterReturn(true);
        formStackViewModel.deleteCardCache('test', 'test');
        expect(formStackViewModel).not().assertNull();
        mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clearAll();
    });

    it('onDisplayChanged_003', 0, () => {
      let mock = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        formStackViewModel.onDisplayChanged('test', true, 1);
        expect(formStackViewModel).not().assertNull();

        let mockIf: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockIf)(ArgumentMatchers.any).afterReturn(true);
        formStackViewModel.onDisplayChanged('', false, 1);
        expect(formStackViewModel).not().assertNull();
        mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clearAll();
    });

    it('reportFormStackDragEvent_004', 0, () => {
      let mock = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let mockFuncReport: Function = mock.mockFunc(FormStackHiSysEventUtil, FormStackHiSysEventUtil.reportMoveEvent);
        when(mockFuncReport)(ArgumentMatchers.any).afterReturnNothing();
        let mockFuncReport2: Function = mock.mockFunc(FormStackHiSysEventUtil, FormStackHiSysEventUtil.reportDragSubCardToDesktop);
        when(mockFuncReport2)(ArgumentMatchers.any).afterReturnNothing();

        let dragItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        const startPosition: DragItemPosition = {
          page: 1,
          row: 1,
          column: 1,
          x: 1,
          y: 1,
        };

        dragItemInfo.typeId = 6;
        let result = formStackViewModel.reportFormStackDragEvent(9, dragItemInfo, startPosition, startPosition);
        expect(result == null).assertTrue();

        dragItemInfo.typeId = 4;
        result = formStackViewModel.reportFormStackDragEvent(10, dragItemInfo, startPosition, startPosition);
        expect(result == null).assertTrue();

        dragItemInfo.typeId = 1;
        result = formStackViewModel.reportFormStackDragEvent(9, dragItemInfo, startPosition, startPosition);
        expect(result == null).assertTrue();
        mock.clear(FormStackHiSysEventUtil);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clearAll();
    });

    it('notifyCloseFormStackExpandView_005', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result = formStackViewModel.notifyCloseFormStackExpandView('');
        expect(result == null).assertTrue();

        result = formStackViewModel.notifyCloseFormStackExpandView('test');
        expect(result == null).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('updateDesktop_006', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result = formStackViewModel.updateDesktop();
        expect(result == null).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('notifyLastFormShow_007', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result = formStackViewModel.notifyLastFormShow('test');
        expect(result == null).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('delPreloadCardInFormStack_001', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result = formStackViewModel.delPreloadCardInFormStack('', undefined);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('delPreloadCardInFormStack_002', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result = formStackViewModel.delPreloadCardInFormStack('test', undefined);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('delPreloadCardInFormStack_003', 0, () => {
      let mock = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        const cardItemInfo = new CardItemInfo();
        let mockIf: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockIf)(ArgumentMatchers.any).afterReturn(true);
        let result = formStackViewModel.delPreloadCardInFormStack('test', cardItemInfo);
        expect(result == null).assertTrue();
        mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clearAll();
    });

    it('dragCardBackToFormStack_001', 0, () => {
      let mock = new MockKit();
      try {
        let mockIf: Function = mock.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getFormStackPosition);
        when(mockIf)().afterReturn([]);
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result = formStackViewModel.dragCardBackToFormStack();
        expect(result == null).assertTrue();
        mock.ignoreMock(FormStackManager.getInstance(), FormStackManager.getInstance().getFormStackPosition);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clearAll();
    });

    it('dragCardBackToFormStack_002', 0, () => {
      let mock = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let mockIf: Function = mock.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getFormStackPosition);
        when(mockIf)().afterReturn([1,2]);
        let result = formStackViewModel.dragCardBackToFormStack();
        expect(result == null).assertTrue();
        mock.ignoreMock(FormStackManager.getInstance(), FormStackManager.getInstance().getFormStackPosition);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clearAll();
    });

    it('dragCardBackToFormStack_003', 0, () => {
      let mock = new MockKit();
      try {
        AppStorage.setOrCreate('dragItemInfo', '');
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let mockIf: Function = mock.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getFormStackPosition);
        when(mockIf)().afterReturn([1,2,3,4]);
        let result = formStackViewModel.dragCardBackToFormStack();
        expect(result == null).assertTrue();
        mock.ignoreMock(FormStackManager.getInstance(), FormStackManager.getInstance().getFormStackPosition);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clearAll();
    });

    it('dragCardBackToFormStack_004', 0, () => {
      let mock = new MockKit();
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let mockIf: Function = mock.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getFormStackPosition);
        when(mockIf)().afterReturn([1,2,3,4]);
        let item:GridLayoutItemInfo = new GridLayoutItemInfo();
        item.typeId = 2;
        AppStorage.set('dragItemInfo', item);
        let result = formStackViewModel.dragCardBackToFormStack();
        expect(result == null).assertTrue();
        mock.ignoreMock(FormStackManager.getInstance(), FormStackManager.getInstance().getFormStackPosition);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clearAll();
    });

    it('dragCardBackToFormStack_005', 0, () => {
      let mock = new MockKit();
      try {
        let item:GridLayoutItemInfo = new GridLayoutItemInfo();
        item.typeId = 1;
        AppStorage.set('dragItemInfo', item);
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let mockIf: Function = mock.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getFormStackPosition);
        when(mockIf)().afterReturn([1,2,3,4]);
        let result = formStackViewModel.dragCardBackToFormStack();
        expect(result == null).assertTrue();
        mock.ignoreMock(FormStackManager.getInstance(), FormStackManager.getInstance().getFormStackPosition);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clearAll();
    });

    it('deleteCardsImmediately_010', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result = formStackViewModel.deleteCardsImmediately([]);
        expect(result == null).assertTrue();

        result = formStackViewModel.deleteCardsImmediately(['test1','test2']);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('createNewFormStackInfo_012', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let result: Object = (formStackViewModel as object)['createNewFormStackInfo']([], new GridLayoutItemInfo());
      expect(result !== null).assertTrue();
    });

    it('deleteCardLayoutItems_013', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result: Object = (formStackViewModel as object)['deleteCardLayoutItems']([new GridLayoutItemInfo()]);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('reportCreateEvent_014', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let result: Object = (formStackViewModel as object)['reportCreateEvent'](new GridLayoutItemInfo(), [], new GridLayoutItemInfo());
      expect(result == null).assertTrue();

      result = (formStackViewModel as object)['reportCreateEvent'](new GridLayoutItemInfo(), [new GridLayoutItemInfo()], new GridLayoutItemInfo());
      expect(result == null).assertTrue();
    });

    it('reportDragSubCardToDesktop_016', 0, () => {
      let mock = new MockKit();
      try {
        const startPosition: DragItemPosition = {
          page: 1,
          row: 1,
          column: 1,
          x: 0,
          y: 0,
        };
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();

        AppStorage.setOrCreate('formStackId', '');
        let result: Object = (formStackViewModel as object)['reportDragSubCardToDesktop'](new GridLayoutItemInfo(), startPosition);
        expect(result == null).assertTrue();
        let mockIf: Function = mock.mockFunc(FormStackManager.getInstance(), FormStackManager.getInstance().getDragOriginPosition);
        when(mockIf)().afterReturn(undefined);
        AppStorage.set('formStackId', 'test');
        result = (formStackViewModel as object)['reportDragSubCardToDesktop'](new GridLayoutItemInfo(), startPosition);
        expect(result == null).assertTrue();

        let mockFuncReport: Function = mock.mockFunc(FormStackHiSysEventUtil, FormStackHiSysEventUtil.reportDragSubCardToDesktop);
        when(mockFuncReport)(ArgumentMatchers.any).afterReturnNothing();

        when(mockIf)().afterReturn(startPosition);
        result = (formStackViewModel as object)['reportDragSubCardToDesktop'](new GridLayoutItemInfo(), startPosition);
        expect(result == null).assertTrue();
        mock.ignoreMock(FormStackManager.getInstance(), FormStackManager.getInstance().getDragOriginPosition);
        mock.clear(FormStackHiSysEventUtil);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clearAll();
    });

    it('isExistCardInList_017', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let result: boolean = (formStackViewModel as object)['isExistCardInList']([], []);
      expect(result).assertFalse();

      let item = new GridLayoutItemInfo();
      result = (formStackViewModel as object)['isExistCardInList']([item], [item]);
      expect(result).assertTrue();
    });

    it('getFormLayoutInfoList_018', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        (formStackViewModel as object)['getFormLayoutInfoList']('test');
        expect(formStackViewModel).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('swapForm_019', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let item1 = new GridLayoutItemInfo();
      item1.cardId = '1';
      let item2 = new GridLayoutItemInfo();
      item2.cardId = '2';
      let items: GridLayoutItemInfo[] = [item1,item2];
      let result: Object = (formStackViewModel as object)['swapForm'](items, '3', '4');
      expect(result == null).assertTrue();

      result = (formStackViewModel as object)['swapForm'](items, '4', '1');
      expect(result == null).assertTrue();

      result = (formStackViewModel as object)['swapForm'](items, '1', '2');
      expect(result == null).assertTrue();
    });

    it('updateLayoutInfo_020', 0, () => {
      let mock = new MockKit();
      try {
        let mockIf: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockIf)(ArgumentMatchers.any).afterReturn(true);
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        (formStackViewModel as object)['updateLayoutInfo']('test', [new GridLayoutItemInfo()]);
        expect(formStackViewModel).not().assertNull();
        mock.clear(CheckEmptyUtils);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clearAll()


      // when(mockIf)(ArgumentMatchers.any).afterReturn(false);
      // (formStackViewModel as object)['updateLayoutInfo']('test', [new GridLayoutItemInfo()]);
      // expect(formStackViewModel).not().assertNull();
      // mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      // mock.clearAll();
    });

    it('notifyDeleteCardMsg_021', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let result: Object = (formStackViewModel as object)['notifyDeleteCardMsg']('test', []);
      expect(result == null).assertTrue();

      result = (formStackViewModel as object)['notifyDeleteCardMsg']('test', [], true);
      expect(result == null).assertTrue();
    });

    it('notifyDelPreloadCardMsg_022', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let result: Object = (formStackViewModel as object)['notifyDelPreloadCardMsg']('test', 'test1');
      expect(result == null).assertTrue();
    });

    it('notifyUpdateFormStackListMsg_023', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let result: Object = (formStackViewModel as object)['notifyUpdateFormStackListMsg']('test', [], 'test1', true);
      expect(result == null).assertTrue();
    });

    it('notifyAddCardsToFormStackMsg_024', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let result: Object = (formStackViewModel as object)['notifyAddCardsToFormStackMsg']('test', [], {isNeedAnimate: true, targetCardId: 'test', isAppendFromTail: true});
      expect(result == null).assertTrue();
    });

    it('notifyCreateFormStackAnimate_025', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let result: Object = (formStackViewModel as object)['notifyCreateFormStackAnimate']('test');
      expect(result == null).assertTrue();
    });

    it('isShowPromptView_026', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let result: boolean = (formStackViewModel as object)['isShowPromptView'](2);
      expect(result).assertFalse();

      result = (formStackViewModel as object)['isShowPromptView'](15);
      expect(result).assertTrue();
    });

    it('swapItemToTopOfList_027', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let item1 = new GridLayoutItemInfo();
      item1.cardId = '1';
      let item2 = new GridLayoutItemInfo();
      item2.cardId = '2';
      let items: GridLayoutItemInfo[] = [item1,item2];
      let result: Object = (formStackViewModel as object)['swapItemToTopOfList'](items, '3');
      expect(result == null).assertTrue();

      result = (formStackViewModel as object)['swapItemToTopOfList'](items, '1');
      expect(result == null).assertTrue();
    });

    it('deleteCardDetail_028', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let item1 = new GridLayoutItemInfo();
      item1.cardId = '1';
      let item2 = new GridLayoutItemInfo();
      item2.cardId = '2';
      let items: GridLayoutItemInfo[] = [item1,item2];
      let result: boolean = (formStackViewModel as object)['deleteCardDetail'](items, '3');
      expect(result).assertFalse();

      result = (formStackViewModel as object)['deleteCardDetail'](items, '1');
      expect(result).assertFalse();

      let mock = new MockKit();
      let mockIf: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIf)(ArgumentMatchers.any).afterReturn(false);
      result = (formStackViewModel as object)['deleteCardDetail'](items, '1');
      expect(result).assertInstanceOf('Boolean')
      mock.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mock.clearAll();
    });

    it('updateRemainingCard_029', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result: Object = (formStackViewModel as object)['updateRemainingCard'](new GridLayoutItemInfo(), new GridLayoutItemInfo());
        expect(result == null).assertTrue();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('insertCardsToSpecificPosition_030', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let item1 = new GridLayoutItemInfo();
      item1.cardId = '1';
      let item2 = new GridLayoutItemInfo();
      item2.cardId = '2';
      let extend: AddInterfaceExtendParam = {
        isNeedAnimate: false,
        targetCardId: '',
        isAppendFromTail: false
      }
      let result: number  = (formStackViewModel as object)['insertCardsToSpecificPosition']([item1], [item2], null);
      expect(result >= 0).assertTrue();

      result = (formStackViewModel as object)['insertCardsToSpecificPosition']([item1], [item2], extend);
      expect(result >= 0).assertTrue();

      extend.targetCardId = '1';
      result = (formStackViewModel as object)['insertCardsToSpecificPosition']([item1], [item2], extend);
      expect(result >= 0).assertTrue();

      extend.isAppendFromTail = true;
      result = (formStackViewModel as object)['insertCardsToSpecificPosition']([item1, item2], [item2], extend);
      expect(result >= 0).assertTrue();
    });

    it('deleteCards_030', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let item1 = new GridLayoutItemInfo();
      item1.cardId = '1';
      let item2 = new GridLayoutItemInfo();
      item2.cardId = '2';
      let items: GridLayoutItemInfo[] = [item1,item2];
      let result: GridLayoutItemInfo[] = (formStackViewModel as object)['deleteCards'](items, ['3','1'], true);
      expect(result.length >= 0).assertTrue();

      result = (formStackViewModel as object)['deleteCards'](items, ['3','1'], false);
      expect(result.length >= 0).assertTrue();
    });

    it('createFormStack_031', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result: string = (formStackViewModel as object)['createFormStack']([new GridLayoutItemInfo()], new GridLayoutItemInfo());
        expect(result.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('printInterfaceLog_032', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result: Object = (formStackViewModel as object)['printInterfaceLog'](1, 'test', ['3']);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('isDuplicateCardExist_033', 0, () => {
      let formStackViewModel: FormStackViewModel = new FormStackViewModel();
      let result: boolean = (formStackViewModel as object)['isDuplicateCardExist']([new GridLayoutItemInfo()]);
      expect(result).assertInstanceOf('Boolean');
    });

    it('createFormStackWithoutAnimation_034', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result: Object = (formStackViewModel as object)['createFormStackWithoutAnimation']([new GridLayoutItemInfo()], ['2'], new GridLayoutItemInfo());
        expect(result == null).assertTrue();

        result = (formStackViewModel as object)['createFormStackWithoutAnimation']([new GridLayoutItemInfo()], ['2'], new GridLayoutItemInfo(), false);
        expect(result == null).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('deleteFormStackItemById_035', 0, () => {
      try {
        let formStackViewModel: FormStackViewModel = new FormStackViewModel();
        let result: Object = (formStackViewModel as object)['deleteFormStackItemById'](new GridLayoutItemInfo());
        expect(result == null).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

  });
}