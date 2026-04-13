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
  expect,
  Level,
  TestType,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { SCBScreenSessionManager } from '@ohos/basiccommon/src/main/ets/TsIndex';
import { FormHostService, VisibleChangeListener } from '../../../../../../main/ets/default/service/FormHostService';
import { DefaultDesktopLayoutInfo, FormLayoutCacheManager,
  GridLayoutItemInfo, CommonConstants,
  LaunchLayoutCacheManager } from '@ohos/launchercommon/src/main/ets/TsIndex';

export function FormHostServiceTest() {
  describe('FormHostServiceTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getFormListByPageIndex_onlyCard', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.cardId = '123';
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.page = 0;
      layout.push(formItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);
      let formHostService: FormHostService = FormHostService.getInstance();
      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(1);
      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('getFormListByPageIndex', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 0;
      layout.push(formItem);
      let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem.page = 0;
      let formItemInFormStack: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack.cardId = '234';
      formItemInFormStack.page = 0;
      formStackItem.layoutInfo = [[formItemInFormStack]];
      layout.push(formStackItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);
      let formHostService: FormHostService = FormHostService.getInstance();
      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(2);
      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('getFormListByPageIndex_foldOpen', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 1;
      layout.push(formItem);
      let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem.page = 1;
      let formItemInFormStack: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack.cardId = '234';
      formItemInFormStack.page = 1;
      formStackItem.layoutInfo = [[formItemInFormStack]];
      layout.push(formStackItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      const mockFunc2: Function = mocker.mockFunc(sessionManager, sessionManager.isFoldablePhoneExpandStatus);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

      let formHostService: FormHostService = FormHostService.getInstance();
      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(2);
      mocker.clear(formLayoutManager);
      mocker.clear(sessionManager);
      mocker.clearAll();
    });

    it('recoverFormsOfNeighborPage', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 1;
      layout.push(formItem);
      let formStackItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem.page = 1;
      let formItemInFormStack: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack.cardId = '234';
      formItemInFormStack.page = 1;
      let formItemInFormStack1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack1.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack1.cardId = '345';
      formItemInFormStack1.page = 1;

      formStackItem.layoutInfo = [[formItemInFormStack, formItemInFormStack1]];
      layout.push(formStackItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      let layoutManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      const mockFunc2: Function = mocker.mockFunc(layoutManager, layoutManager.selectPageCount);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(3);

      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['insertListToCurrentRecycleList'](['123', '234', '345']);
      formHostService.recoverFormsOfNeighborPage(0);

      expect(formHostService['startHandlerTimer']).assertEqual(-1);
      mocker.clear(formLayoutManager);
      mocker.clear(layoutManager);
      mocker.clearAll();
    });

    it('recoverFormsOfNeighborPage_1', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 0;
      layout.push(formItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      let layoutManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      const mockFunc2: Function = mocker.mockFunc(layoutManager, layoutManager.selectPageCount);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(2);

      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['insertListToCurrentRecycleList'](['123']);
      formHostService.recoverFormsOfNeighborPage(1);

      expect(formHostService['startHandlerTimer']).assertEqual(-1);
      mocker.clear(formLayoutManager);
      mocker.clear(layoutManager);
      mocker.clearAll();
    });

    it('formRecoverWhenAppExitHandler_0', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['startHandlerTimer'] = 123;
      formHostService.formRecoverWhenAppExitHandler(0);

      expect(formHostService['startHandlerTimer']).assertEqual(-1);
    });

    it('formRecoverWhenAppExitHandler', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      formHostService['startHandlerTimer'] = -1;
      formHostService['startRecycleTimer'] = 123;

      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.cardId = '123';
      formItem.page = 0;
      layout.push(formItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      formHostService.formRecoverWhenAppExitHandler(0);
      expect(formHostService['startRecycleTimer']).assertEqual(-1);
      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('handleRecycleFormsOfInvisible', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let formList: Array<string> = new Array();
      formList.push('123');
      formList.push('234');
      formList.push('345');
      formList.push('456');
      formHostService.formHostNotifyInvisible(formList);
      let formRecycleList: Array<string> = new Array();
      formRecycleList.push('123');
      formHostService.formHostNotifyRecycle(formRecycleList);

      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem1.typeId = CommonConstants.TYPE_CARD;
      formItem1.cardId = '123';
      formItem1.page = 0;
      formItem1.container = CommonConstants.CONTAINER_DESKTOP;
      layout.push(formItem1);

      let formItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem2.typeId = CommonConstants.TYPE_CARD;
      formItem2.cardId = '345';
      formItem2.page = 0;
      formItem2.container = CommonConstants.CONTAINER_DESKTOP;
      layout.push(formItem2);

      let formStackItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem1.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem1.page = 0;
      let formItemInFormStack1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack1.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack1.cardId = '234';
      formItemInFormStack1.page = 0;
      formItemInFormStack1.container = 55;
      formStackItem1.layoutInfo = [[formItemInFormStack1]];
      layout.push(formStackItem1);

      let formStackItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem2.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem2.page = 0;
      let formItemInFormStack2: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack2.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack2.cardId = '456';
      formItemInFormStack2.page = 0;
      formItemInFormStack2.container = 65;
      formStackItem2.layoutInfo = [[formItemInFormStack2]];
      layout.push(formStackItem2);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);

      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(4);

      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('formHostNotifyVisible', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let formList: Array<string> = new Array();
      formList.push('123');
      formList.push('234');
      formList.push('345');
      formList.push('456');
      let formRecycleList: Array<string> = new Array();
      formRecycleList.push('123');
      formRecycleList.push('567');
      formHostService.formHostNotifyRecycle(formRecycleList);
      formHostService.formHostNotifyVisible(formList);

      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      const mockFunc1: Function = mocker.mockFunc(sessionManager, sessionManager.isFoldablePhoneExpandStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);

      const mockFunc2: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem1.typeId = CommonConstants.TYPE_CARD;
      formItem1.cardId = '123';
      formItem1.page = 0;
      formItem1.container = CommonConstants.CONTAINER_DESKTOP;
      layout.push(formItem1);

      let formStackItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formStackItem1.typeId = CommonConstants.TYPE_FORM_STACK;
      formStackItem1.page = 0;
      let formItemInFormStack1: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItemInFormStack1.typeId = CommonConstants.TYPE_CARD;
      formItemInFormStack1.cardId = '456';
      formItemInFormStack1.page = 0;
      formItemInFormStack1.container = 65;
      formStackItem1.layoutInfo = [[formItemInFormStack1]];
      layout.push(formStackItem1);

      when(mockFunc2)(ArgumentMatchers.any).afterReturn(layout);

      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(2);

      mocker.clear(formLayoutManager);
      mocker.clear(sessionManager);
      mocker.clearAll();
    });

    it('registerFormVisibleListener_empty', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let calledTimes: number = 0;
      let visibleListener: VisibleChangeListener = {
        onVisibleChange: (visible: boolean): void => {
          calledTimes = calledTimes + 1;
        }
      };

      formHostService.registerFormVisibleListener('123', visibleListener);
      formHostService.registerFormVisibleListener('123', visibleListener);
      formHostService.registerFormVisibleListener('234', visibleListener);
      formHostService.formHostNotifyVisible(['123','345']);
      formHostService.unRegisterFormVisibleListener('123', visibleListener);
      formHostService.unRegisterFormVisibleListener('456', visibleListener);
      expect(calledTimes).assertEqual(2);

    });

    it('registerFormVisibleListener', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let calledTimes: number = 0;
      let visibleListener: VisibleChangeListener = {
        onVisibleChange: (visible: boolean): void => {
          calledTimes = calledTimes + 1;
        }
      };

      formHostService.registerFormVisibleListener('123', visibleListener);
      formHostService.formHostNotifyVisible(['123']);
      formHostService.unRegisterFormVisibleListener('123', visibleListener);
      expect(calledTimes).assertEqual(1);
    });
  })
}