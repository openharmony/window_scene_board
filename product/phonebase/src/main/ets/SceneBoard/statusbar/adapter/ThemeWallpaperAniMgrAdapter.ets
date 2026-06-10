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
import { threadCall, ThreadCallType } from '@ohos/systemuicommon/src/main/ets/messageChannel/ThreadCall';
import lazy {
  themeWallpaperAniMgr,
  WallPaperAnimationParam
} from '@ohos/themeservice/src/main/ets/service/themeservice/ThemeWallpaperAnimationManager';

export class ThemeWallpaperAniMgrAdapter {
  @threadCall()
  public static reqPlayWallpaperAnimation(param: WallPaperAnimationParam): void | Promise<void> {
    themeWallpaperAniMgr.reqPlayWallpaperAnimation({
      curState: param.curState,
      tarState: param.tarState,
      isOffScreenSupportAod: param.isOffScreenSupportAod,
      onFinish: param.onFinish,
      isPlayingAnimation: param.isPlayingAnimation,
    });
  }
}