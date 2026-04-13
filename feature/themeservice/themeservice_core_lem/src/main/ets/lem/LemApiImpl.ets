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

import { CalleeMethodSet, TsLog } from '@ohos/themeservicebase';
import { LemApi } from '@ohos/themeservice_inner_api';
import { LemSubScreenInfo } from './LemSubScreenInfo';
import { lemSubThemeService } from './LemSubThemeServiceImpl';

const LEM_ACTIVATE_SUB_SCREEN_THEME: string = `lemActivateSubScreenTheme`;

const LEM_GET_SUB_SCREEN_THEMES: string = `lemGetSubScreenThemes`;

const LEM_ADD_SUB_SCREEN_THEME: string = `lemAddSubScreenTheme`;

const LEM_DELETE_SUB_SCREEN_THEME: string = `lemDeleteSubScreenTheme`;

const TAG: string = 'LemApiImpl';

export class LemApiImpl implements LemApi {
  init(): Promise<void> {
    TsLog.info(TAG, `init`);
    return lemSubThemeService.init();
  }

  registerRemoteMethod(methodSet: CalleeMethodSet): void {
    TsLog.info(TAG, `registerRemoteMethod`);
    methodSet.register(LEM_ACTIVATE_SUB_SCREEN_THEME, this.lemActivateSubScreenTheme);
    methodSet.register(LEM_GET_SUB_SCREEN_THEMES, this.lemGetSubScreenThemes);
    methodSet.register(LEM_ADD_SUB_SCREEN_THEME, this.lemAddSubScreenTheme);
    methodSet.register(LEM_DELETE_SUB_SCREEN_THEME, this.lemDeleteSubScreenTheme);
  }

  lemActivateSubScreenTheme(subScreenInfo: LemSubScreenInfo): Promise<boolean> {
    return lemSubThemeService.onSubThemeActivated(subScreenInfo);
  }

  lemGetSubScreenThemes(): Promise<LemSubScreenInfo[]> {
    return lemSubThemeService.getSubThemeUsed();
  }

  async lemAddSubScreenTheme(subScreenInfo: LemSubScreenInfo): Promise<LemSubScreenInfo[]> {
    return lemSubThemeService.onSubThemeAdded(subScreenInfo);
  }

  async lemDeleteSubScreenTheme(themeId: string): Promise<LemSubScreenInfo[]> {
    return lemSubThemeService.onSubThemeDeleted(themeId);
  }
}