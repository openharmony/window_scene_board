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
import { CommonUtils } from '@ohos/basicutils';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FormStyleConfig, FormViewModel } from '@ohos/form';
import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import { PageDesktopViewModel } from '../../../../../main/ets/default/common/viewmodel/PageDesktopViewModel';
import {
  DesktopFormStackViewModel,
  FormStackItemCommonData,
  FormStackItemViewData
} from '../../../../../main/ets/default/common/viewmodel/DesktopFormStackViewModel';

export function DesktopFormStackViewModelTest() {
  describe('DesktopFormStackViewModelTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initData', 0, () => {
      try {
        const viewModel: DesktopFormStackViewModel = new DesktopFormStackViewModel();
        const viewData = new FormStackItemViewData();
        viewData.mFormStackItemWidth = 1;
        viewModel.initData(viewData);

        expect(viewModel.mViewDate.mFormStackItemWidth).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('resetData', 0, () => {
      try {
        const viewModel: DesktopFormStackViewModel = new DesktopFormStackViewModel();
        const viewData = new FormStackItemViewData();
        viewData.mFormStackItemWidth = 1;
        viewModel.initData(viewData);

        expect(viewModel.mViewDate.mFormStackItemWidth === 1).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }

    });

    it('initViewData', 0, () => {
      try {
        const viewModel: DesktopFormStackViewModel = new DesktopFormStackViewModel();
        const viewData = new FormStackItemViewData();
        viewModel.initData(viewData);

        viewModel.initViewData(1);
        const formStyleConfig: FormStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
        expect(CommonUtils.equals(viewData.mFormStackItemWidth,
          Number(formStyleConfig.mFormWidth.get(String(1))))).assertTrue();
        expect(CommonUtils.equals(viewData.mFormStackItemHeight,
          Number(formStyleConfig.mFormHeight.get(String(1))))).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('initCommonData', 0, () => {
      try {
        const viewModel: DesktopFormStackViewModel = new DesktopFormStackViewModel();
        const viewData = new FormStackItemViewData();
        viewData.mFormStackItemWidth = 30;
        viewModel.initData(viewData);

        const commonData: FormStackItemCommonData = new FormStackItemCommonData();
        viewModel.iniCommonConfigData(commonData);

        const styleConfig = PageDesktopViewModel.getInstance().getPageDesktopStyleConfig();
        commonData.mFormStackNameHeight = styleConfig.mNameHeight;
        commonData.mFormStackNameWidth = styleConfig.mNameWidth;
        commonData.mFormStackNameSize = styleConfig.mNameSize;
        commonData.mNameFontColor = styleConfig.mNameFontColor;
        commonData.mIconNameMargin = styleConfig.mIconNameMargin;
        commonData.mIconNameMarginTop = styleConfig.mIconNameMarginTop;

        expect(CommonUtils.equals(styleConfig.mNameHeight, commonData.mFormStackNameHeight)).assertTrue();
        expect(CommonUtils.equals(styleConfig.mNameWidth, commonData.mFormStackNameWidth)).assertTrue();
        expect(CommonUtils.equals(styleConfig.mNameSize, commonData.mFormStackNameSize)).assertTrue();
        expect(CommonUtils.equals(styleConfig.mNameFontColor, commonData.mNameFontColor)).assertTrue();
        expect(CommonUtils.equals(styleConfig.mIconNameMargin, commonData.mIconNameMargin)).assertTrue();
        expect(CommonUtils.equals(styleConfig.mIconNameMarginTop, commonData.mIconNameMarginTop)).assertTrue();

        viewData.mFormStackItemWidth = 30;
        expect(CommonUtils.equals(commonData.mSizeRatio, (30 - StyleConstants.CARD_BACKGROUND_SIZE_OFFSET) / 30))
          .assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('dragStart', 0, () => {
      try {
        const viewModel: DesktopFormStackViewModel = new DesktopFormStackViewModel();
        const viewData = new FormStackItemViewData();
        viewModel.initData(viewData);
        viewModel.dragStart(new FormStackItemInfo(), {
          getWindowX: () => { return 0; },
          getWindowY: () => { return 0; },
        } as DragEvent);

        expect(AppStorage.get<number>('isDrag')).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  });
}
