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

import type image from '@ohos.multimedia.image';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
} from '@ohos/hypium';
import type { CardItemInfo } from '@ohos/launchercommon';
import type { DragItemPosition } from '@ohos/componentdrag';
import { FormStackManager } from '../../../../../main/ets/common/FormStackManager';

export function FormStackManagerTest() {
  describe('FormStackManagerTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('setFormStackId', 0, () => {
      let formStackId: string = '1234567';
      let formStackManager: FormStackManager = new FormStackManager();
      formStackManager.setFormStackId('');
      expect(formStackManager.getFormStackId()).assertEqual('');
      formStackManager.setFormStackId(formStackId);
      expect(formStackManager.getFormStackId()).assertEqual(formStackId);
    });

    it('getFormStackId', 0, () => {
      let formStackId: string = '1234567';
      let formStackManager: FormStackManager = new FormStackManager();
      formStackManager.setFormStackId(formStackId);
      expect(formStackManager.getFormStackId()).assertEqual(formStackId);
    });

    it('setClickTopFormId', 0, () => {
      let formId: string = '1234567';
      let formStackManager: FormStackManager = new FormStackManager();
      formStackManager.setClickTopFormId(formId);
      expect(formStackManager.getTopFormId()).assertEqual(formId);
    });

    it('getTopFormId', 0, () => {
      let formId: string = '1234567';
      let formStackManager: FormStackManager = new FormStackManager();
      formStackManager.setClickTopFormId(formId);
      expect(formStackManager.getTopFormId()).assertEqual(formId);
    });

    it('setBreakFormStackExpandAnimation', 0, () => {
      let formStackManager: FormStackManager = new FormStackManager();
      formStackManager.setBreakFormStackExpandAnimation(() => {});
      expect(formStackManager.getBreakFormStackExpandAnimation() === undefined).assertFalse;
    });

    it('getBreakFormStackExpandAnimation', 0, () => {
      let formStackManager: FormStackManager = new FormStackManager();
      formStackManager.setBreakFormStackExpandAnimation();
      expect(formStackManager.getBreakFormStackExpandAnimation()).assertUndefined();
    });

    it('clearFormStackId', 0, () => {
      let formStackId: string = '123456';
      let formStackManager: FormStackManager = new FormStackManager();
      formStackManager.setFormStackId(formStackId);
      expect(formStackManager.getFormStackId()).assertEqual(formStackId);
      formStackManager.clearFormStackId();
      expect(formStackManager.getFormStackId()).assertEqual('');
    });

    it('clearTopFormId', 0, () => {
      let topId: string = '123456';
      let formStackManager: FormStackManager = new FormStackManager();
      formStackManager.setClickTopFormId(topId);
      expect(formStackManager.getTopFormId()).assertEqual(topId);
      formStackManager.clearTopFormId();
      expect(formStackManager.getTopFormId()).assertEqual('');
    });

    it('saveDragOriginPosition', 0, () => {
      let cardInfo: CardItemInfo = {
        page: 1,
        column: 2,
        row: 3,
      } as CardItemInfo;

      let manager: FormStackManager = FormStackManager.getInstance();
      manager.saveDragOriginPosition(cardInfo)
      let position: DragItemPosition = manager.getDragOriginPosition() as DragItemPosition;
      expect(position?.page).assertEqual(1)
      expect(position?.column).assertEqual(2)
      expect(position?.row).assertEqual(3)
    });

    it('resetDragOriginPosition', 0, () => {
      let cardInfo: CardItemInfo = {
        page: 1,
        column: 2,
        row: 3,
      } as CardItemInfo;

      let manager: FormStackManager = FormStackManager.getInstance();
      manager.saveDragOriginPosition(cardInfo);
      expect(manager.getDragOriginPosition() !== undefined).assertTrue();
      manager.resetDragOriginPosition();
      expect(manager.getDragOriginPosition() !== undefined).assertFalse();
    });


    it('deleteFormStackCards', 0, () => {
      let manager: FormStackManager = FormStackManager.getInstance();
      const formStackId: string = '123456';
      expect(manager.getFormStackSubCards(formStackId) !== undefined).assertTrue();
      manager.deleteFormStackCards(formStackId);
      expect(manager.getFormStackSubCards(formStackId) !== undefined).assertTrue();
    });

    it('deleteFormStackIdInAnimate', 0, () => {
      let manager: FormStackManager = FormStackManager.getInstance();
      const formStackId: string = '123456';
      manager.cacheFormStackIdInAnimate(formStackId);
      expect(manager.isFormStackInAnimate(formStackId)).assertTrue();
      manager.deleteFormStackIdInAnimate(formStackId);
      expect(manager.isFormStackInAnimate(formStackId)).assertFalse();
    });


    it('setStackName', 0, () => {
      let manager: FormStackManager = FormStackManager.getInstance();
      manager.setStackName('123');
      let stackName: string = manager.getStackName();
      expect(stackName).assertEqual('123');
    });

    it('setFormStackPosition', 0, () => {
      let manager: FormStackManager = FormStackManager.getInstance();
      manager.setFormStackPosition([]);
      expect(manager.getFormStackPosition().length).assertEqual(0);
    });
  });
}