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
import { FormStackEventIdUtil } from '../../../../../../main/ets/TsIndex';

export function FormStackEventIdUtilTest() {
  describe('FormStackEventIdUtilTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterAll(() => {
    });
    afterEach(() => {
    });

    it('getCoverdFormStackEventId', 0, () => {
      expect(FormStackEventIdUtil.getCoverdFormStackEventId('1')).assertEqual('coveredFormStack1');
    });

    it('getDropStackCardEventId', 0, () => {
      expect(FormStackEventIdUtil.getDropStackCardEventId('1')).assertEqual('dropStackCard1');
    });

    it('getUpdateFormStackEventId', 0, () => {
      expect(FormStackEventIdUtil.getUpdateFormStackEventId('1')).assertEqual('updateFormStack1');
    });

    it('getOpenFormStackEventId', 0, () => {
      expect(FormStackEventIdUtil.getOpenFormStackEventId('1')).assertEqual('openFormStack1');
    });

    it('getShowFormNameEventId', 0, () => {
      expect(FormStackEventIdUtil.getShowFormNameEventId('1')).assertEqual('showFormName1');
    });

    it('getAddCardsToFormStackEventId', 0, () => {
      expect(FormStackEventIdUtil.getAddCardsToFormStackEventId('1')).assertEqual('addCardsToFormStack1');
    });

    it('getDelCardsOfFromStackEventId', 0, () => {
      expect(FormStackEventIdUtil.getDelCardsOfFromStackEventId('1')).assertEqual('delCardsOfFormStack1');
    });

    it('getCreateFormStackAnimateEventId', 0, () => {
      expect(FormStackEventIdUtil.getCreateFormStackAnimateEventId('1')).assertEqual('createFormStackAnimate1');
    });

    it('getCreateFormStackFailedEventId', 0, () => {
      expect(FormStackEventIdUtil.getCreateFormStackFailedEventId('1')).assertEqual('createFormStackFailed1');
    });
  });
}