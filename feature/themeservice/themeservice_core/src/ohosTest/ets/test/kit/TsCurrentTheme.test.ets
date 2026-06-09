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

import { describe, expect, it } from '@ohos/hypium';
import { FileUtil, TsLog } from '@ohos/themeservicebase';
import { createCurrentThemeApi } from '@ohos/themeservicekit/src/main/ets/service/impl/TSCurrentThemeApiImpl';
import { IconsInfo } from '@ohos/themeservicekit/src/main/ets/service/model/IconsInfo';
import { ActivatedThemeUtil } from '../../../../main/ets/util/ActivatedThemeUtil';

const TAG: string = `TsCurrentThemeTest`;

export default function TsCurrentThemeTest() {
  describe('TsCurrentThemeTest', () => {
    it('test001_get_icons_info_success', 0, async () => {
      let iconsInfo: Nullable<IconsInfo> = await createCurrentThemeApi().getIconsInfo();
      expect(iconsInfo).not().assertUndefined();
      expect(iconsInfo).not().assertNull();
      const iconsPath: string = `${ActivatedThemeUtil.getActivatedThemePath()}/app/icons`;
      let manifestContent: string = await FileUtil.readFileContent(`${iconsPath}/manifest.json`);
      let curIconsInfo: IconsInfo = {
        id: '', origin: '',
      };
      if (manifestContent !== '') {
        try {
          let manifestObj: object = JSON.parse(manifestContent);
          curIconsInfo.id = manifestObj['id'] ?? '';
          curIconsInfo.origin = manifestObj['origin'] ?? '';
        } catch (err) {
          TsLog.error(TAG, `manifestContent catch exception. code:${err.code}, message:${err.message}`);
        }
      }
      if (curIconsInfo.id === '' || curIconsInfo.origin === '') {
        let descriptionContent: string = await FileUtil.readFileContent(`${iconsPath}/description.json`);
        try {
          let descriptionObj: object = JSON.parse(descriptionContent);
          curIconsInfo.id = curIconsInfo.id !== '' ? curIconsInfo.id : descriptionObj['id'] ?? '';
          curIconsInfo.origin = curIconsInfo.origin !== '' ? curIconsInfo.origin : descriptionObj['origin'] ?? '';
        } catch (err) {
          TsLog.error(TAG, ` descriptionObj catch exception. code:${err.code}, message:${err.message}`);
        }
      }
      expect(iconsInfo?.id).assertEqual(curIconsInfo.id);
      expect(iconsInfo?.origin).assertEqual(curIconsInfo.origin);
    });
  });
}