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
} from '@ohos/hypium';
import { CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { DragItemPosition } from '@ohos/componentdrag';
import { FormStackDataAdapt, FormStackMsg } from '../../../../../main/ets/common/FormStackDataAdapt';
import { FormStackItemInfo } from '../../../../../main/ets/common/FormStackItemInfo';

export function FormStackDataAdaptTest() {
  describe('FormStackDataAdaptTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('registerMsg', 0, () => {
      let instance: FormStackDataAdapt = FormStackDataAdapt.getInstance();
      let formStackItemInfo: FormStackItemInfo | undefined;
      let ret: boolean = instance.registerMsg<FormStackItemInfo>(
        FormStackMsg.SET_FORM_STACK_ITEM_INFO, undefined);
      expect(ret).assertFalse();
      ret = instance.registerMsg<FormStackItemInfo>(
        FormStackMsg.SET_FORM_STACK_ITEM_INFO, (itemInfo: FormStackItemInfo) => {
        formStackItemInfo = itemInfo;
      });
      expect(ret).assertTrue();

      let formStackItemInfoTemp: FormStackItemInfo = {
        column: 1,
        row: 2,
        page: 3,
      } as FormStackItemInfo;

      instance.handleMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO, formStackItemInfoTemp);
      expect(formStackItemInfo?.column === formStackItemInfoTemp.column).assertTrue();
      expect(formStackItemInfo?.row === formStackItemInfoTemp.row).assertTrue();
      expect(formStackItemInfo?.page === formStackItemInfoTemp.page).assertTrue();
    });

    it('unregisterMsg', 0, () => {
      let instance: FormStackDataAdapt = FormStackDataAdapt.getInstance();
      let formStackItemInfo: FormStackItemInfo | undefined;
      let ret: boolean = instance.registerMsg<FormStackItemInfo>(
        FormStackMsg.SET_FORM_STACK_ITEM_INFO, (itemInfo: FormStackItemInfo) => {
        formStackItemInfo = itemInfo;
      });
      expect(ret).assertTrue();

      let formStackItemInfoTemp: FormStackItemInfo = {} as FormStackItemInfo;
      instance.handleMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO, formStackItemInfoTemp);
      expect(formStackItemInfo !== undefined).assertTrue();
      formStackItemInfo = undefined;
      instance.unregisterMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO);
      instance.handleMsg(FormStackMsg.SET_FORM_STACK_ITEM_INFO, formStackItemInfo);
      expect(formStackItemInfo !== undefined).assertFalse();
    });

    it('setDragItemInfo', 0, () => {
      let instance: FormStackDataAdapt = FormStackDataAdapt.getInstance();
      let formStackItemInfo: FormStackItemInfo | undefined;
      let ret: boolean = instance.registerMsg<FormStackItemInfo>(
        FormStackMsg.SET_FORM_STACK_ITEM_INFO, (itemInfo: FormStackItemInfo) => {
        formStackItemInfo = itemInfo;
      });
      expect(ret).assertTrue();

      let card: CardItemInfo = {
        id: '123',
        cardId: '123',
        row: 1,
        column: 1,
      } as CardItemInfo;
      instance.setDragItemInfo('123456', card);
      expect(AppStorage.get('isDrag') as boolean).assertTrue();
      let startPos: DragItemPosition = AppStorage.get('startPosition') as DragItemPosition;
      expect(startPos.row).assertEqual(0);
    });
  });
}