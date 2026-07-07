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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
} from '@ohos/hypium';
import { AddFormToFormStackCommand } from '../../../../../../../main/ets/default/command/imp/AddFormToFormStackCommand';
import { AbilityFormUtil } from '../../../../../../../main/ets/default/utils/AbilityFormUtil';

export default function AddFormToFormStackCommandTest() {
  describe('AddFormToFormStackCommandTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('AddFormToFormStackCommandTest_canExecute_01', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let cardId: string = '123';
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getCardBelongFormStack);
      when(func1)(cardId).afterReturn(false);

      let commandObj: AddFormToFormStackCommand = new AddFormToFormStackCommand('123');
      let results: boolean = (commandObj as object)['canExecute'](cardId);
      expect(results).assertFalse();
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });

    it('AddFormToFormStackCommandTest_canExecute_02', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let cardId: string = '123';
      const func1: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getCardBelongFormStack);
      when(func1)(cardId).afterReturn(true);

      let commandObj: AddFormToFormStackCommand = new AddFormToFormStackCommand('123');
      let results: boolean = (commandObj as object)['canExecute'](cardId);
      expect(results).assertTrue();
      mocker.clear(AbilityFormUtil);
      mocker.clearAll();
    });
  });
}