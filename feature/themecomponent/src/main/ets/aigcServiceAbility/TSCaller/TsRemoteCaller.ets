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

import { common } from '@kit.AbilityKit';
import { AigcConstant } from '../AigcConstant';
import { RemoteCaller } from './RemoteCaller';
import { NullableType, ThemeInfoNew, ThemeOptions } from './ThemeOptions';
import { EditThemeArg } from './EditThemeArg';
import { SubScreenInfo } from '../IdlService/model/SubScreenInfo';
import { Log } from '../IdlService/Log';

const TAG: string = '[AigcService]TsRemoteCaller';

export class TsRemoteCaller {

  private static instance?: TsRemoteCaller;

  private readonly remoteCaller: RemoteCaller;

  private constructor(context: common.UIAbilityContext | common.ServiceExtensionContext) {
    this.remoteCaller = new RemoteCaller(context, {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'ThemeServiceAbility',
    });
  }

  public static getInstance(context: common.UIAbilityContext | common.ServiceExtensionContext): TsRemoteCaller {
    if (TsRemoteCaller.instance === undefined) {
      TsRemoteCaller.instance = new TsRemoteCaller(context);
    }
    return TsRemoteCaller.instance;
  }

  public activateThemeCustom(
    themeDir: string, customThemePkgPath?: string, option?: ThemeOptions, apply: boolean = true, innerScreen?: boolean
  ): Promise<boolean> {
    Log.info(TAG, `activateThemeCustom called innerScreen:${innerScreen}`);
    return this.remoteCaller.request(AigcConstant.ACTIVATE_THEME_CUSTOM, themeDir, customThemePkgPath, option, apply,
      innerScreen);
  }

  public getCurrentTheme(): Promise<NullableType<ThemeInfoNew>> {
    Log.info(TAG, 'getCurrentTheme called');
    return this.remoteCaller.request(AigcConstant.GET_CURRENT_THEME);
  }

  public editTheme(editArg: EditThemeArg, innerScreen?: boolean): Promise<boolean> {
    Log.info(TAG, `editTheme called innerScreen:${innerScreen}`);
    return this.remoteCaller.request(AigcConstant.EDIT_THEME, editArg, innerScreen);
  }

  getSubScreenThemes(): Promise<SubScreenInfo[]> {
    return this.remoteCaller.request(AigcConstant.GET_SUB_SCREEN_THEMES);
  }
}