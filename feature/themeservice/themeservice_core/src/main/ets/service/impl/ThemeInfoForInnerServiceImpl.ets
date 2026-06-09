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
import { ThemeInfo, ThemeInfoApi } from '@ohos/themeservice_inner_api/Index';
import { NullableType, TsLog } from '@ohos/themeservicebase/Index';
import { themeInfoService } from './ThemeInfoServiceImpl';

const TAG: string = `ThemeSubInfoService`;

export class ThemeInfoForInnerServiceImpl implements ThemeInfoApi {
  async getCurrentInnerTheme(): Promise<NullableType<ThemeInfo>> {
    let themeInfo: ThemeInfo = await themeInfoService.get().getCurrentTheme();
    if (!themeInfo) {
      TsLog.warning(TAG, `not find current theme`);
    }
    return themeInfo;
  }

  async getCurrentInnerThemeInfoList(type: number): Promise<NullableType<ThemeInfo[]>> {
    let themeInfoList: NullableType<ThemeInfo[]> = await themeInfoService.get().getThemeList(type);
    if (!themeInfoList) {
      TsLog.warning(TAG, `not find current theme list`);
    }
    return themeInfoList;
  }
}