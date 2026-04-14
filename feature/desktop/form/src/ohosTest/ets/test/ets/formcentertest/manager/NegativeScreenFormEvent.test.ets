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
import { LazyDataSource } from '@ohos/launchercommon/Index';
import { AppItemInfo, CardItemInfo } from '@ohos/launchercommon';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  Level,
  TestType
} from '@ohos/hypium';
import {
  NegativeScreenFormEvent
} from '../../../../../../main/ets/formcenter/viewmodel/event/FormCenterViewEvent/NegativeScreenFormEvent';
import { ViewData } from '../../../../../../main/ets/default/viewmodel/FormCenterObservedData';
import { BindSheetStateData } from '../../../../../../main/ets/formcenter/viewmodel/data/BindSheetStateData';
import { FormCenterViewModel } from '../../../../../../main/ets/formcenter/viewmodel/FormCenterViewModel';
import {
  NegativeScreenStackViewEvent
} from '../../../../../../main/ets/formcenter/viewmodel/event/FormCenterStackEvent/NegativeScreenStackViewEvent';


export function NegativeScreenFormEventTest() {
  describe('NegativeScreenFormEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('filterNegativeScreenCards', TestType.FUNCTION | Level.LEVEL0, () => {
      let appList: LazyDataSource<AppItemInfo> = new LazyDataSource<AppItemInfo>();
      let mRecommendedCardList: CardItemInfo[] = [];
      let mViewStateChangeCallback = undefined;
      let mViewData: ViewData = new ViewData();
      let bindSheetStateData: BindSheetStateData = new BindSheetStateData();
      let negativeScreenFormEvent: NegativeScreenFormEvent =
        new NegativeScreenFormEvent(appList, mRecommendedCardList, bindSheetStateData, mViewData,
          mViewStateChangeCallback);
      let blackBundleNameList: string[] = ['com.ohos.thememanager'];
      FormCenterViewModel.getInstance().setNegativeBundleNameBlackList(blackBundleNameList);
      let filterRes: boolean = negativeScreenFormEvent.filterNegativeScreenCards();
      expect(filterRes).assertTrue();
    });

    it("NegativeScreenStackViewEvent_filterNegativeScreenCards", TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let blackBundleNameList: string[] = ['com.ohos.thememanager'];
        FormCenterViewModel.getInstance().setNegativeBundleNameBlackList(blackBundleNameList);
        let negativeScreenStackViewEvent: NegativeScreenStackViewEvent = new NegativeScreenStackViewEvent(true, []);
        let filterRes: boolean = negativeScreenStackViewEvent.filterNegativeScreenCards();
        expect(filterRes).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  })
}