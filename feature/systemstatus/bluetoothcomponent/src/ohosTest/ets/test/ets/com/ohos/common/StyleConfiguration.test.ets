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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, DEFAULT} from '@ohos/hypium';
import StyleConfiguration from '../../../../../../../main/ets/com/ohos/common/StyleConfiguration';
import { StatusBarBluetoothComponentStyle } from '../../../../../../../main/ets/com/ohos/common/StyleConfiguration';

export function BluetoothStyleTest() {
  describe('BluetoothStyleTest', (): void => {
    beforeAll(() => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    it('BluetoothStyle_getStatusBarBluetoothComponentStyleTest01', DEFAULT, (): void => {
      const style: StatusBarBluetoothComponentStyle = StyleConfiguration.getStatusBarBluetoothComponentStyle();
      expect(style instanceof StatusBarBluetoothComponentStyle).assertTrue();
    })
    it('BluetoothStyle_initStatusBarBluetoothComponentStyleTest01', DEFAULT, (): void => {
      const style: StatusBarBluetoothComponentStyle = new StatusBarBluetoothComponentStyle();
      expect(style instanceof StatusBarBluetoothComponentStyle).assertTrue();
    })
  })
}
