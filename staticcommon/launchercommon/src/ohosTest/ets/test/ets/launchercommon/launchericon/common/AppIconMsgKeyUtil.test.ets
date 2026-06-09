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

import { StartType } from '@ohos/basicutils';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
} from '@ohos/hypium';
import { AppData } from '@ohos/windowscene';
import { appIconMsgKeyUtil } from '../../../../../../../main/ets/launchericon/common/AppIconMsgKeyUtil';
import { AppItemInfo, CommonConstants } from '../../../../../../../main/ets/TsIndex';

export function AppIconMsgKeyUtilTest() {
  describe('AppIconMsgKeyUtilTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getIconContainerOpacityKey', 0, () => {
      let ret: string = appIconMsgKeyUtil.getIconContainerOpacityKey(null, null);
      expect(ret).assertEqual('Opacity_AppIconRelative');

      let appItem: AppItemInfo = new AppItemInfo();
      appItem.keyName = 'keyName';
      ret = appIconMsgKeyUtil.getIconContainerOpacityKey(appItem, null);
      expect(ret).assertEqual(`Opacity_AppIconRelative_keyName`);

      let appData: AppData = new AppData();
      appData.startAppType = StartType.RECENT_DOCK_APP;
      ret = appIconMsgKeyUtil.getIconContainerOpacityKey(appItem, appData);
      expect(ret).assertEqual(`Opacity_AppIconRelative_keyName`);

      appData.extraId = 'extraId';
      ret = appIconMsgKeyUtil.getIconContainerOpacityKey(appItem, appData);
      expect(ret).assertEqual(`Opacity_AppIconRelative_keyNameextraId`);
    });

    it('getIconAnimBackToIconKey', 0, () => {
      let ret: string = appIconMsgKeyUtil.getIconAnimBackToIconKey(null, null);
      expect(ret).assertEqual(CommonConstants.EVENTHUB_ANIMATE_BACK_TO_ICON);

      let appItem: AppItemInfo = new AppItemInfo();
      appItem.keyName = 'keyName';
      ret = appIconMsgKeyUtil.getIconAnimBackToIconKey(appItem, null);
      expect(ret).assertEqual(`${CommonConstants.EVENTHUB_ANIMATE_BACK_TO_ICON}keyName`);

      let appData: AppData = new AppData();
      appData.startAppType = StartType.RECENT_DOCK_APP;
      ret = appIconMsgKeyUtil.getIconAnimBackToIconKey(appItem, appData);
      expect(ret).assertEqual(`${CommonConstants.EVENTHUB_ANIMATE_BACK_TO_ICON}keyName`);

      appData.extraId = 'extraId';
      ret = appIconMsgKeyUtil.getIconAnimBackToIconKey(appItem, appData);
      expect(ret).assertEqual(`${CommonConstants.EVENTHUB_ANIMATE_BACK_TO_ICON}keyNameextraId`);
    });

    it('getItemAccessibilityClickKey', 0, () => {
      let ret: string = appIconMsgKeyUtil.getItemAccessibilityClickKey(null);
      expect(ret).assertEqual('appItemAccessibilityClick');

      let appItem: AppItemInfo = new AppItemInfo();
      appItem.keyName = 'keyName';
      ret = appIconMsgKeyUtil.getItemAccessibilityClickKey(appItem);
      expect(ret).assertEqual('appItemAccessibilityClickkeyName');
    });
  });
}