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
import { AppItemInfo, CommonConstants, AppDataWrapper } from '../../../../../../../main/ets/TsIndex';
import { StartType } from '@ohos/basicutils';

export function AppDataWrapperTest() {
  describe('AppDataWrapperTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getDefaultAppData', 0, () => {
      let iconRadius: number = 100;
      let result: AppDataWrapper = AppDataWrapper.getDefaultAppData(null, iconRadius);
      expect(result.bundleName).assertEqual('');
      expect(result.abilityName).assertEqual('');
      expect(result.appIconId).assertEqual('');
      expect(result.iconRadius).assertEqual(iconRadius);

      let itemInfo: AppItemInfo = {
        bundleName: 'validBundleName',
        abilityName: 'validAbilityName',
        appIconId: 100,
        appIndex: 0,
        shortcutId: 'validShortcutId',
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        appName: '',
      };
      let result2: AppDataWrapper = AppDataWrapper.getDefaultAppData(itemInfo, iconRadius);
      expect(result2.bundleName).assertEqual('validBundleName');
      expect(result2.abilityName).assertEqual('validAbilityName');
      expect(result2.appIconNumber).assertEqual(100);
      expect(result2.appIndex).assertEqual(0);
      expect(result2.shortcutId).assertEqual('validShortcutId');
      expect(result2.startAppType).assertEqual(StartType.SHORTCUT_APP);
      expect(result2.iconRadius).assertEqual(iconRadius);

      let itemInfo2: AppItemInfo = {
        bundleName: 'validBundleName',
        abilityName: 'validAbilityName',
        appIconId: 100,
        appIndex: 0,
        shortcutId: 'validShortcutId',
        typeId: CommonConstants.TYPE_APP,
        appName: '',
      };
      let result3: AppDataWrapper = AppDataWrapper.getDefaultAppData(itemInfo2, iconRadius);
      expect(result3.bundleName).assertEqual('validBundleName');
      expect(result3.abilityName).assertEqual('validAbilityName');
      expect(result3.appIconNumber).assertEqual(100);
      expect(result3.appIndex).assertEqual(0);
      expect(result3.shortcutId).assertEqual('validShortcutId');
      expect(result3.startAppType).assertEqual(StartType.APP);
      expect(result3.iconRadius).assertEqual(iconRadius);
    });

    it('setBundleName', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setBundleName('validBundleName');
      expect(result.bundleName).assertEqual('validBundleName');

      result = appDataWrapper.setBundleName('');
      expect(result.bundleName).assertEqual('');

      result = appDataWrapper.setBundleName(null);
      expect(result.bundleName).assertNull();

      result = appDataWrapper.setBundleName(undefined);
      expect(result.bundleName).assertUndefined();
    });

    it('setAbilityName', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setAbilityName('validAbilityName');
      expect(result.abilityName).assertEqual('validAbilityName');

      result = appDataWrapper.setAbilityName('');
      expect(result.abilityName).assertEqual('');

      result = appDataWrapper.setAbilityName(null);
      expect(result.abilityName).assertNull();

      result = appDataWrapper.setAbilityName(undefined);
      expect(result.abilityName).assertUndefined();
    });

    it('setAppIndex', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setAppIndex(100);
      expect(result.appIndex).assertEqual(100);

      result = appDataWrapper.setAppIndex(null);
      expect(result.appIndex).assertNull();

      result = appDataWrapper.setAppIndex(undefined);
      expect(result.appIndex).assertUndefined();
    });

    it('setShortcutId', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setShortcutId('validShortcutId');
      expect(result.shortcutId).assertEqual('validShortcutId');

      result = appDataWrapper.setShortcutId('');
      expect(result.shortcutId).assertEqual('');

      result = appDataWrapper.setShortcutId(null);
      expect(result.shortcutId).assertNull();

      result = appDataWrapper.setShortcutId(undefined);
      expect(result.shortcutId).assertUndefined();
    });

    it('setAppIconNumber', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setAppIconNumber(100);
      expect(result.appIconNumber).assertEqual(100);

      result = appDataWrapper.setAppIconNumber(null);
      expect(result.appIconNumber).assertNull();

      result = appDataWrapper.setAppIconNumber(undefined);
      expect(result.appIconNumber).assertUndefined();
    });

    it('setAppIconId', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setAppIconId('validAppIconId');
      expect(result.appIconId).assertEqual('validAppIconId');

      result = appDataWrapper.setAppIconId('');
      expect(result.appIconId).assertEqual('');

      result = appDataWrapper.setAppIconId(null);
      expect(result.appIconId).assertNull();

      result = appDataWrapper.setAppIconId(undefined);
      expect(result.appIconId).assertUndefined();
    });

    it('setIconRadius', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setIconRadius(100);
      expect(result.iconRadius).assertEqual(100);

      result = appDataWrapper.setIconRadius(null);
      expect(result.iconRadius).assertNull();

      result = appDataWrapper.setIconRadius(undefined);
      expect(result.iconRadius).assertUndefined();
    });

    it('setCardId', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setCardId('validCardId');
      expect(result.cardId).assertEqual('validCardId');

      result = appDataWrapper.setCardId('');
      expect(result.cardId).assertEqual('');

      result = appDataWrapper.setCardId(null);
      expect(result.cardId).assertNull();

      result = appDataWrapper.setCardId(undefined);
      expect(result.cardId).assertUndefined();
    });

    it('setStartType', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setStartType(StartType.APP);
      expect(result.startAppType).assertEqual(StartType.APP);

      result = appDataWrapper.setStartType(null);
      expect(result.startAppType).assertNull();

      result = appDataWrapper.setStartType(undefined);
      expect(result.startAppType).assertUndefined();
    });

    it('setExtraId', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setExtraId('validExtraId');
      expect(result.extraId).assertEqual('validExtraId');

      result = appDataWrapper.setExtraId('');
      expect(result.extraId).assertEqual('');

      result = appDataWrapper.setExtraId(null);
      expect(result.extraId).assertNull();

      result = appDataWrapper.setExtraId(undefined);
      expect(result.extraId).assertUndefined();
    });

    it('setIsOpenFolder', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setIsOpenFolder(true);
      expect(result.isOpenFolder).assertTrue();

      result = appDataWrapper.setIsOpenFolder(false);
      expect(result.isOpenFolder).assertFalse();

      result = appDataWrapper.setIsOpenFolder(null);
      expect(result.isOpenFolder).assertNull();

      result = appDataWrapper.setIsOpenFolder(undefined);
      expect(result.isOpenFolder).assertUndefined();
    });

    it('setIsOuterDesktop', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setIsOuterDesktop('validIsOuterDesktop');
      expect(result.isOuterDesktop).assertEqual('validIsOuterDesktop');

      result = appDataWrapper.setIsOuterDesktop('');
      expect(result.isOuterDesktop).assertEqual('');

      result = appDataWrapper.setIsOuterDesktop(null);
      expect(result.isOuterDesktop).assertNull();

      result = appDataWrapper.setIsOuterDesktop(undefined);
      expect(result.isOuterDesktop).assertUndefined();
    });

    it('setScreenId', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setScreenId(100);
      expect(result.screenId).assertEqual(100);

      result = appDataWrapper.setScreenId(null);
      expect(result.screenId).assertNull();

      result = appDataWrapper.setScreenId(undefined);
      expect(result.screenId).assertUndefined();
    });

    it('setPersistentId', 0, () => {
      let appDataWrapper: AppDataWrapper = new AppDataWrapper();

      let result = appDataWrapper.setPersistentId('validPersistentId');
      expect(result.persistentId).assertEqual('validPersistentId');

      result = appDataWrapper.setPersistentId('');
      expect(result.persistentId).assertEqual('');

      result = appDataWrapper.setPersistentId(null);
      expect(result.persistentId).assertNull();

      result = appDataWrapper.setPersistentId(undefined);
      expect(result.persistentId).assertUndefined();
    });
  });
}