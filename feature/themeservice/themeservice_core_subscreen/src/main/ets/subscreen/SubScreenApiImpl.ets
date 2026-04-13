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
import { SubScreenApi } from '@ohos/themeservice_inner_api';
import { SubScreenInfo } from './SubScreenInfo';
import { subThemeService } from './SubThemeServiceImpl';

const ACTIVATE_SUB_SCREEN_THEME: string = `activateSubScreenTheme`;

const GET_SUB_SCREEN_THEMES: string = `getSubScreenThemes`;

const ADD_SUB_SCREEN_THEME: string = `addSubScreenTheme`;

const DELETE_SUB_SCREEN_THEME: string = `deleteSubScreenTheme`;

const RESET_SUB_SCREEN_THEME: string = `resetSubScreenTheme`;

const TAG: string = 'SubScreenApiImpl';

export class SubScreenApiImpl implements SubScreenApi {

  init(): Promise<void> {
    TsLog.info(TAG, `init`);
    subThemeService.registerListener();
    return subThemeService.init();
  }

  async removeOnlineThemes(): Promise<void> {
    TsLog.info(TAG, 'removeOnlineThemes');
    await subThemeService.removeOnlineSubThemes();
  }

  resetSubScreenTheme(): Promise<void> {
    TsLog.info(TAG, `reset`);
    return subThemeService.reset();
  }

  registerRemoteMethod(methodSet: CalleeMethodSet): void {
    TsLog.info(TAG, `registerRemoteMethod`);
    methodSet.register(ACTIVATE_SUB_SCREEN_THEME, this.activateSubScreenTheme, { parallel: false });
    methodSet.register(GET_SUB_SCREEN_THEMES, this.getSubScreenThemes);
    methodSet.register(ADD_SUB_SCREEN_THEME, this.addSubScreenTheme);
    methodSet.register(DELETE_SUB_SCREEN_THEME, this.deleteSubScreenTheme);
    methodSet.register(RESET_SUB_SCREEN_THEME, this.resetSubScreenTheme);
  }

  activateSubScreenTheme(subScreenInfo: SubScreenInfo): Promise<boolean> {
    return subThemeService.onSubThemeActivated(subScreenInfo);
  }

  getSubScreenThemes(): Promise<SubScreenInfo[]> {
    return subThemeService.getSubThemeUsed();
  }

  async addSubScreenTheme(subScreenInfo: SubScreenInfo): Promise<SubScreenInfo[]> {
    return subThemeService.onSubThemeAdded(subScreenInfo);
  }

  async deleteSubScreenTheme(themeId: string): Promise<SubScreenInfo[]> {
    return subThemeService.onSubThemeDeleted(themeId);
  }
}