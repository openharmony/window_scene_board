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
  TestType,
  Level,
  describe
} from '@ohos/hypium';
import {
  OverflowFunInteractionFormStatusController
} from '../../../../../../../../main/ets/default/common/components/liveform/controller/status/OverflowFunInteractionFormStatusController';
import {
  FormBackboardVm,
  FormItemRelativeVm,
  FormMaskVm,
} from '../../../../../../../../main/ets/default/common/components/form/viewmodel/FormItemRelativeVm';
import {
  OverflowFunInteractionFormEvent
} from '../../../../../../../../main/ets/default/common/components/liveform/event/OverflowFunInteractionFormEvent';
import {
  OverflowFormVm
} from '../../../../../../../../main/ets/default/common/components/liveform/viewmodel/OverflowFormVm';

function createOverflowFormItemEvent(): OverflowFunInteractionFormEvent{
  let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
  let formBackVm: FormBackboardVm = new FormBackboardVm();
  let formMaskVm: FormMaskVm = new FormMaskVm();
  return (new OverflowFunInteractionFormEvent(formItemVm, formBackVm, formMaskVm));
}

export function OverflowFunInteractionFormStatusControllerTest() {
  describe('OverflowFunInteractionFormStatusControllerTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_clearOverflowFormActiveTimer', TestType.FUNCTION | Level.LEVEL0, () => {
      let controller: OverflowFunInteractionFormStatusController = new OverflowFunInteractionFormStatusController('1', 5);
      controller.clearOverflowFormActiveTimer();
    })

    it('test_updateAndClearOverflowFormActiveTimer', TestType.FUNCTION | Level.LEVEL0, () => {
      let controller: OverflowFunInteractionFormStatusController = new OverflowFunInteractionFormStatusController('1', 5);
      let formItemEvent: OverflowFunInteractionFormEvent = createOverflowFormItemEvent();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      controller.updateOverflowFormActiveTimer(formItemEvent,overflowFormVm);
    })
  })
}

