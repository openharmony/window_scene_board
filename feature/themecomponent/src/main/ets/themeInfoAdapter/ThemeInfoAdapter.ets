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

import {WallPaperInfo, WallPaper} from '@ohos/themeservicekit'
import { Log } from '../aigcServiceAbility/IdlService/Log';
import { RemoteCaller, TsContext } from '@ohos/themeservicebase'
import { VERSION_0, VERSION_1 } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import { TSRemoteMethod } from '@ohos/themeservice_inner_api'
import { common } from '@kit.AbilityKit';

/**
 * Ts测跨端接口版本号，手动修改分别测试不同解码器
 */
const REMOTE_VERSION: number = VERSION_0;
const TAG: string = 'ThemeInfoAdapter'

export class ThemeInfoAdapter {
  private readonly remoteCaller: RemoteCaller;

  constructor(context: common.UIAbilityContext) {
    this.remoteCaller = new RemoteCaller(context, {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'ThemeServiceAbility',
    });
  }
  public async setWallpaper( wallPaperInfo: WallPaperInfo[]): Promise<boolean> {
    Log.info(TAG, 'setWallpaper start');
    wallPaperInfo.forEach((info: WallPaperInfo) => {
      info.wallPapers.forEach((wallPaper: WallPaper) => {
        Log.info(TAG, `setWallpaper: ${wallPaper.toString()}`);
      });
    });
    let setRes: boolean = false;
    let errCode: number | undefined = undefined;
    try {
      setRes = await this.remoteCaller.request<boolean>(REMOTE_VERSION, TSRemoteMethod.SET_WALLPAPER, wallPaperInfo) as boolean
    } catch (error) {
      Log.error(TAG, `setWallpaper failed: ${error?.code}, ${error?.message}`);
      errCode = error?.code;
      setRes = false;
    }
    if (!setRes) {
      // this.showToast(errCode, uiContext);
      Log.info(TAG, `setWallpaper error：${errCode}`)
    }
    return setRes;
  }
}