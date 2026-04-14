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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import {
  CommonToggleController
} from '../../../../../main/ets/com/ohos/controller/CommonToggleController';

export function CommonToggleControllerTest() {
  describe('CommonToggleControllerTest', (): void => {

    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('CommonToggleControllerTest001', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest002', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest003', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest004', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest005', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest006', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
    })

    it('CommonToggleControllerTest007', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest008', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest009', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest015', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest016', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest017', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest018', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest010', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleUpdateState = commonToggleController.handleUpdateState();
      expect(HandleUpdateState !== null).assertEqual(true);
    })

    it('CommonToggleControllerTest011', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest012', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let Available = commonToggleController.isAvailable();
      expect(Available).assertEqual(true);
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
    })

    it('CommonToggleControllerTest013', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest014', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let data = commonToggleController.getData();
      expect(data !== null).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })

    it('CommonToggleControllerTest019', 0, (): void => {
      let commonToggleController = new CommonToggleController('');
      let HandleLongClick = commonToggleController.handleLongClick();
      expect(HandleLongClick).assertEqual(true);
      let HandleClick = commonToggleController.handleClick();
      expect(HandleClick).assertEqual(true);
    })
  })
}