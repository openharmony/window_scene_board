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
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when,
} from '@ohos/hypium';
import { IconPicType, IconResourceManager } from '@ohos/frameworkwrapper';
import IconInfo from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
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

    it('AbilityFormUtilTest_isCardIdInvalid_invalid_item_app_not_exist', 0, async (done: Function): Promise<void> => {
      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      const displayCardInfo = new LauncherDisplayCardInfo();
      const launchRecItem = new LauncherRecItem();
      launchRecItem.itemType = AiSuggestionConstants.TYPE_APP;
      launchRecItem.bundleName = 'com.ohos.testapp';
      displayCardInfo.recItems = [launchRecItem];
      cardInfo.portrait = displayCardInfo;

      let resultInfo: IconInfo = new IconInfo();
      resultInfo.iconType = IconPicType.NONE;
      let mocker: MockKit = new MockKit();
      const mockFunc =
        mocker.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().getIconResource);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(resultInfo));

      expect(await ServiceValidator.isCardInfoValid(cardInfo)).assertFalse();

      mocker.clear(IconResourceManager.getInstance());
      mocker.clearAll();
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

    it('AbilityFormUtilTest_isCardIdInvalid_cardInfo_valid_subItem', 0, async (done: Function): Promise<void> => {
      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      const displayCardInfo = new LauncherDisplayCardInfo();
      const launchRecItem = new LauncherRecItem();
      launchRecItem.itemType = AiSuggestionConstants.TYPE_APP_GROUP;
      const launchSubRecItem1 = new LauncherRecItem();
      launchSubRecItem1.bundleName = 'com.ohos.suggestion';
      launchSubRecItem1.moduleName = 'entry';
      launchSubRecItem1.abilityName = 'ParentFormAbility';
      launchSubRecItem1.itemType = AiSuggestionConstants.TYPE_APP;

      const launchSubRecItem2 = new LauncherRecItem();
      launchSubRecItem2.itemType = AiSuggestionConstants.TYPE_APP;
      launchSubRecItem2.bundleName = 'com.ohos.suggestion';
      launchSubRecItem2.moduleName = 'entry';
      launchSubRecItem2.abilityName = 'ParentFormAbility';

      launchRecItem.subLauncherRecItems = [launchSubRecItem1, launchSubRecItem2];

      displayCardInfo.recItems = [launchRecItem];
      cardInfo.portrait = displayCardInfo;

      let resultInfo: IconInfo = new IconInfo();
      resultInfo.iconType = IconPicType.NORMAL;
      let mocker: MockKit = new MockKit();
      const mockFunc =
        mocker.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().getIconResource);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(resultInfo));

      expect(await ServiceValidator.isCardInfoValid(cardInfo)).assertTrue();

      mocker.clear(IconResourceManager.getInstance());
      mocker.clearAll();
      done();
    });

    it('AbilityFormUtilTest_isCardIdInvalid_cardInfo_valid_app', 0, async (done: Function): Promise<void> => {
      const cardInfo: LauncherCardInfo = new LauncherCardInfo();
      const displayCardInfo = new LauncherDisplayCardInfo();
      const launchRecItem1 = new LauncherRecItem();
      launchRecItem1.itemType = AiSuggestionConstants.TYPE_APP;
      launchRecItem1.bundleName = 'com.ohos.suggestion';
      launchRecItem1.moduleName = 'entry';
      launchRecItem1.abilityName = 'ParentFormAbility';

      const launchRecItem2 = new LauncherRecItem();
      launchRecItem2.itemType = AiSuggestionConstants.TYPE_APP;
      launchRecItem2.bundleName = 'com.ohos.suggestion';
      launchRecItem2.moduleName = 'entry';
      launchRecItem2.abilityName = 'ParentFormAbility';

      displayCardInfo.recItems = [launchRecItem1, launchRecItem2];
      cardInfo.portrait = displayCardInfo;

      let resultInfo: IconInfo = new IconInfo();
      resultInfo.iconType = IconPicType.NORMAL;
      let mocker: MockKit = new MockKit();
      const mockFunc =
        mocker.mockFunc(IconResourceManager.getInstance(), IconResourceManager.getInstance().getIconResource);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(resultInfo));

      expect(await ServiceValidator.isCardInfoValid(cardInfo)).assertTrue();
      mocker.clear(IconResourceManager.getInstance());
      mocker.clearAll();
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