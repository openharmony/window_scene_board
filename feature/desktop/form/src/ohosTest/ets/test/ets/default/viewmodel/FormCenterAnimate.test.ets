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
	MockKit,
	when,
	TestType,
	Level,
	ArgumentMatchers
} from '@ohos/hypium';
import { CardItemInfo, CommonConstants } from '@ohos/launchercommon';
import { AppFormsAnimate, RecommendFormsAnimate } from '../../../../../../main/ets/default/viewmodel/FormCenterAnimate';
import {
	AppFormItemData,
	NavDestinationViewData,
	RecommendFormItemData } from '../../../../../../main/ets/default/viewmodel/FormCenterObservedData';
import { AppFormsViewData } from '../../../../../../main/ets/default/viewmodel/FormCenterViewData';

export function FormCenterAnimateTest() {
	describe('FormCenterAnimateTest', () => {
		beforeAll(() => {
		});

		beforeEach(() => {
		});

		afterAll(() => {
		});

		afterEach(() => {
		});

		it('RecommendFormsAnimate_test', TestType.FUNCTION | Level.LEVEL0, () => {
			let testModel: RecommendFormsAnimate = new RecommendFormsAnimate();
			let formList: CardItemInfo[] = [];
			let animateData: RecommendFormItemData[] = [];
			let formInfo: CardItemInfo = new CardItemInfo();
			formInfo.cardDimension = CommonConstants.CARD_DIMENSION_1x2;
			formList.push(formInfo);
			testModel.initData(formList, animateData);
			expect(animateData.length).assertEqual(1);
			expect(animateData[0].animateScale).assertEqual(1);
			testModel.scaleAnimate(true, 1, 0);
			expect(animateData[0].animateScale <= 1).assertTrue();
			formInfo.cardDimension = CommonConstants.CARD_DIMENSION_2x4;
			testModel.scaleAnimate(true, 1, 0);
			expect(animateData[0].animateScale <= 1).assertTrue();
			formInfo.cardDimension = CommonConstants.CARD_DIMENSION_4x4;
			testModel.scaleAnimate(true, 1, 0);
			expect(animateData[0].animateScale <= 1).assertTrue();

			testModel.scaleAnimate(false, 1, 0);
			expect(animateData[0].animateScale).assertEqual(1);
		});

		it('scaleAnimate_0', TestType.FUNCTION | Level.LEVEL0, () => {
			try {
				let testModel: AppFormsAnimate = new AppFormsAnimate();
				let viewData: AppFormsViewData = new AppFormsViewData();
				let size: Size = { width: 10, height: 10 };
				viewData.appFormList = [];
				testModel.initData(viewData, new NavDestinationViewData(),
					[new AppFormItemData(), new AppFormItemData()], (cardDimension: number) => size);
				testModel.scaleAnimate(true, 0);
				let formItem: CardItemInfo = new CardItemInfo();
				formItem.cardId = '123';
				formItem.bundleName = 'testBundle';
				formItem.cardDimension = FormDimension.Dimension_2_2;
				viewData.appFormList = [formItem];
				viewData.appFormList.push(formItem);
				testModel.initData(viewData, new NavDestinationViewData(),
					[new AppFormItemData(), new AppFormItemData()], (cardDimension: number) => size);
				testModel.scaleAnimate(true, -1);
				testModel.scaleAnimate(true, 3);
				testModel.scaleAnimate(true, 0);
				expect(viewData.appFormList.length).assertEqual(2);
			}  catch (e) {
				expect(JSON.stringify(e)).assertInstanceOf('String');
			}
		});

		it('calculateOffSet_0', TestType.FUNCTION | Level.LEVEL0, () => {
			try {
				let testModel: AppFormsAnimate = new AppFormsAnimate();
				let viewData: AppFormsViewData = new AppFormsViewData();
				let formItem: CardItemInfo = new CardItemInfo();
				let size: Size = { width: 10, height: 10 };
				formItem.cardId = '123';
				formItem.bundleName = 'testBundle';
				formItem.cardDimension = FormDimension.Dimension_2_2;
				viewData.appFormList = [formItem];
				testModel.initData(viewData, new NavDestinationViewData(),
					[new AppFormItemData(), new AppFormItemData()], (cardDimension: number) => size);
				testModel.calculateOffSet(-2, 1);
				testModel.calculateOffSet(1, 1);
				testModel.calculateOffSet(1, 0);
				testModel.calculateOffSet(0, 1);
				testModel.calculateOffSet(-1, 1);
				expect(viewData.appFormList.length).assertEqual(1);
			}  catch (e) {
				expect(JSON.stringify(e)).assertInstanceOf('String');
			}
		});

		it('updateFormOffset_0', TestType.FUNCTION | Level.LEVEL0, () => {
			try {
				let testModel: AppFormsAnimate = new AppFormsAnimate();
				let viewData: AppFormsViewData = new AppFormsViewData();
				let formItem: CardItemInfo = new CardItemInfo();
				let size: Size = { width: 10, height: 10 };
				formItem.cardId = '123';
				formItem.bundleName = 'testBundle';
				formItem.cardDimension = FormDimension.Dimension_2_2;
				viewData.appFormList = [formItem];
				testModel.initData(viewData, new NavDestinationViewData(),
					[new AppFormItemData(), new AppFormItemData()], (cardDimension: number) => size);
				testModel.updateFormOffset(-2, 1);
				testModel.updateFormOffset(0, 1);
				let navViewData: NavDestinationViewData = new NavDestinationViewData();
				navViewData.viewWidth = 100;
				viewData.appFormList.push(formItem);
				testModel.initData(viewData, navViewData,
					[new AppFormItemData(), new AppFormItemData()], (cardDimension: number) => size);
				testModel.updateFormOffset(1, -1);
				testModel.updateFormOffset(0, -1);
				testModel.updateFormOffset(0, 1);
				testModel.updateFormOffset(1, 1);
				expect(viewData.appFormList.length).assertEqual(2);
			}  catch (e) {
				expect(JSON.stringify(e)).assertInstanceOf('String');
			}
		});
	})
}