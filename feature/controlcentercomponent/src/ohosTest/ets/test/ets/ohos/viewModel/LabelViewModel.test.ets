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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ToggleBaseComponentStyle } from '@ohos/systemuicommon';
import { FontViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/LabelViewData';
import { LabelViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/LabelViewModel';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';

const DEFAULT = 0;

export function LabelViewModelTest() {
  describe('LabelViewModelTest', (): void => {
    beforeAll((): void => {})
    beforeEach((): void => {})
    afterAll((): void => {})
    afterEach((): void => {})

    it('defaultFontSizeTest', DEFAULT, () => {
      let toggleState: ToggleViewData = new ToggleViewData();
      let style: ToggleBaseComponentStyle = new ToggleBaseComponentStyle();
      style.buttonDiameter = ResUtils.getConvertNumber($r('app.float.Control_center_button_diameter'));
      let viewData: FontViewData = new FontViewData();
      let viewModel: LabelViewModel = new LabelViewModel(viewData, toggleState, style);
      viewModel.resetFontSize();
      expect(viewData.lineHeight > 0).assertFalse();
    })

    it('smallFontSizeTest', DEFAULT, () => {
      let toggleState: ToggleViewData = new ToggleViewData();
      let style: ToggleBaseComponentStyle = new ToggleBaseComponentStyle();
      style.buttonDiameter = ResUtils.getConvertNumber($r('app.float.Control_center_button_diameter'));
      let viewData: FontViewData = new FontViewData();
      let viewModel: LabelViewModel = new LabelViewModel(viewData, toggleState, style);
      viewModel.resetFontSize();
      expect(viewData.lineHeight > 0).assertFalse();
    })
  })
}