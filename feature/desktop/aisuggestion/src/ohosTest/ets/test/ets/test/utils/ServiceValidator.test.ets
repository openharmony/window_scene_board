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
  describe,
  expect,
  it,
} from '@ohos/hypium';
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { LauncherDisplayCardInfo } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherDisplayCardInfo';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { LauncherCardInfo } from '../../../../../../main/ets/default/bean/LauncherCardInfo';
import { ServiceValidator } from '../../../../../../main/ets/default/utils/ServiceValidator';

/**
 * ServiceValidator测试
 *
 * @since 2024-11-27
 */
export function ServiceValidatorTest() {
  describe('ServiceValidatorTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('AbilityFormUtilTest_isCardIdInvalid_portrait_item_list_empty', 0, async (done: Function): Promise<void> => {
      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      expect(await ServiceValidator.isCardInfoValid(cardInfo)).assertFalse();
      done();
    });

    it('AbilityFormUtilTest_isCardIdInvalid_unkown_item_type', 0, async (done: Function): Promise<void> => {
      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      const displayCardInfo = new LauncherDisplayCardInfo();
      const launchRecItem = new LauncherRecItem();
      displayCardInfo.recItems = [launchRecItem];
      cardInfo.portrait = displayCardInfo;
      expect(await ServiceValidator.isCardInfoValid(cardInfo)).assertFalse();
      done();
    });

    it('AbilityFormUtilTest_isCardIdInvalid_invalid_card_card_not_exist', 0, async (done: Function): Promise<void> => {
      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      const displayCardInfo = new LauncherDisplayCardInfo();
      const launchRecItem = new LauncherRecItem();
      launchRecItem.itemType = AiSuggestionConstants.TYPE_CARD;
      launchRecItem.bundleName = 'com.ohos.testapp';
      displayCardInfo.recItems = [launchRecItem];
      cardInfo.portrait = displayCardInfo;
      expect(await ServiceValidator.isCardInfoValid(cardInfo)).assertFalse();
      done();
    });

    it('AbilityFormUtilTest_isCardIdInvalid_invalid_card_invalid_moduleName', 0, async (done: Function): Promise<void> => {
      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      const displayCardInfo = new LauncherDisplayCardInfo();
      const launchRecItem = new LauncherRecItem();
      launchRecItem.itemType = AiSuggestionConstants.TYPE_CARD;
      launchRecItem.bundleName = 'com.ohos.suggestion';
      displayCardInfo.recItems = [launchRecItem];
      cardInfo.portrait = displayCardInfo;
      expect(await ServiceValidator.isCardInfoValid(cardInfo)).assertFalse();
      done();
    });

    it('AbilityFormUtilTest_isCardIdInvalid_invalid_item_invalid_bundleName', 0, async (done: Function): Promise<void> => {
      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      const displayCardInfo = new LauncherDisplayCardInfo();
      const launchRecItem = new LauncherRecItem();
      launchRecItem.itemType = AiSuggestionConstants.TYPE_APP;
      displayCardInfo.recItems = [launchRecItem];
      cardInfo.portrait = displayCardInfo;
      expect(await ServiceValidator.isCardInfoValid(cardInfo)).assertFalse();
      done();
    });

    it('AbilityFormUtilTest_isCardIdInvalid_invalid_subItem_unknown_sub_item', 0, async (done: Function): Promise<void> => {
      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      const displayCardInfo = new LauncherDisplayCardInfo();
      const launchRecItem = new LauncherRecItem();
      launchRecItem.itemType = AiSuggestionConstants.TYPE_APP_GROUP;
      const launchSubRecItem = new LauncherRecItem();
      launchRecItem.subLauncherRecItems = [launchSubRecItem];
      displayCardInfo.recItems = [launchRecItem];
      cardInfo.portrait = displayCardInfo;
      expect(await ServiceValidator.isCardInfoValid(cardInfo)).assertFalse();
      done();
    });

    it('AbilityFormUtilTest_isCardIdInvalid_invalid_subItem_app_not_exist', 0, async (done: Function): Promise<void> => {
      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      const displayCardInfo = new LauncherDisplayCardInfo();
      const launchRecItem = new LauncherRecItem();
      launchRecItem.itemType = AiSuggestionConstants.TYPE_APP_GROUP;
      const launchSubRecItem = new LauncherRecItem();
      launchSubRecItem.itemType = AiSuggestionConstants.TYPE_APP;
      launchRecItem.bundleName = 'com.ohos.testapp';
      launchRecItem.subLauncherRecItems = [launchSubRecItem]
      displayCardInfo.recItems = [launchRecItem];
      cardInfo.portrait = displayCardInfo;
      expect(await ServiceValidator.isCardInfoValid(cardInfo)).assertFalse();
      done();
    });

    it('AbilityFormUtilTest_isCardIdInvalid_cardInfo_valid_card', 0, async (done: Function): Promise<void> => {
      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      const displayCardInfo = new LauncherDisplayCardInfo();
      const launchRecItem1 = new LauncherRecItem();
      launchRecItem1.itemType = AiSuggestionConstants.TYPE_CARD;
      launchRecItem1.bundleName = 'com.ohos.aidispatchservice';
      launchRecItem1.moduleName = 'abilityexpress';
      launchRecItem1.abilityName = 'TemplateFormAbility';
      launchRecItem1.formName = 'TemplateDynamic';
      launchRecItem1.dimension = 2;

      displayCardInfo.recItems = [launchRecItem1];
      cardInfo.portrait = displayCardInfo;
      expect(await ServiceValidator.isCardInfoValid(cardInfo)).assertTrue();
      done();
    });
  });
}